/**---------------------------------------------------------------
 * テスト関数
 * @param {string} str 
 * @param {boolean} carriage_return キャリッジリターン
 */
function print(str, carriage_return)
{
    var c_ret = carriage_return || false;
    if (c_ret) {
        WScript.StdOut.Write("\r" + str);
        return;
    }

    WScript.StdOut.Write("\n" + str);
    return;
}

