<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:set var="contextPath" value='${pageContext.request.contextPath}'/>
<c:set value="${pageContext.request.contextPath}/resources" var="resourceurl" scope="application"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="${contextPath}/resources/css/course/course_detail.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=247193dfa28ad4e983e0bea6bc9fd614"></script>
</head>
<body>
<jsp:include page="${contextPath }/WEB-INF/views/include/header.jsp"></jsp:include>
<div id="course_detail_wrapper">
	<div class="left_box">
		<div class="side_tab">
				<a href="${contextPath}/course/allList"><span class="spread-underline checked">여행코스 검색</span></a><br>
				<a href="${contextPath}/course/write"><span class="spread-underline">여행코스 만들기</span></a>
		</div>
	</div>
	<div class="right_box">
		<!-- 여행코스 세부 페이지 -->
		<div class="title">
			<blockquote>
			 	<p>${course.title}</p>
			</blockquote>
		</div>
		<div class="container">
		<div class="writer-text">
			<c:choose>
				<c:when test="${course.id == 'admin'}">
					<span class="writer" style="background:#0D689C; color:#FFFFFF;">한국관광공사 제공</span>
				</c:when>
				<c:otherwise>
					<span class="writer" style="background:#c4deff; color:#000000;">작성자 : ${course.id}</span>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="overview-text">
			<blockquote>
				<pre id="preoverview">${course.overview}</pre>
			</blockquote>
		</div>
		<div class="row-wrapper">
			<div class="projcard-container">
					<c:choose>
						<c:when test="${empty contentdetailList}">
						여행지 목록이 없습니다.
						</c:when>
						<c:otherwise>
						<c:forEach items="${contentdetailList}" var="contentdetail">
						<c:set var="i" value="${i+1}"/>
						<div class="projcard projcard-blue" onclick="location.href='/tour/detail?contentid=${contentdetail.contentid}&title=${contentdetail.title}&mapy=${contentdetail.mapy}&mapx=${contentdetail.mapx}&firstimage=${contentdetail.firstimage}'">
							<div class="projcard-innerbox">
								<img class="projcard-img" src="${contentdetail.firstimage}" alt="..." onerror="this.src='../../../resources/images/nocourseimg.png'"/>
								<div class="projcard-textbox">
									<div class="projcard-title"><span class="projcard-num">${i}</span>${contentdetail.title}</div>
									<div class="projcard-subtitle">${contentdetail.addr1}</div>
									<div class="projcard-bar"></div>
									<div class="projcard-description">${contentdetail.overview}</div>
								</div>
							</div>
						</div>
						</c:forEach>
						</c:otherwise>
					</c:choose>
			</div>
  		</div>
  		
  		<!-- 카카오 지도 -->
  		<div id="map-wrapper">
  			<div id="map" style="width:700px;height:400px;"></div>
  		</div>
  		
  		<hr style="border: none; height: 2px; background: #0D689C; opacity: 0.4; width:100%;">
  		
  		<c:if test="${sessionScope.loginId == course.id}">
  		 <div class="buttons-wrapper">
  			<button data-oper='modify' onclick="location.href='/course/modify?contentid=<c:out value="${course.contentid}"/>'">여행코스 수정하기</button>
  			<button data-oper='delete' onclick="location.href='/course/delete?contentid=<c:out value="${course.contentid}"/>'">여행코스 삭제하기</button>
  		</div>
  		</c:if>
  		
  		<!-- 댓글 -->
  		
  		<div class="comment-wrapper" style="width:100%; margin-top:15px;">
  		<div class="comment">
  			<div class="container bootstrap snippets bootdey">
    			<div class="row">
					<div class="col-md-12">
		    		<div class="blog-comment">
						<h4>Comments</h4>
						<div class="comment-header">
							<input type="text" id="content"/>
							<button type="button" id="registerBtn">댓글 등록</button>
                			<hr/>
                		</div>
						<ul class="comments">
				
				
				
<%-- 				<li class="clearfix">
				  <img src="${resourceurl}/images/user-icon.png" class="avatar" alt="">
				  <div class="post-comments">
				      <p class="meta"><a href="#">유저아이디</a>2024-04-16<i class="pull-right">
				      <a href="#"><small>수정하기</small></a><a href="#"><small>삭제하기</small></a></i></p>
				      <p>
				      안녕하세요 댓글예제
				      </p>
				  </div>
				</li> --%>
				
				
				
						</ul>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
		</div>
	</div>




<script>


var xList = new Array();
var yList = new Array();
var titleList = new Array();
var linePath = new Array(); //선을 구성하는 좌표 배열
	
<c:forEach items="${contentdetailList}" var="contentdetail">
	xList.push("${contentdetail.mapx}");
	yList.push("${contentdetail.mapy}");
	titleList.push("${contentdetail.title}");
</c:forEach>

//x,y 최대값, 최소값 구하기
var maxXvalue = Math.max.apply(null,xList);
var minXvalue = Math.min.apply(null,xList);
var maxYvalue = Math.max.apply(null,yList);
var minYvalue = Math.min.apply(null,yList);

//여행지들의 평균 좌표
var centerX = (maxXvalue + minXvalue) / 2;
var centerY = (maxYvalue + minYvalue) / 2;
	
var mapContainer = document.getElementById('map');
var options = {
		center: new kakao.maps.LatLng(centerY, centerX),
		level: 10
	};

var map = new kakao.maps.Map(mapContainer, options);

var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png"; // 마커 이미지 url

for(var i=0; i<xList.length; i++){
	var imageSize = new kakao.maps.Size(36, 35); // 마커 이미지 크기
	var imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (i*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        };
	var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions); // 마커 이미지 생성
	
    var marker = new kakao.maps.Marker({ // 마커 생성
        map: map, // 마커를 표시할 지도
        position: new kakao.maps.LatLng(yList[i], xList[i]),
        title : titleList[i], // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
        image : markerImage // 마커 이미지 
    });
	
	//배열에 좌표 저장
	linePath.push(new kakao.maps.LatLng(yList[i], xList[i]));
}

//지도에 표시할 선을 생성합니다
var polyline = new kakao.maps.Polyline({
    path: linePath, // 선을 구성하는 좌표배열 입니다
    strokeWeight: 5, // 선의 두께 입니다
    strokeColor: '#0D689C', // 선의 색깔입니다
    strokeOpacity: 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
    strokeStyle: 'solid' // 선의 스타일입니다
});

// 지도에 선을 표시합니다 
polyline.setMap(map);


$(document).ready(function(){
	let contentidValue = '<c:out value="${course.contentid}"/>';
	let sessionId = '<%=(String)session.getAttribute("loginId")%>';
	/* ======댓글 함수 호출========= */
	
	//현재 게시글에 댓글 추가(테스트용)
/* 	add({content:"JS TEST", id:"js tester", bno:bnoValue}, //댓글 데이터
			function(result) {alert("RESULT : " + result)}); */
	
	//댓글 목록 가져오기
/* 	getList({
		bno: bnoValue,
		page : 1
		}, function(list){
			list.forEach(function(item){
				console.log(item);
		});	
	}); */
			
	//댓글 삭제
/* 	remove(
		4,
		function(count){
			console.log(count);
			if(count==="success"){
				alert("REMOVED");
			}
		},
		function(err){
			alert('error occurred....');
		}); */
	
	//댓글 수정
/* 	update({
		commentid:7,
		bno:bnoValue,
		content:"modified reply..."
	},
	function(result){alert("수정 완료");
	}); */
	
	//특정 댓글 조회
	/* get(9,function(data){console.log(data);}); */
			
			
	/* ======댓글 함수 정의========== */
	
	//댓글 추가 함수
	function add(comment, callback, error){
		console.log("reply....");
		$.ajax({
			type:'post',
			url:'/commentsCo/new',
			data:JSON.stringify(comment),
			contentType:"application/json;charset=utf-8",
			success:function(result,status,xhr){
				if(callback){ callback(result); }
			},
			error:function(xhr,status,er){
				if(error) { error(er); }
			}
		});
	}
	
	//댓글 목록 불러오는 함수
	function getList(param, callback, error){
		var contentid = param.contentid;
		var page = param.page||1;
		$.getJSON("/commentsCo/pages/"+contentid+"/"+page+".json",
			function(data){
			 if(callback) {callback(data);}
		}).fail(function(xhr,status,err){
			if(error) {error();}
		});
	}
	
	//댓글 삭제
	function remove(commentid,callback,error){
		$.ajax({
			type:'delete',
			url:'/commentsCo/' + commentid,
			success:function(deleteResult, status, xhr){
				if(callback) { callback(deleteResult);}
			},
			error:function(xhr,status,er){
				if(error) { error(er); }
			}
		});
	}
	
	//댓글 수정
	function update(comment, callback, error){
		$.ajax({
			type:'put',
			url:'/commentsCo/' + comment.commentid,
			data:JSON.stringify(comment),
			contentType:"application/json;charset=utf-8",
			success:function(result,status,xhr){
				if(callback){ callback(result); }
			},
			error:function(xhr,status,er){
				if(error) { error(er); }
			}
		});
	}
	
	//특정 댓글 조회
	function get(commentid, callback, error){
		$.get("/commentsCo/"+commentid+".json",function(result){
			if(callback) { callback(result); }
		}).fail(function(xhr,status,err){
			if(error) { error(); }
		});
	}
	
	//댓글 목록 처리
	let replyUL = $(".comments");
	showList(1);
	function showList(page){
		getList(
			{contentid:contentidValue, page:page||1},
			function(list){
				let str="";
				if(list == null || list.length==0){
					replyUL.html("<p>등록된 댓글이 없습니다</p>");
					return;
				}
				list.forEach(function(item){
					if(sessionId == item.id){
					str+=`

					<li class="clearfix" data-commentid="\${item.commentid}">
					  <img src="${resourceurl}/images/user-icon.png" class="avatar" alt="">
					  <div class="post-comments">
					  <input type="hidden" id="findid" value="\${item.commentid}"/>
				     	 <div class="comment-button">
				      		<button type="button" id="modifyBtn">수정하기</button>
				      		<button type="button" id="removeBtn">삭제하기</button>
				      	</div>

					      <p class="meta"><span class="id">\${item.id}</span>\${displayTime(item.regDate)}</p>
					      <p id="comment-content">
					      \${item.content}
					      </p>
					      <p id="modifycomment"><input type="hidden" value="\${item.content}"></p>
					  </div>
					</li>
					`;
					}
					else{
						str+=`
						
						<li class="clearfix" data-commentid="\${item.commentid}">
						  <img src="${resourceurl}/images/user-icon.png" class="avatar" alt="">
						  <div class="post-comments">
						  <input type="hidden" id="findid" value="\${item.commentid}"/>
					     	 <div class="comment-button">
					      		<button type="button" id="modifyBtn" style="display:none;">수정하기</button>
					      		<button type="button" id="removeBtn" style="display:none;">삭제하기</button>
					      	</div>

						      <p class="meta"><span class="id">\${item.id}</span>\${displayTime(item.regDate)}</p>
						      <p id="comment-content">
						      \${item.content}
						      </p>
						      <p id="modifycomment"><input type="hidden" value="\${item.content}"></p>
						  </div>
						</li>
						`;
					}


				}); //forEach
				replyUL.html(str);
			}); //getList
	} //showList
	
	//시간 처리
	function displayTime(timeValue){
		let today = new Date();
		let gap = today.getTime()-timeValue;
		let dateObj = new Date(timeValue);
		if(gap<(1000*60*60*24)){
			let hh = dateObj.getHours();
			let mi = dateObj.getMinutes();
			let ss = dateObj.getSeconds();
			return [(hh>9?'':'0')+hh, ':', (mi>9?'':'0')+mi, ':', (ss>9?'':'0')+ss].join('');		
		}else{
			let yy = dateObj.getFullYear();
			let mm = dateObj.getMonth()+1;
			let dd = dateObj.getDate();
			return [yy, '/', (mm>9?'':'0')+mm, '/', (dd>9?'':'0')+dd].join('');
		}
	}
	
	let modifyBtn = $("#modifyBtn");
	let loginId = '<%=(String)session.getAttribute("loginId")%>';
	
	//새로운 댓글 처리
	$("#registerBtn").on("click",function(e){
		var contentValue = document.getElementById('content').value; //댓글창에 입력된 값 가져오기
		if(loginId=="null"){
			alert("로그인 후 사용해주세요");
			return;
		}
		if(contentValue === ''){
			alert("최소 한 글자 이상 입력해주세요");
			return;
		}
/* 		console.log("content값============"+document.getElementById('content').value);
		console.log("loginId값============"+loginId); */
 		var comment={
			content:contentValue,
			id:loginId,
			contentid:contentidValue
		};
		
		add(comment,function(result){
			alert("댓글이 등록되었습니다");
			$('#content').val(""); //댓글 등록이 되면, 텍스트 내용을 지움
			showList(1);
		});
	});
	
	//댓글 수정버튼 클릭시 input 활성화
	$(document).on("click","#modifyBtn",function(e){
		$(this).attr('hidden',true);
		$(this).next().attr('hidden',true);
		$(this).parent().append('<button type="button" id="updateBtn" style="margin:0; background:#FF8383">수정완료</button>');
		$(this).parent().next().next().attr('hidden',true); //댓글 감추기
		$(this).parent().next().next().next().children().prop("type","text"); //input type 변경
	});
	
	//특정 댓글 수정
	$(document).on("click","#updateBtn",function(){
		//var idData = document.querySelector(".clearfix"); //.clearfix의 data 속성 가져오기
		var commentid = $(this).parent().prev().val();//해당 댓글의 id값 가져오기
		var modifycomment = $(this).parent().next().next().next().children();
  		var comment = {commentid:commentid, content:modifycomment.val()};
		update(comment,function(result){
			alert("수정되었습니다");
			showList(1);
		});
	});
	
	//특정 댓글 삭제
	$(document).on("click","#removeBtn",function(){
		//var idData = document.querySelector(".clearfix"); //.clearfix의 data 속성 가져오기
		var commentid = $(this).parent().prev().val();//해당 댓글의 id값 가져오기
		remove(commentid,function(result){
			alert("삭제되었습니다");
			showList(1);
		});
	});

}); //document.ready

</script>
</div>
</body>
</html>
