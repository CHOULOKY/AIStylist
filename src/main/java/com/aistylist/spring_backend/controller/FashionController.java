package com.aistylist.spring_backend.controller; // 패키지 이름은 실제 프로젝트에 맞게 확인해주세요.

import com.aistylist.spring_backend.service.FashionApiService;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;


@RestController
public class FashionController {

    // --- 클래스 내부에 logger 변수 선언 추가 ---
    private static final Logger logger = LoggerFactory.getLogger(FashionController.class);
    // --- 여기까지 ---

    private final FashionApiService fashionApiService;

    public FashionController(FashionApiService fashionApiService) {
        this.fashionApiService = fashionApiService;
    }

    @GetMapping(value = "/test-tryon", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> testTryon() {
        try {
            // ClassPathResource를 사용하여 resources 폴더 밑의 경로를 지정합니다.
            ClassPathResource personResource = new ClassPathResource("demo/example/person/men/model_7.png");
            ClassPathResource upperGarmentResource = new ClassPathResource("demo/example/condition/upper/23255574_53383833_1000.jpg");
            // Downloads 폴더에 있던 파일도 resources 폴더로 옮기는 것이 좋습니다.
            // 예시: src/main/resources/demo/example/condition/lower/your_lower_garment.jpg
            ClassPathResource lowerGarmentResource = new ClassPathResource("demo/example/condition/lower/0e71311f-8f10-40b9-9b95-68f19b2a548c.jpg");

            byte[] resultImage = fashionApiService.callVirtualTryonOutfitApi(
                    personResource.getFile().getAbsolutePath(),
                    upperGarmentResource.getFile().getAbsolutePath(),
                    lowerGarmentResource.getFile().getAbsolutePath()
            );

            return ResponseEntity.ok()
                    .contentType(MediaType.IMAGE_PNG)
                    .body(resultImage);

        } catch (IOException e) {
            // 파일을 찾지 못했을 때의 오류 처리
            logger.error("테스트 이미지 파일을 찾을 수 없습니다.", e); // 이제 logger를 사용할 수 있습니다.
            return ResponseEntity.status(500).body(("테스트 이미지 파일을 찾을 수 없습니다: " + e.getMessage()).getBytes());
        } catch (Exception e) {
            logger.error("가상 착용 테스트 중 오류 발생", e); // 이제 logger를 사용할 수 있습니다.
            return ResponseEntity.internalServerError().body(e.getMessage().getBytes());
        }
    }
}