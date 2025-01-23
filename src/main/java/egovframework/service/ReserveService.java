package egovframework.service;

import java.time.LocalDate;
import java.util.List;

import egovframework.vo.ReserveVO;

public interface ReserveService {
	List<ReserveVO> getReservationsByDate(LocalDate date);
	ReserveVO bookReservation(Long id);
}
