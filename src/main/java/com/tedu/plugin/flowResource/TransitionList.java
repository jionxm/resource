package com.tedu.plugin.flowResource;

import com.sdicons.json.validator.impl.predicates.Str;
import com.tedu.base.common.model.DataGrid;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.common.utils.ConstantUtil;
import com.tedu.base.common.utils.ContextUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.initial.model.xml.ui.Flow;
import com.tedu.base.initial.model.xml.ui.Param;
import com.tedu.base.initial.model.xml.ui.Procedure;
import com.tedu.base.initial.model.xml.ui.XML;
import com.tedu.base.task.SpringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author yangjixin
 * @Description: TODO
 * @date 2018/4/23
 */
public class TransitionList implements ILogicReviser {
	@Autowired
	FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	@Override
	public FormModel beforeLogic(FormEngineRequest requestObj) {
		return null;
	}
	@Override
	public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {
		FormLogger.info("Transform逻辑后置方法FlowList" + requestObj.getData());
		List<Map<String, String>> resourceList = new ArrayList<Map<String, String>>();
		XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
		QueryPage query = new QueryPage();
		query.setQueryParam("documentScan/QryTransitionName");
		List<Map<String, Object>> list = formMapper.query(query);
		System.out.println(list);
		for (Map<String, Object> name : list) {
			List<String> transition=new ArrayList<>();
			String uiName=(String) name.get("name");
			List<Flow> flowList = xml.getFlow(uiName);
			for (Flow flow : flowList) {
				String trigger = flow.getTrigger();
				Map<String, String> row = new HashMap<String, String>();
				List<Procedure> list1 = flow.getProcedureList();
				String value = null;
				for (Procedure procedure : list1) {
					String LogicName = procedure.getLogic();
					if (LogicName.equals("Transition")) {
						int a=0;
						Param param = procedure.getParam("To");
						value = param.getValue();
						for(String value1:transition){
							if (value1.equals(value)) {
								a++;
							}	
						}
						if(a==0){
						transition.add(value);
						row.put("oldTransition",uiName);
						row.put("transition", value);
						resourceList.add(row);
						}
					}
				}
			
			}
			
		}
		DataGrid resourceDataGrid = new DataGrid(resourceList);
        resourceDataGrid.setTotal(resourceList.size());
        responseObj.setData(resourceDataGrid);
	}
}
