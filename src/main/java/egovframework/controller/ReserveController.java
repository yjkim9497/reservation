package egovframework.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.ReserveService;
import egovframework.vo.ReserveVO;

@Controller
@RequestMapping("/reservation")
public class ReserveController {
	
	@Autowired
	private ReserveService reserveService;
	
//	@RequestMapping(value = "/{date}.do", method = RequestMethod.GET)
//	@ResponseBody
//    public String getReservations(@PathVariable String date, Model model) {
//		System.out.println(date);
//        LocalDate reservationDate = LocalDate.parse(date);
//        System.out.println(reservationDate);
//        List<ReserveVO> reservations = reserveService.getReservationsByDate(reservationDate);
//        model.addAttribute("reservations",reservations);
//        return "reservation";
//    }

	
	@RequestMapping(value = "/{date}.do", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> getReservations(@PathVariable String date) {
	    try {
	        LocalDate reservationDate = LocalDate.parse(date);
	        List<ReserveVO> reservations = reserveService.getReservationsByDate(reservationDate);
	        return ResponseEntity.ok(reservations);
	    } catch (DateTimeParseException e) {
	        return ResponseEntity.badRequest().body("Invalid date format. Please use 'YYYY-MM-DD'.");
	    }
	}
//    public List<ReserveVO> getReservations(@PathVariable String date) {
//		System.out.println(date);
//        LocalDate reservationDate = LocalDate.parse(date);
//        System.out.println(reservationDate);
//        List<ReserveVO> reservations = reserveService.getReservationsByDate(reservationDate);
//        return reservations;
//    }

    @RequestMapping(value = "/{id}/book.do", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> bookReservation(@PathVariable Long id) {
    	reserveService.bookReservation(id);
        return ResponseEntity.ok("예약이 완료되었습니다.");
    }
	

}
