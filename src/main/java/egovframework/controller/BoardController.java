package egovframework.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.service.BoardService;
import egovframework.vo.BoardVO;
import egovframework.vo.LoginVO;
import egovframework.vo.SampleDefaultVO;
import egovframework.vo.SampleVO;
import egovframework.vo.UserVO;

@Controller
public class BoardController {
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	
	/**
	 * 글 목록을 조회한다. (pageing)
	 * @param searchVO - 조회할 정보가 담긴 SampleDefaultVO
	 * @param model
	 * @return "egovSampleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/boardList.do")
	public String selectBoardList(@ModelAttribute("searchVO") SampleDefaultVO searchVO, ModelMap model) throws Exception {

		/** EgovPropertyService.sample */
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> boardList = boardService.selectBoardList(searchVO);
		model.addAttribute("resultList", boardList);

		int totCnt = boardService.selectBoardListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "boardList";
	}

	/**
	 * 글 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addBoard.do", method = RequestMethod.GET)
	public String addBoardView(@ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("boardVO", new BoardVO());
		return "boardRegister";
	}

	/**
	 * 글을 등록한다.
	 * @param sampleVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addBoard.do", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public Map<String, Object> addBoard(@RequestBody BoardVO boardVO, BindingResult bindingResult, HttpServletRequest request) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        System.out.println("게시글등록 컨트롤러");

	        LoginVO loginUser = (LoginVO) request.getSession().getAttribute("LoginVO");
	        System.out.println("로그인유저: " + (loginUser != null ? loginUser.getUserPk(): "로그인 안됨"));

	        if (loginUser == null) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return response;
	        }

	        boardVO.setUserPk(loginUser.getUserPk());

	        if (bindingResult.hasErrors()) {
	            response.put("success", false);
	            response.put("message", "입력값이 올바르지 않습니다.");
	            return response;
	        }

	        boardService.insertBoard(boardVO);
	        response.put("success", true);
	        response.put("message", "게시글이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "서버 오류 발생: " + e.getMessage());
	    }

	    return response; // ✅ JSON 응답 반환
	}


	/**
	 * 글 수정화면을 조회한다.
	 * @param id - 수정할 글 id
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateBoardView.do")
	public String updateBoardView(@RequestParam("selectedId") String id, @ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) throws Exception {
		BoardVO boardVO = new BoardVO();
		boardVO.setBoardPk(id);
		// 변수명은 CoC 에 따라 sampleVO
		model.addAttribute(selectBoard(boardVO, searchVO));
		return "egovSampleRegister";
	}

	/**
	 * 글을 조회한다.
	 * @param sampleVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return @ModelAttribute("sampleVO") - 조회한 정보
	 * @exception Exception
	 */
	public BoardVO selectBoard(BoardVO boardVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO) throws Exception {
		return boardService.selectBoard(boardVO);
	}

	/**
	 * 글을 수정한다.
	 * @param sampleVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateBoard.do")
	public String updateSample(@ModelAttribute("searchVO") SampleDefaultVO searchVO, BoardVO boardVO, BindingResult bindingResult, Model model, SessionStatus status)
			throws Exception {

		beanValidator.validate(boardVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("boardVO", boardVO);
			return "boardRegister";
		}

		boardService.updateBoard(boardVO);
		status.setComplete();
		return "forward:/boardList.do";
	}

	/**
	 * 글을 삭제한다.
	 * @param sampleVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteBoard.do")
	public String deleteSample(BoardVO boardVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO, SessionStatus status) throws Exception {
		boardService.deleteBoard(boardVO);
		status.setComplete();
		return "forward:/boardList.do";
	}

}
