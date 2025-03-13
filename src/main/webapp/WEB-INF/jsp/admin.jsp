<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="admin" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../resouces/font/pretendard.css">
    <style>
       	* {
           font-family: 'pretendard';
        }
        body {
            background-color: #f8f9fa;
            font-family: 'pretendard';
        }
        .table td, .table th {
	        white-space: nowrap; /* 텍스트가 한 줄로 표시되게 설정 */
	        overflow: hidden; /* 넘치는 텍스트는 숨김 */
	        text-overflow: ellipsis; /* 넘치는 텍스트는 '...'으로 표시 */
	        vertical-align: middle !important;
	    }
    </style>
</head>
<body>
    <div class="container mt-4">
	   <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/admin.do">관리자페이지</a></li>
		    <li class="breadcrumb-item active" aria-current="page">사용자 관리</li>
		  </ol>
		</nav>
        <h2 class="mb-4">관리자 페이지</h2>

        <!-- 네비게이션 탭 -->
        <ul class="nav nav-tabs" id="adminPageTabs">
	        <li class="nav-item"><a href="<c:out value="${page.context}" />admin.do" class="nav-link active">사용자 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminSeminar.do" class="nav-link">세미나 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminHoliday.do" class="nav-link">휴무일 관리</a></li>
        </ul>

        <div class="card mt-4">
            <!-- 유저 관리 탭 -->
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>아이디</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>연락처</th>
                            <th>생년월일</th>
                            <th>가입일</th>
                            <th>계정상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.userName}</td>
                                <td>
									<c:if test="${not empty user.userEmail}">
									        ${user.userEmail}
									</c:if>
						        </td>
                                <td>
									<c:if test="${not empty user.userPhone}">
									        ${user.userPhone}
									</c:if>
						        </td>
						        <td>
									<c:if test="${not empty user.userBirth}">
									        <fmt:formatDate value="${user.userBirth}" pattern="yyyy년 MM월 dd일" />
									</c:if>
					        	</td>
                                <td>${user.regDateFormatted}</td>
                                <td>
					                <c:choose>
					                    <c:when test="${user.userLock}">
					                        <span class="text-danger">잠김</span>
					                    </c:when>
					                    <c:otherwise>
					                        <span class="text-success">활성</span>
					                    </c:otherwise>
					                </c:choose>
					            </td>
                                <td>
                                    <%-- <form action="editUser.do" method="get" style="display: inline;">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <button type="submit" class="btn btn-primary btn-sm">수정</button>
                                    </form> --%>
                                    <form action="deleteUser.do" method="post" style="display: inline;" onsubmit="return confirmDelete();">
                                        <input type="hidden" name="id" value="${user.userPk}">
                                        <button type="submit" class="btn btn-danger btn-sm">회원 삭제</button>
                                    </form>
                                    <c:if test="${user.userLock}">
					                    <form action="unlockUser.do" method="post" style="display: inline;">
					                        <input type="hidden" name="userPk" value="${user.userPk}">
					                        <button type="submit" class="btn btn-warning btn-sm">계정 잠금 해제</button>
					                    </form>
					                </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 세미나 관리 탭 -->
  <%--           <div class="tab-pane fade" id="seminars">
                <h2 class="mb-4">세미나 목록</h2>
                <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addReservationModal">세미나 추가</button>
                <c:if test="${not empty loginUser}">
                    <p>현재 로그인한 사용자: <strong>${loginUser.name}</strong> (${loginUser.role})</p>
                </c:if>
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
                                <td><fmt:formatDate value="${seminar.seminarDate}" pattern="yyyy년 MM월 dd일" /></td>
                                <td>
								    <a href="reservation/seminarReservation.do?seminarPk=${seminar.seminarPk}" class="text-decoration-none">
								        ${seminar.seminarName}
								    </a>
								</td>
                                <td>${seminar.seminarTimeSlot}</td>
                                <td>${seminar.seminarCurrentPeople} / ${seminar.seminarCapacity}</td>
                                <td>${seminar.seminarStatus}</td>
                                <td>
                                    <button class="btn btn-success btn-sm" onclick="approveReservation('${reservation.reservationId}')">승인</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div> --%>
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
<%@ include file="footer.jsp" %>
</html>
