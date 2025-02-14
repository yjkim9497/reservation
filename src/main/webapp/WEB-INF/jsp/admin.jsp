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
    <title>관리자 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">관리자 페이지</h1>

        <!-- 네비게이션 탭 -->
        <ul class="nav nav-tabs" id="adminTabs">
            <li class="nav-item">
                <a class="nav-link active" id="userTab" data-bs-toggle="tab" href="#users">유저 관리</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="reservationTab" data-bs-toggle="tab" href="#reservations">세미나 관리</a>
            </li>
        </ul>

        <div class="tab-content mt-3">
            <!-- 유저 관리 탭 -->
            <div class="tab-pane fade show active" id="users">
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
                                <td>${user.userId}</td>
                                <td>${user.userName}</td>
                                <td>${user.userEmail}</td>
                                <td>${user.userPhone}</td>
                                <td><fmt:formatDate value="${user.userBirth}" pattern="yyyy년 MM월 dd일" /></td>
                                <td>${user.regDateFormatted}</td>
                                <td>
                                    <form action="editUser.do" method="get" style="display: inline;">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <button type="submit" class="btn btn-primary btn-sm">수정</button>
                                    </form>
                                    <form action="deleteUser.do" method="post" style="display: inline;" onsubmit="return confirmDelete();">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 예약 관리 탭 -->
            <div class="tab-pane fade" id="reservations">
                <h2 class="mb-4">세미나 목록</h2>
                <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addReservationModal">세미나 추가</button>
                <%-- <c:if test="${not empty loginUser}">
                    <p>현재 로그인한 사용자: <strong>${loginUser.name}</strong> (${loginUser.role})</p>
                </c:if> --%>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>NO</th>
                            <th>날짜</th>
                            <th>이름</th>
                            <th>시간</th>
                            <th>예약인원</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="seminar" items="${seminars}">
                            <tr>
                                <td>${seminar.seminarPk}</td>
                                <td>${seminar.seminarDate}</td>
                                <td>${seminar.seminarName}</td>
                                <td>${seminar.seminarTimeSlot}</td>
                                <td>${seminar.seminarCurrentPeople} / ${seminar.seminarCapacity}</td>
                                <td>${seminar.seminarStatus}</td>
                                <td>
                                    <c:if test="${seminar.seminarStatus == 'PROGRESSING' and loginUser.userRole == 'ADMIN'}">
                                        <button class="btn btn-success btn-sm" onclick="approveReservation('${reservation.reservationId}')">승인</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="addReservationModal" tabindex="-1" aria-labelledby="addReservationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addReservationModalLabel">세미나 추가</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addReservationForm">
                        <div class="mb-3">
                            <label for="seminarDate" class="form-label">세미나 날짜</label>
                            <input type="date" class="form-control" id="seminarDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="seminarName" class="form-label">세미나 이름</label>
                            <input type="text" class="form-control" id="seminarName" required>
                        </div>
                        <div class="mb-3">
                            <label for="seminarTimeSlot" class="form-label">세미나 시간</label>
                            <select class="form-control" id="seminarTimeSlot" required>
                                <option value="am">오전</option>
                                <option value="pm">오후</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="seminarCapacity" class="form-label">세미나 정원</label>
                            <input type="text" class="form-control" id="seminarCapacity" required>
                        </div>
                        <button type="submit" class="btn btn-primary">예약 추가</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete() {
            return confirm("정말로 삭제하시겠습니까?");
        }
        function approveReservation(id) {
            fetch(`/test1/reservation/${'${id}'}/approve.do`, { method: 'POST' })
            .then(response => response.text())
            .then(data => {
                alert(data);
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }
        
        document.getElementById("addReservationForm").addEventListener("submit", function(event) {
            event.preventDefault();
            let date = document.getElementById("seminarDate").value;
            let name = document.getElementById("seminarName").value;
            let time = document.getElementById("seminarTimeSlot").value;
            let capacity = document.getElementById("seminarCapacity").value;
            console.log(date)
            console.log(time)
            fetch('/test1/seminar/add.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ "seminarDate": date, "seminarName": name, "seminarTimeSlot" : time, "seminarCapacity" : capacity })
            }).then(response => response.text())
            .then(data => {
                alert("예약이 추가되었습니다.");
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        });
        
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
