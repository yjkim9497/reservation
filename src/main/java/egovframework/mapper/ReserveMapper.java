package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.ReserveVO;

@Mapper
public interface ReserveMapper {
	
	void insertReservation(ReserveVO reserveVO);
	
	// 예약 목록 조회
    List<ReserveVO> selectReservationList(@Param("seminarPk") Long seminarPk);
    
    List<ReserveVO> userReservationList(@Param("userPk") Long userPk);

    // 특정 예약 상세 조회
    ReserveVO selectReservationById(@Param("reservationPk") Long reservationPk);
    
    ReserveVO findReservation(@Param("reservationPk")Long reservationPk, @Param("reservationEmail")String reservationEmail);
    // 예약 승인
    int approveReservation(@Param("reservationPk") Long reservationPk);
    void updateSeminarCurrentPeople(@Param("seminarPk") Long seminarPk, @Param("reservationNumber") int reservationNumber);

    // 예약 거절
    void rejectReservation(@Param("reservationPk") Long reservationPk);
    void changeCurrentPeople(@Param("seminarPk") Long seminarPk, @Param("reservationNumber") int reservationNumber);

    // 예약 취소
    void cancelReservation(@Param("reservationPk") Long reservationPk);
}
