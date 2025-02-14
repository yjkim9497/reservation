<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        form {
            width: 50%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
        }
        input, textarea, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   	<script type="text/javaScript">
	        
	    /* 글 등록 화면 function */
	    function addBoard() {
	    	var formData = {
	    	boardTitle: $("#boardTitle").val(),
	    	boardDescription: $("#boardDescription").val()
	    	};
	    	
	    	$.ajax({
	    	    url: "<c:url value='/addBoard.do'/>",
	    	    type: "POST",
	    	    contentType: "application/json", // ✅ JSON 형식 명시
	    	    dataType: "json", // ✅ JSON 응답을 받을 것이라고 명시
	    	    data: JSON.stringify({
	    	        boardTitle: $("#boardTitle").val(),
	    	        boardDescription: $("#boardDescription").val()
	    	    }),
	    	    success: function(response) {
	    	        console.log(response); // ✅ JSON 형태로 로그 확인
	    	        if (response.success) {
	    	            alert("게시글이 등록되었습니다.");
	    	            window.location.href = "/test1/boardList.do";
	    	        } else {
	    	            alert("게시글 등록에 실패했습니다. 다시 시도해주세요.");
	    	        }
	    	    },
	    	    error: function(xhr, status, error) {
	    	        console.error("오류 발생:", error);
	    	        alert("서버 오류로 인해 게시글 등록에 실패했습니다.");
	    	    }
	    	});

	    }
	
	</script>
</head>
<body>

<h2>게시글 등록</h2>

<form:form modelAttribute="boardVO" id="boardForm" name="boardForm">
    <label for="boardTitle">제목</label>
    <form:input path="boardTitle" id="boardTitle" required="required"/>

    <label for="boardDescription">내용</label>
    <form:textarea path="boardDescription" id="boardDescription" rows="5" required="required"/>

    <!-- 사용자 ID는 로그인된 유저 정보를 가져와 자동으로 설정 -->
    <form:hidden path="userPk" value="${sessionScope.loginUser.userPk}" />

    <button type="button" onclick="addBoard()">등록</button>
</form:form>

</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</html>
