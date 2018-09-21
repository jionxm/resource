package com.tedu.plugin.workflow;

import com.tedu.base.common.model.DataGrid;
import com.tedu.base.common.utils.ConstantUtil;
import com.tedu.base.common.utils.ContextUtils;
import com.tedu.base.common.utils.SessionUtils;
import com.tedu.base.engine.aspect.ILogicReviser;
import com.tedu.base.engine.model.FormEngineRequest;
import com.tedu.base.engine.model.FormEngineResponse;
import com.tedu.base.engine.model.FormModel;
import com.tedu.base.engine.util.FormLogger;
import com.tedu.base.initial.model.xml.ui.XML;
import com.tedu.base.task.SpringUtils;
import com.tedu.base.workflow.service.WorkflowUserService;
import com.tedu.base.workflow.util.WorkflowConstant;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.*;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author yangjixin
 * @Description: 工作流列表显示
 * @date 2017/11/16
 */

public class WorkflowList implements ILogicReviser {


    HistoryService historyService = SpringUtils.getBean("historyService");

    TaskService taskService = SpringUtils.getBean("taskService");

    IdentityService identityService = SpringUtils.getBean("identityService");

    RuntimeService runtimeService = SpringUtils.getBean("runtimeService");

    WorkflowUserService workflowUserService = SpringUtils.getBean("workflowUserService");

    public FormModel beforeLogic(FormEngineRequest requestObj) {
        return null;
    }

    @Override
    public void afterLogic(FormEngineRequest requestObj, FormEngineResponse responseObj) {

        String userId = SessionUtils.getUserInfo().getUserId() + "";

        FormLogger.info("Transform逻辑后置方法WorkflowList" + requestObj.getData());
        List<Map<String, Object>> undoTaskDataList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> doneTaskDataList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> completeTaskDataList = new ArrayList<Map<String, Object>>();

            if (requestObj.getData().get("assignee") == null) {
                //全部待办
                TaskQuery taskQuery = taskService.createTaskQuery().orderByTaskCreateTime().desc();
                List<Task> undoTaskList = taskQuery.active().list();

                //统一添加处理人
                List<String> userIds = new ArrayList<>();

                for (Task task : undoTaskList) {
                    Map<String, Object> row = new HashMap<String, Object>();
                    String uiName = taskService.getVariables(task.getId()).get("viewUrl").toString();
                    String businessKey = runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult().getBusinessKey();
                    row.put("id", businessKey.split("_")[1]);
                    row.put("viewUrl", uiName);
                    XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
                    row.put("toTitle", xml.getUiByName(uiName).getTitle());
                    row.put("title", task.getName());
                    row.put("createTime", task.getCreateTime());
                    row.put("assignee","");
                    undoTaskDataList.add(row);
                }
                HistoricProcessInstanceQuery historicProcessInstanceQuery = historyService.createHistoricProcessInstanceQuery();
                historicProcessInstanceQuery.orderByProcessInstanceStartTime().desc();
                List<HistoricProcessInstance> completeTaskList = historicProcessInstanceQuery.list();
                for (HistoricProcessInstance historicProcessInstance : completeTaskList) {
                    String procId = historicProcessInstance.getId();
                    HistoricTaskInstanceQuery historicTaskInstanceQuery = historyService.createHistoricTaskInstanceQuery();
                    historicTaskInstanceQuery.orderByHistoricTaskInstanceEndTime().desc();
                    List<HistoricTaskInstance> historicTaskInstances = historicTaskInstanceQuery.processInstanceId(procId).list();
                    HistoricTaskInstance historicTaskInstance = historicTaskInstances.get(0);
                    if (historicTaskInstance.getAssignee() != null) {
                        if (!historicTaskInstance.getAssignee().equals(WorkflowConstant.ASSIGNEE)) {
                            userIds.add(historicTaskInstance.getAssignee());
                        }
                    }
                }

                Map<String, String> userMap1 = workflowUserService.getNamesByIds(userIds);

                for (HistoricProcessInstance historicProcessInstance : completeTaskList) {
                    String procId = historicProcessInstance.getId();
                    //完成事项
                    HistoricVariableInstance variableInstanceEntities = historyService.createHistoricVariableInstanceQuery().processInstanceId(procId).variableName("viewUrl").singleResult();
                    HistoricTaskInstanceQuery historicTaskInstanceQuery = historyService.createHistoricTaskInstanceQuery();
                    historicTaskInstanceQuery.orderByHistoricTaskInstanceEndTime().desc();
                    List<HistoricTaskInstance> historicTaskInstances = historicTaskInstanceQuery.processInstanceId(procId).list();
                    HistoricTaskInstance historicTaskInstance = historicTaskInstances.get(0);
                    String assignName = "";
                    if (historicTaskInstance.getAssignee() != null && historicTaskInstance.getAssignee().equals(WorkflowConstant.ASSIGNEE)) {
                        assignName = WorkflowConstant.ASSIGNEE_NAME;
                    } else {
                        assignName = userMap1.get(historicTaskInstance.getAssignee());
                    }
                    if(assignName!=null&&!assignName.equals("")) {
                        try {
                            Map<String, Object> row = new HashMap<String, Object>();
                            String id = historicProcessInstance.getBusinessKey().split("_")[1];
                            row.put("id", id);

                            row.put("title", id + "-" + historicProcessInstance.getProcessDefinitionName() + "-" + historicTaskInstance.getName());
                            row.put("createTime", historicProcessInstance.getStartTime());


                            String uiName = variableInstanceEntities.getValue().toString();
                            row.put("viewUrl", uiName);
                            XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
                            row.put("toTitle", xml.getUiByName(uiName).getTitle());

                            row.put("assignee", userMap1 != null ? assignName : "");
                            if (historicProcessInstance.getEndTime() == null) {
                                doneTaskDataList.add(row);
                            } else {
                                completeTaskDataList.add(row);
                            }
                        }catch (Exception e){
                            System.out.println(procId);
                        }
                    }

                }

            } else {
                //查询Session中用户的任务
                TaskQuery taskQuery = taskService.createTaskQuery().orderByTaskCreateTime().desc();
                List<Task> undoTaskList = taskQuery.active().taskCandidateOrAssigned(userId).list();
                for (Task task : undoTaskList) {

                    String uiName = taskService.getVariables(task.getId()).get("viewUrl").toString();
                    String businessKey = runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult().getBusinessKey();

                    Map<String, Object> row = new HashMap<String, Object>();
                    row.put("id", businessKey.split("_")[1]);
                    row.put("viewUrl", uiName);
                    XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
                    row.put("toTitle", xml.getUiByName(uiName).getTitle());
                    row.put("title", task.getName());
                    row.put("createTime", task.getCreateTime());
                    row.put("assignee", task.getAssignee());
                    undoTaskDataList.add(row);
                }

                HistoricTaskInstanceQuery historicTaskInstanceQuery = historyService.createHistoricTaskInstanceQuery();
                historicTaskInstanceQuery.orderByHistoricTaskInstanceEndTime().desc();
                HistoricProcessInstanceQuery historicProcessInstanceQuery = historyService.createHistoricProcessInstanceQuery();

                List<HistoricTaskInstance> doneTaskList = historicTaskInstanceQuery.taskAssignee(userId).list();
                List<String> userIds = new ArrayList<>();
                for (HistoricTaskInstance historicTaskInstance : doneTaskList) {
                    if (historicTaskInstance.getAssignee() != null) {
                        if (!historicTaskInstance.getAssignee().equals(WorkflowConstant.ASSIGNEE)) {
                            userIds.add(historicTaskInstance.getAssignee());
                        }
                    }
                }
                String assignee = "";
                if (userIds.size() > 0) {
                    Map<String, String> userMap = workflowUserService.getNamesByIds(userIds);

                    Map<String, HistoricTaskInstance> doneTaskMap = doneTaskList.stream().collect(Collectors.toMap(HistoricTaskInstance::getProcessInstanceId, historicTaskInstance -> historicTaskInstance, (key1, key2) -> key2));
                    for (String procId : doneTaskMap.keySet()) {

                        HistoricTaskInstance historicTaskInstance = doneTaskMap.get(procId);
                        //历史流程变量
                        HistoricVariableInstance variableInstanceEntities = historyService.createHistoricVariableInstanceQuery().processInstanceId(procId).variableName("viewUrl").singleResult();
                        HistoricProcessInstance historicProcessInstance = historicProcessInstanceQuery.processInstanceId(procId).singleResult();
                        String uiName = variableInstanceEntities.getValue().toString();
                        Map<String, Object> row = new HashMap<String, Object>();
                        if (historicTaskInstance.getAssignee() != null && historicTaskInstance.getAssignee().equals(WorkflowConstant.ASSIGNEE)) {
                            assignee = WorkflowConstant.ASSIGNEE_NAME;
                        } else {
                            assignee = userMap.get(historicTaskInstance.getAssignee());
                        }
                        String id = historicProcessInstance.getBusinessKey().split("_")[1];
                        row.put("id", id);
                        row.put("viewUrl", uiName);

                        XML xml = (XML) ContextUtils.getAttrbute(ConstantUtil.XML);
                        row.put("toTitle", xml.getUiByName(uiName).getTitle());
                        row.put("assignee", assignee);
                        row.put("createTime", historicTaskInstance.getStartTime());
                        String title = id + "-" + historicProcessInstance.getProcessDefinitionName() + "-" + historicTaskInstance.getName();
                        if (historicProcessInstance.getEndTime() == null) {
                            row.put("title", title);
                            doneTaskDataList.add(row);
                            //办理中的处理人显示最新的处理人
                        } else {
                            title = id + "-" + historicProcessInstance.getProcessDefinitionName() + "-" + historicTaskInstance.getName();
                            row.put("title", title);
                            completeTaskDataList.add(row);
                        }

                    }
                }

            }
            DataGrid undoTaskDataGrid = new DataGrid(undoTaskDataList);
            undoTaskDataGrid.setTotal(undoTaskDataList.size());
            DataGrid doneTaskDataGrid = new DataGrid(doneTaskDataList);
            doneTaskDataGrid.setTotal(doneTaskDataList.size());
            DataGrid completeTaskDataGrid = new DataGrid(completeTaskDataList);
            completeTaskDataGrid.setTotal(completeTaskDataList.size());
            List<DataGrid> dataGridList = new ArrayList<DataGrid>();
            dataGridList.add(undoTaskDataGrid);
            dataGridList.add(doneTaskDataGrid);
            dataGridList.add(completeTaskDataGrid);
            responseObj.setData(dataGridList);

    }
}
