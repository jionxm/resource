<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
 <%@ include file="common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css" rel="stylesheet" media="screen"/>
<link href="${ctx}/view/common/css/style.css" rel="stylesheet" media="screen"/>
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/icon.css" rel="stylesheet" media="screen"/>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.min.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.easyui.min.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/easyui.plugins.js"></script>
<script  src="${ctx}/view/common/js/ajaxfileupload.js"></script>
<!-- 引用EasyUI的国际化文件,让它显示中文 -->
<script src="${ctx}/view/common/css/plugins/easyui-1.5.2/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script  src="${ctx}/view/common/js/base.js"></script>
<div id="a" class="easyui-layout" style="width:100%;height:100%;">
	<div data-options="region:'south'">
		<div class="easyui-layout" data-options="fit:true,collapsible:false">
			<div data-options="border:false,region:'center'"
				style="overflow: hidden;" class="js-panel">
				<div class="btn-group" style="text-align: right;">
					<a class="easyui-linkbutton" href="javascript:void(0)"
						onClick="exportData()"
						id="pnlDown_ctlSave" name="ctlSave" style="margin-right: 10px">确认</a>
					<a class="easyui-linkbutton" href="javascript:void(0)"
						onClick="closeDialog()"
						id="pnlDown_ctlCancel" name="ctlCancel" style="margin-right: 10px">取消</a>
				</div>
			</div>
		</div>
	</div>
     <div  data-options="region:'west',collapsible:false," style="width:200px;">
     	<div  id='exportData' class="easyui-panel" style='weight:300px;height:100%' title="选择导出类型">
     		<input name="ContentType" type="radio" value="Excel" checked="checked">Excel</input></br> 
     		<input name="ContentType" type="radio" value="Csv" >CSV</input></br> 
     		<input name="ContentType" type="radio" value="Html" >HTML</input></br> 
     		<input name="ContentType" type="radio" value="Pdf" >PDF</input></br> 
     	</div>
     </div>
     <div data-options="region:'center'">  
			<!-- <div id="dg" title="请选择导出列"></div> -->
			 <div  id='dataList'  style='weight:300px;height:100%' title="选择导出列"></div>
	 </div>
</div>
	<script type="text/javascript">

$(document).ready(function(){ 
	//导出列
	var myDataList = $('#dataList');//dataList句柄
	myDataList.datalist({
		lines: false,
		checkbox: true,
		selectOnCheck: false,
		data: parent.columnDefine,
		onLoadSuccess: function () {
			$.each(parent.checked, function (i, rowIndex) {
				myDataList.datalist("checkRow", rowIndex);
			});
		}
	});
	
	//全选/全不选
 	$("#dataList").datagrid({
        onCheck : function(index, row){
			if(index==0) $("#dataList").datalist('checkAll');
        },
 		onUncheck:function(index, row){
 			if(index==0) $("#dataList").datalist('clearChecked');
 		}
	}); 
	
});

//导出数据
function exportData(){
    var SQLId = parent.SQLId;
    var InputPanel = parent.InputPanel;
    var exportUrl = parent.exportUrl;
    var token = parent.token;
    var title = parent.title;
    var exportType = null;
    
    //获取所选导出类型
  	exportType =  $('input:radio[name="ContentType"]:checked').val();
	if(exportType == null){
		$.messager.alert("提示","请选择导出格式");
		return false;
	} 
	
	//获取所选导出列
	var checkedDataArray = $('#dataList').datalist("getChecked");
	var dataValue = new Array();
	var dataTitle = new Array();
	$.each(checkedDataArray, function (i, checkedData) {
		debugger
		if(checkedDataArray[0].value==""){
			dataValue[i-1] = checkedData.value;
			if(checkedData.title==''||checkedData.title == undefined){
				dataTitle[i-1] = checkedData.text;
			}else{
				dataTitle[i-1] = checkedData.text;
			}
		}else{
			dataValue[i] = checkedData.value;
			dataTitle[i] = checkedData.text;
		}
	});
	var param = {};
	//请求生成导出文件
	//因为有提示框所以没有用ajaxutil函数请求，因为后台要循环request对象来取查询条件参数
	//至于循环request对象取参数是为了满足freemarker模板中sql语句model.control这类传值的需求
	var par = parent.param;
	param = par;
	param['token'] = token;
	param['dataValue'] = dataValue.toString();
	param['dataTitle'] = dataTitle.toString();
	param['SQLId'] = SQLId;
	param['exportType'] = exportType;
	param['title'] = title;
 	var url = exportUrl;
	$.ajax({	
		type: 'GET',
		url: url,
		data:param,
		dataType: "json",
	    beforeSend: function () {
	        $.messager.progress({ 
	           title: '提示', 
	           msg: '正在导出文件，10秒后无响应请重新导出……', 
	           text: '' 
	        });
	        },
	           complete: function () {
	            $.messager.progress('close');
	        },
		success: function (data)
		{
			var download = "<div align='center' ><h3>导出成功！<h3><br/>";
			var msg = data.msg;
			if(data.msg!=0){
				$.messager.alert("数据导出",download,downloadFile(msg));
			}else{
				$.messager.alert("数据导出","生成文件失败，请重试");
			}
		},
	}); 
}

//下载导出的数据文件
function downloadFile(msg){location.href = parent.ctx+"/localDownload?fileId="+msg+"&methodType=export";}

//关闭窗口
function closeDialog(){
	parent.dlg.dialog('close');
}


</script>			
