<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="seminar" />
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세미나 목록</title>
    <link href="../../resouces/font/pretendard.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
    	* {
            font-family: 'pretendard';
        }
        body {
            font-family: 'pretendard';
            background-color: #f8f9fa;
        }
        .seminar-card {
            transition: transform 0.2s, box-shadow 0.2s;
            height: 500px;
        }
        .seminar-card:hover {
            transform: scale(1.05);
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }
        .seminar-image {
            height: 180px;
            object-fit: cover;
        }
        .card-body{
        	height: 140px;
        }
        a {
		    text-decoration: none !important;
		}
        footer {
		    margin-bottom: 0;
		    padding-bottom: 0;
		}
    </style>
</head>
<body>

<!-- 컨텐츠 -->
<div class="container mt-4">
<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="/test1">홈</a></li>
    <li class="breadcrumb-item active" aria-current="page">세미나</li>
  </ol>
</nav>
    <h2 class="mb-4">세미나</h2>

    <!-- 세미나 목록이 여기에 동적으로 추가됨 -->
    <div class="row" id="seminar-container"></div>
</div>

<!-- jQuery 추가 (AJAX 요청을 위해 필요) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
var contextPath = "${pageContext.request.contextPath}";
$(document).ready(function() {
    $.ajax({
        url: "/test1/seminar/all.do", // 세미나 목록을 가져오는 컨트롤러 URL
        type: "GET",
        dataType: "json",
        success: function(data) {
            let seminarHtml = "";
            $.each(data, function(index, seminar) {
                seminarHtml += `
                    <div class="col-md-4 mb-4">
                        <div class="card seminar-card">
                            <img src="<c:url value="${'${seminar.seminarFilePath}'}" />" class="card-img-top seminar-image" alt="세미나 이미지">
                                <a style="text-decoration: none !important; color:black;" href="/test1/seminar/detail.do?seminarPk=${'${seminar.seminarPk}'}">
		                            <div class="card-body">
		                                <h5 class="card-title">${'${seminar.seminarName}'}</h5>
		                                <p class="card-text"><i class="bi bi-geo-alt"></i> ${'${seminar.seminarPlace}'}</p>
		                            </div>
                                </a>
                        </div>
                    </div>
                `;
            });
            $("#seminar-container").html(seminarHtml);
        },
        error: function(xhr, status, error) {
            console.error("세미나 목록을 불러오는 중 오류 발생:", error);
            $("#seminar-container").html("<p class='text-center text-danger'>세미나 정보를 불러올 수 없습니다.</p>");
        }
    });
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="footer.jsp" %>
</html>
