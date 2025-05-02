package com.aistylist.spring_backend.config;

import com.aistylist.spring_backend.filter.JwtAuthenticationFilter; // 아래에서 만들 필터 import
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import org.springframework.security.config.Customizer;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import java.util.List;


@Configuration
@EnableWebSecurity // Spring Security 활성화
@RequiredArgsConstructor
public class SecurityConfig {

    // 아래에서 만들 JwtAuthenticationFilter 주입
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    // PasswordEncoder Bean 등록 (향후 비밀번호 암호화 적용 위해 필요)
    @Bean
    public PasswordEncoder passwordEncoder() {
        // BCryptPasswordEncoder는 Spring Security에서 권장하는 암호화 방식 중 하나
        return new BCryptPasswordEncoder();
    }

    // Security Filter Chain 설정 정의
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // test code
                // Spring MVC에 정의된 CORS 규칙을 Security 필터 체인에도 적용
                .cors(Customizer.withDefaults())

                // CSRF 보호 비활성화 (Stateless JWT 사용 시 일반적으로 비활성화)
                .csrf(AbstractHttpConfigurer::disable)

                // HTTP Basic 인증 비활성화
                .httpBasic(AbstractHttpConfigurer::disable)

                // Form 기반 로그인 비활성화
                .formLogin(AbstractHttpConfigurer::disable)

                // 세션 관리 정책: STATELESS (JWT는 세션 사용 안 함)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // HTTP 요청에 대한 접근 권한 설정
                .authorizeHttpRequests(authz -> authz
                        // '/users/login', '/users/register' 경로는 인증 없이 모두 허용
                        .requestMatchers("/users/login", "/users/register").permitAll()
                        // '/recommends'로 시작하는 경로는 인증된 사용자만 허용
                        .requestMatchers("/recommends/**").permitAll()
                        // '/users/'로 시작하는 나머지 경로 (예: /users/me, /users/info)도 인증된 사용자만 허용
                        .requestMatchers("/users/**").authenticated()
                        // 위에 명시되지 않은 모든 다른 요청들도 인증된 사용자만 허용
                        .anyRequest().authenticated()
                )

                // 직접 구현한 JwtAuthenticationFilter를 Spring Security 필터 체인에 추가
                // (UsernamePasswordAuthenticationFilter보다 먼저 실행되도록 설정)
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        // 설정된 HttpSecurity 객체를 빌드하여 SecurityFilterChain 반환
        return http.build();
    }

    // test code
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of("http://localhost:57020"));
        config.setAllowedMethods(List.of("GET","POST"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
