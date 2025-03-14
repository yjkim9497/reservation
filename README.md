# 세미나 예약 페이지 개발 프로젝트
- 개발 기간 : 2025.01 ~ 2025.03 (약 6주)
- 1인 프로젝트 

## 📌 프로젝트 개요
**세미나 예약 시스템**을 개발하는 과정에서 서버 구성, 프로그래밍, 데이터 암호화 등의 기술을 적용한 프로젝트입니다. 본 리포지토리는 프로젝트의 주요 기능 및 기술 스택을 정리한 문서입니다.

## 🛠 기술 스택
- **Back-End**: Java 1.8, 전자정부프레임워크(Spring Framework) 4.2, MyBatis
- **Front-End**: HTML, CSS, JavaScript
- **Database**: MariaDB
- **Infra**: Virtual Machine (VM), Rocky Linux 8.10
- **Security**: SHA-256 암호화

## ⚙ 프로젝트 구성
### 1️⃣ 서버 구성
- **OS**: Linux 기반 환경 구축
- **Web Server**: Apache 설정 및 가상 호스트 적용
- **WAS**: Tomcat 연동 및 설정 파일 적용
- **DB**: MariaDB 실행 및 설정

### 2️⃣ 주요 기능
#### ✅ 사용자 기능
- **회원가입**: ID, 비밀번호(암호화), 휴대전화(암복호화), 이메일(암복호화)
- **로그인**: 일반 로그인, 카카오 로그인
- **세미나 조회 및 예약**: 달력 및 썸네일 기반 목록 제공, 정원 체크, 예약 및 취소 기능
- **게시판**: 질문 게시판, 댓글 작성 기능
- **마이페이지**: 예약 확인 및 취소, 개인정보 조회

#### ✅ 관리자 기능
- **회원 관리**: 사용자 정보 관리
- **세미나 관리**: 세미나 일정 등록 및 수정
- **예약 관리**: 예약자 정보 조회
- **게시판 관리**: 질문 게시판 및 댓글 관리

### 3️⃣ 프로젝트 화면
- 메인화면
  ![image](https://github.com/user-attachments/assets/c94f8c7b-c0d0-4434-a652-11e52f77c99a)
- 세미나 목록
  <br>
  ![image](https://github.com/user-attachments/assets/a5cc4c28-3e81-480d-aa23-694600c6ec2a)
- 세미나 예약
  <br>
  ![image](https://github.com/user-attachments/assets/5b220cd6-7fd2-48ad-ab58-4d131c8cb37e)
- 세미나 상세
![image](https://github.com/user-attachments/assets/ae9ca1ff-0910-4f87-af17-591f60147d46)

 
### 4️⃣ 프로젝트 구조
전자정부 프레임워크의 표준을 준수하여 **Controller, Service, Mapper, VO** 계층을 분리함으로써 유지보수성과 확장성을 확보하였습니다.

## 🏗 ERD
다음과 같은 주요 테이블을 설계하였습니다.
![image](https://github.com/user-attachments/assets/b2bd08f1-2cfa-4ea8-9d53-fb2f4e4e379f)

- **USER**: 회원 정보 테이블
- **SEMINAR**: 세미나 정보 테이블
- **RESERVATION**: 예약 정보 테이블
- **HOLIDAY**: 휴무일 관리 테이블
- **BOARD**: 게시판 테이블
- **COMMENT**: 댓글 테이블

## 🔒 보안 및 암호화
- 사용자 비밀번호 및 주요 개인정보는 **SHA-256** 알고리즘을 적용하여 암호화 처리하였습니다.


