// src/main/java/com/aistylist/spring_backend/dto/RecommendRequest.java
package com.aistylist.spring_backend.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendRequest {
    // 클라이언트가 추천 요청 시 보내는 정보
    private String situation; // 예: "데이트"
    private String weather;   // 예: "맑음"
    private String temperature; // 예: "쌀쌀함"
    private String style;     // 예: "스트릿" (사용자가 특정 스타일 우선 요청 시)
}