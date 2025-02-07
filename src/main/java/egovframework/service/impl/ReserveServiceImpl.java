package egovframework.service.impl;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.ReserveMapper;
import egovframework.service.ReserveService;
import egovframework.vo.ReserveStatus;
import egovframework.vo.ReserveVO;

@Service
public class ReserveServiceImpl implements ReserveService {
	
	@Autowired
	private ReserveMapper reserveMapper;
	
	@Override
    public List<ReserveVO> getReservationsByDate(LocalDate date) {
        return reserveMapper.findByDate(date);
    }

	@Override
	public ReserveVO bookReservation(Long id, Long userId) {
        ReserveVO reservation = reserveMapper.findById(id);
        if (reservation == null) {
            throw new RuntimeException("Reservation not found");
        }
//        if (!"AVAILABLE".equals(reservation.getStatus())) {
//            throw new RuntimeException("이미 예약 완료된 항목입니다.");
//        }
        reservation.setStatus(ReserveStatus.PROGRESSING);
        reserveMapper.updateReservationStatus(id, ReserveStatus.PROGRESSING, userId);
        return reservation;
    }
	
	@Override
    public void approveReservation(Long id, int numberOfPeople) {
        // 예약 인원 수가 정원 수를 초과하지 않도록 체크
        ReserveVO reservation = reserveMapper.findById(id);
        if (reservation == null) {
            throw new RuntimeException("Reservation not found");
        }

        // 현재 예약된 인원 수 조회
        int currentCount = reserveMapper.getCurrentReservationCount(reservation.getDate(), reservation.getTimeSlot());

        // 정원 초과 체크
        if (currentCount + numberOfPeople > reservation.getMaxCapacity()) {
            throw new RuntimeException("정원 초과로 예약을 승인할 수 없습니다.");
        }

        // 예약 인원 수 증가
        reserveMapper.increaseReservationCount(id, numberOfPeople);

        // 예약 승인
        reserveMapper.updateReservationStatus(id, ReserveStatus.COMPLETED, reservation.getUserId());
    }

    @Override
    public List<ReserveVO> getAllReservations() {
        return reserveMapper.findAllReservations();
    }
    
    @Override
    public List<ReserveVO> getUserReservations(Long userId) {
        return reserveMapper.getUserReservations(userId);
    }
    
    @Override
    public void addAvailableReservation(ReserveVO reserve) {
        reserveMapper.addAvailableReservation(reserve);
    }
    
    @Override
    public void cancelReservation(Long id, int numberOfPeople) {
        // 예약 인원 수 감소
        reserveMapper.decreaseReservationCount(id, numberOfPeople);

        // 예약 취소
        reserveMapper.updateReservationStatus(id, ReserveStatus.CANCELED, null);
    }

    @Override
    public void deleteReservation(Long id) {
        reserveMapper.deleteReservation(id);
    }

}
