package com.aistylist.spring_backend.service;

import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.dto.UserInfoRequest;
import com.aistylist.spring_backend.dto.UserInfoResponse;
import com.aistylist.spring_backend.repository.UserRepository;
import com.aistylist.spring_backend.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    public User login(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));

        if (!user.getPassword().equals(password)) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        return user;
    }

    public User register(User user) {
        return userRepository.save(user);
    }

    // 사용자 정보 저장/수정
    public void saveUserInfo(String token, UserInfoRequest request) {
        String email = jwtUtil.extractEmail(token);
        User user = userRepository.findByEmail(email).orElseThrow();

        user.setName(request.getName());
        user.setHeight(request.getHeight());
        if (request.getBodyType() == null) {
            throw new IllegalArgumentException("bodyType 값이 올바르지 않습니다.");
        }
        user.setBodyType(request.getBodyType());

        userRepository.save(user);
    }

    // 사용자 정보 조회
    public UserInfoResponse getUserInfo(String token) {
        String email = jwtUtil.extractEmail(token);
        User user = userRepository.findByEmail(email).orElseThrow();

        return new UserInfoResponse(
                user.getName(),
                user.getHeight(),
                user.getBodyType()
        );
    }
}