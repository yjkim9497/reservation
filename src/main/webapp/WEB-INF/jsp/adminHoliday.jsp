<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="admin" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>휴무일 관리</title>
    <link href="../../resouces/font/pretendard.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <style>
       	* {
           font-family: 'pretendard';
        }
        body {
            background-color: #f8f9fa;
            font-family: 'pretendard' !important;
        }
        #calendar {
            max-width: 900px;
            margin: 20px auto;
        }
        /* 날짜 및 요일 밑줄 제거 */
	.fc-daygrid-day-number, .fc-col-header-cell {
		text-decoration: none !important;
		color: black !important;
	}
	
	/* 포커스 시에도 밑줄 제거 */
	.fc-daygrid-day-number a, .fc-col-header-cell a {
		text-decoration: none !important;
		color: black !important;
	}
    </style>
</head>
<body>
    <div class="container mt-4">
	   <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/admin.do">관리자페이지</a></li>
		    <li class="breadcrumb-item active" aria-current="page">휴무일 관리</li>
		  </ol>
		</nav>
        <h2 class="mb-4">관리자 페이지</h2>

        <!-- 네비게이션 탭 -->
        <ul class="nav nav-tabs" id="adminPageTabs">
	        <li class="nav-item"><a href="<c:out value="${page.context}" />admin.do" class="nav-link">사용자 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminSeminar.do" class="nav-link">세미나 관리</a></li>
	        <li class="nav-item"><a href="<c:out value="${page.context}" />adminHoliday.do" class="nav-link active">휴무일 관리</a></li>
        </ul>


        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">휴무일 추가</h5>
                <form id="holidayForm">
                    <div class="mb-3">
                        <label for="startDate" class="form-label">시작일</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">종료일</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary">휴무일 추가</button>
                </form>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">휴무일 캘린더</h5>
                <div id="calendar"></div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales/ko.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            let calendarEl = document.getElementById('calendar');
            let calendar = new FullCalendar.Calendar(calendarEl, {
                locale: 'ko',
                initialView: 'dayGridMonth',
                selectable: true,
                editable: false,
                displayEventTime: false,
                events: function(fetchInfo, successCallback, failureCallback) {
                	Promise.all([
    	                fetch('/test1/seminar/all.do').then(res => res.json()), // 세미나 API
    	                fetch('/test1/holiday/list.do').then(res => res.json()) // 휴무일 API
    	            ])
    	            .then(([seminars, holidays]) => {
    	                const seminarEvents = seminars.map(seminar => ({
    	                    title: seminar.seminarName,
    	                    start: seminar.seminarStart, // "YYYY-MM-DD"
    	                    end: new Date(new Date(seminar.seminarEnd).setDate(new Date(seminar.seminarEnd).getDate() + 1)),
    	                    allDay: true,
    	                    backgroundColor: 'blue', // 세미나는 파란색
    	                    borderColor: 'blue'
    	                }));

    	                const holidayEvents = holidays.map(holiday => ({
    	                	id: holiday.holidayPk,
    	                    title: '휴무일',
    	                    start: holiday.holidayStart, 
    	                    end: new Date(new Date(holiday.holidayEnd).setDate(new Date(holiday.holidayEnd).getDate() + 1)), 
    	                    allDay: true,
    	                    backgroundColor: 'red', // 휴무일은 빨간색
    	                    borderColor: 'red'
    	                }));

    	                successCallback([...seminarEvents, ...holidayEvents]);
    	            })
    	            .catch(error => {
    	                console.error('데이터를 불러오는 중 오류 발생:', error);
    	                failureCallback(error);
    	            });
                },
                eventClick: function (info) {
                    if (confirm('이 휴무일을 삭제하시겠습니까?')) {
                        $.ajax({
                            url: '/test1/holiday/delete.do',
                            method: 'DELETE',
                            contentType: 'application/json',
                            data: JSON.stringify({ holidayPk: info.event.id }),
                            success: function () {
                                alert('휴무일이 삭제되었습니다.');
                                info.event.remove();
                            },
                            error: function () {
                                alert('삭제 중 오류가 발생했습니다.');
                            }
                        });
                    }
                }
            });

            calendar.render();

            $('#holidayForm').submit(function (event) {
                event.preventDefault();
                let startDate = $('#startDate').val();
                let endDate = $('#endDate').val();

                if (!startDate || !endDate) {
                    alert('시작일과 종료일을 모두 선택하세요.');
                    return;
                }

                $.ajax({
                    url: '/test1/holiday/add.do',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ holidayStart: startDate, holidayEnd: endDate }),
                    success: function (d) {
                        console.log(d);
                        
                        // 서버 응답에서 status 값에 따라 분기 처리
                        if (d.status === 'success') {
                            alert(d.message);  // success일 경우 메시지 출력
                            calendar.refetchEvents();
                        } else if (d.status === 'fail') {
                            alert(d.message);  // fail일 경우 메시지 출력
                        }
                    },
                    error: function (e) {
                        console.log(e);
                        alert('추가 중 오류가 발생했습니다.');
                    }
                });

            });
        });
    </script>
</body>
<%@ include file="footer.jsp" %>
</html>
