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
        .table td, .table th {
	        white-space: nowrap; /* 텍스트가 한 줄로 표시되게 설정 */
	        overflow: hidden; /* 넘치는 텍스트는 숨김 */
	        text-overflow: ellipsis; /* 넘치는 텍스트는 '...'으로 표시 */
	        vertical-align: middle !important;
	    }
	    .seminar-name{
	        max-width: 140px; /* 원하는 최대 너비로 설정 */
	    }
	    .seminar-place {
	        max-width: 100px; /* 원하는 최대 너비로 설정 */
	    }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container mt-4">
	   <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/admin.do">관리자페이지</a></li>
		    <li class="breadcrumb-item active" aria-current="page">세미나 관리</li>
		  </ol>
		</nav>
        <h2 class="mb-4">관리자 페이지</h2>

        <!-- 네비게이션 탭 -->
        <ul class="nav nav-tabs" id="adminPageTabs">
	        <li class="nav-item"><a href="<c:out value="${page.context}" />admin.do" class="nav-link">사용자 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminSeminar.do" class="nav-link active">세미나 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminHoliday.do" class="nav-link">휴무일 관리</a></li>
        </ul>
        <div class="card mt-4">
            <!-- 세미나 관리 탭 -->
            <div class="card-body">
                <!-- <h2>세미나 목록</h2> -->
                
                <%-- <c:if test="${not empty loginUser}">
                    <p>현재 로그인한 사용자: <strong>${loginUser.name}</strong> (${loginUser.role})</p>
                </c:if> --%>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>NO</th>
                            <th>이름</th>
                            <th>시작일</th>
                            <th>종료일</th>
                            <th>예약인원</th>
                            <th>장소</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="seminar" items="${seminars}">
                            <tr>
                                <td>${seminar.seminarPk}</td>
                                <td class="seminar-name">
								    <a href="reservation/seminarReservation.do?seminarPk=${seminar.seminarPk}" class="seminar-name text-decoration-none">
								        ${seminar.seminarName}
								    </a>
								</td>
                                <td><fmt:formatDate value="${seminar.seminarStart}" pattern="yyyy-MM-dd" /></td>
                                <td><fmt:formatDate value="${seminar.seminarEnd}" pattern="yyyy-MM-dd" /></td>
                                <td>${seminar.seminarCurrentPeople} / ${seminar.seminarCapacity}</td>
                                <td class="seminar-place">${seminar.seminarPlace} </td>
                                <td>
								    <c:choose>
								        <c:when test="${seminar.seminarStatus == 'AVAILABLE'}">예약 가능</c:when>
								        <c:when test="${seminar.seminarStatus == 'FULL'}">정원 마감</c:when>
								        <c:when test="${seminar.seminarStatus == 'COMPLETED'}">세미나 종료</c:when>
								        <c:otherwise>${seminar.seminarStatus}</c:otherwise>
								    </c:choose>
								</td>

                                <td>
                                    <button class="btn btn-danger btn-sm" onclick="deleteSeminar('${seminar.seminarPk}')">삭제</button>
                                    <c:if test="${seminar.seminarStatus != 'COMPLETED'}">
                                    	<button class="btn btn-secondary btn-sm" onclick="completeSeminar('${seminar.seminarPk}')">종료</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addReservationModal">세미나 추가</button>
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
                <form id="addSeminarForm" enctype="multipart/form-data">
	                <div class="mb-3">
                        <label for="seminarName" class="form-label">세미나 이름</label>
                        <input type="text" class="form-control" id="seminarName" required>
                    </div>
                    <div class="mb-3">
                        <label for="seminarStart" class="form-label">세미나 시작일</label>
                        <input type="date" class="form-control" id="seminarStart" required>
                        <small class="text-danger" id="dateError" style="display: none;">올바른 날짜를 입력하세요 (YYYY ≤ 9999)</small>
                    </div>
                    <div class="mb-3">
                        <label for="seminarEnd" class="form-label">세미나 종료일</label>
                        <input type="date" class="form-control" id="seminarEnd" required>
                        <small class="text-danger" id="dateError" style="display: none;">올바른 날짜를 입력하세요 (YYYY ≤ 9999)</small>
                    </div>
                    <div class="mb-3">
                        <label for="seminarPlace" class="form-label">세미나 장소</label>
                        <input type="text" class="form-control" id="seminarPlace" required>
                    </div>
                    <div class="mb-3">
                        <label for="seminarCapacity" class="form-label">세미나 정원</label>
                        <input type="text" class="form-control" id="seminarCapacity" required>
                        <small class="text-danger" id="capacityError" style="display: none;">숫자만 입력하세요</small>
                    </div>
                    <div class="mb-3">
                        <label for="seminarUrl" class="form-label">세미나 URL</label>
                        <input type="text" class="form-control" id="seminarUrl" required>
                    </div>
                    <div class="mb-3">
                        <label for="file" class="form-label">세미나 이미지</label>
                        <input type="file" class="form-control" id="file">
                    </div>
                    <button type="submit" class="btn btn-primary">세미나 추가</button>
                </form>
            </div>
        </div>
    </div>
</div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        const seminarStart = document.getElementById("seminarStart");
        const seminarEnd = document.getElementById("seminarEnd");
        const dateError = document.getElementById("dateError");
        const seminarCapacity = document.getElementById("seminarCapacity");
        const capacityError = document.getElementById("capacityError");

        seminarStart.addEventListener("input", function() {
            const dateValue = seminarStart.value;
            const [year, month, day] = dateValue.split("-").map(Number);

            if (year > 9999 || month > 12 || day > 31) {
                dateError.style.display = "block";
                seminarStart.classList.add("is-invalid");
            } else {
                dateError.style.display = "none";
                seminarStart.classList.remove("is-invalid");
            }
        });
        seminarEnd.addEventListener("input", function() {
            const dateValue = seminarEnd.value;
            const [year, month, day] = dateValue.split("-").map(Number);

            if (year > 9999 || month > 12 || day > 31) {
                dateError.style.display = "block";
                seminarEnd.classList.add("is-invalid");
            } else {
                dateError.style.display = "none";
                seminarEnd.classList.remove("is-invalid");
            }
        });

        seminarCapacity.addEventListener("input", function() {
            if (!/^\d*$/.test(seminarCapacity.value)) {
                capacityError.style.display = "block";
                seminarCapacity.classList.add("is-invalid");
            } else {
                capacityError.style.display = "none";
                seminarCapacity.classList.remove("is-invalid");
            }
        });

        document.getElementById("addSeminarForm").addEventListener("submit", function(event) {
            if (dateError.style.display === "block" || capacityError.style.display === "block") {
                event.preventDefault();
            }
        });
    });
    
        function confirmDelete() {
            return confirm("정말로 삭제하시겠습니까?");
        }
        
        function deleteSeminar(id) {
            console.log(id);
            if (!confirm("정말로 삭제하시겠습니까?")) {
                return;
            }
            fetch(`/test1/seminar/delete.do`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(id)
            })
            .then(response => response.text())
            .then(data => {
                alert(data);
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }
        
        function completeSeminar(id) {
            console.log(id);
            if (!confirm("정말로 완료시키겠습니까?")) {
                return;
            }
            fetch(`/test1/seminar/complete.do`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(id)
            })
            .then(response => response.text())
            .then(data => {
                alert(data);
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }
        
        function addSeminar(){
        	var formData = new FormData();
        	formData.append("seminarName", $("#seminarName").val());
        	formData.append("seminarStart", $("#seminarStart").val());
        	formData.append("seminarEnd", $("#seminarEnd").val());
        	formData.append("seminarPlace", $("#seminarPlace").val());
        	formData.append("seminarCapacity", $("#seminarCapacity").val());
        	formData.append("seminarUrl", $("#seminarUrl").val());
        	formData.append("file", $("#file")[0].files[0]);
        	
        	console.log('formData seminarStart : '+formData.get('seminarStart'));
        	console.log('formData file : '+formData.get('file'));
        	
        	$.ajax({
                url: "<c:url value='/seminar/add.do'/>",
                type: "POST",
                data: formData, 
                processData: false,  
                contentType: false,  
                success: function(response) {
                    console.log(response);
                    if (response.success) {
                        alert(response.message);
                        window.location.href = "/test1/adminSeminar.do";
                    } else if (response.status === 'fail') {
                    	alert(response.message);
                    } else {
                        alert("세미나 등록에 실패했습니다. 다시 시도해주세요.");
                    }
                },
                error: function(xhr, status, error) {
                	console.log(formData)
                    console.error("오류 발생:", error);
                    alert("서버 오류로 인해 세미나 등록에 실패했습니다.");
                }
            });
        	return false;
        }
        
        $("#addSeminarForm").on("submit", function(event) {
            event.preventDefault();
            addSeminar();
        });
         
       /*  document.getElementById("addSeminarForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const formData = new FormData(this);
            fetch('/test1/seminar/add.do', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }); */

        
         /* document.getElementById("addReservationForm").addEventListener("submit", function(event) {
            event.preventDefault();
            let seminarStart = document.getElementById("seminarStart").value;
            let seminarEnd = document.getElementById("seminarEnd").value;
            let name = document.getElementById("seminarName").value;
            let capacity = document.getElementById("seminarCapacity").value;
            console.log(date)
            console.log(time)
            fetch('/test1/seminar/add.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ "seminarStart": seminarStart, "seminarEnd" : seminarEnd, "seminarCapacity" : capacity })
            }).then(response => response.text())
            .then(data => {
                alert("세미나가 등록되었습니다.");
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        });  */
        
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="footer.jsp" %>
</html>
