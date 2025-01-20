package egovframework.service.impl;

import org.apache.ibatis.session.SqlSession;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.vo.LoginVO;


@Repository("loginDAO")
public class LoginDAO extends EgovAbstractMapper {
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
	
	@Autowired
	private SqlSession sqlSession;
	
	public LoginVO actionLogin(LoginVO vo) throws Exception {
		System.out.println("dao단으로 넘어옴");
		System.out.println("DAO에서 받은 파라미터: " + vo.getId() + ", " + vo.getPassword());
	    LoginVO result = sqlSession.selectOne("egovframework.mapper.UserMapper.actionLogin", vo);
	    System.out.println("DAO에서 반환된 결과: " + (result != null ? result.getId() : "null"));
	    return result;
	}
}
