//弹出修改密码弹层

$("body").on("click","#change-psd",function(){
    console.log("修改密码弹窗");
    $(".change-psd").removeClass("none");
})

//关闭修改密码弹层

$("body").on("click",".psd-canel",function(){
    $(".change-psd").addClass("none");
    $(".psd-check").addClass("none");
    $("input").val("");
})

//提交反馈

$("body").on("click",".psd-ok",function(){
    //显示提交弹层
    var psd1=$("#psd1").val();
    var psd2=$("#psd2").val();
    if(psd1==""||psd2==""){
        
    }else if(psd1!=psd2){
        
    }else if(psd1==psd2){

        $(".submit-psd").removeClass("none");
        $(".change-psd").addClass("none");
       
    }
})
 function close() {
            $(".submit-psd").delay(3000).addClass("none");
            window.location.reload();
        }
//密码监听

function check(){
    var psd1=$("#psd1").val();
    var psd2=$("#psd2").val();
    //console.log(psd1);
    //console.log(psd2);
    if(psd1==""||psd2==""){
        
    }else if(psd1!=psd2){
        $(".psd-check").removeClass("none");
    }else if(psd1==psd2){
        $(".psd-check").addClass("none");
    }
}