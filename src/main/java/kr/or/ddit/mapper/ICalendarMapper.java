package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.CalendarVO;

public interface ICalendarMapper {
	public List<CalendarVO> getData();
	public List<CalendarVO> test();
	public int insertEvent(CalendarVO calendar);
	public int updateEvent(CalendarVO calendar);
	public int deleteEvent(String id);
}
