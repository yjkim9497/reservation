package egovframework.service;

import java.util.List;

import egovframework.vo.UserVO;

public interface UserService {
	void registerUser(UserVO userVO);  // 회원가입
    UserVO getUser(String id); 
    
    List<UserVO> getAllUsers();
    
    void deleteUser(String id); // 삭제 메서드
    void updateUser(UserVO user); // 수정 메서드
    
    boolean isDuplicateId(String id);
}
