//颜色数组
var itemStyle = {
    normal: {
        color: function (params) {
            // build a color map as your need.
            var colorList = [
                '#C1232B', '#B5C334', '#FCCE10', '#E87C25', '#27727B',
                '#FE8463', '#9BCA63', '#FAD860', '#F3A43B', '#60C0DD',
                '#D7504B', '#C6E579', '#F4E001', '#F0805A', '#26C0C0'
            ];
            return colorList[params.dataIndex]
        }
    }
}

var chart_hasChanged = [];

/*
 *
 * LoadData：装载数据
 * PackageData 打包数据
 * UnpackageData 恢复数据
 * SaveOption 保存条件
 * RestoreOption 恢复条件
 * GetIds
 * */
function loadChartData(panelName, url, param, setOption, ifyes, ifno) {
    var panel = eval(panelName);
    var chartData = eval(panelName + '_data');
    var originType = $("#" + panelName).attr("class");
    var initOption = eval(panelName + '_chartInitOption');
    var changedType = panel.getOption().series[0].type;
    if(chart_hasChanged[panelName]==undefined){
        chart_hasChanged[panelName]=false;
    }
    var type = originType;

    var keys = chartData.showKey;
    var hiddenKeys = chartData.hiddenKey;
    var allKeys = chartData.allKey;
    var showType = '';

    if (type == 'pieChart') {
        showType = 'pie';
    } else if (type == 'lineChart') {
        showType = 'line';
    } else {
        showType = 'bar';
    }

    if (changedType != undefined && showType != changedType) {
        chart_hasChanged[panelName] = true;
            type = changedType + "Chart";

    }

    //数据加载完之前先显示一段简单的loading动画
    panel.showLoading();
    ajaxPost(url, param, function (result) {
            if (result.data != null && result.data.total > 0) {
                if (type == 'pieChart') {
                    showType = 'pie';
                } else if (type == 'lineChart') {
                    showType = 'line';
                } else {
                    showType = 'bar';
                }
                var series = [];
                //取X轴数据，
                var names = new Array();

                //设置隐藏数据
                var hiddenDatas = [];
                var hiddenData = [];
                if (hiddenKeys.length > 0) {
                    $.each(hiddenKeys, function (i) {
                        var hiddenValues = [];
                        $.each(result.data.rows, function (index, obj) {
                            hiddenValues.push(obj[hiddenKeys[i]]);
                        });
                        hiddenData.push(hiddenValues);
                    });
                    if (type != "pieChart") {
                        hiddenDatas.push(hiddenData);
                    } else {
                        hiddenDatas.push({"key": hiddenData});
                    }
                }

                //准备数据

                if (keys.length == 2) {
                    var seriesData = [];
                    if (type == 'pieChart') {
                        $.each(result.data.rows, function (index, obj) {
                            names.push(obj[keys[0]]);
                            //一组数据
                            seriesData.push({
                                name: obj[keys[0]],
                                value: obj[keys[1]]
                            });
                        });
                        //饼图设置隐藏数据
                        seriesData.push(hiddenDatas);

                    } else if (type == "barChart") {
                        $.each(result.data.rows, function (index, obj) {
                            names.push(obj[keys[1]]);
                            seriesData.push(obj[keys[0]]);
                        });
                        seriesData.push(hiddenDatas);

                        ////console.log(seriesData);

                    } else {
                        $.each(result.data.rows, function (index, obj) {
                            names.push(obj[keys[0]]);
                            seriesData.push(obj[keys[1]]);
                        });
                        seriesData.push(hiddenDatas);
                    }

                    if (type == "barChart" || type == "columnChart") {
                        if(seriesData.length<=10){
                            series.push({
                                data: seriesData,
                                itemStyle: itemStyle,
                                type: showType,
                                barGap: '30%',
                                barCategoryGap: '20%',
                                barWidth:30
                            });
                        }else{
                            series.push({
                                data: seriesData,
                                itemStyle: itemStyle,
                                type: showType,
                                barGap: '30%',
                                barCategoryGap: '20%'
                            });
                        }

                    } else {

                        series.push({
                            data: seriesData,
                            type: showType

                        });
                    }
                } else {

                    //多组数据
                    $.each(result.data.rows, function (index, obj) {
                        names.push(obj[keys[0]]);
                    });
                    //实际设置数据,排除x轴数据
                    for (var k = 1; k < keys.length; k++) {
                        ////console.log(keys[k]);
                        var seriesData = new Object();
                        var value = new Array();
                        $.each(result.data.rows, function (index, obj) {
                            value.push(obj[keys[k]]);
                        });
                        seriesData.type = showType;
                        seriesData.data = value;
                        if (hiddenDatas.length > 0) {
                            seriesData.data.push(hiddenDatas);
                        }
                        ////console.log(seriesData);
                        series.push(seriesData);
                    }

                    panel.setOption(
                        {
                            xAxis: {
                                axisLabel: {
                                    interval: 0,//横轴信息全部显示
                                    rotate: 45,
                                    formatter: function (val) {
                                        var str = "";
                                        for (var i = 0, s; s = val[i++];) {//遍历字符串数组
                                            str += s;
                                            if (!(i % 10)) str += '\n';
                                        }
                                        return str; //横轴信息文字竖直显示
                                    }
                                }
                            }
                        }
                    );


                }

                if (chart_hasChanged[panelName]) {
                    //构造初始化option
                    var op = panel.getOption();
                    var changedInitOption = {
                        chartName: panelName,
                        title: op.title[0].text,
                        xName: op.xAxis[0].name,
                        yName: op.yAxis[0].name,
                        series: []
                    };
                    //console.log(changedInitOption);

                    var lengendStr = op.legend[0].data;

                    if (type == 'pieChart') {
                        panel.clear();
                        panel.setOption(getPieChartInitOption(changedInitOption))
                    } else if (type == 'lineChart') {
                        changedInitOption.lengend = op.legend[0].data;
                        var lineSeries = [];
                        $.each(lengendStr, function (i) {
                            lineSeries.push({
                                type: 'line',
                                name: [lengendStr[i]],
                                data: []
                            });
                        });
                        changedInitOption.series = lineSeries;
                        panel.clear();
                        panel.setOption(getLineChartInitOption(changedInitOption));
                    } else if (type == 'columnChart') {
                        changedInitOption.lengend = op.legend[0].data;
                        var columnSeries = [];
                        $.each(lengendStr, function (i) {
                            columnSeries.push({
                                type: 'bar',
                                barGap: '30%',
                                barCategoryGap: '20%',
                                name: [lengendStr[i]],
                                data: []
                            });
                        });
                        changedInitOption.series = columnSeries;
                        panel.clear();
                        panel.setOption(getColumnChartInitOption(changedInitOption));
                    }else if(type=='barChart'){
                        changedInitOption.lengend = op.legend[0].data;
                        var barSeries = [];
                        $.each(lengendStr, function (i) {
                            barSeries.push({
                                type: 'bar',
                                barGap: '30%',
                                barCategoryGap: '20%',
                                name: [lengendStr[i]],
                                data: []
                            });
                        });
                        changedInitOption.series = barSeries;
                        panel.clear();
                        panel.setOption(getBarChartInitOption(changedInitOption));
                    }
                    //console.log("切换过重新加载数据");

                    //console.log(panel.getOption());

                }

                //console.log(panel.getOption());
               // console.log(series);

//设置数据
                if (type == 'pieChart') {
                    panel.setOption({
                        legend: {
                            //动态图例(饼图特有)
                            data: names
                        }
                        ,
                        series: series

                    });
                } else if (type == 'lineChart') {
                    panel.setOption({
                        xAxis: [
                            {
                                data: names
                            }
                        ],
                        series: series
                    });
                } else if (type == 'columnChart') {
                    panel.setOption({
                        xAxis: [
                            {
                                data: names
                            }
                        ],
                        series: series
                    });
                } else if (type == 'barChart') {
                    panel.setOption({
                        yAxis: [
                            {
                                data: names
                            }
                        ],
                        series: series
                    });
                }
                panel.hideLoading();
                panel.resize();
            } else {
                //无数据塞入初始化Option
                panel.setOption(initOption);
                panel.hideLoading();


            }

            //console.log(panel.getOption());
            packageChartData(panelName);


        }
        ,
        function (res) {//error
            parent.showError(res.responseText);
            panel.hideLoading();
        }
    );

    if (ifyes) {
        ifyes();
    }
}


function packageChartData(chart) {
    //console.log("packageChartData开始..");
    if (chart != undefined) {
        var chartObj = eval(chart);
        var chartOptionInit = JSON.stringify(chartObj.getOption());

        setStorage(chart + "_chartOption", chartOptionInit);
    }
    //console.log(chartOptionInit);
}

function unPackageChartData(chart) {
    console.log("unPackageChartData开始..");
    if (chart != undefined && getStorage(chart + "_chartOption") != undefined) {
        var chartObj = eval(chart);
        var chartOption = JSON.parse(getStorage(chart + "_chartOption"));
        //chartObj.clear();
        chartObj.setOption(chartOption);
    }
}


function toolBoxOption(chartName, chartFromType) {

    var toolbox = {
        feature: {
            myTool1: {
                show: true,
                title: '切换为线状图',
                icon: 'path://M339.5 467.4L145.8 667.7l-83.2-82.2 271.6-284.4 282 266.3 254.5-295.6 89.7 77.3-337 387.7z',
                onclick: function () {
                    if (chartFromType == 'lineChart') {
                        unPackageChartData(chartName);
                    } else {
                        chartChangeType(chartName, chartFromType, 'lineChart');
                    }
                }
                // 图标颜色设置
                ,iconStyle:{
                    normal:{
                        color:'#d81e06',
                        borderWidth:0,
                        opacity:0.5
                    },
                    emphasis:{
                        color:'#d81e06',
                        borderWidth:0,
                        opacity:1
                    }
                }
            },
            myTool2: {
                show: true,
                title: '切换为柱状图',
                icon: 'ptah://M383.951 1023.87H639.92V0H383.951v1023.87z m383.95-767.901v767.901h255.969V255.969H767.901zM0 1023.87h255.969V511.938H0v511.932z m0 0',
                onclick: function () {
                    if (chartFromType == 'columnChart') {
                        unPackageChartData(chartName);
                        eval(chartName).setOption({
                            series: {
                                itemStyle: itemStyle
                            }
                        });
                    } else {
                        chartChangeType(chartName, chartFromType, 'columnChart');
                    }
                },iconStyle:{
                    normal:{
                        color:'#f4bd1c',
                        borderWidth:0,
                        opacity:0.5

                    },
                    emphasis:{
                        color:'#f4bd1c',
                        borderWidth:0,
                        opacity:1
                    }
                }
            },
            myTool3: {
                show: true,
                title: '切换为饼状图',
                icon: 'path://M486.2444 72.8023v444.309504c0 1.3097 0.4997 2.6214 1.4991 3.6198 1.0004 1.0004 2.3101 1.5002 3.6209 1.5002H949.7190400000001c0 238.0882-199.9575 421.3412-438.6222 421.3412-238.677 0-432.1485-186.5452-432.1485-424.6323C78.9484 280.8402 251.9009 72.8023 486.2444 72.8023z" fill="#1296db" /><path d="M542.422 44.713c238.6637 0 435.3853 183.253 435.3853 421.3402H547.542016c-1.3097 0-2.6214-0.4997-3.6198-1.4991-1.0004-1.0004-1.5002-2.3101-1.5002-3.6209V44.71296z',
                onclick: function () {
                    if (chartFromType == 'pieChart') {
                        eval(chartName).setOption({
                            xAxis: {
                                show: false
                            },
                            yAxis: {
                                show: false
                            }
                        });
                        unPackageChartData(chartName);
                    } else {
                        chartChangeType(chartName, chartFromType, 'pieChart');

                    }
                }
                    ,iconStyle:{
                        normal:{
                            color:'#1296db',
                            borderWidth:0,
                            opacity:0.5

                        },
                        emphasis:{
                            color:'#1296db',
                            borderWidth:0,
                            opacity:1
                        }
                    }

            },
            myTool4: {
                show: true,
                title: '切换为条状图',
                icon: 'path://M103.434343 108.606061h853.333334v175.838383H103.434343zM103.434343 418.909091h636.121213v175.838384H103.434343zM103.434343 713.69697h449.939394v175.838384H103.434343z',
                onclick: function () {
                    if (chartFromType == 'barChart') {
                        unPackageChartData(chartName);
                        eval(chartName).setOption({
                            series: {
                                itemStyle: itemStyle
                            }
                        });
                    } else {
                        chartChangeType(chartName, chartFromType, 'barChart');
                    }
                }
                ,iconStyle:{
                    normal:{
                        color:'#06e31f',
                        borderWidth:0,
                        opacity:0.5

                    },
                    emphasis:{
                        color:'#06e31f',
                        borderWidth:0,
                        opacity:1
                    }
                }

            }
        },
        right: '60',
    };
    return toolbox;
}


function chartChangeType(chartName, changeFromType, changeToType) {
    var initOption = eval('chartOption_'+chartName);
    var seriesData = new Object();
    var series = [];
    var names = [];
    var values = [];
    var xName = "";
    var yName = "";
    var legend = [];
    var chartObj = eval(chartName);
    //console.log("Chart切换");
    //console.log(getStorage(chartName + "_chartOption"));
    if (getStorage(chartName + "_chartOption") != undefined) {
        var chart = JSON.parse(getStorage(chartName + "_chartOption"));
        var title = chart.title[0].text;
        //如果没数据不转换，直接unPackage
        if (chart.series[0].data.length != 0) {
            var chartOption = {};
            if (changeToType == 'pieChart') {
                console.log("changeToPie...转换数据开始");
                if (changeFromType == 'barChart') {
                    //console.log(chart.series[0].data);
                    $.each(chart.yAxis[0].data, function (i, obj) {
                        names.push(obj);
                    });

                    xName = chart.yAxis[0].name;
                } else if (changeFromType == 'columnChart' || changeFromType == 'lineChart') {
                    $.each(chart.xAxis[0].data, function (i, obj) {
                        names.push(obj);
                    });
                    xName = chart.xAxis[0].name;
                }
                //console.log("切换饼图的数据");
                //console.log(chart.series[0].data);
                $.each(chart.series[0].data, function (i, obj) {
                    //console.log("所有数据");
                    //console.log(obj);
                    if (obj.constructor != Array) {
                        series.push({
                            name: names[i],
                            value: obj
                        });
                    } else {
                        //获取隐藏数据
                        series.push({"key": obj});
                    }
                });
                //console.log("changeToPie...转换数据结束");
                //console.log("changeToPie...构造Option开始");
                chartOption = {
                    xAxis: {
                        show: false
                    },
                    yAxis: {
                        show: false
                    },
                    title: {
                        text: title,
                        fontSize: 12,
                        subtext: '',
                        x: 'center'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                    },
                    grid: {
                        top: 60,
                        right: '20%'
                    },

                    toolbox: toolBoxOption(chartName, changeFromType),
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                        data: names
                    },
                    series: [
                        {
                            name: xName,
                            type: 'pie',
                            radius: '55%',
                            center: ['50%', '60%'],
                            data: series,
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]


                };
                //console.log("changeToPie...构造Option结束");
            } else if (changeToType == 'columnChart') {
                //console.log("changeToColumn...转换数据开始");
                if (chart.series.length > 1) {
                    ////console.log("多组数据");
                    ////console.log(chart.series);
                    //多组数据
                    $.each(chart.xAxis[0].data, function (i, obj) {
                        names.push(obj);
                    });
                    xName = chart.xAxis[0].name;
                    yName = chart.yAxis[0].name;
                    seriesData.name = xName;
                    legend = chart.legend[0].data;

                    $.each(chart.series, function (index, obj) {
                        seriesData = obj;
                        seriesData.type = "bar";
                        seriesData.barGap = '30%',
                            seriesData.barCategoryGap = '20%',

                            series.push(seriesData);
                    });

                    if(seriesData.data.length<=10){
                        seriesData.barWidth = 30;
                    }

                } else {

                    if (changeFromType == "pieChart") {
                        $.each(chart.legend[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.series[0].name;
                        yName = initOption.yName;

                    } else if (changeFromType == "lineChart") {
                        $.each(chart.xAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.xAxis[0].name;
                        yName = chart.yAxis[0].name;

                    }else if (changeFromType=='barChart'){
                        $.each(chart.yAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.yAxis[0].name;
                        yName = chart.xAxis[0].name;

                    }
                    $.each(chart.series[0].data, function (i, obj) {
                        values.push(obj);
                    });
                    legend.push(xName);
                    seriesData.type = 'bar';
                    seriesData.barGap = '30%';
                    seriesData.barCategoryGap = '20%';
                    seriesData.data = values;
                    seriesData.name = xName;
                    seriesData.itemStyle = itemStyle;
                    if(seriesData.data.length<=10){
                        seriesData.barWidth = 30;
                    }
                    series.push(seriesData);
                }
                //console.log("changeToColumn...构造Option开始");
                chartOption = {
                    title: {
                        text: title,
                        fontSize: 12
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data: legend
                    },

                    grid: {
                        left: '3%',
                        right: '10%',
                        bottom: '10%',
                        containLabel: true
                    },
                    toolbox: toolBoxOption(chartName, changeFromType),
                    xAxis: [
                        {
                            name: xName,
                            type: 'category',
                            axisLabel: {
                                interval: 0,
                                rotate:45,
                                formatter: function (val) {
                                    var str="";
                                    for(var i=0,s;s=val[i++];){//遍历字符串数组
                                        str+=s;
                                        if(!(i%10))str+='\n';
                                    }
                                    return str;
                                }
                            },
                            data: names
                        }
                    ],
                    yAxis: [
                        {
                            name: yName,
                            type: 'value'
                        }
                    ],
                    series: series
                };
                //console.log("changeToColumn...构造Option结束");
            }else if(changeToType=='barChart'){
                //console.log("changeToBar...转换数据开始");
                if (chart.series.length > 1) {
                    ////console.log("多组数据");
                    ////console.log(chart.series);
                    //多组数据
                    $.each(chart.xAxis[0].data, function (i, obj) {
                        names.push(obj);
                    });
                    xName = chart.xAxis[0].name;
                    yName = chart.yAxis[0].name;
                    seriesData.name = xName;
                    legend = chart.legend[0].data;

                    $.each(chart.series, function (index, obj) {
                        seriesData = obj;
                        seriesData.type = "bar";
                        seriesData.barGap = '30%',
                            seriesData.barCategoryGap = '20%',

                            series.push(seriesData);
                    });

                    if(seriesData.data.length<=10){
                        seriesData.barWidth = 30;
                    }

                } else {


                    if (changeFromType == "pieChart") {
                        $.each(chart.legend[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.series[0].name;
                        yName = initOption.yName;

                    } else if (changeFromType == "lineChart") {
                        $.each(chart.xAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.xAxis[0].name;
                        yName = chart.yAxis[0].name;

                    }else if(changeFromType=='columnChart'){
                        xName=chart.yAxis[0].name;
                        yName=chart.xAxis[0].name;
                        $.each(chart.xAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                    }
                    $.each(chart.series[0].data, function (i, obj) {
                        values.push(obj);
                    });
                    legend.push(xName);
                    seriesData.type = 'bar';
                    seriesData.barGap = '30%';
                    seriesData.barCategoryGap = '20%';
                    seriesData.data = values;
                    seriesData.name = xName;
                    seriesData.itemStyle = itemStyle;
                    if(seriesData.data.length<=10){
                        seriesData.barWidth = 30;
                    }
                    series.push(seriesData);
                }
                //console.log("changeToBar...构造Option开始");
                chartOption = {
                    title: {
                        text: title,
                        fontSize: 12
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data: legend
                    },

                    grid: {
                        left: '3%',
                        right: '10%',
                        bottom: '10%',
                        containLabel: true
                    },
                    toolbox: toolBoxOption(chartName, changeFromType),
                    xAxis: [
                        {
                            name: xName,
                            type: 'value'
                        }
                    ],
                    yAxis: [
                        {
                            name: yName,
                            type: 'category',
                            axisLabel: {
                                interval: 0,
                                rotate:45,
                                formatter: function (val) {
                                    var str="";
                                    for(var i=0,s;s=val[i++];){//遍历字符串数组
                                        str+=s;
                                        if(!(i%10))str+='\n';
                                    }
                                    return str;
                                }
                            },
                            data: names
                        }
                    ],
                    series: series
                };
            } else if (changeToType = 'lineChart') {
                //console.log("changeToLine...转换数据开始");
                if (chart.series.length > 1) {
                    //console.log("多组数据");
                    //console.log(chart.series);
                    //多组数据
                    if (changeFromType == 'barChart') {
                        $.each(chart.yAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.yAxis[0].name;
                        yName = chart.xAxis[0].name;
                        seriesData.name = yName;
                    } else if (changeFromType == 'columnChart') {
                        $.each(chart.xAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.xAxis[0].name;
                        yName = chart.yAxis[0].name;
                        seriesData.name = xName;
                    }
                    legend = chart.legend[0].data;

                    $.each(chart.series, function (index, obj) {
                        seriesData = obj;
                        seriesData.type = "line";
                        series.push(seriesData);
                    });


                } else {

                    if (changeFromType == 'barChart') {
                        //console.log(chart.series[0].data);
                        $.each(chart.yAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.yAxis[0].name;
                        yName = chart.xAxis[0].name;
                        seriesData.name = xName;
                        $.each(chart.series[0].data, function (i, obj) {
                            values.push(obj);
                        });
                        legend.push(xName);
                    } else if (changeFromType == 'columnChart') {
                        $.each(chart.xAxis[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.xAxis[0].name;
                        yName = chart.yAxis[0].name;
                        seriesData.name = xName;
                        $.each(chart.series[0].data, function (i, obj) {
                            values.push(obj);
                        });
                        legend.push(xName);
                    } else if (changeFromType == 'pieChart') {

                        $.each(chart.legend[0].data, function (i, obj) {
                            names.push(obj);
                        });
                        xName = chart.series[0].name;
                        yName = initOption.yName;
                        $.each(chart.series[0].data, function (i, obj) {
                            values.push(obj.value);
                        });
                        seriesData.name = xName;
                        legend.push(xName);
                    }

                    seriesData.type = 'line';
                    seriesData.data = values;
                    series.push(seriesData);

                }
                //console.log("changeToLine...转换数据结束");
                //console.log("changeToLine...构造Option开始");
                chartOption = {
                    title: {
                        text: title,
                        fontSize: 12
                    },
                    tooltip: {},
                    legend: {
                        data: legend
                    },
                    toolbox: toolBoxOption(chartName, changeFromType),
                    xAxis: {
                        type: 'category',
                        name: xName,
                        data: names,
                        axisLabel: {
                            interval: 0,//横轴信息全部显示
                            rotate:45,
                            formatter: function (val) {
                                var str="";
                                for(var i=0,s;s=val[i++];){//遍历字符串数组
                                    str+=s;
                                    if(!(i%10))str+='\n';
                                }
                                return str; //横轴信息文字竖直显示
                            }
                        }
                    },
                    //折线与柱图Grid一致
                    grid: {
                        left: '3%',
                        right: '10%',
                        bottom: '10%',
                        containLabel: true
                    },
                    yAxis: {
                        type: 'value',
                        name: yName
                    },
                    series: series
                };
                //console.log("changeToLine...构造Option结束");
            }
            //先清理原来Chart的设置
            chartObj.clear();
            //设置新的设置
            //console.log("新的option");
            //console.log(chartOption);
            chartObj.setOption(chartOption);
        }
    }


}

function getPieChartInitOption(chartOption) {
    var pieInitOption = {
        title: {
            text: chartOption.title,
            fontSize: 14,
            subtext: '',
            x: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        grid: {
            top: 60,
            right: '20%'
        },
        legend: {
            orient: 'vertical',
            left: 'left'
        },
        series: [
            {
                name: chartOption.xName,
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: [],
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }
        ],
        toolbox: toolBoxOption(chartOption.chartName, "pieChart")

    };
    return pieInitOption;
}


function getLineChartInitOption(chartOption) {
    var lineInitOption = {
        title: {
            text: chartOption.title,
            fontSize: 12
        },
        tooltip: {},
        legend: {
            data: chartOption.lengend
        },
        grid: {
            left: '3%',
            right: '10%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            name: chartOption.xName,
            boundaryGap: false
        },
        yAxis: {
            type: 'value',
            name: chartOption.yName
        },
        series: chartOption.series,
        toolbox: toolBoxOption(chartOption.chartName, "lineChart")
    };

    return lineInitOption;
}

function getBarChartInitOption(chartOption) {
    var barInitOption = {
        title: {
            text: chartOption.title,
            fontSize: 12
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
            }
        },
        legend: {
            data: chartOption.lengend
        },

        grid: {
            left: '3%',
            right: '10%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: [
            {
                name: chartOption.xName,
                type: 'value',
                data: []
            }
        ],
        yAxis: [
            {
                name: chartOption.yName,
                type: 'category',
                axisLabel: {
                    interval: 0
                },
                data: []
            }
        ],
        series: chartOption.series,
        toolbox: toolBoxOption(chartOption.chartName, "barChart")
    };

    return barInitOption;
}

function changeToPie(chartName,chartType){

}

function getColumnChartInitOption(chartOption) {
    var columnInitOption = {
        title: {
            text: chartOption.title,
            fontSize: 12
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
            }
        },
        legend: {
            data: chartOption.lengend
        },

        grid: {
            left: '3%',
            right: '10%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: [
            {
                name: chartOption.xName,
                type: 'category',
                axisLabel: {
                    interval: 0
                },
                data: []
            }
        ],
        yAxis: [
            {
                name: chartOption.yName,
                type: 'value',
                data: []
            }
        ],
        series: chartOption.series,
        toolbox: toolBoxOption(chartOption.chartName, "columnChart")
    };

    return columnInitOption;
}

