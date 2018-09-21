function button1_onclick(){
	var id=getId();
	if(id){
		doEdit(id)
	} else {
		alert("没有选择id")
	}
}

// 取得当前dg选中行id
function getId(){
	try{
		var row = $('#dg').datagrid('getSelected');
		return row.userId;
	} catch (e){
		return "";
	}
}
//编辑弹出
function doEdit(id) {
		var url = 'http://localhost:8080/base-web/popupDemo?id=' + id;
		showPageDialog(url, '编辑demo', 400, 400, function() {
			$(this).dialog('destroy');//后面可以关闭后的事件  
		});
}

//dg初始化操作行
function opFormatter(val,row,index){
		var id = row.userId;
		var status = row.status;
		var statu;
		if(status=="可用"){
			statu='1';
		}else{
			statu='2';
		}
		return '&nbsp;<a href="#" onClick="doEdit(' + id +','+statu+ ')">[修改]</a>&nbsp;'
				+ '&nbsp;<a href="#" onClick="doDisable(' + id
				+ ')">[冻结]</a>&nbsp;'
				+ '&nbsp;<a href="#" onClick="doEnable(' + id
				+ ')">[解冻]</a>&nbsp;'
	}

	
	function showPageDialog(url, title, width, height,callback, shadow) {  //
	    var content = '<iframe src="' + url + '" width="100%" height="100%" style="padding: 0px;overflow:hidden;" frameborder="0" scrolling="no"></iframe>';  
	    var boarddiv = '<div id="tmpDlg" title="' + title + '"></div>'//style="overflow:hidden;"可以去掉滚动条  
	    $(document.body).append(boarddiv);  
	    var win = $('#tmpDlg').dialog({  
	        content: content,  
	        width: width,  
	        height: height,  
	        modal: arguments[5]?arguments[5]:true,   //默认为模式对话框
	        title: title,  
//	        buttons:[], //按钮在这里不设置否则会产生一个窄的灰色div
	        onClose:callback
	    });  
	    win.dialog('open');  
	    return win;
	} 