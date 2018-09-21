<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx"
       value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html >
<head >
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <link rel="shortcut icon" href="${faviconIco}" type="image/vnd.microsoft.icon" />

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
    <title>${baseTitle}</title>
    <style>
        html, body {
            width: 100%;
            height: 100%;
            background: url("${ctx}/${loginImg}") no-repeat center center;
        }

        .lg-cont-box {
            position: absolute;
            top: 50%;
            left: 50%;
            margin-left: -500px;
            margin-top: -235px;
            width: 1000px;
            height: 470px;
        }

        .form-cont {
            width: 285px;
            height: 210px;
        }

        .form-cont input {
            padding-left: 40px;
            display: inline-block;
            width: 100%;
            height: 42px;
            margin-top: 9px;
            border: 1px solid #afadad;
        }

        .lg-cont-box input.last-yanzheng {
            width: 118px;
            padding-left: 7px;
        }

        .lg-cont-box input {
            background: rgb(250, 255, 189);
        }

        .form-cont > p {
            position: relative;
        }

        .form-cont > p > i {
            font-size: 18px;
            position: absolute;
            left: 13px;
            top: 18px;
            color: #a8a8a8;
        }

        .form-cont .lg-yzbox span {
            display: inline-block;
            margin-left: 15px;
        }

        .lg-login {
            display: block;
            width: 100%;
            height: 42px;
            margin-top: 9px;
            font-size: 18px;
            color: #fff;
            background: #ffb35b;
            line-height: 42px;
            text-align: center;
        }

        .lg-login:hover {
            color: #fff;
            cursor: pointer;
        }

        .form-cont input:focus + i {
            color: #39a5ff;
        }

        .login-new-box {
            position: absolute;
            right: 3px;
            height: 443px;
            top: 34px;
            width: 401px;
            padding: 0 58px;
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
        }

        .login-logo {
            text-align: center;
            margin: 60px 0 35px;
        }

        #tool-mes {
            line-height: 30px;
            height: 30px;
            color: red;
            font-size: 14px
        }

        #tool-mes span {
            font-size: 12px;
            margin-right: 5px
        }

        /*通知滚动*/

        .mBox-x {
            width:100%; height:40px; line-height:40px; overflow:hidden;background: rgb(250, 255, 189);
            /*-webkit-box-sizing: border-box;*/
            /*-moz-box-sizing: border-box;*/
            /*box-sizing: border-box;*/
            position: fixed;
            top: 0;
            /*默认不显示*/
            display: none;
            /*width: 100%;*/
            /*background: rgb(250, 255, 189);*/
            /*padding: 10px 0px;*/
            /*color: #000;*/
            /*z-index: 999;*/
            /*overflow:hidden;*/
        }


        .mBox-cont {
            width:100%; height:40px; line-height:40px; overflow:hidden;
            /*-webkit-box-sizing: border-box;*/
            /*-moz-box-sizing: border-box;*/
            /*box-sizing: border-box;*/
            position: fixed;
            padding-right: 4%;
            padding-left: 4%;
            /*width: 100%;*/
            /*background: rgb(250, 255, 189);*/
            /*padding: 10px 0px;*/
            /*color: #000;*/
            /*z-index: 999;*/
            /*overflow:hidden;*/
        }
        .mBox-x .mBox-close-x {
            position: absolute;
            right: 15px;
            top: 0px;
            display: inline-block;
            cursor: pointer;
            font-size: 16px;
            z-index: 999;
        }

        .mBox-cont-x{
            position:absolute; width:100%;

        }

        @media screen and (max-width:1000px) {
            .login-new-box {
                left: 50%;
                right: auto;
                margin-left: -200px;
            }
        }

        input::-ms-clear{display:none;}
        input::-ms-reveal{display:none;}
    </style>
    <script>
        if (window != top)
            top.location.href = location.href;
    </script>
    <script>
        function init(){
            initMq(document.getElementById("mq"));
            document.getElementById("mq").start();
        }
        function initMq(obj){
            var objs;
            //定义跑马灯对象的自定义属性
            obj.currentItem = -1;
            obj.loopDelay = 40;
            obj.loopItems = new Array();
            obj.loopTimer = null;
            //跑马灯的速度
            obj.speedX = 2;
            //定义跑马灯对象的自定义方法
            obj.loop = mq_loop;
            obj.start = mq_startLoop;
            obj.stop = mq_stopLoop;
            //定义跑马灯对象的事件
            obj.onmouseover = function(){ this.stop(); }
            obj.onmouseout = function(){ this.loop(); }

            //获取跑马灯对象的所有子元素
            objs = obj.getElementsByTagName("div");
            for(var i=0; i<objs.length; i++){
                //在loopItems属性中记录子元素
                obj.loopItems.push(objs[i]);
                //自定义子元素的属性和方法
                objs[i].index = i;
                objs[i].move = move;
                objs[i].reset = mq_reset;
                //初始化子元素的状态
                objs[i].reset();
            }
        }

        function move(x){
            this.style.left = x + "px";
        }

        function mq_loop(){
            var obj;
            clearTimeout(this.loopTimer);
            if(this.currentItem >= this.loopItems.length)
            {
                this.currentItem = 0;
            }
            obj = this.loopItems[0];

            //console.log(obj);

            var fontWidth = document.getElementById("labelText").offsetWidth;

//            console.log("this.speedX"+this.speedX);
//
//            console.log("fontWidth"+fontWidth);

            obj.offsetLeft = document.getElementById("mq").offsetWidth;

            //console.log("obj.offsetLeft"+obj.offsetLeft);

            if(obj.offsetLeft>=fontWidth){
                //向左卷动
                obj.move(obj.offsetLeft- this.speedX);
            }else {
                //重置该子元素
                obj.reset();
                this.currentItem++;
            }
            this.loopTimer = setTimeout("document.getElementById(\""+this.id+"\").loop()", this.loopDelay);
        }

        function mq_reset(){
            //console.log("重置");
            var fontWidth = document.getElementById("labelText").offsetWidth;
            var p = this.parentNode;
            //console.log(fontWidth);
            this.move(p.offsetLeft +p.offsetWidth+fontWidth);
        }

        function mq_startLoop(){
            for(var i=0; i<this.loopItems.length; i++)this.loopItems[i].reset();
            this.currentItem = 0;
            this.loop();
        }

        function mq_stopLoop(){
            clearTimeout(this.loopTimer);
        }

    </script>
</head>
<body onkeydown="on_return();" onload="init()">
<div id="mq1" class="mBox-x">
    <span class="mBox-close-x">×</span>
    <div id="mq" class="mBox-cont">
        <div id="notice" class="mBox-cont-x">
            <span id="labelText">${notice}</span>
        </div>
    </div>
</div>
<div class="lg-cont-box">
    <div class="login-new-box">
        <div class="login-logo">
            <img src="${ctx}/${loginLogo}">
        </div>
        <form id="form" method="post"
              onsubmit="return ajaxCheck();">
            <div class="form-cont">
                <!--替换placeholder文字-->
                <p>
                    <input id="userName" name="userName"
                           class="lg-usern validate_custem userName easyui-validatebox" style=""
                           required="true" placeholder="请输入用户名" type="text"
                           onblur="checkVal()"> <i class="tedufont tedu-icon50"></i>
                </p>

                <p>
                    <input id="password" name="password"
                           class="lg-pwd validate_custem password" placeholder="请输入登录口令"
                           type="password" onfocus="clearMeg()"> <i class="tedufont tedu-icon49"></i>
                </p>
                <div class="lg-yzbox" style="display: none">
                    <input placeholder="请输入验证码" class="last-yanzheng validate_custem"
                           type="text" id="validateCode" name="validateCode" required><span>
						<img src="validateCode" id="validate" style="cursor: pointer;"
                             onclick="refreshMe(this);" width="90" height="24"/>
					</span>
                </div>
                <div id="tool-mes">
                    <div style="display: none">
                        <span class="glyphicon glyphicon-exclamation-sign"></span><em
                            style="font-style: normal">${errorMsg }</em>
                    </div>
                </div>
                <span style="margin-top: 0" class="lg-login" onclick="logon()">登录</span>
            </div>
        </form>
    </div>
    <div style="height:560px;padding-top:540px;text-align: center">
        ${copyRight}
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function () {
        console.log(localDB.select("appStart"));
        if (localDB.select("appStart").length == 0) {
            localDB.createSpace("appStart");
            localDB.insert("appStart", {app: '${app}', ver: '${ver}', cid: '${cid}', uid: ''});
        }

        var notice = '${notice}';
        if (notice != '') {
            $(".mBox-x").show();
        }

        $('.mBox-close-x').click(function () {
            mq_stopLoop();
            $(this).parent().hide();
        });

        var errorMsg = '${errorMsg}';
        if (null != errorMsg && '' != errorMsg) {
            $("#tool-mes > div").show();
        }

    });

    //错误再输入密码时候不会提示
    function clearMeg() {
        $('#tool-mes>div').hide();
    }


    function logon() {
        var pswd = $('.password').val();
        var userName = $('.userName').val();
        ajaxPost("${ctx}/login", {
            password: pswd,
            userName: userName,
            validateCode: $("#validateCode").val()
        }, function (result) {
            if (result.data!=null&&result.data.userId!=undefined) {
                //登录成功存储uid
                localDB.update("appStart", {app: '${app}', ver: '${ver}', cid: '${cid}', uid: ''}, {
                    app: '${app}',
                    ver: '${ver}',
                    cid: '${cid}',
                    uid: result.data.userId
                });
                window.location.href = "${ctx}/";
            } else {
                $('#tool-mes>div').show();
                var errorMsg = $("#tool-mes em");
                errorMsg.text(result.msg);
                return;
            }
        });

    }

    function on_return() {
        if (event.keyCode == 13) {
            logon();
        }
    }

    var xWithScroll = 0;
    var yWithScroll = 0;

    function login_show_bg() {
        var login_bg = document.getElementById("crm_login_bg");
        if (login_bg) {
            login_bg.style.display = "block";
        }
    }

    function login_hide_bg() {
        login_bg.style.display = "none";
    }

    function refreshMe(obj) {
        obj.src = "validateCode?t=" + Math.random();
    }

    function ajaxCheck() {
        //如果是IE7或IE6,弹窗提示并打开google浏览器下载页面
        if (document.all) {
            if (navigator.userAgent.indexOf("MSIE 7.") > 0
                || navigator.userAgent.indexOf("MSIE 6.") > 0) {
                alert("IE版本太低，推荐使用谷歌chrome浏览器");
                window.open("http://www.google.cn/intl/zh-CN/chrome/browser/");
                return false;
            }
        }
        var userName = $("#userName");
        var uPwd = $("#pwd");
        var validateCode = $("#validateCode");
        var errorMsg = $("#tool-mes em");
        //初步页面校验
        if (userName.val() == '') {
            errorMsg.text("用户名不能为空！");
            $('#tool-mes>div').show();
            return false;
        } else if (uPwd.val() == '') {
            errorMsg.text("密码不能为空！");
            $('#tool-mes>div').show();
            return false;
        } else if (validateCode.val() == '') {
            errorMsg.text("验证码不能为空！");
            $('#tool-mes>div').show();
            return false;
        } else {
            login_show_bg();
            return true;
        }
    }


    function checkVal() {
        ajaxPost("${ctx}/getValidateStatus", {userName: $('.userName').val()}, function (result) {
            if (result.msg== 1) {
                $(".lg-yzbox").show();
            }
            else {
                $(".lg-yzbox").hide();
            }
        });
    }
</script>


<script type="text/javascript">


    function downloadJSAtOnload() {
        var element = document.createElement("script");
        element.src = "${ctx}/view/common/js/jquery-1.8.3.min.js";
        document.body.appendChild(element);
        element = document.createElement("script");
        element.src = "${ctx}/view/common/js/jquery-1.8.3.min.js";
        document.body.appendChild(element);
        element = document.createElement("script");
        element.src = "${ctx}/view/common/css/plugins/easyui-1.5.2/jquery.easyui.min.js";
        document.body.appendChild(element);
        element = document.createElement("script");
        element.src = "${ctx}/view/common/css/plugins/easyui-1.5.2/locale/easyui-lang-zh_CN.js";
        document.body.appendChild(element);
        element = document.createElement("script");
        element.src = "${ctx}/view/common/js/base.js";
        document.body.appendChild(element);
    }

    if (window.addEventListener) {
        window.addEventListener("load", downloadJSAtOnload, false);
    }
    else if (window.attachEvent) {
        window.attachEvent("onload", downloadJSAtOnload);
    }
    else {
        window.onload = downloadJSAtOnload;
    }
</script>
</body>
</html>
