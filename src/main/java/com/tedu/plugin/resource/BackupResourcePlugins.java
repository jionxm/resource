package com.tedu.plugin.resource;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tedu.base.common.error.ErrorCode;
import com.tedu.base.common.error.ValidException;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.task.SpringUtils;

@Service("backupResourcePlugins")
public class BackupResourcePlugins implements ILogicPlugin {
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	@Autowired
	FormService formService;
	public final Logger log = Logger.getLogger(this.getClass());

	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		Map<String, Object> data = formModel.getData();
		Object object = formModel.getData().get("resourceFileId");
		log.info(object.toString());
		if (object == null || object.equals("")) {
			List<Map<String, Object>> list = getParams("resource/QryResFile");
			log.info(list);
			String fileIds = "";
			if (list == null || list.size() == 0) {
				throw new ValidException(ErrorCode.INVALIDATE_FORM_DATA, "备份失败", "没有可备份文件！");
			}
			if (list.size() == 1) {
				fileIds = list.get(0).get("fileId").toString();
			} else {
				for (Map<String, Object> map : list) {
					log.info(map);
					String fileId = map.get("fileId").toString();
					if (fileIds.equals("")) {
						fileIds = fileId;
					}else {
						fileIds=fileIds+","+fileId;
					}
					log.info(fileId);
				}
			}
			data.put("resourceFileId", fileIds);
			formModel.setData(data);
			log.info(formModel.getData());
		}
		return null;
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,
			FormEngineResponse responseObj) {
		String id = formModel.getPrimaryFieldValue();
		String fileId = formModel.getData().get("resourceFileId").toString();
		log.info(fileId);
		if (fileId.contains(",")) {
			String[] files = fileId.split(",");
			for (String file : files) {
				saveRecord(id, file);
			}
		} else {
			saveRecord(id, fileId);
		}
		List<Map<String, Object>> list = getParams("resource/QryCopyFile","eq_fileId",fileId);				
		String url=list.get(0).get("url").toString();
		String fileName=url.substring(url.lastIndexOf("/")+1);//取到原文件的名字
		/*url=url.replaceAll("/", "\\\\");//将url的/转换为\*/		
		String srcPathStr=list.get(0).get("path").toString()+fileName;
		copyFile(srcPathStr);
		log.info("文件备份成功");
	}

	public void saveRecord(String id, String fileId) {
		Map<String, Object> data = new HashMap<>();
		CustomFormModel cModel = new CustomFormModel();
		data.put("recordId", id);
		data.put("fileId", fileId);
		cModel.setData(data);
		log.info("insert:" + data);
		cModel.setSqlId("resource/insertRestore");
		formMapper.saveCustom(cModel);
	}

	public List<Map<String, Object>> getParams(String url) {
		QueryPage queryPage = new QueryPage();
		queryPage.setQueryParam(url);
		List<Map<String, Object>> list = formService.queryBySqlId(queryPage);
		return list;
	}
	public List<Map<String, Object>> getParams(String url, String eq, String param) {
		QueryPage queryPage = new QueryPage();
		Map<String, Object> mapParam = new HashMap<>();
		mapParam.put(eq, param);
		queryPage.setParamsByMap(mapParam);
		queryPage.setQueryParam(url);
		// 查询人员并替换新旧表单相关人员信息(姓名)
		List<Map<String, Object>> list = formService.queryBySqlId(queryPage);
		return list;
	}
	/*
	 * 实现文件的拷贝
	 * 
	 * @param srcPathStr 源文件的地址信息
	 * 
	 * @param desPathStr 目标文件的地址信息
	 */
	public static void copyFile(String srcPathStr) {
		// 1.获取源文件的名称
		String desPathStr =srcPathStr.substring(0,srcPathStr.lastIndexOf("\\") + 1) +"copy"
								+srcPathStr.substring(srcPathStr.lastIndexOf("\\") + 1);
		File srcFile = new File(srcPathStr);
		File desFile = new File(desPathStr);
		try {
			if (!desFile.exists()) {
				if (!srcFile.exists()) {
					throw new FileNotFoundException("原文件必须存在");
				} else {
					Files.copy(srcFile.toPath(), desFile.toPath());
				}
			} else {
				System.out.println("已存在同名文件");
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
