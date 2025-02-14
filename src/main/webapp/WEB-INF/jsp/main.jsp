<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>세미나 예약 메인 | <spring:message code="title.sample" /></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .carousel-item img {
            max-height: 500px;
            object-fit: cover;
        }
        .card {
            transition: transform 0.3s;
        }
        .card:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <!-- 🚀 캐러셀 (세미나 슬라이드) -->
    <div id="seminarCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#seminarCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#seminarCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#seminarCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="https://cdn.goodkyung.com/news/photo/202210/189479_151296_2725.jpg" class="d-block w-100" alt="세미나 이미지 1">
                <div class="carousel-caption d-none d-md-block">
                    <h5>최신 IT 세미나</h5>
                    <p>최고의 IT 전문가들과 함께하는 시간</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://i.ytimg.com/vi/ng08_uiVzx8/sddefault.jpg?v=6204df78" class="d-block w-100" alt="세미나 이미지 2">
                <div class="carousel-caption d-none d-md-block">
                    <h5>비즈니스 전략 세미나</h5>
                    <p>최고의 비즈니스 인사이트를 경험하세요</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://www.kgnews.co.kr/data/photos/20211249/art_16392859725788_733e2c.jpg" class="d-block w-100" alt="세미나 이미지 3">
                <div class="carousel-caption d-none d-md-block">
                    <h5>AI & 데이터 분석</h5>
                    <p>최신 AI 기술 트렌드를 알아보세요</p>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#seminarCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#seminarCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- 🎯 인기 세미나 목록 -->
    <h2 class="text-center mt-5">🔥 인기 세미나</h2>
    <div class="row mt-4">
        <c:forEach var="seminar" items="${popularSeminars}">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <img src="https://source.unsplash.com/400x250/?lecture" class="card-img-top" alt="세미나 이미지">
                    <div class="card-body">
                        <h5 class="card-title">${seminar.title}</h5>
                        <p class="card-text">${seminar.description}</p>
                        <a href="reservation/${seminar.id}" class="btn btn-primary">예약하기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
