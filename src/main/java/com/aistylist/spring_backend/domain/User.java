package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    private String name;

    private LocalDateTime createdDay;
    private LocalDateTime updatedDay;

    @PrePersist
    protected void onCreate() {
        createdDay = LocalDateTime.now();
        updatedDay = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedDay = LocalDateTime.now();
    }
}
