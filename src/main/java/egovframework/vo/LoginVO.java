package egovframework.vo;

public class LoginVO {
	private Long userPk;
	private String userId;       // 사용자 ID
    private String userPassword; // 비밀번호
    private UserRole userRole;
    
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
    

}
