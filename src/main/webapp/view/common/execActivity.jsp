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

<div class="easyui-layout" style="width:100%;height:100%;">
    <div data-options="region:'south'">
        <div class="easyui-layout" data-options="fit:true,collapsible:false">
            <div data-options="border:false,region:'south'"
                 style="overflow: hidden;" class="js-panel">
                <div class="btn-group" style="text-align: right;">
                    <c:if test="${isShowRadio==true}">
                        <a class="easyui-linkbutton" href="javascript:void(0)"
                           onClick="completeTask()"
                           id="pnlDown_ctlSave" name="ctlSave" style="margin-right: 10px">确认</a>
                    </c:if>
                    <c:if test="${isShowRadio==false}">
                        <a class="easyui-linkbutton" href="javascript:void(0)"
                           onClick="completeTask()"
                           id="pnlDown_ctlSave" name="ctlSave" style="margin-right: 10px">提交</a>
                    </c:if>
                    <a class="easyui-linkbutton" href="javascript:void(0)"
                       onClick="closeDialog()"
                       id="pnlDown_ctlCancel" name="ctlCancel" style="margin-right: 10px">取消</a>

                </div>
            </div>
        </div>
    </div>
    <div data-options="region:'center'">
                <form id="auditForm">
                    <input type="hidden" name="taskId" value="${taskId}"/>
                    <c:if test="${isShowRadio==false}">
                        <div class="input-group-inline">
                            <label style="">知会</label>
                        </div>
                        <input type="hidden" name="auditResult" value="y"/>
                    </c:if>
                    <c:if test="${isShowRadio==true}">
                        <div class="input-group-inline">
                            <label style="">审核说明</label>
                            &nbsp${auditGuideline}
                        </div>
                    </c:if>
                    <c:if test="${isShowRadio==true }">
                        <div class="input-group-inline">
                            <label style="">审核结果</label>
                            <input type="radio" name="auditResult" style="height:22px;" onchange="changeRequire('y')"
                                   value="y" checked="checked"/>同意
                            <input type="radio" name="auditResult" style="height:22px;" onchange="changeRequire('n')"
                                   value="n"/>不同意
                        </div>
                    </c:if>
                    <div class="input-group-inline">
                        <label style="">审核意见</label>
                        <input style="width: 200px" data-options="multiline:true" id="auditOption" name="auditOption"
                               class="easyui-textbox js-input "/>
                    </div>

                </form>
    </div>
</div>


</body>
<script>
    var saveOpt = 0;
    $(document).ready(function () {
        var height = $("#auditOption").parent().height();
        var width = $("#auditOption").parent().width();
        $("#auditOption").textbox('textbox').css('height', "60%");
        //没有撑满需要设置和input一样的高度
        $("#auditOption").textbox('textbox').css('width', '200px');
        $("#auditOption").textbox('textbox').css('background', 'white');

    });


    function changeRequire(v) {
        // if (v == 'n') {
        //     $("#auditOption").attr("class", "easyui-textbox");
        //     $('#auditOption').attr("validType","required");
        // } else {
        //
        // }
    }

    function completeTask() {

       saveOpt =1;

        var url = '${ctx}/api/completeTask';
        var param1 = $("#auditForm").serializeJson();
        var param2 = new Object();
        param2['token'] = "${token}";
        var params = $.extend(param1, param2);
        ajaxPost(url, params, function (result) {
            closeDialog();
            //审批结束关闭窗体
            //parent.dlg.dialog('close');
        });
    }

    function closeDialog() {
        parent.$("#workFlowWindowDiv").dialog('close');
        //取消关闭窗体
        //parent.dlg.dialog('close');
    }

</script>
</html>

