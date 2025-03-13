package egovframework.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class HolidayVO {
	private Long holidayPk;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date holidayStart;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date holidayEnd;
	public Long getHolidayPk() {
		return holidayPk;
	}
	public void setHolidayPk(Long holidayPk) {
		this.holidayPk = holidayPk;
	}
	public Date getHolidayStart() {
		return holidayStart;
	}
	public void setHolidayStart(Date holidayStart) {
		this.holidayStart = holidayStart;
	}
	public Date getHolidayEnd() {
		return holidayEnd;
	}
	public void setHolidayEnd(Date holidayEnd) {
		this.holidayEnd = holidayEnd;
	}
	
	
}
