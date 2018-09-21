package com.tedu.plugin.trainSystem;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;


import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.task.SpringUtils;

@Service("insertCoursePlugin")
public class insertCoursePlugin implements ILogicPlugin {
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
		QueryPage qp = new QueryPage();
		qp.setParamsByMap(map);
		qp.getData().put("courseId", formModel.getData().get("courseId"));
		qp.setQueryParam("trainSystem/QryTrainee");
	    List<Map<String,Object>> list = formService.queryBySqlId(qp);
	    QueryPage query = new QueryPage();
	    query.getData().put("id", list.get(list.size()-1).get("id"));
	    query.getData().put("courseId", formModel.getData().get("courseId"));
	    query.setQueryParam("trainSystem/QryTrainee1");
	    List<Map<String,Object>> list1 = formService.queryBySqlId(query);
	    for(Map smap : list1){
	    	Map<String,Object> sqlMap =  new HashMap();
	    	sqlMap.put("id", list.get(list.size()-1).get("id"));
	    	sqlMap.put("traineeId", smap.get("trainee_id"));
	    	CustomFormModel csmd = new CustomFormModel("","",sqlMap);
	    	csmd.setSqlId("trainSystem/InsertCourse");
	    	formMapper.saveCustom(csmd);
	    }
    	
	}

	

}
