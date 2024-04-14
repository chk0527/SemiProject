<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write</title>
<c:set value="${pageContext.request.contextPath}/resources" var="resourceurl" scope="application"/>
<c:set value="${pageContext.request.contextPath}" var="contextPath" />
<link href="${resourceurl}/css/board/common.css" rel="stylesheet">
<link href="${resourceurl}/css/board/write.css" rel="stylesheet">
</head>
<body>
<jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/include/header.jsp"/>
<div class="board-wrapper">
<!-- 로그인여부 확인 -->
	<%-- <c:import url='${application.contextPath}/users/isLoggedIn.jsp'/> --%>
	<table class="table-top">
		<tr>
			<td align="left">
				<h2>글 작성하기</h2>
			</td>
		</tr>
	</table>
	<form action="${contextPath}/board/write.bo" method="POST">
		<table class="table-middle" width="80%">
			<tr>
				<td width="30%">분류</td>
				<td width="70%">
				<select name="btype" class="btype">
					<option value="정보공유">정보공유</option>
					<option value="분실물">분실물</option>
					<option value="자유주제">자유주제</option>
				</select>
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="title" style="width:90%;"/></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" style="width:90%; height:100px"></textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit">작성완료</button>
					<button type="reset">다시 입력</button>
					<button type="button" onclick="location.href='${contextPath}/board/board.bo';">목록 보기</button>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>