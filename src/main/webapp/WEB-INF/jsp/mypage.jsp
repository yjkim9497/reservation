<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="mt-5">마이페이지</h1>
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
                            <td>${loginUser.userEmail}</td>
                        </tr>
                        <tr>
                            <th scope="row">연락처</th>
                            <td>${loginUser.userPhone}</td>
                        </tr>
                        <tr>
                            <th scope="row">역할</th>
                            <td>${loginUser.userRole}</td>
                        </tr>
                        <tr>
                            <th scope="row">생년월일</th>
                            <td><fmt:formatDate value="${loginUser.userBirth}" pattern="yyyy년MM월dd일" /></td>
                        </tr>
                    </tbody>
                </table>
                <a href="editProfile.do" class="btn btn-primary mt-3">프로필 수정</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
