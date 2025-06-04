package com.aistylist.spring_backend.service;

import com.aistylist.spring_backend.domain.CalendarEntry;
import com.aistylist.spring_backend.dto.CalendarEntryDto;
import com.aistylist.spring_backend.repository.CalendarEntryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional; // 추가
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CalendarService {

    private final CalendarEntryRepository calendarEntryRepository;

    @Transactional
    // 변경: 메서드 이름 및 로직 수정 (덮어쓰기 기능 구현)
    public CalendarEntryDto saveOrUpdateRecommendationForDate(Long userId, LocalDate date, String recommendationJson) {
        Optional<CalendarEntry> existingEntryOpt = calendarEntryRepository.findByUserIdAndDate(userId, date);

        CalendarEntry entryToSave;
        if (existingEntryOpt.isPresent()) {
            // Entry exists, update it
            entryToSave = existingEntryOpt.get();
            entryToSave.setRecommendation(recommendationJson);
            // @PreUpdate in CalendarEntry entity will handle updatedAt
        } else {
            // No entry, create a new one
            entryToSave = new CalendarEntry();
            entryToSave.setUserId(userId);
            entryToSave.setDate(date);
            entryToSave.setRecommendation(recommendationJson);
            // @PrePersist in CalendarEntry entity will handle createdAt and updatedAt
        }
        CalendarEntry savedEntry = calendarEntryRepository.save(entryToSave);
        return CalendarEntryDto.fromEntity(savedEntry);
    }

    @Transactional(readOnly = true)
    // 변경: Repository 변경에 따른 로직 수정
    public List<CalendarEntryDto> getEntriesByDate(Long userId, LocalDate date) {
        Optional<CalendarEntry> entryOpt = calendarEntryRepository.findByUserIdAndDate(userId, date);
        return entryOpt.map(CalendarEntryDto::fromEntity)
                       .map(List::of) // If entry is present, convert DTO to List<DTO>
                       .orElseGet(List::of); // Otherwise, return an empty list
    }

    @Transactional(readOnly = true)
    public List<CalendarEntryDto> getEntriesByMonth(Long userId, LocalDate startDate, LocalDate endDate) {
        List<CalendarEntry> entries = calendarEntryRepository.findByUserIdAndDateBetween(userId, startDate, endDate);
        return entries.stream()
                .map(CalendarEntryDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public CalendarEntryDto updateEntry(Long userId, Long id, String recommendation) { // 변경: 반환타입 CalendarEntryDto로 변경
        CalendarEntry entry = calendarEntryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Calendar entry not found with id: " + id));
        
        if (!entry.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized access to update calendar entry with id: " + id);
        }
        
        entry.setRecommendation(recommendation);
        CalendarEntry updatedEntry = calendarEntryRepository.save(entry);
        return CalendarEntryDto.fromEntity(updatedEntry); // 변경: 업데이트된 엔티티 반환
    }

    // 추가: 삭제 메서드
    @Transactional
    public void deleteEntry(Long userId, Long entryId) {
        CalendarEntry entry = calendarEntryRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Calendar entry not found with id: " + entryId));

        if (!entry.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized access to delete calendar entry with id: " + entryId);
        }
        calendarEntryRepository.delete(entry);
    }
}
