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

@Service("DeleteFilePlugin")
public class DeleteFilePlugin implements ILogicPlugin {
	@Resource
	FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	public final Logger log = Logger.getLogger(this.getClass());

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		Map<String,Object> map =  formModel.getData();
		log.info(map);
		Map sqlMap = new HashMap();
		sqlMap.put("id", map.get("id"));
		CustomFormModel csmd = new CustomFormModel("","",sqlMap);
    	csmd.setSqlId("trainSystem/DeleteFile");
    	formMapper.saveCustom(csmd);
		/*QueryPage qp = new QueryPage();
		QueryPage query = new QueryPage();
		qp.setParamsByMap(map);
		qp.getData().put("id", formModel.getData().get("id"));
		qp.setQueryParam("trainSystem/QryFileId");
	    List<Map<String,Object>> list = formService.queryBySqlId(qp);
	    log.info(list);
	    query.getData().put("trainFileId", list.get(0).get("train_file_id"));
	    query.setQueryParam("trainSystem/QryFile");
	    List<Map<String,Object>> list1 = formService.queryBySqlId(query);
	    log.info(list1);
	    for(Map nmap:list1){
	    	String id =  nmap.get("id").toString();
	    	Map sqlMap = new HashMap();
	    	sqlMap.put("id", id);
	    	sqlMap.put("traineeId", list.get(0).get("trainee_id"));
	    	CustomFormModel csmd = new CustomFormModel("","",sqlMap);
	    	csmd.setSqlId("trainSystem/DeleteFile");
	    	formMapper.saveCustom(csmd);
	    }*/
		return formModel;
	}
		
		
	
	

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,
			FormEngineResponse responseObj) {
		
	}

	

}
