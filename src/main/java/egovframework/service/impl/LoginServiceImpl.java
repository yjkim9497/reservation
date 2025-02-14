package egovframework.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.UserMapper;
import egovframework.service.LoginService;
import egovframework.vo.LoginVO;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;

	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
	@Override
	public LoginVO actionLogin(LoginVO vo) throws Exception {
		
		System.out.println("로그인 서비스");

		// 1. 입력한 비밀번호를 암호화한다.
//		String enpassword = EgovFileScrty.encryptPassword(vo.getPassword(), vo.getId());
//		vo.setPassword(enpassword);

		// 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
		LoginVO loginVO = loginDAO.actionLogin(vo);
		
		if (loginVO == null) {
		    System.out.println("loginVO가 null입니다. DAO에서 데이터를 조회하지 못했습니다.");
		} else {
		    System.out.println("서비스 로그인 dao" + loginVO.getUserId());
		}
		
		System.out.println("서비스 로그인 vo의 role : "+loginVO.getUserRole());

		// 3. 결과를 리턴한다.
		if (loginVO != null && !loginVO.getUserId().equals("") && !loginVO.getUserPassword().equals("")) {
			return loginVO;
		} else {
			loginVO = new LoginVO();
		}

		return loginVO;
	}
	
	
//	@Resource(name="userMapper")
//	private UserMapper userDAO;
//	
//	@Override
//    public boolean loginUser(LoginVO loginVO) {
//		System.out.println("아이디"+loginVO.getId());
//		System.out.println("비밀번호"+loginVO.getPassword());
//    	boolean result = userDAO.loginUser(loginVO) > 0;
//    	System.out.println("로그인성공여부"+result);
//        return result;
//    }
}
