package egovframework.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonFormat;

public class SeminarVO {
	
	private String seminarPk;
	private String seminarName;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date seminarStart;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date seminarEnd;
	
	private int seminarCapacity;
	private String seminarFileName;
	private String seminarFilePath;
	private String seminarPlace;
	private String seminarUrl;
	private SeminarStatus seminarStatus;
	private int seminarCurrentPeople;
	
	private MultipartFile uploadFile;
	
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
	
	public int getSeminarCapacity() {
		return seminarCapacity;
	}
	public void setSeminarCapacity(int seminarCapacity) {
		this.seminarCapacity = seminarCapacity;
	}
	public int getSeminarCurrentPeople() {
		return seminarCurrentPeople;
	}
	public void setSeminarCurrentPeople(int seminarCurrentPeople) {
		this.seminarCurrentPeople = seminarCurrentPeople;
	}
	public String getSeminarFileName() {
		return seminarFileName;
	}
	public void setSeminarFileName(String seminarFileName) {
		this.seminarFileName = seminarFileName;
	}
	public String getSeminarFilePath() {
		return seminarFilePath;
	}
	public void setSeminarFilePath(String seminarFilePath) {
		this.seminarFilePath = seminarFilePath;
	}
	public Date getSeminarStart() {
		return seminarStart;
	}
	public void setSeminarStart(Date seminarStart) {
		this.seminarStart = seminarStart;
	}
	public Date getSeminarEnd() {
		return seminarEnd;
	}
	public void setSeminarEnd(Date seminarEnd) {
		this.seminarEnd = seminarEnd;
	}
	public String getSeminarPlace() {
		return seminarPlace;
	}
	public void setSeminarPlace(String seminarPlace) {
		this.seminarPlace = seminarPlace;
	}
	public MultipartFile getUploadFile() {
		return uploadFile;
	}
	public void setUploadFile(MultipartFile uploadFile) {
		this.uploadFile = uploadFile;
	}
	public String getSeminarUrl() {
		return seminarUrl;
	}
	public void setSeminarUrl(String seminarUrl) {
		this.seminarUrl = seminarUrl;
	}
	
}
