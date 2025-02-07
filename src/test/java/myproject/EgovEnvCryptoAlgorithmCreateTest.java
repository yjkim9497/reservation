package myproject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.EgovPasswordEncoder;
import org.egovframe.rte.fdl.cryptography.impl.EgovEnvCryptoServiceImpl;
import org.junit.Test;
 
public class EgovEnvCryptoAlgorithmCreateTest {
 
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovEnvCryptoAlgorithmCreateTest.class);
 
	//계정암호화키 키
	public String algorithmKey = "testkey";
 
	//계정암호화 알고리즘(MD5, SHA-1, SHA-256)
	public String algorithm = "SHA-256";
 
	//계정암호화키 블럭사이즈
	public int algorithmBlockSize = 1024;
 
	@Test
	public void createHash() {
		EgovEnvCryptoAlgorithmCreateTest cryptoTest = new EgovEnvCryptoAlgorithmCreateTest();
 
		EgovPasswordEncoder egovPasswordEncoder = new EgovPasswordEncoder();
		egovPasswordEncoder.setAlgorithm(cryptoTest.algorithm);
 
		LOGGER.info("------------------------------------------------------");
		LOGGER.info("알고리즘(algorithm) : "+cryptoTest.algorithm);
		LOGGER.info("알고리즘 키(algorithmKey) : "+cryptoTest.algorithmKey);
		LOGGER.info("알고리즘 키 Hash(algorithmKeyHash) : "+egovPasswordEncoder.encryptPassword(cryptoTest.algorithmKey));
		LOGGER.info("알고리즘 블럭사이즈(algorithmBlockSize)  :"+cryptoTest.algorithmBlockSize);
 
	}
	
	@Test
	public void createEncryptedProperties() {
		String[] arrCryptoString = { 
			"root", //데이터베이스 접속 계정 설정
			"rladuswl54", //데이터베이스 접속 패드워드 설정
			"jdbc:mariadb://127.0.0.1:3306/test1", //데이터베이스 접속 주소 설정
			"org.mariadb.jdbc.Driver" //데이터베이스 드라이버
		};
	 
		LOGGER.info("------------------------------------------------------");		
		ApplicationContext context = new ClassPathXmlApplicationContext(new String[]{"classpath:/egovframework/spring/context-crypto.xml"});
		EgovEnvCryptoService cryptoService = context.getBean(EgovEnvCryptoServiceImpl.class);
		LOGGER.info("------------------------------------------------------");
	 
		String label = "";
		try {
			for(int i=0; i < arrCryptoString.length; i++) {		
				if(i==0)label = "사용자 아이디";
				if(i==1)label = "사용자 비밀번호";
				if(i==2)label = "접속 주소";
				if(i==3)label = "데이터 베이스 드라이버";
				LOGGER.info(label+" 원본(orignal):" + arrCryptoString[i]);
				LOGGER.info(label+" 인코딩(encrypted):" + cryptoService.encrypt(arrCryptoString[i]));
				LOGGER.info("------------------------------------------------------");
			}
		} catch (IllegalArgumentException e) {
			LOGGER.error("["+e.getClass()+"] IllegalArgumentException : " + e.getMessage());
		} catch (Exception e) {
			LOGGER.error("["+e.getClass()+"] Exception : " + e.getMessage());
		}
	}
}