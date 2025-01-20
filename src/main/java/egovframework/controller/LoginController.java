package egovframework.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.service.LoginService;
import egovframework.vo.LoginVO;

@Controller
public class LoginController {
	
	@Resource(name = "loginService")
	private LoginService loginService;
	
	 @Resource(name = "egovEnvPasswordEncoderService")
	    EgovPasswordEncoder egovPasswordEncoder;
	
	// 로그인 페이지로 이동
//    @RequestMapping(value = "/login.do")
//    public String loginPage() {
//        return "login";
//    }

    // 로그인 처리
//    @RequestMapping(value = "/login", method = RequestMethod.POST)
//    public String loginUser(@ModelAttribute LoginVO loginVO, Model model) {
//    	System.out.println("아이디"+loginVO.getId());
//		System.out.println("비밀번호"+loginVO.getPassword());
//    	System.out.println("로그인 성공여부"+loginService.loginUser(loginVO));
//        if (loginService.loginUser(loginVO)) {
//        	System.out.println("로그인성공");
//            return "signup";
//        } else {
//            model.addAttribute("error", "로그인 정보가 올바르지 않습니다.");
//            return "login";
//        }
//    }
    
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
	public String actionLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, Model model) throws Exception {
		System.out.println("로그인 컨트롤러");
		System.out.println("vo 아이디"+loginVO.getId());
		
		// 입력된 비밀번호 암호화
		String hashedPassword = egovPasswordEncoder.encryptPassword(loginVO.getPassword());
        loginVO.setPassword(hashedPassword);
	    
		// 1. 일반 로그인 처리
		LoginVO resultVO = loginService.actionLogin(loginVO);
		if (resultVO == null) {
		    System.out.println("resultVO가 null입니다.");
		    model.addAttribute("message", "로그인에 실패하였습니다.");
		    return "login";
		}
		System.out.println("아이디"+resultVO.getId());
		boolean loginPolicyYn = true;

		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("") && loginPolicyYn) {
			System.out.println("로그인 정보 전송 성공");
			request.getSession().setAttribute("LoginVO", resultVO);
			LoginVO sessionUser = (LoginVO) request.getSession().getAttribute("LoginVO");
			if (sessionUser != null) {
			    System.out.println("세션에 저장된 사용자 ID: " + sessionUser.getId());
			} else {
			    System.out.println("세션에 데이터가 없습니다.");
			}
			return "forward:egovSampleList.do";
		} else {

			model.addAttribute("message", "로그인에 실패하였습니다.");
			return "login";
		}

	}

	/**
	 * 로그인 후 메인화면으로 들어간다
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/uat/uia/actionMain.do")
	public String actionMain(ModelMap model) throws Exception {

		// 1. 사용자 인증 처리
//		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//		if (!isAuthenticated) {
//			model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
//			return "cmm/uat/uia/EgovLoginUsr";
//		}

		// 2. 메인 페이지 이동
		return "forward:egovSampleList";
	}
	
	@RequestMapping(value = "/logout.do")
    public String logout(HttpServletRequest request) throws Exception {
        // 세션에서 LoginVO 객체 제거
        request.getSession().invalidate();
        return "redirect:/egovSampleList.do"; // 로그아웃 후 홈으로 리다이렉트
    }

}
