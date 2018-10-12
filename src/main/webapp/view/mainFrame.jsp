<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ include file="common/base.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>${baseTitle}</title>
    <link rel="shortcut icon" href="view/common/images/favicon.ico" type="image/vnd.microsoft.icon" />
    <style>
            .innerbox{
            overflow-x: hidden;
            overflow-y: auto;
            color: #000;
            font-size: .7rem;
            font-family: "\5FAE\8F6F\96C5\9ED1",Helvetica,"黑体",Arial,Tahoma;
            height: 100%;
        }
    .innerbox::-webkit-scrollbar {/*滚动条整体样式*/
            width: 4px;     /*高宽分别对应横竖滚动条的尺寸*/
            height: 4px;
        }
        .innerbox::-webkit-scrollbar-thumb {/*滚动条里面小方块*/
            border-radius: 5px;
            -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.2);
            background: #fafafa;
        }
        .innerbox::-webkit-scrollbar-track {/*滚动条里面轨道*/
            -webkit-box-shadow: inset 0 0 5px #2f4258;
            border-radius: 0;
            background: #2f4258;
        }
    </style>
</head>
<div id='Loading'
     style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#FFFFFF ;text-align:center;padding-top: 10%;">
    <h1 style="display: inline-block;border: 1px solid #95b9e7;font-size: 16px;padding: 5px;">
        <image src='${ctx}/view/common/css/plugins/easyui-1.5.2/themes/default/images/loading.gif'/>
        <font color="#15428B" size="2">正在处理，请稍等···</font></h1>
</div>
<body>
<input type="hidden" id="curUrl"></input>
<div class="js-test" style="">
    <div class="easyui-layout" fit="true">
        <div data-options="region:'north'" split="true" border="false" class="x-header">
            <div class="header-right">
                <input id="userId" hidden="hidden" value="${ sessionScope.userInfo.userId}"></input>

                <%--<p class="x-welcome">${ sessionScope.userInfo.userName}，欢迎您！</p>--%>
                <!--快捷菜单-->

                <p class="btn-group-header">
                    <c:forEach items="${quickMenuList}" var="quickMenu" varStatus="quickMenuStatus">
                    <span><a href="#"
                             onclick="openMenu('${quickMenu.name}','${ctx}${quickMenu.url}?token','${quickMenu.code}','${quickMenu.target}','quickMenu')">${quickMenu.name}</a></span>
                    <span>|</span>
                    </c:forEach>

                    <span><a onclick="logout()">安全退出</a></span>
                </p>

            </div>
            <div class="header-left" style="background:#299be4">
            <span class="tedu-logo"><img src="${ctx}/${logImg}" style="display:block;margin:12px auto"/></span>
            </div>
        </div>
      
        <div data-options="region:'west',title:'导航菜单'" style="left:-2px;top:49px;width:149px;height:650px">
            <div style="width: 100%;height:100%; overflow: hidden">
                <div id="nav_list" class="easyui-accordion" style="width:145px;height:640px;">
                    <c:forEach items="${menuParentList}" var="menu1">
                        <div class="x-accordion-cont innerbox" title="<img src='${ctx}/view/common/images/${menu1}.png'style='width:15px;height:12px;margin-right:8px;' >${menu1}" style="overflow:auto;">
                            <c:forEach items="${menuList}" var="menu2">
                                <c:if test="${menu1==menu2.parentName}">
                                    <p id="${menu2.code}"
                                       onclick="openMenu('${menu2.name}','${ctx}${menu2.url}?token','${menu2.code}','${menu2.target}','menu')">
                                            ${menu2.name}
                                    </p>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
      
        <div data-options="region:'center'" style="background:#fff;">
            <div data-options="tools:'#tab-tools'" id="center_tab" fit="true" class="easyui-tabs"
                 style="height: 100%;width:100%;">

            </div>
            <!--关闭按钮样式-->
            <div id="tab-tools">
                <a id="close_all" href="javascript:void(0)"
                   style="display: block;height: 20px;line-height: 20px;text-align: center;padding-top:3px;padding-right: 15px   "><img
                        src="${ctx}/view/common/images/close.png" style="vertical-align: middle" alt=""/><font
                        style="vertical-align: middle">&nbsp;关闭全部</font> </a>
            </div>
        </div>
    </div>
</div>
</div>
<script>
    $(document).ready(function () {
        openIndex();
        setStorage('appStartData', window.localDB.select("appStart"));
        setTimeout("openRedirect()", "1500");//为index tab延迟
    });
	//外部链接在系统内打开
    function openRedirect(){
    	var redirect = ${redirect};
    	if(redirect.msg){
    		window.top.location.href="${ctx}/404";
    	}else if(redirect.ui){
	    	$.messager.confirm("提示信息", '打开页面[' + redirect.name + ']?', function(r){
	    		if (r){
	    			//详情页
		    		if(redirect.id){
		    			setStorage('EditId', redirect.id);
		    		}
	    			//传参
		    		if(redirect.targetName){
		    			setEncodeParam(redirect.targetName,redirect.param);
		    		}
	    			openMenu(redirect.name,'${ctx}' + redirect.targetUrl,"-1",'tab','menu');//目前固定支持tab
	    		}
	    	});
       	}
    }

    function openIndex() {
        openMenu('${indexName}', '${ctx}${indexUrl}' + '?token', '${indexMenuCode}', '${indexTarget}', 'index')
    }

    function openMenu(name, url, code, openWay, type) {
        if (openWay == 'tab') {
            if (name == '') {
                addTab('首页', '', '', 'index');
            } else {
                addTab(name, url, code, type);
            }
        } else if (openWay == 'window') {
            openDialog(url, name)
        } else if (openWay == 'new' && currentUrl.split('/?').length > 1) {
            openNewWindow(url);
        }
    }

    var gloableStorage = {};
    var currentUrl = window.location.href;
    //修饰主页面地址导致界面刷新两次
    //     if (currentUrl.indexOf("?") > -1) {
    //         var targetUrl = currentUrl.split('/?')[0];
    //         setTimeout("window.location.href = targetUrl;", 1000);

    //     }
    var width;
    var height;
    var framepx1;
    var framepx2;
    if (isIE()) {
        framepx1 = 210;
        framepx2 = 10;
    } else {
        framepx1 = 133;
        framepx2 = 0
    }
    if (window.screen.width < 1200) {
        width = 1366;
    } else {
        width = document.documentElement.clientWidth + 17;
    }
    if (window.screen.height < 768) {
        height = 768;
    } else {
        height = document.documentElement.clientHeight
    }

    $(".js-test").width(width);
    $(".js-test").height(height);
    //以页签的方式打开菜单
    function addTab(title_, url_, id_, type) {
    	if(url_.indexOf("?")>0){
        	url_ = url_ + "&from=" + type + "&code=" + id_ + "&date=" + Date.parse(new Date());//这里加了随机数还缓存嘛？
    	}else{
    		url_ = url_ + "?from=" + type + "&code=" + id_ + "&date=" + Date.parse(new Date());//
    	}

        //判断是否有重名的tab页签，如果有，不在执行下面方法
        var exist = $('#center_tab').tabs('exists', title_);

        if (!exist) {
            if (type == 'index') {
                var content = '';
                if (url_ == '') {
                    content = '欢迎您，无首页';
                } else {
                    content = '<iframe  data-itemid="' + id_ + '"  frameborder="0"  src="' + url_ + '" style="width:100%;height:100%;"></iframe>';
                }
                $('#center_tab').tabs('add', {
                    title: title_,
                    content: content,
                    closable: false
                    //首页不能关闭
                });
            } else {
                //大于最小尺寸出滚动条目前1366*768分辨率下最小尺寸为1135*502
                var content = '';
                if (url_ == '') {

                    content = '欢迎您，无首页';
                } else {
                    content = '<iframe  data-itemid="' + id_ + '"  frameborder="0"  src="' + url_ + '" style="width:100%;height:100%;"></iframe>';
                }
                $('#center_tab').tabs('add', {
                    title: title_,
                    content: content,
                    closable: true

                });
            }
        } else {

            //已经存在切换焦点
            $('#center_tab').tabs('select', title_);
        }

        //var c1=parent.$('#center_tab').tabs('getSelected').find('iframe').get(0).contentWindow;
        //console.log(c1.$("#uiid").val());

    }

    //以对话框的方式打开页面
    function openDialog(url, uiName) {

        var content = '<iframe id="frmDlg" src="' + url + '&type=Popup" style="overflow:hidden;width:100%;height:100%;border:0;"></iframe>';
        var boarddiv = '<div id="tmpDlg" style="overflow:hidden;" title="' + uiName + '"></div>'// style="overflow:hidden;"可以去掉滚动条
        $(document.body).append(boarddiv);
        windowSize = '${windowSize}';
        var width;
        var height;
        width = windowSize.split("|")[0];
        height = windowSize.split("|")[1];
        var win = $('#tmpDlg').dialog({
            content: content,
            width: width,
            height: height,
            modal: true,   // 默认为模式对话框
            title: uiName

        });
        win.dialog('open');
        return win;
    }

    //以新页面的方式打开菜单
    function openNewWindow(url) {

        window.open(url);

    }

    function logout() {
    	layer.open({
    	    content: '您确定要退出系统吗？'
    	    ,btn: ['确定', '取消']
    	    ,yes: function(index){
    	      window.location.href = "${ctx}/logOut";
    	      layer.close(index);
    	    }
    	  });
    }


    $(function () {
        /*关闭所有tab标签*/
        $('#close_all').click(function () {
            $(".tabs li").each(function(index, obj) {
                //获取所有可关闭的选项卡
                var tab = $(".tabs-closable", this).text();
                $(".easyui-tabs").tabs('close', tab);
            });
            RefreshTab()
        });
        //初始化layout
        $('#easyui-layout').layout();
        //左侧菜单点击
        $('#nav_list .x-accordion-cont>p').click(function () {
            $(this).find("a").click();
        });


        //tab切换时左侧高亮
        $('#center_tab').tabs({
            border: false,
            selected: 0,
            onBeforeClose: function (title, index) {
                var curTabWin = null;
                var curTab = parent.$('#center_tab').tabs(index);
                if (curTab && curTab.find('iframe') && curTab.find('iframe').length > 0) {
                    curTabWin = curTab.find('iframe')[index].contentWindow;
                    for (var key in gloableStorage) {
                        try {
                            if (curTabWin.document.getElementById("code")) {
                                if (key.endsWith(curTabWin.$("#code").val() + "_backStorage_data") || key.endsWith(curTabWin.$("#code").val() + "_backStorage_option")) {
                                    delStorage(key);
                                }
                            }
                        } catch (err) {
                            return;
                        }
                    }

                }

                try {
                    if (curTabWin.document.getElementById("uiid") != null) {
                        //获取uiid清理token
                        var uiid = [curTabWin.$("#uiid").val()];
                        var param1 = {"ui": uiid};
                        ajaxPost("${ctx}/api/close", param1, function (res) {
                            console.log("clear token end");
                        })
                    }
                } catch (err) {
                    return;
                }
            },
            onSelect: function (title, index) {
                var id_ = $(this).find('.panel').filter(function () {
                    return !$(this).is(':hidden');
                }).find('iframe').attr('data-itemid');
                $('#nav_list .current').removeClass('current');
                var p_ = $('#nav_list p[id=' + id_ + ']');
                p_.addClass('current');
                var i_ = p_.closest('.panel').index();
                if (i_ != -1) {
                    $('#nav_list').accordion('select', i_);
                }
            }
        });
        $('#nav_list').accordion({
            onUnselect: function () {
                $(this).resize();
            }
        })
    });

    //刷新当前标签Tabs
    function RefreshTab() {
        var currentTab = $('#center_tab').tabs('getSelected');
        var url = $(currentTab.panel('options')).attr('href');
        $('#tabs').tabs('update', {
            tab: currentTab,
            options: {
                href: url
            }
        });
        currentTab.panel('refresh');
    }

    function closes() {
        $("#Loading").fadeOut("normal", function () {
            $(this).remove();
        });
    }

    var pc;
    $.parser.onComplete = function () {
        if (pc) clearTimeout(pc);
        pc = setTimeout(closes, 0);
    }
</script>
</body>
</html>