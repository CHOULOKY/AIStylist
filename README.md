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
- https://github.com/L4HO/virtual-tryon-api 트레이스

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

서비스는 FastAPI의 `/docs` 엔드포인트를 통해 API 명세를 제공합니다. Docker로 실행한 후 브라우저에서 서비스에 접속하여 확인할 수 있습니다.

| Virtual Fitting Service| `http://localhost:8000/docs` |

---

## 6. 팀원 및 기여자 (Contributors)

- **박근하**
  - 아이디어 제공
  - DB 설계 및 구현
  - 백엔드 CRUD 설계 및 구현
  - Flutter 구현

- **배서진**  
  - UI 디자인
  - 
  
- **박인희**  
  - 전반적인 Flutter (프론트엔드) 구현
  - 

- **이기환**  
  - 가상 피팅 구현
  - AI 추천 구현
  - 시연 영상 촬영
  - 

---

## 7. 라이선스 (License)

MIT License

Copyright (c) 2025 CHOULOKY

본 소프트웨어 및 관련 문서 파일(이하 "소프트웨어")의 사본을 입수하는 모든 사람에게, 
소프트웨어를 제한 없이 다루는 권한(사용, 복사, 수정, 병합, 게시, 배포, 서브라이선스 및/또는 판매)을 
허용하며, 다음 조건을 충족하는 경우에 한합니다:

상기 저작권 표시 및 이 허가 고지를 소프트웨어의 모든 사본 또는 주요 부분에 포함해야 합니다.

본 소프트웨어는 "있는 그대로"(AS IS) 제공되며, 상품성, 특정 목적에의 적합성 및 비침해에 대한 
보증을 포함하되 이에 국한되지 않는 어떠한 형태의 보증도 제공되지 않습니다. 
저자 또는 저작권자는 소프트웨어 또는 그 사용으로 인해 발생하는 어떠한 청구, 손해 또는 
기타 책임에 대해서도 책임을 지지 않습니다.
