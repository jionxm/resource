package com.tedu.plugin.conf;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.ObjectUtils;

import com.tedu.base.common.model.DataGrid;
import com.tedu.base.common.utils.DateUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.initial.model.xml.ui.FormConstants;

public class UIProcessor implements ILogicReviser{
	@Override
	public FormModel beforeLogic(FormEngineRequest requestObj) {
		FormLogger.info("Transform逻辑插件前置方法");
		return null;
	}

	@Override
	public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {
		FormLogger.info("Transform逻辑后置方法"+requestObj.getData());
		String filter = requestObj.getData()==null?"":ObjectUtils.toString(requestObj.getData().get("lk_name")).toLowerCase();
		
		String xmlPath = this.getClass().getClassLoader().getResource("/").getPath() + FormConstants.XML_ROOT;
		
		File xmlFolder = new File(xmlPath);
		
		List<File> fileList = new ArrayList<File>(FileUtils.listFiles(xmlFolder, new String[]{"xml"}, true));
		
		List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
		try {
			for(File file:fileList){
				if(!filter.isEmpty() && file.getName().toLowerCase().indexOf(filter)<0){
					continue;//不满足筛选条件
				}
				
				Path filePath = Paths.get(file.getAbsolutePath()); 				
				BasicFileAttributes  fileAttribute = Files.readAttributes(filePath, BasicFileAttributes.class);				
				Map<String,Object> row = new HashMap<String,Object>();
				row.put("filePath", file.getParent());				
				row.put("fileSize", FileUtils.byteCountToDisplaySize(FileUtils.sizeOf(file)));				
				row.put("name", file.getName());				
				row.put("updateTime", DateUtils.getDateToStr(DateUtils.YYMMDD_HHMMSS_24, new Date(file.lastModified())));
				row.put("createTime", DateUtils.getDateToStr(DateUtils.YYMMDD_HHMMSS_24, new Date(fileAttribute.creationTime().toMillis())));
				row.put("type", "表单定义");
				dataList.add(row);
			}
			DataGrid dg = new DataGrid(dataList);
			responseObj.setData(dg);
		} catch (IOException e) {
			FormLogger.info("UIProcessor.afterLogic"+e.getMessage());
		}
	}
}
