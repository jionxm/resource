package com.tedu.plugin.redis;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

@Service("redisPlugin")
public class RedisQueryPlugin implements ILogicPlugin {
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
		RedisSerializer<String> keySerializer=redisTemplate.getStringSerializer();
		log.info("keySerializer:"+keySerializer);
		//通过连接对象获取Redis所有key
		Set<byte[]> keyset=connection.keys("*".getBytes());
		String redisKey;
		String redisValue;
		Map<String,Object> dmap=new HashMap<String,Object>();
		CustomFormModel cfd = new CustomFormModel("","",dmap);
    	cfd.setSqlId("redis/DeleteRedis");
    	formMapper.saveCustom(cfd);
		//遍历所有key，将key和value放入map中
    	int i=0;
    	if(!keyset.isEmpty()){
    		for(byte[] key:keyset){
  			  Map<String, Object> map=new HashMap<String,Object>();
  			  redisKey=new String(key);
  			  redisValue=keySerializer.deserialize(connection.get(key));
  			  log.info("key:"+redisKey+"value:"+redisValue);
  			  if(redisValue.length()>=2000){
  				  redisValue=redisValue.substring(0, 1999);
  			  }
  			  map.put("redisKey", redisKey);
  			  map.put("redisValue", redisValue);
  			  i++;
  			  log.info("map"+i+map);
  			  //将map中的键值对插入到数据库中
  			  CustomFormModel csmd = new CustomFormModel("","",map);
  			  csmd.setSqlId("redis/RedisInsert");
  			  formMapper.saveCustom(csmd);
  		  }
    	}
    	connection.close();
		return null;
	}

	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,FormEngineResponse responseObj) {
		
	}

}

