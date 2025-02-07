package egovframework.controller;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.service.ReserveService;
import egovframework.service.UserService;
import egovframework.vo.LoginVO;
import egovframework.vo.ReserveVO;
import egovframework.vo.UserVO;

@Controller
public class AdminController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ReserveService reserveService;
	
	@RequestMapping(value = "admin.do")
    public String adminPage(HttpServletRequest request,HttpSession session, Model model) {
        // 세션에서 로그인 정보 가져오기
		LoginVO sessionUser = (LoginVO) request.getSession().getAttribute("LoginVO");

        // 로그인한 사용자가 없거나 role이 admin이 아닌 경우
        if (sessionUser == null || !"admin".equals(sessionUser.getRole())) {
            // 접근을 차단하거나 다른 페이지로 리다이렉트
            return "redirect:/accessDenied.do"; // 접근 권한 없을 때 이동할 페이지
        }
//        String userId = sessionUser.getId();
//        UserVO loginUser = userService.getUser(userId);
        
        List<UserVO> users = userService.getAllUsers();
        
     // 예약 목록 가져오기
        List<ReserveVO> reservations;
        try {
            reservations = reserveService.getAllReservations();
        } catch (Exception e) {
            System.err.println("예약 목록 조회 중 오류 발생: " + e.getMessage());
            reservations = Collections.emptyList();
        }

        model.addAttribute("loginUser", sessionUser);
        model.addAttribute("users", users);
        model.addAttribute("reservations", reservations);
		System.out.println("관리자 컨트롤"+users.toString());
//        model.addAttribute("users", users);

        // role이 admin인 경우에만 admin 페이지 반환
        return "admin";
    }
	
	@RequestMapping(value = "accessDenied.do")
	public String accessDenied() {
		return "accessDenied";
	}
	
	@RequestMapping(value = "users.do")
    public String getAllUsers(Model model) {
		List<UserVO> users = userService.getAllUsers();
		System.out.println("관리자 컨트롤"+users.toString());
        model.addAttribute("users", users);
        return "admin";
    }
	
	@RequestMapping(value = "deleteUser.do", method = RequestMethod.POST)
	public String deleteUser(@RequestParam("id") String id) {
	    userService.deleteUser(id);
	    return "redirect:users.do"; // 삭제 후 목록 페이지로 리다이렉트
	}

	@RequestMapping(value = "editUser.do")
	public String editUser(@RequestParam("id") String id, Model model) {
	    UserVO user = userService.getUser(id);
	    model.addAttribute("user", user);
	    return "admin/editUser"; // editUser.jsp로 이동
	}
}
