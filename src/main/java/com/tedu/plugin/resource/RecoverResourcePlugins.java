package com.tedu.plugin.resource;

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

@Service("recoverResourcePlugins")
public class RecoverResourcePlugins implements ILogicPlugin {
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
}
