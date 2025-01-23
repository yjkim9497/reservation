package egovframework.vo;

import java.time.LocalDate;

import javax.persistence.Column;

public class ReserveVO {
	private String id;
	
	private LocalDate date; // 예약 날짜
	@Column(name = "time_slot")
    private String timeSlot; // 예약 시간대
    private String status; // 예약 상태 (예: "가능", "완료")
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public LocalDate getDate() {
		return date;
	}
	public void setDate(LocalDate date) {
		this.date = date;
	}
	public String getTimeSlot() {
		return timeSlot;
	}
	public void setTimeSlot(String timeSlot) {
		this.timeSlot = timeSlot;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
    
    
	
}

