<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ include file="base.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script  src="${ctx}/view/common/js/easyui/jquery.min.js"></script>
<script  src="${ctx}/view/common/js/easyui/jquery.easyui.min.js"></script>
<link href="${ctx}/view/common/css/imageView.css" rel="stylesheet" media="screen"/>
<script src="${ctx}/view/common/js/carousel-v0.7.js"></script>
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.preview.min.css" />
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/editormd.css" />
<link rel="stylesheet" href="${ctx}/view/common/css/editormd/style.css" />
<script src="${ctx}/view/common/css/editormd/lib/marked.min.js"></script>
<script src="${ctx}/view/common/css/editormd/lib/prettify.min.js"></script>
<script src="${ctx}/view/common/js/editormd/editormd.js"></script>
<link rel="shortcut icon" href="https://pandao.github.io/editor.md/favicon.ico" type="image/x-icon" />
<link href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css" rel="stylesheet" media="screen" />
<link href="${ctx}/view/common/css/style.css" rel="stylesheet" media="screen" />
<script src="http://adrai.github.io/flowchart.js/"></script>
<style>
.input-group-inline .textbox-text {
	padding-top: 0px;
	padding-bottom: 10px;
}
</style>
<script>
$(function(){
	var type = $("#type").val();
	var ctx = $("#ctx").val();
	var id = $("#id").val();
	if(type == "IMAGE"){
		htmlContext = "<div class='carousel' id='carousel'></div>"; 
		$("#preview").append(htmlContext);
        var opts = {
	            index:2,                               //开始显示的图片索引值
	            carousleTime:5000,                     //轮播图速度（ms）
	            imgWidth:500,                          //图片的宽度
	            parentDom:".carousel",                 //必传参数 父容器
	
	            data:[                                 //必传参数 图片数据
	            	{href:"#",img:ctx+"/localDownload?fileId="+id},
	            ],
	        }
	    var carousel = new Carousel(opts); 
	}else if(type == "MARKDOWN"){
    	$("#layout").hide();
    	addEditor = editormd.markdownToHTML("text123-content", {//注意：这里是上面DIV的id
            htmlDecode: "style,script,iframe", 
            //saveHTMLToTextarea : true, //配置，方便post提交表单
			
    	});
		
	}else if(type == "PDF"){
		location.href="${ctx}/localDownload?fileId="+id+"&preview=pre";
	}else if(type == "VIDEO"){
		htmlContext = "<div><video src='"+ctx+"/localDownload?fileId="+id+"' controls='controls' height='100%' width='100%'>您的浏览器不支持该视频播放。</video></div>"; 
		$("#preview").append(htmlContext);
	}else{
		htmlContext = "<div style='margin-top:200px;'><font size='4' face='微软雅黑' >该类型文件无法预览，请直接下载文件</font></div>";
		$("#preview").append(htmlContext);
	}
}); 
function open(href){
		window.open(href);
}
</script>
<body  fit="true" style="width:100%;height:100%" onresize="resizeGrid();" >
<!-- <body > -->
<div id="layout" class="easyui-layout" data-options="fit:true" >
<div data-options="region:'south'" >
	<div class="easyui-layout" data-options="fit:true" >
	<div data-options="border:false,region:'south'" style="overflow:hidden;" class="js-panel">
	
	<div class="btn-group" style="text-align:right;">
	<!-- <a class="easyui-linkbutton" href="#" target="_blank>">原文件查看</a> -->
    <a class="easyui-linkbutton" href="${ctx}/localDownload?fileId=${id}"
						id="pnlDown_ctlSave" name="ctlSave" style="margin-right: 10px">文件下载</a>
	</div>
	</div>
	</div>
</div>	

<div id="preview" data-options="region:'center'" style="text-align:center;width:100%;height:100%" >
	<input id="type" value="${type}" hidden="hidden">
	<input id="ctx" value="${ctx}" hidden="hidden">
	<input id="id" value="${id}" hidden="hidden">
	<input id="fileContent" value="${fileContent}" hidden="hidden">
</div>
</div>

<div id="text123-content" style="width:100%;height:100%">
	<textarea style="display: none;">${fileContent}</textarea>
	
</div>
		

</body>
