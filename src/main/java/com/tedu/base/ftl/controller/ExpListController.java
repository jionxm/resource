
package com.tedu.base.ftl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.service.FormTokenService;
import com.tedu.base.task.SpringUtils;

/**
 * 登录类
 *
 * @author 朱小猛
 */
@Controller
public class ExpListController {

	@Resource
	private FormTokenService formTokenService;
	@Resource
	private FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	// 日志记录器
	public final Logger log = Logger.getLogger(this.getClass());

	@RequestMapping("/resource-list")
	public String resourceList(Model model, HttpServletRequest request) {
		String stageId = request.getParameter("stageId");
		String systemCode = request.getParameter("systemCode");
		Map<String, Object> map = new HashMap<>();
		if (StringUtils.isNotEmpty(stageId) && StringUtils.isNotEmpty(systemCode)) {
			map.put("eq_stageId", stageId);
			map.put("eq_systemCode", systemCode);
			List<Map<String, Object>> list = getParam("resource/QryCourse", map);
			if (!list.isEmpty()) {
				Map<String, Object> course = list.get(0);
				String courseId = course.get("id").toString();
				map = new HashMap<>();
				map.put("eq_courseId", courseId);
				map.put("eq_status", 0);
				list = getParam("resource/QryResFile", map);
				log.info(list);
				if (!list.isEmpty()) {
					model.addAttribute("resourceList", list);
				}
				map = new HashMap<>();
				list = getParam("resourceType/QryResourceTypeList", map);
				if (!list.isEmpty() && list.size() > 0) {
					model.addAttribute("typeList", list);
				}
				return "pc/ResourceList";
			}
		} else {
			return "";
		}
		return "";
	}

	public List<Map<String, Object>> getParam(String url, Map<String, Object> map) {
		QueryPage queryPage = new QueryPage();
		queryPage.setParamsByMap(map);
		queryPage.setQueryParam(url);
		// 查询人员并替换新旧表单相关人员信息(姓名)
		List<Map<String, Object>> list = formService.queryBySqlId(queryPage);
		return list;
	}

}
