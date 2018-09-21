function unPackageWorkflowData(){

}
function loadWorkflowListData(panelName,res) {
    var tab = $('#workflowTab').tabs('getTab',0);// 取得第一个tab
    var title =tab.panel('options').title;
    if(res.data[0].total>0&&title.indexOf("(")<=-1) {
        $('#workflowTab').tabs('update', {
            tab: tab,
            options: {
                title: title + "(" + res.data[0].total + ")"
            }
        });
    }
    $("#undoTaskList").datagrid('loadData', res.data[0]);
    $("#doneTaskList").datagrid('loadData', res.data[1]);
    $("#completeTaskList").datagrid('loadData', res.data[2]);

}

function loadTransformWorkflowList(out, res){
    var tab = $('#workflowTab').tabs('getTab',0);// 取得第一个tab
	var title =tab.panel('options').title;
    if(res.data[0].total>0&&title.indexOf("(")<=-1) {
        $('#workflowTab').tabs('update', {
            tab: tab,
            options: {
                title: title + "(" + res.data[0].total + ")"
            }
        });
    }
    $("#undoTaskList").datagrid('loadData', res.data[0]);
    $("#doneTaskList").datagrid('loadData', res.data[1]);
    $("#completeTaskList").datagrid('loadData', res.data[2]);

}

function setOptionGrid(data, datagrid){

}

function getOptionGrid(datagrid){
    //私有方法

}