package egovframework.service.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import egovframework.mapper.UserMapper;
import egovframework.service.LoginService;
import egovframework.vo.LoginVO;
import egovframework.vo.UserVO;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
	@Autowired
    private UserMapper userMapper;

	@Resource(name = "egovEnvPasswordEncoderService")
    EgovPasswordEncoder egovPasswordEncoder;
	
	@Resource(name = "egovEnvCryptoService")
    EgovEnvCryptoService cryptoService;
	
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
	@Override
	public LoginVO actionLogin(LoginVO vo) throws Exception {

		// 1. 입력한 비밀번호를 암호화한다.
//		String enpassword = EgovFileScrty.encryptPassword(vo.getPassword(), vo.getId());
//		vo.setPassword(enpassword);
		
		if (vo.getUserId() == null || vo.getUserId().trim().isEmpty()) {
	        throw new IllegalArgumentException("아이디를 입력하세요.");
	    }
	    if (vo.getUserPassword() == null || vo.getUserPassword().trim().isEmpty()) {
	        throw new IllegalArgumentException("비밀번호를 입력하세요.");
	    }
	    
	    String hashedPassword = egovPasswordEncoder.encryptPassword(vo.getUserPassword());
        vo.setUserPassword(hashedPassword);

		// 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
		LoginVO loginVO = loginDAO.actionLogin(vo);
		
		if (loginVO == null) {
		    return null;
		}

		// 3. 결과를 리턴한다.
		if (loginVO != null && !loginVO.getUserId().equals("") && !loginVO.getUserPassword().equals("")) {
			return loginVO;
		} else {
			loginVO = new LoginVO();
		}

		return loginVO;
	}
	
	public String getAccessToken(String authorize_code) {
	    String accessToken = "";
	    String refreshToken = "";
	    String reqURL = "https://kauth.kakao.com/oauth/token";

	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

	        // POST 요청을 위해 기본값이 false인 setDoOutput을 true로 변경
	        conn.setRequestMethod("POST");
	        conn.setDoOutput(true);

	        // POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
	        // BufferedWriter 간단하게 파일을 끊어서 보내기 위한 코드
	        try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()))) {
	            StringBuilder sb = new StringBuilder();
	            sb.append("grant_type=authorization_code")
	            .append("&client_id=86deb5ba96687995c0fd88d76e9f9008")  // 발급받은 key
	            .append("&redirect_uri=http://localhost:8081/test1/kakaoLogin.do")  // 본인이 설정해 놓은 redirect_uri 주소
	            .append("&code=").append(authorize_code);  // authorize_code
	            bw.write(sb.toString());
	            bw.flush();
	        }

	        // 결과 코드가 200이라면 성공
	        // 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
	        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
	        	String line = "";
	            String result = "";  // StringBuilder를 사용하여 문자열 결합

	            while ((line = br.readLine()) != null) {
	                result+=line;  // StringBuilder의 append 메서드 사용
	            }

	            // Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
	            JsonParser parser = new JsonParser();
	            JsonElement element = parser.parse(result);

	            accessToken = element.getAsJsonObject().get("access_token").getAsString();
	            refreshToken = element.getAsJsonObject().get("refresh_token").getAsString();
	        }

	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return accessToken;
	}
	
	public UserVO getuserinfo(String accessToken, HttpSession session, RedirectAttributes rttr) {
	    HashMap<String, Object> userInfo = new HashMap<>();

	    String requestURL = "https://kapi.kakao.com/v2/user/me";
	    String view = null;
	    String msg = null;

	    try {
	        URL url = new URL(requestURL); //1.url 객체만들기
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        //2.url 에서 url connection 만들기
	        conn.setRequestMethod("GET"); // 3.URL 연결구성
	        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

	        //키 값, 속성 적용
	        int responseCode = conn.getResponseCode(); //서버에서 보낸 http 상태코드 반환
	        BufferedReader buffer = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        // 버퍼를 사용하여 읽은 것
	        String line;
	        String result = "";  // StringBuilder를 사용하여 문자열 결합

	        while ((line = buffer.readLine()) != null) {
	            result+=line;  // StringBuilder의 append 메서드 사용
	        }
	        //readLine()) ==> 입력 String 값으로 리턴값 고정

	        // 읽었으니깐 데이터꺼내오기
	        JsonParser parser = new JsonParser();
	        JsonElement element = parser.parse(result); //Json element 문자열변경
	        String userId = element.getAsJsonObject().get("id").getAsString();
	        JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
	        JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();

	        String userName = properties.getAsJsonObject().get("nickname").getAsString();
//	        String id = kakao_account.getAsJsonObject().get("email").getAsString();
	        
			//userInfo에 사용자 정보 저장
	        userInfo.put("userId", userId);
	        userInfo.put("userName", userName);
//	        userInfo.put("userEmail", userEmail);

//	        log.info(String.valueOf(userInfo));

	        UserVO user = userMapper.findkakao(userId);
//	        System.out.println("유저조회 성공" + user.getUserEmail());
	        
	        UserVO resultVO = new UserVO();
	        if (user == null) {
	        	//member null 이면 정보가 저장 안되어있는거라서 정보를 저장.
	        	userMapper.kakaoinsert(userId,userName);
	        	//저장한 member 정보 다시 가져오기 HashMap이라 형변환 시켜줌
	        	resultVO.setUserPk(user.getUserPk());
	        	resultVO.setUserId(user.getUserId());
	        	resultVO.setUserRole(user.getUserRole());
	        	resultVO.setUserName(userName);
	        	
	        	return resultVO;
//	        	user = userMapper.selectUser((String)userInfo.get("userId"));
//	        	session.setAttribute("loginUser", user);
//	        	
//	        	//로그인 처리 후 메인 페이지로 이동
//	        	view = "redirect:/main.do";
//	        	msg = "로그인 성공";
	        } else {
	        	resultVO = userMapper.selectUser(user.getUserPk());
	        	resultVO.setUserPk(user.getUserPk());
	        	resultVO.setUserId(user.getUserId());
	        	resultVO.setUserRole(user.getUserRole());
	        	if(resultVO.getUserEmail()!= null) {
	        		resultVO.setUserEmail(cryptoService.decrypt(resultVO.getUserEmail()));
				}
				if(resultVO.getUserPhone()!= null) {
					resultVO.setUserPhone(cryptoService.decrypt(resultVO.getUserPhone()));
				}
	        	resultVO.setUserName(userName);
	        	if(resultVO.getUserBirth()!=null) {
	        		resultVO.setUserBirth(user.getUserBirth());
	        	}
	        	return resultVO;
//	        	session.setAttribute("LoginVO", user);
//	        	LoginVO sessionUser = (LoginVO) request.getSession().getAttribute("LoginVO");
//				if (sessionUser != null) {
//				    System.out.println("세션에 저장된 사용자 pk: " + sessionUser.getUserPk());
//				} else {
//				    System.out.println("세션에 데이터가 없습니다.");
//				}
//	        	System.out.println("로그인 성공 :"+ user.getUserName());
//	        	view = "redirect:/main.do";
//	        	msg = "로그인 성공";
	        	
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
//	    System.out.println("db조회 시작");
//
//	    System.out.println("저장되어있는지 확인" + user.getUserName());
	    // 저장되어있는지 확인
//	    log.info("S :" + member);
		return null;

//	    rttr.addFlashAttribute("msg", msg);
//	    return view;
	}
	
	
	
//	@Resource(name="userMapper")
//	private UserMapper userDAO;
//	
//	@Override
//    public boolean loginUser(LoginVO loginVO) {
//		System.out.println("아이디"+loginVO.getId());
//		System.out.println("비밀번호"+loginVO.getPassword());
//    	boolean result = userDAO.loginUser(loginVO) > 0;
//    	System.out.println("로그인성공여부"+result);
//        return result;
//    }
}
