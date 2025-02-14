package egovframework.vo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

public class UserVO {
	
	private Long userPk;             // 기본 키 (AUTO_INCREMENT)
    private String userId;           // 사용자 ID
    private String userPassword;     // 비밀번호
    private UserRole userRole = UserRole.GENERAL;         // 역할   GENERAL, ADMIN
    private String userName;         // 이름
    private String userEmail;        // 이메일
    private String userPhone;        // 전화번호
    private Date userBirth;     // 생년월일
    private LocalDateTime userRegDate; // 가입일 (기본값: 현재 시간)
    private Boolean userLock = false;        // 계정 잠금 여부
    private Integer userLockCount = 0;   // 계정 잠금 횟수
    
    private String regDateFormatted; // 포매팅된 가입일

    public String getRegDateFormatted() {
        return regDateFormatted;
    }

    public void setRegDateFormatted(String regDateFormatted) {
        this.regDateFormatted = regDateFormatted;
    }
    
	public Long getUserPk() {
		return userPk;
	}
	public void setUserPk(Long userPk) {
		this.userPk = userPk;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public UserRole getUserRole() {
		return userRole;
	}
	public void setUserRole(UserRole userRole) {
		this.userRole = userRole;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public Date getUserBirth() {
		return userBirth;
	}
	public void setUserBirth(Date userBirth) {
		this.userBirth = userBirth;
	}
	public LocalDateTime getUserRegDate() {
		return userRegDate;
	}
	public void setUserRegDate(LocalDateTime userRegDate) {
		this.userRegDate = userRegDate;
	}
	public Boolean getUserLock() {
		return userLock;
	}
	public void setUserLock(Boolean userLock) {
		this.userLock = userLock;
	}
	public Integer getUserLockCount() {
		return userLockCount;
	}
	public void setUserLockCount(Integer userLockCount) {
		this.userLockCount = userLockCount;
	}

    
    
    
}
