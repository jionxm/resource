//app.title = '环形图';
var workinc=$("#workinc").text();
var openc=$("#openc").text();
var testc=$("#testc").text();
var resolvec=$("#resolvec").text();
var reopenc=$("#reopenc").text();
option = {
	//  tooltip: {
	//      trigger: 'item',
	//      formatter: "{a} <br/>{b}: {c} ({d}%)"
	//  },
	title:{
		text:"进展统计",
		left:"center",
		right:"center",
		top:"37%",
//		bottom:'center'
	},
	legend: {
		orient: 'horizontal',
		bottom: 0,
		itemWidth: 40,
		itemGap:30,
		align:"left",
	//	data:["打开","重新打开","处理中","已解决","测试中"]
	},
	series: [{
		name: '访问来源',
		type: 'pie',
		center:["50%","40%"],
		radius: ['35%', '50%'],
		label: {
			color: "black",
			emphasis: {
				show: true,
				textStyle: {
					fontSize: '20',
					fontWeight: 'bold'
				}
			},
			formatter:function(param){
				return param.data.value;
			}
		},
		labelLine: {
			lineStyle: {
				color: "black"
			}
		},
		data: [{
				value: openc,
				name: '打开'
			},
			{
				value: reopenc,
				name: '重新打开'
			},
			{
				value: workinc,
				name: '处理中'
			},
			{
				value: resolvec,
				name: '已解决'
			},
			{
				value: testc,
				name: '测试中'
			}
		]
	}]
};