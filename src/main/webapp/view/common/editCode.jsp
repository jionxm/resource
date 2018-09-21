<%--
  Created by IntelliJ IDEA.
  User: yangjixin
  Date: 2017/12/18
  Time: 上午10:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="base.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title><c:if test="${title==''}">代码编辑器</c:if><c:if test="${title!=''}">${title}</c:if></title>
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/lib/codemirror.css">

    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/3024-day.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/3024-night.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/abcdef.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/ambiance.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/base16-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/bespin.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/base16-light.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/blackboard.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/cobalt.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/colorforth.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/dracula.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/duotone-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/duotone-light.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/eclipse.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/elegant.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/erlang-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/hopscotch.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/icecoder.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/isotope.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/lesser-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/liquibyte.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/material.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/mbo.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/mdn-like.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/midnight.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/monokai.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/neat.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/neo.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/night.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/panda-syntax.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/paraiso-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/paraiso-light.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/pastel-on-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/railscasts.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/rubyblue.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/seti.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/solarized.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/the-matrix.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/tomorrow-night-bright.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/tomorrow-night-eighties.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/ttcn.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/twilight.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/vibrant-ink.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/xq-dark.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/xq-light.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/yeti.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/theme/zenburn.css">

    <script src="${ctx}/view/common/js/ajaxfileupload.js"></script>

    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/addon/hint/show-hint.css">
    <link rel="stylesheet" href="${ctx}/view/common/js/codemirror-5.34.0/addon/dialog/dialog.css">
    <!-- 下面分别为显示行数、括号匹配和全屏插件 -->
    <script src="${ctx}/view/common/js/codemirror-5.34.0/lib/codemirror.js"></script>

    <script type="text/javascript"
            src="${ctx}/view/common/js/codemirror-5.34.0/addon/selection/active-line.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/edit/matchbrackets.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/edit/closetag.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/edit/closebrackets.js"></script>

    <!--自动提示插件-->
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/hint/show-hint.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/hint/xml-hint.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/hint/html-hint.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/hint/javascript-hint.js"></script>

    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/mode/xml/xml.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/mode/javascript/javascript.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/mode/css/css.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/mode/htmlmixed/htmlmixed.js"></script>

    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/search/search.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/search/searchcursor.js"></script>
    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/search/jump-to-line.js"></script>


    <script type="text/javascript" src="${ctx}/view/common/js/codemirror-5.34.0/addon/dialog/dialog.js"></script>
    　
    <style>
        .CodeMirror {
            border: 1px solid #eee;
            height: auto;
        }

    </style>
    <script>
        var codeMirrorEditor;

        function showEditor() {
            codeMirrorEditor = CodeMirror.fromTextArea(document.getElementById("editor"), {
                lineNumbers: true,     // 显示行数
                indentUnit: 4,         // 缩进单位为4
                styleActiveLine: true, // 当前行背景高亮
                matchBrackets: true,   // 括号匹配
                mode: '${mode}',     // HMTL混合模式
                theme: 'eclipse',      // 使用eclipse模版
                lineWrapping: true,    //自动换行
                extraKeys: {"Ctrl": "autocomplete"},
                value: document.documentElement.innerHTML

            });

            CodeMirror.commands.autocomplete = function (cm) {
                var doc = cm.getDoc();
                var POS = doc.getCursor();
                var mode = CodeMirror.innerMode(cm.getMode(), cm.getTokenAt(POS).state).mode.name;
                if (mode == 'xml') { //html depends on xml
                    CodeMirror.showHint(cm, CodeMirror.hint.html);
                } else if (mode == 'javascript') {
                    CodeMirror.showHint(cm, CodeMirror.hint.javascript);
                } else if (mode == 'css') {
                    CodeMirror.showHint(cm, CodeMirror.hint.css);
                }
            };


            codeMirrorEditor.on("inputRead", function () {
                //调用显示提示
                codeMirrorEditor.showHint();
            });

            $("#fileTypeName").combobox({
                onChange: function (n, o) {
                    if ($("#fileTypeName").val() == 'img') {
                        $("#imgFile").attr("style", "display:block;")
                        $("#txtFile").attr("style", "display:none;")
                    } else {
                        $("#txtFile").attr("style", "display:block;")
                        $("#imgFile").attr("style", "display:none;")
                    }

                }
            });


            $('#imgFileBox').filebox({
                buttonText: '选择文件',
                accept:'image/jpg,image/png,image/gif',
            });

        }


    </script>
</head>
<body onload="showEditor()">
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north'" style="height:45px;overflow:hidden;">
        <div class="btn-group" style="text-align: left;">
            <a style="margin-left: 10px" id="btnOpenProject" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="openFile()">打开</a>
            <a id="btnNewFile" style="" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="newFile()">新建</a>

            <a id="btnSaveFile" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="saveCode()">保存</a>

            <%--<a id="btnCutCode" style="margin-left: 10px"  class="easyui-linkbutton" href="javascript:void(0)"--%>
            <%--onClick="cutCode()">剪切</a>--%>

            <%--<a id="btnCopyCode"  class="easyui-linkbutton" href="javascript:void(0)"--%>
            <%--onClick="copyCode()">复制</a>--%>

            <%--<a id="btnPasteCode"  class="easyui-linkbutton" href="javascript:void(0)"--%>
            <%--onClick="pasteCode()">粘贴</a>--%>

            <a id="btnSearch" style="margin-left: 10px" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="searchCode()">查找</a>

            <a id="btnReplace" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="replaceCode()">替换</a>

            <a id="btnJump" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="jump()">跳转</a>

            <a id="btnRunFile" style="margin-left: 10px" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="runCode()">运行</a>

            <a id="btnHelp" style="float:right;margin-right: 10px" class="easyui-linkbutton" href="javascript:void(0)"
               onClick="openHelp()">帮助</a>

            <div style="float:right;margin-right: 10px;"><label>请选择主题：</label>
                <select class="easyui-combobox" id="selectTheme">
                    <option>default</option>
                    <option>3024-day</option>
                    <option>3024-night</option>
                    <option>abcdef</option>
                    <option>ambiance</option>
                    <option>base16-dark</option>
                    <option>base16-light</option>
                    <option>bespin</option>
                    <option>blackboard</option>
                    <option>cobalt</option>
                    <option>colorforth</option>
                    <option>dracula</option>
                    <option>duotone-dark</option>
                    <option>duotone-light</option>
                    <option selected>eclipse</option>
                    <option>elegant</option>
                    <option>erlang-dark</option>
                    <option>hopscotch</option>
                    <option>icecoder</option>
                    <option>isotope</option>
                    <option>lesser-dark</option>
                    <option>liquibyte</option>
                    <option>material</option>
                    <option>mbo</option>
                    <option>mdn-like</option>
                    <option>midnight</option>
                    <option>monokai</option>
                    <option>neat</option>
                    <option>neo</option>
                    <option>night</option>
                    <option>oceanic-next</option>
                    <option>panda-syntax</option>
                    <option>paraiso-dark</option>
                    <option>paraiso-light</option>
                    <option>pastel-on-dark</option>
                    <option>railscasts</option>
                    <option>rubyblue</option>
                    <option>seti</option>
                    <option>shadowfox</option>
                    <option>solarized dark</option>
                    <option>solarized light</option>
                    <option>the-matrix</option>
                    <option>tomorrow-night-bright</option>
                    <option>tomorrow-night-eighties</option>
                    <option>ttcn</option>
                    <option>twilight</option>
                    <option>vibrant-ink</option>
                    <option>xq-dark</option>
                    <option>xq-light</option>
                    <option>yeti</option>
                    <option>zenburn</option>
                </select>
            </div>
            <%--<div style="float:right;margin-right: 10px;margin-top: 5px">--%>
            <%--<label>是否开启自动完成：</label><input type="checkbox" id="autoCom">--%>
            <%--</div>--%>

        </div>
    </div>
    <div data-options="region:'west',split:true,collapsible:false" title="工程目录" style="width:20%;height:auto;">
        <ul id="codeTree" class="easyui-tree">
        </ul>
    </div>
    <div data-options="region:'center'" style="width: auto;height:auto;">
        <div class="easyui-panel" title="代码编辑" data-options="fit:true,border:false">

            <form id="editorForm" action="" method="post" enctype="multipart/form-data">
                <textarea id="editor" name="editor"></textarea>
                <input type="hidden" name="token" id="token" value="${token}"/>
                <input type="hidden" id="editorText" name="editorText" value=""/>
                <input type="hidden" id="rootCatalog" name="rootCatalog" value=""/>
                <input id="uniqueCode" type="hidden" name="uniqueCode"/>
            </form>
        </div>
    </div>


</div>
<div id="catalogChoose" closed="true" class="easyui-dialog" title="选取目录"
     style="width:500px;height:200px;padding:10px;">
    <div class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north'" style="width:100%;height:100%;overflow:hidden;">
            <div class="easyui-panel" title="" data-options="fit:true,border:false" style="padding:30px 50px;">

                <select style="margin-top: 10px;width:300px;" class="easyui-combobox" name="catalog" id="catalog"
                        label="目录"
                        labelPosition="left">
                    <c:forEach items="${catalogs}" var="f">
                        <option value="${f.path}">${f.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div data-options="region:'south'" data-options="border:false" style="height:45px">
            <div class="btn-group" data-options="border:false" style="text-align: right;">
                <a class="easyui-linkbutton" href="javascript:void(0)"
                   onClick="refreshTree()">确定</a>
                <a style="margin-right: 10px" class="easyui-linkbutton" href="javascript:void(0)"
                   onClick="closeCatalog()">取消</a>
            </div>
        </div>
    </div>
</div>

<div id="fileDiv" closed="true" class="easyui-dialog" title="新建文件"
     style="width:500px;height:200px;padding:10px;">
    <div class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north'" style="width:100%;height:100%;overflow:hidden;">
            <form id="auditForm">
                <div class="input-group-inline" style="margin-top: 10px">
                    <label>文件类型</label>
                    <select style="width:100px" class="easyui-combobox" id="fileTypeName">
                        <option value=".css">css</option>
                        <option value=".js">js</option>
                        <option value=".html">html</option>
                        <option value="img">img</option>
                    </select>

                </div>
                <div id="txtFile" style="display:block;" class="input-group-inline">
                    <label>文件名</label><input id="fileName" name="fileName" class="easyui-textbox"
                                             style="width:300px"
                                             labelPosition="left">
                </div>
                <div id="imgFile" style="display:none;" class="input-group-inline">
                    <label>上传文件</label>
                    <input class="easyui-filebox" id="imgFileBox" name="file1" data-options="prompt:'仅支持jpg,png,gif,大小100k以内的图片'"
                           style="width:300px">
                    <a class="easyui-linkbutton"  href="javascript:void(0)" onclick="uploadImgFile()">上传</a>
                </div>
            </form>
        </div>
        <div data-options="region:'south'" data-options="border:false" style="height:45px">
            <div class="btn-group" style="text-align: right;">
                <a class="easyui-linkbutton" href="javascript:void(0)"
                   onClick="saveFileName()">保存</a>
                <a style="margin-right: 10px" class="easyui-linkbutton" href="javascript:void(0)"
                   onClick="closeFileDiv()">取消</a>
            </div>
        </div>
    </div>
</div>
<div id="helpDiv" closed="true" class="easyui-dialog" title="帮助"
     style="width:650px;height:400px;padding:10px;">
    <table>
        <thead>
        <tr>
            <th style="text-align:left">Keyboard shortcuts (键盘快捷键)</th>
            <th style="text-align:left">说明</th>
            <th style="text-align:left">Description</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td style="text-align:left">Ctrl + X / Command + X</td>
            <td style="text-align:left">剪切</td>
            <td style="text-align:left">Cut</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + C / Command + C</td>
            <td style="text-align:left">复制</td>
            <td style="text-align:left">Copy</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + V / Command + V</td>
            <td style="text-align:left">粘贴</td>
            <td style="text-align:left">Paste</td>
        </tr>

        <tr>
            <td style="text-align:left">Ctrl + F / Command + F</td>
            <td style="text-align:left">查找/搜索</td>
            <td style="text-align:left">Start searching</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + G / Command + G</td>
            <td style="text-align:left">查找下一个</td>
            <td style="text-align:left">Find next</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + Shift + G / Command + Shift + G</td>
            <td style="text-align:left">查找上一个</td>
            <td style="text-align:left">Find previous</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + Shift + F / Command + Option + F</td>
            <td style="text-align:left">替换</td>
            <td style="text-align:left">Replace</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl + Shift + R / Command + Shift + Option + F</td>
            <td style="text-align:left">替换全部</td>
            <td style="text-align:left">Replace all</td>
        </tr>
        <tr>
            <td style="text-align:left">Alt + F</td>
            <td style="text-align:left">跳转</td>
            <td style="text-align:left">Jump to Line</td>
        </tr>
        <tr>
            <td style="text-align:left">Ctrl</td>
            <td style="text-align:left">自动提示</td>
            <td style="text-align:left">开启自动提示</td>
        </tr>
        </tbody>
    </table>

</div>
</div>
<script>

    var openProjectCnt = 0;
    var fileImgUploadSuccess=false;

    $('#btnOpenProject').linkbutton({
        //id : 'btn2',          //没搞明白干嘛用的,跟节点ID设置不一样值，在获取属性的时候报错
        //disabled : true,      //是否禁用
        //selected : true,      //默认是false  未选中状态
        group: 'sys',        //指定相同组名的按钮同属于一个组，可实现radio单选效果
        toggle: true,
        plain: true,           //默认false，设置true的时候显示简洁效果
        text: '打开工程',
        iconCls: 'icon-code-open',   //按钮图标 (参照icon.css中的样式),默认为null
        iconAlign: 'left'     //按钮图标位置 值为left或者right  默认left
    });
    $(window).bind('beforeunload', function () {
        return '您输入的内容尚未保存，确定离开此页面吗？';

    });

    $('#btnNewFile').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '新建文件',
        iconCls: 'icon-code-new',
        iconAlign: 'left'
    });

    $('#btnSaveFile').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '保存文件',
        iconCls: 'icon-code-save',
        iconAlign: 'left'
    });


    // $('#btnCutCode').linkbutton({
    //     toggle : true,
    //     plain : true,
    //     text : '剪切',
    //     iconCls : 'icon-code-cut',
    //     iconAlign : 'left'
    // });
    //
    // $('#btnCopyCode').linkbutton({
    //     toggle : true,
    //     plain : true,
    //     text : '复制',
    //     iconCls : 'icon-code-copy',
    //     iconAlign : 'left'
    // });
    // $('#btnPasteCode').linkbutton({
    //     toggle : true,
    //     plain : true,
    //     text : '粘贴',
    //     iconCls : 'icon-code-paste',
    //     iconAlign : 'left'
    // });

    $('#btnSearch').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '查找',
        iconCls: 'icon-code-search',
        iconAlign: 'left'
    });

    $('#btnReplace').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '替换',
        iconCls: 'icon-code-replace',
        iconAlign: 'left'
    });
    $('#btnJump').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '跳转',
        iconCls: 'icon-code-jump',
        iconAlign: 'left'
    });


    $('#btnRunFile').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '运行',
        iconCls: 'icon-code-run',
        iconAlign: 'left'
    });

    $('#btnHelp').linkbutton({
        group: 'sys',
        toggle: true,
        plain: true,
        text: '帮助文档',
        iconCls: 'icon-code-help',
        iconAlign: 'left'
    });


    var ctx = '${ctx}';

    function saveCode() {
        var token = $("#token").val();
        var editorText = codeMirrorEditor.getValue();
        var uniqueCode = $("#uniqueCode").val();
        var url = ctx + "/saveCode?token=" + token;
        $.ajax({
            url: url,
            type: 'post',
            data: {editorText: editorText, uniqueCode: uniqueCode},
            dataType: 'json',
            timeout: 1000,
            success: function (data) {
                if (data.msg == "1") {
                    $.messager.alert('操作提示', '保存成功');
                } else {
                    $.messager.alert('操作提示', '保存失败，请重新上传');
                }
            }
        })

    }

    function saveFileName() {
        var token = $("#token").val();
        var fileTypeName = $("#fileTypeName").val();
        var editorText = codeMirrorEditor.getValue();
        var uniqueCode = "";
        if ($("#uniqueCode").val().indexOf("/") != -1) {
            uniqueCode = $("#uniqueCode").val() + "/" + $("#fileName").val() + fileTypeName;
        } else {
            uniqueCode = $("#uniqueCode").val() + "\\" + $("#fileName").val() + fileTypeName;
        }


        if (fileTypeName != 'img') {
            var url = ctx + "/saveCode?token=" + token;
            $.ajax({
                url: url,
                type: 'post',
                data: {editorText: editorText, uniqueCode: uniqueCode},
                dataType: 'json',
                timeout: 1000,
                success: function (data) {
                    if (data.msg == "1") {
                        refreshTree();
                        $('#fileDiv').window('close');
                    } else {
                        $.messager.alert('操作提示', '新建失败，注意要输入文件后缀');
                    }
                }
            })
        } else {

            if (fileImgUploadSuccess) {
                refreshTree();
                $('#fileDiv').window('close');
            }else{
                alert("请上传文件！");
            }


        }
    }

    function closeFileDiv() {
        $('#fileDiv').window('close');
    }

    function openFile() {
        if (openProjectCnt == 0) {
            $('#catalogChoose').window('open');
            openProjectCnt++;
        } else if (confirm('您输入的内容尚未保存，确定离开此页面吗？')) {
            codeMirrorEditor.setValue("");
            $('#catalogChoose').window('open');
        }
    }

    function newFile() {
        if ($("#uniqueCode").val() == '') {
            $.messager.alert("新建", "请先选择目录！");
        } else if ($("#uniqueCode").val().indexOf(".") != -1) {
            $.messager.alert("新建", "不能选择文件，请选择目录新建");
        } else {
            $('#fileDiv').window('open');
        }
    }


    function refreshTree() {
        var catalog = $("#catalog").val();
        var param = {"catalog": catalog, "token": '${token}'};
        ajaxPost("${ctx}/codeTree", param, function (result) {
            if (result.data) {
                var cataData = eval(result.data);
                var data = cataData[0];
                $('#codeTree').tree({
                    data: [data],
                    onClick: function (node) {
                        var path = node.id;
                        var fileName = node.text;
                        var param = {"uniqueCode": path, "token": '${token}'};
                        $("#uniqueCode").val(path);
                        var filePaths = fileName.split(".");

                        var fileType = filePaths[filePaths.length - 1];
                        if (fileType == 'html' || fileType == 'js' || fileType == 'css') {
                            var mode = "";
                            if (fileType == 'html') {
                                mode = "xml";
                            } else if (fileType == 'css') {
                                mode = 'css';

                            } else {
                                mode = "javascript";

                            }

                            codeMirrorEditor.setOption("mode", mode);


                            if (path.indexOf(".")) {
                                ajaxPost("${ctx}/viewfile", param, function (result) {
                                    codeMirrorEditor.setValue(result.data);
                                });
                            }
                        }

                    }
                });

                $('#catalogChoose').window('close');
            }

        });
    }


    function runCode() {
        $("#rootCatalog").val($("#catalog").val());
        $("#editorText").val(codeMirrorEditor.getValue());
        console.log(codeMirrorEditor.getValue());
        console.log($("#editorText").val());
        var uniqueCode = $("#uniqueCode").val();
        if (uniqueCode == "") {
            alert("请选择文件再运行");
        } else {
            //保存
            //新窗口打开
            $("#editorForm").attr("enctype", "");
            $("#editorForm").attr("action", "${ctx}/runCode");
            //$("#editorForm").attr("action", "${ctx}/api/runcode");
            $("#editorForm").attr("target", "_blank");
            $('#editorForm').submit();
        }
    }

    //图片上传方法
    function uploadImgFile() {
       var uniqueCode =  $("#uniqueCode").val();
        var path = "";
        var accessType = "";
        var maxSize = 100*1024;
        var upfile = document.getElementById('filebox_file_id_2').files[0];
        if (uniqueCode.indexOf("/") != -1) {
            path = uniqueCode+"/";
        } else {
            path = uniqueCode+"\\" ;
        }
        debugger;
        if (upfile.name!=""){
            var fileNameContents = upfile.name.split(".");
            accessType = fileNameContents[fileNameContents.length - 1];
            if (upfile.size <= maxSize) {
                $.ajaxFileUpload({
                    url: '${ctx}/localUpload?token=' + token,
                    data: {"path": path, accessType: accessType, allowFile: "jpg,png,gif", maxSize: maxSize},
                    secureuri: false,
                    fileElementId: 'filebox_file_id_2',//file标签的id
                    dataType: 'json',//返回数据的类型
                    success: function (data) {
                        $.messager.alert('文件上传', data.msg);
                        fileImgUploadSuccess =true;
                    },
                    error: function (data) {
                        $.messager.alert('文件上传失败，请重新上传');
                        fileImgUploadSuccess = false;
                    }
                });
            } else {
                alert("图片应小于100k");
            }
        }else{
            alert("请选择要上传的文件！")
        }
    }

    function closeCatalog() {
        $('#catalogChoose').window('close');
    }

    function jump() {
        codeMirrorEditor.execCommand("jumpToLine");
    }

    function searchCode() {
        codeMirrorEditor.execCommand("find");
    }

    function replaceCode() {
        codeMirrorEditor.execCommand("replace");
    }


    function openHelp() {
        $('#helpDiv').window('open');
    }

    $(document).ready(function () {
        $('#selectTheme').combobox({
            onChange: function (param) {
                codeMirrorEditor.setOption("theme", param);
            }
        });


    });


</script>
</body>
</html>
