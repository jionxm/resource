<%--
  Created by IntelliJ IDEA.
  User: yangjixin
  Date: 2017/11/9
  Time: 下午3:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="base.jsp" %>
<!DOCTYPE HTML >
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html>
<body>
<div id='Loading'
     style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#FFFFFF ;text-align:center;padding-top: 10%;">
    <h1 style="display: inline-block;border: 1px solid #95b9e7;font-size: 16px;padding: 5px;">
        <image src='${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/images/loading.gif'/>
        <font color="#15428B" size="2">正在处理，请稍等···</font></h1>
</div>
<div class="easyui-layout" style="overflow:hidden;width:100%;height:100%;" fit="true",scoll="no">
    <div data-options="region:'south'" style="height: 47px">
        <div data-options="border:false,region:'south'"
             style="overflow: hidden;" class="js-panel">
            <div class="btn-group" style="text-align: right;">
                <a class="easyui-linkbutton" href="javascript:void(0)"
                   onClick="closeDialog()" style="margin-right: 10px">关闭</a>
            </div>
        </div>
    </div>
    <div data-options="region:'center'" style="overflow:hidden;">
        <div class="easyui-tabs" data-options="fit:true">
            <div title="流程进度"  >
                <table class="easyui-datagrid"
                       data-options="rownumbers: true,singleSelect:true,fitColumns:false,fit:true">
                    <thead>
                    <tr>
                        <!--事件名被遮挡-->
                        <th data-options="field:'activityName',width:200,align:'center'">事件名称</th>
                        <th data-options="field:'assignee',width:80,align:'center'">处理人</th>
                        <th data-options="field:'startTime',width:150,align:'center'">
                            开始时间
                        </th>
                        <th data-options="field:'endTime',width:150,align:'center'">
                            结束时间
                        </th>
                        <th data-options="field:'auditResult',width:80,align:'center'">审核结果</th>
                        <!--审核意见显示不下-->
                        <th data-options="field:'auditOption',width:500,align:'center'">审核意见</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${hisList}" var="his" varStatus="i">
                        <tr>
                            <td style="text-align: left">${his.activityName}</td>
                            <td style="text-align: left">${his.assignee}</td>
                            <td style="text-align: center">${his.startTime}</td>
                            <td style="text-align: center">${his.endTime}</td>
                            <td style="text-align: left">${his.auditResult}</td>
                            <td style="text-align: left">${his.auditOption}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div title=" 流程图" >
                <!--流程图文字遮挡-->
                <div data-options="fit:true"><img id=""
                          src='${ctx}/api/readActitiviPicture?token=${token}&processId=${processId}&processDefinitionId=${processDefinitionId}&resourceName=${resourceName}'/>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script>
    function closes() {
        $("#Loading").fadeOut("normal", function () {
            $(this).remove();
        });
    }
    var pc;
    function loaded() {
        if (pc) clearTimeout(pc);
        pc = setTimeout(closes, 0);
    }
    $(document).ready(function () {
        loaded();
    });
    function closeDialog() {
        //取消关闭窗体
        //parent.$("#workFlowListWindowDiv").dialog("close");
        parent.$("#workFlowListWindowDiv").dialog('close');

    }

</script>


