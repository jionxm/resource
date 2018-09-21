<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta http-equiv="pragma" content="no-cache">  
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="no-cache">    
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- easyUI -->
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.min.js"></script>
<script  src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.easyui.min.js"></script>
<script src="${ctx}/view/common/css/plugins/easyui-1.5.2/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script  src="${ctx}/view/common/js/base.js"></script>

 <link rel="stylesheet" href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/easyui.css">
 <link rel="stylesheet" href="${ctx}/view/common/css/plugins/easyui-1.5.2/themes/icon.css">
<link rel="stylesheet" href="${ctx}/view/common/css/style.css">

<script src="${ctx}/view/common/js/store/myStorage.js" charset="utf-8"></script>
<script src="${ctx}/view/common/js/store/json2.js" charset="utf-8"></script>
<script src="${ctx}/view/common/js/store/localDB.js" charset="utf-8"></script>
<!-- ajaxUtil-->
<script src="${ctx}/view/common/js/ajaxUtil.js" charset="utf-8"></script>
<script type="text/javascript">  
function isIE() { //ie?
    if (!!window.ActiveXObject || "ActiveXObject" in window)
      return true;
    else
      return false;
  }
    if (isIE()){
    } else {
    	//history.pushState(null, null, document.URL);
    }
</script>  

 