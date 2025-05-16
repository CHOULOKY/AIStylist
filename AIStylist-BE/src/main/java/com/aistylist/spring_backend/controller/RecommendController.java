// src/main/java/com/aistylist/spring_backend/controller/RecommendController.java
package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.dto.RecommendRequest;
import com.aistylist.spring_backend.dto.RecommendResponse;
import com.aistylist.spring_backend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/recommends") // API 엔드포인트 경로
@RequiredArgsConstructor
public class RecommendController {

    private final RecommendService recommendService;

    /**
     * AI 옷 추천 요청을 처리하는 API 엔드포인트
     * @param userDetails JWT 토큰에서 파싱된 사용자 정보 (Spring Security)
     * @param request 추천 요청 컨텍스트 (TPO, 날씨, 기온, 스타일)
     * @return 추천 결과 또는 에러 응답
     */
    @PostMapping
    public Mono<ResponseEntity<?>> getRecommend(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody RecommendRequest request) {

        // 1. 사용자 인증 확인 (Spring Security에서 처리하지만, 추가 확인 가능)
        if (userDetails == null) {
            log.warn("Unauthorized access attempt to /api/recommends");
            return Mono.just(ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "인증되지 않은 사용자입니다.")));
        }

        // 2. 사용자 식별자 추출 (보통 이메일)
        String userEmail = userDetails.getUsername();
        log.info("Recommend API request received for user: {}, request context: {}", userEmail, request);

        // 3. 서비스 호출하여 추천 로직 실행
        return recommendService.getRecommend(userEmail, request)
                .<ResponseEntity<?>>map(recommendResponse -> {
                    log.info("Successfully generated recommendation for user {}: {}", userEmail, recommendResponse);
                    return ResponseEntity.ok(recommendResponse); // 성공 시 200 OK 와 RecommendResponse 반환
                })
                //.cast(ResponseEntity.class) // Mono<ResponseEntity<RecommendResponse>> -> Mono<ResponseEntity<?>>
                .onErrorResume(Exception.class, e -> { // 모든 종류의 예외 처리
                    log.error("Error occurred while processing recommend request for user {}: {}", userEmail, e.getMessage(), e);
                    Map<String, String> errorBody = Map.of(
                            "error", "추천을 생성하는 중 오류가 발생했습니다.",
                            "message", e.getMessage()
                    );
                    // Mono.just 안에 ResponseEntity<?> 타입을 명시적으로 사용
                    return Mono.just(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorBody));
                });
    }
}