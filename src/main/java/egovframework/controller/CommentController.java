package egovframework.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.CommentService;
import egovframework.vo.CommentVO;

@Controller
@RequestMapping("/comment")
public class CommentController {
	
	@Resource(name = "commentService")
	private CommentService commentService;
	
	// 댓글 등록
	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
    public String addComment(@RequestBody CommentVO comment) {
        commentService.addComment(comment);
        return "댓글이 등록되었습니다.";
    }

    // 댓글 수정
	@RequestMapping(value = "/update", method = RequestMethod.PUT)
	@ResponseBody
    public String updateComment(@RequestBody CommentVO comment) {
        commentService.modifyComment(comment);
        return "댓글이 수정되었습니다.";
    }

    // 댓글 삭제
	@RequestMapping(value = "/delete.do", method = RequestMethod.DELETE)
	@ResponseBody
    public String deleteComment(@RequestBody Long commentPk) {
		try {
			commentService.removeComment(commentPk);
			return "댓글이 삭제되었습니다.";
		} catch (Exception e) {
			e.printStackTrace();
			return "오류가 발생했습니다.";
		}
    }

    // 특정 게시글의 댓글 목록 조회
	@RequestMapping(value = "/list/{boardPk}.do", method = RequestMethod.GET)
	@ResponseBody
    public List <CommentVO> getComments(@PathVariable Long boardPk) {
        List <CommentVO> comments =  commentService.getCommentsByBoardPk(boardPk);
//        model.addAttribute("comments", comments);
        return comments;
    }

}
