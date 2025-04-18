package com.aistylist.spring_backend.service;

import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.domain.UserPreference;
import com.aistylist.spring_backend.dto.UserPreferenceRequest;
import com.aistylist.spring_backend.dto.UserPreferenceResponse;
import com.aistylist.spring_backend.repository.UserPreferenceRepository;
import com.aistylist.spring_backend.repository.UserRepository;
import com.aistylist.spring_backend.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserPreferenceService {

    @Autowired
    private UserPreferenceRepository preferenceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    public void savePreference(String token, UserPreferenceRequest request) {
        String email = jwtUtil.extractEmail(token);
        User user = userRepository.findByEmail(email).orElseThrow();

        UserPreference preference = preferenceRepository.findByUser(user)
                .orElse(new UserPreference());

        preference.setUser(user);
        preference.setPreferredStyle(request.getPreferredStyle());
        preference.setPreferredColor(request.getPreferredColor());
        preference.setAvoidStyle(request.getAvoidStyle());
        preference.setBodyType(request.getBodyType());

        preferenceRepository.save(preference);
    }

    public UserPreferenceResponse getPreference(String token) {
        String email = jwtUtil.extractEmail(token);
        User user = userRepository.findByEmail(email).orElseThrow();

        UserPreference preference = preferenceRepository.findByUser(user)
                .orElseThrow();

        return new UserPreferenceResponse(
                preference.getPreferredStyle(),
                preference.getPreferredColor(),
                preference.getAvoidStyle(),
                preference.getBodyType()
        );
    }
}
