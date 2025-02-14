package egovframework.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import egovframework.vo.SeminarVO;

public interface SeminarService {
	
	// 세미나 추가
	void insertSeminar(SeminarVO seminarVO) throws Exception;
	
	// 세미나 날짜로 세미나 조회
    List<SeminarVO> getSeminarsByDate(LocalDate date);

    // 세미나의 정원과 현재 예약 인원 조회
    Map<String, Integer> getSeminarCapacityAndCurrentPeople(Long seminarPk);

    // 세미나 예약 인원 업데이트
    void updateSeminarCurrentPeople(Long seminarPk, int seminarCurrentPeople);
}
