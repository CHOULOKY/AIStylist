package com.aistylist.spring_backend.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TokenUtils {

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * 인증 헤더에서 토큰을 추출하고 유효성을 검사합니다.
     * @param authHeader Authorization 헤더 값
     * @return 유효한 토큰이면 토큰 문자열, 그렇지 않으면 null
     */
    public String validateToken(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        
        String token = authHeader.substring(7); // "Bearer " 제거
        
        // 토큰 유효성 검사
        if (!jwtUtil.validateToken(token)) {
            return null;
        }
        
        return token;
    }
} 