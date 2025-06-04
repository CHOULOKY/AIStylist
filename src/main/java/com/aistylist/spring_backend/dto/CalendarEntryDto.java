package com.aistylist.spring_backend.dto;

import lombok.Getter;
import lombok.Setter;
import com.aistylist.spring_backend.domain.CalendarEntry;

@Getter
@Setter
public class CalendarEntryDto {
    private Long id;
    private Long userId;
    private String date;
    private String recommendation;
    private String createdAt;
    private String updatedAt;

    // Create DTO from Entity
    public static CalendarEntryDto fromEntity(CalendarEntry entity) {
        CalendarEntryDto dto = new CalendarEntryDto();
        dto.setId(entity.getId());
        dto.setUserId(entity.getUserId());
        dto.setDate(entity.getDate().toString());
        dto.setRecommendation(entity.getRecommendation());
        dto.setCreatedAt(entity.getCreatedAt().toString());
        dto.setUpdatedAt(entity.getUpdatedAt().toString());
        return dto;
    }
}
