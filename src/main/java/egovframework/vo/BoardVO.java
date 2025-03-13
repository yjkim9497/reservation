package egovframework.vo;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

public class BoardVO {
	 	private Long boardPk;         // 게시글 PK
	    private String boardTitle;    // 게시글 제목
	    private String boardDescription; // 게시글 설명
	    private String boardPassword;
	    private String boardFileName;
	    private String boardFilePath;
	    private LocalDateTime boardRegDate; // 등록일
	    private Long userPk;          // 작성자 (NULL 가능)
	    private Long seminarPk;
	    private MultipartFile uploadFile;

	    // 기본 생성자
	    public BoardVO() {}

	    // 모든 필드를 포함하는 생성자
	    public BoardVO(Long boardPk, String boardTitle, String boardDescription, String boardFileName, String boardPassword,String boardFilePath, LocalDateTime boardRegDate, Long userPk, Long seminarPk) {
	        this.boardPk = boardPk;
	        this.boardTitle = boardTitle;
	        this.boardDescription = boardDescription;
	        this.boardFileName = boardFileName;
	        this.boardFilePath = boardFilePath;
	        this.boardRegDate = boardRegDate;
	        this.boardPassword = boardPassword;
	        this.userPk = userPk;
	        this.seminarPk = seminarPk;
	    }

		public Long getBoardPk() {
			return boardPk;
		}

		public void setBoardPk(Long boardPk) {
			this.boardPk = boardPk;
		}

		public String getBoardTitle() {
			return boardTitle;
		}

		public void setBoardTitle(String boardTitle) {
			this.boardTitle = boardTitle;
		}

		public String getBoardDescription() {
			return boardDescription;
		}

		public void setBoardDescription(String boardDescription) {
			this.boardDescription = boardDescription;
		}

		public LocalDateTime getBoardRegDate() {
			return boardRegDate;
		}

		public void setBoardRegDate(LocalDateTime boardRegDate) {
			this.boardRegDate = boardRegDate;
		}

		public Long getUserPk() {
			return userPk;
		}

		public void setUserPk(Long userPk) {
			this.userPk = userPk;
		}

		public String getBoardPassword() {
			return boardPassword;
		}

		public void setBoardPassword(String boardPassword) {
			this.boardPassword = boardPassword;
		}

		public String getBoardFileName() {
			return boardFileName;
		}

		public void setBoardFileName(String boardFileName) {
			this.boardFileName = boardFileName;
		}

		public String getBoardFilePath() {
			return boardFilePath;
		}

		public void setBoardFilePath(String boardFilePath) {
			this.boardFilePath = boardFilePath;
		}

		public MultipartFile getUploadFile() {
			return uploadFile;
		}

		public void setUploadFile(MultipartFile uploadFile) {
			this.uploadFile = uploadFile;
		}

		public Long getSeminarPk() {
			return seminarPk;
		}

		public void setSeminarPk(Long seminarPk) {
			this.seminarPk = seminarPk;
		}

}
