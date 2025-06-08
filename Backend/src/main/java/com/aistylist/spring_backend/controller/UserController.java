package com.aistylist.spring_backend.controller;

import com.aistylist.spring_backend.domain.User;
import com.aistylist.spring_backend.dto.UserInfoRequest;
import com.aistylist.spring_backend.dto.UserInfoResponse;
import com.aistylist.spring_backend.dto.UserLoginRequest;
import com.aistylist.spring_backend.dto.UserRegisterRequest;
import com.aistylist.spring_backend.repository.UserRepository;
import com.aistylist.spring_backend.service.UserService;
import com.aistylist.spring_backend.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserLoginRequest request) {
        Optional<User> userOpt = userRepository.findByEmail(request.getEmail());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("존재하지 않는 사용자입니다.");
        }

        User user = userOpt.get();

        if (!user.getPassword().equals(request.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("비밀번호가 일치하지 않습니다.");
        }

        String token = jwtUtil.generateToken(user.getEmail());

        // 토큰을 포함한 JSON 객체 반환
        Map<String, String> response = new HashMap<>();
        response.put("message", "로그인 성공");
        response.put("token", token);

        return ResponseEntity.ok(response);
    }


    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody UserRegisterRequest request) {
        // 이메일 중복 체크
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body("이미 등록된 이메일입니다.");
        }

        // 새 유저 생성
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(request.getPassword());
        user.setName(request.getName());

        userRepository.save(user);
        return ResponseEntity.ok("회원가입 성공");
    }

    @GetMapping("/me")
    public ResponseEntity<?> getMyInfo(@RequestHeader("Authorization") String authHeader) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("유효하지 않은 토큰입니다.");
        }
        String email = jwtUtil.extractEmail(token);
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사용자를 찾을 수 없습니다.");
        }
        User user = userOpt.get();
        Map<String, Object> response = new HashMap<>();
        response.put("email", user.getEmail());
        response.put("name", user.getName());
        return ResponseEntity.ok(response);
    }

    // 사용자 정보 저장 또는 수정
    @PostMapping("/info")
    public ResponseEntity<?> saveUserInfo(@RequestHeader("Authorization") String authHeader,
                                          @RequestBody UserInfoRequest request) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        userService.saveUserInfo(token, request);
        return ResponseEntity.ok("사용자 정보 저장 완료");
    }

    // 사용자 정보 조회
    @GetMapping("/info")
    public ResponseEntity<?> getUserInfo(@RequestHeader("Authorization") String authHeader) {
        String token = jwtUtil.extractValidToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
        }
        UserInfoResponse response = userService.getUserInfo(token);
        return ResponseEntity.ok(response);
    }
}