package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Clothes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String imageUrl;
    private String category;
    private String color;
    private String season;
    private String style;

    private Long userId;

    @Column(updatable = false)
    private java.time.LocalDateTime createdDay;
}
