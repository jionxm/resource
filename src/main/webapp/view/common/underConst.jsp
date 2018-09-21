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
<title>正在建设中</title>
<style>  
.box{ position: absolute;width:400px;height:200px;left:50%;top:50%; 
margin-left:-200px;margin-top:-100px;}   
img{ *position:relative; vertical-align:top;left:50%;top:50%;right:50%;}  
</style>  
</head>
<body>  
	<div class="box">
		<img alt="正在建设中" src="${ctx}/view/common/images/underConstruct.png"  height="200" width="200">
	</div>     
</body>
</html>