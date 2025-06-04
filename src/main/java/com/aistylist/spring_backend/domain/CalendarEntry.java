package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime; // 변경: LocalDateTime 사용
import java.util.Objects;

@Entity
@Getter
@Setter
// 변경: uniqueConstraints 추가
@Table(name = "calendar_entries", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "date"})
})
public class CalendarEntry {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Lob // 추가: JSON 문자열이 길 수 있으므로 @Lob 추천
    @Column(name = "recommendation", columnDefinition = "TEXT", nullable = false)
    private String recommendation;

    @Column(name = "created_at", nullable = false, updatable = false) // 변경: nullable = false, updatable = false 추가
    private LocalDateTime createdAt; // 변경: LocalDateTime

    @Column(name = "updated_at", nullable = false) // 변경: nullable = false 추가
    private LocalDateTime updatedAt; // 변경: LocalDateTime

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now(); // 변경: LocalDateTime.now()
        updatedAt = LocalDateTime.now(); // 변경: LocalDateTime.now()
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now(); // 변경: LocalDateTime.now()
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CalendarEntry that = (CalendarEntry) o;
        // userId와 date가 모두 non-null이라고 가정. 실제로는 null 체크 필요할 수 있음
        // 현재 엔티티 정의상 userId와 date는 nullable=false 이므로 Objects.equals로 충분
        return Objects.equals(userId, that.userId) && Objects.equals(date, that.date);
    }

    @Override
    public int hashCode() {
         // 현재 엔티티 정의상 userId와 date는 nullable=false 이므로 Objects.hash로 충분
        return Objects.hash(userId, date);
    }
}
