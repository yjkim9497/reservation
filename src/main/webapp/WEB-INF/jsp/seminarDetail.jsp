<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.net.URLEncoder" %>
<c:set var="currentPage" value="seminar" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세미나 상세 정보</title>
    <!-- Bootstrap 5 CDN -->
    <link href="../../resouces/font/pretendard.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
    	* {
            font-family: 'pretendard';
        }
        body {
        	font-family: 'pretendard';
            background-color: #f8f9fa;
        }
        /* .seminar-card {
            max-width: 800px;
            margin: auto;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            overflow: hidden;
        } */
        .seminar-header {
            background: linear-gradient(135deg, #4b6cb7, #182848);
            color: white;
            text-align: center;
            padding: 20px;
            font-size: 1.8rem;
            font-weight: bold;
        }
        .seminar-image {
            width: 100%;
            max-height: 350px;
            object-fit: cover;
        }
        .card-body {
            padding: 20px;
        }
        .btn-purple {
            background-color: #6f42c1;
            color: white;
        }
        .btn-purple:hover {
            background-color: #563d7c;
        }
    </style>
</head>
<body>

<div class="container mt-4 my-5">
<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
    <li class="breadcrumb-item active"><a href="/test1/seminar/list.do">세미나</a></li>
  </ol>
</nav>
	<h2 class="mb-4">세미나</h2>
    <div class="card seminar-card">
	    <div class="row g-0">
            <!-- 이미지 영역 (왼쪽 70%) -->
            <div class="col-md-7">
                <img src="${ seminar.seminarFilePath }" class="seminar-image img-fluid" alt="세미나 이미지">
            </div>

            <!-- 세미나 정보 영역 (오른쪽 30%) -->
            <div class="col-md-5 d-flex flex-column justify-content-center p-4">
                <h3 class="seminar-title mb-3">${ seminar.seminarName }</h3>
                <c:if test="${seminar.seminarStatus == 'AVAILABLE'}">
                	<a href="/test1/reservation.do" class="btn btn-secondary w-100 py-2">신청하기</a>
	                <%-- <button class="btn btn-secondary w-100 py-2" onclick="openReservationModal(${seminar.seminarPk})">신청하기</button> --%>
                </c:if>
            </div>
        </div>
        

        <!-- 카드 본문 -->
        <div class="card-body">
        <!-- 세미나 정보 테이블 -->
					<table class="table">
					    <tbody>
					        <tr>
					            <td style="width: 20%;"><strong>시작일</strong></td>
            					<td style="width: 80%;"><fmt:formatDate value="${seminar.seminarStart}" pattern="yyyy년 MM월 dd일" /></td>
					        </tr>
					        <tr>
					            <td><strong>종료일</strong></td>
					            <td><fmt:formatDate value="${seminar.seminarEnd}" pattern="yyyy년 MM월 dd일" /></td>
					        </tr>
					        <tr>
					            <td><strong>장소</strong></td>
					            <td>${ seminar.seminarPlace }</td>
					        </tr>
					        <tr>
					            <td><strong>신청 인원</strong></td>
					            <td id="seminarRow">
					                <span class="seminarCurrentPeople">${ seminar.seminarCurrentPeople }</span> /
					                <span>${ seminar.seminarCapacity }</span>
					            </td>
					        </tr>
					        <tr>
					            <td><strong>상태</strong></td>
					            <td>
					            	<c:choose>
								        <c:when test="${seminar.seminarStatus == 'AVAILABLE'}">예약 가능</c:when>
								        <c:when test="${seminar.seminarStatus == 'FULL'}">정원 마감</c:when>
								        <c:when test="${seminar.seminarStatus == 'COMPLETED'}">세미나 종료</c:when>
								        <c:otherwise>${seminar.seminarStatus}</c:otherwise>
								    </c:choose>
								 </td>
					        </tr>
					        <tr>
							    <td><strong>세미나 페이지</strong></td>
							    <td>
								    <c:if test="${not empty seminar.seminarUrl}">
									    <img src="/test1/qr.do?url=${seminar.seminarUrl}" alt="QR Code" class="img-fluid mt-3"/>
									</c:if>
									<c:if test="${empty seminar.seminarUrl}">
									    <p>QR 코드가 제공되지 않습니다.</p>
									</c:if>
							    </td>
							</tr>
					    </tbody>
					</table>
            <div class="mt-3">
                <a href="/test1/seminar/list.do" class="btn btn-secondary">목록으로</a>
            </div>
        </div>
    </div>
</div>

<script>
</script>
</body>
<%@ include file="footer.jsp" %>
</html>

