package egovframework.vo;

import java.util.Date;

public class SeminarVO {
	
	private String seminarPk;
	private Date seminarDate;
	private String seminarName;
	private String seminarTimeSlot;
	private String seminarCapacity;
	private SeminarStatus seminarStatus;
	private String seminarCurrentPeople;
	
	public String getSeminarName() {
		return seminarName;
	}
	public void setSeminarName(String seminarName) {
		this.seminarName = seminarName;
	}
	public SeminarStatus getSeminarStatus() {
		return seminarStatus;
	}
	public void setSeminarStatus(SeminarStatus seminarStatus) {
		this.seminarStatus = seminarStatus;
	}
	public String getSeminarPk() {
		return seminarPk;
	}
	public void setSeminarPk(String seminarPk) {
		this.seminarPk = seminarPk;
	}
	public Date getSeminarDate() {
		return seminarDate;
	}
	public void setSeminarDate(Date seminarDate) {
		this.seminarDate = seminarDate;
	}
	public String getSeminarTimeSlot() {
		return seminarTimeSlot;
	}
	public void setSeminarTimeSlot(String seminarTimeSlot) {
		this.seminarTimeSlot = seminarTimeSlot;
	}
	public String getSeminarCapacity() {
		return seminarCapacity;
	}
	public void setSeminarCapacity(String seminarCapacity) {
		this.seminarCapacity = seminarCapacity;
	}
	public String getSeminarCurrentPeople() {
		return seminarCurrentPeople;
	}
	public void setSeminarCurrentPeople(String seminarCurrentPeople) {
		this.seminarCurrentPeople = seminarCurrentPeople;
	}
	
	

}
