<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ include file="base.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.min.js"></script>
<script  src="${ctx}/view/common/js/jquery.barrager.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.easyui.min.js"></script>
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
video::-webkit-media-controls-enclosure {
    overflow:hidden;
}
video::-webkit-media-controls-panel {
     width: calc(100% + 30px); 
}
.input-group-inline .textbox-text {
	padding-top: 0px;
	padding-bottom: 10px;
}
video::-webkit-media-controls-fullscreen-button {
    display: none;
}
</style>
<script type="text/javascript">
function endstudy(){
	console.log(111);
	/* var ctx = $("#ctx").val();
	console.log(ctx);
	var ajaxctx = ctx+"/QryFileId/"; */
	var url = "/test/defect";
	$.ajax({
		type: 'POST',
		url: url,
		data:{
			'empid':$("#empid").val(),
			'id':$("#id").val(),
			'business':$("#business").val()
		},
		dataType: "json",
		success: function (data){;
			return "确定离开当前页面吗？";
		},
	});
   	
}

$(function(){
	var empid = $("#empid").val();
	var empname = $("#empname").val();	
    $('canvas').barrager([{"msg":empname+"-"+empid},{"msg":empname+"-"+empid}]);
    $('#qc').click(function(){
       $('canvas').barrager("clear");
    });
    $('#tj').click(function(){
    	$('canvas').barrager([{"msg":empname+"-"+empid},{"msg":empname+"-"+empid}]);
    });
   setInterval(function(){
	   $('canvas').barrager([{"msg":empname+"-"+empid},{"msg":empname+"-"+empid}]);
    },2000);
})
</script>
<script>
document.onkeydown = function()//禁止刷新
{
     if(event.keyCode==116) {
    	 alert("禁止F5刷新网页！");
         event.keyCode=0;
         event.returnValue = false;
     }
     if ((event.ctrlKey==true)&&(event.keyCode==82)){ 
         alert("禁止Ctrl+R刷新网页！"); 
         event.keyCode=0;  
         event.returnValue=false;  
     }  
     if ((event.shiftKey)&&(event.keyCode==121)){ 
         alert("禁止shift+F10刷新网页！"); 
         event.keyCode=0;  
         event.returnValue=false;  
     }  
}
document.oncontextmenu = function() {
   event.returnValue = false;
}
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
		var empid = $("#empid").val();
		var empname = $("#empname").val();
		var business = $("#business").val();
		sessionStorage.setItem("playCtx",ctx);
		sessionStorage.setItem('playFileId', id);
		sessionStorage.setItem('empid', empid);
		sessionStorage.setItem('empname', empname);
		sessionStorage.setItem("business",business);
		window.onbeforeunload=null;
		location.href="${ctx}/view/common/js/pdfjs/web/viewer.html";//文件id
		//window.open("${ctx}/view/common/js/pdfjs/web/viewer.html",'_blank');
	}else if(type == "VIDEO"){
		htmlContext = "<div><video  src='"+ctx+"/localDownload?fileId="+id+"' controls='controls' height='100%' width='100%'>您的浏览器不支持该视频播放。</video><input id='close'  style='width:60px;height:20px;' OnClick='endstudy()' type='button' value='结束学习'></div>"; 
		$("#preview").append(htmlContext);
	}else{
		htmlContext = "<div style='margin-top:200px;'><font size='4' face='微软雅黑' >不支持该类型文件播放</font></div>";
		$("#preview").append(htmlContext);
	}
});
function open(href){
		window.open(href);
}

/* window.onbeforeunload=function(e){	
	var e = window.event||e;  
	e.returnValue=save(e);	
} */

function save(){
	/* var ctx = $("#ctx").val();
	console.log(ctx);
	var ajaxctx = ctx+"/QryFileId/"; */
	var url = "/test/defect";
	$.ajax({
		type: 'POST',
		url: url,
		data:{
			'empid':$("#empid").val(),
			'id':$("#id").val(),
			'business':$("#business").val()
		},
		dataType: "json",
		success: function (data){;
			return "确定离开当前页面吗？";
		},
	});
   	return false;
}
</script>


<body  fit="true" style="width:100%;height:100%" >
<!-- <body > -->

<div id="preview" data-options="region:'center'" style="text-align:center;width:100%;height:100%" >
	<input id="type" value="${type}" hidden="hidden">
	<input id="ctx" value="${ctx}" hidden="hidden">
	<input id="id" value="${id}" hidden="hidden">
	<input id="empid" value="${empid}" hidden="hidden">
	<input id="empname" value="${empname}" hidden="hidden">
	<input id="fileid" value="${fileid}" hidden="hidden">
	<input id="business" value="${business}" hidden="hidden">
	<input id="fileContent" value="${fileContent}" hidden="hidden">
</div>
</div>

<canvas style="width: 1280px;position: absolute;left: 0;top: 0;margin: 0 auto;right: 0;height: 100px;background-color: rgba(0,0,0,0);">你的浏览器不支持canvas</canvas>
		

</body>
