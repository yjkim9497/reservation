<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="mypage" />
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function deleteUser(userPk) {
	    if (!confirm("정말로 회원 탈퇴를 진행하시겠습니까?")) {
	        return;
	    }
	
	    $.ajax({
	        url: "<c:url value='/deleteUser.do'/>",
	        type: "DELETE",
	        contentType: "application/json",  // JSON 형식으로 전송
	        data: JSON.stringify({ userPk: userPk }),  // userPk를 JSON 형태로 변환
	        success: function(response) {
	            if (response.success) {
	                alert("회원탈퇴가 완료되었습니다.");
	                window.location.href = "/test1/";  // 메인 페이지로 리다이렉트
	            } else {
	                alert("회원 탈퇴에 실패했습니다. 다시 시도해주세요.");
	            }
	        },
	        error: function() {
	            alert("서버 오류로 인해 회원 탈퇴에 실패했습니다.");
	        }
	    });
	}
</script>
</head>
<body>
    <div class="container mt-4">
    	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/mypage.do">마이페이지</a></li>
		    <li class="breadcrumb-item active" aria-current="page">내 정보</li>
		  </ol>
		</nav>
        <h2 class="mb-4">마이페이지</h2>
        <ul class="nav nav-tabs" id="myPageTabs">
	        <li class="nav-item"><a href="<c:out value="${page.context}" />mypage.do" class="nav-link active">내 정보</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />myReservation.do" class="nav-link">나의 예약</a></li>
        </ul>
        <div class="card mt-4">
            <div class="card-body">
                <h2>${loginUser.userName}님, 환영합니다!</h2>
                <table class="table">
                    <tbody>
                        <tr>
						    <th scope="row">아이디</th>
						    <td>${loginUser.userId}</td>
						</tr>
						    <tr>
						        <th scope="row">이메일</th>
						        <td>
									<c:if test="${not empty loginUser.userEmail}">
									        ${loginUser.userEmail}
									</c:if>
						        </td>
						    </tr>
						    <tr>
						        <th scope="row">연락처</th>
							        <td>
										<c:if test="${not empty loginUser.userPhone}">
										        ${loginUser.userPhone}
										</c:if>
							        </td>
						    </tr>
						<tr>
						    <th scope="row">권한</th>
						    <td>${loginUser.userRole}</td>
						</tr>
						    <tr>
						        <th scope="row">생년월일</th>
						        	<td>
										<c:if test="${not empty loginUser.userBirth}">
										        <fmt:formatDate value="${loginUser.userBirth}" pattern="yyyy년 MM월 dd일" />
										</c:if>
						        	</td>
						    </tr>

                    </tbody>
                </table>
                <a href="editProfile.do?userPk=${loginUser.userPk}" class="btn btn-primary mt-3">프로필 수정</a>
                <button type="button" class="btn btn-danger mt-3" onclick="deleteUser(${loginUser.userPk})">회원탈퇴</button>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="footer.jsp" %>
</html>
