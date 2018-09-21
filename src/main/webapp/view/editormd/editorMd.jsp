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
<link rel="stylesheet"
	href="${ctx}/view/common/css/editormd/editormd.css" />
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/style.css" />
<script src="${ctx}/view/common/js/editormd/editormd.js"></script>
<link rel="shortcut icon"
	href="https://pandao.github.io/editor.md/favicon.ico"
	type="image/x-icon" />
<title>editor.md</title>
<script type="text/javascript">
	//调用编辑器
	var testEditor;
	$(function() {
		testEditor = editormd("test-editormd", {
			width : "1200px",
			height : 640,
			syncScrolling : "single",
			path : "${ctx}/view/common/css/editormd/lib/",
			saveHTMLToTextarea : true, //配置，方便post提交表单
			flowChart : true, //支持流程图 

			/**上传图片相关配置如下*/
			imageUpload : true,
			imageFormats : [ "jpg", "jpeg", "gif", "png", "bmp", "webp" ],
			imageUploadURL : "${ctx}/mdupload",

			/**emoji */
			emoji : true,
			/**绘制UML时序图*/
			sequenceDiagram : true, // 默认不解析
		});
	});
</script>
</head>
<body onload="testEditor.watch()">
	<!-- 不需要实时预览时  testEditor.unwatch()-->
	<form action="" name="" method="post">
		<table>
			<tr>
				<td style="padding-left: 30px;margin-left: inherit;float: left;">文件名称:</td>
				<td  style="padding-left: 10px;"><input type="text" id="" name="" value="" /></td>
			</tr>
			<tr>
				<td  style="padding-left: 30px;margin-left: inherit;float: left;">文件内容:</td>
				<td style="padding-left: 10px;">
					<div id="test-editormd" >
						<textarea style="display: none;" id="ts" style="width: 800px;"></textarea>
						<!-- 注意：name属性的值-->
						<textarea id="test-editormd-html-code" name="test-editormd-html-code" 
						style="display:none;"></textarea>
					</div></td>
			</tr>
			<tr>
				<td style="float: inherit;padding-left: 600px;" colspan="2">
					<input type="submit" id="submit" value="保存" /> 
					<input type="button" id="cancle" value="取消" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>