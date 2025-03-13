package egovframework.vo;

import java.util.Date;

public class CommentVO {
	private Long commentPk;
    private String commentDescription;
    private String commentPassword;
    private Date commentRegDate;
    private Long userPk;
    private Long boardPk;
	public Long getCommentPk() {
		return commentPk;
	}
	public void setCommentPk(Long commentPk) {
		this.commentPk = commentPk;
	}
	public String getCommentDescription() {
		return commentDescription;
	}
	public void setCommentDescription(String commentDescription) {
		this.commentDescription = commentDescription;
	}
	public String getCommentPassword() {
		return commentPassword;
	}
	public void setCommentPassword(String commentPassword) {
		this.commentPassword = commentPassword;
	}
	public Date getCommentRegDate() {
		return commentRegDate;
	}
	public void setCommentRegDate(Date commentRegDate) {
		this.commentRegDate = commentRegDate;
	}
	public Long getUserPk() {
		return userPk;
	}
	public void setUserPk(Long userPk) {
		this.userPk = userPk;
	}
	public Long getBoardPk() {
		return boardPk;
	}
	public void setBoardPk(Long boardPk) {
		this.boardPk = boardPk;
	}
    
}
