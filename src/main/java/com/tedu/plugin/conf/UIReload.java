package com.tedu.plugin.conf;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.util.FormConfiguration;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.engine.util.FormValidator;

public class UIReload implements ILogicReviser{
	@Override
	public FormModel beforeLogic(FormEngineRequest requestObj) {
		return null;
	}

	@Override
	public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {
		FormLogger.info("Transform.plugin.UIReload逻辑后置方法");
		FormLogger.info("Transform.plugin.UIReload逻辑插件前置方法");
		List<String> msg = new ArrayList<String>();
		responseObj.setMsg("加载成功");
		responseObj.setCode("0");
		try {
			FormConfiguration.refreshXML();
			msg.add("配置加载成功==>");
			FormValidator.validate();
			msg.add("配置校验完毕，校验详情请查看后台日志");
		} catch (Exception e) {
			SessionUtils.removeAttrbute("xml");
			msg.add("异常:" + e.getMessage());
			msg.add("配置加载失败,请检查!");
			responseObj.setCode("1");
		}
		responseObj.setData(null);
		responseObj.setMsg(StringUtils.join(msg.toArray(),";"));
//		return "common/formEngineResponseView";				
	}
}
