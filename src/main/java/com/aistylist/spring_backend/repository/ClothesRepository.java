package com.aistylist.spring_backend.repository;

import com.aistylist.spring_backend.domain.Clothes;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClothesRepository extends JpaRepository<Clothes, Long> {
}
