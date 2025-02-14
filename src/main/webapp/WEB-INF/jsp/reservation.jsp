<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="navbar.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>예약 시스템</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<link
		href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.css"
		rel="stylesheet">
		<script
			src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<style>
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
	<div class="container mt-5">
		<div id="calendar"></div>
		<div id="reservations" style="margin-top: 20px;"></div>
	</div>
	<!-- 예약 모달 -->
	<div class="modal fade" id="reservationModal" tabindex="-1"
		aria-labelledby="reservationModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="reservationModalLabel">예약 정보 입력</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="reservationForm">
						<input type="hidden" id="seminarPk" name="seminarPk">

							<div class="mb-3">
								<label for="reservationName" class="form-label">예약자명</label> <input
									type="text" class="form-control" id="reservationName" required>
							</div>

							<div class="mb-3">
								<label for="reservationPhone" class="form-label">휴대폰번호</label> <input
									type="tel" class="form-control" id="reservationPhone" required>
							</div>

							<div class="mb-3">
								<label for="reservationEmail" class="form-label">이메일</label> <input
									type="email" class="form-control" id="reservationEmail" required>
							</div>

							<div class="mb-3">
								<label for="reservationBirth" class="form-label">생년월일</label> <input
									type="date" class="form-control" id="reservationBirth" required>
							</div>

							<div class="mb-3">
								<label for="reservationNumber" class="form-label">예약 인원</label> <input
									type="number" class="form-control" id="reservationNumber" min="1"
									required>
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
    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            dateClick: function (info) {
                const clickedDate = info.dateStr;
                fetchReservations(clickedDate);
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
            data.reservations
               /*  .filter(item => item.status === 'AVAILABLE') */ // ✅ AVAILABLE 상태만 표시
                .forEach(item => {
                    const id = item.id;
                    const reservationItem = document.createElement('div');
                    reservationItem.id = `reservation-${id}`;
                    reservationItem.innerHTML = `
                        <p>시간대: ${'${item.seminarTimeSlot}'} - 정원 : ${'${item.seminarCapacity}'} - 현재 예약 인원 : ${'${item.seminarCurrentPeople}'} </p>
                        <button class="btn btn-primary" onclick="openReservationModal(${'${item.seminarPk}'})">예약</button>
                    `;
                    reservationDiv.appendChild(reservationItem);
                });
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

        if (!reservationName || !reservationPhone || !reservationEmail || !reservationBirth || !reservationNumber) {
            alert("모든 필드를 입력해주세요.");
            return;
        }

        const requestData = {
       		seminarPk,
       		reservationName,
       		reservationPhone,
       		reservationEmail,
       		reservationBirth,
       		reservationNumber
        };

        try {
            const response = await fetch(`/test1/reservation/${'${seminarPk}'}/book.do`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestData)
            });
			
            console.log(response.status)
            console.log(response)
            /* if (!response.ok) {
                throw new Error('예약 요청 실패');
            } */

            alert('예약이 완료되었습니다!');
            document.getElementById('reservationModal').classList.remove('show');
            document.body.classList.remove('modal-open');
            document.querySelector('.modal-backdrop').remove();
        } catch (error) {
            console.error('예약 실패:', error);
            alert('예약 중 오류가 발생했습니다.');
        }
    }

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
