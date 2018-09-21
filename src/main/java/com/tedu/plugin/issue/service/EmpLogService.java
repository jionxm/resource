package com.tedu.plugin.issue.service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.jcraft.jsch.Session;
import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormLogService;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.engine.util.FormUtil;

@Service("empLogService")
public class EmpLogService implements ILogicPlugin {
	@Resource
	FormLogService formLogService;
	@Resource
	private FormMapper formMapper;		
	private String table = "t_employee";
	private String primaryField = "id";
	private String sqlTemplate = "emp/saveEmpLog";

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		if (StringUtils.isNotEmpty(formModel.getPrimaryFieldValue())) {
			Map<String,Object> mapData = formMapper.selectById(table, primaryField,
					formModel.getPrimaryFieldValue());
			return mapData;
		}else{
			return null;
		}
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,FormEngineResponse responseObj) {
		    Map<String,String> empStatus = new HashMap<String,String>();	
		    empStatus.put("employ", "已入职");
		    empStatus.put("work", "已上岗");
		    empStatus.put("dimission", "已离职");
		    empStatus.put("offer", "已录用");
		    empStatus.put("unavailable", "不可用");
		    empStatus.put("reserve", "已储备");
	    
			Map<String,Object> mapOldData = null;
			//判断旧数据是否是0
			if (StringUtils.isNotEmpty(beforeResult.toString())) {
				mapOldData = (Map<String,Object>)beforeResult;
			}
			Map<String,Object> mapNewData = formMapper.selectById(table, primaryField,
					formModel.getPrimaryFieldValue());
			formModel.getData().put("id", formModel.getPrimaryFieldValue());
			CustomFormModel cModel = new CustomFormModel();
			
			cModel.setSqlId(sqlTemplate);
			cModel.setData(formModel.getData());
			FormUtil.shrink(mapOldData, mapNewData);
			Map<String, Object> logData = formModel.getData();
			
			logData.put("history", beforeResult.toString());
			String name = SessionUtils.getUserInfo().getEmpName();
			boolean flag = false;
			if (mapOldData == null) {
				logData.put("type","new");
				logData.put("logContent","("+name+")新建人员");
				flag = true;
			}else{
				logData.put("type","modify");
				if (mapNewData.get("status")!=null) {
					logData.put("logContent","("+name+")将状态由("+empStatus.get(ObjectUtils.toString(mapOldData.get("status"))) + ")变更为(" + empStatus.get(ObjectUtils.toString(mapNewData.get("status")))+")");
					flag = true;
				}		
			}
			logData.put("createTime",new Date());
			logData.put("createBy",SessionUtils.getUserInfo().getEmpId());	
			
			int n = 0;
			if (flag) {
				n = formMapper.saveCustom(cModel);
			}
			if(n!=1){
				FormLogger.logFlow(String.format("记录issueLog失败", formModel.getPrimaryFieldValue()), FormLogger.LOG_TYPE_ERROR);
			}
	}
}
