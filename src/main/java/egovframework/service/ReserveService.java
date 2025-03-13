package egovframework.service;

import java.time.LocalDate;
import java.util.List;

import egovframework.vo.ReserveVO;

public interface ReserveService {
	
	// 예약 신청
	ReserveVO bookReservation(ReserveVO reserveVO);
	
	// 예약 목록 조회
    List<ReserveVO> getReservationList(Long seminarPk);
    
    List<ReserveVO> getUserReservationList(Long userPk);

    // 특정 예약 상세 조회
    ReserveVO getReservationById(Long reservationPk);

    // 예약 승인
    void approveReservation(Long reservationPk);

    // 예약 거절
    void rejectReservation(Long reservationPk);

    // 예약 취소
    void cancelReservation(Long reservationPk);
}
