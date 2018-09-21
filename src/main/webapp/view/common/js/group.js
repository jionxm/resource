/*
 * 
 * LoadData：装载数据
 * PackageData 打包数据
 * UnpackageData 恢复数据
 * SaveOption 保存条件
 * RestoreOption 恢复条件
 * GetIds
 * */
function loadDataGroup(group,url,param, setOption, ifyes,ifno, sync) {
	if(typeof(group) == 'string'){
		group = $("#" + group);
	}else{
		group = group;
	}
	if(group.attr("class").indexOf("js-group")==-1)
		return;
	console.log("loadDataGroup开始..");
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
function restoreGroupOption(group,ifyes, storageData, url,param) {
	console.log("restoreGroupOption开始..");
	if($("#fromUi").val()!="menu")
	group.form('load', storageData);
	if(ifyes)
		ifyes();
}
// 保存树数据
function packageGroup() {
	console.log("packageGroup开始..");
	$('.js-group').each(
			function() {
				setStorage(getPath($(this))+"_backStorage_data", $(this).find("input,hidden").serializeJson());
	});
}

function unpackageGroup(group) {
	console.log("unpackageGroup开始..");
	var storageData = getStorage(getPath($("#"+group))+"_backStorage_data");
	$("#"+group).form('load', storageData);
}
function loadTransformGroup(out,res){
	$("#"+out).form('load',res.data);
}