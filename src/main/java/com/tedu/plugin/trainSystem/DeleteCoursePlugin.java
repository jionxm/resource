package com.tedu.plugin.trainSystem;


import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;


import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.task.SpringUtils;

@Service("deleteCoursePlugin")
public class DeleteCoursePlugin implements ILogicPlugin {
	@Resource
	FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	public final Logger log = Logger.getLogger(this.getClass());

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		return formModel;
	}
		
		
	
	

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,
			FormEngineResponse responseObj) {
		Map<String,Object> map =  formModel.getData();
		log.info(map);
	/*	QueryPage qp = new QueryPage();
		qp.setParamsByMap(map);
		qp.getData().put("id", formModel.getData().get("id"));
		qp.setQueryParam("trainSystem/QryCourseId");
	    List<Map<String,Object>> list = formService.queryBySqlId(qp);
	    log.info(list);*/
	   
	    Map sqlMap = new HashMap();
    	sqlMap.put("id", formModel.getData().get("id"));
    	CustomFormModel csmd = new CustomFormModel("","",sqlMap);
    	csmd.setSqlId("trainSystem/deleteCourse");
    	formMapper.saveCustom(csmd);
	}

	

}
