package com.aistylist.spring_backend.service;

import com.aistylist.spring_backend.domain.Clothes;
import com.aistylist.spring_backend.repository.ClothesRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClothesService {

    private final ClothesRepository clothesRepository;

    public ClothesService(ClothesRepository clothesRepository) {
        this.clothesRepository = clothesRepository;
    }

    public List<Clothes> getAllClothes() {
        return clothesRepository.findAll();
    }

    public Clothes saveClothes(Clothes clothes) {
        clothes.setCreatedDay(java.time.LocalDateTime.now());
        return clothesRepository.save(clothes);
    }

    public List<Clothes> getClothesByUserId(Long userId) {
        return clothesRepository.findByUserId(userId);
    }

    /**
     * ID로 의류 정보를 조회합니다.
     * @param id 의류 ID
     * @return 조회된 의류 정보
     * @throws RuntimeException 의류를 찾을 수 없는 경우
     */
    public Clothes getClothesById(Long id) {
        return clothesRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("의류를 찾을 수 없습니다: " + id));
    }
}
