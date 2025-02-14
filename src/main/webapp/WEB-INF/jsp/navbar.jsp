<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="/test1/">Comin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="/test1/">홈</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/test1/reservation.do">예약하기</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/test1/boardList.do">질문게시판</a>
                </li>
            </ul>
            <c:if test="${sessionScope.LoginVO == null}">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/test1/login.do">로그인</a>
                    </li>
                </ul>
            </c:if>
            <c:if test="${sessionScope.LoginVO != null}">
                <ul class="navbar-nav">
	                <c:if test="${sessionScope.LoginVO.userRole eq 'ADMIN'}">
	                	<li class="nav-item">
	                        <a class="nav-link" href="/test1/admin.do">관리자페이지</a>
	                    </li>
	                </c:if>
                    <li class="nav-item">
                        <a class="nav-link" href="/test1/mypage.do">마이페이지</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/test1/logout.do">로그아웃</a>
                    </li>
                </ul>
            </c:if>
        </div>
    </div>
</nav>

<div style="padding-top: 70px;">
    <!-- Navbar가 화면 상단에 고정되므로 콘텐츠가 가려지지 않게 상단 여백을 추가 -->
  <!--   <p>이곳은 메인 콘텐츠 영역입니다.</p> -->
</div>
