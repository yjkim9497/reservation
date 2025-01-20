package egovframework.controller;


import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.service.UserService;
import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

@Controller
public class UserController {
	@Autowired
    private UserService userService;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
    
    @Resource(name = "egovEnvPasswordEncoderService")
    EgovPasswordEncoder egovPasswordEncoder;

    // 회원가입 페이지로 이동
    @RequestMapping(value = "signup.do")
    public String signupPage() {
        return "signup";
    }

    // 회원가입 처리
    @RequestMapping(value = "/actionSignup.do", method = RequestMethod.POST)
    public String registerUser(@ModelAttribute("userVO") UserVO userVO, HttpServletRequest request, Model model) throws Exception {
    	// 암호화 로직 추가
    	String hashedPassword = egovPasswordEncoder.encryptPassword(userVO.getPassword());
        userVO.setPassword(hashedPassword);
        
        String encryptedPhone = cryptoService.encrypt(userVO.getPhone());
        String encryptedEmail = cryptoService.encrypt(userVO.getEmail());

        // 암호화된 데이터로 UserVO 업데이트
        userVO.setPhone(encryptedPhone);
        userVO.setEmail(encryptedEmail);

        
        System.out.println("컨트롤단 생년월일"+userVO.getBirth());
        
        userService.registerUser(userVO);
        model.addAttribute("message", "회원가입이 완료되었습니다.");
        System.out.println("회원가입 완료");
        return "login";
    }
    
    @RequestMapping(value = "mypage.do")
    public String myPage() {
        return "mypage";
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
        LoginVO resultVO = (LoginVO) request.getSession().getAttribute("LoginVO");
        String userId = resultVO.getId();
        
        if (resultVO == null || resultVO.getId() == null) {
        	// 세션이 없으면 로그인 페이지로 리다이렉트
        	System.out.println("세션에 로그인한 유저가 존재하지 않음");
        	return "redirect:/login.do";
        }
        UserVO loginUser = userService.getUser(userId);
        
        
        try {
            // 복호화 처리
            String decryptedEmail = cryptoService.decrypt(loginUser.getEmail());
            String decryptedPhone = cryptoService.decrypt(loginUser.getPhone());

            // 복호화된 데이터로 업데이트
            loginUser.setEmail(decryptedEmail);
            loginUser.setPhone(decryptedPhone);
        } catch (Exception e) {
            // 복호화 실패 시 로그 출력 및 에러 처리
            System.out.println("복호화 중 오류 발생: " + e.getMessage());
            model.addAttribute("message", "사용자 정보를 가져오는 중 오류가 발생했습니다.");
            return "error";
        }

        // 사용자 정보를 모델에 추가
        model.addAttribute("loginUser", loginUser);
        return "mypage"; // 마이페이지 화면으로 이동
    }
    
    
    

    
}
