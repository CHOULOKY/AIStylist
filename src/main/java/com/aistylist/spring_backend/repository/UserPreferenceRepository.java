package com.aistylist.spring_backend.repository;

import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.domain.UserPreference;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserPreferenceRepository extends JpaRepository<UserPreference, Long> {
    Optional<UserPreference> findByUser(User user);
}