package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.*;
import com.aistylist.spring_backend.domain.ClothesCategory;
import com.aistylist.spring_backend.domain.ClothesColor;
import com.aistylist.spring_backend.domain.ClothesSeason;
import com.aistylist.spring_backend.domain.ClothesStyle;

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
    @Enumerated(EnumType.STRING)
    private ClothesCategory category;
    @Enumerated(EnumType.STRING)
    private ClothesColor color;
    @Enumerated(EnumType.STRING)
    private ClothesSeason season;
    @Enumerated(EnumType.STRING)
    private ClothesStyle style;

    private Long userId;

    @Column(updatable = false)
    private java.time.LocalDateTime createdDay;
}
