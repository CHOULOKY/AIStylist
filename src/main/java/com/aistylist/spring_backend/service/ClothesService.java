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
}
