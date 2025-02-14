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
    font-family: Arial, sans-serif;
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
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

.login-container button:hover {
    background-color: #0056b3;
}
</style>
<script type="text/javascript">
    function actionLogin() {

        if (document.loginForm.userId.value == "") {
            alert("아이디를 입력하세요");
            return false;
        } else if (document.loginForm.userPassword.value == "") {
            alert("비밀번호를 입력하세요");
            return false;
        } else {
            document.loginForm.action = "<c:url value='actionLogin.do'/>";
            document.loginForm.submit();
        }
    }
    <!--

    function setCookie(name, value, expires) {
        document.cookie = name + "=" + escape(value) + "; path=/; expires="
                + expires.toGMTString();
    }

    function getCookie(Name) {
        var search = Name + "="
        if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
            offset = document.cookie.indexOf(search)
            if (offset != -1) { // 쿠키가 존재하면
                offset += search.length
                // set index of beginning of value
                end = document.cookie.indexOf(";", offset)
                // 쿠키 값의 마지막 위치 인덱스 번호 설정
                if (end == -1)
                    end = document.cookie.length
                return unescape(document.cookie.substring(offset, end))
            }
        }
        return "";
    }

    function saveid(form) {
        var expdate = new Date();
        // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
        if (form.checkId.checked)
            expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
        else
            expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
        setCookie("saveid", form.id.value, expdate);
    }

    function getid(form) {
        form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
    }

    function fnInit() {
        var message = document.loginForm.message.value;
        if (message != "") {
            alert(message);
        }
        getid(document.loginForm);
    }
    //-->
</script>
</head>
<body onload="initialize()">
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

                    <button type="button" onclick="actionLogin()">로그인</button>
                    <!-- <div style="text-align: center; margin: 10px 0;">--- 또는 ---</div> -->
                    <button style="text-align: center; margin: 20px 0;" type="button" onclick="window.location.href='/test1/signup.do'">회원가입</button>

                    <input type="hidden" name="message" value="${message}" />
                    <input type="hidden" name="userSe" value="USR" />
                </form:form>
            </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>
