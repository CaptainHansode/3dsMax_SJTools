@if(0)==(0) ECHO OFF
rem �x���ݒ�
setlocal enabledelayedexpansion

cscript.exe //nologo //E:JScript "%~f0" %*
pause

GOTO :EOF
@end

(function() {

    /**---------------------------------------------------------------
     * ���ϐ��Ƃ��Ƃ��Ă���
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
     * �v�����g
     * @param {string} str
     * @param {boolean} carriage_return �L�����b�W���^�[��
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
        print("======================���ϐ��ꗗ��������======================");
        print("");

        for (i in envStrList) {
            print("");
            print("���ϐ���");
            print(envStrList[i]);
            print("���ϐ����̓��e");
            print(wsh.ExpandEnvironmentStrings("%" + envStrList[i] + "%"));
        }
        WScript.Sleep(5000);
    }

    // run
    main()

})();
