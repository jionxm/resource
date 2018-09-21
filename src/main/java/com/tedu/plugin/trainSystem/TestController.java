package com.tedu.plugin.trainSystem;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.task.SpringUtils;

@Controller
@RequestMapping ("/test")

public class TestController {
	/**
	 * 
	 * @author zhangbinjie
	 *
	 */
	
	@Resource
	FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	@RequestMapping(value = "defect")
	@ResponseBody
	public Map workplace(Model model,HttpServletRequest request,
			QueryPage qp) { 
		Map map = new HashMap();
		String id = request.getParameter("id");
		String empid = request.getParameter("empid");
		String business = request.getParameter("business");		
		map.put("id", id);
		map.put("empid", empid);
		map.put("business", business);
		qp.getData().put("addressid", id);
		qp.getData().put("planid", business);
		qp.setQueryParam("trainSystem/QryFileIdByAddress");
		System.out.println("已执行查询");
	    List<Map<String,Object>> list = formService.queryBySqlId(qp);	    
		
		Map sqlMap = new HashMap();
		sqlMap.put("id",list.get(0).get("id"));
		sqlMap.put("planId",business);
		sqlMap.put("traineeBy", empid);
		CustomFormModel csmd = new CustomFormModel("", "", sqlMap);
		csmd.setSqlId("trainSystem/fileFilterUpdate");
		System.out.println("已执行更新");
		
		Map sqlMap1 = new HashMap();
		sqlMap1.put("id",list.get(0).get("id"));
		sqlMap1.put("planId",business);
		sqlMap1.put("traineeBy", empid);
		CustomFormModel csmd1 = new CustomFormModel("", "", sqlMap1);
		csmd1.setSqlId("trainSystem/fileSumTimeSave");
		System.out.println("已执行统计");
		
		Map sqlMap2 = new HashMap();		
		sqlMap2.put("startTime",list.get(0).get("startTime"));
		sqlMap2.put("resultId",list.get(0).get("resultId"));
		sqlMap2.put("traineeBy", empid);
		CustomFormModel csmd2 = new CustomFormModel("", "", sqlMap2);
		csmd2.setSqlId("trainSystem/insertRecord");
		System.out.println("已执行插入");
		
		formMapper.saveCustom(csmd);
		formMapper.saveCustom(csmd1);
		formMapper.saveCustom(csmd2);
		return map;
	}	
}
