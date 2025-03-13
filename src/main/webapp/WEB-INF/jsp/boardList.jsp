<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="currentPage" value="board" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../resouces/font/pretendard.css">
    <style>
    	* {
            font-family: 'pretendard';
        }
        body {
            background-color: #f8f9fa;
            font-family: 'pretendard';
        }
        .table th, .table td {
	        white-space: nowrap; /* 텍스트 줄바꿈 방지 */
	        overflow: hidden; /* 넘치는 내용 숨김 */
	        text-overflow: ellipsis; /* 넘치는 부분 "..." 처리 */
	    }
	    
	    /* No 열 크기 작게 */
	    .col-no {
	        width: 5%;
	    }
	
	    /* 제목 열 크기 길게 */
	    .col-title {
	        width: 50%;
	    }
	
	    /* 나머지 열 일정한 크기 */
	    .col-user, .col-seminar, .col-date {
	        width: 15%;
	    }
    </style>
</head>
<body>
    <div class="container mt-4">
        <!-- Title Section -->
        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
		    <li class="breadcrumb-item active" aria-current="page">질문게시판</li>
		  </ol>
		</nav>
    	<h2 class="mb-4">질문게시판</h2>

        <!-- Search Section -->
        <div class="card p-3 mb-4 d-flex align-items-center" style="height: 70px;">
    <form:form modelAttribute="searchVO" id="listForm" name="listForm" method="get" class="w-100">
        <div class="row align-items-center">
            <div class="col-md-2">
                <form:select path="searchCondition" cssClass="form-select">
                    <form:option value="0" label="제목" />
                    <form:option value="1" label="내용" />
                </form:select>
            </div>
            <div class="col-md-8">
                <form:input path="searchKeyword" cssClass="form-control" placeholder="검색어를 입력하세요" />
            </div>
            <div class="col-md-2 text-end">
                <button type="button" class="btn btn-primary" onclick="fn_egov_selectList();">
                    검색
                </button>
            </div>
        </div>
        <form:hidden path="pageIndex" />
    </form:form>
</div>


        <!-- Table Section -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
    <thead class="table-light">
        <tr>
            <th scope="col" class="text-center col-no">No</th>
            <th scope="col" class="text-center col-title">제목</th>
            <th scope="col" class="text-center col-user">사용자</th>
            <th scope="col" class="text-center col-seminar">세미나</th>
            <th scope="col" class="text-center col-date">등록일</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="result" items="${resultList}" varStatus="status">
            <tr>
                <td class="text-center col-no">
                    <c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}" />
                </td>
                <td class="col-title">
                    <a href="<c:url value='/boardDetail.do?boardPk=${result.boardPk}' />" class="d-inline-block text-truncate" style="max-width: 100%;">
                        <c:out value="${result.boardTitle}" />
                        (<c:out value="${result.commentCount}" />)
                    </a>
                </td>
                <td class="text-center col-user">
                    <c:out value="${result.userName != null ? result.userName : '비회원'}" />
                </td>
                <td class="text-center col-seminar">
                    <c:out value="${result.seminarName != null ? result.seminarName : '기타'}" />
                </td>
                <td class="text-center col-date">
                    <fmt:formatDate value="${result.boardRegDate}" pattern="yyyy-MM-dd" />
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
        </div>

        <!-- Pagination Section -->
        <div class="d-flex justify-content-center mt-4">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
        </div>

        <!-- Buttons Section -->
        <div class="d-flex justify-content-between mt-4">
            <button class="btn btn-success" onclick="fn_egov_addView();">
                등록하기
            </button>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function fn_egov_addView() {
        document.listForm.action = "<c:url value='/addBoard.do'/>";
        document.listForm.submit();
    } 
    
    function fn_egov_selectList() {
        document.listForm.action = "<c:url value='/boardList.do'/>";
        document.listForm.submit();
    }
    function fn_egov_link_page(pageNo) {
        document.listForm.pageIndex.value = pageNo; // 선택한 페이지 번호 설정
        document.listForm.action = "<c:url value='/boardList.do'/>";
        document.listForm.submit(); // 폼 전송
    }
    </script>
</body>
<%@ include file="footer.jsp" %>
</html>
