<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        회원가입
    </title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .signup-container {
            background: #ffffff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .signup-container h1 {
            margin-bottom: 1rem;
            font-size: 1.5rem;
            color: #333;
        }
        .signup-container form {
            display: flex;
            flex-direction: column;
        }
        .signup-container input {
            margin-bottom: 1rem;
            padding: 0.8rem;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .signup-container button {
            padding: 0.8rem;
            font-size: 1rem;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .signup-container button:hover {
            background-color: #0056b3;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
	function actionSignup() {
        var formData = {
            userId: $("#userId").val(),
            userPassword: $("#userPassword").val(),
            userName: $("input[name='userName']").val(),
            userEmail: $("input[name='userEmail']").val(),
            userPhone: $("input[name='userPhone']").val(),
            userBirth: $("input[name='userBirth']").val()
        };

        $.ajax({
            url: "<c:url value='/actionSignup.do'/>",  // 서버 URL
            type: "POST",
            data: formData,
            success: function(response) {
            	console.log(response)
                if (response.success) {
                    alert("회원가입이 완료되었습니다.");
                    window.location.href = "/login";  // 로그인 페이지로 리다이렉트
                } else {
                    alert("회원가입에 실패했습니다. 다시 시도해주세요.");
                }
            },
            error: function() {
                alert("서버 오류로 인해 회원가입에 실패했습니다.");
            }
        });
    }
	    
	    function checkDuplicateId(id) {
	        // 서버로 AJAX 요청하여 아이디 중복 확인
	        $.ajax({
	            url: "<c:url value='checkDuplicateId.do'/>",
	            type: "POST",
	            data: { id: id },
	            success: function(response) {
	                if (response.isDuplicate) {
	                    alert("이미 사용 중인 아이디입니다.");
	                } else {
	                    alert("사용 가능한 아이디입니다.");
	                }
	            }
	        });
	    }
	</script>
</head>
<body>
    <div class="signup-container">
        <h1>
           회원가입
        </h1>
       <%--  <form:form method="post" name="signupForm" action="actionSignup"> --%>
        <form:form modelAttribute="userVO" id="signupForm" name="signupForm">
        	<input type="text" id="userId" name="userId" placeholder="아이디" required onblur="checkDuplicateId(this.value)">
            <input type="password" id="userPassword" name="userPassword" placeholder="비밀번호" required>
            <input type="text" name="userName" placeholder="이름" required>
            <input type="email" name="userEmail" placeholder="이메일" required>
            <input type="tel" name="userPhone" placeholder="전화번호" required>
            <input type="date" name="userBirth" placeholder="생년월일" required>
            <button type="button" onclick="actionSignup()">회원가입</button>
        </form:form>
    </div>
</body>
</html>