function ajaxQueryGrid(datagrid,url,param,setOption,ifyes, sync) {
	datagrid.datagrid('loading');
	if (localDB.select(getPath(datagrid)+"_columnOption")&&localDB.select(getPath(datagrid)+"_columnOption").length>0) {
		var options=datagrid.datagrid("options").columns[0];
		for(var i=0;i<options.length;i++){
			if(!options[i].formatter&&options[i].field!='ck'){
				options[i].width=localDB.select(getPath(datagrid)+"_columnOption")[i].width;
				options[i].hidden=localDB.select(getPath(datagrid)+"_columnOption")[i].hidden;
			}
		}
	} 
	datagrid.datagrid({
		loader : function(param, success, error) {
			ajaxPost(url, param, function(res) {
				var $getPager = datagrid.datagrid('getPager');
				if(datagrid.datagrid("options").queryParams.rows){
					var pageSize =datagrid.datagrid("options").queryParams.rows;
//					datagrid.datagrid('options').pageSize=pageSize;
					datagrid.datagrid('getPager').pagination("options").pageSize=pageSize;
				} 
				if(datagrid.datagrid("options").queryParams.page){
					var pageNo =datagrid.datagrid("options").queryParams.page;
//					datagrid.datagrid('options').pageNumber=pageNo;
					datagrid.datagrid('getPager').pagination("options").pageNumber=pageNo;
				} 
				if(res.code!=0){
					console.log(res.msg);
				}
				if (res.data && res.data.rows) {
					success(res.data);

					datagrid.datagrid('loaded');
					if (setOption) {
						eval(setOption + '(res.data, datagrid)')
					}
				}
				gobranchSync(sync, ifyes);
			});
		}
	});
	gobranch(sync, ifyes);
}
function ajaxQueryTree(tree, url, param, setOption, ifyes,sync) {
	ajaxPost(url,param,function(res){
		tree.tree('loadData',res.data);
		if (setOption) {
			eval(setOption + '(tree)')
		}
		gobranchSync(sync, ifyes);
	});
	gobranch(sync, ifyes);
}
function ajaxQueryGroup(group, url, param, setOption, ifyes, sync) {
	ajaxPost(url,param,function(res){
		group.form('load',res.data);
		if (setOption) {
			eval(setOption + '(group)')
		}
		gobranchSync(sync, ifyes);
	});
	gobranch(sync, ifyes);
}
function gobranch(sync, ifyes){
	if (sync == "N" && ifyes) {
		ifyes();
	}
}
function gobranchSync(sync, ifyes){
	if((!sync||sync=="Y") && ifyes){
		ifyes();
	}
}

