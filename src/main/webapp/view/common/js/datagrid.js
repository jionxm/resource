/*
 * 
 * LoadData：装载数据
 * PackageData 打包数据
 * UnpackageData 恢复数据
 * SaveOption 保存条件
 * RestoreOption 恢复条件
 * GetIds
 * */
function loadDataGrid(datagrid,url,param, setOption, ifyes,ifno, sync) {
	console.log("loadDataGrid开始..");
	ajaxQueryGrid($("#"+datagrid),url,param,setOption,ifyes, sync);
}
function setParamGrid(datagrid, param){
	if(getStorage(getPath($("#"+datagrid))+"_backStorage_option")){
		if(getStorage(getPath($("#"+datagrid))+"_backStorage_option").pageNumber==0){
			param.page=1;
		} else {
			param.page=getStorage(getPath($("#"+datagrid))+"_backStorage_option").pageNumber;
		}
		param.rows=getStorage(getPath($("#"+datagrid))+"_backStorage_option").pageSize;
	}
	$("#"+datagrid).datagrid('options').queryParams = param;
//	return param;
}
function getOptionGrid(datagrid){
	//私有方法
	if($("#"+datagrid).datagrid('getSelections')&&$("#"+datagrid).datagrid('getSelections').length>0||
			$("#"+datagrid).datagrid('getChecked')&&$("#"+datagrid).datagrid('getChecked').length>0){
		var dataGridOption=$("#"+datagrid).datagrid("options")
		dataGridOption.selected=$("#"+datagrid).datagrid('getSelections');
		dataGridOption.getChecked=$("#"+datagrid).datagrid('getChecked');
		setStorage(getPath($("#"+datagrid))+"_backStorage_option", dataGridOption);
	}
}
//恢复树状态
// 保存树数据
function packageDatagrid() {
	console.log("packageDatagrid开始..");
	$('.easyui-datagrid').each(
			function() {
				var dataGridOption=$(this).datagrid("options");
				dataGridOption.selected=$(this).datagrid('getSelections');
				setStorage(getPath($(this))+"_backStorage_option", dataGridOption);
				setStorage(getPath($(this))+"_backStorage_data", $(this).datagrid('getData'));
			});

}

function unpackageDatagrid(datagrid) {
	console.log("unpackageDatagrid开始..");
	var path=getPath($("#"+datagrid));
	var storageRoot = getStorage(path+"_backStorage_data");
	var option = getStorage(path+"_backStorage_option");
	if (storageRoot) { 
		if(option&&$('#'+datagrid).datagrid('getPager').length>0){
			$('#'+datagrid).datagrid('getPager').pagination("options").pageSize=option.pageSize;
			$('#'+datagrid).datagrid('getPager').pagination("options").pageNumber=option.pageNumber;
			$('#'+datagrid).datagrid('options').pageSize=option.pageSize;
			$('#'+datagrid).datagrid('options').pageNumber=option.pageNumber
		}
		$("#"+datagrid).datagrid('loadData', storageRoot);
		setOptionGrid(storageRoot, $("#"+datagrid));
	}
}
function acceptChangesGrid(datagrid){
	datagrid.datagrid('acceptChanges');
	var options = datagrid.datagrid("options").columns[0];
	var data = datagrid.datagrid("getData").rows;
	for(var j=0;j<data.length;j++){
		for(var i=0;i<options.length;i++){
			var ed = datagrid.datagrid('getEditor', {index:j,field:options[i].field});
			if(ed){
				$.messager.alert("校验失败",'校验失败', 'info', function(){
				});
				return false;
			}
		}
	}
	return true
}
//设置选中状态 私有方法
function setOptionGrid(data, datagrid){
	var storageOption = getStorage(getPath(datagrid)+"_backStorage_option");
	if(storageOption){
		var flg=-1;
		if(storageOption.selected&&storageOption.selected.length>0){
			for(var i=0;i<data.rows.length;i++){
				for(var j=0;j<storageOption.selected.length;j++){
					if(storageOption.selected[j].id==data.rows[i].id){
						var index = datagrid.datagrid("getRowIndex",data.rows[i])
						datagrid.datagrid("selectRow",index);
						flg=index;
					}
				}
			}
		}
		
		if(storageOption.getChecked){
			for(var i=0;i<data.rows.length;i++){
				for(var j=0;j<storageOption.getChecked.length;j++){
					if(storageOption.getChecked[j].id==data.rows[i].id){
						datagrid.datagrid("checkRow",i);
						flg = i;//7588 fix
					}
				}
			}
		}
		if(storageOption.sortName)
		datagrid.datagrid("options").sortName=storageOption.sortName;
		if(storageOption.sortOrder)
		datagrid.datagrid("options").sortOrder=storageOption.sortOrder;
//		if(flg==-1){
//			datagrid.datagrid("selectRow",0)
//			datagrid.datagrid("checkRow",0)
//		}
	}
}

function loadGridRow(grid, data){
	var index=grid.datagrid('getRowIndex', grid.datagrid('getSelected'))
	var row = grid.datagrid("selectRow", index).datagrid("getSelected");
	for(var i in data){
		row[i] = data[i];
	}
	grid.datagrid('refreshRow', index);
	grid.datagrid('beginEdit', index);
}
function loadTransformGrid(out, res){
	$("#"+out).datagrid({
		loader : function(param, success, error) {
			success(res.data);
//			$("#"+out).datagrid('loaded');
			
		}
	})
}