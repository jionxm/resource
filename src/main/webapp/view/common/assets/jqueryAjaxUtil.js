function getUiName(key, data, kName) {
  if (typeof(data) == "object" && Object.prototype.toString.call(data).toLowerCase() == "[object object]" && !data.length) {
    for (var k in data) {
      var item = data[k];
      if (item.tokenKey && item.tokenKey == key) {
        return kName;
      }
      var result = this.getUiName(key, item, k);
      if (result) {
        return result;
      }
    }
  }
  return false;
}

$.ajaxSetup({
  dataType: "JSON",
  contentType: 'application/json',
  cache: false,
  beforeSend: function(data) {
    // console.log('beforeSend data:' + JSON.stringify(data));
  },
  complete: function(xhr) {
    // console.log('complete');
    //token过期，则跳转到登录页面
    // if (xhr.responseJSON.code == 401) {
    //   parent.location.href = baseURL + 'login.html';
    // }
  }
});

function getToken(tokenKey, cb) {
	//console.log(API_PROXY+ '123456');
	//API_PROXY = "vipcoding";
	 //"http://localhost:8080/vipcoding"
  if (tokenKey) {
    var uiName = getUiName(tokenKey, APIS);
    //console.log(uiName);
    $.ajax({
      type: 'GET',
      url:  API_PROXY + '/ui/' + uiName + '/app',
      success: function(data) {;
        if (data && data.token && data.token.items) {
          var token = data.token.items[tokenKey];
          if (token) {
            cb(token);
          } else {
            console.log('------------------------token的UiName配置错误-------------------');
          }
        } else {
          console.log('------------------------token列表获取失败-----------------------');
        }
      }
    });
  } else {
    cb(null);
  }
}

function ajaxRequest(type, api, data, success, error) {
  var token = '';
  var url = api.url;
 //console.log(url);
  var tokenKey = api.tokenKey;
  //console.log(tokenKey);
  //console.log(API_PROXY);
  getToken(tokenKey, function(token) {
    var headers;
    if (token) {
      headers = {
        token: token
      };
    }
    
    $.ajax({
      type: type,
      url: API_PROXY + url,
      headers: headers,
      data: JSON.stringify({
        data: data
        
      }),
      success: success,
      error: error || function(e) {
         
      }
    
    });
  });
}

var ajaxPost = function(api,data,success, error) {
	//console.log(api);
	//console.log(data);
	//console.log(success);
	//console.log(error); 
  ajaxRequest('POST', api, data, success, error);
 
};

/*(function() {
  //匿名登录
  ajaxPost(APIS.loginAn, {}, function(data) {
	
    if (data.code == 101) {
      console.log('-----------------------匿名登录失败------------------------');
    }
  });
})();*/
