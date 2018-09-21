<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML >
<head>
<meta http-equiv="pragma" content="no-cache">  
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="no-cache">    
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css" rel="stylesheet" media="screen"/>
<link href="${ctx}/view/common/css/style.css" rel="stylesheet" media="screen"/>
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/icon.css" rel="stylesheet" media="screen"/>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.min.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.easyui.min.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/easyui.plugins.js"></script>
<!-- 引用EasyUI的国际化文件,让它显示中文 -->
<script src="${ctx}/view/common/css/plugins/easyui-1.5.2/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script  src="${ctx}/view/common/js/base.js"></script>
   <!-- js本地存储-->
<script src="${ctx }/view/common/js/store/myStorage.js" charset="utf-8"></script>
<script src="${ctx }/view/common/js/store/json2.js" charset="utf-8"></script>
<script src="${ctx }/view/common/js/store/localDB.js" charset="utf-8"></script>
<script  src="${ctx}/view/common/js/ajaxUtil.js"></script>
<script src="${ctx}/view/common/js/ajaxfileupload.js"></script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<body class="easyui-layout" fit="true" style="width:100%;height:100%" >

<div data-options="region:'north'" style="" >
		<div class="easyui-layout" data-options="fit:true" >
		<div data-options="border:false,region:'north'" style="overflow:hidden;" class="js-panel">
		<div class="btn-group" style="text-align:center;" id="group" >
        	<a href="javascript:void(0)" flat="true" class="easyui-linkbutton" style="width:56spx;color:#red" id="btnDownload" onclick="downloadTemp()">下载模板</a> &gt;
			<input class="easyui-filebox" name="fileUploadId" id="fileUploadId" data-options="prompt:'选择文件',buttonText:'&nbsp;选&nbsp;择&nbsp;',
			onClickButton:uploadExcelType(),onChange:uploadExcel" style="width:300px">	 &gt;
        	<a href="javascript:void(0)" flat="true" class="easyui-linkbutton" style="width:60px" id="importData" onclick="importData()">导入数据</a>
  		</div>
</div>
</div>
</div>
<div data-options="region:'center'" >
 <table  class="easyui-datagrid"  
				name="pnlDg" id="pnlDg" 
				data-options="
				fit:true,
				toolbar:'#toolbar',
				halign:'center',
				fitColumns:false,
				singleSelect:true,
				pagination:false,
				columns:[${columns}],
				nowrap:false"> 
		<thead>
		</thead>
</table> 
</div>
</body>
<script type="text/javascript">
$(function(){
	$("#btnDownload").find("span").css("backgroundColor","#ffe48d");  
   })
function updateClientContext(c) {
	//do nothing for ajaxUtil
}
$(document).ready(function () {
	$('#importData').linkbutton('disable');  
 });
function uploadExcelType(){
	var fileAccessType="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,.csv";
	$("#fileUploadId").attr("accept",fileAccessType);
	window.fileSize = "1000";
	window.fileType = "csv,xls,xlsx";
	window.fileAccessType = fileAccessType;
}
function uploadExcel(){
	var upfile = document.getElementById('filebox_file_id_1').files[0];
	var size = ''; size = fileSize;
	var type = ''; type = fileType;
	var accessType = ''; accessType = fileAccessType; 
	if(size == ''){
		$.messager.alert('文件上传',请配置文件上传大小参数);
	}else if(parseInt(size)*1024<=upfile.size){
		var msg = '上传文件不能超过'+size+'KB';
		$.messager.alert('文件上传',msg);
	}else{
		var formData = new FormData($("#importFileForm")[0]);  
		$.messager.confirm('文件上传', '确定要上传吗?', function(r){
			if (r){
			  	 $.messager.progress({
					           title: '提示', 
					           msg: '正在解析，请稍后……', 
					           text: '' 
					        });
	    		$.ajaxFileUpload({  
	                 url:'${ctx}/uploadExcelBat?token=${token}',  
	                 data:{accessType:accessType,allowFile:type,maxSize:size},
	                 
	                 secureuri:false,  
	                 fileElementId:'filebox_file_id_1',//file标签的id  
	         		/* contentType:"application/json;charset=utf-8",  */
	        		dataType : "json", 
	                 success: function (data) {
           				$.messager.progress('close');  
	                	 if(data.code==0){
	                		$("#pnlDg").datagrid({
	                			loader:function(params,success,error){
                					var dgData = data.data;
                					dgData['columns'] = [${columns}];
                					success(dgData);
                					$('#importData').linkbutton('enable'); 
	                			}
	                		});
	                	 } else {
	                		 $.messager.alert('提示','文件损坏');
	                	 }
	                 },
	                 error: function (data) {
	                	 $.messager.progress('close'); 
	                	 $.messager.alert('提示','文件损坏');  
	                 }  
         		});
			}
		});
	}
	
}
function downloadTemp(){
	window.location.href = "${ctx}/downLoadTemp?&title=${title}&titles='${titles}'";
}
function importData(){
	var data=$("#pnlDg").datagrid("getRows");
	var successData = new Array();
	for(var i=0;i<data.length;i++){
		if(data[i]["验证结果"]=="成功"){
			successData.push(data[i]);
		}
	}
	$('#importData').linkbutton('disable');  
	var index=0;
	for(var i=0;i<data.length;i++){
		var param = {};
		param = data[i];
		param['token'] = "${token}";
		ajaxPost("${ctx}/api/save",param,function(res){//succeeded
		 	 $.messager.progress({
		         title: '提示', 
		         msg: '正在解析，请稍后……', 
		         text: '' 
		      });
			if(res.code!=0){
				var row = $('#pnlDg').datagrid("selectRow", index).datagrid("getSelected");
				row.验证结果 = res.data.msg;
				$('#pnlDg').datagrid('refreshRow', index);
			}
			index++;
			if(index==data.length){
				$('#importData').linkbutton('enable');
				$.messager.progress('close');  
				$.messager.alert("提示",'导入完成', 'info', function(){
				});
			}
		},
		function(res){//error
	    	parent.showError(res.responseText);
		},false);
		
	}


}
</script>

</html>