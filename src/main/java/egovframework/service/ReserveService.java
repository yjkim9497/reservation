package egovframework.service;

import java.time.LocalDate;
import java.util.List;

import egovframework.vo.ReserveVO;

public interface ReserveService {
	List<ReserveVO> getReservationsByDate(LocalDate date);
	ReserveVO bookReservation(Long id, Long userId);
	void addAvailableReservation(ReserveVO reserve);
	List<ReserveVO> getUserReservations(Long userId);
	void approveReservation(Long id, int numberOfPeople);
    void cancelReservation(Long id, int numberOfPeople);
    void deleteReservation(Long id);
    List<ReserveVO> getAllReservations();
}
