package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.domain.Clothes;
import com.aistylist.spring_backend.service.ClothesService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/clothes")
public class ClothesController {

    private final ClothesService clothesService;

    public ClothesController(ClothesService clothesService) {
        this.clothesService = clothesService;
    }

    @GetMapping
    public List<Clothes> getAllClothes() {
        return clothesService.getAllClothes();
    }

    @PostMapping
    public Clothes createClothes(@RequestBody Clothes clothes) {
        return clothesService.saveClothes(clothes);
    }
}
