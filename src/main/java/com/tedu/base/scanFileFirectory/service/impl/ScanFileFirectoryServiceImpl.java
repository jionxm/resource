package com.tedu.base.scanFileFirectory.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.service.FormLogService;
import com.tedu.base.engine.service.FormService;
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
	@Override
	public void gainScanFileFirectory() {
		String path = "E:\\copyfiles";
		for (Object filePath : scanFilesWithRecursion(path)) {
			String srcPath = filePath.toString();
			String srcName=srcPath.substring(srcPath.lastIndexOf("\\")+1);
			saveRecord(srcPath, srcName);
		}
		log.info("一共插入"+filesSum+"个文件");
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
								filesSum++;
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

