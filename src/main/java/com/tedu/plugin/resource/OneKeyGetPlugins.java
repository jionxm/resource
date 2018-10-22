package com.tedu.plugin.resource;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.task.SpringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("oneKeyGetPlugins")

public class OneKeyGetPlugins implements ILogicPlugin {
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	@Autowired
	FormService formService;
	public final Logger log = Logger.getLogger(this.getClass());
	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		/*Map<String, Object> data = formModel.getData();
		Object object = formModel.getData().get("fileId");
		System.out.println(object.toString());
		System.out.println(data);*/
		Map<String, Object> data = formModel.getData();
		List<Map<String,Object>> list = getParams("resource/QryResFile","eq_status","0");
		String fileIds = "";
		for (Map<String, Object> map : list) {
			String fileId = map.get("fileId").toString();
			if (fileIds.equals("")) {
				fileIds = fileId;
			}else {
				fileIds=fileIds+","+fileId;
			}
		}
		data.put("fileId", fileIds);
		formModel.setData(data);
		log.info(formModel.getData());
		return null;
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,
			FormEngineResponse responseObj) {

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

}
