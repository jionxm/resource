<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta charset="utf-8">
<title>播放</title>
	<link href="${ctx}/view/common/css/video-js.css" rel="stylesheet">	
	<style>
		body{background-color: #191919}
		.m{ width: 740px; height: 400px; margin-left: auto; margin-right: auto; margin-top: 100px; }
	</style>
</head>

<body>
<c:if test="${type}=='mp4'">
	<div class="m" width="100%" height="100%">
		<video id="my-video" class="video-js" controls preload="auto" 
		  poster="m.png" data-setup="{}">
			<source src="https://tedu-01-obs-14ac.obs.cn-north-1.myhwclouds.com/${url}" type="video/mp4">
			<p class="vjs-no-js">
			  To view this video please enable JavaScript, and consider upgrading to a web browser that
			  <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>
			</p>
		  </video>
		  <script src="${ctx}/view/common/js/video.min.js"></script>	
		  <script type="text/javascript">
			var myPlayer = videojs('my-video');
			videojs("my-video").ready(function(){
				var myPlayer = this;
				myPlayer.play();
			});
		</script>
	</div>
</c:if>
<c:if test="${type}=='pdf'">
<iframe src='https://tedu-01-obs-14ac.obs.cn-north-1.myhwclouds.com/${url}' width='100%' height='100%'></iframe> 
</c:if>
</body>
</html>
