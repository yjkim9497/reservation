package egovframework.service;

import egovframework.vo.LoginVO;

public interface LoginService {
//	boolean loginUser(LoginVO loginVO); // 로그인
	
	public LoginVO actionLogin(LoginVO vo) throws Exception;
}
