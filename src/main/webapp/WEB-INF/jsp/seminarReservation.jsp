<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예약 확인</title>
    <link href="../../resouces/font/pretendard.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
       	* {
          font-family: 'pretendard';
        }
        body {
            background-color: #f8f9fa;
            font-family: 'pretendard';
        }
    </style>
</head>
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
	            alert(action === 'approve' ? '예약이 승인되었습니다.' :
	                  action === 'reject' ? '예약이 거절되었습니다.' :
	                  '예약이 취소되었습니다.');
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

<body>
	<div class="container mt-4">
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/adminSeminar.do">세미나 관리</a></li>
		    <li class="breadcrumb-item active" aria-current="page">예약 관리</li>
		  </ol>
		</nav>
        <h2 class="mb-4">예약 관리</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>예약 ID</th>
                    <th>예약자 이름</th>
                    <th>예약자 이메일</th>
                    <th>예약자 생년월일</th>
                    <th>예약 인원</th>
                    <th>예약 상태</th>
                    <th>예약자 명</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.reservationPk}</td>
                        <td>${reservation.reservationName}</td>
                        <td>${reservation.reservationEmail}</td>
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
                        <td>
						    <c:choose>
						        <c:when test="${not empty reservation.userName}">
						            ${reservation.userName}
						        </c:when>
						        <c:otherwise>
						            비회원
						        </c:otherwise>
						    </c:choose>
						</td>
                        <td>
                        <c:if test="${reservation.reservationStatus eq 'APPLYING'}">
                            <button class="btn btn-success btn-sm" onclick="updateReservation('${reservation.reservationPk}', 'approve')">승인</button>
                            <button class="btn btn-danger btn-sm" onclick="updateReservation('${reservation.reservationPk}', 'reject')">거절</button>
                        </c:if>
                        <c:if test="${reservation.reservationStatus eq 'REJECTED'}">
                        	<button class="btn btn-success btn-sm" onclick="updateReservation('${reservation.reservationPk}', 'approve')">승인</button>
                        </c:if>
                            <button class="btn btn-warning btn-sm" onclick="updateReservation('${reservation.reservationPk}', 'cancel')">취소</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
<%@ include file="footer.jsp" %>
</html>