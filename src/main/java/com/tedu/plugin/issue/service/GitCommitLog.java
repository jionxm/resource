package com.tedu.plugin.issue.service;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


import org.apache.commons.lang.StringUtils;
import org.apache.xmlbeans.impl.jam.mutable.MPackage;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.task.SpringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 记录个git提交记录
 * @author gaolu
 *
 */
@Controller
public class GitCommitLog{
	
	private FormMapper formMapper = SpringUtils.getBean("simpleDao");
	private String pushSql = "git/insertPushLog";
	private String commitSql = "git/insertCommitLog";
	
	@RequestMapping("saveLog")	
	@ResponseBody
	public String saveLog(@RequestBody GitPush jPush){
		
		if (jPush!=null) {
			//system(jPush);
			//入库
			CustomFormModel cModel = new CustomFormModel();
			//封装入库的数据
			List<Map<String, Object>> commits = (List<Map<String,Object>>)jPush.getCommits();
			
			if (commits!=null) {
				//获取commit数据并保存
				for(int i=0,j=commits.size(); i < j; i++){
					cModel.setSqlId(commitSql);
					cModel.setData(commitData(commits.get(i), jPush));
					insert(cModel);
					//System.out.println("into this commit");
				}
			}
			
			//获取push数据并保存
			cModel.setSqlId(pushSql);
			cModel.setData(pushData(jPush));
			insert(cModel);
			//System.out.println("into this push");
		}
		//System.out.println("end this method");
		return "success";
	}

	/**
	 * 
	 * @Description: 数据库中新增git数据
	 * @author: gaolu
	 * @date: 2018年4月23日 下午5:44:04  
	 * @param:      
	 * @return: Boolean
	 */
	private void insert(CustomFormModel cModel) {
		if (cModel != null) {
			int n = formMapper.saveCustom(cModel);
			if (n != 1) {
				FormLogger.logFlow(String.format("记录git日志失败"), FormLogger.LOG_TYPE_ERROR);
			}
		}
	}
	
	/**
	 * 
	 * @Description: 创建push数据集合
	 * @author: gaolu
	 * @date: 2018年4月24日 上午11:47:00  
	 * @param:      
	 * @return: Map<String,Object>
	 */
	private Map<String, Object> pushData(GitPush jPush){
		Map<String, Object> pushData = new HashMap<>();
		pushData.put("before", jPush.getBefore());
		pushData.put("after", jPush.getAfter());
		pushData.put("ref", jPush.getRef());
		pushData.put("user_name", jPush.getUser_name());
		pushData.put("user_email", jPush.getUser_email());
		pushData.put("total_commits_count", jPush.getTotal_commits_count());
		pushData.put("repository", jPush.getRepository().toString());
		return pushData;
	}
	
	/**
	 * 
	 * @Description: 创建commit数据集合
	 * @author: gaolu
	 * @date: 2018年4月24日 上午11:47:00  
	 * @param:      
	 * @return: Map<String,Object>
	 */
	private Map<String, Object> commitData(Map<String, Object> jPush, GitPush p){
		Map<String, Object> commitData = new HashMap<>();
		try {
			commitData.put("c_id", jPush.get("id"));
			commitData.put("push_sha", p.getAfter());
			commitData.put("issue_id", getIdByMsg(jPush.get("message")));
			commitData.put("message", jPush.get("message"));
			commitData.put("url", jPush.get("url"));
			commitData.put("name", JSONObject.fromObject(jPush.get("author")).getString("name"));
			commitData.put("email", JSONObject.fromObject(jPush.get("author")).getString("email"));
			commitData.put("timestamp", transformDate(jPush.get("timestamp").toString()));
		} catch (Exception e) {
			FormLogger.logFlow(String.format("记录git日志失败,时间转换失败")+jPush.get("timestamp"), FormLogger.LOG_TYPE_ERROR);
		}
		return commitData;
	}	
	
	private Object getIdByMsg(Object object) {
		if(object == null){
			return 0L;
		}
		try {
			String msg = object.toString();
			int length = msg.length();
			int startidx = msg.indexOf("#");
			int endidx = length;
			for(int i = startidx+1 ; i < length; i++){
				if (!Character.isDigit(msg.charAt(i))) {
					endidx = i;
					break;
				}
			}
			msg = msg.substring(startidx+1, endidx);
			return StringUtils.isBlank(msg)?0L:Long.parseLong(msg);
		} catch (Exception e) {
			e.printStackTrace();
			FormLogger.logFlow(String.format("记录git提交记录失败,获取工作项ID失败"), FormLogger.LOG_TYPE_ERROR);
		}	
		return 0L;
	}
	
	public static void main(String[] args) {
		System.out.println(new GitCommitLog().getIdByMsg("fix #页面样式"));
	}

	/**
	 * 
	 * @Description: UTC通用标准时转换成东8区时间yyyy-MM-dd HH:mm:ss
	 * @author: gaolu
	 * @date: 2018年4月24日 下午2:46:07  
	 * @param:      
	 * @return: String
	 */
	private String transformDate(String timeStr) throws Exception{
		String date = null;
		
		//git推送来的时间有错误不是标准时间格式，需要在加毫秒单位
		int i = timeStr.indexOf("+");
		StringBuilder sb = new StringBuilder(timeStr);
		timeStr = sb.insert(i, ".000").toString();
		
		//日期转换
		if (StringUtils.isNotEmpty(timeStr)) {
			 DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");  //yyyy-MM-dd'T'HH:mm:ss.SSSZ
			 Date  date0 = df.parse(timeStr);
			 SimpleDateFormat df1 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK);
			 Date date1 =  df1.parse(date0.toString());
			 DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			 date = df2.format(date1);
		}
		return date;
	}
	
	/**
	 * 
	 * @Description: 测试数据
	 * @author: gaolu
	 * @date: 2018年4月24日 上午10:03:17  
	 * @param:      
	 * @return: String	
	 */
	private String testData(){
		String Data = "{\"object_kind\":\"push\",\"before\":\"95790bf891e76fee5e1747ab589903a6a1f80f22\",\"after\":\"da1560886d4f094c3e6c9ef40349f7d38b5d27d7\",\"ref\":\"refs/heads/master\",\"checkout_sha\":\"da1560886d4f094c3e6c9ef40349f7d38b5d27d7\",\"user_id\":4,\"user_name\":\"JohnSmith\",\"user_email\":\"john@example.com\",\"user_avatar\":\"https://s.gravatar.com/avatar/d4c74594d841139328695756648b6bd6?s=8://s.gravatar.com/avatar/d4c74594d841139328695756648b6bd6?s=80\",\"project_id\":15,\"project\":{\"name\":\"Diaspora\",\"description\":\"\",\"web_url\":\"http://example.com/mike/diaspora\",\"avatar_url\":null,\"git_ssh_url\":\"git@example.com:mike/diaspora.git\",\"git_http_url\":\"http://example.com/mike/diaspora.git\",\"namespace\":\"Mike\",\"visibility_level\":0,\"path_with_namespace\":\"mike/diaspora\",\"default_branch\":\"master\",\"homepage\":\"http://example.com/mike/diaspora\",\"url\":\"git@example.com:mike/diaspora.git\",\"ssh_url\":\"git@example.com:mike/diaspora.git\",\"http_url\":\"http://example.com/mike/diaspora.git\"},\"repository\":{\"name\":\"Diaspora\",\"url\":\"git@example.com:mike/diaspora.git\",\"description\":\"\",\"homepage\":\"http://example.com/mike/diaspora\",\"git_http_url\":\"http://example.com/mike/diaspora.git\",\"git_ssh_url\":\"git@example.com:mike/diaspora.git\",\"visibility_level\":0},\"commits\":[{\"id\":\"b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327\",\"message\":\"UpdateCatalantranslationtoe38cb41\",\"timestamp\":\"2011-12-12T14:27:31+02:00\",\"url\":\"http://example.com/mike/diaspora/commit/b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327\",\"author\":{\"name\":\"JordiMallach\",\"email\":\"jordi@softcatala.org\"},\"added\":[\"CHANGELOG\"],\"modified\":[\"app/controller/application.rb\"],\"removed\":[]},{\"id\":\"da1560886d4f094c3e6c9ef40349f7d38b5d27d7\",\"message\":\"fixedreadme\",\"timestamp\":\"2012-01-03T23:36:29+02:00\",\"url\":\"http://example.com/mike/diaspora/commit/da1560886d4f094c3e6c9ef40349f7d38b5d27d7\",\"author\":{\"name\":\"GitLabdevuser\",\"email\":\"gitlabdev@dv6700.(none)\"},\"added\":[\"CHANGELOG\"],\"modified\":[\"app/controller/application.rb\"],\"removed\":[]}],\"total_commits_count\":4}";
		return Data;
	}
	
	private void system(GitPush jPush){
		System.out.println("after:"+jPush.getAfter().toString());
		System.out.println("before:"+jPush.getBefore().toString());
		System.out.println("checkout:"+jPush.getCheckout_sha().toString());
		System.out.println("commits:"+jPush.getCommits().toString());
		System.out.println("commitsCount:"+jPush.getTotal_commits_count().toString());
	}
}
