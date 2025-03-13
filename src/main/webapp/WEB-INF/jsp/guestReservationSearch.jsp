<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="mypage" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 조회</title>
    <link href="../../resouces/font/pretendard.css">
    <!-- Bootstrap CSS 링크 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>
<style>
	* {
         font-family: 'pretendard';
      }
	body {
		font-family: 'pretendard';
	}
</style>
<body>
    <div class="container mt-4">
    	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/reservation.do">예약하기</a></li>
		    <li class="breadcrumb-item active" aria-current="page">비회원 예약 조회</li>
		  </ol>
		</nav>
        <h2 class="mb-4">비회원 예약 조회</h2>

        <!-- 예약 조회 폼 -->
        <form id="reservationForm">
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="email">이메일</label>
                    <input type="email" class="form-control" id="reservationEmail" name="reservationEmail" placeholder="이메일을 입력하세요" required>
                </div>
                <div class="form-group col-md-6">
                    <label for="reservationId">예약번호</label>
                    <input type="text" class="form-control" id="reservationPk" name="reservationPk" placeholder="예약번호를 입력하세요" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block">예약 조회</button>
        </form>

        <!-- 예약 내역 출력 -->
        <div id="reservationResult" class="mt-5"></div>

    </div>

    <!-- Bootstrap JS 및 의존성 스크립트 링크 -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        // AJAX를 통해 비동기 방식으로 예약 조회
        $('#reservationForm').submit(function(event) {
    event.preventDefault();  // 폼 제출 기본 동작 방지

    var reservationEmail = $('#reservationEmail').val();
    var reservationPk = $('#reservationPk').val();

    // 보낼 데이터를 JSON 형식으로 준비
    var requestData = {
        reservationEmail: reservationEmail,
        reservationPk: reservationPk
    };

    // AJAX 요청
    $.ajax({
        url: '/test1/reservation/search.do',  // 서버의 예약 조회 URL
        type: 'POST',  // POST 방식
        contentType: 'application/json',  // 요청 데이터 형식은 JSON
        data: JSON.stringify(requestData),  // 데이터를 JSON 형식으로 변환하여 전송
        success: function(response) {
            // 예약 조회 성공 시
            if (response.reservation) {
                var reservation = response.reservation;
                const status = reservation.reservationStatus;
                let statusText = '';
                if (status === 'APPLYING') {
                    statusText = '신청중';
                } else if (status === 'PROGRESSING') {
                    statusText = '진행중';
                } else if (status === 'REJECTED') {
                    statusText = '거절';
                } else if (status === 'COMPLETED') {
                    statusText = '완료';
                } else {
                    statusText = '알 수 없음';
                }
                var resultHtml = `
                    <h4 class="text-center">예약 내역</h4>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>예약자명</th>
                                <th>이메일</th>
                                <th>예약 인원</th>
                                <th>예약 상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>${'${reservation.reservationName}'}</td>
                                <td>${'${reservation.reservationEmail}'}</td>
                                <td>${'${reservation.reservationNumber}'}</td>
                                <td>${'${statusText}'}</td>
                            </tr>
                        </tbody>
                    </table>
                `;
                $('#reservationResult').html(resultHtml);
            } else {
                // 예약이 없을 경우
                var noResultHtml = `
                    <div class="alert alert-warning mt-5" role="alert">
                        예약 내역을 찾을 수 없습니다. 이메일과 예약번호를 다시 확인해 주세요.
                    </div>
                `;
                $('#reservationResult').html(noResultHtml);
            }
        },
        error: function() {
            // 오류 발생 시
            var errorHtml = `
                <div class="alert alert-danger mt-5" role="alert">
                    서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.
                </div>
            `;
            $('#reservationResult').html(errorHtml);
        }
    });
});

    </script>
</body>
</html>
