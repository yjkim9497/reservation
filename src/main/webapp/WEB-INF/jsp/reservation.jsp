<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>예약 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
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
    
    function fetchReservations(date) {
        console.log('날짜: ' + date);

        // AJAX 요청으로 데이터 가져오기
        fetch(`/test1/reservation/${'${date}'}.do`)
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
                .filter(item => item.status === 'AVAILABLE') // ✅ AVAILABLE 상태만 표시
                .forEach(item => {
                    const id = item.id;
                    const reservationItem = document.createElement('div');
                    reservationItem.id = `reservation-${id}`;
                    reservationItem.innerHTML = `
                        <p>시간대: ${'${item.timeSlot}'} - 상태: ${'${item.status}'}}</p>
                        <button class="btn btn-primary" onclick="bookReservation(${'${id}'})">예약</button>
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
    
    async function bookReservation(id) {
        try {
            const response = await fetch(`/test1/reservation/${'${id}'}/book.do`, { method: 'POST' });

            if (!response.ok) {
                throw new Error('예약 요청 실패');
            }

            // ✅ 예약 성공 시 해당 예약 요소 제거
            document.getElementById(`reservation-${id}`).remove();
            alert('예약이 완료되었습니다!');
        } catch (error) {
            console.error('예약 실패:', error);
            alert('예약 중 오류가 발생했습니다.');
        }
    }

    function bookReservation22(id) {
    	console.log("id확인"+id)
        fetch(`/test1/reservation/${'${id}'}/book.do`, { method: 'POST' })
            .then(response => response.text())
            .then(message => {
                alert(message); // 예약 성공 메시지 표시
            })
            .catch(error => {
                console.error('예약 처리 중 오류 발생:', error);
                alert('예약 처리 중 문제가 발생했습니다.');
            });
    }
</script>
</body>
</html>
