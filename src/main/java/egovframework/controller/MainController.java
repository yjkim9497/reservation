package egovframework.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.mapper.SeminarMapper;
import egovframework.vo.SeminarVO;

@Controller
public class MainController {
	
	@Resource(name="seminarMapper")
	SeminarMapper seminarMapper;
	
	@RequestMapping(value = "/main.do")
	public String mainPage(Model model) {
		List<SeminarVO> seminars = seminarMapper.selectLatestSeminars();
		List<SeminarVO> seminarList = seminarMapper.selectAllSeminars();
		model.addAttribute("seminars",seminars);
		model.addAttribute("seminarList",seminarList);
		return "main";
	}

}
