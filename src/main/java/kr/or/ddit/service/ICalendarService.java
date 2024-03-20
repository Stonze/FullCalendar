package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.CalendarVO;

public interface ICalendarService {
	public List<CalendarVO> getData();
	public List<CalendarVO> test();
	public int insertEvnet(CalendarVO calendar);
	public int updateEvent(CalendarVO calendar);
	public int deleteEvent(String id);
}
