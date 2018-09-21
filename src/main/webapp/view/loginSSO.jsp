<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.ImportDocument.Import" %>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE HTML >
<html lang="en">
<body> 
1111
<form action="https://auth.huaweicloud.com/authui/federation/websso?domain_id=5ce1e59796ee42f5b2c7aaf0002099c5&idp=tpms_saml&protocol=saml"  id="sso"
method="post"> 
<input type="hidden" name="RelayState" 
value="${RelayState}" /> 
<input type="hidden" name="SAMLRequest" 
value='${SAMLRequest}' /> 

</form> 
</body> 
</html>
<script>
debugger
document.getElementById("sso").submit();
</script>
