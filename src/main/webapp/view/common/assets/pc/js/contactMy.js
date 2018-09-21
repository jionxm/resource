$("body").on("click",".feedback-close",function(){
    $(".feed").addClass("none");
    $(".in-short").removeClass("none");
    $(".feed-picture").addClass("none");
    $("#phone").val("");
    $("table").remove();
        var html='<table cellspacing="0px" id="feedback">'+
          '<tr>'+
            '<td class="feedback-project-name" height="78px">项目名称</td>'+
             '<td class="feedback-project-state" height="78px">项目状态</td>'+
           '<td height="78px" align="center">当前进度</td>'+
         '</tr>'+
        '</table>';
    $(".feedback-table").html(html);
})
$("body").on("click",".cehck-return",function(){
    $(".feed").removeClass("none");
})
//确定按钮
//$("body").on("click",".short-ok",function(){
//	if()
//    $(".feed-picture").removeClass("none");
//    $(".in-short").addClass("none");
//})

//联系我们

  
  var timers = 0;
  document.querySelector('#listBtn').addEventListener('click', function () {
    if (timers++ % 2 == 0) {
      document.querySelector('#list').setAttribute('style', 'display: block');
      document.querySelector('#listBtn').setAttribute('class', 'close-btn');
    } else {
      document.querySelector('#list').setAttribute('style', 'display: none');
      document.querySelector('#listBtn').setAttribute('class', 'btn');
    }
  });
