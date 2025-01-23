package egovframework.service.impl;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.ReserveMapper;
import egovframework.service.ReserveService;
import egovframework.vo.ReserveVO;

@Service
public class ReserveServiceImpl implements ReserveService {
	
	@Autowired
	private ReserveMapper reserveMapper;
	
	public List<ReserveVO> getReservationsByDate(LocalDate date) {
		System.out.println("서비스단"+date);
		List<ReserveVO> result = reserveMapper.findByDate(date);
		System.out.println("크기" + result.size());
        return reserveMapper.findByDate(date);
    }

	public ReserveVO bookReservation(Long id) {
        ReserveVO reservation = reserveMapper.findById(id);
        if (reservation == null) {
            throw new RuntimeException("Reservation not found");
        }
        if (!"가능".equals(reservation.getStatus())) {
            throw new RuntimeException("이미 예약 완료된 항목입니다.");
        }
        reservation.setStatus("완료");
        reserveMapper.updateReservationStatus(reservation);
        return reservation;
    }

}
