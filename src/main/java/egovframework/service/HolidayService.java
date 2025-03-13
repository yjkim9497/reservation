package egovframework.service;

import java.util.List;

import egovframework.vo.HolidayVO;

public interface HolidayService {
	List<HolidayVO> getAllHolidays();
	void insertHoliday(HolidayVO holiday);
	void deleteHoliday(HolidayVO holiday);
}
