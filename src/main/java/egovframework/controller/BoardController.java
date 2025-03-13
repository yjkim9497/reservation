package egovframework.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.mapper.SeminarMapper;
import egovframework.service.BoardService;
import egovframework.vo.BoardVO;
import egovframework.vo.LoginVO;
import egovframework.vo.SampleDefaultVO;
import egovframework.vo.SeminarVO;
import egovframework.vo.UserVO;

@Controller
public class BoardController {
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	@Resource
	private SeminarMapper seminarMapper;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;
	
	@Resource(name = "egovEnvPasswordEncoderService")
    EgovPasswordEncoder egovPasswordEncoder;

	private static final String SUCCESS_KEY = "success";
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
		List<SeminarVO> seminars = seminarMapper.selectAllSeminars();
		model.addAttribute("boardVO", new BoardVO());
		model.addAttribute("seminars",seminars);
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
	@RequestMapping(value = "/addBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addBoard(
			@RequestParam(value = "file", required = false) MultipartFile file,
			@RequestParam(value = "seminarPk", required = false) Long seminarPk,
	        @RequestParam("boardTitle") String boardTitle,
	        @RequestParam("boardDescription") String boardDescription,
	        @RequestParam("boardPassword") String boardPassword,
	        HttpServletRequest request) {
	    Map<String, Object> response = new HashMap<>();
	    
	    try {

	        UserVO loginUser = (UserVO) request.getSession().getAttribute("LoginVO");

	        String hashedPassword = egovPasswordEncoder.encryptPassword(boardPassword);
	        String fileName = null;

	        // BoardVO 객체 생성
	        BoardVO boardVO = new BoardVO();
	        boardVO.setBoardTitle(boardTitle);
	        boardVO.setBoardDescription(boardDescription);
	        boardVO.setBoardPassword(hashedPassword);
	        if(loginUser != null) {
	        	boardVO.setUserPk(loginUser.getUserPk());
	        }

	        if (file!=null && !file.isEmpty()) { //file객체가 비어있지 않다면
	            
	    		String originalFileName = file.getOriginalFilename(); //파일의 실제 이름
	    		UUID uuid = UUID.randomUUID(); 
	    		fileName = uuid+originalFileName; 
	    		file.transferTo(new File(fileName));
	    		boardVO.setBoardFileName(fileName);
	    		boardVO.setBoardFilePath("./"+fileName);
	    		}
	        if (seminarPk != null) {
	        	boardVO.setSeminarPk(seminarPk);
	        }
	        boardService.insertBoard(boardVO);

	        response.put(SUCCESS_KEY, true);
	        response.put("message", "게시글이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        response.put(SUCCESS_KEY, false);
	        response.put("message", "서버 오류 발생: " + e.getMessage());
	    }

	    return response;
	}
	
	@RequestMapping("/boardDetail.do")
	public String boardDetail(@RequestParam("boardPk") Long boardPk, Model model) throws Exception {
		BoardVO board = boardService.selectBoard(boardPk);
		model.addAttribute("board",board);
		if(board.getSeminarPk() != null){
			String seminar = seminarMapper.findByPk(board.getSeminarPk()).getSeminarName();
			model.addAttribute("seminar",seminar);
		}
		return "boardDetail";
	}
	
	@RequestMapping(value = "/editBoard.do", method = RequestMethod.GET)
	public String boardEdit(@RequestParam("boardPk") Long boardPk, Model model) throws Exception {
		BoardVO board = boardService.selectBoard(boardPk);
		List<SeminarVO> seminars = seminarMapper.selectAllSeminars();
		model.addAttribute("seminars",seminars);
		model.addAttribute("board",board);
		return "editBoard";
	}

	@RequestMapping(value = "fileDownload.do")
	public void filedownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filename = request.getParameter("boardFileName");
		String encodedFilename = UriUtils.encode(filename, StandardCharsets.UTF_8);
		String realFilename = "";
		String browser = request.getHeader("User-Agent");
		if (browser.contains("MSIE")) {
		    encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.contains("Firefox")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.contains("Opera")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.contains("Chrome")) {
		    StringBuffer sb = new StringBuffer();
		    for (int i = 0; i < filename.length(); i++) {
			char c = filename.charAt(i);
			if (c > '~') {
			    sb.append(URLEncoder.encode("" + c, "UTF-8"));
			} else {
			    sb.append(c);
			}
		    }
		    encodedFilename = sb.toString();
		} else {
		    throw new IOException("Not supported browser");
		}
//		}
		
//		realFilename = "C:\\files\\"+filename;
		realFilename = "./"+filename;
		
		File file = new File(realFilename);
		if(!file.exists()) {
			return;
		}
		
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFilename + "\"");
		Path path = Paths.get(realFilename);
		try {
			OutputStream os = response.getOutputStream();
			InputStream fis = Files.newInputStream(path);
//			final FileInputStream fis = new FileInputStream(realFilename);
			
			int cnt = 0;
			byte[] bytes = new byte[512];
			
			while((cnt = fis.read(bytes)) != -1) {
				os.write(bytes, 0, cnt);
			}
			
			fis.close();
			os.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/board/verifyPassword.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Boolean>> verifyPassword(@RequestBody Map<String, Object> request) throws Exception {
	    Long boardPk = Long.valueOf(request.get("boardPk").toString());
	    String inputPassword = request.get("password").toString();
	    
	    // DB에서 저장된 게시글 정보 가져오기
	    BoardVO board = boardService.selectBoard(boardPk);
	    String storedPassword = board.getBoardPassword();

	    // 입력한 비밀번호와 저장된 암호화된 비밀번호 비교
	    egovPasswordEncoder.checkPassword(inputPassword, storedPassword);
	    boolean isMatch = egovPasswordEncoder.checkPassword(inputPassword, storedPassword);

	    return ResponseEntity.ok(Collections.singletonMap("success", isMatch));
	}


    @RequestMapping(value = "/board/delete.do", method = RequestMethod.DELETE)
	@ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteBoard(@RequestBody Map<String, Object> request) throws Exception {
        Long boardPk = Long.valueOf(request.get("boardPk").toString());
        BoardVO board = boardService.selectBoard(boardPk);
        boardService.deleteBoard(board);
        return ResponseEntity.ok(Collections.singletonMap("success", true));
    }
    
    @RequestMapping(value = "/editBoard.do", method = RequestMethod.POST)
    @ResponseBody
	public Map<String, Object> editBoard(
			@RequestParam("boardPk") Long boardPk,
			@RequestParam(value = "file", required = false) MultipartFile file,
			@RequestParam(value = "seminarPk", required = false) Long seminarPk,
	        @RequestParam("boardTitle") String boardTitle,
	        @RequestParam("boardDescription") String boardDescription,
	        @RequestParam("boardPassword") String boardPassword,
	        HttpServletRequest request) {
	    
	    Map<String, Object> response = new HashMap<>();
	    
	    try {
	        UserVO loginUser = (UserVO) request.getSession().getAttribute("LoginVO");

	        String hashedPassword = egovPasswordEncoder.encryptPassword(boardPassword);
	        String fileName = null;

	        // BoardVO 객체 생성
	        BoardVO boardVO = new BoardVO();
	        boardVO.setBoardPk(boardPk);
	        boardVO.setBoardTitle(boardTitle);
	        boardVO.setBoardDescription(boardDescription);
	        boardVO.setBoardPassword(hashedPassword);
	        if(loginUser != null) {
	        	boardVO.setUserPk(loginUser.getUserPk());
	        }

	        if (file != null && !file.isEmpty()) { //file객체가 비어있지 않다면
	            
	    		String originalFileName = file.getOriginalFilename(); //파일의 실제 이름
	    		UUID uuid = UUID.randomUUID(); 
	    		fileName = uuid+originalFileName; 
	    		file.transferTo(new File(fileName));
	    		boardVO.setBoardFileName(fileName);
	    		boardVO.setBoardFilePath("./"+fileName);
	    		}
	        if (seminarPk != null) {
	        	boardVO.setSeminarPk(seminarPk);
	        }
	        boardService.updateBoard(boardVO);

	        response.put("success", true);
	        response.put("message", "게시글을 수정하였습니다.");
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "서버 오류 발생: " + e.getMessage());
	    }

	    return response;
	}

}
