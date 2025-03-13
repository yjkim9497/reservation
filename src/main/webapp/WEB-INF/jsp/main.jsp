<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="currentPage" value="home" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>세미나 예약 메인 | <spring:message code="title.sample" /></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../resouces/font/pretendard.css">
    <style>
        * {
            font-family: 'pretendard';
        }

        body {
            background-color: #f8f9fa;
            font-family: 'pretendard';
        }

        /* 캐러셀 여백 동일하게 맞추기 */
        .carousel-container, .seminar-list-container {
            padding-left: 15px;
            padding-right: 15px;
        }

        /* 세미나 목록을 수평으로 가로로 스크롤할 수 있도록 설정 */
        .seminar-list {
            display: flex;
            overflow-x: auto;
            gap: 15px;
            scroll-behavior: smooth; /* 스크롤 애니메이션을 부드럽게 만듬 */
        }

        .seminar-list .card {
            min-width: 250px; /* 카드 최소 너비 */
            flex-shrink: 0;
        }

        /* 세미나 목록이 너무 길어지면 스크롤바가 보이도록 */
        .seminar-list::-webkit-scrollbar {
            height: 8px;
        }

        .seminar-list::-webkit-scrollbar-thumb {
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 5px;
        }

        /* 세미나 목록을 감싸는 컨테이너 */
        .seminar-list-wrapper {
            position: relative;
            width: 100%;
        }

        /* 세미나 목록 내 버튼 위치 */
        .scroll-button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.2);
            border: none;
            padding: 10px;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
        }

        .scroll-button-left {
            left: 0;
        }

        .scroll-button-right {
            right: 0;
        }
        
        a {
		    text-decoration: none !important;
		}
        
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container">
    <!-- 캐러셀 영역 -->
    <div class="carousel-container">
		    <h3 class="text-center" style="margin-top: -30px">🔥 마감 임박 세미나</h3>
        <div id="seminarCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="5000">
            <div class="carousel-indicators">
                <c:forEach var="seminar" items="${seminars}" varStatus="status">
                    <button type="button" data-bs-target="#seminarCarousel" data-bs-slide-to="${status.index}" 
                        class="${status.index == 0 ? 'active' : ''}"></button>
                </c:forEach>
            </div>
            <div class="carousel-inner">
                <c:forEach var="seminar" items="${seminars}" varStatus="status">
                    <div class="carousel-item text-center ${status.index == 0 ? 'active' : ''}">
	                    <a href="/test1/seminar/detail.do?seminarPk=${seminar.seminarPk}">
	                        <img src="${seminar.seminarFilePath}" alt="세미나 이미지" width="960" height="540">
	                    </a>
                    </div>
                </c:forEach>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#seminarCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#seminarCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </div>

    <!-- 세미나 목록 -->
    <h2 class="mt-5">세미나 목록</h2>
    <div class="seminar-list-wrapper">
        <div class="seminar-list-container">
            <div class="seminar-list">
                <c:forEach var="seminar" items="${seminarList}">
                    <div class="col-md-3 mb-4"> <!-- 기존의 col-md-4에서 col-md-3로 변경하여 가로 길이를 줄임 -->
                        <a href="/test1/seminar/detail.do?seminarPk=${seminar.seminarPk}">
                        <div class="card h-100"> <!-- h-100 클래스를 사용하여 카드 높이를 동일하게 맞춤 -->
                            <img src="${seminar.seminarFilePath}" class="card-img-top" alt="세미나 이미지">
                            <div class="card-body d-flex flex-column"> <!-- flex-column으로 카드 본문을 세로로 정렬 -->
                                <h5 class="card-title">${seminar.seminarName}</h5>
                                <p class="card-text">${seminar.seminarPlace}</p>
                                <div class="mt-auto"></div> <!-- 하단에 여백을 추가하여 내용이 고정된 높이를 유지하도록 함 -->
                            </div>
                        </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 왼쪽으로 스크롤 버튼 -->
        <button class="scroll-button scroll-button-left" onclick="scrollSeminarList('left')"><</button>

        <!-- 오른쪽으로 스크롤 버튼 -->
        <button class="scroll-button scroll-button-right" onclick="scrollSeminarList('right')">></button>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 세미나 목록을 왼쪽 또는 오른쪽으로 스크롤하는 함수
    function scrollSeminarList(direction) {
        const seminarList = document.querySelector('.seminar-list');
        const scrollAmount = 250; // 스크롤할 거리
        if (direction === 'right') {
            seminarList.scrollBy({ left: scrollAmount, behavior: 'smooth' });
        } else if (direction === 'left') {
            seminarList.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
        }
    }
</script>
<div style="margin-bottom: 300px;"></div>
</body>
<%@ include file="footer.jsp" %>
</html>
