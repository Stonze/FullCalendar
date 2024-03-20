<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/locales-all.js"></script>
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<div id="calendar"></div>
	<div>
			<table border="1" id="table">
				<tr>
					<td style="text-align: center">ID</td>
					<td><input type="text" id="ID" disabled="disabled" /></td>
				</tr>
				<tr>
					<td style="text-align: center">제목</td>
					<td><input type="text" id="title" /></td>
				</tr>
				<tr>
					<td style="text-align: center">시작일</td>
					<td><input type="text" id="startDate" />시작</td>
				</tr>
				<tr>
					<td style="text-align: center">종료일</td>
					<td><input type="text" id="endDate" />종료</td>
				</tr>
				<tr>
					<td style="text-align: center">시작시간</td>
					<td><input type="text" id="startTime" /></td>
				</tr>
				<tr>
					<td style="text-align: center">종료시간</td>
					<td><input type="text" id="endTime" /></td>
				</tr>
				<tr>
					<td style="text-align: center">AllDay(하루종일)</td>
					<td style="text-align: center"><input type="checkbox" id="allDay"></td>
				</tr>
			</table>
			<button id="insertBtn">추가</button>
			<button id="updateBtn">수정</button>
			<button id="deleteBtn">삭제</button>
	</div>
</body>
<script type="text/javascript">
    let calendarEl = document.getElementById('calendar');	// calendar 영역
    let calendar = "";
    let allDay = "";	// 이벤트 종일 여부값을 넣을 변수
    
    let id = $('#ID');					// input id="Id"
    let title = $('#title');			// input id="title"
    let startTime = $('#startTime');	// input id="startTime"
    let endTime = $('#endTime');		// input id="endTiime"
    let startDate = $('#startDate');	// input id="startDate"
    let endDate = $('#endDate');		// input id="endDate"
    let allDayCheckBox = $('#allDay');	// input checkbox id="allDay"
    let table = $('#table');			// table
    
    let insertBtn = $('#insertBtn');	// 등록버튼
    let updateBtn = $('#updateBtn');	// 수정버튼
    let deleteBtn = $('#deleteBtn');	// 삭제버튼
    
    let inputs = table.find('input');	// 테이블 내의 input요소들
    
	inputs.val("");						// input요소들의 value값을 초기화
    
    
    allDayCheckBox.change(function() {	// checkbox change 이벤트
    	if ($(this).is(':checked')) {	// checkbox가 체크되어 있으면	
			allDay = true;
			startTime.attr("disabled", true);
			endTime.attr("disabled", true);
		} else {
			startTime.attr("disabled", false);
			endTime.attr("disabled", false);
			allDay = false;
			
		}
    	
	});
    function loadCalendar() {	// FullCalendar를 화면에 띄우는 함수. 등록, 수정, 삭제될 때마다 변동사항을 화면에 띄우기 위함
    	$.ajax({
        	url : "/loadData",
        	type : "post",
        	success : function (res) {
    		    calendar = new FullCalendar.Calendar(calendarEl, {
    		        events: res,	// event(Controller에서 JSONArray로 전달한 값을 대입)
    		        initialView: 'dayGridMonth',	// FullCalendar가 처음 로드되었을때 뷰 설정
    		        headerToolbar : {				// 헤드툴바 설정
    		        	center : "title",			
    		        	left : "dayGridMonth,timeGridWeek,timeGridDay"
    		        },
    		        expandRows : true,
    		        selectable : true, // 달력 일자 드래그 설정가능
    				droppable : true,	// 드롭 가능 여부 설정
    				editable : true,	// 수정 가능 여부 설정
    				nowIndicator: true, // 현재 시간 마크
    				navLinks : true,	// 링크 활성화 여부 설정
    				eventResize : function(info) {	// 리사이즈 이벤트(리사이즈 시 이벤트 내용 수정)
    					
    					// 리사이즈 후의 이벤트 정보
    					let event = info.event._def;
    					let instance = info.event._instance;
    					let id = event.publicId;
    					let title = event.title;
    					let allDay = event.allDay;
    					let start = instance.range.start.toISOString().split('.')[0];
    					let end = instance.range.end.toISOString().split('.')[0];
    					
    					
    					let data = {
    						id : id,
    						title : title,
    						start : start,
    						end : end,
    						allDay : allDay
    					};
    					
    					// 이벤트 수정 함수
    					update(data);
    				},
    				// 이벤트가 드롭되었을 떄 이벤트
    				eventDrop : function(info) {
    					
    					// 이벤트가 드롭되었을 때의 정보
    					let event = info.event._def;
    					let instance = info.event._instance;
    					let id = event.publicId;
    					let title = event.title;
    					let allDay = event.allDay;
    					let start = instance.range.start;
    					let end = instance.range.end;
    					
    					let data = {
    						id : id,
    						title : title,
    						start : start.toISOString().split('.')[0],
    						end : end.toISOString().split('.')[0],
    						allDay : allDay
    					};
    					update(data);	// 이벤트 수정 함수
    				},
    				// 달력 칸을 선택했을 경우(이벤트 선택 x)
    				select : function(info) {
    					inputs.val(""); 				// input 초기화
    					let endDateVal = info.endStr;	// 해당 날짜의 정보를 input에 입력
    					startDate.val(info.startStr);
    					endDate.val(endDateVal);
    					
    				},
    				// 이벤트를 클릭했을 때의 이벤트
    				eventClick : function(info) {
    					inputs.val("");	// input 초기화
    					
    					// 클릭한 이벤트의 정보
    					let event = info.event._def;
    					let instance = info.event._instance;
    					let idVal = event.publicId;
    					let titleVal = event.title;
    					let allDay = event.allDay;
    					let startVal = instance.range.start;
    					let endVal = instance.range.end;
    					
    					let startDateVal = startVal.toISOString().split('.')[0].split('T')[0];
    					let endDateVal = endVal.toISOString().split('.')[0].split('T')[0];
    					let startTimeVal = startVal.toISOString().split('.')[0].split('T')[1];
    					let endTimeVal = endVal.toISOString().split('.')[0].split('T')[1];
    					
    					// 이벤트의 정보들을 가공하여 input에 입력
    					id.val(idVal);
    					title.val(titleVal);
    					startDate.val(startDateVal);
    					endDate.val(endDateVal);
    					
    					
    					if (allDay) {	// 종일 여부가 true이면
    						allDayCheckBox.attr("checked", true);
    						startTime.attr("disabled", true);
    						endTime.attr("disabled", true);
    						startTime.val("00:00:00");
    						endTime.val("00:00:00");
    					} else {
    						allDayCheckBox.attr("checked", false);
    						startTime.val();
        					endTime.val();
    						startTime.val(startTimeVal);
    						endTime.val(endTimeVal);
    					}
    				},
    				locale: 'ko' // 한국어 설정
    		    });
    		    // calendar 띄우기
    			calendar.render();
    		}
        });
	}
    
    // calendar를 띄우는 함수
    loadCalendar();
    
    // 등록 버튼 클릭 이벤트
    insertBtn.click(function() {
		
		let start = "";
		let end = "";
		let event = "";
		
		if (allDayCheckBox.is(':checked')) {
			allDay = true;
		} else {
			allDay = false;
		}
		
		if (allDay) {
			start = startDate.val();
			end = endDate.val();
		} else {
			if (startDate.val() == null || endDate.val() == null) {
				alert("null!!!");
				return;
			} else {
				start = startDate.val() + "T" + startTime.val();
				end = endDate.val() + "T" + endTime.val();
			}
		}
		
		let data = {
			title : title.val(),
			start : start,
			end : end,
			allDay : allDay
		};
		
		$.ajax({
			url : "/insertEvent",
			data : JSON.stringify(data),
			method : "post",
			contentType : "application/json; charset=utf-8",
			success : function(res) {
				if (res) {
					alert("일정 등록 성공!");
					// FullCalendar를 다시 로드
					loadCalendar();
				} else {
					alert("일정 등록에 실패했습니다!");
				} 
				
			}
		});
	});
    
    // 수정 버튼 클릭 이벤트
    updateBtn.click(function() {
    	let start = "";
		let end = "";
		let event = "";
		
		if (allDayCheckBox.is(':checked')) {
			allDay = true;
		} else {
			allDay = false;
		}
		
		if (allDay) {
			let endDateValue = endDate.val();
			let endDateFormat = new Date(endDateValue);
			endDateFormat.setDate(endDateFormat.getDate() + 1);
			start = startDate.val();
			end = endDateFormat;
		} else {
			if (startDate.val() == null || endDate.val() == null) {
				alert("null!!!");
				return;
			} else {
				start = startDate.val() + "T" + startTime.val();
				end = endDate.val() + "T" + endTime.val();
			}
		}
		
		let data = {
			id : id.val(),
			title : title.val(),
			start : start,
			end : end,
			allDay : allDay
		};
		
		// 이벤트 수정 함수
		update(data);
		
	});
    
    // 삭제 버튼 클릭 이벤트
    deleteBtn.click(function() {
		let idVal = id.val();
		$.ajax({
			url : "/deleteEvent",
			data : idVal,
			method : "post",
			contentType : "application/text; charset=utf-8",
			success : function(res) {
				if (res) {
					alert("삭제 성공!");
					// FullCalendar를 다시 로드
					loadCalendar();
				} else {
					alert("삭제 실패!");
				} 
			}
		});
	});
	
    // 이벤트 수정함수 
    // input으로 입력한 값으로 수정하는 것 이외에 reSize, drop되었을 때에도 이벤트가 수정될 수 있도록
    // 함수를 따로 만들어두었음
    // data : 수정할 정보 데이터
    function update(data) {
		$.ajax({
			url : "/updateEvent",
			data : JSON.stringify(data),
			method : "post",
			contentType : "application/json; charset=utf-8",
			success : function(res) {
				if (res) {
					alert("수정 성공!");
					// FullCalendar를 다시 로드
					loadCalendar();
				} else {
					alert("수정 실패!");
				} 
			}
		});
	}
</script>
</html>