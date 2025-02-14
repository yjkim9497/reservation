package egovframework.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.SeminarVO;

@Mapper
public interface SeminarMapper {
	
	// 세미나 날짜로 세미나 조회
    List<SeminarVO> findByDate(@Param("seminarDate") LocalDate seminarDate);
    
   void insertSeminar(SeminarVO seminarVO);
    
    SeminarVO findByPk(@Param("seminarPk") Long seminarPk);

    // 세미나의 정원과 현재 예약 인원 조회
    Map<String, Integer> getSeminarCapacityAndCurrentPeople(@Param("seminarPk") Long seminarPk);

    // 세미나 예약 인원 업데이트
    void updateSeminarCurrentPeople(@Param("seminarPk") Long seminarPk, @Param("seminarCurrentPeople") int seminarCurrentPeople);
}
