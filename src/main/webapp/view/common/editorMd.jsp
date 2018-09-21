<%@page
	import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ include file="../common/base.jsp"%>
<!DOCTYPE HTML >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="no-cache">
<%-- <link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.preview.min.css" />
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.css" />
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/style.css" />
<script src="${ctx}/view/common/css/editormd/lib/marked.min.js"></script>
<script src="${ctx}/view/common/css/editormd/lib/prettify.min.js"></script>
<script src="${ctx}/view/common/js/editormd/editormd.js"></script>
<link rel="shortcut icon" href="https://pandao.github.io/editor.md/favicon.ico" type="image/x-icon" />
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css" rel="stylesheet" media="screen" />
<link href="${ctx}/view/common/css/style.css" rel="stylesheet" media="screen" />
 --%>
 <script src="${ctx}/view/common/css/editormd/lib/marked.min.js"></script>
 <script src="${ctx}/view/common/css/editormd/lib/prettify.min.js"></script>
 <script src="${ctx}/view/common/css/editormd/lib/raphael.min.js"></script>
 <script src="${ctx}/view/common/css/editormd/lib/flowchart.min.js"></script>
 <script src="${ctx}/view/common/css/editormd/lib/jquery.flowchart.min.js"></script>
 <script src="${ctx}/view/common/js/editormd/editormd.js"></script>
 <link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.preview.min.css" />
 <link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.css" />
 <link rel="stylesheet" href="${ctx}/view/common/css/editormd/style.css" />
<link rel="shortcut icon" href="https://pandao.github.io/editor.md/favicon.ico" type="image/x-icon" />
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css" rel="stylesheet" media="screen" />
<link href="${ctx}/view/common/css/style.css" rel="stylesheet" media="screen" />

<title>editor.md</title>
<style>
.input-group-inline .textbox-text {
	padding-top: 0px;
	padding-bottom: 10px;
}
</style>
<script type="text/javascript">
	//调用编辑器
	var testEditor;
	var addEditor;
	$(function() {
		loaded();
		$(window).load(function() {
			var mode = "${param.EditMode}";
			if (mode == "Readonly" || mode == "") {
				$("#test-editormd").hide();
				addEditor = editormd.markdownToHTML("text123-content", {//注意：这里是上面DIV的id
					htmlDecode: "style,script,iframe",
		            emoji           : true,
		            taskList        : true,
		            tex             : true,  // 默认不解析
		            flowChart       : true,  // 默认不解析
		    	});
			} else if (mode == "Edit"){
				
				testEditor = editormd("test-editormd", {
					width : "730px",
					height : 500,
					syncScrolling : "single",
					path : "${ctx}/view/common/css/editormd/lib/",
					saveHTMLToTextarea : true, //配置，方便post提交表单
					flowChart : true, //支持流程图 
					/**上传图片相关配置如下*/
					imageUpload : true,
					imageFormats : [ "jpg", "jpeg", "gif", "png", "bmp", "webp" ],
					imageUploadURL : "${ctx}/mdupload",
					emoji : true,
					/**绘制UML时序图*/
					sequenceDiagram : true, // 默认不解析
					mdUploadURL:"${ctx}/createMdBat?fileId=${fileId}&fileTitle=${fileTitle}",
					docUploadURL:"${ctx}/saveDocCata?fileId=${fileId}", //保存目录表，文档表
					saveAsPDFURL:"${ctx}/saveAsPDF?fileId=${fileId}", //保存爲PDF
					modeHandleURL:"Edit"
				});
				
					$("#test-editormd").show();
					addEditor = editormd.markdownToHTML("test-editormd-markdown-doc", {//注意：这里是上面DIV的id
			            htmlDecode: "style,script,iframe",
			           
			    });
			}else if (mode == "Add"){
				$("#test-editormd").show();
				testEditor = editormd("test-editormd", {
					width : "730px",
					height : 500,
					syncScrolling : "single",
					path : "${ctx}/view/common/css/editormd/lib/",
					saveHTMLToTextarea : true, //配置，方便post提交表单
					flowChart : true, //支持流程图 
					/**上传图片相关配置如下*/
					imageUpload : true,
					imageFormats : [ "jpg", "jpeg", "gif", "png", "bmp", "webp" ],
					imageUploadURL : "${ctx}/mdupload",
					emoji : true,
					/**绘制UML时序图*/
					sequenceDiagram : true, // 默认不解析
					mdUploadURL:"${ctx}/createMdBat?cataId=${param.cataId}", //上传md文件
					docUploadURL:"${ctx}/saveDocCata", //保存目录表，文档表
					saveAsPDFURL:"${ctx}/saveAsPDF", //保存爲PDF
				    modeHandleURL:"Add"
				});
			}
		});
	});
    
</script>
</head>
<body>
	<form action="${ctx}/mdupload" id="mdFileForm" name="mdFileForm"
		method="post">
		<div id="test-editormd">
			<textarea style="display: none;" class="easyui-textbox"
				id="test-editormd-markdown-doc" name="test-editormd-markdown-doc"
				style="width: 800px;">${fileContent}</textarea>
			<input type="text" id="hideEditor" name="hideEditor" />
			<input type="text" id="test-editormd-mode" name="test-editormd-mode" value = "${param.cataId}"/>
			<!-- 注意：name属性的值  后台如果需要转换成html标准格式存储的话需要调用下边的这个textarea -->
			<textarea id="test-editormd-html-code" name="test-editormd-html-code"
				style="display: none;"></textarea>
			<input type="hidden" class="easyui-textbox" id="fileName"  name="fileName" value="" />
		</div>
		
		<div id="text123-content">
			<textarea style="display: none;">${fileContent}</textarea>
		</div>
	</form>
	<div id='Loading'
		style="position: absolute; z-index: 1000; top: 0px; left: 0px; width: 100%; height: 100%; background: #FFFFFF; text-align: center; padding-top: 10%;">
		<h1
			style="display: inline-block; border: 1px solid #95b9e7; font-size: 16px; padding: 5px;">
			<img src='${ctx}/view/common/images/loading.gif' /> <font
				color="#15428B" size="2">正在处理，请稍等···</font>
		</h1>
	</div>

	<script>
		function closes() {
			$("#Loading").fadeOut("normal", function() {
				$(this).remove();
			});
		}
		var pc;
		function loaded() {
			if (pc)
				clearTimeout(pc);
			pc = setTimeout(closes, 0);
		}
	    
		function doCancel(){
			parent.$('#tmpSearcher').dialog('close');
		}
	</script>
</body>
</html>
