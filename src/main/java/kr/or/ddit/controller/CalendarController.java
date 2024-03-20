package kr.or.ddit.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.ICalendarService;
import kr.or.ddit.vo.CalendarVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;

@Controller
@Slf4j
public class CalendarController {
	
	/*
	 * 주의 사항
	 * 
	 * allDay를  true로 설정한 경우 시작시간, 종료시간이 없어도 된다. (시간 설정은 가능하지만 reSize는 불가능)
	 * allDay가 false이고 시작 날짜만 설정한 경우 시작 시간은 00시, 종료시간은 시작 날짜 + 01시로 설정된다.
	 * allDay가 false이고 시작 날짜, 종료 날짜만 설정하면 시작, 종료날짜는 00시로 설정된다. (allDay 체크 안할 경우 시간 입력 받게 해야할듯)
	 * allDay가 true이면 시작 시간, 종료 시간은 설정하지 않아도 됨 (설정하지 않을 경우 00시로 설정됨)
	 * allDay가 true이면 시작 시간, 종료 시간을 설정해도 무시되고 00시로 설정됨
	 * allDay가 true인 경우 시작 날짜, 종료 날짜를 동일하게 설정하면 종료 날짜가 하루 뒤로 자동으로 설정됨.
	 * 
	 * 
	 */

	@Inject
	private ICalendarService calService;
	
	// FullCalender 화면에 띄우기
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public String calendar() {
		log.info("calendar() 실행!!!");
		return "calendar";
	}
	
	// DB 데이터를 FullCalendar페이지에 보내기
	@RequestMapping(value = "/loadData", method = RequestMethod.POST)
	public ResponseEntity<JSONArray> loadData() {
		// ResponseEntity 초기화
		ResponseEntity<JSONArray> data = null;
		
		// DB에서 데이터를 받아와 List에 저장
		List<CalendarVO> dataList = calService.getData();
		for (int i = 0; i < dataList.size(); i++) {
			CalendarVO cal = dataList.get(i);
			log.info("event : " + cal.getTitle());
		}
		
		// List데이터를 JSONArray로 변환
		JSONArray dataArray = new JSONArray().fromObject(dataList);
		System.out.println(dataArray.toString());
		// JSONArray를 응답으로 전달
		data = new ResponseEntity<JSONArray>(dataArray, HttpStatus.OK);
		return data;
	}
	
	// 이벤트 등록
	@ResponseBody
	@RequestMapping(value = "/insertEvent", method = RequestMethod.POST)
	public ResponseEntity<Boolean> insertEvent(@RequestBody CalendarVO calendar) {
		// 이벤트 등록 여부 flag. 기본값 false
		boolean insertFlag = false;
		
		// insert 성공 여부 상태 값
		int status = calService.insertEvnet(calendar);
		
		if (status > 0) {	// insert에 성공했다면
			// flag값을 true로 변경
			insertFlag = true;
		}
		// flag값을 응답으로 전달
		return new ResponseEntity<Boolean>(insertFlag, HttpStatus.OK);
	}
	
	// 이벤트 수정
	@ResponseBody
	@RequestMapping(value = "/updateEvent", method = RequestMethod.POST)
	public ResponseEntity<Boolean> updateEvent(@RequestBody CalendarVO calendar) {
		// 이벤트 수정 여부 flag. 기본값 false
		boolean updateFlag = false;
		
		// update 성공 여부 상태값
		int status = calService.updateEvent(calendar);
		
		if (status > 0) {	// update에 성공했다면
			updateFlag = true;	// flag값을 true로 변경
		}
		
		// flag값을 응답으로 전달
		return new ResponseEntity<Boolean>(updateFlag, HttpStatus.OK);
	}
	
	// event 삭제
	@ResponseBody
	@RequestMapping(value = "/deleteEvent", method = RequestMethod.POST)
	public ResponseEntity<Boolean> deleteEvent(@RequestBody String id) {	// id값만 받아옴
		// 이벤트 삭제 여부 flag. 기본값 false
		boolean deleteFlag = false;
		
		// delete 성공여부 상태값
		int status = calService.deleteEvent(id);
		
		if (status > 0) {	// 삭제에 성공했다면
			deleteFlag = true;	// flag값을 true로 변경
		}
		
		// flag값을 응답으로 전달
		return new ResponseEntity<Boolean>(deleteFlag, HttpStatus.OK);
	}
	
}
