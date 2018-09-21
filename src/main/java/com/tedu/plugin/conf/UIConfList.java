package com.tedu.plugin.conf;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicLong;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.tedu.base.common.model.DataGrid;
import com.tedu.base.common.utils.ContextUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.engine.util.FormUtil;
import com.tedu.base.initial.model.xml.ui.Flow;
import com.tedu.base.initial.model.xml.ui.Panel;
import com.tedu.base.initial.model.xml.ui.Param;
import com.tedu.base.initial.model.xml.ui.Procedure;
import com.tedu.base.initial.model.xml.ui.Region;
import com.tedu.base.initial.model.xml.ui.UI;
import com.tedu.base.initial.model.xml.ui.XML;

public class UIConfList implements ILogicReviser{
	private static final String CELL_UI_PANEL = "%s_%s";
	@Override
	public FormModel beforeLogic(FormEngineRequest requestObj) {
		FormLogger.info("Transform.ConfList逻辑插件前置方法");
		return null;
	}

	
	
	@Override
	public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {
		String filter = requestObj.getData()==null?"":ObjectUtils.toString(requestObj.getData().get("lk_name")).toLowerCase();
		XML xml = ContextUtils.getXML();
		List<UI> uiList =  xml.getUi_layer().getUiList();
		List<Map<String,Object>> confList = new ArrayList<>();
		for(UI ui:uiList){
			Map<String,Object> row = new HashMap<>();
			row.put("uiName", ui.getName());
			row.put("title", ui.getTitle());
			
			Map<String,String> panelMap = new HashMap<>();
			Map<String,String> objMap = new HashMap<>();

			for(Panel p:ui.getPanelList()){
				panelMap.put(p.getName(), p.getTitle());
				if(!ObjectUtils.toString(p.getObject()).isEmpty()){
					objMap.put(p.getObject(), "");
				}
			}
			
			final StringBuilder ss1 = new StringBuilder(); 
			panelMap.forEach((k,v)->{
				ss1.append(String.format("%s:%s;\n", k,v));
			});
			row.put("panel", ss1.toString());
			row.put("model", StringUtils.join(objMap.keySet().toArray(),";\n"));

			
			Map<String,String> sqlMap = new HashMap<>();
			Map<String,String> msgMap = new HashMap<>();
			Map<String,String> msgFilter = new HashMap<>();
		    final ConcurrentMap<String, AtomicLong> logicMap = new ConcurrentHashMap<>();

		    
			for(Flow flow:ui.getFlowList()){
				if(!ObjectUtils.toString(flow.getFilter()).isEmpty()){
					msgFilter.put(flow.getFilter(), "");
				}
				for(Procedure p:flow.getProcedureList()){
					logicMap.putIfAbsent(p.getLogic(), new AtomicLong(1));
					logicMap.get(p.getLogic()).incrementAndGet();

					Param pSql = p.getParam(Param.P_SQLId);
					if(pSql!=null){
						sqlMap.put(pSql.getValue(), "");
					}
					Param pMsg = p.getParam(Param.P_Msg);
					if(pMsg!=null){
						msgMap.put(pMsg.getValue(), "");
					}
				}
			}
			final StringBuilder ss2 = new StringBuilder();
			logicMap.forEach((k,v)->{
				ss2.append(String.format("%s:%s;\n", k,v));
			});
			row.put("Logic", ss2.toString());
			row.put("SQL", StringUtils.join(sqlMap.keySet().toArray(),";\n"));
			row.put("Msg", StringUtils.join(msgMap.keySet().toArray(),";\n"));
			row.put("Filter", StringUtils.join(msgFilter.keySet().toArray(),";\n"));
			if((!filter.isEmpty() && FormUtil.toJsonString(row).toLowerCase().indexOf(filter)>=0) || filter.isEmpty()){
				confList.add(row);
			}
		}
		DataGrid dgData = new DataGrid(confList);
		dgData.setTotal(confList.size());
		responseObj.setData(dgData);
	}
	
	public void afterLogicTree(FormEngineRequest requestObj, FormEngineResponse responseObj) {
		FormLogger.info("Transform.ConfList逻辑后置方法"+requestObj.getData());

		XML xml = ContextUtils.getXML();
		List<UI> uiList =  xml.getUi_layer().getUiList();
		List<Map<String,Object>> confList = new ArrayList<>();

		try{
			FormLogger.logBegin("配置校验,错误提示不修正可能引起运行时刻功能错误");
			int i =0;
			addRow("1","","资源树",confList);
			for(UI ui:uiList){
				String uiName = ui.getName();
				addRow(ui.getName(),"1",ui.getTitle()+"_"+ui.getName(),confList);
				List<Flow> flowList = ui.getFlowList();
				
				List<Panel> panelList = ui.getPanelList();
				List<Region> regionList = ui.getLayout().getRegionList();
				addRow(
						String.format(CELL_UI_PANEL, uiName,"PanelList"),
						uiName,
						"Panel列表",
						confList);
				for(Panel p:panelList){
					addRow(
							String.format(CELL_UI_PANEL, uiName,p.getName()),
							String.format(CELL_UI_PANEL, uiName,"PanelList"),
							String.format("%s<%s>", p.getName(),p.getType()),
							confList);
				}
				addRow(
						String.format(CELL_UI_PANEL, uiName,"RegionList"),
						uiName,
						"布局",
						confList);
				for(Region r:regionList){
					addRow(
							r.getLocation(),
							String.format(CELL_UI_PANEL, uiName,"RegionList"),
							r.getLocation(),
							confList);
				}
				addRow(
						String.format(CELL_UI_PANEL, uiName,"FlowList"),
						uiName,
						"事件",
						confList);
				for(Flow flow:flowList){
					String flowId = String.format(CELL_UI_PANEL, flow.getTrigger(),flow.getEvent());
					//flow
					addRow(
							String.format(CELL_UI_PANEL, uiName,flowId),
							String.format(CELL_UI_PANEL, uiName,"FlowList"),
							String.format(CELL_UI_PANEL, flow.getTrigger(), flow.getEvent()),
							confList);
					List<Procedure> procList = flow.getProcedureList();
					for(Procedure proc:procList){
						addRow(
								String.format("%s_%s_%s", uiName,flowId,proc.getLogic()),
								String.format(CELL_UI_PANEL, uiName,flowId),
								String.format(CELL_UI_PANEL, proc.getLogic(),proc.getName()),
								confList);
					}
				}
			}
			List<Map<String,Object>> data = FormUtil.transformToTree(confList, "code", "parent");
			DataGrid dgData = new DataGrid(data);
			dgData.setTotal(confList.size());
			responseObj.setData(dgData);
		}catch(Exception e){
			FormLogger.error("UIConfList:"+ e.getMessage());
		}
	}
	
	private void addRow(String id,String parentId,String text,List<Map<String,Object>> rows){
		Map<String,Object> row = new HashMap<>();
		row.put("code", id);
		row.put("id", id);
		row.put("parent", parentId);
		row.put("text", text);
		rows.add(row);
	}
}
