package egovframework.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.mapper.SeminarMapper;
import egovframework.service.HolidayService;
import egovframework.vo.HolidayVO;

@Controller
@RequestMapping("/holiday")
public class HolidayController {
	@Autowired
	private HolidayService holidayService;
	
	@Autowired
	private SeminarMapper seminarMapper;
	
	@RequestMapping(value = "/list.do", method = RequestMethod.GET)
	@ResponseBody
	public List <HolidayVO> getholidays(){
		List <HolidayVO> holidays = holidayService.getAllHolidays();
		return holidays;
	}
	
	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addHoliday(@RequestBody HolidayVO holiday) {
	    Date holidayStart = holiday.getHolidayStart();
	    Date holidayEnd = holiday.getHolidayEnd();

	    Map<String, Date> params = new HashMap<>();
	    params.put("holidayStart", holidayStart);
	    params.put("holidayEnd", holidayEnd);

	    // MyBatis 쿼리 호출
	    int overlapCount = seminarMapper.checkHolidayOverlap(params);

	    // 응답을 위한 Map 객체 생성
	    Map<String, Object> response = new HashMap<>();
	    
	    if (overlapCount > 0) {
	        // 날짜 겹칠 경우
	        response.put("status", "fail");
	        response.put("message", "휴무일이 세미나 날짜와 겹칩니다. 다른 날짜로 변경해주세요.");
	    } else {
	        // 날짜 겹치지 않으면 추가
	        holidayService.insertHoliday(holiday);
	        response.put("status", "success");
	        response.put("message", "휴무일이 추가되었습니다.");
	    }
	    
	    return response;  // Map을 반환하면 JSON 형태로 자동 변환
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.DELETE)
	@ResponseBody
    public String deleteHoliday(@RequestBody HolidayVO holiday) {
		holidayService.deleteHoliday(holiday);
        return "휴무일이 삭제되었습니다.";
    }
}
