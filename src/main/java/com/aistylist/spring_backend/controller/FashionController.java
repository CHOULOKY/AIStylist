package com.aistylist.spring_backend.controller; // 패키지 이름은 실제 프로젝트에 맞게 확인해주세요.

import com.aistylist.spring_backend.domain.Clothes;
import com.aistylist.spring_backend.service.ClothesService;
import com.aistylist.spring_backend.service.FashionApiService;
import com.aistylist.spring_backend.service.FileStorageService;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;

@RestController
@RequestMapping("/fashion")
public class FashionController {

    private static final Logger logger = LoggerFactory.getLogger(FashionController.class);
    private final FashionApiService fashionApiService;
    private final ClothesService clothesService;
    private final FileStorageService fileStorageService;

    // 고정된 person 이미지 경로
    private static final String FIXED_PERSON_IMAGE = "demo/example/person/men/model_7.png";

    public FashionController(
            FashionApiService fashionApiService,
            ClothesService clothesService,
            FileStorageService fileStorageService) {
        this.fashionApiService = fashionApiService;
        this.clothesService = clothesService;
        this.fileStorageService = fileStorageService;
    }

    @PostMapping(value = "/virtual-tryon", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> tryOn(
            @RequestParam Long upperClothesId,
            @RequestParam Long lowerClothesId) {
        try {
            // 1. 고정된 person 이미지 사용
            ClassPathResource personResource = new ClassPathResource(FIXED_PERSON_IMAGE);
            
            // 2. DB에서 의류 정보 조회 (상의, 하의만)
            Clothes upperClothes = clothesService.getClothesById(upperClothesId);
            Clothes lowerClothes = clothesService.getClothesById(lowerClothesId);

            // 3. 이미지 URL을 실제 파일 경로로 변환
            String upperImagePath = fileStorageService.getFilePath(upperClothes.getImageUrl());
            String lowerImagePath = fileStorageService.getFilePath(lowerClothes.getImageUrl());

            // 4. 가상 피팅 API 호출
            byte[] resultImage = fashionApiService.callVirtualTryonOutfitApi(
                    personResource.getFile().getAbsolutePath(),
                    upperImagePath,
                    lowerImagePath
            );

            return ResponseEntity.ok()
                    .contentType(MediaType.IMAGE_PNG)
                    .body(resultImage);

        } catch (Exception e) {
            logger.error("가상 착용 처리 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(e.getMessage().getBytes());
        }
    }

    // 테스트용 엔드포인트는 유지
    @GetMapping(value = "/test-tryon", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> testTryon() {
        try {
            ClassPathResource personResource = new ClassPathResource(FIXED_PERSON_IMAGE);
            ClassPathResource upperGarmentResource = new ClassPathResource("demo/example/condition/upper/23255574_53383833_1000.jpg");
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
            logger.error("테스트 이미지 파일을 찾을 수 없습니다.", e);
            return ResponseEntity.status(500).body(("테스트 이미지 파일을 찾을 수 없습니다: " + e.getMessage()).getBytes());
        } catch (Exception e) {
            logger.error("가상 착용 테스트 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(e.getMessage().getBytes());
        }
    }
}