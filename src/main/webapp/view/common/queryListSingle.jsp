<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择对话框</title>
<script type="text/javascript">


var retName = "";
var retValue = "";
var ids = [];
function doQuery(){
     $('#dgQuery').datagrid({  
	    url:'${ctx}/query/${query.queryType}',
	    queryParams:$("#frmQuery").serializeJson()
	});  
 } 
//
function doConfirm(){
	var row = $("#dgQuery").datagrid('getSelected');     
	if(row){
		checkRow(row);
		closePageDialog();
	}
};

function checkRow(row){
	retName = row.name;
	retValue = row.id
};
function doClear(){
	//$('#frmQuery').form('clear');
	$("#dlgId").textbox("setValue", "");
	$("#dlgName").textbox("setValue", "");
}

function opFormatter(value, rowData, rowIndex){
	return '<input name="isShow" type="radio" onclick="checkRow(' + rowData + ')"/> ';
}

$(document).ready(function(){
	doQuery();
});
</script>
</head>
<body class="easyui-layout" fit="true" margin="0" >
<div id="searchtool" style="padding:5px">  
    <form id="frmQuery" method="post">
     <div class="input-box">
        <div class="input-group-inline">
        	<label for="$eq_id">编码:</label>
        	<input class="easyui-textbox" type="text" name="$lk_id" id="dlgId" />
        </div>
        <div class="input-group-inline">
        	<label for="$lk_name">名称:</label>
        	<input class="easyui-textbox" type="text"  name="$lk_name" id="dlgName"/>
        	<input type="hidden" name="queryParam" value="${query.queryParam}" />
        	<input type="hidden" name="single" value="1" /><!-- 单选 -->
        </div>
     </div>   
	</form>
</div>
<div data-options="region:'center'" >	
		<!-- 用户信息列表 -->
		<table class="easyui-datagrid" 
		data-options="fit:true,pagination:true,toolbar:'#searchtool',fitColumns:true,singleSelect:true" id="dgQuery">
		    <thead>
		        <tr>
		        	<th data-options="field:'ck',width:80,align:'center',formatter:opFormatter">选择</th>  
		        	<th data-options="field:'id',width:80">编码</th>
		            <th data-options="field:'name',width:300">名称</th>
		        </tr>
		    </thead>
		</table>
</div>
<div data-options="region:'south'" style="text-align: right;overflow:hidden;padding:10px 5px 10px 15px" >	
		<a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px" id="btnQuery" onclick="doQuery()" ">查询</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px" id="btnClear" onClick="doClear()" >清空</a>
	    <a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px" id="btnConfirm" onClick="doConfirm()" >确认</a>
	    <a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px" id="btnCancel" onClick="javascript:closePageDialog();">取消</a>
</div>
</body>
