<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
 <%@ include file="common/base.jsp"%>
<!DOCTYPE HTML >
<html lang="en">
<head>
<title>工具列表</title>
</head>
<body>
<c:forEach items="${menuList}" var="item" varStatus="st1">
<a href="${ctx}download?fileName=${item }">点击下载${item }</a><br>
</c:forEach>
</body>
</html>
