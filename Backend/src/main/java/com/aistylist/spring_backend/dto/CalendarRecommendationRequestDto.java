package com.aistylist.spring_backend.dto;

import lombok.Getter;
import lombok.Setter;
import jakarta.validation.constraints.NotBlank; // 유효성 검사 추가

@Getter
@Setter
public class CalendarRecommendationRequestDto {

    @NotBlank(message = "Recommendation JSON cannot be blank") // 추천 JSON은 비어있을 수 없음
    private String recommendationJson; // GPT API 응답 JSON
}
