<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link href="../../resouces/font/pretendard.css">
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
	* {
         font-family: 'pretendard';
      }
	body {
		font-family: 'pretendard';
	}
</style>
</head>
<body>
    <div class="container mt-4">
    	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/mypage.do">마이페이지</a></li>
		    <li class="breadcrumb-item active" aria-current="page">나의 예약</li>
		  </ol>
		</nav>
        <h2 class="mb-4">마이페이지</h2>
        <ul class="nav nav-tabs" id="myPageTabs">
	        <li class="nav-item"><a href="<c:out value="${page.context}" />mypage.do" class="nav-link">내 정보</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />myReservation.do" class="nav-link active">나의 예약</a></li>
        </ul>
        <div class="card mt-4">
            <div class="card-body">
                <h2>내 예약 관리</h2>
                <table class="table table-striped">
            <thead>
                <tr>
                    <th>예약 ID</th>
                    <th>예약 날짜</th>
                    <th>예약 인원</th>
                    <th>예약 상태</th>
                    <th>세미나 명</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.reservationPk}</td>
                        <td><fmt:formatDate value="${reservation.reservationBirth}" pattern="yyyy년 MM월 dd일" /></td>
                        <td>${reservation.reservationNumber}</td>
                        <td>
						    <c:choose>
						        <c:when test="${reservation.reservationStatus == 'APPLYING'}">신청중</c:when>
						        <c:when test="${reservation.reservationStatus == 'PROGRESSING'}">진행중</c:when>
						        <c:when test="${reservation.reservationStatus == 'REJECTED'}">거절</c:when>
						        <c:when test="${reservation.reservationStatus == 'COMPLETED'}">완료</c:when>
						        <c:otherwise>알 수 없음</c:otherwise>
						    </c:choose>
						</td>
                        <td>${reservation.seminarName}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="updateReservation('${reservation.reservationPk}', 'cancel')">취소</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function updateReservation(reservationPk, action) {
	    let url = '/test1/reservation/' + action + '.do?reservationPk=' + reservationPk;
	    let method = 'PUT';
	
	    fetch(url, {
	        method: method,
	        headers: {
	            'Content-Type': 'application/json'
	        }
	    })
	    .then(response => response.json())
	    .then(data => {
	    	console.log(data)
	    	data = data.trim()
	        if (data === 'SUCCESS') {
	            alert('예약이 취소되었습니다.');
	            location.reload(); // 페이지 새로고침
	        } else {
	            alert('처리 중 오류가 발생했습니다.');
	        }
	    })
	    .catch(error => {
	        console.error('Error:', error);
	        alert('서버와의 통신 중 문제가 발생했습니다.');
	    });
	}
    </script>
</body>
<%@ include file="footer.jsp" %>
</html>
