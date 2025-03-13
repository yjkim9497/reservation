package egovframework.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.UserMapper;
import egovframework.service.UserService;
import egovframework.vo.UserVO;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
    private UserMapper userMapper;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;

    @Override
    public void registerUser(UserVO userVO) {
    	
    	if (userVO.getUserRegDate() == null) {
            userVO.setUserRegDate(LocalDateTime.now());
        }
        userMapper.insertUser(userVO);
    }

    @Override
    public UserVO getUser(Long userPk) {
        return userMapper.selectUser(userPk);
    }
    
    @Override
    public List<UserVO> getAllUsers() {
    	List<UserVO> users = userMapper.selectAllUsers();

        // 이메일과 연락처 복호화 처리
        return users.stream()
            .map(user -> {
            	// 이메일이 존재하는 경우만 복호화
                if (user.getUserEmail() != null && !user.getUserEmail().isEmpty()) {
                    user.setUserEmail(cryptoService.decrypt(user.getUserEmail()));
                }

                // 연락처가 존재하는 경우만 복호화 및 포맷팅
                if (user.getUserPhone() != null && !user.getUserPhone().isEmpty()) {
                    String decryptedPhone = cryptoService.decrypt(user.getUserPhone());
                    user.setUserPhone(formatPhone(decryptedPhone));
                }
//                user.setUserEmail(cryptoService.decrypt(user.getUserEmail()));
//                user.setUserPhone(formatPhone(cryptoService.decrypt(user.getUserPhone())));
                user.setRegDateFormatted(formatRegDate(user.getUserRegDate()));
                return user;
            })
            .collect(Collectors.toList());
    }
    
 // 전화번호 포매팅 메서드
    private String formatPhone(String phone) {
        if (phone != null && phone.length() == 11) {
            return phone.replaceAll("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        }
        return phone;
    }

    // 가입일 포매팅 메서드
    private String formatRegDate(LocalDateTime regDate) {
        if (regDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년MM월dd일");
            return regDate.format(formatter);
        }
        return null;
    }
    
    @Override
    public void deleteUser(Long userPk) {
        userMapper.deleteUser(userPk);
    }

    @Override
    public void updateUser(UserVO user) {
        userMapper.updateUser(user);
    }
    
    @Override
    public boolean isDuplicateId(String id) {
        int count = userMapper.countById(id);
        return count > 0;
    }
}
