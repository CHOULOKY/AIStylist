package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.dto.CalendarEntryDto;
import com.aistylist.spring_backend.dto.CalendarRecommendationRequestDto;
import com.aistylist.spring_backend.repository.UserRepository;
import com.aistylist.spring_backend.service.CalendarService;
import com.aistylist.spring_backend.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/calendar")
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarService calendarService;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    private Optional<User> extractUserFromAuthHeader(String authHeader) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) return Optional.empty();
        String email = jwtUtil.extractEmail(token);
        return userRepository.findByEmail(email);
    }

    // 오늘의 추천 저장 (덮어쓰기)
    @PostMapping("/recommendations")
    public ResponseEntity<?> saveOrUpdateTodaysRecommendation(
            @RequestHeader("Authorization") String authHeader,
            @Valid @RequestBody CalendarRecommendationRequestDto requestDto) {

        Optional<User> userOpt = extractUserFromAuthHeader(authHeader);
        if (userOpt.isEmpty()) return ResponseEntity.status(401).body("유효하지 않은 사용자입니다.");

        Long userId = userOpt.get().getId();
        CalendarEntryDto savedEntry = calendarService.saveOrUpdateRecommendationForDate(
                userId, LocalDate.now(), requestDto.getRecommendationJson()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(savedEntry);
    }

    // 특정 날짜의 추천 조회
    @GetMapping("/recommendations/{date}")
    public ResponseEntity<?> getEntriesByDate(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        Optional<User> userOpt = extractUserFromAuthHeader(authHeader);
        if (userOpt.isEmpty()) return ResponseEntity.status(401).body("유효하지 않은 사용자입니다.");

        List<CalendarEntryDto> entries = calendarService.getEntriesByDate(userOpt.get().getId(), date);
        return ResponseEntity.ok(entries);
    }

    // 특정 달의 추천 조회
    @GetMapping("/recommendations")
    public ResponseEntity<?> getEntriesByMonth(
            @RequestHeader("Authorization") String authHeader,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        Optional<User> userOpt = extractUserFromAuthHeader(authHeader);
        if (userOpt.isEmpty()) return ResponseEntity.status(401).body("유효하지 않은 사용자입니다.");

        List<CalendarEntryDto> entries = calendarService.getEntriesByMonth(userOpt.get().getId(), startDate, endDate);
        return ResponseEntity.ok(entries);
    }

    // 특정 ID의 추천 수정
    @PutMapping("/recommendations/{id}")
    public ResponseEntity<?> updateRecommendation(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable Long id,
            @Valid @RequestBody CalendarRecommendationRequestDto requestDto) {

        Optional<User> userOpt = extractUserFromAuthHeader(authHeader);
        if (userOpt.isEmpty()) return ResponseEntity.status(401).body("유효하지 않은 사용자입니다.");

        CalendarEntryDto updated = calendarService.updateEntry(userOpt.get().getId(), id, requestDto.getRecommendationJson());
        return ResponseEntity.ok(updated);
    }

    // 특정 ID의 추천 삭제
    @DeleteMapping("/recommendations/{id}")
    public ResponseEntity<?> deleteRecommendation(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable Long id) {

        Optional<User> userOpt = extractUserFromAuthHeader(authHeader);
        if (userOpt.isEmpty()) return ResponseEntity.status(401).body("유효하지 않은 사용자입니다.");

        calendarService.deleteEntry(userOpt.get().getId(), id);
        return ResponseEntity.noContent().build();
    }
}