var Judge = function (a1, op, a2) {
    switch (op) {
        case 'IsEq':
            return a1 == a2;
            break;
        case 'IsGe':
            return a1 >= a2;
            break;
        case 'IsGt':
            return a1 > a2;
            break;
        case 'IsLe':
            return a1 <= a2;
            break;
        case 'IsLt':
            return a1 < a2;
            break;
        case 'IsNeq':
            return a1 != a2;
            break;

    }

}

var MathOperation = function (a1, op, a2) {
    switch (op) {
        case 'Add':
            return a1 + a2;
            break;
        case 'Sub':
            return a1 - a2;
            break;
        case 'Mul':
            return a1 * a2;
            break;
        case 'Div':
            return a1 / a2;
            break;
        case 'Mod':
            return a1 % a2;
            break;
    }
}

var LogicOperation = function (a1, op, a2) {
    switch (op) {
        case 'OR':
            return a1 || a2;
            break;
        case 'AND':
            return a1 && a2;
            break;
        case 'NOT':
            return !a1;
            break;

    }
}



var Contain = function (s1, s2) {
    return getPanelControlValue(s1).contains(s2);
}

var Length = function (s) {

    return getPanelControlValue(s).length;
}


var StartsWith = function (s1, s2) {
    return getPanelControlValue(s1).startWidth(s2);
}


var Substring = function (s, begin, end) {
    return getPanelControlValue(s).substring(begin, end);
}

var IndexOf = function (s1, s2) {
    return getPanelControlValue(s1).indexOf(s2);
}

var LowerCase = function (s) {
    return getPanelControlValue(s).toLowerCase();
}

var UpperCase = function (s) {
    return getPanelControlValue(s).toUpperCase();
}

var CheckPasswordStrength = function (s) {
    var reg = /^([a-z0-9A-Z]+[-|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$/;
    return reg.test($.trim(s));
}


$.extend($.fn.validatebox.defaults.rules, {
    CheckEmail: {
        validator: function (value, param) {
            var reg = /^([a-z0-9A-Z]+[-|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$/;
            return reg.test($.trim(value));
        },
        message: '请检查Email格式是否正确'
    },

    CheckChinese: {
        validator: function (value, param) {
            var reg = /[(\u4e00-\u9fa5)]{0,}$/;
            return reg.test($.trim(value));
        },
        message: '请检查是否全部字符为中文格式'
    },
    CheckIdCard: {
        validator: function (value, param) {
            var reg = /(^\d{18}$)|(^\d{15}$)/;
            return reg.test($.trim(value));
        },
        message: '请检查身份证号格式是否正确'
    },

    CheckMobile: {
        validator: function (value, param) {
            var reg = /1(3|5|7|8)[0-9]{9}/;
            return reg.test($.trim(value));
        },
        message: '请检查手机号格式是否正确'
    },
    CheckPhone: {
        validator: function (value, param) {
            var reg = /^(0[0-9]{2,3}\/-)?([2-9][0-9]{6,7})+(\/-[0-9]{1,4})?$/;
            return reg.test($.trim(value));
        },
        message: '请检查电话号码格式是否正确'
    },

    CheckURL: {
        validator: function (value, param) {
            var regx = new RegExp("http(s)?:/([\\w-]+\\.)+[\\w-]+(\\/[\\w- ./?%&=]*)?");
            return regx.test($.trim(value));
        },
        message: '请检查URL格式是否正确'
    },
    CheckPostCode: {
        validator: function (value, param) {
            var reg = new RegExp("[1-9]{1}(/d+){5}");
            return reg.test($.trim(value));
        },
        message: '请检查邮编格式是否正确'
    },
    CheckIpAddress: {
        validator: function (value, param) {
            var reg = /(^(?:(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$)|(^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$)/;
            return reg.test($.trim(value));
        },
        message: '请检查IP地址格式是否正确'
    },
    CheckMACAddress: {
        validator: function (value, param) {
            var reg = /([A-Fa-f0-9]{2}-){5}[A-Fa-f0-9]{2}/;
            return reg.test($.trim(value));
        },
        message: '请检查MAC地址格式是否正确'
    },
    CheckCharAndNum: {
        validator: function (value, param) {
            var reg = /^[A-Za-z0-9]+$/;
            return reg.test($.trim(value));
        },
        message: '请检查字符中是否包含字母和数字'
    },

    CheckPasswordStrength: {
        validator: function (value, param) {
            var reg = /^([a-z0-9A-Z]+[-|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$/;
            return reg.test($.trim(value));
        },
        message: '请检查密码是否符合要求'
    },
    CheckNum: {
        validator: function (value, param) {
            var reg = /[0-9]/;
            return reg.test($.trim(value));
        },
        message: '请检查字符中是否只有数字'
    },

});


var TernaryOperation =function(condition,value1,value2){
   return  condition?value1:value1;
}

