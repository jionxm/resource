package com.tedu.plugin.trainSystem;

import com.tedu.base.common.utils.LogUtil;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormLogService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

@Service("deleteStudyPlugins")
public class DeleteStudyPlugins implements ILogicPlugin {
	@Resource
    FormLogService formLogService;
	@Resource
	private FormMapper formMapper;
	private String table = "t_trainee_file";
	private String sqlTemplate = "trainSystem/deleteStudySql2";

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		return null;
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult, FormEngineResponse responseObj) {
		
		  
		  Map<String,Object> map=(Map<String, Object>) formModel.getData();
		  LogUtil.info(map.toString());
		  String[] ids=map.get("id").toString().split(",");
		  LogUtil.info(ids.toString());
		  int i=0;
		  for(String id:ids){
				CustomFormModel cModel = new CustomFormModel();
				
				cModel.setSqlId(sqlTemplate);
				cModel.setData(formModel.getData());
				Map<String, Object> logData = formModel.getData();
				
				logData.put("id", id);
				LogUtil.info(cModel.getData().toString());
				formMapper.saveCustom(cModel);
				i++;
					}
	}
}
