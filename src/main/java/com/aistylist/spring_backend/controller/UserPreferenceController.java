package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.dto.UserPreferenceRequest;
import com.aistylist.spring_backend.dto.UserPreferenceResponse;
import com.aistylist.spring_backend.service.UserPreferenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/preferences")
public class UserPreferenceController {

    @Autowired
    private UserPreferenceService preferenceService;

    // POST /users/preferences
    @PostMapping
    public ResponseEntity<?> savePreference(@RequestHeader("Authorization") String authHeader,
                                            @RequestBody UserPreferenceRequest request) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(401).body("토큰이 없습니다.");
        }

        String token = authHeader.substring(7);
        preferenceService.savePreference(token, request);
        return ResponseEntity.ok("사용자 선호 정보 저장 완료");
    }

    // GET /users/preferences
    @GetMapping
    public ResponseEntity<?> getPreference(@RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(401).body("토큰이 없습니다.");
        }

        String token = authHeader.substring(7);
        UserPreferenceResponse response = preferenceService.getPreference(token);
        return ResponseEntity.ok(response);
    }
}
