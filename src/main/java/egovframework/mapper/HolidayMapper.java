package egovframework.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.HolidayVO;

@Mapper
public interface HolidayMapper {
	void insertHoliday(HolidayVO holiday);
	void deleteHoliday(HolidayVO holiday);
	List<HolidayVO> getAllHolidays();
	
	int checkSeminarOverlap(Map<String, Date> params);
}
