// src/main/java/com/aistylist/spring_backend/dto/RecommendResponse.java
package com.aistylist.spring_backend.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendResponse {
    // AI가 추천한 결과
    private String top;    // 추천 상의 ID
    private String bottom; // 추천 하의 ID
    private String outer;  // 추천 아우터 ID (없으면 null)
    private String reason; // 추천 이유
}