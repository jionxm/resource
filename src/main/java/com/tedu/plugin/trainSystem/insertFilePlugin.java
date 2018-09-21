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

@Service("insertFilePlugin")
public class insertFilePlugin implements ILogicPlugin {
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
		QueryPage qp = new QueryPage();
		qp.setParamsByMap(map);
		qp.getData().put("trainFileId", formModel.getData().get("trainFileId"));
		qp.setQueryParam("trainSystem/QryFile");
	    List<Map<String,Object>> list = formService.queryBySqlId(qp);
	    for(Map nmap:list){
	    	String id =  nmap.get("id").toString();
	    	Map sqlMap = new HashMap();
	    	sqlMap.put("id", id);
	    	sqlMap.put("traineeId", formModel.getData("ctlTraineeId"));
	    	CustomFormModel csmd = new CustomFormModel("","",sqlMap);
	    	csmd.setSqlId("trainSystem/InsertCourse");
	    	formMapper.saveCustom(csmd);
	    	
	    	
	    }
	}

	

}
