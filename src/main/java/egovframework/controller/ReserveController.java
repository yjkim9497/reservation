package egovframework.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.mapper.ReserveMapper;
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
	private ReserveMapper reserveMapper;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
	
	@Autowired
    private UserService userService;
	
	@RequestMapping(value = "/{seminarPk}/book.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> bookReservation(
	        @PathVariable("seminarPk") Long seminarPk,
	        @RequestBody ReserveVO reserveVO, 
	        HttpServletRequest request) {
	    Map<String, Object> response = new HashMap<>();
	    
	    try {
	        UserVO loginUser = (UserVO) request.getSession().getAttribute("LoginVO");
	        if (loginUser != null) {
	            Long userPk = loginUser.getUserPk();
	            reserveVO.setUserPk(userPk);
	            reserveVO.setReservationLogin(true);
	            reserveVO.setReservationBirth(loginUser.getUserBirth());
	        } else {
	            reserveVO.setReservationLogin(false);
	        }
	        
	        reserveVO.setSeminarPk(seminarPk);
	        
	     // 날짜와 시간 정보를 기반으로 고유 ID 생성
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	        String datePart = dateFormat.format(new Date());
	        
	        // 날짜 부분을 long 타입으로 변환 (예: "20250305121234" -> 20250305121234L)
	        long datePartLong = Long.parseLong(datePart);
	        
	        // 순차적으로 증가하는 번호 부여 (예시로 마지막 ID + 1)
	        long reservationId = datePartLong * 10000; // 예: 20250305121234001
	        
	        reserveVO.setReservationPk(reservationId);

	        // 이메일 & 전화번호 암호화
	        String encryptedPhone = cryptoService.encrypt(reserveVO.getReservationPhone());
	        String encryptedEmail = cryptoService.encrypt(reserveVO.getReservationEmail());
	        
	        reserveVO.setReservationPhone(encryptedPhone);
	        reserveVO.setReservationEmail(encryptedEmail);
	        
	        reserveService.bookReservation(reserveVO);

	        response.put("message", "예약이 완료되었습니다!");
	        response.put("status", "success");
	        response.put("reservationId", reservationId);
	        return ResponseEntity.ok(response); // 200 OK 반환

	    } catch (IllegalStateException e) { 
	        // 정원 초과 등의 비즈니스 로직 예외 처리
	        response.put("message", e.getMessage());
	        response.put("status", "fail");
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response); // 400 Bad Request 반환

	    } catch (IllegalArgumentException e) {
	        // 세미나 존재하지 않는 경우 예외 처리
	        response.put("message", e.getMessage());
	        response.put("status", "fail");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response); // 404 Not Found 반환

	    } catch (Exception e) {
	        // 기타 예상치 못한 예외 처리
	        e.printStackTrace(); // 로그에 출력 (필요하면 Logger 사용)
	        response.put("message", "서버 내부 오류가 발생했습니다.");
	        response.put("status", "error");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response); // 500 Internal Server Error 반환
	    }
	}
	
	@RequestMapping(value = "/seminarReservation.do", method = {RequestMethod.GET, RequestMethod.PUT})
    public String seminarReservation(@RequestParam("seminarPk") Long seminarPk, Model model) {
        // 세미나 정보를 조회하는 로직 추가 (예: 서비스 호출)
        // Seminar seminar = seminarService.findById(seminarPk);
        List<ReserveVO> reservations = reserveService.getReservationList(seminarPk);
        model.addAttribute("seminarPk", seminarPk);
        model.addAttribute("reservations", reservations);  

        return "seminarReservation";  // seminarReservation.jsp로 이동
    }
	
	@RequestMapping(value = "/guest.do", method = RequestMethod.GET)
	public String getGuestReservation() {
		return "guestReservationSearch";
	}
	
	@RequestMapping(value = "/search.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> searchReservation(@RequestBody Map<String, Object> requestBody) {
		// Map에서 데이터를 추출
	    String reservationEmail = (String) requestBody.get("reservationEmail");
	    Long reservationPk = Long.parseLong((String) requestBody.get("reservationPk"));
	    
	    // 데이터베이스에서 예약 정보를 조회 (reserveMapper 사용)
	    ReserveVO reservation = reserveMapper.findReservation(reservationPk, cryptoService.encrypt(reservationEmail));
	    
	    reservation.setReservationEmail(reservationEmail);
	    // 응답 객체 준비
	    Map<String, Object> response = new HashMap<>();
	    if (reservation != null) {
	        response.put("reservation", reservation);  // 예약이 있으면 데이터 반환
	    } else {
	        response.put("reservation", null);  // 예약이 없으면 null 반환
	    }
	    return response;
	}



    // 특정 세미나의 예약 목록 조회
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ResponseBody
    public List<ReserveVO> getReservationList(@RequestParam("seminarPk") Long seminarPk) {
        return reserveService.getReservationList(seminarPk);
    }
    
    @RequestMapping(value = "/myList", method = RequestMethod.GET)
    @ResponseBody
    public List<ReserveVO> getUserReservationList(@RequestParam("userPk") Long userPk) {
    	return reserveService.getUserReservationList(userPk);
    }

    // 특정 예약 상세 조회
    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    @ResponseBody
    public ReserveVO getReservationById(@RequestParam("reservationPk") Long reservationPk) {
        return reserveService.getReservationById(reservationPk);
    }

    // 예약 승인
    @RequestMapping(value = "/approve.do", method = RequestMethod.PUT)
    @ResponseBody
    public String approveReservation(@RequestParam("reservationPk") Long reservationPk) {
        reserveService.approveReservation(reservationPk);
        return "SUCCESS";
    }

    // 예약 거절
    @RequestMapping(value = "/reject.do", method = RequestMethod.PUT)
    @ResponseBody
    public String rejectReservation(@RequestParam("reservationPk") Long reservationPk) {
        reserveService.rejectReservation(reservationPk);
        return "SUCCESS";
    }

    // 예약 취소
    @RequestMapping(value = "/cancel.do", method = RequestMethod.PUT)
    @ResponseBody
    public String cancelReservation(@RequestParam("reservationPk") Long reservationPk) {
        reserveService.cancelReservation(reservationPk);
        return "SUCCESS";
    }
}
