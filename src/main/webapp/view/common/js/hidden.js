function loadDataHidden(group,url,param, setOption, ifyes,ifno, sync) {
	if(typeof(group) == 'string'){
		group = $("#" + group);
	}else{
		group = group;
	}
	if(group.attr("class").indexOf("js-group")==-1)
		return;
	console.log("loadDataHidden开始..");
	var encodeParam = getEncodeParam(group.attr("name"));
	var storageData = getStorage(getPath(group)+"_backStorage_data");
	if(encodeParam){
		restoreGroupOption(group,ifyes, encodeParam,url,param);
//		delStorage(encodeParamKey);
		delEncodeParam(group.attr("name"));
	}else if (storageData) {
		restoreGroupOption(group,ifyes, storageData,url,param);
		delStorage(getPath(group)+"_backStorage_data");
	} else {
		ajaxQueryGroup(group, url, param, setOption, ifyes, sync)
	}
}
// 保存树数据
function packageHidden() {
	console.log("packagehidden开始..");
	$('.js-group').each(
			function() {
				setStorage(getPath($(this))+"_backStorage_data", $(this).find("input,hidden").serializeJson());
	});
}

function unpackageHidden(hidden) {
	console.log("unpackagehidden开始..");
	var storageData = getStorage(getPath($("#"+hidden))+"_backStorage_data");
	$("#"+hidden).form('load', storageData);
}
