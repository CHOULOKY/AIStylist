package com.aistylist.spring_backend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.Set;
import java.util.HashSet;

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

    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "clothes_season", joinColumns = @JoinColumn(name = "clothes_id"))
    @Column(name = "season")
    @Builder.Default
    private Set<ClothesSeason> seasons = new HashSet<>();

    @Enumerated(EnumType.STRING)
    private ClothesStyle style;

    private Long userId;

    @Column(updatable = false)
    private java.time.LocalDateTime createdDay;
}
