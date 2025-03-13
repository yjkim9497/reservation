package egovframework.controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import egovframework.mapper.HolidayMapper;
import egovframework.service.SeminarService;
import egovframework.service.UserService;
import egovframework.vo.BoardVO;
import egovframework.vo.LoginVO;
import egovframework.vo.ReserveVO;
import egovframework.vo.SeminarVO;

@Controller
@RequestMapping("/seminar")
public class SeminarController {

	@Autowired
	private SeminarService seminarService;
	
	@Autowired
	private HolidayMapper holidayMapper;

	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "/list.do", method = RequestMethod.GET)
	public String getSeminars() {
		return "seminarList";
	}

	@RequestMapping(value = "/{date}.do", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> getSeminars(@PathVariable String date) {
		try {
			LocalDate seminarDate = LocalDate.parse(date);
			List<SeminarVO> seminars = seminarService.getSeminarsByDate(seminarDate);

			// 예약 정보를 개별 Map으로 변환하여 리스트에 저장
			List<Map<String, Object>> seminarList = new ArrayList<>();

			for (SeminarVO seminar : seminars) {
				Map<String, Object> seminarMap = new HashMap<>();
				seminarMap.put("seminarPk", seminar.getSeminarPk());
				seminarMap.put("seminarName", seminar.getSeminarName());
				seminarMap.put("seminarStart", seminar.getSeminarStart());
				seminarMap.put("seminarEnd", seminar.getSeminarEnd());
				seminarMap.put("seminarStatus", seminar.getSeminarStatus());
				seminarMap.put("seminarFileName", seminar.getSeminarFileName());
				seminarMap.put("seminarFilePath", seminar.getSeminarFilePath());
				seminarMap.put("seminarStatus", seminar.getSeminarStatus());
				seminarMap.put("seminarCapacity", seminar.getSeminarCapacity());
				seminarMap.put("seminarPlace", seminar.getSeminarPlace());
				seminarMap.put("seminarCurrentPeople", seminar.getSeminarCurrentPeople());
				seminarList.add(seminarMap);
			}

			// 최종 응답 Map 생성
			Map<String, Object> response = new HashMap<>();
			response.put("date", date);
			response.put("totalReservations", seminars.size());
			response.put("reservations", seminarList); // 리스트 형태로 전달

			return ResponseEntity.ok(response);
		} catch (DateTimeParseException e) {
			return ResponseEntity.badRequest().body("Invalid date format. Please use 'YYYY-MM-DD'.");
		}
	}

	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addSeminar(
			@RequestParam(value = "file", required = false) MultipartFile file,
			@RequestParam("seminarStart") Date seminarStart,
			@RequestParam("seminarEnd") Date seminarEnd,
			@RequestParam("seminarName") String seminarName,
			@RequestParam("seminarPlace") String seminarPlace,
			@RequestParam("seminarCapacity") int seminarCapacity,
			@RequestParam("seminarUrl") String seminarUrl,
			HttpServletRequest request){
		Map<String, Object> response = new HashMap<>();
		Map<String, Date> params = new HashMap<>();
	    params.put("seminarStart", seminarStart);
	    params.put("seminarEnd", seminarEnd);
	    int overlapCount = holidayMapper.checkSeminarOverlap(params);
	    if (overlapCount > 0) {
	        // 날짜 겹칠 경우
	        response.put("status", "fail");
	        response.put("message", "세미나 날짜가 휴무일과 겹칩니다. 다른 날짜로 변경해주세요.");
	        return response;
	    }
	    
	    if(file == null || file.isEmpty()) {
	    	response.put("status", "fail");
	    	response.put("message", "세미나 이미지를 등록해주세요.");
	    	return response;
	    }
		try {
			if (seminarName.getBytes("UTF-8").length > 255) {
	            response.put("status", "fail");
	            response.put("message", "세미나 이름은 100자 이내로 작성해주세요.");
	            return response;
	        }
	        String fileName = null;

	        // SeminarVO 객체 생성
	        SeminarVO seminarVO = new SeminarVO();
	        seminarVO.setSeminarStart(seminarStart);
	        seminarVO.setSeminarEnd(seminarEnd);
	        seminarVO.setSeminarName(seminarName);
	        seminarVO.setSeminarCapacity(seminarCapacity);
	        seminarVO.setSeminarPlace(seminarPlace);
	        seminarVO.setSeminarUrl(seminarUrl);
	        if (!file.isEmpty()) {
	            String originalFileName = file.getOriginalFilename(); // 파일명
	            String ext = FilenameUtils.getExtension(originalFileName); // 확장자
	            UUID uuid = UUID.randomUUID(); // 랜덤 UUID 생성
	            fileName = uuid + "_" + originalFileName; // 새로운 파일명
	            
	            // **프로젝트 내 정적 리소스 경로 설정**
	            ServletContext context= request.getSession().getServletContext();
	            String uploadDir = request.getSession().getServletContext().getRealPath("/images/");
	            File uploadPath = new File(uploadDir+fileName);
	            if (!uploadPath.getParentFile().exists()) uploadPath.getParentFile().mkdirs(); 
	            if (!uploadPath.exists()) uploadPath.mkdirs(); // 디렉토리 없으면 생성

	            // **파일 저장**
	            file.transferTo(new File(uploadDir+fileName));

	            // **DB 저장 경로 (브라우저에서 접근 가능한 경로로 저장)**
	            seminarVO.setSeminarFileName(fileName);
	            seminarVO.setSeminarFilePath("/test1/images/"+fileName);
	        }
	        seminarService.insertSeminar(seminarVO);
	        response.put("success", true);
	        response.put("message", "세미나가 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "서버 오류 발생: " + e.getMessage());
	    }

	    return response;
	}
	
	@RequestMapping(value = "/delete.do", method = RequestMethod.DELETE)
	@ResponseBody
	public String deleteSeminar(@RequestBody Long seminarPk) {
		try {
			seminarService.deleteSeminar(seminarPk);
			return "세미나를 삭제하였습니다.";
		} catch (Exception e) {
			e.printStackTrace();
			return "오류가 발생했습니다.";
		}
	}
	
	@RequestMapping(value = "/all.do", method = RequestMethod.GET)
    @ResponseBody
    public List<SeminarVO> getSeminarList (Model model) {
        // 세미나 목록 조회
        List<SeminarVO> seminars = seminarService.getAllSeminars();
        return seminars; // JSON 형식으로 반환됨
    }
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String getSeminars(Model model) {
		List<SeminarVO> seminars = seminarService.getAllSeminars();
        model.addAttribute("seminars", seminars);
        return "세미나 조회 완료";
    }
	
	@RequestMapping("/detail.do")
	public String seminarDetail(@RequestParam("seminarPk")Long seminarPk, Model model) throws Exception {
		SeminarVO seminar = seminarService.findSeminar(seminarPk);
		model.addAttribute("seminar",seminar);
		return "seminarDetail";
	}
	
	@RequestMapping(value = "/complete.do", method = RequestMethod.POST)
	@ResponseBody
	public String completeSeminar(@RequestBody Long seminarPk) {
		try {
			seminarService.completeSeminar(seminarPk);
			return "세미나를 완료시켰습니다";
		} catch (Exception e) {
			e.printStackTrace();
			return "세미나를 종료시키는데 오류가 발생하였습니다.";
		}
	}
	
}
