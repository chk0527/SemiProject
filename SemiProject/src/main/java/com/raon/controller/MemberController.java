package com.raon.controller;

import com.raon.domain.Members;
import com.raon.service.BoardService;
import com.raon.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@Log4j
@RequestMapping("/login/*")
@AllArgsConstructor
public class MemberController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/list")
    public String list(Model model) {
        List<Members> memberList = memberService.getAllMembers();
        model.addAttribute("memberList", memberList);
        return "member/memberList";
    }

    @GetMapping("/read")
    public String read(@RequestParam("id") String id, Model model) {
        Members member = memberService.getMemberById(id);
        model.addAttribute("member", member);
        return "member/read";
    }

    @GetMapping("/updateFrm")
    public String updateForm(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        Members member = memberService.getMemberById(loginId);
        model.addAttribute("member", member);
        return "member/updateFrm";
    }

    @PostMapping("/update")
    public String update(Members member) {
        memberService.updateMember(member);
        return "redirect:/header/main";
    }

    @PostMapping("/delete")
    public String delete(HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        memberService.deleteMember(loginId);
        return "redirect:/member/list";
    }

    @GetMapping("/rePwd")
    public String rePwd(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        Members member = memberService.getMemberById(loginId);
        model.addAttribute("member", member);
        return "rePwd";
    }

    @PostMapping("/updatePwd")
    public String updatePwd(Members member) {
        memberService.updatePassword(member);
        return "redirect:/home/main";
    }

    @GetMapping("/login")
    public String login(HttpSession session, HttpServletRequest request) {
    	String previousPageUrl = request.getHeader("referer");
    	previousPageUrl = previousPageUrl.substring(21);
    	session.setAttribute("previousPageUrl", previousPageUrl);
    	log.info("previousPageUrl: " + session.getAttribute("previousPageUrl"));
        return "login/login";
    }
   
    
    @PostMapping("/login")
    public String login(HttpSession session, @RequestParam String id, @RequestParam String pwd) {
        if (memberService.isUser(id, pwd)) {
        	log.info("login....");
            session.setAttribute("loginId", id);
            return "redirect:"+session.getAttribute("previousPageUrl");
        } else {
            return "redirect:/login/login";
        }
    }

    @PostMapping("/signUp")
    public String signUp(Members member) {
    	log.info("signUp...");
        memberService.registerMember(member);
        return "redirect:/login/login";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        // 세션 무효화
        request.getSession().invalidate();
        
        // 이전 페이지 URL 가져오기
        String referer = request.getHeader("referer");
        
        // 이전 페이지 URL이 없으면 기본적으로 홈 페이지로 리디렉션
        String redirectUrl = (referer != null) ? referer : "/";
        
        // 기존 페이지로 리디렉션
        return "redirect:" + redirectUrl;
    }
  //Id 중복 확인
  	@PostMapping("/ConfirmId")
  	@ResponseBody
  	public ResponseEntity<Boolean> confirmId(String id) {
  		log.info("ConfirmId.........");
  		log.info("id : " + id);
  		boolean result = true;
  		
  		if(id.trim().isEmpty()) {
  			log.info("id : " + id);
  			result = false;
  		} else {
  			if (memberService.selectId(id)) {
  				result = false;
  			} else {
  				result = true;
  			}
  		}
  		
  		return new ResponseEntity<>(result, HttpStatus.OK);
  	}
  //Id와 email 확인
  	@PostMapping("/confirmPwd")
  	@ResponseBody
  	public ResponseEntity<Boolean> confirmPwd(@RequestParam String id, @RequestParam String email) {
  		log.info("Confirm Id,email.........");
  		log.info("id : " + id + "email: "+email);
  		boolean result = true;
  		
  		if(id.trim().isEmpty()||email.trim().isEmpty()) {
  			log.info("id : " + id+ ", email : " + email);
  			result = false;
  		} else {
  			if (memberService.rePwdInfo(id, email)) {
  				result = true;
  			} else {
  				result = false;
  			}
  		}
  		
  		return new ResponseEntity<>(result, HttpStatus.OK);
  	}
}
