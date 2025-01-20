<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5">
        <!-- Title Section -->
        <div class="text-center mb-4">
            <h1 class="display-6">질문게시판</h1>
        </div>

        <!-- Search Section -->
        <div class="card p-3 mb-4">
            <form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <form:select path="searchCondition" cssClass="form-select">
                            <form:option value="1" label="Name" />
                            <form:option value="0" label="ID" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <form:input path="searchKeyword" cssClass="form-control" placeholder="검색어를 입력하세요" />
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="button" class="btn btn-primary" onclick="fn_egov_selectList();">
                            검색
                        </button>
                    </div>
                </div>
            </form:form>
        </div>

        <!-- Table Section -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th scope="col" class="text-center">No</th>
                        <th scope="col" class="text-center"><spring:message code="title.sample.id" /></th>
                        <th scope="col" class="text-center"><spring:message code="title.sample.name" /></th>
                        <th scope="col" class="text-center"><spring:message code="title.sample.useYn" /></th>
                        <th scope="col" class="text-center"><spring:message code="title.sample.description" /></th>
                        <th scope="col" class="text-center"><spring:message code="title.sample.regUser" /></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td class="text-center">
                                <c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}" />
                            </td>
                            <td class="text-center">
                                <a href="javascript:fn_egov_select('<c:out value="${result.id}"/>')"><c:out value="${result.id}"/></a>
                            </td>
                            <td><c:out value="${result.name}" /></td>
                            <td class="text-center"><c:out value="${result.useYn}" /></td>
                            <td><c:out value="${result.description}" /></td>
                            <td class="text-center"><c:out value="${result.regUser}" /></td>
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
            <div>
                <a href="<c:url value='/login.do'/>" class="btn btn-primary">로그인</a>
                <a href="<c:url value='/signup.do'/>" class="btn btn-secondary">회원가입</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function fn_egov_addView() {
        document.listForm.action = "<c:url value='/addSample.do'/>";
        document.listForm.submit();
    } 
        // 기존 JavaScript 함수 유지
/*         function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateSampleView.do'/>";
            document.listForm.submit();
        }

        function fn_egov_addView() {
            document.listForm.action = "<c:url value='/addSample.do'/>";
            document.listForm.submit();
        } 

        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/egovSampleList.do'/>";
            document.listForm.submit();
        }

        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/egovSampleList.do'/>";
            document.listForm.submit();
        } */
    </script>
</body>
</html>
