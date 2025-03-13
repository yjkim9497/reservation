<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정</title>
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

        function editUser() {
            var formData = {
           		userPk: $("#userPk").val(), 
                userPassword: $("#userPassword").val(),
                userName: $("#userName").val(),
                userEmail: $("#userEmail").val(),
                userPhone: $("#userPhone").val(),
                userBirth: $("#userBirth").val()
            };
            
            console.log(formData)

            $.ajax({
                url: "<c:url value='/editUser.do'/>",  // 서버 URL
                type: "POST",
                data: formData,
                success: function(response) {
                	console.log(response.data)
                    console.log(response.message)
                    console.log(response.success)
                    if (response.success) {
                        alert("회원정보가 수정되었습니다.");
                        window.location.href = "/test1/mypage.do";  // 로그인 페이지로 리다이렉트
                    } else {
                        alert("회원 정보 수정에 실패했습니다. 다시 시도해주세요.");
                    }
                },
                error: function() {
                    alert("서버 오류로 인해 회원 정보 수정에 실패했습니다.");
                }
            });
        }
    </script>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="card shadow-lg p-4" style="max-width: 500px; width: 100%;">
            <h3 class="text-center mb-4">회원정보 수정</h3>
            <form id="signupForm">
             <input type="hidden" id="userPk" name="userPk" value="${user.userPk}">
                <div class="mb-3">
                    <label for="userId" class="form-label">아이디</label>
                    <div class="">
                        <span>${user.userId}</span>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="userPassword" class="form-label">비밀번호 수정</label>
                    <input type="password" class="form-control" id="userPassword" placeholder="비밀번호 수정" required>
                </div>
				<div class="mb-3">
				    <label for="userEmail" class="form-label">이메일</label>
				    <div class="input-group">
				        <input type="email" class="form-control" id="userEmail"
				               <c:if test="${not empty user.userEmail}"> placeholder="${user.userEmail}"</c:if> required>
				    </div>
				</div>
				
 <%--                <div class="mb-3">
                    <label for="userEmail" class="form-label">이메일</label>
                    <div class="input-group">
                        <input type="email" class="form-control" id="userEmail" placeholder="${user.userEmail}" required>
                    </div>
                </div> --%>

                <div class="mb-3">
                    <label for="userName" class="form-label">이름</label>
                    <input type="text" class="form-control" id="userName" placeholder="${user.userName}" required>
                </div>
                
				<div class="mb-3">
				    <label for="userPhone" class="form-label">전화번호</label>
				    <div class="input-group">
				        <input type="tel" class="form-control" id="userPhone"
				               <c:if test="${not empty user.userPhone}"> placeholder="${user.userPhone}"</c:if> required>
				    </div>
				</div>

                <%-- <div class="mb-3">
                    <label for="userPhone" class="form-label">전화번호</label>
                    <div class="input-group">
                        <input type="tel" class="form-control" id="userPhone" placeholder="${user.userPhone }" required>
                    </div>
                </div> --%>

                <div class="mb-3">
                    <label for="userBirth" class="form-label">생년월일</label>
                    <input type="date" class="form-control" id="userBirth" required>
                </div>

                <button type="button" class="btn btn-primary w-100" onclick="editUser()">회원정보수정</button>
            </form>
        </div>
    </div>
</body>
</html>
