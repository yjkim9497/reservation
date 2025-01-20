<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container mt-5">
        <h1 class="mb-4">관리자 페이지</h1>
        
        <!-- 유저 목록 테이블 -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>연락처</th>
                    <th>생년월일</th>
                    <th>가입일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.phone}</td>
                        <td><fmt:formatDate value="${user.birth}" pattern="yyyy년MM월dd일" /></td>
                        <td>${user.regDateFormatted}</td>
                        <td>
                            <!-- 수정 버튼 -->
                            <form action="editUser.do" method="get" style="display: inline;">
                                <input type="hidden" name="id" value="${user.id}">
                                <button type="submit" class="btn btn-primary btn-sm">수정</button>
                            </form>
                            <!-- 삭제 버튼 -->
                            <form action="deleteUser.do" method="post" style="display: inline;" onsubmit="return confirmDelete();">
                                <input type="hidden" name="id" value="${user.id}">
                                <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <script>
        function confirmDelete() {
            return confirm("정말로 삭제하시겠습니까?");
        }
    </script>
</body>
</html>