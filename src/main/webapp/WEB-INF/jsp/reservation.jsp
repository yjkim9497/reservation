<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="reservation" />
<%@ include file="navbar.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>예약 시스템</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.css" rel="stylesheet">
<link href="../../resouces/font/pretendard.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
	* {
            font-family: 'pretendard';
        }
	body {
           background-color: #f8f9fa;
           font-family: 'pretendard';
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
	.fc-day.selected {
	    background-color: lightgray !important;
	    color: white !important;
	}
</style>
</head>
<body>
	<div class="container mt-4">
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
			  <ol class="breadcrumb">
			    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
			    <li class="breadcrumb-item active" aria-current="page">예약하기</li>
			  </ol>
			</nav>
    	<h2 class="mb-4">예약하기</h2>
    <div class="row">
        <!-- 달력 (왼쪽) -->
        <div class="col-md-6">
            <div id="calendar" style="height: 500px; width: 100%;"></div>
        </div>

        <!-- 예약 가능 항목 (오른쪽) -->
        <div class="col-md-6">
            <div id="reservations" class="p-3 border rounded" style="height: 500px; overflow-y: auto;">
                <h3>예약 가능 항목</h3>
                <p>날짜를 선택하면 예약 가능 항목이 표시됩니다.</p>
            </div>
        </div>
    </div>
    <a href="/test1/reservation/guest.do" class="btn btn-secondary">비회원 예약 조회</a>
    <c:if test="${not empty sessionScope.LoginVO}">
	    <a href="/test1/myReservation.do" class="btn btn-secondary">회원 예약 조회</a>
	</c:if>
</div>
	<!-- 예약 모달 -->
	<div class="modal fade" id="reservationModal" tabindex="-1"
    aria-labelledby="reservationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <%-- <h1>fdfdf : ${sessionScope.loginUser.userName}</h1>
            <h1>sdfsdf : ${sessionScope.LoginVO.userName}</h1> --%>
                <h5 class="modal-title" id="reservationModalLabel">예약 정보 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                    aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="reservationForm">
                    <input type="hidden" id="seminarPk" name="seminarPk">

                    <div class="mb-3">
    <label for="reservationName" class="form-label">예약자명</label>
    <c:choose>
        <c:when test="${not empty sessionScope.LoginVO.userName}">
            <p class="form-control-plaintext">${sessionScope.LoginVO.userName}</p>
            <input type="hidden" id="reservationName" value="${sessionScope.LoginVO.userName}">
        </c:when>
        <c:otherwise>
            <input type="text" class="form-control" id="reservationName" required>
        </c:otherwise>
    </c:choose>
</div>

<div class="mb-3">
    <label for="reservationPhone" class="form-label">휴대폰번호</label>
    <c:choose>
        <c:when test="${not empty sessionScope.LoginVO.userPhone}">
            <p class="form-control-plaintext">${sessionScope.LoginVO.userPhone}</p>
            <input type="hidden" id="reservationPhone" name="reservationPhone" value="${sessionScope.LoginVO.userPhone}">
        </c:when>
        <c:otherwise>
            <input type="tel" class="form-control" id="reservationPhone" name="reservationPhone" required>
            <small class="text-danger" id="phoneError" style="display: none;">
                휴대폰 번호 형식이 올바르지 않습니다 (예: 01012345678)
            </small>
        </c:otherwise>
    </c:choose>
</div>

<div class="mb-3">
    <label for="reservationEmail" class="form-label">이메일</label>
    <c:choose>
        <c:when test="${not empty sessionScope.LoginVO.userEmail}">
            <p class="form-control-plaintext">${sessionScope.LoginVO.userEmail}</p>
            <input type="hidden" id="reservationEmail" name="reservationEmail" value="${sessionScope.LoginVO.userEmail}">
        </c:when>
        <c:otherwise>
            <input type="email" class="form-control" id="reservationEmail" name="reservationEmail" required>
            <small class="text-danger" id="emailError" style="display: none;">
                올바른 이메일 형식이 아닙니다 (예: example@email.com)
            </small>
        </c:otherwise>
    </c:choose>
</div>

<div class="mb-3">
    <label for="reservationBirth" class="form-label">생년월일</label>
    <c:choose>
        <c:when test="${not empty sessionScope.LoginVO.userBirth}">
            <p class="form-control-plaintext"><fmt:formatDate value="${sessionScope.LoginVO.userBirth}" pattern="yyyy-MM-dd" /></p>
            <input type="hidden" id="reservationBirth" name="reservationBirth" value="${sessionScope.LoginVO.userBirth}">
        </c:when>
        <c:otherwise>
            <input type="date" class="form-control" id="reservationBirth" name="reservationBirth" required>
            <small class="text-danger" id="dateError" style="display: none;">올바른 날짜를 입력하세요 (YYYY ≤ 9999)</small>
        </c:otherwise>
    </c:choose>
</div>

                    <div class="mb-3">
                        <label for="reservationNumber" class="form-label">예약 인원</label>
                        <input type="text" class="form-control" id="reservationNumber" min="1"
                            required>
                        <small class="text-danger" id="numberError" style="display: none;">
                            숫자만 입력 가능하며 최소 1명 이상이어야 합니다.
                        </small>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                    data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary"
                    onclick="submitReservation()">예약하기</button>
            </div>
        </div>
    </div>
</div>


	<script>
	document.addEventListener("DOMContentLoaded", function() {
	    const phoneInput = document.getElementById("reservationPhone");
	    const phoneError = document.getElementById("phoneError");

	    const emailInput = document.getElementById("reservationEmail");
	    const emailError = document.getElementById("emailError");

	    const numberInput = document.getElementById("reservationNumber");
	    const numberError = document.getElementById("numberError");
	    
	    reservationBirth.addEventListener("input", function() {
            const dateValue = reservationBirth.value;
            const [year, month, day] = dateValue.split("-").map(Number);

            if (year > 9999 || month > 12 || day > 31) {
                dateError.style.display = "block";
                reservationBirth.classList.add("is-invalid");
            } else {
                dateError.style.display = "none";
                reservationBirth.classList.remove("is-invalid");
            }
        });

	    phoneInput.addEventListener("input", function() {
	        const phonePattern = /^010-\d{4}-\d{4}$|^010\d{8}$/;
	        if (!phonePattern.test(phoneInput.value)) {
	            phoneError.style.display = "block";
	            phoneInput.classList.add("is-invalid");
	        } else {
	            phoneError.style.display = "none";
	            phoneInput.classList.remove("is-invalid");
	        }
	    });

	    emailInput.addEventListener("input", function() {
	        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	        if (!emailPattern.test(emailInput.value)) {
	            emailError.style.display = "block";
	            emailInput.classList.add("is-invalid");
	        } else {
	            emailError.style.display = "none";
	            emailInput.classList.remove("is-invalid");
	        }
	    });

	    reservationNumber.addEventListener("input", function() {
            if (!/^\d*$/.test(reservationNumber.value)) {
            	numberError.style.display = "block";
                reservationNumber.classList.add("is-invalid");
            } else {
            	numberError.style.display = "none";
                reservationNumber.classList.remove("is-invalid");
            }
        });

	    function submitReservation() {
	        if (phoneError.style.display === "block" || emailError.style.display === "block" || numberError.style.display === "block") {
	            alert("입력값을 확인해주세요.");
	            return;
	        }
	        document.getElementById("reservationForm").submit();
	    }

	});
	
	document.addEventListener('DOMContentLoaded', function () {
	    var calendarEl = document.getElementById('calendar');
	    var holidayDates = []; // 휴무일을 저장할 배열
	    var reservationsEl = document.getElementById('reservations'); // 예약 가능 항목 표시 영역

	    // 1. 휴무일 데이터 미리 가져오기
	    fetch('/test1/holiday/list.do')
	        .then(res => res.json())
	        .then(holidays => {
	            	console.log(holidays)
	            holidayDates = holidays.map(holiday => ({
	                start: holiday.holidayStart, 
	                end: holiday.holidayEnd
	            }));
	        })
	        .catch(error => console.error('휴무일 데이터를 불러오는 중 오류 발생:', error));

	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        initialView: 'dayGridMonth',
	        locale: 'ko',
	        dateClick: function (info) {
	            /* const clickedDate = info.dateStr; */
	            const clickedDate = new Date(info.dateStr).toISOString().split('T')[0];

	            // 2. 클릭한 날짜가 휴무일인지 검사
	            const isHoliday = holidayDates.some(holiday => {
	            	console.log("클릭한 날짜"+clickedDate)
	                const startDate = new Date(holiday.start).toISOString().split('T')[0];
	                const endDate = holiday.end ? new Date(holiday.end).toISOString().split('T')[0] : startDate;
	                return clickedDate >= startDate && clickedDate <= endDate;
	            });

	            // 3. 예약 가능 항목 영역 업데이트
	            if (isHoliday) {
	            	console.log("휴일입니다")
	                reservationsEl.innerHTML = `
	                    <h3>예약 가능 항목</h3>
	                    <p style="color: red; font-weight: bold;">휴무일입니다.</p>
	                `;
	            } else {
	                fetchReservations(clickedDate);
	            }

	            // 기존 선택된 날짜의 스타일을 초기화
	            const prevSelectedDate = document.querySelector('.fc-day.selected');
	            if (prevSelectedDate) {
	                prevSelectedDate.classList.remove('selected');
	            }

	            // 클릭한 날짜에 'selected' 클래스를 추가하여 스타일 변경
	            const selectedDateElement = info.dayEl;
	            selectedDateElement.classList.add('selected');
	        },
	        events: function(info, successCallback, failureCallback) {
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
	        }
	    });

	    calendar.render();
	});


    
    function openReservationModal(id) {
        console.log("예약할 ID:", id);
        document.getElementById('seminarPk').value = id; // 예약 ID 저장
        var modal = new bootstrap.Modal(document.getElementById('reservationModal'));
        modal.show(); // 모달 열기
    }

    
    function fetchReservations(date) {
        console.log('날짜: ' + date);

        // AJAX 요청으로 데이터 가져오기
        fetch(`/test1/seminar/${'${date}'}.do`)
	        .then(response => {
	            console.log("응답값이 있음");
	            console.log(response);
	
	            if (!response.ok) {
	                throw new Error('Network response was not ok');
	            }
	
	            // 응답이 JSON인지 확인
	            const contentType = response.headers.get("Content-Type");
	            if (contentType && contentType.includes("application/json")) {
	                return response.json(); // JSON으로 변환
	            } else {
	                throw new Error("Invalid content type: " + contentType);
	            }
	        })
	        .then(data => {
	            console.log("받은 데이터:", data);
	            displayReservations(data, date); // 데이터 렌더링
	        })
	        .catch(error => {
	            console.error('데이터를 가져오는 중 오류 발생:', error);
	            document.getElementById('reservations').innerHTML = `
	                <p>예약 데이터를 가져오는 데 문제가 발생했습니다.</p>
	            `});
    }
    
    function displayReservations(data, date) {
        const reservationDiv = document.getElementById('reservations');
        reservationDiv.innerHTML = `<h3>${date} 예약 가능 항목</h3>`;

        if (data.reservations && data.reservations.length > 0) {
            // 테이블 생성
            const table = document.createElement('table');
            table.className = 'table table-striped table-bordered'; // Bootstrap 스타일 적용
            table.innerHTML = `
                <thead class="thead-dark">
                    <tr>
                        <th>세미나 이름</th>
                        <th>정원</th>
                        <th>현재 예약 인원</th>
                        <th>예약</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            `;

            const tbody = table.querySelector('tbody');

            data.reservations.forEach(item => {
            	console.log(item)
                const id = item.seminarPk;
                const status = item.seminarStatus
                const row = document.createElement('tr');
                console.log(status)
                row.id = `reservation-${'${id}'}`;
                console.log(row.id)
               /*  const reservationButton = status == "AVAILABLE" 
                    ? "예약가능": "예약불가"; */
                 const reservationButton = status == "AVAILABLE" 
                    ? `<button class="btn btn-primary" onclick="openReservationModal(${'${item.seminarPk}'})">예약</button>`
                    : ""; 

                row.innerHTML = `
                    <td>${'${item.seminarName}'}</td>
                    <td>${'${item.seminarCapacity}'}</td>
                    <td class="seminarCurrentPeople seminar-${'${item.seminarPk}'}">${'${item.seminarCurrentPeople}'}</td>
                    <td>${'${reservationButton}'}</td>
                `;
                /* row.innerHTML = `
                    <td>${'${timeSlot}'}</td>
                    <td>${'${item.seminarName}'}</td>
                    <td>${'${item.seminarCapacity}'}</td>
                    <td class="seminarCurrentPeople">${'${item.seminarCurrentPeople}'}</td>
                    <td>
                        <button class="btn btn-primary" onclick="openReservationModal(${'${item.seminarPk}'})">예약</button>
                    </td>
                `; */
                tbody.appendChild(row);
            });

            reservationDiv.appendChild(table);
        } else {
            reservationDiv.innerHTML += '<p>예약 가능한 항목이 없습니다.</p>';
        }
    }


/*     function displayReservations(data, date) {
        const reservationDiv = document.getElementById('reservations');
        reservationDiv.innerHTML = `<h3>${date} 예약 가능 항목</h3>`;

        if (data.reservations && data.reservations.length > 0) {
            data.reservations.forEach(item => {
            	const id = item.id;
                reservationDiv.innerHTML += `
                    <div>
                        <p>시간대: ${'${item.timeSlot}'} - 상태: ${'${item.status}'}</p>
                        <button class="btn btn-primary" onclick="bookReservation(${'${id}'})">예약</button>
                    </div>`;
            });
        } else {
            reservationDiv.innerHTML += '<p>예약 가능한 항목이 없습니다.</p>';
        }
    } */
    
    async function submitReservation() {
        const seminarPk = document.getElementById('seminarPk').value;
        const reservationName = document.getElementById('reservationName').value;
        const reservationPhone = document.getElementById('reservationPhone').value;
        const reservationEmail = document.getElementById('reservationEmail').value;
        const reservationBirth = document.getElementById('reservationBirth').value;
        const reservationNumber = document.getElementById('reservationNumber').value;
        
        console.log('예약자 이름 : '+reservationName)
        console.log('예약자 폰 : '+reservationPhone)
        console.log('예약자 이메일 : '+reservationEmail)
        console.log('예약자 생일 : '+reservationBirth)
        console.log('예약인원 : '+reservationNumber)

        // 필수 입력값 체크
        if (!reservationName || !reservationPhone || !reservationEmail || !reservationNumber) {
            alert("모든 필드를 입력해주세요.");
            return;
        }

        function isValidDateFormat(date) {
            const regex = /^\d{4}-\d{2}-\d{2}$/;
            return regex.test(date);
        }

        // 날짜 포맷이 yyyy-MM-dd 형식인지 확인하는 함수
       /*  function isValidDateFormat(date) {
            const regex = /^\d{4}-\d{2}-\d{2}$/;
            return regex.test(date);
        }

        // 날짜 포매팅 함수 (Mon Feb 17 00:00:00 KST 2025 -> 2025-02-17)
        function formatDate(date) {
            const d = new Date(date);
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, '0');  // 월은 0부터 시작하므로 +1
            const day = String(d.getDate()).padStart(2, '0');

            return `${year}-${month}-${day}`;
        }
		let formattedDate = '';
        // 만약 예약 날짜가 yyyy-MM-dd 형식이 아니라면 포매팅을 해줍니다.
        if (!isValidDateFormat(reservationBirth)) {
            formattedDate = formatDate(reservationBirth);
            console.log(formattedDate)
        }else {
        	formattedDate = reservationBirth;
        	console.log(formattedDate)
        } */
        
        const requestData = {
            seminarPk,
            reservationName,
            reservationPhone,
            reservationEmail,
            reservationBirth : isValidDateFormat(reservationBirth)? reservationBirth : null,
            reservationNumber
        };

        try {
            await fetch(`/test1/reservation/${'${seminarPk}'}/book.do`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
            	if(data.reservationId){
            	alert(`${'${data.message}'} 예약번호는 ${'${data.reservationId}'} 입니다`);
            	}else {
            		alert(data.message)
            	}

                if (data.status === 'success') {
                    // 세미나 현재 인원 업데이트
                    const seminarRow = document.getElementById(`reservation-${'${seminarPk}'}`);
                    console.log(seminarRow)
                    if (seminarRow) {
                        const currentPeopleCell = seminarRow.querySelector('.seminarCurrentPeople');
                        console.log(currentPeopleCell.innerText)
                        if (currentPeopleCell) {
                            currentPeopleCell.innerText = Number(currentPeopleCell.innerText) + Number(reservationNumber);
                        }
                    }
                    
                    document.getElementById('reservationName').value = "";
                    document.getElementById('reservationPhone').value = "";
                    document.getElementById('reservationEmail').value = "";
                    document.getElementById('reservationBirth').value = "";
                    document.getElementById('reservationNumber').value = "";

                    // 모달 닫기
                    closeReservationModal();
                }
            });
        } catch (error) {
            console.error('예약 실패:', error);
            alert('예약 중 오류가 발생했습니다.');
        }
    }

    // 모달 닫기 함수
    function closeReservationModal() {
        const modal = document.getElementById('reservationModal');
        if (modal) modal.classList.remove('show');

        document.body.classList.remove('modal-open');
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
    }

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

</body>
<%@ include file="footer.jsp" %>
</html>
