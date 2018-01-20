@if(0)==(0) ECHO OFF
rem 遅延設定
setlocal enabledelayedexpansion

cscript.exe //nologo //E:JScript "%~f0" %*
pause

GOTO :EOF
@end

(function() {

    /**---------------------------------------------------------------
     * 環境変数とかとってくる
     * @param {string} filter
     * @return {list}
     */
    function getEnvStr(filter)
    {
        var filter = filter || "";
        var wsh = WScript.CreateObject("WScript.Shell");
        var cmd = ["cmd.exe /c set ", filter];
        wsh = wsh.Exec(cmd.join(""));
        var file_list = wsh.StdOut.ReadAll();
        file_list = file_list.split("\r\n");
        file_list.pop();
        var return_list = [];

        for (i in file_list) {
            return_list.push(file_list[i].split("=")[0]);
        }

        return return_list;
    }

    /**---------------------------------------------------------------
     * プリント
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

    /**-------------------------------------------------------------------------
     *
     * @main
     *
     */
    function main()
    {
        var wsh = WScript.CreateObject("WScript.Shell");
        var sysPath = wsh.ExpandEnvironmentStrings("%WinDir%");

        print(sysPath);
        print("");

        var envStrList = getEnvStr();
        print("======================環境変数一覧ここから======================");
        print("");

        for (i in envStrList) {
            print("");
            print("環境変数名");
            print(envStrList[i]);
            print("環境変数内の内容");
            print(wsh.ExpandEnvironmentStrings("%" + envStrList[i] + "%"));
        }
        WScript.Sleep(5000);
    }

    // run
    main()

})();
