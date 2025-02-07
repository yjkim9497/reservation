package egovframework.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.ReserveStatus;
import egovframework.vo.ReserveVO;

@Mapper
public interface ReserveMapper {
	// 날짜로 예약 목록 조회
    List<ReserveVO> findByDate(@Param("date") LocalDate date);

    // ID로 예약 조회
    ReserveVO findById(@Param("id") Long id);

    // 모든 예약 조회
    List<ReserveVO> findAllReservations();

    // 예약 상태 업데이트
    void updateReservationStatus(@Param("id") Long id, 
                                 @Param("status") ReserveStatus status,
                                 @Param("userId") Long userId);

    // 예약 가능 시간 추가 (관리자)
    void addAvailableReservation(ReserveVO reserve);

    // 사용자의 예약 목록 조회
    List<ReserveVO> getUserReservations(@Param("userId") Long userId);

    // 예약 승인 (관리자) -> numberOfPeople 증가 처리
    void approveReservation(@Param("id") Long id, @Param("numberOfPeople") int numberOfPeople);

    // 예약 취소 (관리자 또는 사용자) -> numberOfPeople 감소 처리
    void cancelReservation(@Param("id") Long id, @Param("numberOfPeople") int numberOfPeople);

    // 예약 삭제 (관리자)
    void deleteReservation(@Param("id") Long id);

    // 현재 예약된 인원 조회
    int getCurrentReservationCount(@Param("date") LocalDate date, @Param("timeSlot") String timeSlot);

    // 예약 인원 증가 (예약 승인 시, 정원 초과 방지)
    void increaseReservationCount(@Param("id") Long id, @Param("numberOfPeople") int numberOfPeople);

    // 예약 인원 감소 (예약 취소 시)
    void decreaseReservationCount(@Param("id") Long id, @Param("numberOfPeople") int numberOfPeople);

    // 사용자 예약 추가
    void addUserReservation(ReserveVO reserve);
}
