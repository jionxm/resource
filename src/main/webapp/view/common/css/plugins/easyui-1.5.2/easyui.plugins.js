/**
 * jQuery EasyUI 1.5.2
 * 
 * Copyright (c) 2009-2017 www.jeasyui.com. All rights reserved.
 *
 * Licensed under the freeware license: http://www.jeasyui.com/license_freeware.php
 * To use it on other terms please contact us: info@jeasyui.com
 *
 */

$.extend($.fn.datagrid.methods, {
    showColumnSelector : function(jq, param) {
        var oGrid = $(jq);
    	var columnFields = oGrid.datagrid('getColumnFields');	// get unfrozen columns
    	var arr=new Array()
    	var columName = new Object();
    	var columWidth = new Object();
    	var columCheck = new Object();
    	columCheck.field="ck";
    	columCheck.checkbox=true;
    	arr.push(columCheck);
    	columName.field='displaytitle';
    	columName.title='列名';
    	columName.width=150;
    	columName.halign='center';
    	arr.push(columName);
    	columWidth.field='displaywidth';
    	columWidth.editor={type:'numberbox',options:{validType:'length[2,3]',required:true}};
    	columWidth.title='宽度';
    	columWidth.width=150;
    	columWidth.halign='center';
    	arr.push(columWidth);
    	var columns=JSON.stringify(arr);
    	var content='' 
		content+=' <table  class="easyui-datagrid" name="displayGrid" id="displayGrid" ' 
		content+='data-options=\'onDblClickCell:function(index,field,value){$(this).datagrid("beginEdit", index);},fit:true,singleSelect:true,selectOnCheck:false,checkOnSelect:false,toolbar:"#tb_displayBar",halign:"center",fitColumns:false,selectOnCheck:false,checkOnSelect:false,pagination:false,columns:['+columns+'],nowrap:false\'></table>';
    	content+='<div id="tb_displayBar" style="padding:5px;height:auto"><div style="margin-bottom:5px">';
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$(\'#displayGrid\').datagrid(\'checkAll\')">全选</a>  ';
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$(\'#displayGrid\').datagrid(\'clearChecked\')">取消全选</a>';
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="moveUp(\'displayGrid\')">上移</a>';	
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="moveDown(\'displayGrid\')">下移</a>';	
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="confirmDisplay(\'displayGrid\',\'csd\',\''+$(jq).attr("id")+'\')">确定</a>';	
    	content+='<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$(\'#csd\').dialog(\'close\')">取消</a></div></div>';	
    	var dlg = $("<div id='csd' />").dialog({
    	    title: '显示列',
    	    width: 350,
    	    height: 400,
    	    content:content,
    	    modal: true,
    	    onClose : function() {
                $(this).dialog('destroy');
            }
        });
    	//加载数据
		var rowdata=new Array();
    	$.each(columnFields, function (i, columnField) {
    		var fieldOptions = oGrid.datagrid("getColumnOption", columnField);
    		if(!fieldOptions.formatter&&fieldOptions.field!='ck'){
    			rowdata.push({displaytitle:fieldOptions.title,displaywidth:fieldOptions.width,field:fieldOptions.field});
    		}
    	});
		$("#displayGrid").datagrid('loadData', rowdata); 
		//设置勾选状态
		var displayData = $('#displayGrid').datagrid("getData");
    	$.each(columnFields, function (i, columnField) {
    		var fieldOptions = oGrid.datagrid("getColumnOption", columnField);
    		for(var j=0;j<displayData.rows.length;j++){
    			if(!fieldOptions.formatter&&fieldOptions.field!='ck'&&!fieldOptions.hidden&&columnField==displayData.rows[j].field){
    				$("#displayGrid").datagrid("checkRow",j);
    			}
    		}
    	});
    },
/**
 * 弹框数据导出
 */
exportData : function(jq, param) {
		var oGrid = $(jq);
		window.oGridHtml = oGrid.html();
        var jqId = $(jq).attr("id");
        window.SQLId = param.SQLId;
        window.InputPanel = param.InputPanelId;
        window.ctx = param.ctx;
        window.exportUrl = param.ctx+param.url;
        window.param = $("#"+InputPanel+" :input,hidden").serializeJson();
        window.token = param.token;
        window.tree = param.tree;
        window.title = param.title;
        if(param.tree != 'true'){
        	var columnFields = oGrid.datagrid('getColumnFields');	// get unfrozen columns
        	var columnDefineArray = [];
        	var checkedRow = [];
        	$.each(columnFields, function (i, columnField) {
        		var fieldOptions = oGrid.datagrid("getColumnOption", columnField);
        		fieldOptions.text = fieldOptions.title;
        		fieldOptions.value = columnField;
        		if (!fieldOptions.hidden) {
        			checkedRow.push(i);
        		}
        		columnDefineArray.push(fieldOptions);
        	});
        }
        //获取列描述数组用于构造dialog
    	var myBody;
    	var myDataList;
    	window.dlg = $("<div id='csd' style='overflow:hidden' class='js-dialog'/>").dialog({
            iconCls: 'icon-save',
			title:'导出数据',
			modal: true,   // 默认为模式对话框
			closed:false,
			width:500,
			height:400,
			content:
				"<iframe id='frmDlg2' src='"+ctx+"/view/exportData.jsp' style='overflow:hidden;width:100%;height:100%;border:0;'></ifram>",
			onOpen: function () {
				var fields ;
				debugger
				if(param.tree != 'true'){
					fields = oGrid.datagrid('getColumnFields');	// get unfrozen columns
				}else{
					var treetitle = new Array();
					treetitle[0] = {
							value:'id',
						    text:'树编号',
						    title:'树编号'
							};
					treetitle[1] = {
							value:'parent',
						    text:'父编号',
						    title:'树编号'
							};
					treetitle[2] = {
							value:'text',
						    text:'节点名称',
						    title:'节点名称'
							};
					fields = treetitle
				}
				window.columnFields = fields;
					var columnDefineArray = [];
					var checkedRow = [];
					var checkAll = new Map();
					checkAll.text = '全选/全不选';
					checkAll.value = '';
					columnDefineArray.push(checkAll);
					$.each(fields, function (i, columnField) {
						var options = new Array();
						if(param.tree != 'true'){
							fieldOptions = oGrid.datagrid("getColumnOption", columnField);
							checkedRow.push(i);
							if(!fieldOptions.hidden && fieldOptions.title!="操作" && fieldOptions.title!= undefined){
								options.text = fieldOptions.title;
								options.value = columnField;
								columnDefineArray.push(options);
							}
						}else{
							checkedRow.push(i);
							options = columnField;
							columnDefineArray.push(options);
						}
					});
					debugger
					window.columnDefine = columnDefineArray
					window.checked = checkedRow
					myBody = $(this).panel('body');//从dialog content中找到dataList
					myDataList = myBody.find('#dataList');//dataList句柄
					myDataList.datalist({
						lines: true,
						checkbox: true,
						selectOnCheck: false,
						data: columnDefineArray,
						onLoadSuccess: function () {
							$.each(checkedRow, function (i, rowIndex) {
								myDataList.datalist("checkRow", rowIndex);
							});
						}
					});
				

		},			
        });
    	
    	window.closeDialog1 = function(){}
}
});

$.extend($.fn.validatebox.defaults.rules, {  
    //验证汉字  
    CHS: {  
        validator: function (value) {  
            return /^[\u0391-\uFFE5]+$/.test(value);  
        },  
        message: '只能输入汉字'  
    },  
    //移动手机号码验证  
    mobile: {//value值为文本框中的值  
        validator: function (value) {  
            var reg = /^1[3|4|5|8|9]\d{9}$/;  
            return reg.test(value);  
        },  
        message: '输入手机号码格式不准确.'  
    }
})  
var myview = $.extend({},$.fn.datagrid.defaults.view,{
    onAfterRender:function(target){
        $.fn.datagrid.defaults.view.onAfterRender.call(this,target);
        var opts = $(target).datagrid('options');
        var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
        vc.children('div.datagrid-empty').remove();
        if (!$(target).datagrid('getRows').length){
            var d = $('<div class="datagrid-empty"></div>').html(opts.emptyMsg || '没有查询结果').appendTo(vc);
            d.css({
                position:'absolute',
                left:0,
                top:50,
                width:'100%',
                textAlign:'center'
            });
        }
    }
});
//datagird editor searchbox扩展
$.extend($.fn.datagrid.defaults.editors, {  
    searchbox: {  
        init: function(container, options){  
        	var index=$(options.datagrid).datagrid("getRowIndex",$(options.datagrid).datagrid("getSelected"));
        	if(options.required==true){
        		var input = $('<input class="easyui-searchbox" name="'+options.cName+'"required="true" id="'+options.pName+'_'+options.cName+
        	             '" searcher="'+options.searcher+'">').appendTo(container); 	
        	} else {
        		var input = $('<input class="easyui-searchbox" name="'+options.cName+'" id="'+options.pName+'_'+options.cName+
       	             '" searcher="'+options.searcher+'">').appendTo(container); 	
        	}
            input.searchbox(undefined);  
            return input;  
        },  
        destroy: function(target){  
            $(target).searchbox('destroy');  
        },  
        getValue: function(target){  
            return $(target).searchbox('getValue');  
        },  
        setValue: function(target, value){  
            $(target).searchbox('setValue', value);  
        },  
        resize: function(target, width){  
            var box = $(target).searchbox('textbox');//获取控件文本框对象
            box.attr('readonly', true);//禁用输入
            $(target).searchbox('resize',width);  
        }  
    }  
});  
$.extend($.fn.datagrid.defaults.editors, {  
	textBox: {
        init: function(container, options){  
        	var html='<input ';
        	if(options.jsFunctionName!=''){
        		html+='class="easyui-textbox '+options.css+'" validType='+options.jsFunctionName;
        	} else {
        		html+='class="easyui-textbox" '
        	}
        	if(options.required){
        		html+=' required="true" '
        	}
        	html+='>';
            var input = $(html).appendTo(container); 
            input.textbox(undefined);  
            return input;  
        },  
        destroy: function(target){  
            $(target).textbox('destroy');  
        },  
        getValue: function(target){  
            return $(target).textbox('getValue');  
        },  
        setValue: function(target, value){  
            $(target).textbox('setValue', value);  
        },  
        resize: function(target, width){  
            $(target).textbox('resize',width);  
        }  
    }
});  

$.extend($.fn.datagrid.defaults.editors, {  
filebox:{  
    init:function(container,options){
    	var fileIdx=$("").filebox('getIndex')+1;
    	var html="<input id=\"fileUploadId_"+fileIdx+"\" type=\"grid\" required="+options.required+" name=\""+options.name+"\" index="+fileIdx+" data-options=\"buttonText:'"+options.buttonText+"',prompt:'"+options.prompt+"',onClickButton:"+options.onClickButton+",onChange:"+options.onChange+"\"/>";
        var input=$(html).appendTo(container);  
        input.filebox(options);  
        return input;  
    },  
      
    getValue:function(target){  
       return $(target).filebox("getText");    

    },  
    destroy: function(target){  
        $(target).filebox('destroy');  
    },
    setValue:function(target,value){  
        $(target).filebox("setText",value);
//    	$(target).textbox("setValue",value);
    },  
    resize: function (target, width) {    
          var input = $(target);    
          if ($.boxModel == true) {    
              input.resize('resize', width - (input.outerWidth() - input.width()));    
          } else {    
              input.resize('resize', width);    
          }    
      }    
  
 }  
});  

var buttons = $.extend([], $.fn.datebox.defaults.buttons);
buttons.splice(1, 0,
{
    text: '清空',//按钮文本
    handler: function (target) {
        $("#"+ target.id+"" ).datebox('setValue', "");//根据ID清空
        $("#" + target.id + "").datebox('hidePanel', "");
    }
});
buttons.splice(1, 0,
		{
    text: '确定',//按钮文本
    handler: function (target) {
        var Calendar = $(target).datetimebox("calendar") ;   
        var date = Calendar.calendar("options").current ;  
        var month = date.getMonth()+1 ;  
        var day = date.getDate() ;  
        var comboTime = date.getFullYear() + "-"+ (month<10?('0'+month):month) + "-"+ (day<10?('0'+day):day) + " ";  
        if($(target).attr('class').indexOf('easyui-datetimebox')>-1){
        	var Spinner = $(target).datetimebox("spinner") ;  
        	var hour = Spinner.timespinner("getHours") ;  
        	var minute = Spinner.timespinner("getMinutes") ;  
        	var seconds = Spinner.timespinner("getSeconds") ;  
        	comboTime += (hour<10?('0'+hour):hour) + ":" + (minute<10?('0'+minute):minute) + ":" + (seconds<10?('0'+seconds):seconds);  
        }
        $(target).combo("setText",comboTime);//设置组合框文本
        $(target).combo("setValue",comboTime);//设置组合框文本
        $(target).combo("hidePanel");  
    }
});
function confirmDisplay(dg,dialog,dg2) {
	if(!acceptChangesGrid($('#'+dg))){
		return false;
	}
	var displayData = $('#'+dg).datagrid("getData");
	var columnFields = $('#'+dg2).datagrid("getColumnFields");
	var checkedDataArray = $('#'+dg).datagrid("getChecked");
	var showField = [];
	// 弹出层所有选择列
	$.each(checkedDataArray, function (i, checkedData) {
		showField.push(checkedData.field);
	});
	//设置宽度 排序 显示隐藏
	var options=$('#'+dg2).datagrid("options").columns[0];
	var dg2colum=new Array();
	for(var i=0;i<options.length;i++){
		var obj={title:options[i].title,width:options[i].width,formatter:options[i].formatter,field:options[i].field};
		dg2colum.push(obj);
	}
	var newdg2colun=new Array();
	// checkbox和操作列不坐处理
	for(var i=0;i<dg2colum.length;i++){
		if(dg2colum[i].formatter||dg2colum[i].field=='ck'){
			newdg2colun[i]=dg2colum[i];
		}
	}
	for(var i = 0; i < displayData.rows.length; i++) {
		for(var j = 0; j < dg2colum.length; j++) {
			if(dg2colum[j].field==displayData.rows[i].field){
				if ($.inArray(dg2colum[j].field,showField) == -1){
					dg2colum[j].hidden=true;
				}else {
					dg2colum[j].hidden=undefined;
				}
				dg2colum[j].width=$('#'+dg).datagrid('getRows')[i]['displaywidth'];
				newdg2colun.push(dg2colum[j]);
				break;
			}
		}	
	}
	var options=$('#'+dg2).datagrid("options").columns[0];
	for(var i=0;i<options.length;i++){
		if(!options[i].formatter&&options[i].field!='ck'){
			$('#'+dg2).datagrid("options").columns[0][i]=newdg2colun[i];
//			$('#'+dg2).datagrid("options").columns[0][i].hidden=newdg2colun[i].hidden;
		}
	}
	$('#'+dg2).datagrid();
	// 放入本地变量
    if (!localDB.select(getPath($('#'+dg2))+"_columnOption")||localDB.select(getPath($('#'+dg2))+"_columnOption").length==0) {
        localDB.createSpace(getPath($('#'+dg2))+"_columnOption");
        localDB.insert(getPath($('#'+dg2))+"_columnOption", newdg2colun);
    } else {
    	localDB.update(getPath($('#'+dg2))+"_columnOption", localDB.select(getPath($('#'+dg2))+"_columnOption"), newdg2colun);
    }
    
	$('#'+dialog).dialog('close');
}
