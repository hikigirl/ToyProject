package com.test.toy.user;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailSender {
	public static void main(String[] args) {
		//테스트용
//		MailSender sender = new MailSender();
//		
//		Map<String, String> map = new HashMap<String, String>();
//		
//		map.put("email", "sunshine_ouo@naver.com");
//		map.put("validNumber", "12345");
		
//		sender.sendMail(map);
//		sender.sendVerificationMail(map);
		
	}
	public void sendMail(Map<String,String> map) {
		// 메일 발송 시 필요한 정보
		// - 보내는사람(이름, 이메일)
		// - 받는사람(이름, 이메일)
		// - 제목
		// - 내용
		
		//보내는 사람의 이메일주소와 앱 비밀번호
		String username = "보내는 사람 이메일 주소 입력";
		String password = "앱 비밀번호 입력";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		
		//메일 발송
		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(username));		//보내는사람
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(map.get("email")));
			message.setSubject("토이프로젝트에서 발송한 인증번호입니다.");
			
			String content = """
				<h1>메일 테스트</h1>
				<div>메일 내용입니다.</div>
			""";
			message.setContent(content, "text/html; charset=UTF-8");
			Transport.send(message);
			System.out.println("이메일 전송 완료");
			
		} catch (Exception e) {
			// handle exception
			System.out.println("MailSender.sendMail()");
			e.printStackTrace();
		}
		
	}
	public void sendVerificationMail(Map<String,String> map) {
		// 메일 발송 시 필요한 정보
		// - 보내는사람(이름, 이메일)
		// - 받는사람(이름, 이메일)
		// - 제목
		// - 내용

		//보내는 사람의 이메일주소와 앱 비밀번호
		String username = "보내는 사람 이메일 주소 입력";
		String password = "앱 비밀번호 입력";

		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		
		//메일 발송
		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(username));		//보내는사람
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(map.get("email")));
			message.setSubject("인증 테스트 메일입니다.");
			
			String content = """
				<h2>인증번호 발송</h2>
				<div style="border: 1px solid #CCC; width: 300px; height: 120px; border-radius: 5px; background-color: #EEE; display: flex; justify-content: center; align-items: center; margin: 20px 0;">
					인증번호: <span style="font-weight:bold;">%s</span>
				</div>
				<div>
					인증번호를 확인하세요
				</div>
			""".formatted(map.get("validNumber"));
			message.setContent(content, "text/html; charset=UTF-8");
			Transport.send(message);
			System.out.println("이메일 전송 완료");
			
		} catch (Exception e) {
			// handle exception
			System.out.println("MailSender.sendMail()");
			e.printStackTrace();
		}
		
	}
}
