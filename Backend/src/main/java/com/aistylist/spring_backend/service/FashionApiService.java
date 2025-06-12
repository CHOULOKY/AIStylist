package com.aistylist.spring_backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import java.time.Duration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import reactor.netty.http.client.HttpClient;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@Service
public class FashionApiService {

    private static final Logger logger = LoggerFactory.getLogger(FashionApiService.class);
    private final WebClient webClient;

    // application.properties에서 API URL 주입
    public FashionApiService(WebClient.Builder webClientBuilder, @Value("${fashion.api.url}") String apiUrl) {
        // 1. 응답 바디의 크기 제한을 늘리기 위한 ExchangeStrategies 설정
        ExchangeStrategies exchangeStrategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer
                        .defaultCodecs()
                        .maxInMemorySize(10 * 1024 * 1024)) // 최대 버퍼 사이즈를 10MB로 설정 (이미지 크기에 맞게 조절 가능)
                .build();

        // 2. 타임아웃 설정을 위한 HttpClient 구성
        HttpClient httpClient = HttpClient.create()
                .responseTimeout(Duration.ofMinutes(5)); // 응답 타임아웃을 60분으로 설정

        // 3. 위 설정들을 적용하여 WebClient 빌드
        this.webClient = webClientBuilder
                .baseUrl(apiUrl)
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .exchangeStrategies(exchangeStrategies) // 설정한 ExchangeStrategies 적용
                .build();
    }

    /**
     * 상/하의 전체 가상 착용 API를 호출하는 메서드
     *
     * @param personImagePath    사람 이미지 파일 경로
     * @param upperGarmentPath   상의 이미지 파일 경로
     * @param lowerGarmentPath   하의 이미지 파일 경로
     * @return 생성된 이미지의 byte 배열
     */
    public byte[] callVirtualTryonOutfitApi(String personImagePath, String upperGarmentPath, String lowerGarmentPath) {
        // MultipartBodyBuilder를 사용하여 multipart/form-data 요청 본문 생성
        MultipartBodyBuilder builder = new MultipartBodyBuilder();

        // 1. 파일 파트 추가
        builder.part("person_image_file", new FileSystemResource(personImagePath));
        builder.part("upper_garment_file", new FileSystemResource(upperGarmentPath));
        builder.part("lower_garment_file", new FileSystemResource(lowerGarmentPath));

        // 2. 폼 데이터 파트 추가 (필요 시)
        // FastAPI 엔드포인트의 기본값을 사용하므로 여기서는 생략합니다.
        // 만약 값을 변경하고 싶다면 아래와 같이 추가할 수 있습니다.
        builder.part("num_inference_steps", "30");
        builder.part("guidance_scale", "2.5");
        builder.part("seed", "42");

        try {
            // WebClient를 사용하여 API 호출 (이 부분은 동일)
            byte[] resultImage = webClient.post()
                    .uri("/virtual-tryon-outfit/")
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(BodyInserters.fromMultipartData(builder.build()))
                    .retrieve()
                    .bodyToMono(byte[].class)
                    .block();

            logger.info("FastAPI로부터 성공적으로 이미지를 수신했습니다.");
            return resultImage;

            // --- 아래 catch 블록을 교체해주세요 ---
        } catch (WebClientResponseException e) {
            // 이 블록은 4xx, 5xx 같은 HTTP 오류 상태일 때 실행됩니다.
            logger.error("### WebClientResponseException 발생! ###");
            logger.error("API 호출 실패: Status {}, Headers: {}", e.getRawStatusCode(), e.getHeaders());
            logger.error("Response Body: {}", e.getResponseBodyAsString());
            // 이 예외의 전체 스택 트레이스를 로그로 남깁니다.
            logger.error("Stack Trace:", e);
            throw new RuntimeException("가상 착용 API 호출에 실패했습니다 (HTTP 오류): " + e.getResponseBodyAsString(), e);

        } catch (Exception e) {
            // Status 200인데도 문제가 생겼다면 아마 이 블록이 실행될 것입니다.
            // (예: 응답 본문 디코딩 문제 등)
            logger.error("### 일반 Exception 발생! ###");
            logger.error("API 호출 중 예상치 못한 오류 발생. Exception Type: {}", e.getClass().getName());
            logger.error("Error Message: {}", e.getMessage());
            // 이 예외의 전체 스택 트레이스를 로그로 남깁니다.
            logger.error("Stack Trace:", e);
            throw new RuntimeException("가상 착용 API 호출 중 오류가 발생했습니다.", e);
        }
    }
}