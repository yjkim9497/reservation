package egovframework.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.mapper.HolidayMapper;
import egovframework.service.HolidayService;
import egovframework.vo.HolidayVO;

@Service("holidayService")
public class HolidayServiceImpl implements HolidayService {
	
	@Resource(name="holidayMapper")
	private HolidayMapper holidayMapper;

	public List<HolidayVO> getAllHolidays() {
        return holidayMapper.getAllHolidays();
    }
	
	public void insertHoliday(HolidayVO holiday) {
		holidayMapper.insertHoliday(holiday);
	}
	
	public void deleteHoliday(HolidayVO holiday) {
		holidayMapper.deleteHoliday(holiday);
	}
}
