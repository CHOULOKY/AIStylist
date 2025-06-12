package com.aistylist.spring_backend.repository;

import com.aistylist.spring_backend.domain.Clothes;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface    ClothesRepository extends JpaRepository<Clothes, Long> {
    List<Clothes> findByUserId(Long userId);
}
