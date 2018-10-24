package com.tedu.base.scanFileFirectory.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.service.FormLogService;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.util.FormUtil;
import com.tedu.base.scanFileFirectory.service.ScanFileFirectoryService;
import com.tedu.base.task.SpringUtils;

/**
 * 文件目录获取插入到数据表
 * @author Chenjun
 *
 */
@Service("ScanFileFirectoryService")
public class ScanFileFirectoryServiceImpl implements ScanFileFirectoryService {
	@Resource
	private FormMapper formMapper;
	@Autowired
	FormService formService;
	public final Logger log = Logger.getLogger(this.getClass());
	public static final String separator=File.separator; 
	@Override
	public void gainScanFileFirectory() {
		String path = separator+"opt"+separator+"file"+separator+"AI"+separator+"data";		
		List<Map<String,Object>> mapNewData =new ArrayList<Map<String, Object>>();
		for (Object filePath : scanFilesWithRecursion(path)) {
			Map<String, Object> map = new HashMap<>();
			String srcPath = filePath.toString();
			String srcName=srcPath.substring(srcPath.lastIndexOf(separator)+1);
			map.put("name",srcName);
			map.put("path",srcPath);
			mapNewData.add(map);
		}
		List<Map<String,Object>> mapOldData = qryRecord("resource/QryFilesData");
		log.info("查询出"+mapOldData.size()+"个原文件");
		for(Map<String,Object> newmap:mapNewData){
			boolean flag = false;
			if(null == mapOldData || mapOldData.size() ==0 ) {
				flag =true;
			}else {
			for(Map<String,Object> oldmap:mapOldData){
				FormUtil.shrink(oldmap, newmap);
				if(newmap.size()==0) {
					log.info("数据重复不插入");
					flag=false;
					break;
				}else {
					flag=true;
				}
					}
						}
			if(flag==true) {
				String srcPath = newmap.get("path").toString();				
				String srcName=srcPath.substring(srcPath.lastIndexOf(separator)+1);
				saveRecord(srcPath, srcName);
				filesSum++;
			}
		
		}
		scanFiles.clear();//清理存扫描目录的集合
		log.info("一共新插入"+filesSum+"个文件");
	}
	private static ArrayList<Object> scanFiles = new ArrayList<Object>();
	private static int filesSum=0;
	public static ArrayList<Object> scanFilesWithRecursion(String folderPath){
		ArrayList<String> dirctorys = new ArrayList<String>();
		File directory = new File(folderPath);
		try {
			if (!directory.isDirectory()) {
				throw new ScanFilesException("当前文件夹下不存在文件或文件夹"+directory.toPath().toString());
			}else {
				File[] filelist = directory.listFiles();
				/** 如果当前是文件夹，进入递归扫描文件夹 **/
				if (filelist == null || filelist.length == 0) {
					throw new ScanFilesException("当前文件夹下不存在文件或文件夹"+directory.toPath().toString());
				}else{			
					for (int i = 0; i < filelist.length; i++) {
							if (filelist[i].isDirectory()) {
								dirctorys.add(filelist[i].getAbsolutePath());
								/** 递归扫描下面的文件夹 **/
								scanFilesWithRecursion(filelist[i].getAbsolutePath());
							}
							/** 非文件夹 **/
							else {
								scanFiles.add(filelist[i].getAbsolutePath());
							}
						}
					}

			}
		} catch (ScanFilesException e) {
			System.out.println(e.getMessage());
		}catch (Exception e) {
			e.printStackTrace();
		}	
		return scanFiles;
	}
	public List<Map<String, Object>> getParam(String url, Map<String, Object> map) {
		QueryPage queryPage = new QueryPage();
		queryPage.setParamsByMap(map);
		queryPage.setQueryParam(url);
		// 查询人员并替换新旧表单相关人员信息(姓名)
		List<Map<String, Object>> list = formService.queryBySqlId(queryPage);
		return list;
	}
	public void saveRecord(String srcPath,String srcName) {
		Map<String, Object> data = new HashMap<>();
		CustomFormModel cModel = new CustomFormModel();
		data.put("srcName",srcName);
		data.put("srcPath",srcPath);
		cModel.setData(data);
		cModel.setSqlId("resource/InsertResource");
		formMapper.saveCustom(cModel);
	}
	public List<Map<String, Object>> qryRecord(String path) {
		QueryPage queryPage = new QueryPage();
		queryPage.setQueryParam(path);
		List<Map<String,Object>> mapData = formMapper.query(queryPage);
		return mapData;
	}
}
//定义一个文件夹或者文件找不到的异常类
class ScanFilesException extends Exception {
	// 无参构造方法
	public ScanFilesException() {
		super();
	}

	// 有参的构造方法
	public ScanFilesException(String message) {
		super(message);

	}
}

