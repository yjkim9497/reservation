package egovframework.mapper;


import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

@Mapper
public interface UserMapper {
	void insertUser(UserVO userVO);  // 회원가입
	LoginVO actionLogin(LoginVO loginVO);
    UserVO selectUser(String id);   // 회원 정보 조회
    
    List<UserVO> selectAllUsers();
    
    void deleteUser(String id);
    void updateUser(UserVO user);
    
    int countById(String id);
}
