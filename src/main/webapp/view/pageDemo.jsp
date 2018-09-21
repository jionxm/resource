<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
 <%@ include file="common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>分页测试111111111</title>
</head>
<body>
    <table id="dg" title="" class="easyui-datagrid" style="width:700px;height:250px"
           	url="<%=request.getContextPath()%>/user/userList"
           	 data-options="fitColumns:true,rownumbers: true, pagination:true"
            >
        <thead>
            <tr >
                <th field="id" width="30" sortable="true">用户ID</th>
                <th field="name" width="50" id="name" sortable="true">姓名</th>
                <th field="sex" width="30" id="sex" sortable="true">性别</th>
                <th field="age" width="30" id="age" sortable="true">年龄</th>
				<th field="address" width="70" id="address"	>家庭住址</th>
            </tr>
        </thead>
    </table>
    <script>

    </script>
</body>
</html>