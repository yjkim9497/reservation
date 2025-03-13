package egovframework.service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Map;

import egovframework.vo.SeminarVO;

/**
 * @author SAMSUNG
 *
 */
/**
 * @author SAMSUNG
 *
 */
/**
 * @author SAMSUNG
 *
 */
/**
 * @author SAMSUNG
 *
 */
/**
 * @author SAMSUNG
 *
 */
public interface SeminarService {
	
	// 세미나 추가
	/**
	 * @param seminarVO
	 * @throws Exception
	 */
	void insertSeminar(SeminarVO seminarVO) throws Exception;
	
	// 세미나 날짜로 세미나 조회
    /**
     * @param date
     * @return
     */
    List<SeminarVO> getSeminarsByDate(LocalDate date);
    
    /**
     * @return
     */
    List<SeminarVO> getAllSeminars();

    // 세미나의 정원과 현재 예약 인원 조회
    /**
     * @param seminarPk
     * @return
     */
    Map<String, Integer> getSeminarCapacityAndCurrentPeople(Long seminarPk);

    // 세미나 예약 인원 업데이트
    /**
     * @param seminarPk
     * @param seminarCurrentPeople
     */
    void updateSeminarCurrentPeople(Long seminarPk, int seminarCurrentPeople);

	/**
	 * @param seminarPk
	 * @throws Exception
	 */
	void deleteSeminar(Long seminarPk) throws Exception;
	
	/**
	 * @param seminarPk
	 * @throws Exception
	 */
	void completeSeminar(Long seminarPk) throws Exception;

	/**
	 * @param seminarPk
	 * @return
	 */
	SeminarVO findSeminar(Long seminarPk);
	
	/**
	 * @return
	 */
	public List<Map<Date, Date>> getSeminarDates();
}
