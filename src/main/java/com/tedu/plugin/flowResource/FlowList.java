package com.tedu.plugin.flowResource;

import com.tedu.base.common.model.DataGrid;
import com.tedu.base.common.utils.ConstantUtil;
import com.tedu.base.common.utils.ContextUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.initial.model.xml.ui.Flow;
import com.tedu.base.initial.model.xml.ui.Param;
import com.tedu.base.initial.model.xml.ui.Procedure;
import com.tedu.base.initial.model.xml.ui.XML;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yangjixin
 * @Description: TODO
 * @date 2018/4/23
 */
public class FlowList implements ILogicReviser {
    @Override
    public FormModel beforeLogic(FormEngineRequest requestObj) {
        return null;
    }

    @Override
    public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {
        FormLogger.info("Transform逻辑后置方法FlowList" + requestObj.getData());
        List<Map<String, String>> resourceList = new ArrayList<Map<String, String >>();

        XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
        String uiName = requestObj.getData().get("uiName").toString();

        List<Flow> flowList = xml.getFlow(uiName);
  
        
        for (Flow flow : flowList) {
            String trigger = flow.getTrigger();
            String resourceName="";
            Map<String, String> row = new HashMap<String, String>();
            row.put("uiName", uiName);
            if (trigger.contains(".")) {
                resourceName = uiName + "." + trigger;
            }
            
            
            List<Procedure> list = flow.getProcedureList();
            String value = null;
            for (Procedure procedure : list) {
            	String name = procedure.getLogic();
            	System.out.println(name);
            	if(name.equals("Transition")){
            		Param param = procedure.getParam("To");
            		value = param.getValue();
            		//System.out.println(value);
            	}
            }
            
            
            
            
            //System.out.println("1");
            row.put("controlName", trigger);
            //System.out.println(trigger);
            row.put("eventName", flow.getEvent());
           // System.out.println(flow.getEvent());
            row.put("resourceName", resourceName);
           // System.out.println(resourceName);
            row.put("transition",value);
            
            resourceList.add(row);
        }
        DataGrid resourceDataGrid = new DataGrid(resourceList);
        resourceDataGrid.setTotal(resourceList.size());
        responseObj.setData(resourceDataGrid);

    }
}
