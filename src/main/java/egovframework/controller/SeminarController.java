package egovframework.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.SeminarService;
import egovframework.service.UserService;
import egovframework.vo.ReserveVO;
import egovframework.vo.SeminarVO;

@Controller
@RequestMapping("/seminar")
public class SeminarController {

	@Autowired
	private SeminarService seminarService;

	@Autowired
	private UserService userService;

	@RequestMapping(value = "/{date}.do", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> getSeminars(@PathVariable String date) {
		System.out.println("세미나 컨트롤러");
		try {
			LocalDate seminarDate = LocalDate.parse(date);
			List<SeminarVO> seminars = seminarService.getSeminarsByDate(seminarDate);

			System.out.println("컨트롤단 확인 : " + seminars.size());

			// 예약 정보를 개별 Map으로 변환하여 리스트에 저장
			List<Map<String, Object>> seminarList = new ArrayList<>();

			for (SeminarVO seminar : seminars) {
				Map<String, Object> seminarMap = new HashMap<>();
				seminarMap.put("seminarPk", seminar.getSeminarPk());
				seminarMap.put("seminarName", seminar.getSeminarName());
				seminarMap.put("seminarTimeSlot", seminar.getSeminarTimeSlot());
				seminarMap.put("seminarCapacity", seminar.getSeminarCapacity());
				seminarMap.put("seminarCurrentPeople", seminar.getSeminarCurrentPeople());
				seminarList.add(seminarMap);
			}

			// 최종 응답 Map 생성
			Map<String, Object> response = new HashMap<>();
			response.put("date", date);
			response.put("totalReservations", seminars.size());
			response.put("reservations", seminarList); // 리스트 형태로 전달

			return ResponseEntity.ok(response);
		} catch (DateTimeParseException e) {
			return ResponseEntity.badRequest().body("Invalid date format. Please use 'YYYY-MM-DD'.");
		}
	}

	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public String addSeminar(@RequestBody SeminarVO seminarVO) {
		try {
			seminarService.insertSeminar(seminarVO);
			return "예약이 추가되었습니다.";
		} catch (Exception e) {
			e.printStackTrace();
			return "오류가 발생했습니다.";
		}
	}

}
