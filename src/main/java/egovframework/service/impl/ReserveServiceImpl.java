package egovframework.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.ReserveMapper;
import egovframework.mapper.SeminarMapper;
import egovframework.service.ReserveService;
import egovframework.vo.ReserveVO;
import egovframework.vo.SeminarVO;

@Service
public class ReserveServiceImpl implements ReserveService {
	
	@Autowired
	private ReserveMapper reserveMapper;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
	
	@Autowired
	private SeminarMapper seminarMapper;

	@Override
	@Transactional
	public ReserveVO bookReservation(ReserveVO reserveVO) {
		
		SeminarVO seminar = seminarMapper.findByPk(reserveVO.getSeminarPk());
		
		if (seminar == null) {
	        throw new IllegalArgumentException("해당 세미나가 존재하지 않습니다.");
	    }

	    Long seminarPk = reserveVO.getSeminarPk();
	    int currentPeople = seminar.getSeminarCurrentPeople();  // 현재 참여 인원
	    int capacity = seminar.getSeminarCapacity();  // 세미나 최대 인원
	    int reservationNumber = reserveVO.getReservationNumber();  // 새로 예약하려는 인원
	    // 2. 정원 초과 여부 확인
	    if (currentPeople + reservationNumber > capacity) {
	        throw new IllegalStateException("정원이 초과되어 예약할 수 없습니다.");
	    } else if (currentPeople + reservationNumber == capacity) {
	    	seminarMapper.updateSeminarStatus(seminarPk);
	    }
		reserveMapper.insertReservation(reserveVO);
		reserveMapper.updateSeminarCurrentPeople(seminarPk, reservationNumber);
		return reserveVO;
    }
	
	@Override
    public List<ReserveVO> getReservationList(Long seminarPk) {
        List<ReserveVO> reservations = reserveMapper.selectReservationList(seminarPk);
        
        return reservations.stream()
        		.map(reservation -> {
        			reservation.setReservationEmail(cryptoService.decrypt(reservation.getReservationEmail()));
        			reservation.setReservationPhone(cryptoService.decrypt(reservation.getReservationPhone()));
        			return reservation;
        		})
        		.collect(Collectors.toList());
    }
	
	@Override
	public List<ReserveVO> getUserReservationList(Long userPk) {
		List<ReserveVO> reservations = reserveMapper.userReservationList(userPk);
		
		return reservations.stream()
				.map(reservation -> {
					reservation.setReservationEmail(cryptoService.decrypt(reservation.getReservationEmail()));
					reservation.setReservationPhone(cryptoService.decrypt(reservation.getReservationPhone()));
					return reservation;
				})
				.collect(Collectors.toList());
	}

    @Override
    public ReserveVO getReservationById(Long reservationPk) {
        return reserveMapper.selectReservationById(reservationPk);
    }

    @Override
    @Transactional
    public void approveReservation(Long reservationPk) {
        // 1. 예약 상태를 PROGRESSING으로 변경
    	reserveMapper.approveReservation(reservationPk);

        // 2. 세미나의 현재 인원 업데이트
//    	reserveMapper.updateSeminarCurrentPeople(reservationPk);
    }
//    public boolean approveReservation(Long reservationPk) {
//    	reserveMapper.updateSeminarCurrentPeople(reservationPk);
//        return reserveMapper.approveReservation(reservationPk) > 0;
//    }

    @Override
    @Transactional
    public void rejectReservation(Long reservationPk) {
        ReserveVO reserve = reserveMapper.selectReservationById(reservationPk);
        int reservationNumber = reserve.getReservationNumber();
        reserveMapper.rejectReservation(reservationPk);
        reserveMapper.changeCurrentPeople(reserve.getSeminarPk(), reservationNumber);
    }

    @Override
    @Transactional
    public void cancelReservation(Long reservationPk) {
        ReserveVO reserve = reserveMapper.selectReservationById(reservationPk);
        int reservationNumber = reserve.getReservationNumber();
        reserveMapper.cancelReservation(reservationPk);
        reserveMapper.changeCurrentPeople(reserve.getSeminarPk(), reservationNumber);
    }

}
