package egovframework.mapper;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.CommentVO;

@Mapper
public interface CommentMapper {
	void insertComment(CommentVO comment);
    void updateComment(CommentVO comment);
    void deleteComment(Long commentPk);
    int countCommentsByBoardPk(Long boardPk);
    List<CommentVO> selectCommentsByBoardPk(Long boardPk);
}
