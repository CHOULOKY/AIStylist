// src/main/java/com/aistylist/spring_backend/dto/ClothingItemDto.java
package com.aistylist.spring_backend.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothingItemDto {
    private String id;
    private String category;
    private String color;
    private String season;
    private String style;
}