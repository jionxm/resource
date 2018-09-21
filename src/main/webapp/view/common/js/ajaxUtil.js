/**
 * 封装ajax请求
 *  app:"",
 *  ver:"",
 *  cid:"",
 *  uid:"",
 *  time:"",
 *  token:"",
 *  data:{},
 *  hmac:""
 */
function ajaxRequest(type, url, data, callback, error,loading, cache, isasync) {
	if(typeof(isasync)=="undefined"){
		isasync=true;
	} else {
		isasync=isasync;
	}
    //loading, cache,
    var ajaxConfig = {
        url: '',
        data: {},
        callback: null,
        error: null,//错误回调
        loading: true,
        cache: true,
        async: isasync
    };
    // 判断每一个参数url的类型
    // 如果是对象则是请求参数对象
    // 如果是字符串则是请求URL，参数和回调要继续检测后面的参数
    var token = data['token'];
    if((token==undefined || token=="") && url && 
    		(url.indexOf("login")<0 && url.indexOf("/api/close")<0 && url.indexOf("getValidateStatus")<0)){
//		showError("已拒绝未携带token的请求" + url);
    	console.log("已拒绝未携带token的请求" + url);
    	return;
    }
    delete data['token'];
    if (typeof url === 'string') {
    	//data code msg
    	var param = {
    			app:'',
    			ver:'',
    			cid:'',
    			uid:'',
    			wid:'',
    			pid:'',
    			time:getNowFormatDate(),
    			data:data,
    			hmac:''};

		//var defaultRequest = getStorage("defaultRequest");
    	try {

            var appStartData = getStorage("appStartData");
    		if(appStartData!=null&&appStartData.app!=""){
    			param['app'] = appStartData.app;
    		}
    		if(appStartData!=null&&appStartData.ver!=""){
    			param['ver'] = appStartData.ver;
    		}
    		if(appStartData!=null&&appStartData.cid!=""){
    			param['cid'] = appStartData.cid;
    		}
    		if(appStartData!=null&&appStartData.uid!=""){
    			param['uid'] = appStartData.uid;
    		}
    		if($("#uiid").val()){
    			param['wid'] = $("#uiid").val();
    		}
    		if($("#puid").val()){//parent
    			param['pid'] = $("#puid").val();
    		}    		
		} catch (e) {
			console.log(e.name + ": " + e.message);
		}
        ajaxConfig.url = url;
        ajaxConfig.data = param;
        ajaxConfig.callback = callback;
        ajaxConfig.error = error;
        ajaxConfig.loading = typeof(loading) === 'undefined' ? true : loading;
        ajaxConfig.cache = cache;
    } else {
        ajaxConfig = $.extend({}, ajaxConfig, url);
    }
    $.ajax({
        type: type,
        url: ajaxConfig.url,
        data: JSON.stringify(ajaxConfig.data),
        beforeSend: function(xhr) {
        	xhr.setRequestHeader("token",token);
        },
        dataType: 'json',
        cache: ajaxConfig.cache,
        async: ajaxConfig.async,
        contentType:"application/json",
        success: function(response) {
        	var code = response.code;
        	if(code==199){//session timeout
        		parent.location.reload();
        	}else if(code>=0){
	    		if(response.token){
	    			updateClientContext(response.token);
	    		}
	    		ajaxConfig.callback(response);
        	}else{
        		console.log("code="+code + " ,do nothing");
        	}
        },
        error:function (res) 
        { 
        	if (ajaxConfig.error){
        		ajaxConfig.error(res);
    		}else{
    			showError("未知异常,详情请查看错误日志");
    		}
        }
    })
}


function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var hour = date.getHours();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (hour <= 9) {
        strDate = "0" + hour;
    }    
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + hour + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}

function ajaxGet(url, data, callback, loading) {
    ajaxRequest('get', url, data, callback,error, loading, false);
}

function ajaxPost(url, data, callback,error, isasync) {
    ajaxRequest('post', url, data, callback,error,false,false, isasync);
}