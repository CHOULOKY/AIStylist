package com.aistylist.spring_backend.filter;

import com.aistylist.spring_backend.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections; // Collections 임포트 추가
import java.util.List; // List 임포트 추가

@Slf4j
@Component // Spring 컨테이너가 관리하는 Bean으로 등록
@RequiredArgsConstructor // final 필드 생성자 자동 생성 (Lombok)
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    // 가지고 계신 JwtUtil 주입
    private final JwtUtil jwtUtil;

    // 모든 HTTP 요청에 대해 이 필터가 실행됨 (OncePerRequestFilter 상속)
    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,      // 들어오는 요청 객체
            @NonNull HttpServletResponse response,     // 나가는 응답 객체
            @NonNull FilterChain filterChain)         // 다음 필터를 호출하기 위한 체인 객체
            throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization"); // 요청 헤더에서 "Authorization" 값 가져오기
        final String jwt;
        final String userEmail;

        // 1. Authorization 헤더가 없거나 "Bearer "로 시작하지 않으면 토큰 검증 안 함
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response); // 그냥 다음 필터로 요청 전달
            return; // 필터 실행 종료
        }

        // 2. "Bearer " 부분을 제외하고 실제 JWT 토큰 문자열만 추출
        jwt = authHeader.substring(7);

        try {
            // 3. JwtUtil을 사용하여 토큰에서 이메일(Subject) 추출 시도
            userEmail = jwtUtil.extractEmail(jwt);

            // 4. 이메일이 추출되었고, 아직 현재 요청에 대한 인증 정보가 SecurityContext에 없는 경우
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {

                // 5. JwtUtil을 사용하여 토큰 유효성 검증 (만료 시간, 서명 등)
                if (jwtUtil.validateToken(jwt)) {

                    // --- 인증 정보 생성 ---
                    // UserDetails 객체 생성 (DB 조회 없이 토큰 정보만으로 간단히 생성)
                    // 실제 서비스에서는 DB에서 사용자 정보를 조회하여 권한 등을 설정하는 것이 좋음
                    // 여기서는 간단히 이메일을 username으로 사용하고, 기본 권한("ROLE_USER") 부여
                    UserDetails userDetails = User.builder()
                            .username(userEmail) // Spring Security 내부에서 사용될 사용자 식별자 (Principal)
                            .password("")        // JWT 사용 시 비밀번호 필드는 사실상 불필요
                            .authorities(List.of(new SimpleGrantedAuthority("ROLE_USER"))) // 사용자 권한 설정 (예시)
                            .build();

                    // UserDetails, Credentials(여기선 null), Authorities를 포함하는 Authentication 객체 생성
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails, // 인증된 사용자 정보 (Principal)
                            null,        // 인증 수단(비밀번호 등) - JWT에서는 사용 안 함
                            userDetails.getAuthorities() // 사용자 권한 목록
                    );
                    // 요청에 대한 부가 정보(IP 주소, 세션 ID 등)를 Authentication 객체에 설정
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );

                    // --- SecurityContext에 인증 정보 등록 ---
                    // SecurityContextHolder에 위에서 생성한 Authentication 객체를 설정
                    // 이제 이 요청은 Spring Security에 의해 "인증된" 상태로 간주됨
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    log.debug("Authentication successful for user: {}", userEmail);

                } else {
                    // 토큰 유효성 검증 실패 시 로그
                    log.warn("Invalid JWT token received for user: {}", userEmail);
                }
            }
        } catch (Exception e) {
            // 토큰 처리(추출, 검증 등) 중 예외 발생 시 로그
            log.error("Error processing JWT token: {}", e.getMessage());
            // 필요하다면 여기서 SecurityContext를 초기화할 수도 있음
            // SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }
}