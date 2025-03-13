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
	 * @return LoginVO
	 * @exception Exception
	 */
	
	@Autowired
	private SqlSession sqlSession;
	
	public LoginVO actionLogin(LoginVO vo) throws Exception {
	    LoginVO result = sqlSession.selectOne("egovframework.mapper.UserMapper.actionLogin", vo);
	    return result;
	}
}
