package egovframework.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

@Mapper
public interface UserMapper {
	void insertUser(UserVO userVO);  // 회원가입
	LoginVO actionLogin(LoginVO loginVO);
    UserVO selectUser(Long userPk);   // 회원 정보 조회
    
    List<UserVO> selectAllUsers();
    UserVO findkakao(String userId);
    void kakaoinsert(@Param("userId")String userId,@Param("userName")String userName);
    
    void deleteUser(Long userPk);
    void updateUser(UserVO user);
    
    void updateLockCount(String userId);
    
    int countById(String id);
    int getLockCount(String userId); // 현재 로그인 실패 횟수 조회
    void lockUserAccount(String userId); // 계정 잠금 처리 (user_lock = true)
    boolean isUserLocked(String userId); // 계정이 잠겨있는지 확인
    void resetLockCount(String userId); // 로그인 성공 시 잠금 횟수 초기화
    
    void unlockUserAccount(Long userPk);
}
