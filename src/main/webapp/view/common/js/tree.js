/*
 * 
 * LoadData：装载数据
 * PackageData 打包数据
 * UnpackageData 恢复数据
 * SaveOption 保存条件
 * RestoreOption 恢复条件
 * GetIds
 * */
function loadDataTree(tree,url,param, setOption, ifyes,ifno, sync) {
	console.log("loadDataTree开始..");
    if ($("#"+tree).attr("dataCheckBox") == "Y") {
        var checkbox = true;
    } else {
        var checkbox = false;
    }
    $("#"+tree).tree({
		checkbox : checkbox,
		multiple : true,
		data:null,
		loadFilter : function(data) {
			if(data.rows)
				return data.rows;
			else 
				return data;
		},
		onClick : function(node) {
			setStorage('selectTree', node);
			setPanelId($("#"+tree), node.id);
			id = node.id;
			eval($("#"+tree).attr("trigger"));
		},
		onSelect : function(node) {
			id = node.id;
		}
	});
	ajaxQueryTree($("#"+tree), url, param, setOption, ifyes, sync);
}
// getids用于获取多个选中时候的id
function getids(){
	//TODO
}
function setids(){
	//TODO
}
//保存树状态 back时和弹出层关闭刷新是调用
function getOptionTree(tree){
	console.log("getOptionTree开始..");
	var path=getPath($("#"+tree));
	if ($("#"+tree).tree('getSelected')) {
		setStorage(path+"_backStorage_option", $("#"+tree).tree('getSelected'));
		setStorage(path+"_backStorage_data", $("#"+tree).tree('getRoots'));
	} else {
		setStorage(path+"_backStorage_option" , getStorage('selectTree'));
	}
}
//恢复树状态
// 保存树数据
function packageTree() {
	console.log("packageTree开始..");
	$('.easyui-tree').each(
			function() {
				var path=getPath($(this));
				setStorage(path+"_backStorage_option", $(this).tree('getSelected'));
				setStorage(path+"_backStorage_data", $(this).tree('getRoots'));
			});

}

function unpackageTree(tree) {
	console.log("unpackageTree开始..");
	var path=getPath($("#"+tree));
	var storageRoot = getStorage(path+"_backStorage_data");
	if (storageRoot) {
		$('#'+tree).tree({
			data:storageRoot
		});
	}
}
// 私有方法，合并两颗树的属性 但是与extend js方法不同  恢复树状态
function setOptionTree(tree) {
	console.log("setOptionTree开始..");
	var path=getPath(tree);
	
	var storageData = getStorage(path+"_backStorage_data");
	var storageOption = getStorage(path+"_backStorage_option");
	if (storageData && storageOption) {
		// 设置展开状态以及选中状态 选中节点需要特殊处理
//		if (storageOption && storageOption.id == tree.tree('getRoots')[0].id) {
//			tree.tree('select', tree.tree('getRoots')[0].target);
//		} else {
			extend(tree, storageData, storageOption);
//		}
	}
}

//私有合并两个树的代码
function extend(tree, storageData, storageOption){
	var des = tree.tree('getChildren', tree.tree('getRoots')); // alert(childs.length);
	var flg = -1;
	var arr = new Array();
	for (var i = 0; i < des.length; i++) {
		for (var j = 0; j < storageData.length; j++) {
			if (des[i].id == storageData[j].id) {
				if (storageData[j].state == 'closed') {
					tree.tree('collapse', des[i].target);
				}
			}
		}
		if (storageOption&&storageOption.id == des[i].id) {
			flg = storageOption.id;
			tree.tree('select', des[i].target);
		}
		if(storageOption){
			arr[i] = Math.abs(des[i].id - storageOption.id);
		}
	}
	// 没有匹配到节点 选择最近节点
	if (flg == -1&&storageOption) {
		var max = arr[0];
		var min = arr[0];
		for (var i = 0; i < arr.length; i++) {
			if (arr[i] < min) {
				min = arr[i];
			}
		}
		
		var k = 0;
		for (var i = 0; i < arr.length; i++) {
			if (min == arr[i]) {
				k += i;
			}
		}
		if(des.length==k){
			console.log("最接近的树节点下标="+k);
			console.log("最接近的树节点id="+des[k-1].id);
			tree.tree('select', des[k-1].target);
			setPanelId(tree.attr('id'), des[k-1].id);
			setStorage('selectTree',tree.tree('find', des[k-1].id));
		} else {
			for (var i = 0; i < des.length; i++) {
				if(i==k){
					console.log("最接近的树节点下标="+k);
					console.log("最接近的树节点id="+des[i].id);
					tree.tree('select', des[i].target);
					setPanelId(tree.attr('id'), des[i].id);
					setStorage('selectTree',tree.tree('find', des[i].id));
					break;
				}
			}
		}
	}

}
function loadTransformTree(out, res){
	$("#"+out).tree('loadData', res.data.rows);
}