/*
 * Tmooc 3.0
 *
 * Copyright © 2018 Tarena Technology Group Ltd. All rights reserved..
 */
package com.tedu.base.ftl.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import com.alibaba.druid.support.json.JSONUtils;
import com.tarena.ucutil.model.request.Request;
import com.tarena.ucutil.util.CommonUtil;
import com.tarena.ucutil.util.GetSign;
import com.tarena.ucutil.util.RequestUtil;
import com.tarena.ucutil.util.UUIDGenerator;
import com.tedu.base.common.utils.JsonUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * <p>
 * Description: 发送请求工具类
 * </p>
 *
 * @author Wanghc
 * @version 1.0
 * 
 *          <p>
 *          History: ----------------------------------------------- Date:
 *          2018年8月30日 上午10:28:53 Author: Wanghc Version: 1.0 OP: Create
 *          -----------------------------------------------
 *          </p>
 *
 * @since
 * @see
 */
public class SendRequetUtil {

	private static final Logger logger = LoggerFactory.getLogger(RequestUtil.class);
	/** 编码方式 */
	private final static String ENCODED_TYPE = "UTF-8";
	/** 请求类型 */
	private final static String CONTENT_TYPE = "application/json";


	/**
	 *
	 * @param url
	 * @param jsonParam
	 * @return
	 */
	public static String sendPostByJsonParam(String url, String jsonParam) {

		logger.info("post url :{}, post data:{}", url, jsonParam);
		// post请求返回结果
		if (CommonUtil.isEmpty(url)) {
			return null;
		}
		if (CommonUtil.isEmpty(jsonParam)) {
			return null;
		}
		String str = "";
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost method = new HttpPost(url);

		// 解决中文乱码问题
		StringEntity entity = new StringEntity(jsonParam, ENCODED_TYPE);
		entity.setContentEncoding(ENCODED_TYPE);
		entity.setContentType(CONTENT_TYPE);
		method.setEntity(entity);
		try {
			HttpResponse result = client.execute(method);
			/* 请求发送成功，并得到响应 * */
			if (200 == result.getStatusLine().getStatusCode()) {
				/* 读取服务器返回过来的json字符串数据 * */
				str = EntityUtils.toString(result.getEntity(), ENCODED_TYPE);
				logger.info("-------------------" + str);
			} else {
				logger.info("-------------------" + result.getStatusLine().getStatusCode());
				str = "{'code':'-4','msg':'响应为空'}";
			}
		} catch (ClientProtocolException e) {
			logger.error("发送请求异常" + e);
			e.printStackTrace();
			return "{'code':'-1','msg':'服务器本地错误：客户端协议异常'}";
		} catch (ParseException e) {
			logger.error("发送请时转换异常" + e);
			e.printStackTrace();
			return "{'code':'-2','msg':'服务器本地错误：本次转换异常'}";
		} catch (IOException e) {
			logger.error("发送请求异常" + e);
			e.printStackTrace();
			return "{'code':'-3','msg':'服务器本地错误：网络异常'}";
		}
		return str;
	}

	/**
	 * 发送请求
	 * 
	 * @param request
	 * @param publicKey  公钥
	 * @param privateKey 私钥
	 * @param sender     发送方
	 * @return
	 */
	public static String synData(Request request, String publicKey, String privateKey,String courseUrl) {

		request.setRequestid(UUIDGenerator.random16UUID());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		request.setTime(sdf.format(new Date()));
		String param = "requestid=" + request.getRequestid() + "&version=" + request.getVersion() + "&time="
				+ request.getTime() + "&appcode=" + publicKey + "&key=" + privateKey;
		request.setSign(GetSign.getSHA256(param));
		request.setAppcode(publicKey);
		String jsonParam = JSONObject.fromObject(request).toString();
		System.out.println(courseUrl);
		return SendRequetUtil.sendPostByJsonParam(courseUrl, jsonParam);

	}

	public static void main(String[] args) {
	}

}
