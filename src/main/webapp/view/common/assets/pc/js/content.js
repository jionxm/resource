//分配给我的工作项
function check1(status){
			var assignee=$("#assignee").val();
			var assigneeName=$("#assigneeName").val();
			var rowIndex = 0;
			try{	
					var param ="{eq_assignee:"+assignee+",eq_issueStatus:"+"'"+$(status).attr("value")+"'"+",assigneeName:"+"'"+assigneeName+"'"+"}";//json string
					var paramObj = eval("(" + param + ")");
					setEncodeParam('pCondition',paramObj);
					transition();
			} catch (e) {
				console.log(e.name + ": " + e.message);
			}
		 }
//我发起的工作项
function check2(status){
	var reporter=$("#assignee").val();
	var reporterName=$("#assigneeName").val();
	var rowIndex = 1;
	try{	
			var param ="{eq_reporter:"+reporter+",eq_issueStatus:"+"'"+$(status).attr("value")+"'"+",reporterName:"+"'"+reporterName+"'"+"}";//json string
			var paramObj = eval("(" + param + ")");
			setEncodeParam('pCondition',paramObj);
			transition();
	} catch (e) {
		console.log(e.name + ": " + e.message);
	}
 }
function check3(status){
	var testDesignBy=$("#assignee").val();
	var testDesignByName=$("#assigneeName").val();
	var rowIndex = 0;
	try{	
			var param ="{eq_testDesignBy:"+testDesignBy+",eq_status:"+"'"+$(status).attr("value")+"'"+",testDesignByName:"+"'"+testDesignByName+"'"+"}";//json string
			var paramObj = eval("(" + param + ")");
			setEncodeParam('pnlGroup',paramObj);
			transition1();
	} catch (e) {
		console.log(e.name + ": " + e.message);
	}
 }
function check4(status){
	debugger;
	var testBy=$("#assignee").val();
	var testByName=$("#assigneeName").val();
	var rowIndex = 1;
	try{	
			var param ="{eq_testBy:"+testBy+",eq_status:"+"'"+$(status).attr("value")+"'"+",testByName:"+"'"+testByName+"'"+"}";//json string
			var paramObj = eval("(" + param + ")");
			setEncodeParam('pnlGroup',paramObj);
			transition1();
	} catch (e) {
		console.log(e.name + ": " + e.message);
	}
 }
function  transition() {
console.log("跳转到工作项管理");
		if(true){
			//返回需要记录跳转路径 做成数组 没跳转一次push back一次pop tab关闭时候清除storage 唯一标识为页面code和from
			eval('packageDatagrid();');
			setUIMode('frmIssueList', 'Edit') 			
			window.location.href = getTransitionUrl('', 'Transition', '013687d246f94992ab470cb2b76a84b5','Edit', 'menu', 25,'工作项列表', 'frmIssueList', '/ui/');	
		  }
	   }
function  transition1() {
	console.log("跳转到测试任务列表");
			if(true){
				//返回需要记录跳转路径 做成数组 没跳转一次push back一次pop tab关闭时候清除storage 唯一标识为页面code和from
				eval('packageDatagrid();');
				setUIMode('issueTestList', 'Edit') 			
				window.location.href = getTransitionUrl('', 'Transition', 'd15196c3a92c4831b277f6cba03e31ce','Edit', 'menu', 25,'测试任务列表', 'issueTestList', '/ui/');	
			  }
		   }