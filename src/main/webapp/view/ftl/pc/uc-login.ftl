<html>
<head>
	<#assign ctx = request.contextPath />
	
	<script src="${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.min.js"></script>
    <script src="${ctx}/view/common/js/jquery-1.8.3.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="${ctx}/view/common/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/view/common/css/animate.css" rel="stylesheet">
    <link href="${ctx}/view/common/css/iconfont.css" rel="stylesheet">
    <link href="${ctx}/view/common/css/style.css" rel="stylesheet">
    <script src="${ctx}/view/common/js/MD5.js?${date}"></script>
    <script src="${ctx}/view/common/js/ajaxUtil.js?${date}"></script>

    <script src="${ctx}/view/common/js/store/myStorage.js?${date}" charset="utf-8"></script>
    <script src="${ctx}/view/common/js/store/json2.js?${date}" charset="utf-8"></script>
    <script src="${ctx}/view/common/js/store/localDB.js?${date}" charset="utf-8"></script>
    <script src="${ctx}/view/common/js/base.js" charset="utf-8"></script>
	
	
</head>

<body onload="load()">
	正在加载中。。。
</body>
<script type="text/javascript">
	 $(document).ready(function () {
        console.log(localDB.select("appStart"));
        if (localDB.select("appStart").length == 0) {
            localDB.createSpace("appStart");
            localDB.insert("appStart", {app: '${app}', ver: '${ver}', cid: '${cid}', uid: ''});
        }
		console.log(localDB.select("appStart"));

    });
	function load(){
        ajaxPost("${ctx}/uc-login", {
            ucToken:"${ucToken}"
        }, function (result) {
            if (result.data!=null&&result.data.userId!=undefined) {
                //登录成功存储uid
                localDB.update("appStart", {app: '${app}', ver: '${ver}', cid: '${cid}', uid: ''}, {
                    app: '${app}',
                    ver: '${ver}',
                    cid: '${cid}',
                    uid: result.data.userId
                });
                console.log(localDB.select("appStart"));
                window.location.href = "${ctx}/uc-index";
            } else {
                $('#tool-mes>div').show();
                var errorMsg = $("#tool-mes em");
                errorMsg.text(result.msg);
                window.location.href = "${ucIndex}";
            }
        });

    }
</script>
</html>