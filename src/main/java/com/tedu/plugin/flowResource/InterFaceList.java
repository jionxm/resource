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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

/**
 * @author yangjixin
 * @Description: TODO
 * @date 2018/4/23
 */
public class InterFaceList implements ILogicReviser {
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
            if (trigger.contains(".")) {
                resourceName = uiName + "." + trigger;
            }   
            List<Procedure> list = flow.getProcedureList();
            String value = null;
            for (Procedure procedure : list) { 
            	Map<String, String> row1 = new HashMap<String, String>();
            	String logic=procedure.getLogic();
            	System.out.println(procedure.getServer()+":"+procedure.getLogic());
            	if(logic.equals("Close")){
            		if(trigger.equals("null")||trigger.equals("")){
            			String name = flow.getEvent()+"."+procedure.getLogic();
            			String urlname="/api/"+procedure.getLogic().toLowerCase();
            			row1.put("urlName",urlname);
            			row1.put("logiclName",name);
            			resourceList.add(row1);
            	}else{
            		String name = trigger+"."+flow.getEvent()+"."+procedure.getLogic();
            		String urlname="/api/"+procedure.getLogic().toLowerCase();
                	row1.put("urlName",urlname);
                	row1.put("logiclName",name);
                	resourceList.add(row1);
            	}
            	}
            	if(logic.equals("Popup")||logic.equals("Transition")||logic.equals("EncodeId")||
            		procedure.getServer()==""){
            		System.out.println("不是接口");
            	}else{
            		if(procedure.getServer()==null){
            		if(trigger.equals("null")||trigger.equals("")){
                			String name = flow.getEvent()+"."+procedure.getLogic();
                			String urlname="/api/"+procedure.getLogic().toLowerCase();
                			row1.put("urlName",urlname);
                			row1.put("logiclName",name);
                			resourceList.add(row1);
                	}else{
                		String name = trigger+"."+flow.getEvent()+"."+procedure.getLogic();
                		String urlname="/api/"+procedure.getLogic().toLowerCase();
                    	row1.put("urlName",urlname);
                    	row1.put("logiclName",name);
                    	resourceList.add(row1);
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
