<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="currentPage" value="board" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>게시글 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { 
	        background-color: #f8f9fa; 
	        font-family: 'pretendard';
        }
        .card { border-radius: 10px; }
        .btn-custom { background-color: #007bff; color: white; }
    </style>
</head>
<body>
    <div class="container mt-4 my-5">
    	 <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item active"><a href="/test1/boardList.do">질문게시판</a></li>
		  </ol>
		</nav>
    	<h2 class="mb-4">질문게시판</h2>
        <div class="row justify-content-center">
            <div class="card shadow-sm p-4">
			    <div class="card-header bg-primary text-white">
			        <h3 class="card-title mb-0"><c:out value="${board.boardTitle}" /></h3>
			    </div>
			    <div class="card-body">
			        <div class="d-flex justify-content-between align-items-center">
			            <span class="text-muted text-end">📅 등록일: <c:out value="${board.boardRegDate}" /></span>
			    	<div class="text-end">
			            <button class="btn btn-warning" onclick="verifyPassword(${board.boardPk}, 'edit')">수정</button>
       					<button class="btn btn-danger" onclick="verifyPassword(${board.boardPk}, 'delete')">삭제</button>
			    	</div>
			        </div>
			        <hr>
			        <c:choose>
					    <c:when test="${not empty seminar}">
					        <p class="card-text" style="white-space: pre-line;">관련 세미나 : <c:out value="${seminar}" /></p>
					    </c:when>
					    <c:otherwise>
					        <p class="card-text" style="white-space: pre-line;">관련 세미나 : 기타</p>
					    </c:otherwise>
					</c:choose>

			        <hr>
			        <p class="card-text" style="white-space: pre-line;"><c:out value="${board.boardDescription}" /></p>
			        
			        <c:if test="${board.boardFileName ne null}">
			            <hr>
			            <div class="d-flex align-items-center">
			                <span class="me-2 fw-bold">📎 첨부파일:</span>
			                <a href="fileDownload.do?boardFileName=${board.boardFileName}" class="btn btn-outline-primary btn-sm">
			                    <i class="bi bi-download"></i> <c:out value="${board.boardFileName}" />
			                </a>
			            </div>
			        </c:if>
			    </div>
			    <div class="card-footer text-end">
			        <button class="btn btn-secondary" onclick="goBack()">
			            <i class="bi bi-arrow-left"></i> 목록으로 돌아가기
			        </button>
			    </div>
			</div>
                <!-- 댓글 섹션 -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h5>댓글</h5>
                        <ul id="commentList" class="list-group list-group-flush"></ul>
                        
                        <!-- 댓글 작성 -->
                        <div class="mt-3">
                            <textarea id="commentText" class="form-control" placeholder="댓글을 입력하세요"></textarea>
                            <button class="btn btn-custom mt-2" onclick="addComment()">등록</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const boardPk = ${board.boardPk};
        var userRole = "${sessionScope.LoginVO.userRole}";
        
        $(document).ready(function () {
            loadComments();
        });
        function verifyPassword(boardPk, action) {
            const password = prompt("게시글 비밀번호를 입력하세요:");
            if (!password) return; // 입력하지 않으면 취소
            
            fetch('/test1/board/verifyPassword.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ boardPk, password })
            })
            .then(response => {
                // 응답 상태 및 내용을 콘솔에 출력
                console.log('Response:', response);
                return response.json();  // JSON 응답을 반환
            })
            .then(data => {
                // 데이터 확인용 콘솔 출력
                console.log('Data:', data);

                if (data.success) {
                    if (action === 'edit') {
                        window.location.href = `/test1/editBoard.do?boardPk=${'${boardPk}'}`;
                    } else if (action === 'delete') {
                        if (confirm("정말 삭제하시겠습니까?")) {
                            fetch('/test1/board/delete.do', {
                                method: 'DELETE',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ boardPk })
                            })
                            .then(response => {
                                // 삭제 응답 확인용 콘솔 출력
                                console.log('Delete Response:', response);
                                return response.json();  // JSON 응답을 반환
                            })
                            .then(data => {
                                // 삭제 데이터 확인용 콘솔 출력
                                console.log('Delete Data:', data);

                                if (data.success) {
                                    alert("삭제되었습니다.");
                                    window.location.href = "/test1/boardList.do";
                                } else {
                                    alert("삭제에 실패했습니다.");
                                }
                            });
                        }
                    }
                } else {
                    alert("비밀번호가 일치하지 않습니다.");
                }
            })
            .catch(error => {
                console.error('Error:', error);  // 네트워크 에러 등 출력
            });
        }

        function loadComments() {
            $.get(`/test1/comment/list/${'${boardPk}'}.do`, function (comments) {
                $('#commentList').empty();
                comments.forEach(comment => {
                    let buttons = '';

                    // userRole이 'ADMIN'이면 버튼 추가
                    if (userRole === 'ADMIN') {
                        buttons = `
                            <button class="btn btn-sm btn-outline-secondary" onclick="deleteComment('${'${comment.commentPk}'}')">삭제</button>
                        `;
                    }

                    $('#commentList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center border-bottom">
                            <span>${'${comment.commentDescription}'}</span>
                            <div>${'${buttons}'}</div>
                        </li>`
                    );
                });
            });
        }


        function addComment() {
            const commentDescription = $('#commentText').val();
            /* $.post('/test1/comment/add.do', JSON.stringify({ boardPk, commentDescription }), function () {
                $('#commentText').val('');
                loadComments();
            }, 'json'); */
            fetch(`/test1/comment/add.do`,{
            	method: 'POST',
            	headers: {'Content-Type': 'application/json'},
            	body: JSON.stringify({boardPk, commentDescription})
            })
            .then(response => response.json())
            .then(data => {
            	alert(data)
            	$('#commentText').val('');
            	loadComments();
            })
        }

        function editComment(commentPk) {
            const newContent = prompt("수정할 내용을 입력하세요:");
            if (newContent) {
                $.ajax({
                    url: '/test1/comment/update',
                    type: 'PUT',
                    data: JSON.stringify({ commentPk, commentDescription: newContent }),
                    contentType: 'application/json',
                    success: loadComments
                });
            }
        }

        function deleteComment(commentPk) {
            if (confirm("정말 삭제하시겠습니까?")) {
            	console.log(commentPk)
            	fetch(`/test1/comment/delete.do`, {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify( commentPk )
                })
                .then(response => {
                    response.text()
                })
                .then(data => {
                    // 삭제 데이터 확인용 콘솔 출력
                    console.log('Delete Data:', data);
                        alert("삭제되었습니다.");
                        loadComments();
                });
               /*  $.ajax({
                    url: '/test1/comment/delete',
                    type: 'DELETE',
                    data: JSON.stringify({ commentPk }),
                    contentType: 'application/json',
                    success: loadComments
                }); */
            }
        }

        function goBack() {
            window.history.back();
        }
    </script>
</body>
</html>
