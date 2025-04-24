// src/main/java/com/aistylist/spring_backend/service/RecommendService.java
package com.aistylist.spring_backend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.aistylist.spring_backend.dto.ClothingItemDto;
import com.aistylist.spring_backend.dto.RecommendRequest;
import com.aistylist.spring_backend.dto.RecommendResponse;
import com.aistylist.spring_backend.domain.Clothes;
import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.domain.UserPreference;
import com.aistylist.spring_backend.repository.ClothesRepository;
import com.aistylist.spring_backend.repository.UserPreferenceRepository;
import com.aistylist.spring_backend.repository.UserRepository;
// import com.aistylist.spring_backend.exception.ResourceNotFoundException; // 커스텀 예외 사용 시
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class RecommendService {

    // 의존성 주입
    private final WebClient.Builder webClientBuilder;
    private final ObjectMapper objectMapper;
    private final UserRepository userRepository;
    private final UserPreferenceRepository userPreferenceRepository;
    private final ClothesRepository clothesRepository;

    // OpenAI API Key (application.properties 또는 환경변수)
    @Value("${openai.api.key}")
    private String openaiApiKey;

    // OpenAI API Endpoint URL
    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    /**
     * 사용자의 정보와 요청 컨텍스트를 기반으로 옷 추천을 생성합니다.
     * @param userEmail 추천을 받을 사용자의 이메일 (JWT 토큰에서 추출)
     * @param request 추천 요청 컨텍스트 (TPO, 날씨, 기온, 스타일)
     * @return 추천 결과 Mono<RecommendResponse>
     */
    public Mono<RecommendResponse> getRecommend(String userEmail, RecommendRequest request) {

        // 1. 사용자 조회
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + userEmail));

        // 2. 사용자 선호 정보 조회
        Optional<UserPreference> userPreferenceOpt = userPreferenceRepository.findByUser(user);

        // 3. 사용자 옷장 조회
        List<Clothes> wardrobeEntityList = clothesRepository.findByUserId(user.getId());
        if (wardrobeEntityList.isEmpty()) {
            log.warn("User {}'s wardrobe is empty. Cannot generate recommendation.", userEmail);
            return Mono.error(new RuntimeException("옷장에 등록된 옷이 없습니다."));
        }

        // 4. 옷장 Entity -> DTO 변환
        List<ClothingItemDto> wardrobeDtoList = wardrobeEntityList.stream()
                .map(this::mapToClothingItemDto)
                .collect(Collectors.toList());

        // 5. OpenAI 프롬프트 생성
        String prompt = buildPrompt(request, user, userPreferenceOpt.orElse(null), wardrobeDtoList);
        log.debug("Generated Prompt for OpenAI API for user {}: {}", userEmail, prompt);

        // 6. OpenAI API 호출 설정
        WebClient webClient = webClientBuilder.baseUrl(OPENAI_API_URL)
                .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + openaiApiKey)
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .build();

        // 7. OpenAI 요청 본문 생성
        Map<String, Object> requestBody = new HashMap<>();

        requestBody.put("model", "gpt-4o-mini");
        requestBody.put("messages", List.of(
                Map.of("role", "system", "content", "당신은 패션 전문가입니다. 주어진 사용자 정보, 옷장, 상황에 맞춰 옷을 추천하고, 요청된 JSON 형식으로만 응답해주세요."),
                Map.of("role", "user", "content", prompt)
        ));
        requestBody.put("temperature", 0.7);
        requestBody.put("response_format", Map.of("type", "json_object"));

        // 8. API 호출 및 응답 처리
        return webClient.post()
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(String.class)
                .flatMap(this::parseOpenAIResponse)
                .doOnError(error -> log.error("Error during OpenAI API call or processing for user {}: {}", userEmail, error.getMessage()));
    }

    /**
     * Clothes 엔티티를 ClothingItemDto로 변환합니다.
     * (Clothes 엔티티 필드에 맞게 조정 필요)
     */
    private ClothingItemDto mapToClothingItemDto(Clothes clothes) {
        return new ClothingItemDto(
                String.valueOf(clothes.getId()),
                clothes.getCategory(),
                clothes.getColor(),
                clothes.getSeason(),
                clothes.getStyle()
        );
    }

    /**
     * OpenAI API에 전달할 프롬프트를 생성합니다.
     */
    private String buildPrompt(RecommendRequest contextRequest, User user, UserPreference preference, List<ClothingItemDto> wardrobe) {
        // 사용자 기본 설명 (User 엔티티 필드에 따라 수정)
        String userDescription = String.format("성별: %s, 이름: %s",
                "정보 없음", // user.getGender() 등 사용 가능
                user.getName() != null ? user.getName() : "정보 없음"
        );
        // User 객체에 bodyType 필드가 있는지 확인 (User.java 확인 결과: 있음)
        if (user.getBodyType() != null) { // **** 수정: user에서 getBodyType() 호출 및 null 체크 ****
            userDescription += String.format(", 체형: %s", user.getBodyType()); // **** 수정: user에서 getBodyType() 호출 ****
        }

        // 사용자 선호/비선호 정보
        StringBuilder preferenceDetails = new StringBuilder();
        if (preference != null) {
            if (preference.getPreferredStyle() != null) preferenceDetails.append(String.format("- 선호 스타일: %s\n", preference.getPreferredStyle()));
            if (preference.getPreferredColor() != null) preferenceDetails.append(String.format("- 선호 색상: %s\n", preference.getPreferredColor()));
            if (preference.getAvoidStyle() != null) preferenceDetails.append(String.format("- 비선호 스타일: %s\n", preference.getAvoidStyle()));
        }

        // 옷장 정보 JSON 문자열 변환
        String wardrobeJson;
        try {
            List<Map<String, String>> simplifiedWardrobe = wardrobe.stream()
                    .map(item -> {
                        Map<String, String> map = new HashMap<>();
                        map.put("id", item.getId());
                        if (item.getCategory() != null) map.put("category", item.getCategory());
                        if (item.getColor() != null) map.put("color", item.getColor());
                        if (item.getSeason() != null) map.put("season", item.getSeason()); // **** 수정 ****
                        if (item.getStyle() != null) map.put("style", item.getStyle());   // **** 수정 ****
                        return map;
                    })
                    .collect(Collectors.toList());
            wardrobeJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(simplifiedWardrobe);
        } catch (JsonProcessingException e) {
            log.error("Error converting wardrobe DTO list to JSON string for user {}: {}", user.getEmail(), e.getMessage());
            wardrobeJson = "[{\"error\": \"옷장 정보 변환 오류\"}]";
        }

        // 최종 프롬프트 템플릿
        return String.format(
                "다음 정보를 바탕으로 사용자에게 가장 적합한 오늘의 코디(상의, 하의, 아우터)를 추천해주세요.\n\n" +
                        "--- 사용자 정보 ---\n" +
                        "%s\n" + // 사용자 기본 설명
                        "%s\n" + // 사용자 선호/비선호 정보
                        "--- 요청 상황 ---\n" +
                        "- 상황(TPO): %s\n" +
                        "- 날씨: %s\n" +
                        "- 기온: %s\n" +
                        "- 희망 스타일: %s\n\n" +
                        "--- 사용자의 옷장 ---\n" +
                        "%s\n\n" +
                        "--- 중요 요구사항 ---\n" +
                        "1. 옷장 목록에서 상의(top), 하의(bottom), 아우터(outer)를 각각 1개씩 선택하여 ID로 반환해주세요.\n" +
                        "2. 아우터는 날씨나 스타일에 따라 필요 없으면 값으로 `null`을 포함시켜주세요 (따옴표 없이).\n" +
                        "3. 사용자의 선호/비선호 스타일, 체형, 요청 상황(TPO, 날씨, 기온, 희망 스타일)을 종합적으로 고려해주세요.\n" +
                        "4. 추천 이유를 'reason' 키 값으로 간결하고 명확하게 설명해주세요.\n" +
                        "5. 반드시 아래 명시된 JSON 형식으로만 응답해야 합니다. 다른 설명이나 텍스트는 절대 포함하지 마세요.\n" +
                        "```json\n" +
                        "{\n" +
                        "  \"top\": \"<추천 상의 ID>\",\n" +
                        "  \"bottom\": \"<추천 하의 ID>\",\n" +
                        "  \"outer\": <추천 아우터 ID 또는 null>,\n" +
                        "  \"reason\": \"<추천 이유 요약>\"\n" +
                        "}\n" +
                        "```",
                userDescription,
                preferenceDetails.toString(),
                contextRequest.getSituation(),
                contextRequest.getWeather(),
                contextRequest.getTemperature(),
                contextRequest.getStyle() != null ? contextRequest.getStyle() : "특별히 없음",
                wardrobeJson
        );
    }

    /**
     * OpenAI API 응답(문자열)을 파싱하여 RecommendResponse 객체로 변환합니다.
     */
    private Mono<RecommendResponse> parseOpenAIResponse(String responseBody) {
        log.debug("Raw OpenAI Response body: {}", responseBody);
        try {
            // OpenAI 응답 구조에서 실제 content 추출
            Map<String, Object> responseMap = objectMapper.readValue(responseBody, Map.class);
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseMap.get("choices");

            if (choices == null || choices.isEmpty()) {
                log.error("OpenAI response 'choices' field is missing or empty. Response: {}", responseBody);
                return Mono.error(new RuntimeException("OpenAI 응답 형식이 잘못되었습니다 (choices 없음)."));
            }

            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            if (message == null || message.get("content") == null) {
                log.error("OpenAI response 'message' or 'content' field is missing. Response: {}", responseBody);
                return Mono.error(new RuntimeException("OpenAI 응답 형식이 잘못되었습니다 (content 없음)."));
            }

            String content = ((String) message.get("content")).trim();
            log.debug("Extracted content from OpenAI response: {}", content);

            // ```json 마크다운 블록 제거 (만약을 대비)
            if (content.startsWith("```json")) {
                content = content.substring(7, content.length() - 3).trim();
            } else if (content.startsWith("```")) {
                content = content.substring(3, content.length() - 3).trim();
            }

            // content(JSON 문자열)를 RecommendResponse 객체로 변환
            RecommendResponse recommendResponse = objectMapper.readValue(content, RecommendResponse.class);
            log.info("Successfully parsed OpenAI content into RecommendResponse: {}", recommendResponse);
            return Mono.just(recommendResponse);

        } catch (JsonProcessingException e) {
            log.error("Failed to parse JSON from OpenAI response content. Content: '{}', Error: {}", responseBody, e.getMessage());
            // AI가 JSON 형식을 제대로 지키지 않았을 가능성 높음
            return Mono.error(new RuntimeException("OpenAI 응답을 파싱하는 중 오류가 발생했습니다. 응답 형식을 확인해주세요.", e));
        } catch (Exception e) {
            log.error("Unexpected error occurred while processing OpenAI response. Response: {}, Error: {}", responseBody, e.getMessage(), e);
            return Mono.error(new RuntimeException("OpenAI 응답 처리 중 예기치 않은 오류가 발생했습니다.", e));
        }
    }
}