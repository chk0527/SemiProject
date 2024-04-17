<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modify</title>
<c:set value="${pageContext.request.contextPath}/resources" var="resourceurl" scope="application"/>
<c:set value="${pageContext.request.contextPath}" var="contextPath" />
<link href="${resourceurl}/css/board/common.css" rel="stylesheet">
<link href="${resourceurl}/css/board/modify.css" rel="stylesheet">
</head>
<body>
<jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/include/header.jsp"/>
<div class="board-wrapper">
	<table class="table-top">
		<tr>
			<td align="left">
				<h2>수정하기</h2>
			</td>
		</tr>
	</table>
	<form action="${contextPath}/board/modify" method="POST">
		<input type="hidden" name="bno" value="${board.bno}">
		<table class="table-middle" width="80%">
			<tr>
				<td width="30%">분류</td>
					<td width="70%">
						<select name="btype" class="btype">
							<option value="정보공유" <c:if test="${board.btype eq '정보공유'}">selected="selected"</c:if>>정보공유</option>
							<option value="분실물" <c:if test="${board.btype eq '분실물'}">selected="selected"</c:if>>분실물</option>
							<option value="자유주제" <c:if test="${board.btype eq '자유주제'}">selected="selected"</c:if>>자유주제</option>
						</select>
					</td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="title" value="${board.title}" style="width:90%;"/></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" style="width:90%; height:100px">${board.content}</textarea></td>
			</tr>
<!-- 			<tr>
				<td colspan="2" align="center">
					<button type="submit">수정 완료</button>
					<button type="reset">다시 입력</button>
					<button type="button" onclick="location.href='/board/list'">목록 보기</button>
				</td>
			</tr> -->
		</table>
		<div class="modify-bottom">
			<button type="submit">수정 완료</button>
			<button type="reset">다시 입력</button>
			<button type="button" onclick="location.href='/board/list'">목록 보기</button>
		</div>
	</form>
</div>
</body>
</html>
