<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="board" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<link href="../../resouces/font/pretendard.css">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <style>
        body {
            font-family: 'pretendard';
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

    <script type="text/javascript">
        function editBoard() {
        	var formData = new FormData();
        	formData.append("boardPk", $("#boardPk").val()); 
            formData.append("boardTitle", $("#boardTitle").val());
            formData.append("boardDescription", $("#boardDescription").val());
            formData.append("boardPassword", $("#boardPassword").val());
            
            var fileInput = $("#file")[0].files;
            if (fileInput.length > 0) {
                formData.append("file", fileInput[0]); // 파일이 있을 때만 추가
            }
            
            console.log('formData board : ', formData.get("boardTitle"));
            console.log('formData des : ', formData.get("boardDescription"));
            console.log('formData pass : ', formData.get("boardPassword"));
            console.log('formData file : ', formData.get("file"));
            $.ajax({
                url: "<c:url value='/editBoard.do'/>",
                type: "POST",
                data: formData, 
                processData: false,  
                contentType: false,  
                success: function(response) {
                    console.log(response);
                    if (response.success) {
                        alert("게시글이 수정되었습니다.");
                        window.location.href = "/test1/boardList.do";
                    } else {
                        alert("게시글 수정에 실패했습니다. 다시 시도해주세요.");
                    }
                },
                error: function(xhr, status, error) {
                	console.log(formData)
                    console.error("오류 발생:", error);
                    alert("서버 오류로 인해 게시글 수정이 실패했습니다.");
                }
            });

            return false; // 폼 기본 제출 방지
        }
        
        $("#boardForm").on("submit", function(event) {
            event.preventDefault();
            editBoard();
        });

    </script>

</head>
<body>
<div class="container mt-4">
        <!-- Title Section -->
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item"><a href="/test1/boardList.do">질문게시판</a></li>
		    <li class="breadcrumb-item active" aria-current="page">게시글 등록</li>
		  </ol>
		</nav>
    	<h2 class="mb-4">질문게시판</h2>

<form id="boardForm" enctype="multipart/form-data" onsubmit="return editBoard();">
<input type="hidden" name="boardPk" id="boardPk" value="${board.boardPk}" />
    <label for="boardTitle">제목</label>
    <input type="text" name="boardTitle" id="boardTitle" placeholder="${board.boardTitle}" required/>
   	
   	<!-- <label for="seminarPk">세미나</label> -->
	<div class="form-group mt-2 mb-2">
	    <select class="form-select" name="seminarPk" id="seminarPk" required>
	        <option value="">세미나를 선택하세요</option>
	        <c:forEach var="seminar" items="${seminars}">
	            <option value="${seminar.seminarPk}">${seminar.seminarName}</option>
	        </c:forEach>
	    </select>
	</div>


    <label for="boardDescription">내용</label>
    <textarea name="boardDescription" id="boardDescription" rows="5" placeholder="${board.boardDescription}" required></textarea>

    <label for="file">파일</label>
    <input type="file" name="file" id="file"/>

    <label for="boardPassword">비밀번호</label>
    <input type="password" name="boardPassword" id="boardPassword" required/>

    <!-- 사용자 ID는 로그인된 유저 정보를 가져와 자동으로 설정 -->
    <input type="hidden" name="userPk" value="${sessionScope.loginUser.userPk}" />

    <button type="submit">등록</button>
</form>
</div>
</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</html>
