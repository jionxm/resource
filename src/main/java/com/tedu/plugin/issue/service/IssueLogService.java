package com.tedu.plugin.issue.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.codec.language.bm.Rule.RPattern;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.repository.config.RepositoryBeanNameGenerator;
import org.springframework.stereotype.Service;

import com.tedu.base.auth.login.model.ShareModel;
import com.tedu.base.common.error.ErrorCode;
import com.tedu.base.common.error.ServiceException;
import com.tedu.base.common.page.QueryPage;
import com.tedu.base.common.utils.DateUtils;
import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.engine.aspect.ILogicPlugin;
import com.tedu.base.engine.dao.FormMapper;
import com.tedu.base.engine.model.CustomFormModel;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.service.FormLogService;
import com.tedu.base.engine.service.FormService;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.engine.util.FormUtil;
import com.tedu.base.msg.SendMessage;
import com.tedu.base.msg.mail.Email;

@Service("issueLogService")
public class IssueLogService implements ILogicPlugin {
	@Resource
	FormLogService formLogService;
	@Resource
	private FormMapper formMapper;
	@Resource
	private FormService formService;
	
	private String sqlTemplate = "issue/saveIssueLog";
	private String sqlIssueInfo = "issue/QryIssueList";

    @Autowired
    SendMessage sendMessage;
	
	@Value("${msg.mail.topic}")
	private String mailTopic;

	@Value("${base.website}")
	private String baseSite;
	private final String NEW = "new";
	private final String MODIFY = "modify";
	
	@Override
	public Object doBefore(FormEngineRequest requestObj, FormModel formModel) {
		if (formModel!=null && StringUtils.isNotEmpty(formModel.getPrimaryFieldValue())) {
			QueryPage queryPage = new QueryPage();
			queryPage.setQueryParam("issue/QryIssueList");
			queryPage.addCondition("issueId", formModel.getPrimaryFieldValue());
			return formMapper.query(queryPage);
		}else{
			return null;
		}
	}

	@Override
	public void doAfter(FormEngineRequest requestObj, FormModel formModel, Object beforeResult,FormEngineResponse responseObj) {
	    //邮箱list
		List<Email> list = new ArrayList<Email>();
		List<Map<String,Object>> mapOldData = null;
		if (StringUtils.isNotEmpty(beforeResult.toString())) {
			mapOldData = (List<Map<String,Object>>)beforeResult;
		}
		QueryPage queryPage = new QueryPage();
		queryPage.setQueryParam("issue/QryIssueList");
		queryPage.addCondition("issueId", formModel.getPrimaryFieldValue());
		List<Map<String,Object>> mapNewData = formMapper.query(queryPage);

		//变更类型
		String type = "";
		//取session中的人员名称
		String name = SessionUtils.getUserInfo().getEmpName();
		Date nowDate = new Date();
		//获取工作项信息
		List<Map<String, Object>> empList = getEmp(mapNewData.get(0));
		
		if(mapOldData==null){
			type = NEW;
			//取当前表单内容
			Map<String, Object> newMap = mapNewData.get(0);
			
			//新建情况下
			formModel.getData().put("id", formModel.getPrimaryFieldValue());
			CustomFormModel cModel = new CustomFormModel();
			Map<String, Object> data = formModel.getData();
			cModel.setData(data);
			cModel.setSqlId(sqlTemplate);
			data.put("type",type);
			data.put("logContent",name+"：增加工作项");
			data.put("createTime",nowDate);
			data.put("createBy",SessionUtils.getUserInfo().getEmpId());
			data.put("updateTime",nowDate);
			data.put("updateBy",SessionUtils.getUserInfo().getEmpId());
			data.put("updateStatus", "open");
			
			//获取email发送邮件
			if(newMap != null){
				//把数据中编号替换成名称
				List<Map<String, Object>> listMap = replace(empList, null,newMap);
				newMap = listMap.get(1);
				//newMap.put("issueStatus", "打开");
				//设置邮件内容
				list.add(getEmail(null,newMap,nowDate));
				try {
					for(Email email:list){
						if(StringUtils.isNotEmpty(email.getAddress())){
							sendMessage.sendMessage(mailTopic, email);
						}
					}
				} catch (Exception e) {
					FormLogger.logFlow("送入邮件发送队列失败," + e.getMessage(), FormLogger.LOG_TYPE_INFO);
					throw new ServiceException(ErrorCode.MAIL_EXCEPTION,"邮件发送失败," + e.getMessage());		
				}
			}
			
			if(formMapper.saveCustom(cModel)!=1){
				FormLogger.logFlow(String.format("记录issueLog失败", formModel.getPrimaryFieldValue()), FormLogger.LOG_TYPE_ERROR);
			}
		} else {
			// 单条更新或者批量更新
			for(Map<String,Object> newmap:mapNewData){
				for(Map<String,Object> oldmap:mapOldData){
					if(newmap.get("id").equals(oldmap.get("id"))){
						
						type = MODIFY;	//变更类型
						boolean flag = false;	//更改状态：true变更、false未变更
						String logContent = "";		//变更内容
						
						//把数据中编号替换成名称
						List<Map<String, Object>> listMap = replace(empList, oldmap,newmap);
						oldmap = listMap.get(0);
						newmap = listMap.get(1);
						
						//设置邮件内容
						list.add(getEmail(oldmap,newmap,nowDate));
						
						formModel.getData().put("id", newmap.get("id"));
						//提交前后表单数据去重
						FormUtil.shrink(oldmap, newmap);
						CustomFormModel cModel = new CustomFormModel();
						Map<String, Object> data = formModel.getData();
						cModel.setData(data);
						cModel.setSqlId(sqlTemplate);
						data.put("history", oldmap);

						
						//记录变更内容
						if (oldmap!=null) {
							if (newmap.get("issueStatus")!=null) {
								logContent += name+"：将状态由\""+ObjectUtils.toString(oldmap.get("issueStatus")) + "\"变更为\"" 
										+ ObjectUtils.toString(newmap.get("issueStatus"))+"\"<br/>";
								flag = true;
							}
							if (newmap.get("reporter")!=null) {
								String rptName = ObjectUtils.toString(oldmap.get("reporterName"));
								logContent +=name+"：将发起人由\""+(StringUtils.isEmpty(rptName)?"无":rptName) + "\"变更为\"" 
										+ ObjectUtils.toString(newmap.get("reporterName"))+"\"<br/>";
								flag = true;
								
							}
							if (newmap.get("assignee")!=null) {
								String asgName = ObjectUtils.toString(oldmap.get("assigneeName"));
								logContent +=name+"：将执行人由\""+(StringUtils.isEmpty(asgName)?"无":asgName) + "\"变更为\"" 
										+ ObjectUtils.toString(newmap.get("assigneeName"))+"\"<br/>";
								flag = true;
							}
							if (newmap.get("testDesignByName")!=null) {
								String tdbName = ObjectUtils.toString(oldmap.get("testDesignByName"));
								logContent +=name+"：将测试设计人由\""+(StringUtils.isEmpty(tdbName)?"无":tdbName) + "\"变更为\"" 
										+ ObjectUtils.toString(newmap.get("testDesignByName"))+"\"<br/>";
								flag = true;
							}
							if (newmap.get("testByName")!=null) {
								String tbName = ObjectUtils.toString(oldmap.get("testByName"));
								logContent +=name+"：将测试执行人由\""+(StringUtils.isEmpty(tbName)?"无":tbName) + "\"变更为\"" 
										+ ObjectUtils.toString(newmap.get("testByName"))+"\"<br/>";
								flag = true;
							}
							
						}
						
						
						//如果有更改则发送邮件并记录日志
						if (flag) {
							data.put("createTime",nowDate);
							data.put("createBy",SessionUtils.getUserInfo().getEmpId());
							data.put("updateTime",nowDate);
							data.put("updateBy",SessionUtils.getUserInfo().getEmpId());
							data.put("updateStatus", newmap.get("updateStatus"));
							data.put("type",type);
							data.put("logContent",logContent);
							
							try {
								for(Email email:list){
									if(StringUtils.isNotEmpty(email.getAddress())){
										sendMessage.sendMessage(mailTopic, email);
									}
								}
								list.clear();
							} catch (Exception e) {
								FormLogger.logFlow("送入邮件发送队列失败," + e.getMessage(), FormLogger.LOG_TYPE_INFO);
								throw new ServiceException(ErrorCode.MAIL_EXCEPTION,"邮件发送失败," + e.getMessage());		
							}
							
							if(formMapper.saveCustom(cModel)!=1){
								FormLogger.logFlow(String.format("记录issueLog失败", formModel.getPrimaryFieldValue()), FormLogger.LOG_TYPE_ERROR);
							}
						}
						
						break;
					}
				}
			}
		}

	}
	
	/**
	 * 
	 * @Description: 封装邮件内容
	 * @author: gaolu
	 * @date: 2017年12月11日 下午2:11:26  
	 * @param:      
	 * @return: void
	 */
	private Email getEmail(Map<String,Object> oldmap,Map<String,Object> newmap,Date date){
		String issueId = ObjectUtils.toString(newmap.get("id"));
		ShareModel model = new ShareModel("工作项详情","frmIssueView",issueId);
		String url = model.toUrl(baseSite);
		String issue = String.format("工作项ID：<a href='%s'>%s</a><br/>", url,issueId);
		Email mail = new Email();
		String createTime = ObjectUtils.toString(newmap.get("createTime"));

		StringBuffer Content = new StringBuffer();
		Content.append("<div>");
		Content.append(issue);
		Content.append("项目："+ObjectUtils.toString(newmap.get("projName"))+"<br/>");
		Content.append("操作人："+ObjectUtils.toString(SessionUtils.getUserInfo().getEmpName()+"<br/>"));
		Content.append("操作时间："+DateUtils.getDateToStr("yyyy-MM-dd HH:mm:ss",date)+"<br/>");
		//Content.append("迭代:"+ObjectUtils.toString(newmap.get("sprintId"))+"<br/>");
		Content.append("<table  border='1'>");
		Content.append("<tr> <th>内容</th> <th>变更前</th> <th>变更后</th> </tr>");
		if (oldmap != null) {
			String color = ObjectUtils.toString(oldmap.get("title")).equals(ObjectUtils.toString(newmap.get("title")))?">":" style='color:red'>";
			Content.append("<tr> <td>标题</td> <td>"+ObjectUtils.toString(oldmap.get("title"))+"</td> <td"
							+color+ObjectUtils.toString(newmap.get("title"))+"</td></tr>");	
			
			color = ObjectUtils.toString(oldmap.get("sprintName")).equals(ObjectUtils.toString(newmap.get("sprintName")))?">":" style='color:red'>";
			Content.append("<tr> <td>迭代</td> <td>"+ObjectUtils.toString(oldmap.get("sprintName"))+"</td> <td"
							+color+ObjectUtils.toString(newmap.get("sprintName"))+"</td></tr>");	
			color = ObjectUtils.toString(oldmap.get("issueType")).equals(ObjectUtils.toString(newmap.get("issueType")))?">":" style='color:red'>";
			Content.append("<tr> <td>类型</td> <td>"+ObjectUtils.toString(oldmap.get("issueType"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("issueType"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("issueStatus")).equals(ObjectUtils.toString(newmap.get("issueStatus")))?">":" style='color:red'>";
			Content.append("<tr> <td>状态</td> <td>"+ObjectUtils.toString(oldmap.get("issueStatus"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("issueStatus"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("remark")).equals(ObjectUtils.toString(newmap.get("remark")))?">":"style='color:red'>";
			Content.append("<tr> <td>描述</td> <td>"+ObjectUtils.toString(oldmap.get("remark"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("remark"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("priority")).equals(ObjectUtils.toString(newmap.get("priority")))?">":"style='color:red'>";
			Content.append("<tr> <td>重要程度</td> <td>"+ObjectUtils.toString(oldmap.get("priority"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("priority"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("reporterName")).equals(ObjectUtils.toString(newmap.get("reporterName")))?">":" style='color:red'>";
			Content.append("<tr> <td>发起人</td> <td>"+ObjectUtils.toString(oldmap.get("reporterName"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("reporterName"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("createTime")).equals(ObjectUtils.toString(newmap.get("createTime")))?">":" style='color:red'>";
			Content.append("<tr> <td>创建时间</td> <td>"+ObjectUtils.toString(oldmap.get("createTime")).substring(0,createTime.length()-2)+"</td> <td"
					+color+createTime.substring(0,createTime.length()-2)+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("assigneeName")).equals(ObjectUtils.toString(newmap.get("assigneeName")))?">":" style='color:red'>";
			Content.append("<tr> <td>处理人</td> <td>"+ObjectUtils.toString(oldmap.get("assigneeName"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("assigneeName"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("testDesignByName")).equals(ObjectUtils.toString(newmap.get("testDesignByName")))?">":" style='color:red'>";
			Content.append("<tr> <td>测试设计人</td> <td>"+ObjectUtils.toString(oldmap.get("testDesignByName"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("testDesignByName"))+"</td></tr>");
			
			color = ObjectUtils.toString(oldmap.get("testByName")).equals(ObjectUtils.toString(newmap.get("testByName")))?">":" style='color:red'>";
			Content.append("<tr> <td>测试执行人</td> <td>"+ObjectUtils.toString(oldmap.get("testByName"))+"</td> <td"
					+color+ObjectUtils.toString(newmap.get("testByName"))+"</td></tr>");
			mail.setSubject("工作项"+issueId+"已更改");
		}else{
			Content.append("<tr> <td>标题</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("title"))+"</td></tr>");
			Content.append("<tr> <td>迭代</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("sprintName"))+"</td></tr>");
			Content.append("<tr> <td>类型</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("issueType"))+"</td></tr>");
			Content.append("<tr> <td>状态</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("issueStatus"))+"</td></tr>");
			Content.append("<tr> <td>描述</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("remark"))+"</td></tr>");
			Content.append("<tr> <td>重要程度</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("priority"))+"</td></tr>");
			Content.append("<tr> <td>发起人</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("reporterName"))+"</td></tr>");
			Content.append("<tr> <td>创建时间</td> <td></td> <td>"+createTime.substring(0,createTime.length()-2)+"</td></tr>");
			Content.append("<tr> <td>处理人</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("assigneeName"))+"</td></tr>");
			Content.append("<tr> <td>测试设计人</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("testDesignByName"))+"</td></tr>");
			Content.append("<tr> <td>测试执行人</td> <td></td> <td>"+ObjectUtils.toString(newmap.get("testByName"))+"</td></tr>");
			mail.setSubject("工作项"+issueId+"已新建");
		}
		Content.append("</table>");
		Content.append("</div>");
		mail.setAddress(ObjectUtils.toString(newmap.get("email")));
		mail.setContent(Content.toString());
		mail.setReceiveName(ObjectUtils.toString(newmap.get("assigneeName")));
		mail.setSentDate(new Date());
		return mail;
	}
	
	/**
	 * 
	 * @Description: 获取工作项相关信息
	 * @author: gaolu
	 * @date: 2017年12月11日 下午2:12:39  
	 * @param:      
	 * @return: void
	 */
	public List<Map<String, Object>> getEmp(Map<String,Object> newmap){
		QueryPage queryPage = new QueryPage();
		Map<String, Object> mapParam = new HashMap<>();
		mapParam.put("eq_issueId", newmap.get("id"));
		queryPage.setParamsByMap(mapParam);
		queryPage.setQueryParam(sqlIssueInfo);
		//查询人员并替换新旧表单相关人员信息(姓名)
		List<Map<String,Object>> issueInfo = formService.queryBySqlId(queryPage);
		return issueInfo;
	}
	
	/**
	 * 
	 * @Description: 替换数据中的人员、状态、重要程度等名称
	 * @author: gaolu
	 * @date: 2017年12月11日 下午4:20:16  
	 * @param:      
	 * @return: List<Map<String,Object>>
	 */
	public List<Map<String, Object>> replace(List<Map<String, Object>> issueInfo,Map<String,Object> oldmap,Map<String,Object> newmap){
		
		List<Map<String, Object>> list = new ArrayList<>();
		
		//工作项状态
	    Map<String,String> issStatus = new HashMap<>();	
	    issStatus.put("cancel", "已取消");
	    issStatus.put("test", "测试中");
	    issStatus.put("open", "打开");
	    issStatus.put("resolve", "已解决");
	    issStatus.put("workin", "处理中");
	    issStatus.put("close", "已关闭");
	    issStatus.put("reopen", "重新打开");
	    //工作项重要程度
	    Map<String,String> issPriority = new HashMap<String,String>();
	    issPriority.put("blocker", "严重");
	    issPriority.put("critical", "重要");
	    issPriority.put("major", "一般");
	    issPriority.put("minor", "轻微");
	    //工作项类型
	    Map<String,String> issType = new HashMap<String,String>();
	    issType.put("feature", "新需求");
	    issType.put("improvement", "改进");
	    issType.put("bug", "缺陷");
	    issType.put("task", "任务");
	    issType.put("risk", "风险");
	    
	    
	    
	    //增加邮箱、迭代字段
	    if(issueInfo != null ){
    		if(newmap.get("assignee") != null && 
	    		Integer.parseInt(ObjectUtils.toString(newmap.get("assignee"))) !=  SessionUtils.getUserInfo().getEmpId() ){
    			newmap.put("email",issueInfo.get(0).get("assigneeEmail"));
	    	}
	    	newmap.put("sprintName",issueInfo.get(0).get("sprintName"));
	    }
		
		
		//将工作项类型、状态和重要程度转换成中文名称
		if (oldmap != null) {
			oldmap.put("issueStatus", issStatus.get(oldmap.get("issueStatus")));
			oldmap.put("issueType",issType.get(oldmap.get("issueType")));
			oldmap.put("priority", issPriority.get(oldmap.get("priority")));
			oldmap.put("updateStatus", oldmap.get("issueStatus")); //记录更新前状态
		}
		newmap.put("issueType",issType.get(newmap.get("issueType")));
		newmap.put("priority", issPriority.get(newmap.get("priority")));
		newmap.put("updateStatus", newmap.get("issueStatus")); //记录更新后状态
		newmap.put("issueStatus", issStatus.get(newmap.get("issueStatus")));

		list.add(oldmap);
		list.add(newmap);
		
		return list;
	}
}
