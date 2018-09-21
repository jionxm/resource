<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<table width="100%">
<tr><td colspan="2">数据校验失败:</td></tr>
        <c:forEach items="${ex.errors.fieldErrors}" var="err">
		<tr><td >${err.field}</td><td>${err.defaultMessage}</td></tr>        
        </c:forEach>  
       <tr><td > ${ex.message}</td></tr>    
  </table>