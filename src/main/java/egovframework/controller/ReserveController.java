package egovframework.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.ReserveService;
import egovframework.service.UserService;
import egovframework.vo.LoginVO;
import egovframework.vo.ReserveVO;
import egovframework.vo.UserVO;

@Controller
@RequestMapping("/reservation")
public class ReserveController {
	
	@Autowired
	private ReserveService reserveService;
	
	@Autowired
    private UserService userService;
	
	@RequestMapping(value = "/{date}.do", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> getReservations(@PathVariable String date) {
	    try {
	        LocalDate reservationDate = LocalDate.parse(date);
	        List<ReserveVO> reservations = reserveService.getReservationsByDate(reservationDate);

	        System.out.println("컨트롤단 확인 : " + reservations.size());

	        // 예약 정보를 개별 Map으로 변환하여 리스트에 저장
	        List<Map<String, Object>> reservationList = new ArrayList<>();

	        for (ReserveVO reservation : reservations) {
	            Map<String, Object> reservationMap = new HashMap<>();
	            reservationMap.put("id", reservation.getId());
	            reservationMap.put("timeSlot", reservation.getTimeSlot());
	            reservationMap.put("status", reservation.getStatus());

	            reservationList.add(reservationMap);
	        }

	        // 최종 응답 Map 생성
	        Map<String, Object> response = new HashMap<>();
	        response.put("date", date);
	        response.put("totalReservations", reservations.size());
	        response.put("reservations", reservationList); // 리스트 형태로 전달

	        return ResponseEntity.ok(response);
	    } catch (DateTimeParseException e) {
	        return ResponseEntity.badRequest().body("Invalid date format. Please use 'YYYY-MM-DD'.");
	    }
	}

	// 예약 신청 (사용자가 예약 요청)
    @RequestMapping(value = "/{id}/book.do", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> bookReservation(@PathVariable Long id, HttpServletRequest request) {
    	Long userId = (Long) request.getSession().getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
    	reserveService.bookReservation(id, userId);
    	System.out.println("예약성공");
        return ResponseEntity.ok("예약신청이 완료되었습니다.");
    }
	
    // 예약 승인 (관리자가 예약 승인)
 	@RequestMapping(value = "/{id}/approve.do", method = RequestMethod.POST)
 	@ResponseBody
 	public ResponseEntity<String> approveReservation(@PathVariable String id, HttpServletRequest request) {
 		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
 		
 	// 로그인 여부 확인
        if (user == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        // 관리자 권한 체크
        if (!"admin".equals(user.getRole())) {
            return ResponseEntity.status(403).body("관리자 권한이 필요합니다.");
        }
 		
 		reserveService.approveReservation(id);
 	    return ResponseEntity.ok("예약이 승인되었습니다.");
 	}

 	// 예약 리스트 조회 (JSP 페이지)
 	@RequestMapping(value = "/list.do", method = RequestMethod.GET)
 	public String reservationList(HttpServletRequest request, Model model) {
 	    LoginVO resultVO = (LoginVO) request.getSession().getAttribute("LoginVO");

 	    if (resultVO == null || resultVO.getId() == null) {
 	        // 세션이 없으면 로그인 페이지로 리다이렉트
 	        System.out.println("세션에 로그인한 유저가 존재하지 않음");
 	        return "redirect:/login.do";
 	    }

 	    String userId = resultVO.getId();
 	    UserVO loginUser = userService.getUser(userId);
 
 	    if (loginUser == null) {
 	        System.out.println("해당 ID를 가진 유저 정보가 없음: " + userId);
 	        return "redirect:/login.do"; // 또는 오류 페이지로 이동
 	    }

 	    List<ReserveVO> reservations;
 	    try {
 	        reservations = reserveService.getAllReservations();
 	    } catch (Exception e) {
 	        System.err.println("예약 목록 조회 중 오류 발생: " + e.getMessage());
 	        reservations = Collections.emptyList(); // 예외 발생 시 빈 리스트 반환
 	    }

 	    model.addAttribute("loginUser", loginUser);
 	    model.addAttribute("reservations", reservations);

 	    return "reservationList"; // reservationList.jsp로 이동
 	}
 	
 	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
 	@ResponseBody
 	public String addAvailableReservation(@RequestBody ReserveVO reserve, Model model) {
 		System.out.println("예약 추가 컨트롤러");
 		System.out.println(reserve.getTimeSlot());
 		System.out.println(reserve.getStatus());
 		reserveService.addAvailableReservation(reserve);
        model.addAttribute("message", "예약 가능 시간이 추가되었습니다.");
        return "admin";
    }
 	
 	


}
