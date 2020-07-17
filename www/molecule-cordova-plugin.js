var exec = require('cordova/exec');

// arg0 : maId, arg1 : maKey
exports.startApplication = function (arg0, arg1, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'startApplication', [arg0, arg1]);
};

// arg0 : activityName
exports.startActivity = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'startActivity', [arg0]);
};

// arg0 : activityName
exports.endActivity = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'endActivity', [arg0]);
};

// arg0 : itemList(json)
exports.setItemList = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'setItemList', [arg0]);
};

// arg0 : orderList(json)
exports.setOrderList = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'setOrderList', [arg0]);
};

// arg0 : cartList(json)
exports.setCartList = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'setCartList', [arg0]);
};

// arg0 : searchKeyword
exports.setSearchKeyword = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'setSearchKeyword', [arg0]);
};

// arg0 : mudList(json)
exports.setMudList = function (arg0, success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'setMudList', [arg0]);
};

// arg0 : login
exports.login = function (success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'login', []);
};

// arg0 : join
exports.join = function (success, error) {
    exec(success, error, 'MoleculeCordovaAgent', 'join', []);
};