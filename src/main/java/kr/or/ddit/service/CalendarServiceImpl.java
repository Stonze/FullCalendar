package kr.or.ddit.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ICalendarMapper;
import kr.or.ddit.vo.CalendarVO;

@Service
public class CalendarServiceImpl implements ICalendarService {
	
	@Inject
	private ICalendarMapper mapper;
	
	@Override
	public List<CalendarVO> getData() {
		return mapper.getData();
	}

	@Override
	public List<CalendarVO> test() {
		return mapper.test();
	}

	@Override
	public int insertEvnet(CalendarVO calendar) {
		return mapper.insertEvent(calendar);
	}

	@Override
	public int updateEvent(CalendarVO calendar) {
		return mapper.updateEvent(calendar);
	}

	@Override
	public int deleteEvent(String id) {
		return mapper.deleteEvent(id);
	}
	
}
