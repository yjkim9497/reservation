package egovframework.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.mapper.CommentMapper;
import egovframework.service.CommentService;
import egovframework.vo.CommentVO;

@Service("commentService")
public class CommentServiceImpl implements CommentService {
	@Resource(name = "commentMapper")
	private CommentMapper commentMapper;
	
	@Override
    public void addComment(CommentVO comment) {
		commentMapper.insertComment(comment);
    }

    @Override
    public void modifyComment(CommentVO comment) {
    	commentMapper.updateComment(comment);
    }

    @Override
    public void removeComment(Long commentPk) {
    	commentMapper.deleteComment(commentPk);
    }

    @Override
    public List<CommentVO> getCommentsByBoardPk(Long boardPk) {
        return commentMapper.selectCommentsByBoardPk(boardPk);
    }
}
