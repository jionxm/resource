package com.tedu.uc;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.ObjectUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.googlecode.aviator.AviatorEvaluator;
import com.tarena.ucutil.model.response.CheckTokenResponse;
import com.tarena.ucutil.model.response.QueryResponse;
import com.tarena.ucutil.util.RequestUtil;
import com.tedu.base.auth.login.model.UserModel;
import com.tedu.base.auth.login.service.LoginService;
import com.tedu.base.common.error.ErrorCode;
import com.tedu.base.common.error.ServiceException;
import com.tedu.base.common.error.ValidException;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.common.utils.ConstantUtil;
import com.tedu.base.common.utils.DateUtils;
import com.tedu.base.common.utils.MD5Util;
import com.tedu.base.common.utils.PasswordUtil;
import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.common.utils.TokenUtils;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.UserLog;
import com.tedu.base.engine.service.FormLogService;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.service.FormTokenService;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.engine.util.FormUtil;
import com.tedu.base.msg.mail.SendMsgService;
import com.tedu.base.task.SpringUtils;

/**
 * 登录类
 *
 * @author 朱小猛
 */
@Controller
public class UcLoginController {
	@Value("${base.image.logImg}")
	private String logImg;
	@Value("${base.image.loginImg}")
	private String loginImg;
	@Value("${base.image.sysName}")
	private String sysName;
	@Value("${base.image.loginLogo}")
	private String loginLogo;

	@Value("${base.notice}")
	private String notice;

	@Value("${base.title}")
	private String baseTitle;
	@Value("${base.copyright}")
	private String copyRight;

	@Value("${base.app}")
	private String app;

	@Value("${base.ver}")
	private String ver;

	@Value("${ui.dialog.size.small}")
	private String small;
	@Value("${ui.dialog.size.medium}")
	private String medium;
	@Value("${ui.dialog.size.large}")
	private String large;

	@Value("${base.image.favicon.png}")
	private String faviconPng;

	@Value("${base.image.favicon.ico}")
	private String faviconIco;

	private String cid;

	@Resource
	private LoginService loginService;
	@Resource
	private FormTokenService formTokenService;
	@Resource
	private FormService formService;
	@Resource
	private FormLogService formLogService;
	@Resource
	private SendMsgService sendMsgService;
	// uc接口
	@Value("${uc.index}")
	private String ucIndex;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	// 日志记录器
	public final Logger log = Logger.getLogger(this.getClass());

	@RequestMapping("/uc")
	public String uc(Model model, HttpServletRequest request) {
		model.addAttribute("loginImg", loginImg);
		model.addAttribute("loginLogo", loginLogo);
		model.addAttribute("cid", AviatorEvaluator.execute("Guid()").toString());
		model.addAttribute("app", app);
		model.addAttribute("ver", ver);
		model.addAttribute("notice", notice);
		model.addAttribute("baseTitle", baseTitle);
		model.addAttribute("copyRight", copyRight);
		model.addAttribute("faviconPng", faviconPng);
		model.addAttribute("faviconIco", faviconIco);
		model.addAttribute("ucIndex", ucIndex);
		model.addAttribute("date", DateUtils.getDateToStr("yyyyMMdd", new Date()));
		String token = request.getParameter("token");
		log.info("token:" + token);
		log.info("请求验证中。。。");
		model.addAttribute("ucToken", token);
		return "pc/uc-login";
	}

	/**
	 * 登出操作
	 */
	@RequestMapping("/uc-logOut")
	public String logOut(HttpServletRequest request, Model model) {
		// 登出记录日志
		UserLog log = new UserLog();
		log.setUiName("uc-login");// 必填
		log.setUiTitle("登录页");
		log.setAction("uc-logout");
		log.setUserId(SessionUtils.getUserInfo().getUserId());
		log.setEmpId(SessionUtils.getUserInfo().getEmpId());
		log.setControlName("");
		log.setControlTitle("");
		log.setPanelName("");
		log.setPanelTitle("");
		log.setFlowId(TokenUtils.genUUID());// 必填
		log.setSessionId(SessionUtils.getSession().getId().toString());
		log.setCreateTime(new Date());
		log.setCreateBy(SessionUtils.getUserInfo().getEmpId());

		formLogService.save(log);

		// 清Session
		SessionUtils.removeAll();
		return "redirect:" + ucIndex;
	}

	/**
	 * 登录操作
	 *
	 * @throws Exception
	 */
	@RequestMapping("/uc-login")
	@ResponseBody
	public FormEngineResponse toLogin(@RequestBody FormEngineRequest requestObj, HttpServletRequest request)
			throws Exception {
		return login(requestObj, request);
	}

	private FormEngineResponse login(FormEngineRequest requestObj, HttpServletRequest request) {
		FormEngineRequest engineRequest = requestObj;
		Map<String, Object> param = engineRequest.getData();
		FormEngineResponse response = new FormEngineResponse("");
		log.info("response:" + param);
		Object ucToken = param.get("ucToken");
		UserLog userLog = new UserLog();
		userLog.setUiName("ucMainFrame");
		userLog.setUiTitle("主页");
		userLog.setAction("uc-login");
		String errorReason = "";
		String validateCode = ObjectUtils.toString(param.get("validateCode"));
		Session s = SessionUtils.getSession();
		s.setAttribute("validateCode", validateCode);
		Subject subject = SecurityUtils.getSubject();
		subject.hasRole("");
		Map<String, String> dataMap = new HashMap<String, String>();
		CheckTokenResponse checkToken = RequestUtil.httpCheckTokenPost(ucToken.toString());
		QueryResponse queryResponse = RequestUtil.httpQueryPost(null, checkToken.getUserCode(), null, null);
		if (queryResponse.getCode().equals("0000")) {
			// 登录名
			String userAccount = queryResponse.getUserAccount();
			// 用户code
			String userCode = queryResponse.getUserCode();
			// 邮箱
			String email = queryResponse.getUserEmail();
			// 手机
			String mobile = queryResponse.getUserMobile();
			// 用户姓名
			String name = queryResponse.getUserName();
			// 用户头像
			String photo = queryResponse.getUserPhoto();
			// 用户性别：0男1女
			Integer sex = queryResponse.getUserSex();
			// 0:未激活 1激活 -1:注销"
			Integer state = queryResponse.getUserState();
			String password = "123456";
			List<Map<String, Object>> params = getParams("login/QryUserByName", "eq_name", userAccount);
			String empId = "";
			if (params.size() == 0 || params.isEmpty()) {
				Map<String, Object> data = new HashMap<>();
				data.put("name", name);
				data.put("code", userCode);
				if (state == 1) {
					data.put("status", "work");
				} else {
					data.put("status", "unavailable");
				}
				data.put("type", "fulltime");
				if (sex == 0) {
					data.put("gender", "male");
				} else if (sex == 1) {
					data.put("gender", "female");
				}
				data.put("mobile", mobile);
				data.put("email", email);
				data.put("remark", "uc接口登录用户");
				log.info("insertEmployee" + data);
				save("login/insertEmployee", data);
				params = getParams("login/findByMobile", "eq_name", name);
				log.info("login/findByMobile" + name + ":" + params);
				if (params.isEmpty() || params.size() == 0) {
					throw new ValidException(ErrorCode.INVALIDATE_FORM_DATA, "数据业务校验失败", "登录异常，请重新登录！");
				}
				Map<String, Object> map2 = params.get(0);
				empId = map2.get("id").toString();
				data = new HashMap<>();
				data.put("name", userAccount);
				data.put("empId", empId);
				data.put("authType", "local");
				data.put("password", getPassword(password));
				if (state == 1) {
					data.put("status", "enable");
				} else {
					data.put("status", "disable");
				}
				save("login/insertUser", data);
				params = getParams("login/QryUserByName", "eq_name", userAccount);
				map2 = params.get(0);
				String uId = map2.get("id").toString();
				data = new HashMap<>();
				data.put("userId", uId);
				save("login/insertUserRole", data);
			} else {
				params = getParams("login/findByMobile", "eq_name", name);
				if (params.isEmpty() || params.size() == 0) {
					throw new ValidException(ErrorCode.INVALIDATE_FORM_DATA, "数据业务校验失败", "登录异常，请重新登录！");
				}
				Map<String, Object> map2 = params.get(0);
				empId = map2.get("id").toString();
			}

			UsernamePasswordToken token = new UsernamePasswordToken(userAccount, password);
			subject.login(token);
			params = getParams("login/QryUserByName", "eq_name", userAccount);
			Map<String, Object> map2 = params.get(0);
			String userId = map2.get("id").toString();
			SessionUtils.setAttrbute("ctx", request.getContextPath());
			s.setAttribute("ip", request.getLocalAddr());
			s.setAttribute("port", request.getLocalPort());
			response.setCode("0");
			response.setMsg("登录成功");
			userLog.setUserId(Long.parseLong(userId));
			userLog.setEmpId(Long.parseLong(empId));
			userLog.setSessionId(s.getId().toString());
			userLog.setCreateBy(Long.parseLong(empId));
			userLog.setExecResult("登录成功");
			dataMap.put("userId", userId);
			log.info("ucdataMap:" + dataMap);
			response.setData(dataMap);
		} else {
			response.setCode(queryResponse.getCode());
			errorReason = "登录超时";
			response.setCode(ErrorCode.UNKNOWN.getCode());
			response.setMsg(ErrorCode.UNKNOWN.getMsg());
		}
		// 登录成功 记录用户日志
		userLog.setControlName("");
		userLog.setControlTitle("");
		userLog.setPanelName("");
		userLog.setPanelTitle("");
		userLog.setFlowId(TokenUtils.genUUID());
		userLog.setCreateTime(new Date());
		if (userLog.getExecResult() == null) {
			userLog.setExecResult("登录失败");
		}
		userLog.setErrorReason(errorReason);
		userLog.setClientIp(FormUtil.getClientIP(request));
		formLogService.save(userLog);
		log.info(formLogService);

		return response;

	}

	public List<Map<String, Object>> getParams(String url, String eq, String param) {
		QueryPage queryPage = new QueryPage();
		Map<String, Object> mapParam = new HashMap<>();
		mapParam.put(eq, param);
		queryPage.setParamsByMap(mapParam);
		queryPage.setQueryParam(url);
		// 查询人员并替换新旧表单相关人员信息(姓名)
		List<Map<String, Object>> list = formService.queryBySqlId(queryPage);
		return list;
	}

	public void save(String url, Map<String, Object> data) {
		CustomFormModel customerModel = new CustomFormModel();
		customerModel.setData(data);
		customerModel.setSqlId(url);
		formService.saveCustom(customerModel);
	}

	public String getPassword(String password) {
		password = MD5Util.MD5Encode(password).toUpperCase();
		String salt = AviatorEvaluator.execute("Guid()").toString();
		String saltedPwd = PasswordUtil.getPassword(PasswordUtil.ALGORITHM_NAME_STR, salt, password);
		return saltedPwd;
	}

	/**
	 * 跳转首页
	 */
	@RequestMapping("/uc-index")
	public String welcome(HttpServletRequest request, Model model) {
		return index(request, model, "");
	}

	private String index(HttpServletRequest request, Model model, String type) {

		ModelAndView modelAndView = new ModelAndView();
		UserModel userModel = (UserModel) SessionUtils.getAttrbute(ConstantUtil.USER_INFO);
		model.addAttribute("baseTitle", baseTitle);
		// TODO 菜单类型从数据字典中动态获得
		if (userModel != null) {
			List<Map<String, String>> allMenuList = new ArrayList<Map<String, String>>();
			if (SessionUtils.getUserInfo().isAdminRole()) {
				allMenuList = loginService.getAllAuthorization();
			} else {
				if ("forCustom".equals(type)) {
					allMenuList = loginService.getAuthorization("student", "menu");
				} else {
					allMenuList = loginService.getAuthorization(userModel.getUserName(), "menu");
				}
			}

			List<Map<String, String>> mainMenuList = allMenuList
					.stream().filter(stringStringMap -> !stringStringMap.isEmpty()
							&& !stringStringMap.get("type").isEmpty() && stringStringMap.get("type").equals("mainMenu"))
					.collect(Collectors.toList());
			List<Map<String, String>> quickMenuList = allMenuList.stream()
					.filter(stringStringMap -> !stringStringMap.isEmpty() && !stringStringMap.get("type").isEmpty()
							&& stringStringMap.get("type").equals("quickMenu") && stringStringMap.get("parent") != null)
					.collect(Collectors.toList());
			List<Map<String, String>> index = allMenuList.stream()
					.filter(stringStringMap -> !stringStringMap.isEmpty() && !stringStringMap.get("type").isEmpty()
							&& stringStringMap.get("type").equals("index") && stringStringMap.get("parent") != null)
					.collect(Collectors.toList());

			List<String> menuParentList = new ArrayList<String>();

			mainMenuList.stream().forEach(stringStringMap -> menuParentList.add(stringStringMap.get("parentName")));

			List<String> menuParentDistinct = menuParentList.stream().distinct().collect(Collectors.toList());

			// 倒序排列快捷菜单
			Collections.sort(quickMenuList, new Comparator<Map<String, String>>() {
				public int compare(Map<String, String> o1, Map<String, String> o2) {
					Integer seq1 = Integer.valueOf(String.valueOf(o1.get("seq")));
					Integer seq2 = Integer.valueOf(String.valueOf(o2.get("seq")));
					return seq2.compareTo(seq1);
				}
			});

			if (!index.isEmpty()) {
				Map<String, String> indexResource = index.get(0);
				model.addAttribute("indexTarget", indexResource.get("target"));

				model.addAttribute("indexName", indexResource.get("name"));
				model.addAttribute("indexUrl", indexResource.get("url"));
				model.addAttribute("indexMenuCode", indexResource.get("code"));
			} else {
				model.addAttribute("indexName", "");
				model.addAttribute("indexUrl", "");
				model.addAttribute("indexMenuCode", "");
			}
			model.addAttribute("menuList", mainMenuList);
			model.addAttribute("quickMenuList", quickMenuList);

			model.addAttribute("menuParentList", menuParentDistinct);

			model.addAttribute("windowSize", large);

			model.addAttribute("logImg", logImg);
			model.addAttribute("sysName", sysName);

			initResource();
			FormUtil.checkOutSavedRequest(request, model);
			// 登陆成功跳转主页
			return "ucMainFrame";
		} else {
			model.addAttribute("loginImg", loginImg);
			model.addAttribute("loginLogo", loginLogo);

			model.addAttribute("notice", notice);
			model.addAttribute("cid", AviatorEvaluator.execute("Guid()").toString());
			model.addAttribute("app", app);
			model.addAttribute("ver", ver);
			model.addAttribute("copyRight", copyRight);
			model.addAttribute("faviconPng", faviconPng);
			model.addAttribute("faviconIco", faviconIco);
			model.addAttribute("date", DateUtils.getDateToStr("yyyyMMdd", new Date()));
			// 交换秘钥HMAC
			if ("".equals(type))
				return "redirect:" + ucIndex;
			else
				return "loginForCustom";
		}

	}

	/**
	 * token拦截器需要将所有可访问资源初始在内存中 ShiroFilerChainManager中的查询不正确。 暂用此方式代替
	 */
	public void initResource() {
		// load accessible url
		QueryPage queryPage = new QueryPage();
		queryPage.setQueryParam("ACLU");// 所有当前用户可访问的url资源：满足授权的和不需授权的url
		List<Map<String, Object>> listUrl = formService.queryBySqlId(queryPage);
		// //不限定权限的资源
		SessionUtils.setAccessibleUrl(listUrl);
		// load accessible control list
		try {
			queryPage = new QueryPage();
			queryPage.setQueryParam("ACL");
			List<Map<String, Object>> controlList = formService.queryBySqlId(queryPage);
			if (controlList != null) {
				Map<String, String> userControlMap = new HashMap<>();
				controlList.forEach(
						e -> userControlMap.put(ObjectUtils.toString(e.get("url")), ObjectUtils.toString(e.get("id"))));// "ui.panel.controlName"
				SessionUtils.setACL(userControlMap);
				FormLogger.logBegin(String.format("装载用户可访问组件{%s}个", controlList.size()));
			}
		} catch (Exception e) {
			throw new ServiceException(ErrorCode.ACL_LOAD_FAILED, e.getMessage());
		}
	}

}
