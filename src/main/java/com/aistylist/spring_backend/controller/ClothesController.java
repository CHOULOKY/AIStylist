package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.domain.Clothes;
import com.aistylist.spring_backend.domain.ClothesCategory;
import com.aistylist.spring_backend.domain.ClothesColor;
import com.aistylist.spring_backend.domain.ClothesSeason;
import com.aistylist.spring_backend.domain.ClothesStyle;
import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.repository.UserRepository;
import com.aistylist.spring_backend.service.ClothesService;
import com.aistylist.spring_backend.service.FileStorageService;
import com.aistylist.spring_backend.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/clothes")
public class ClothesController {

    private final ClothesService clothesService;
    private final FileStorageService fileStorageService;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    @Autowired
    public ClothesController(ClothesService clothesService, FileStorageService fileStorageService, UserRepository userRepository, JwtUtil jwtUtil) {
        this.clothesService = clothesService;
        this.fileStorageService = fileStorageService;
        this.userRepository = userRepository;
        this.jwtUtil = jwtUtil;
    }

    // 1. 옷 등록 (이미지 업로드)
    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<?> createClothes(
            @RequestHeader("Authorization") String authHeader,
            @RequestPart("image") MultipartFile image,
            @RequestPart("category") String category,
            @RequestPart("color") String color,
            @RequestPart("season") String season,
            @RequestPart("style") String style
    ) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        String email = jwtUtil.extractEmail(token);
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(404).body("사용자를 찾을 수 없습니다.");
        }
        User user = userOpt.get();
        // enum 변환 및 예외처리
        ClothesCategory categoryEnum;
        ClothesColor colorEnum;
        ClothesSeason seasonEnum;
        ClothesStyle styleEnum;
        try {
            categoryEnum = ClothesCategory.fromDisplayName(category);
            if (categoryEnum == null) {
                return ResponseEntity.badRequest().body("카테고리 값이 올바르지 않습니다.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("카테고리 값이 올바르지 않습니다.");
        }
        try {
            colorEnum = ClothesColor.fromDisplayName(color);
            if (colorEnum == null) {
                return ResponseEntity.badRequest().body("색상 값이 올바르지 않습니다.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("색상 값이 올바르지 않습니다.");
        }
        try {
            seasonEnum = ClothesSeason.fromDisplayName(season);
            if (seasonEnum == null) {
                return ResponseEntity.badRequest().body("계절 값이 올바르지 않습니다.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("계절 값이 올바르지 않습니다.");
        }
        try {
            styleEnum = ClothesStyle.fromDisplayName(style);
            if (styleEnum == null) {
                return ResponseEntity.badRequest().body("스타일 값이 올바르지 않습니다.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("스타일 값이 올바르지 않습니다.");
        }
        // 이미지 업로드
        String imageUrl = fileStorageService.storeFile(image);
        Clothes clothes = new Clothes();
        clothes.setImageUrl(imageUrl);
        clothes.setCategory(categoryEnum);
        clothes.setColor(colorEnum);
        clothes.setSeason(seasonEnum);
        clothes.setStyle(styleEnum);
        clothes.setUserId(user.getId());
        Clothes saved = clothesService.saveClothes(clothes);
        return ResponseEntity.ok(saved);
    }

    // 2. 내 옷장 조회 (본인만)
    @GetMapping
    public ResponseEntity<?> getMyClothes(@RequestHeader("Authorization") String authHeader) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        String email = jwtUtil.extractEmail(token);
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(404).body("사용자를 찾을 수 없습니다.");
        }
        User user = userOpt.get();
        List<Clothes> myClothes = clothesService.getClothesByUserId(user.getId());
        return ResponseEntity.ok(myClothes);
    }

    // 3. 관리자 전체 옷장 조회
    @GetMapping("/admin")
    public ResponseEntity<?> getAllClothes() {
        List<Clothes> allClothes = clothesService.getAllClothes();
        return ResponseEntity.ok(allClothes);
    }
}
