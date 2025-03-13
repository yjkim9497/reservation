package egovframework.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
//import org.egovframe.rte.fdl.string.EgovStringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.mapper.UserMapper;
import egovframework.rte.fdl.string.EgovStringUtil;
import egovframework.service.LoginService;
import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

@Controller
public class LoginController {
	
	@Resource(name = "loginService")
	private LoginService loginService;
	
	@Resource
	private UserMapper userMapper;
	
	@Resource(name = "egovEnvPasswordEncoderService")
    EgovPasswordEncoder egovPasswordEncoder;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
	
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "login.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "login";
	}
	
	@RequestMapping(value = "reservation.do")
	public String reservationView() throws Exception {
		return "reservation";
	}

	/**
	 * 일반 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/actionLogin.do", method = RequestMethod.POST)
	@ResponseBody
    public Map<String, Object> actionLogin(@RequestBody LoginVO vo, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        try {
            LoginVO loginVO = loginService.actionLogin(vo);
            if(userMapper.countById(vo.getUserId())!= 0) {
            	boolean isLocked = userMapper.isUserLocked(vo.getUserId()); // user_lock 값 조회
            	if (isLocked) {
            		response.put("status", "fail");
            		response.put("message", "계정이 잠겼습니다. 관리자에게 문의하세요.");
            		return response;
            	}
        	}
            // 사용자의 현재 잠김 상태 확인
            
            if (loginVO != null && EgovStringUtil.isNotEmpty(loginVO.getUserId())) {
            	// 로그인 성공 시, 잠금 횟수 초기화
                userMapper.resetLockCount(vo.getUserId());
            	UserVO loginUser = userMapper.selectUser(loginVO.getUserPk());
            	loginUser.setUserEmail(cryptoService.decrypt(loginUser.getUserEmail()));
            	loginUser.setUserPhone(cryptoService.decrypt(loginUser.getUserPhone()));
            	request.getSession().setAttribute("LoginVO", loginUser);
//            	LoginVO sessionUser = (LoginVO) request.getSession().getAttribute("LoginVO");
                response.put("status", "success");
                response.put("message", "로그인 성공!");
                response.put("userRole", loginVO.getUserRole());
            } else if(loginVO == null) {
            	if(userMapper.countById(vo.getUserId())== 0) {
            		response.put("status", "fail");
                    response.put("message", "존재하지 않는 아이디입니다.");
            	} else {
            		userMapper.updateLockCount(vo.getUserId());
            		int lockCount = userMapper.getLockCount(vo.getUserId());
            		if (lockCount >= 5) {
                        // 계정 잠금 처리
                        userMapper.lockUserAccount(vo.getUserId());

                        response.put("status", "fail");
                        response.put("message", "비밀번호를 5회 틀려 계정이 잠겼습니다. 관리자에게 문의하세요.");
                    } else {
                        response.put("status", "fail");
                        response.put("message", "비밀번호를 틀렸습니다. (" + lockCount + "/5)");
                    }
            	}
            }
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "서버 오류 발생: " + e.getMessage());
        }

        return response;
    }

	
	@RequestMapping(value = "/kakaoLogin.do")
	public String oauthKakao(
	        @RequestParam(value = "code",required = false) String code
	        , HttpSession session, RedirectAttributes rttr, @ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, Model model) throws Exception {
	    String accessToken = loginService.getAccessToken(code);
	    UserVO resultVO = loginService.getuserinfo(accessToken, session, rttr);
	    

	    if (resultVO != null && resultVO.getUserId() != null && !resultVO.getUserId().equals("")) {
			UserVO loginUser = userMapper.selectUser(resultVO.getUserPk());
			if(loginUser.getUserEmail()!= null) {
				loginUser.setUserEmail(cryptoService.decrypt(loginUser.getUserEmail()));
			}
			if(loginUser.getUserPhone()!= null) {
				loginUser.setUserPhone(cryptoService.decrypt(loginUser.getUserPhone()));
			}
			request.getSession().setAttribute("LoginVO", resultVO);
			return "forward:main.do";
		} else {

			model.addAttribute("message", "로그인에 실패하였습니다.");
			return "login";
		}
	}
	
	@RequestMapping(value = "/logout.do")
    public String logout(HttpServletRequest request) throws Exception {
        // 세션에서 LoginVO 객체 제거
        request.getSession().invalidate();
        return "redirect:/main.do"; // 로그아웃 후 홈으로 리다이렉트
    }

}
