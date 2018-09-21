
package com.tedu.base.ftl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.druid.support.json.JSONUtils;
import com.tarena.ucutil.model.request.Request;
import com.tarena.ucutil.model.request.SynInfoRequest;
import com.tarena.ucutil.util.GetRequest;
import com.tarena.ucutil.util.RequestUtil;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.common.utils.JsonUtil;
import com.tedu.base.common.utils.ResponseJSON;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.service.FormTokenService;
import com.tedu.base.task.SpringUtils;

import net.sf.json.JSONArray;

/**
 * 登录类
 *
 * @author 朱小猛
 */
@Controller
public class SyncCourseController {

	@Resource
	private FormTokenService formTokenService;
	@Resource
	private FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	// 日志记录器
	public final Logger log = Logger.getLogger(this.getClass());
	@Value("${course.app.key}")
	private String appKey;
	@Value("${course.private.key}")
	private String privateKey;
	@Value("${uc.resource.course}")
	private String courseUrl;
	@RequestMapping("/resource-sync")
	@ResponseBody
	public ResponseJSON resourceSync(Model model, HttpServletRequest request) {
		Request req = new Request();
		req.setVersion("3.0");
		String string = SendRequetUtil.synData(req, appKey, privateKey,courseUrl);
		log.info(string);
		String data = JsonUtil.getValueByKey(string, "data");
		String systemCode = JsonUtil.getValueByKey(string, "systemCode");
		log.info(systemCode);
		String systemName = JsonUtil.getValueByKey(string, "systemName");
		log.info(systemName);
		Object parse = JSONUtils.parse(data);
		JSONArray arr = JSONArray.fromObject(parse);
		List<CourseDo> list = (List<CourseDo>) JSONArray.toCollection(arr, CourseDo.class);
		log.info(list.size());
		log.info(list);
		Map<String, Object> map;
		Map<String, Object> course;
		int i = 0;
		for (CourseDo courseDo : list) {
			i++;
			Long stageId = courseDo.getStageId();
			map = new HashMap<String, Object>();
			map.put("eq_systemCode", systemCode);
			map.put("eq_stageId", stageId);
			String courseName = courseDo.getCourseName();
			Long courseId = courseDo.getCourseId();
			String stageName = courseDo.getStageName();
			Long versionId = courseDo.getVersionId();
			String versionName = courseDo.getVersionName();
			List<Map<String, Object>> courseList = getParam("resource/QryCourse", map);
			log.info(courseList);
			if (courseList.isEmpty()) {
				course = new HashMap<String, Object>();
				course.put("systemCode", systemCode);
				course.put("courseId", courseId);
				course.put("courseName", courseDo.getCourseName());
				course.put("versionId", versionId);
				course.put("versionName", versionName);
				course.put("stageId", stageId);
				course.put("stageName", stageName);
				course.put("systemName", systemName);
				log.info(map);
				save("resource/InsertCourse", course);
				log.info(i);
			} else {
				course = new HashMap<String, Object>();
				Map<String, Object> cour = courseList.get(0);
				String id = cour.get("id").toString();
				Integer updateCount = Integer.parseInt(cour.get("updateCount").toString());
				course.put("systemCode", systemCode);
				course.put("courseId", courseId);
				course.put("courseName", courseDo.getCourseName());
				course.put("versionId", versionId);
				course.put("versionName", versionName);
				course.put("stageId", stageId);
				course.put("stageName", stageName);
				course.put("systemName", systemName);
				course.put("id", id);
				course.put("updateCount", updateCount++);
				save("resource/UpdateCourse", course);
				log.info(i);
			}
		}

		ResponseJSON result = new ResponseJSON();
		result.setStatus(i);
		result.setMsg("同步成功！共同步了" + i + "个课程");
		return result;
	}

	public void save(String url, Map<String, Object> data) {
		CustomFormModel customerModel = new CustomFormModel();
		customerModel.setData(data);
		customerModel.setSqlId(url);
		formService.saveCustom(customerModel);
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
