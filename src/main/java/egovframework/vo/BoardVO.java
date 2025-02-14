package egovframework.vo;

import java.time.LocalDateTime;

public class BoardVO {
	 	private String boardPk;         // 게시글 PK
	    private String boardTitle;    // 게시글 제목
	    private String boardDescription; // 게시글 설명
	    private LocalDateTime boardRegDate; // 등록일
	    private Long userPk;          // 작성자 (NULL 가능)

	    // 기본 생성자
	    public BoardVO() {}

	    // 모든 필드를 포함하는 생성자
	    public BoardVO(String boardPk, String boardTitle, String boardDescription, LocalDateTime boardRegDate, Long userPk) {
	        this.boardPk = boardPk;
	        this.boardTitle = boardTitle;
	        this.boardDescription = boardDescription;
	        this.boardRegDate = boardRegDate;
	        this.userPk = userPk;
	    }

		public String getBoardPk() {
			return boardPk;
		}

		public void setBoardPk(String boardPk) {
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

	    

}
