<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: 'pretendard';
            background-color: #f5f5f5;
        }
     /*    .signup-container {
            background: #ffffff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
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
        .text-danger {
            color: red;
            font-size: 0.875rem;
        } */
        .text-danger {
            color: red;
            font-size: 0.875rem;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {
            const phoneInput = document.getElementById("userPhone");
            const phoneError = document.getElementById("phoneError");

            const emailInput = document.getElementById("userEmail");
            const emailError = document.getElementById("emailError");

            const passwordInput = document.getElementById("userPassword");
            const confirmPasswordInput = document.getElementById("confirmPassword");
            const passwordError = document.getElementById("passwordError");

            const userIdInput = document.getElementById("userId");
            const idError = document.getElementById("idError");

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

            confirmPasswordInput.addEventListener("input", function() {
                if (passwordInput.value !== confirmPasswordInput.value) {
                    passwordError.style.display = "block";
                    confirmPasswordInput.classList.add("is-invalid");
                } else {
                    passwordError.style.display = "none";
                    confirmPasswordInput.classList.remove("is-invalid");
                }
            });

            function submitReservation() {
                if (phoneError.style.display === "block" || emailError.style.display === "block" || passwordError.style.display === "block" || idError.style.display === "block") {
                    alert("입력값을 확인해주세요.");
                    return;
                }

                document.getElementById("signupForm").submit();
            }

            window.submitReservation = submitReservation;
        });

        function actionSignup() {
            var formData = {
                userId: $("#userId").val(),
                userPassword: $("#userPassword").val(),
                userName: $("#userName").val(),
                userEmail: $("#userEmail").val(),
                userPhone: $("#userPhone").val(),
                userBirth: $("#userBirth").val()
            };
            
            console.log(formData)

            $.ajax({
                url: "<c:url value='/actionSignup.do'/>",  // 서버 URL
                type: "POST",
                data: formData,
                success: function(response) {
                	console.log(response.data)
                    console.log(response.message)
                    console.log(response.success)
                    if (response.success) {
                        alert("회원가입이 완료되었습니다.");
                        window.location.href = "/test1/login.do";  // 로그인 페이지로 리다이렉트
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
                url: "<c:url value='/checkDuplicateId.do'/>",
                type: "POST",
                data: { id: id },
                success: function(response) {
                    if (response.isDuplicate) {
                        alert("이미 사용 중인 아이디입니다.");
                        document.getElementById("idError").style.display = "block";
                    } else {
                        alert("사용 가능한 아이디입니다.");
                        document.getElementById("idError").style.display = "none";
                    }
                }
            });
        }
    </script>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="card shadow-lg p-4" style="max-width: 500px; width: 100%;">
            <h3 class="text-center mb-4">회원가입</h3>
            <form id="signupForm">
                <div class="mb-3">
                    <label for="userId" class="form-label">아이디</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="userId" placeholder="아이디 입력" required>
                    </div>
                    <small class="text-danger d-none" id="idError">이미 사용 중인 아이디입니다.</small>
                    <button type="button" class="btn btn-outline-info w-100 mt-2" onclick="checkDuplicateId($('#userId').val())">아이디 중복 확인</button>
                </div>

                <div class="mb-3">
                    <label for="userPassword" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="userPassword" placeholder="비밀번호 입력" required>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" id="confirmPassword" placeholder="비밀번호 재입력" required>
                    <small class="text-danger" id="passwordError" style="display: none;">비밀번호가 일치하지 않습니다.</small>
                </div>

                <div class="mb-3">
                    <label for="userEmail" class="form-label">이메일</label>
                    <div class="input-group">
                        <input type="email" class="form-control" id="userEmail" placeholder="example@email.com" required>
                    </div>
                    <small class="text-danger" id="emailError" style="display: none;">올바른 이메일 형식이 아닙니다 (예: example@email.com)</small>
                </div>

                <div class="mb-3">
                    <label for="userName" class="form-label">이름</label>
                    <input type="text" class="form-control" id="userName" placeholder="이름 입력" required>
                </div>

                <div class="mb-3">
                    <label for="userPhone" class="form-label">전화번호</label>
                    <div class="input-group">
                        <input type="tel" class="form-control" id="userPhone" placeholder="01012345678" required>
                    </div>
                    <small class="text-danger" id="phoneError" style="display: none;">휴대폰 번호 형식이 올바르지 않습니다 (예: 01012345678)</small>
                </div>

                <div class="mb-3">
                    <label for="userBirth" class="form-label">생년월일</label>
                    <input type="date" class="form-control" id="userBirth" required>
                </div>

                <button type="button" class="btn btn-primary w-100" onclick="actionSignup()">회원가입</button>
            </form>
        </div>
    </div>
</body>
</html>
