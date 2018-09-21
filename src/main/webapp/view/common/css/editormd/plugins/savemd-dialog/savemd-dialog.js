/*!
 * save MarkDown.md plugin for Editor.md
 *
 * @file        savemd-dialog.js
 * @author      hejk
 * @version     1.3.4
 * @updateTime  2017-11-24
 * {@link       https://github.com/pandao/editor.md}
 * @license     MIT
 */

(function() {

    var factory = function (exports) {

		var pluginName   = "savemd-dialog";

		exports.fn.savemdDialog = function() {
            var _this       = this;
            var cm          = this.cm;
            var lang        = this.lang;
            var editor      = this.editor;
            var settings    = this.settings;
            var cursor      = cm.getCursor();
            var selection   = cm.getSelection();
            var selection1  = cm.getSelection();
            var imageLang   = lang.dialog.mDsave;
            var classPrefix = this.classPrefix;
            var iframeName  = classPrefix + "mdSave-iframe";
			var dialogName  = classPrefix + pluginName, dialog;

			cm.focus();

            var loading = function(show) {
                var _loading = dialog.find("." + classPrefix + "dialog-mask");
                _loading[(show) ? "show" : "hide"]();
            };
			
			var guid   = (new Date).getTime();
			var action = settings.mdUploadURL + (settings.mdUploadURL.indexOf("?") >= 0 ? "&" : "?") + "guid=" + guid;
			var actionDoc = settings.docUploadURL+ (settings.docUploadURL.indexOf("?") >= 0 ? "&" : "?");
			var modeHandle = settings.modeHandleURL; 
			
			if (editor.find("." + dialogName).length > 0)
            {
                dialog = editor.find("." + dialogName);
                this.dialogShowMask(dialog);
                this.dialogLockScreen();
                dialog.show();
            }
            else
            {
            	if(modeHandle === 'Add'){
            		
            	}else if(modeHandle === 'Edit'){
            		//文件名
   				 	var fileTitle = settings.mdUploadURL.substring(settings.mdUploadURL.indexOf("&fileTitle=",0)+11,settings.mdUploadURL.length);
   				 	if(fileTitle === ''){
   				 		//新增窗口传值
   				 		selection = "";
   				 	}else{
   				 		selection = fileTitle;
   				 	}
            	}
            	 
            	 var dialogHTML = "<div class=\"" + classPrefix + "form\">" + 
                                        "<label>" + imageLang.alt + "</label>" + 
                                        "<input type=\"text\" value=\"" + selection + "\" data-alt />" +
                                        "<br/>" +
                                        "</div>";
            	 
                dialog = this.createDialog({
                    title      : imageLang.title,
                    width      : 380,
                    height     : 190,
                    content    : dialogHTML,
                    mask       : settings.dialogShowMask,
                    drag       : settings.dialogDraggable,
                    lockScreen : settings.dialogLockScreen,
                    maskStyle  : {
                        opacity         : settings.dialogMaskOpacity,
                        backgroundColor : settings.dialogMaskBgColor
                    },
                    buttons    : {
                        enter  : [lang.buttons.enter, function() {
                        	 var alt  = this.find("[data-alt]").val();
                        	 parent.flg=true;
                             if (alt === "")
                             {
                                 alert(imageLang.mdNameEmpty);
                                 return false;
                             }
 							var altAttr = (alt !== "") ? " \"" + alt + "\"" : "";
 							//_this.gotoLine(1); //指定行插入 （如果可以作为参数传递，可以不向md内追加文档名称的。）

                             //文档名称存放格式
 							//cm.replaceSelection("[文档名称:" + alt + "](" + altAttr + ")"+"\r\n");
 							//给父窗口隐藏控件text赋值
 							
                            this.hide().lockScreen(false).hideMask();
                            return false;
                        }],

                        cancel : [lang.buttons.cancel, function() {                                   
                            this.hide().lockScreen(false).hideMask();

                            return false;
                        }]
                    }
                });
                
                var fileInput  = dialog.find("[class=\"editormd-btn editormd-enter-btn\"]");
                
                var mdFileId = dialog.find("[data-mdfile]"); //存放返回fileID字段的值 
                
				fileInput.bind("click", function() {
					 var mdValue = _this.getMarkdown(); //md语法格式
					 var htmlMdValue = _this.getTextareaSavedHTML(); //html源码格式

					 var xhr = new XMLHttpRequest;
			    	 var dateTime = ((new Date).getTime());
			    	 var CRLF = "\r\n";
			    	 xhr.onreadystatechange=function(){
			    		 if(xhr.readyState ==4 && xhr.status ==200){
			    			 if(xhr.responseText ==0){
			    				 //alert("上传失败，请联系管理员查看.");
			    				 showSaved();
			    			 }else{
			    				 //alert("文件上传成功.接下来进行doc数据保存");
			    				 dialog.find("[data-mdfile]").val(xhr.responseText);
			    				 //文档表ID
			    				 var cataId = "";
			    				 if(modeHandle === 'Add'){
			    					 cataId = settings.mdUploadURL.substring(settings.mdUploadURL.indexOf("=",0)+1,settings.mdUploadURL.length);
			    				 }else{
			    					 cataId = ""; //修改时不传递cataID
			    				 }
			    				 var seMsg = xhr.responseText;
			    				 var xhr1 = new XMLHttpRequest;
			    				 dateTime = ((new Date).getTime());
						    	 xhr1.onreadystatechange=function(){
						    		 if(xhr1.readyState ==4 && xhr1.status ==200){
						    			 if(xhr1.responseText ==1){
						    				 //alert("上传成功.");
						    				 //showSaved();
						    				
											parent.$("#tmpSearcher").dialog("close");
						    			 }else{
						    				 showSaved();
						    				 //alert("上传失败，请联系管理员查看.");
						    			 }
						    		 }
						    	 };
						    	 //文档名称作为参数传递
						    	 xhr1.open("POST",actionDoc
						    			 +"&file_id=" + seMsg
						    			 +"&cata_id="+cataId
						    			 +"&file_name="+dialog.find("[data-alt]").val(),true); 
						    	 xhr1.setRequestHeader("Content-Type", "multipart/form-data;boundary=----"+dateTime);
						    	 var data ="";
						    	 xhr1.send(data);
			    			 }
			    			 //parent.$("#tmpSearcher").dialog("close");
			    		 }
			    	 };
			    	 //文档名称作为参数传递
			    	 xhr.open("POST",action+"&fileName="+dialog.find("[data-alt]").val(),true); 
			    	 xhr.setRequestHeader("Content-Type", "multipart/form-data;boundary=----"+dateTime);
			    	 //md content
			    	 var data =mdValue+CRLF;
			    	 xhr.send(data);
				});
            };
		}
    }
	// CommonJS/Node.js
	if (typeof require === "function" && typeof exports === "object" && typeof module === "object")
    {
        module.exports = factory;
    }
	else if (typeof define === "function")  // AMD/CMD/Sea.js
    {
		if (define.amd) { // for Require.js

			define(["editormd"], function(editormd) {
                factory(editormd);
            });

		} else { // for Sea.js
			define(function(require) {
                var editormd = require("./../../editormd");
                factory(editormd);
            });
		}
	}
	else
	{
        factory(window.editormd);
	}

})();

