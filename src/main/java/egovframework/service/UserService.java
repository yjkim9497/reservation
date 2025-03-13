package egovframework.service;

import java.util.List;

import egovframework.vo.UserVO;


public interface UserService {
	
	
	/**
	 * @param userVO
	 */
	void registerUser(UserVO userVO);  // 회원가입
    /**
     * @param userPk
     * @return
     */
    UserVO getUser(Long userPk); 
    
    /**
     * @return
     */
    List<UserVO> getAllUsers();
    
    /**
     * @param userPk
     */
    void deleteUser(Long userPk); // 삭제 메서드
    /**
     * @param user
     */
    void updateUser(UserVO user); // 수정 메서드
    
    /**
     * @param id
     * @return
     */
    boolean isDuplicateId(String id);
}
