package egovframework.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.mapper.BoardMapper;
import egovframework.service.BoardService;
import egovframework.vo.BoardVO;
import egovframework.vo.SampleDefaultVO;

@Service("boardService")
public class BoardServiceImpl implements BoardService{

	
	@Resource(name="boardMapper")
	private BoardMapper boardmapper;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 글을 등록한다.
	 * @return 등록 결과
	 * @exception Exception
	 */
	@Override
	public Long insertBoard(BoardVO vo) throws Exception {
		boardmapper.insertBoard(vo);
		return vo.getBoardPk();
	}

	/**
	 * 글을 수정한다.
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void updateBoard(BoardVO vo) throws Exception {
		boardmapper.updateBoard(vo);
	}

	/**
	 * 글을 삭제한다.
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void deleteBoard(BoardVO vo) throws Exception {
		boardmapper.deleteBoard(vo);
	}

	/**
	 * 글을 조회한다.
	 * @return 조회한 글
	 * @exception Exception
	 */
	@Override
	public BoardVO selectBoard(Long boardPk) throws Exception {
		BoardVO resultVO = boardmapper.selectBoard(boardPk);
//		if (resultVO == null)
//			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 글 목록을 조회한다.
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectBoardList(SampleDefaultVO searchVO) throws Exception {
		return boardmapper.selectBoardList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다.
	 * @return 글 총 갯수
	 * @exception
	 */
	@Override
	public int selectBoardListTotCnt(SampleDefaultVO searchVO) {
		return boardmapper.selectBoardListTotCnt(searchVO);
	}
}
