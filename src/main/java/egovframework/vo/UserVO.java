package egovframework.vo;

import java.time.LocalDateTime;
import java.util.Date;

import javax.persistence.Column;

public class UserVO {
	private String id;       // 사용자 ID
    private String password; // 비밀번호
    private String role = "general"; // 기본값 general
    private String name;     // 이름
    private String email;    // 이메일
    private String phone;    // 전화번호
    private Date birth;	// 생년월일
    @Column(name = "reg_date")
    private LocalDateTime regDate;  // 가입일
    
    private String regDateFormatted; // 포매팅된 가입일

    public String getRegDateFormatted() {
        return regDateFormatted;
    }

    public void setRegDateFormatted(String regDateFormatted) {
        this.regDateFormatted = regDateFormatted;
    }
    
 // 기본 생성자
    public UserVO() {
        this.role = "general"; // 기본값 설정
    }
    
    public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Date getBirth() {
		return birth;
	}
	public void setBirth(Date birth) {
		this.birth = birth;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}

    
    
    
}
