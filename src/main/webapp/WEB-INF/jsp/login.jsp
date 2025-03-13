<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="content-language" content="ko">
<title>로그인</title>
<style>
body {
    margin: 0;
    font-family: pretendard;
    background-color: #f4f4f4;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.login-container {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    width: 100%;
    max-width: 400px;
    margin: 20px; /* 추가: 양쪽 끝에서 간격을 확보 */
}

.login-container h1 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
}

.login-container label {
    display: block;
    font-size: 14px;
    margin-bottom: 8px;
    color: #555;
}

.login-container input[type="text"], .login-container input[type="password"] {
    width: calc(100% - 20px); /* 좌우 간격 추가 */
    padding: 10px;
    margin-bottom: 20px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
}

.login-container input[type="checkbox"] {
    margin-right: 8px;
}

.login-container .checkbox-container {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.login-container button {
    width: 100%;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    margin-top: 5px;
}

.login-container button:hover {
    background-color: #0056b3;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	/*  $(document).ready(function () {
	    var message = `${'${message}'}`;
	    if (message.trim() !== "") {
	        alert(message);
	        return false;
	    }
	}); */ 
	
	async function actionLogin() {
	    const userId = document.getElementById("userId").value;
	    const userPassword = document.getElementById("userPassword").value;

	    if (userId.trim() === "") {
	        alert("아이디를 입력하세요");
	        return;
	    }
	    if (userPassword.trim() === "") {
	        alert("비밀번호를 입력하세요");
	        return;
	    }

	    const loginData = { userId, userPassword };

	    try {
	        const response = await fetch("/test1/actionLogin.do", {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/json"
	            },
	            body: JSON.stringify(loginData)
	        });

	        const result = await response.json();

	        if (result.status === "success") {
	            alert(result.message);
	            window.location.href = "/test1/main.do"; 
	        } else {
	            alert(result.message); // 로그인 실패 메시지 출력
	        }
	    } catch (error) {
	        alert("서버 오류 발생: " + error.message);
	    }
	}

    function kakaoLogin() {
    	location.href = 'https://kauth.kakao.com/oauth/authorize?client_id=86deb5ba96687995c0fd88d76e9f9008&redirect_uri=http://localhost:8081/test1/kakaoLogin.do&response_type=code';
    	}
</script>
</head>
<body>
    <noscript>자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>
    <!-- 전체 레이어 시작 -->

            <div class="login-container">
                <h1>로그인</h1>
                <form:form name="loginForm" method="post" action="actionLogin">
                    <label for="id">아이디</label>
                    <input type="text" id="userId" name="userId" maxlength="10"
                        placeholder="아이디를 입력하세요" />

                    <label for="password">비밀번호</label>
                    <input type="password" id="userPassword" name="userPassword"
                        maxlength="25" placeholder="비밀번호를 입력하세요"
                        onkeydown="if (event.keyCode === 13) actionLogin();" />

                    <div class="checkbox-container">
                        <input type="checkbox" id="checkId" name="checkId"
                            onclick="saveId(this.form);" /> <label for="checkId">아이디
                            저장</label>
                    </div>

                    <div style="text-align: center;">
					    <button type="button" onclick="actionLogin()" 
					        style="display: block; background-color: black; width: 100%; margin-bottom: 10px;">
					        로그인
					    </button>
					    
					    <button type="button" onclick="kakaoLogin()" 
					        style="display: block; background-color: #FEE500; width: 100%;">
					        카카오로 로그인
					    </button>
					</div>
					
					<a href="/test1/signup.do" 
					   style="display: block; text-align: right;  font-size: 12px; color: black; text-decoration: none; margin-top: 10px;">
					    회원가입
					</a>

                    <input type="hidden" name="message" value="${message}" />
                    <input type="hidden" name="userSe" value="USR" />
                </form:form>
            </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>
