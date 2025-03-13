package egovframework.service;

import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

public interface LoginService {
//	boolean loginUser(LoginVO loginVO); // 로그인
	
	LoginVO actionLogin(LoginVO vo) throws Exception;
	
	String getAccessToken(String authorizeCode);
	
	UserVO getuserinfo(String accessToken, HttpSession session, RedirectAttributes rttr);
}
