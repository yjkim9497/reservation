package egovframework.service;

import java.util.List;

import egovframework.vo.CommentVO;

public interface CommentService {
	void addComment(CommentVO comment);
    void modifyComment(CommentVO comment);
    void removeComment(Long commentPk);
    List<CommentVO> getCommentsByBoardPk(Long boardPk);
}
