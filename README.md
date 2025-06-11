# AIStylist
**AIStylist**는 사용자 맞춤형 스타일을 제안하고, 가상 피팅 및 일정 저장까지 제공하는 AI 기반 패션 추천 플랫폼입니다.

## 1. 프로젝트 개요 (Project Overview)

AIStylist는 다음 기능을 제공합니다:

- 날씨 및 사용자의 보유 옷 기반 스타일 추천
- AI 모델 기반 가상 착장 이미지 생성
- 착장 결과를 캘린더에 스케줄로 저장
- 회원가입 및 인증 처리 (JWT 기반)

---

## 2. 아키텍처 & 기술 스택 (Architecture & Tech Stack)

### 서비스별 MSA 구성

| 서비스 이름                | 주요 역할                      | 독립 DB | 외부 연계                       | 비고                                  |
|--------------------------|-------------------------------|--------|-------------------------------|---------------------------------------|
| Authentication Service  | 사용자 인증, 토큰 발급          | O      | Registration                  | JWT 발급 및 검증                      |
| Registration Service     | 회원가입, 계정 생성             | O      | Authentication                | 회원가입 완료 시 이벤트 전파         |
| Closet Service           | 옷 아이템 CRUD                 | O      | Recommendation, Calendar      | 이미지 기반 태깅 기능 포함            |
| Calendar Service         | 착장 스케줄 관리               | O      | Closet                        | 착장 기반 일정 저장                  |
| Virtual Fitting Service  | AI 기반 가상 피팅               | X      | Closet                        | Diffusion 모델 연동, 임시 이미지 캐시 |
| Recommendation Service   | 날씨 기반 스타일 추천           | O      | Closet, 외부 날씨 API         | 외부 날씨 API 호출 포함               |

### 주요 기술 스택

- **Backend**: Python (FastAPI, Flask), Node.js (일부 서비스), Spring Boot
- **Frontend**: Flutter (Android Studio 기반 개발)
- **AI 모델**: Stable Diffusion, Custom ML Pipelines
- **DB**: PostgreSQL (서비스별 분리)
- **API 연동**: RESTful API, JWT 인증
- **DevOps**: Docker, Docker Compose, GitHub Actions

---

## 3. 설치 및 실행 방법 (Getting Started)

### 사전 요구사항

- Docker & Docker Compose 설치
- Python 3.10+ / Flutter SDK (Frontend 실행 시)

### 클론 및 실행

```bash
git clone https://github.com/CHOULOKY/AIStylist.git
cd AIStylist
docker-compose up --build
```

---

## 4. 환경 변수 & 설정 (Configuration)

각 서비스는 자체 `.env` 파일을 사용하며, 다음과 같은 환경 변수를 설정해야 합니다:

### Authentication Service
- `JWT_SECRET`: JWT 서명용 시크릿 키
- `JWT_EXPIRATION`: 토큰 만료 시간(초)

### Recommendation Service
- `WEATHER_API_KEY`: 외부 날씨 API 키 (예: OpenWeatherMap)

`.env.example` 파일을 각 서비스 폴더에 포함해 참고용으로 제공합니다.

---

## 5. API 문서 (API Reference)

모든 서비스는 자체적으로 Swagger 또는 FastAPI의 `/docs` 엔드포인트를 통해 API 명세를 제공합니다. Docker로 실행한 후 브라우저에서 각 서비스에 접속하여 확인할 수 있습니다.

| 서비스 이름              | 문서 주소                      |
|-------------------------|-------------------------------|
| Authentication Service | `http://localhost:8001/docs` |
| Registration Service   | `http://localhost:8002/docs` |
| Closet Service         | `http://localhost:8003/docs` |
| Calendar Service       | `http://localhost:8004/docs` |
| Recommendation Service | `http://localhost:8005/docs` |
| Virtual Fitting Service| `http://localhost:8006/docs` |

---

## 6. 팀원 및 기여자 (Contributors)

- **박근하**
  - 아이디어 제공
  - DB 설계 및 구현
  - 백엔드 CRUD 설계 및 구현
  - Flutter 구현

- **배서진**  
  - 
  - 
  
- **박인희**  
  - 
  - 

- **이기환**  
  - 
  - 

---

## 7. 라이선스 (License)


