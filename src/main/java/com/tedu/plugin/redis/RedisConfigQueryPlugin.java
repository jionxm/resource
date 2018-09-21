package com.tedu.plugin.redis;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.tedu.base.common.model.DataGrid;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.task.SpringUtils;

@Service("redisConfigPlugin")
public class RedisConfigQueryPlugin implements ILogicPlugin {
	@Resource
	FormService formService;
	FormMapper formMapper = SpringUtils.getBean("simpleDao");
	public final Logger log = Logger.getLogger(this.getClass());
	@Resource
    private RedisTemplate<String, Object> redisTemplate;
	public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
		this.redisTemplate = redisTemplate;
	}
	
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		//获取连接对象
		RedisConnection connection=redisTemplate.getConnectionFactory().getConnection();
		log.info("connection:"+connection.toString());
		//获取Redis配置信息
		Properties properties=connection.info();
		log.info("properties:"+properties.toString());
		//获取各参数
		String  version=properties.getProperty("redis_version");
		String  os=properties.getProperty("os");
		String  runId=properties.getProperty("run_id");
		String  archBits=properties.getProperty("arch_bits");
		String  processId=properties.getProperty("process_id");
		String  port=properties.getProperty("tcp_port");
		String  clients=properties.getProperty("connected_clients");
		//将获取的各参数放到map中
		Map<String,Object> configMap=new HashMap<String,Object>();
		configMap.put("version", version);
		configMap.put("os", os);
		configMap.put("runId", runId);
		configMap.put("archBits", archBits);
		configMap.put("processId", processId);
		configMap.put("port", port);
		configMap.put("clients", clients);
		log.info("configMap:"+configMap);
		Map<String,Object> dmap=new HashMap<String,Object>();
		CustomFormModel csmd = new CustomFormModel("","",dmap);
		csmd.setSqlId("redis/DeleteConfig");
		formMapper.saveCustom(csmd); 
		CustomFormModel cfm = new CustomFormModel("","",configMap);
		cfm.setSqlId("redis/RedisConfigInsert");
		formMapper.saveCustom(cfm);
		connection.close();
		return null;
	}

	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,FormEngineResponse responseObj) {
		
	}

}
