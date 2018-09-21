package com.tedu.plugin.resource;

import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.task.SpringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service("deleteResourcePlugins")
public class DeleteResourcePlugins implements ILogicPlugin {
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	public final Logger log = Logger.getLogger(this.getClass());

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		return null;
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,
			FormEngineResponse responseObj) {
		Map<String, Object> map = formModel.getData();
		String[] ids = map.get("id").toString().split(",");
		for (String id : ids) {
			Map<String, Object> maps = new HashMap<String, Object>();
			log.info(id);
			maps.put("id", id);
			CustomFormModel csmd = new CustomFormModel("", "", maps);
			// 执行删除操作
			csmd.setSqlId("resource/DeleteResource");
			formMapper.saveCustom(csmd);
		}

	}

}
