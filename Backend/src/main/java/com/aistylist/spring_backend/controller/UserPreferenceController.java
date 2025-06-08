package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.dto.UserPreferenceRequest;
import com.aistylist.spring_backend.dto.UserPreferenceResponse;
import com.aistylist.spring_backend.service.UserPreferenceService;
import com.aistylist.spring_backend.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/preferences")
public class UserPreferenceController {

    @Autowired
    private UserPreferenceService preferenceService;

    @Autowired
    private JwtUtil jwtUtil;

    // POST /users/preferences
    @PostMapping
    public ResponseEntity<?> savePreference(@RequestHeader("Authorization") String authHeader,
                                            @RequestBody UserPreferenceRequest request) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        preferenceService.savePreference(token, request);
        return ResponseEntity.ok("사용자 선호 정보 저장 완료");
    }

    // GET /users/preferences
    @GetMapping
    public ResponseEntity<?> getPreference(@RequestHeader("Authorization") String authHeader) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        UserPreferenceResponse response = preferenceService.getPreference(token);
        return ResponseEntity.ok(response);
    }
}
