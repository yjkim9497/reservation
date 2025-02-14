package egovframework.vo;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ReserveVO {
	private Long reservationPk;       // 예약 ID
    private String reservationName;   // 예약자명
    private String reservationPhone;  // 휴대폰번호 (암호화 필요)
    private String reservationEmail;  // 이메일 (암호화 필요)
    private Date reservationBirth;    // 생년월일
    private int reservationNumber;    // 예약 인원
    private boolean reservationLogin; // 로그인 여부
    private String reservationStatus; // 예약 상태 (APPLYING, PROGRESSING, COMPLETED)
    private Timestamp reservationTime; // 예약 신청 시간
    private Long userPk;              // 유저 ID
    private Long seminarPk;           // 세미나 ID
	public Long getReservationPk() {
		return reservationPk;
	}
	public void setReservationPk(Long reservationPk) {
		this.reservationPk = reservationPk;
	}
	public String getReservationName() {
		return reservationName;
	}
	public void setReservationName(String reservationName) {
		this.reservationName = reservationName;
	}
	public String getReservationPhone() {
		return reservationPhone;
	}
	public void setReservationPhone(String reservationPhone) {
		this.reservationPhone = reservationPhone;
	}
	public String getReservationEmail() {
		return reservationEmail;
	}
	public void setReservationEmail(String reservationEmail) {
		this.reservationEmail = reservationEmail;
	}
	public Date getReservationBirth() {
		return reservationBirth;
	}
	public void setReservationBirth(Date reservationBirth) {
		this.reservationBirth = reservationBirth;
	}
	public int getReservationNumber() {
		return reservationNumber;
	}
	public void setReservationNumber(int reservationNumber) {
		this.reservationNumber = reservationNumber;
	}
	public boolean isReservationLogin() {
		return reservationLogin;
	}
	public void setReservationLogin(boolean reservationLogin) {
		this.reservationLogin = reservationLogin;
	}
	public String getReservationStatus() {
		return reservationStatus;
	}
	public void setReservationStatus(String reservationStatus) {
		this.reservationStatus = reservationStatus;
	}
	public Timestamp getReservationTime() {
		return reservationTime;
	}
	public void setReservationTime(Timestamp reservationTime) {
		this.reservationTime = reservationTime;
	}
	public Long getUserPk() {
		return userPk;
	}
	public void setUserPk(Long userPk) {
		this.userPk = userPk;
	}
	public Long getSeminarPk() {
		return seminarPk;
	}
	public void setSeminarPk(Long seminarPk) {
		this.seminarPk = seminarPk;
	}
	
    
}

