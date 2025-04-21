package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
public class UserPreference {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String preferredStyle;
    private String preferredColor;
    private String avoidStyle;

    private LocalDateTime updatedDay;

    @PrePersist
    @PreUpdate
    public void onUpdate() {
        updatedDay = LocalDateTime.now();
    }
}