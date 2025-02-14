package egovframework.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.mapper.BoardMapper;
import egovframework.service.BoardService;
import egovframework.vo.BoardVO;
import egovframework.vo.SampleDefaultVO;
import egovframework.vo.SampleVO;

@Service("boardService")
public class BoardServiceImpl implements BoardService{
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleServiceImpl.class);

	
	@Resource(name="boardMapper")
	private BoardMapper boardmapper;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 글을 등록한다.
	 * @param vo - 등록할 정보가 담긴 SampleVO
	 * @return 등록 결과
	 * @exception Exception
	 */
	@Override
	public String insertBoard(BoardVO vo) throws Exception {
		LOGGER.debug(vo.toString());

		/** ID Generation Service */
//		String id = egovIdGnrService.getNextStringId();
//		vo.setBoardPk(id);
		LOGGER.debug(vo.toString());

		boardmapper.insertBoard(vo);
		return vo.getBoardPk();
	}

	/**
	 * 글을 수정한다.
	 * @param vo - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void updateBoard(BoardVO vo) throws Exception {
		boardmapper.updateBoard(vo);
	}

	/**
	 * 글을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void deleteBoard(BoardVO vo) throws Exception {
		boardmapper.deleteBoard(vo);
	}

	/**
	 * 글을 조회한다.
	 * @param vo - 조회할 정보가 담긴 SampleVO
	 * @return 조회한 글
	 * @exception Exception
	 */
	@Override
	public BoardVO selectBoard(BoardVO vo) throws Exception {
		BoardVO resultVO = boardmapper.selectBoard(vo);
//		if (resultVO == null)
//			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectBoardList(SampleDefaultVO searchVO) throws Exception {
		return boardmapper.selectBoardList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	@Override
	public int selectBoardListTotCnt(SampleDefaultVO searchVO) {
		return boardmapper.selectBoardListTotCnt(searchVO);
	}
}
