<html lang="en">

<head>
	<#assign ctx = request.contextPath />
   <#include "pc/common/base.ftl">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="theme-color" content="#000000">
    <title>资源列表</title>
    <link href="${ctx}/view/common/assets/pc/css/main.1672e1c4.css" rel="stylesheet" type="text/css">
    <style>
        .resource-left-content {
            width: 15%;
            height: auto;
            margin-top: 20px;
            float: left;
        }

        .resource-right-content {
            width: 85%;
            height: auto;
            float: left;
            padding: 30px 60px;
            margin-top: 20px;
        }

        .resource-tab {
            width: 100%;
        }

        .resource-tab li {
            width: 100%;
            height: 40px;
            line-height: 40px;
            font-size: 14px;
            color: #08c2fe;
            cursor: pointer;
            text-align: center;
            margin-bottom: 20px;
        }

        .resource-tab li.active {
            background-color: #0c344e;
            color: #ffffff;
        }

        .search-box {
            width: 400px;
            height: 33px;
            padding: 0 0 0 20px;
            margin: 0 auto;
            border: 1px solid #eee;
            border-radius: 20px;
        }

        .search-box .search-box-input {
            width: 300px;
            height: 30px;
            padding: 10px 0;
            float: left;
            border: none;
            outline: none;
        }

        .search-box .search-box-button {
            width: 60px;
            height: 30px;
            float: right;
            font-size: 12px;
            border-top-right-radius: 20px;
            border-bottom-right-radius: 20px;
            background-color: #0c344e;
            color: #ffffff;
        }

        .resource-list {
            width: 100%;
            margin-top: 40px;
        }

        .resource-list li {
            width: 100%;
            height: 100px;
            padding: 20px 10px 20px 60px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
        }


        .resource-list li .first-child {
            max-width: 70%;
            float: left;
        }

        .resource-list li .last-child {
            width: 30%;
            float: right;
        }

        .resource-list li h5 {
            font-size: 16px;
            margin-bottom: 5px;
            color: #333;
        }

        .resource-list li .prompt {
            line-height: 18px;
            color: #888;
            overflow: hidden;
            white-space: normal;
            word-wrap: normal;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .resource-list li .go-download {
            width: 30px;
            height: 30px;
            margin: 0 auto 5px;
            background: url(${ctx}/view/common/assets/pc/img/icon_resource_download.png) no-repeat center center;
            background-size: 100%; 
            cursor: pointer;
        }

        .resource-list li .resource {
            line-height: 18px;
            color: #888;
            text-align: center; 
        }

    </style>
</head>

<body style="background: #fff;">
    <div class="App">
        <div class="App-header clearfix">
            <img  src="${ctx}/view/common/assets/pc/img/icon_logo.png" style="width: 93px;position: relative;top: 6px;"></img>
            <span class="App-header-title">AI实验资源列表</span>
        </div>
        <div class="clearfix">
            <div class="resource-left-content">
                <ul class="resource-tab" id="resourceTab">
                    <li class="active"value="">所有文件</li>
                    <#list typeList as type>
                    <li value="${type.id}">${type.name}</li>
                    </#list>
                </ul>
            </div>
            <div class="resource-right-content">
                <div class="search-box">
                    <input class="search-box-input" type="text" id="name"placeholder="请输入您要搜索的资源名称"/>
                    <button class="search-box-button"id="search">搜索</button>
                </div>
                <input type="hidden" id="resourceType"/>
                <ul class="resource-list">
                <#list resourceList as resource>
                    <li style='background: url(${ctx}/localDownload?fileId=${resource.picId?c}) no-repeat 13px 20px;background-size: 40px 60px;'>
                        <div class="first-child">
                            <h5>${resource.name}</h5>
                            <div class="prompt">${resource.description}</div>
                        </div>
                        <div class="last-child">
                            <a href="${ctx}/localDownload?fileId=${resource.fileId?c}"><div class="go-download"></div></a>
                            <div class="resource">创建时间：${resource.createTime}</div>
                            <div class="resource">文件大小：${resource.length}kb</div>
                        </div>
                    </li>
				</#list>
                </ul>
            </div>
        </div>
    </div>
    <script>
        $(function(){

            /*左侧tab切换*/
            $("#resourceTab li").click(function(){
                $("#resourceTab li").removeClass("active");
                $(this).addClass("active");
            })

        })
        $("#search").click(function(){
        	var resourceType = $("#resourceType").val();
        	console.log(resourceType);
        	var name = $("#name").val();
        	ajaxPost(APIS.frmResDownList.query, 
	   				 {
	   				 	lk_name:name,
	   				 	eq_status:0,
	   				 	eq_resourceType:resourceType
	    			 }, function(data) {
    	    			console.log(data);
    	    			if(data.code==0){
    	    				$(".resource-list").find("li").remove();
    	    				var result=data.data.rows;
    	    				console.log(result);
    	    				for(var i = 0;i<result.length;i++){
    	    					var picId=result[i].picId;
    	    						console.log(picId);
    	    				var html="<li style='background: url(${ctx}/localDownload?fileId="+picId+") no-repeat 13px 20px;background-size: 40px 60px;'><div class='first-child'><h5>"
    	    						+result[i].name+
    	    						"</h5><div class='prompt'>"
    	    						+result[i].description+
    	    						"</div></div><div class='last-child'><a href='${ctx}/localDownload?fileId="
    	    						+result[i].fileId+
    	    						"'><div class='go-download'></div></a><div class='resource'>创建时间："
    	    						+result[i].createTime+"</div><div class='resource'>文件大小："+
    	    						result[i].length+"</div></div></li>";
    	    						$(".resource-list").append(html);
    	    				}
    	    			}
    	    			else{alert(data.msg);
    	    			}
    	    		}
    	    	);
        })
        $(".resource-tab li").click(function(){
        	var name = $("#name").val();
        	var retype=$(this).attr("value");
        	console.log(retype);
        	$("#resourceType").val(retype);
        	ajaxPost(APIS.frmResDownList.query, 
	   				 {
	   				 	eq_resourceType:retype,
	   				 	eq_status:0,
	   				 	lk_name:name
	    			 }, function(data) {
    	    			console.log(data);
    	    			if(data.code==0){
    	    				$(".resource-list").find("li").remove();
    	    				var result=data.data.rows;
    	    				console.log(result);
    	    				if(result.length>0){
    	    					for(var i = 0;i<result.length;i++){
    	    						var picId=result[i].picId;
    	    						console.log(picId);
    	    						var html="<li style='background: url(${ctx}/localDownload?fileId="+picId+") no-repeat 13px 20px;background-size: 40px 60px;'><div class='first-child'><h5>"
    	    							+result[i].name+
    	    							"</h5><div class='prompt'>"
    	    							+result[i].description+
    	    							"</div></div><div class='last-child'><a href='${ctx}/localDownload?fileId="
    	    							+result[i].fileId+
    	    							"'><div class='go-download'></div></a><div class='resource'>创建时间："
    	    							+result[i].createTime+"</div><div class='resource'>文件大小："+
    	    							result[i].length+"kb</div></div></li>";
    	    							$(".resource-list").append(html);
    	    						}
    	    			  		}
    	    			}
    	    			else{alert(data.msg);
    	    			}
    	    		}
    	    	);
        	}
        )
    </script>
    
</body>

</html>