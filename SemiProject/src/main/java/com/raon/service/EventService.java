package com.raon.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;

import com.raon.domain.Event;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class EventService {

	public void getList(Model model) throws IOException {
		log.info("EventService -> getList()");

		LocalDate currentDate = LocalDate.now();

		// 년, 월, 일을 가져와서 문자열로 변환합니다.
		int year = currentDate.getYear();
		int month = currentDate.getMonthValue();
		int day = currentDate.getDayOfMonth();

		// 월과 일이 한 자리 수일 경우 앞에 0을 붙여줍니다.
		String formattedMonth = String.format("%02d", month);
		String formattedDay = String.format("%02d", day);

		// 날짜 문자열을 생성합니다.
		String currentDateStr = year + formattedMonth + formattedDay;

		StringBuilder urlBuilder = new StringBuilder(
				"https://apis.data.go.kr/B551011/KorService1/searchFestival1"); /* URL */
		urlBuilder.append(
				"?" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("raon", "UTF-8")); /* 조회종료일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /* xml 또는 json */
		urlBuilder.append(
				"&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("Q", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append("&" + URLEncoder.encode("eventStartDate", "UTF-8") + "="
				+ URLEncoder.encode(currentDateStr, "UTF-8")); /* 측정소명 */
		urlBuilder.append(
				"&" + URLEncoder.encode("areaCode", "UTF-8") + "=" + URLEncoder.encode("39", "UTF-8")); /* 측정소명 */
		urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8")
				+ "=KR1eLnI5BrfL8EDf5l8G3OTQakbgTZ0izb4KANg0SWhwqnP1wHHQQRb%2BrbP1N2a5lnEtjR%2BBvLqfZKaKSZELLQ%3D%3D");

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		System.out.println(sb.toString());
		JSONObject jsonObject = new JSONObject(sb.toString());
		List<Event> eventList = new ArrayList<Event>();
		jsonObject = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items");
		JSONArray jsonArray = jsonObject.getJSONArray("item");
		for (int i = 0; i < jsonArray.length(); i++) {
			eventList.add(new Event(jsonArray.getJSONObject(i).getString("addr1"),
					jsonArray.getJSONObject(i).getString("contentid"), formatDate(jsonArray.getJSONObject(i).getString("eventstartdate")),
					formatDate(jsonArray.getJSONObject(i).getString("eventenddate")), jsonArray.getJSONObject(i).getString("firstimage"),
					jsonArray.getJSONObject(i).getString("mapx"), jsonArray.getJSONObject(i).getString("mapy"),
					jsonArray.getJSONObject(i).getString("mlevel"),jsonArray.getJSONObject(i).getString("tel"),
					jsonArray.getJSONObject(i).getString("title")
			));

		}

		log.info("EventService -> getList success");
		model.addAttribute("eventList",eventList);
	}


	
	public void getDetailImage(String contentId, Model model) throws IOException{
		
		StringBuilder urlBuilder = new StringBuilder(
				"https://apis.data.go.kr/B551011/KorService1/detailImage1"); /* URL */
		urlBuilder.append(
				"?" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("raon", "UTF-8")); /* 조회종료일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /* xml 또는 json */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("imageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("subImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("999999", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8")
				+ "=KR1eLnI5BrfL8EDf5l8G3OTQakbgTZ0izb4KANg0SWhwqnP1wHHQQRb%2BrbP1N2a5lnEtjR%2BBvLqfZKaKSZELLQ%3D%3D");

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		log.info("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		log.info(sb.toString());
		JSONObject jsonObject = new JSONObject(sb.toString());
		List<Event> eventImageList = new ArrayList<Event>();
		List<Event> posterImageList = new ArrayList<Event>();
		jsonObject = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items");
		JSONArray jsonArray = jsonObject.getJSONArray("item");
		 for (int i = 0; i < jsonArray.length(); i++) {
	            String imgname = jsonArray.getJSONObject(i).getString("imgname");
	            // "포스터"를 포함하지 않는 경우에만 eventImageList에 추가
	            if (!imgname.contains("포스터")) {
	                eventImageList.add(new Event(
	                        imgname,
	                        jsonArray.getJSONObject(i).getString("originimgurl")
	                ));
	            }
	            if(imgname.contains("포스터")) {
	            	posterImageList.add(new Event(
	            			imgname,
	            	        jsonArray.getJSONObject(i).getString("originimgurl")
	            		));
	            }
	        }
		List<String> eventImageLists = new ArrayList<String>();
		List<String> posterImageLists = new ArrayList<String>();
		for(Event event : eventImageList) {
			eventImageLists.add(event.getOriginimgurl());
		}
		for(Event event : posterImageList) {
			posterImageLists.add(event.getOriginimgurl());
		}
				
		
		log.info("EventService -> getList success");
		model.addAttribute("posterImageList", posterImageLists);
		model.addAttribute("eventImageList",eventImageLists);
	}
	
	public void getDetailInfo(String contentId, Model model) throws IOException{
		StringBuilder urlBuilder = new StringBuilder(
				"https://apis.data.go.kr/B551011/KorService1/detailInfo1"); /* URL */
		urlBuilder.append(
				"?" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("raon", "UTF-8")); /* 조회종료일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /* xml 또는 json */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode("15", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("999999", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8")
				+ "=KR1eLnI5BrfL8EDf5l8G3OTQakbgTZ0izb4KANg0SWhwqnP1wHHQQRb%2BrbP1N2a5lnEtjR%2BBvLqfZKaKSZELLQ%3D%3D");

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		log.info("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		log.info(sb.toString());
		JSONObject jsonObject = new JSONObject(sb.toString());
		List<String> infotextList = new ArrayList<String>();
		jsonObject = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items");
		JSONArray jsonArray = jsonObject.getJSONArray("item");
		 for (int i = 0; i < jsonArray.length(); i++) {
			 infotextList.add(jsonArray.getJSONObject(i).getString("infotext"));
	        }
		log.info("EventService -> getList success");
		model.addAttribute("infotextList", infotextList);
	}
	
	public void detailCommon(String contentId, Model model) throws IOException{
		StringBuilder urlBuilder = new StringBuilder(
				"https://apis.data.go.kr/B551011/KorService1/detailCommon1"); /* URL */
		urlBuilder.append(
				"?" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("raon", "UTF-8")); /* 조회종료일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /* xml 또는 json */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode("15", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("defaultYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("firstImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("areacodeYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("catcodeYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("addrinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("mapinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("overviewYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("999999", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8")
				+ "=KR1eLnI5BrfL8EDf5l8G3OTQakbgTZ0izb4KANg0SWhwqnP1wHHQQRb%2BrbP1N2a5lnEtjR%2BBvLqfZKaKSZELLQ%3D%3D");

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		log.info("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		log.info(sb.toString());
		JSONObject jsonObject = new JSONObject(sb.toString());
		List<Event> detailCommonList = new ArrayList<Event>();
		jsonObject = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items");
		JSONArray jsonArray = jsonObject.getJSONArray("item");
		 for (int i = 0; i < jsonArray.length(); i++) {
			 detailCommonList.add(new Event(
					 jsonArray.getJSONObject(i).getString("mapx"),
					 jsonArray.getJSONObject(i).getString("mapy"),
					 jsonArray.getJSONObject(i).getString("mlevel"),
					 jsonArray.getJSONObject(i).getString("homepage"),
					 jsonArray.getJSONObject(i).getString("telname"),
					 jsonArray.getJSONObject(i).getString("tel")
					 ));
	        }
		log.info("EventService -> getList success");
		model.addAttribute("detailCommonList", detailCommonList);
	}
	
	public void detailIntro(String contentId, Model model) throws IOException{
		StringBuilder urlBuilder = new StringBuilder(
				"https://apis.data.go.kr/B551011/KorService1/detailIntro1"); /* URL */
		urlBuilder.append(
				"?" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("raon", "UTF-8")); /* 조회종료일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /* xml 또는 json */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode("15", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append(
				"&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("999999", "UTF-8")); /* 조회시작일자 */
		urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8")
				+ "=KR1eLnI5BrfL8EDf5l8G3OTQakbgTZ0izb4KANg0SWhwqnP1wHHQQRb%2BrbP1N2a5lnEtjR%2BBvLqfZKaKSZELLQ%3D%3D");

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		log.info("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		log.info(sb.toString());
		JSONObject jsonObject = new JSONObject(sb.toString());
		List<Event> detailIntroList = new ArrayList<Event>();
		jsonObject = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items");
		JSONArray jsonArray = jsonObject.getJSONArray("item");
		 for (int i = 0; i < jsonArray.length(); i++) {
			 detailIntroList.add(new Event(
					 jsonArray.getJSONObject(i).getString("eventplace"),
					 jsonArray.getJSONObject(i).getString("playtime"),
					 jsonArray.getJSONObject(i).getString("usetimefestival"),
					 jsonArray.getJSONObject(i).getString("sponsor1"),
					 jsonArray.getJSONObject(i).getString("sponsor2")
					 ));
	        }
		log.info("EventService -> getList success");
		model.addAttribute("detailIntroList", detailIntroList);
	}

	public String formatDate(String dateString) {
		log.info("EventService -> formatDate");
		String year = dateString.substring(0, 4);
		String month = dateString.substring(4, 6);
		String day = dateString.substring(6, 8);
		return year + "." + month + "." + day;
	}
}
