/**
 * 1秒後にHello!を出力するDeferred対応関数。必ずresolveする
 *
 * @returns Promise
 */
function delayHello() {
    var d = new $.Deferred;
    setTimeout(function () {
        console.log('Hello!');
        d.resolve();
    }, 1000);
    return d.promise();
}

/**
 * 1秒後にエラーを発生させるDeferred対応関数。必ずrejectする
 *
 * @returns Promise
 */
function delayError() {
    var d = new $.Deferred;
    setTimeout(function () {
        d.reject('Error!!');
    }, 1000);
    return d.promise();
}

function hello1() {
    console.log('Hello sync1');
}

function hello2() {
    console.log('Hello sync2');
}