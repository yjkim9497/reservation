package egovframework.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.ReserveService;
import egovframework.service.UserService;
import egovframework.vo.LoginVO;
import egovframework.vo.ReserveVO;
import egovframework.vo.UserVO;

@Controller
public class UserController {
	@Autowired
    private UserService userService;
	
	@Autowired
	private ReserveService reserveService;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
    
    @Resource(name = "egovEnvPasswordEncoderService")
    EgovPasswordEncoder egovPasswordEncoder;

    // 회원가입 페이지로 이동
    @RequestMapping(value = "signup.do")
    public String signupPage() {
        return "signup";
    }
    
 // 사용자 수정 페이지로 이동
    @RequestMapping(value = "/editProfile.do", method = RequestMethod.GET)
    public String editUserPage(@RequestParam("userPk") Long userPk, Model model) {
        UserVO userVO = userService.getUser(userPk);
        
        if (userVO.getUserPhone() != null && !userVO.getUserPhone().isEmpty()) {
            userVO.setUserPhone(cryptoService.decrypt(userVO.getUserPhone()));
        }
        
        if (userVO.getUserEmail() != null && !userVO.getUserEmail().isEmpty()) {
            userVO.setUserEmail(cryptoService.decrypt(userVO.getUserEmail()));
        }
        
        // 사용자 정보 가져오기
        model.addAttribute("user", userVO);
        return "editUser";  // 사용자 정보 수정 페이지
    }



    // 회원가입 처리
    @RequestMapping(value = "actionSignup.do", method = RequestMethod.POST)
    @ResponseBody  // 응답을 JSON으로 반환
    public Map<String, Object> registerUser(@ModelAttribute("userVO") UserVO userVO, HttpServletRequest request) throws Exception {
        String hashedPassword = egovPasswordEncoder.encryptPassword(userVO.getUserPassword());
        userVO.setUserPassword(hashedPassword);
        
        String encryptedPhone = cryptoService.encrypt(userVO.getUserPhone());
        String encryptedEmail = cryptoService.encrypt(userVO.getUserEmail());
        
        userVO.setUserPhone(encryptedPhone);
        userVO.setUserEmail(encryptedEmail);
        
        userService.registerUser(userVO);
        
        // 응답으로 JSON 반환
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "회원가입이 완료되었습니다.");
        return response;
    }
    
    @RequestMapping(value = "editUser.do", method = RequestMethod.POST)
    @ResponseBody  // 응답을 JSON으로 반환
    public Map<String, Object> editUser(@ModelAttribute("userVO") UserVO userVO, HttpServletRequest request) throws Exception {
        String hashedPassword = egovPasswordEncoder.encryptPassword(userVO.getUserPassword());
        userVO.setUserPassword(hashedPassword);
        
        String encryptedPhone = cryptoService.encrypt(userVO.getUserPhone());
        String encryptedEmail = cryptoService.encrypt(userVO.getUserEmail());
        
        userVO.setUserPhone(encryptedPhone);
        userVO.setUserEmail(encryptedEmail);
        
        userService.updateUser(userVO);
        
        // 응답으로 JSON 반환
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "회원 정보 수정이 완료되었습니다.");
        return response;
    }
    
    @RequestMapping(value = "deleteUser.do", method = RequestMethod.DELETE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteUser(@RequestBody Map<String, Long> request) {
        Map<String, Object> response = new HashMap<>();
        Long userPk = request.get("userPk");  // JSON 데이터에서 userPk 추출

        try {
            userService.deleteUser(userPk); // 삭제 로직 실행
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
        }

        return ResponseEntity.ok(response);
    }
    
    @RequestMapping(value = "mypage.do")
    public String myPage() {
        return "mypage";
    }
    
    @RequestMapping(value = "myReservation.do")
    public String myReservation() {
        return "myReservation";
    }
    
	@RequestMapping(value = "/myReservation.do", method = RequestMethod.GET)
    public String myReservation(HttpServletRequest request, Model model) {
        // 세션에서 사용자 정보 가져오기
		UserVO resultVO = (UserVO) request.getSession().getAttribute("LoginVO");
        String userId = resultVO.getUserId();
        if (resultVO == null || resultVO.getUserId() == null) {
        	// 세션이 없으면 로그인 페이지로 리다이렉트
        	return "redirect:/login.do";
        }
        List<ReserveVO> reservations = reserveService.getUserReservationList(resultVO.getUserPk());
        model.addAttribute("reservations", reservations);
        return "myReservation"; // 마이페이지 화면으로 이동
    }
    
    @RequestMapping(value = "/checkDuplicateId.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Boolean> checkDuplicateId(@RequestParam String id) {
        boolean isDuplicate = userService.isDuplicateId(id);
        Map<String, Boolean> response = new HashMap<>();
        response.put("isDuplicate", isDuplicate);
        return response;
    }
    
    @RequestMapping(value = "/mypage.do", method = RequestMethod.GET)
    public String myPage(HttpServletRequest request, Model model) {
        // 세션에서 사용자 정보 가져오기
        UserVO resultVO = (UserVO) request.getSession().getAttribute("LoginVO");
        Long userPK = resultVO.getUserPk();
        if (resultVO == null || resultVO.getUserId() == null) {
        	// 세션이 없으면 로그인 페이지로 리다이렉트
        	return "redirect:/login.do";
        }
        UserVO loginUser = userService.getUser(userPK);
        
        
        try {
            // 이메일이 존재하면 복호화
            if (loginUser.getUserEmail() != null && !loginUser.getUserEmail().isEmpty()) {
                String decryptedEmail = cryptoService.decrypt(loginUser.getUserEmail());
                loginUser.setUserEmail(decryptedEmail);
            }

            // 연락처가 존재하면 복호화
            if (loginUser.getUserPhone() != null && !loginUser.getUserPhone().isEmpty()) {
                String decryptedPhone = cryptoService.decrypt(loginUser.getUserPhone());
                loginUser.setUserPhone(decryptedPhone);
            }
        } catch (Exception e) {
            // 복호화 실패 시 로그 출력 및 에러 처리
            model.addAttribute("message", "사용자 정보를 가져오는 중 오류가 발생했습니다.");
            return "error";
        }


        // 사용자 정보를 모델에 추가
        model.addAttribute("loginUser", loginUser);
        return "mypage"; // 마이페이지 화면으로 이동
    }
    
    
    

    
}
