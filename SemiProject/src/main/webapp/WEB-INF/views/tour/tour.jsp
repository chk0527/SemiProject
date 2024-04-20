<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>tourlist</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
    rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
    crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
    crossorigin="anonymous"></script>
<link rel="stylesheet" href="${contextPath }/resources/css/tour/tour.css">

<style>

</style>
</head>
<body>
<c:set var="contextPath" value="<%=request.getContextPath()%>" scope="application"></c:set>
<header>
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/include/header.jsp" />
</header>

<div id="tour_wrapper">
    <div class="left-box">
        <div class="side_tab">
            <div class="page_tag">
                <div class="tour_category"><h1>여행지</h1></div>
                <div class="hstack gap-3">
                    <input class="form-control me-auto" type="text" placeholder="검색" aria-label="검색">
                    <input type="button" class="btn btn-secondary" value="검색">
                </div>
            </div>
        </div>
    </div>
    <div class="right-box">
        <div class="container">
            <div class="row row-3" align="center">
                <c:forEach items="${tList}" var="item">
                    <div class="col-4">
                        <div class="m-1">
                            <div class="card" style="width:24rem;" align="center">
                                <img src="${item.firstimage}" class="card-img-top" alt="1"
                                    onerror="this.src='../../resources/images/tour_none_image.png'"
                                    style="height: 300px">
                                <div class="card-body">
                                    <p class="card-title">${item.title}</p><br/>
                                    <p class="card-text" style="font-size: 14px">${item.addr1} ${item.addr2}</p>
                                    <p class="text-body-secondary"><a
                                            href="${contextPaht }/tour/detail?contentid=${item.contentid}&title=${item.title}&mapy=${item.mapy}&mapx=${item.mapx}&firstimage=${item.firstimage}"
                                            class="btn">세부 정보</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="pagination">
            <hr style="margin-bottom: 10px">
            <c:set var="page" value="${param.page != null ? param.page : 1}" />
            <c:set var="endPage" value="${Math.ceil(page/10)*10}" />
            <c:set var="startPage" value="${endPage-9}" />
            <!-- 이전 페이지로 이동하는 버튼 -->
            <a href="${contextPath}/tour/list?page=${page - 1}" class="page-link prev-page-link"  data-page="${endPage - 1}">&laquo; Prev</a>
    
            <!-- 페이지 링크를 동적으로 생성 -->
            
			
            <c:forEach var="i" begin="${startPage}" end="${endPage}" varStatus="loop">
                <c:if test="${i <= totalPages}">
                    <a href="${contextPath}/tour/list?page=${i}" class="page-link" data-page="${i}">${i}</a>
                </c:if>
            </c:forEach>
    
            <!-- 다음 페이지로 이동하는 버튼 -->
            <c:if test="${endPage < totalPages}">
                <a href="${contextPath}/tour/list?page=${endPage + 1}" class="page-link next-page-link"
                    data-page="${endPage + 1}">Next &raquo;</a>
            </c:if>
        </div>
    </div>
</div>
<%-- <jsp:include page="footer.jsp"/> --%>

<script>
    $(document).ready(function () {
        $('.pagination a').click(function (event) {
            event.preventDefault(); // 기본 링크 동작 방지
            var nextPage = parseInt($(this).attr('data-page')); // 클릭된 페이지 번호 가져오기
            updatePagination(nextPage); // pagination 업데이트
        });
    });

    function updatePagination(nextPage) {
        var totalPages = ${totalPages}; // 전체 페이지 수 가져오기 (JSP 변수로부터)
        var startPage = nextPage - (nextPage % 10) + 1; // 시작 페이지 계산
        var endPage = Math.min(startPage + 9, totalPages); // 끝 페이지 계산

        // 페이지 링크 업데이트
        var paginationHtml = '';

        if (startPage > 1) {
            paginationHtml += '<a href="${contextPath}/tour/list?page=' + (startPage - 10) + '" class="page-link prev-page-link">&laquo; Prev</a>';
        }

        for (var i = startPage; i <= endPage; i++) {
            paginationHtml += '<a href="${contextPath}/tour/list?page=' + i + '" class="page-link">' + i + '</a>';
        }

        if (endPage < totalPages) {
            paginationHtml += '<a href="${contextPath}/tour/list?page=' + (endPage + 1) + '" class="page-link next-page-link" data-page="' + (endPage + 1) + '">Next &raquo;</a>';
        }

        // pagination 엘리먼트 업데이트
        $('.pagination').html(paginationHtml);
    }
</script>
</body>
</html>