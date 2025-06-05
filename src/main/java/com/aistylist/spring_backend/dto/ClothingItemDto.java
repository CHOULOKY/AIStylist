// src/main/java/com/aistylist/spring_backend/dto/ClothingItemDto.java
package com.aistylist.spring_backend.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothingItemDto {
    private String id;
    private String category;
    private String color;
    private List<String> seasons; // 여러 계절 등록록
    private String style;
}