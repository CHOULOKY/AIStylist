package com.aistylist.spring_backend.repository;

import com.aistylist.spring_backend.domain.CalendarEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional; // Optional 임포트 추가

@Repository
public interface CalendarEntryRepository extends JpaRepository<CalendarEntry, Long> {
    // 변경: 반환 타입을 List<CalendarEntry>에서 Optional<CalendarEntry>로 수정
    Optional<CalendarEntry> findByUserIdAndDate(Long userId, LocalDate date);
    List<CalendarEntry> findByUserIdAndDateBetween(Long userId, LocalDate startDate, LocalDate endDate);
}