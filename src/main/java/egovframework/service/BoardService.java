package egovframework.service;

import java.util.List;

import egovframework.vo.BoardVO;
import egovframework.vo.SampleDefaultVO;

public interface BoardService {
	String insertBoard(BoardVO vo) throws Exception;
	
	void updateBoard(BoardVO vo) throws Exception;
	
	void deleteBoard(BoardVO vo) throws Exception;
	
	BoardVO selectBoard(BoardVO vo) throws Exception;
	
	List<?> selectBoardList(SampleDefaultVO searchVO) throws Exception;
	
	int selectBoardListTotCnt(SampleDefaultVO searchVO);
}
