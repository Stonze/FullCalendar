package kr.or.ddit.vo;

import lombok.Data;

@Data
public class CalendarVO {
	private int id;
	private String title;
	private String start;
	private String end;
	private boolean allDay;
}
