package com.aistylist.spring_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothesRequest {
    private String imageUrl;
    private String category;
    private String color;
    private List<String> seasons; // 여러 계절 등록록
    private String style;
}