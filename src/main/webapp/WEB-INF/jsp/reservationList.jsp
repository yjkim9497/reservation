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
    <title>예약 목록</title>
    <script>
        function approveReservation(id) {
            fetch(`/reservation/${id}/approve.do`, { method: 'POST' })
            .then(response => response.text())
            .then(data => {
                alert(data);
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</head>
<body>
    <h2>예약 목록</h2>
	
    <c:if test="${not empty loginUser}">
        <p>현재 로그인한 사용자: ${loginUser.name} (${loginUser.role})</p>
    </c:if>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>날짜</th>
            <th>예약 시간</th>
            <th>상태</th>
            <th>관리</th>
        </tr>
        <c:forEach var="reservation" items="${reservations}">
            <tr>
                <td>${reservation.id}</td>
                <td>${reservation.date}</td>
                <td>${reservation.timeSlot}</td>
                <td>${reservation.status}</td>
                <td>
                    <c:if test="${reservation.status == 'PROGRESSING' and loginUser.role == 'admin'}">
                        <button onclick="approveReservation(${reservation.id})">승인</button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
