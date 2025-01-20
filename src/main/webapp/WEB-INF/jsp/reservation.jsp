<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>예약 서비스</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Optional JavaScript (Popper.js and Bootstrap JS) -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.min.js"></script>
    <!-- jQuery and jQuery UI -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .reservation-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .datepicker {
            cursor: pointer;
        }
    </style>
    <script>
        $(function () {
            $("#datepicker").datepicker({
                dateFormat: "yy-mm-dd",
                minDate: 0,
                maxDate: "+1M",
                beforeShowDay: function (date) {
                    const day = date.getDay();
                    return [(day !== 0), '']; // 일요일 예약 불가
                }
            });
        });

        function submitForm() {
            const selectedDate = $("#datepicker").val();
            if (!selectedDate) {
                alert("날짜를 선택해주세요.");
                return false;
            }
            alert("예약 요청 중입니다...");
            return true;
        }
    </script>
</head>
<body>
    <div class="reservation-container">
        <h2 class="text-center text-primary mb-4">예약 서비스</h2>
        <form action="reserve.do" method="post" onsubmit="return submitForm();">
            <!-- 이름 입력 -->
            <div class="mb-3">
                <label for="name" class="form-label">이름</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="이름을 입력하세요" required>
            </div>
            <!-- 날짜 선택 -->
            <div class="mb-3">
                <label for="datepicker" class="form-label">예약 날짜</label>
                <input type="text" id="datepicker" name="reservationDate" class="form-control datepicker" readonly placeholder="날짜를 선택하세요" required>
            </div>
            <!-- 예약 버튼 -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary w-100">예약하기</button>
            </div>
        </form>
    </div>
</body>
</html>
