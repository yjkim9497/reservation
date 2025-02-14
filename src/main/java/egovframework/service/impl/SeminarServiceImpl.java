package egovframework.service.impl;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.SeminarMapper;
import egovframework.service.SeminarService;
import egovframework.vo.SeminarVO;

@Service
public class SeminarServiceImpl implements SeminarService {
	
	@Autowired
	private SeminarMapper seminarMapper;
	
	// 세미나 추가
	@Override
    public void insertSeminar(SeminarVO seminarVO) throws Exception {
		seminarMapper.insertSeminar(seminarVO);
    }

    // 세미나 날짜로 세미나 조회
    @Override
    public List<SeminarVO> getSeminarsByDate(LocalDate date) {
    	System.out.println("세미나 조회 서비스단");
        return seminarMapper.findByDate(date);
    }

    // 세미나의 정원과 현재 예약 인원 조회
    @Override
    public Map<String, Integer> getSeminarCapacityAndCurrentPeople(Long seminarPk) {
        return seminarMapper.getSeminarCapacityAndCurrentPeople(seminarPk);
    }

    // 세미나 예약 인원 업데이트
    @Override
    public void updateSeminarCurrentPeople(Long seminarPk, int seminarCurrentPeople) {
        seminarMapper.updateSeminarCurrentPeople(seminarPk, seminarCurrentPeople);
    }

}
