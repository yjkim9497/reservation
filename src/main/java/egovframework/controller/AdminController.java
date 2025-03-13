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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.mapper.UserMapper;
import egovframework.service.ReserveService;
import egovframework.service.SeminarService;
import egovframework.service.UserService;
import egovframework.vo.LoginVO;
import egovframework.vo.SeminarVO;
import egovframework.vo.UserRole;
import egovframework.vo.UserVO;

@Controller
public class AdminController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private UserMapper userMapper;
	
	@Autowired
	private ReserveService reserveService;
	
	@Autowired
	private SeminarService seminarService;
	
//	@RequestMapping(value = "admin.do")
//	public String adminPage() {
//		return "admin";
//	}
//	
//	@RequestMapping(value = "adminSeminar.do")
//	public String adminSeminarPage() {
//		return "adminSeminar";
//	}
	
	@RequestMapping(value = "admin.do")
    public String adminPage(HttpServletRequest request,HttpSession session, Model model) {
        // 세션에서 로그인 정보 가져오기
		UserVO sessionUser = (UserVO) request.getSession().getAttribute("LoginVO");

        // 로그인한 사용자가 없거나 role이 admin이 아닌 경우
        if (sessionUser == null || !UserRole.ADMIN.equals(sessionUser.getUserRole())) {
            // 접근을 차단하거나 다른 페이지로 리다이렉트
            return "redirect:/accessDenied.do"; // 접근 권한 없을 때 이동할 페이지
        }
        
        List<UserVO> users = userService.getAllUsers();
        
        List<SeminarVO> seminars;
        
        try {
        	seminars = seminarService.getAllSeminars();
        } catch (Exception e) {
        	seminars = Collections.emptyList();
        }

        model.addAttribute("loginUser", sessionUser);
        model.addAttribute("users", users);
        model.addAttribute("seminars", seminars);

        // role이 admin인 경우에만 admin 페이지 반환
        return "admin";
    }
	
	@RequestMapping(value = "adminSeminar.do")
	public String adminSeminarPage(HttpServletRequest request,HttpSession session, Model model) {
		// 세션에서 로그인 정보 가져오기
		UserVO sessionUser = (UserVO) request.getSession().getAttribute("LoginVO");
		
		// 로그인한 사용자가 없거나 role이 admin이 아닌 경우
		if (sessionUser == null || !UserRole.ADMIN.equals(sessionUser.getUserRole())) {
			// 접근을 차단하거나 다른 페이지로 리다이렉트
			return "redirect:/accessDenied.do"; // 접근 권한 없을 때 이동할 페이지
		}
		List<SeminarVO> seminars;
		try {
			seminars = seminarService.getAllSeminars();
		} catch (Exception e) {
			seminars = Collections.emptyList();
		}
		model.addAttribute("seminars", seminars);
		
		// role이 admin인 경우에만 admin 페이지 반환
		return "adminSeminar";
	}
	
	@RequestMapping(value = "adminHoliday.do")
	public String adminHolidayPage(HttpServletRequest request,HttpSession session) {
		UserVO sessionUser = (UserVO) request.getSession().getAttribute("LoginVO");
		
		// 로그인한 사용자가 없거나 role이 admin이 아닌 경우
		if (sessionUser == null || !UserRole.ADMIN.equals(sessionUser.getUserRole())) {
			// 접근을 차단하거나 다른 페이지로 리다이렉트
			return "redirect:/accessDenied.do"; // 접근 권한 없을 때 이동할 페이지
		}
		return "adminHoliday";
	}
	
	@RequestMapping(value = "/unlockUser.do", method = RequestMethod.POST)
	public String unlockUser(@RequestParam("userPk") Long userPk, RedirectAttributes redirectAttributes) {
	    userMapper.unlockUserAccount(userPk);
	    redirectAttributes.addFlashAttribute("message", "사용자 계정이 잠금 해제되었습니다.");
	    return "redirect:/admin.do";
	}
	
	
	@RequestMapping(value = "accessDenied.do")
	public String accessDenied() {
		return "accessDenied";
	}
	
	@RequestMapping(value = "users.do")
    public final String getAllUsers(Model model) {
		List<UserVO> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin";
    }
	
	@RequestMapping(value = "deleteUser.do", method = RequestMethod.POST)
	public String deleteUser(@RequestParam("id") Long userPk) {
	    userService.deleteUser(userPk);
	    return "redirect:admin.do"; // 삭제 후 목록 페이지로 리다이렉트
	}

	@RequestMapping(value = "editUser.do")
	public String editUser(@RequestParam("id") Long userPk, Model model) {
	    UserVO user = userService.getUser(userPk);
	    model.addAttribute("user", user);
	    return "admin/editUser"; // editUser.jsp로 이동
	}
}
