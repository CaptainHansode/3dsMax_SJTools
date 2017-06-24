@if(0)==(0) ECHO OFF
rem 遅延設定
setlocal enabledelayedexpansion

cscript.exe //nologo //E:JScript "%~f0" %*

@pause
GOTO :EOF
@end

(function() {

    /**----------------------------------------------------------------
     * modules
     */
    var toolMod = (function() {

        //	グローバルかモジュールかどっちか悩むね
        var debug = false;
        var start_time = new Date();

        return {
            TOOL_NAME : "",
            TOOL_VERSION : "0.0.0.0",
            TOOL_DATE : "",
            DESCRIPTION : "",
            AOUTHER : "(c) Captain Hansode 半袖船長",
            WEB : "Web",
            MAIL : "Email sakaiden@live.jp",


            fso :
                WScript.CreateObject("Scripting.FileSystemObject"),
            wsh :
                WScript.CreateObject("WScript.Shell"),
            debug			: debug
        }

    })();


    /**----------------------------------------------------------------
     * globals
     */
    var gobj = {};
    gobj.folder = getSpFolderPath("Desktop");
    gobj.start_time = new Date();
    gobj.fso = WScript.CreateObject("Scripting.FileSystemObject");
    gobj.wsh = WScript.CreateObject("WScript.Shell");
    gobj.cutDirNameReg = /c\d\d\d/;
    gobj.fileNameReg = /..._\d\d_(\d\d\d)/;
    gobj.cutDirIndex = "c";

    //gobj.wsh = WScript.CreateObject("WScript.Shell");


    /**----------------------------------------------------------------
     * ツールで表示するもの
     * モジュールで定義すると改行で狂うからベタもち
     */
    var toolMes = {
        id : "    ",
        error_tyep1 : "ファイルがありません",
        error_tyep2 : "mbファイルは調べられません",
        indent : "    ",

        lf : function() {
            print("");
        },

        title : function()
        {
            var indent = this.indent;
            print(strMlt("-", 60));
            print("");
            print(indent + "ファイルの振り分けを実行するやつ");
            print(indent + "ファイルとかフォルダをドロップしなよ");
            print("");
            print(strMlt("-", 60));
            print("");
            print("");
        },

        attention : function()
        {
            print("");
        },

        non : function()
        {
            print("");
        },

        checking : function()
        {
            print("");
        },

        prog : function (cnt, max, str)
        {
            var str = str || "";
            print(this.indent
                  + "["
                  + cnt
                  + " / "
                  + max
                  + "]"
                  + str, true
                 );
        },

        clear : function()
        {
            print("");
        },

        err : function()
        {
            print(this.indent + "このファイルおかしいよ！");
        },

        cantMove : function(filename)
        {
            print(filename + "\nこのファイル移動できん！\n");
        },

        footer: function()
        {
            print(strMlt("-", 60));
            print("");
            print(this.indent + "終わったよ、あとヨロシク！！");
            print(this.indent + "いつもお疲れな！(*‘ω‘ *)");
            print("");
            print(strMlt("-", 60));
            print("");
        }
    }


    /**---------------------------------------------------------------
     * get windows special folder
     */
    function getSpFolderPath(dir_name)
    {
        var wsh = WScript.CreateObject("WScript.Shell");
        return wsh.SpecialFolders(dir_name);
    }

    /**---------------------------------------------------------------
     * プリントとprogress用
     * @param {string} str string
     * @param {boolean} carriage_return 行の上書き設定
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

    /**---------------------------------------------------------------
     * 拡張子チェックmbはチェックしない
     * @return {boolean}
     */
    function checkFileType(file)
    {
        var len = file.length;
        if (file.substr(len - 2) != "ma") {
            return false;
        }
        return true;
    }

    /**---------------------------------------------------------------
     * 文字列Multiply
     * @param {string} str 増やしたい文字
     * @param {number} number 増やしたい数
     * @return {string} 増えた文字
     */
    function strMlt(str, number)
    {
        var str = str || "";
        var ret = "";
        for (var i = 0; i < number; i++) {
            ret += str;
        }
        return ret;
    }

    /**---------------------------------------------------------------
     * ディレクトリ以下ファイル全部回収
     * Get File in dir, and get files in sub dir.
     * @param {string} path パス
     * @param {string} file_type フィルタータイプ
     * @return {object} file list(array)
     */
    function getFilesInDir(path, file_type)
    {
        var path = path || "";
        var file_type = file_type || "*";
        if (path == "") {
            return [];
        }

        var file_list = "";
        var cmd ="cmd.exe /c dir /s /b "
            + '"'
            + path
            + "\\"
            + '*.' + file_type
            + '"';

        var wsh = toolMod.wsh;
        wsh = wsh.Exec(cmd);

        var file_list = wsh.StdOut.ReadAll();
        file_list = file_list.split("\r\n");
        file_list.pop();

        return file_list;

    }


    /**---------------------------------------------------------------
     * ドロップされた引数からファイル類を取得
     * @return {string[]} file list(array)
     */
    function getFilesFromArgs()
    {
        var file_list = [];
        var fso = toolMod.fso;

        var count = WScript.Arguments.Count();
        var item;

        for (var i = 0; i < count; i++) {

            item = WScript.Arguments.Item(i);
            if (fso.FolderExists(item)) {
                //	ファイルのフィルタ指定はココ
                file_list = file_list.concat(getFilesInDir(item));
            } else {
                file_list.push(item);
            }
        }
        return file_list;
    }

    /**
     * カット番号のディレクトリに入っているか確認する
     */
    function checkFileParentDirIsCutNum(fileList)
    {
        var result = [];
        var fileList = fileList || [];
        var checkPath = "";
        for (var i in fileList) {
            checkPath = gobj.fso.GetParentFolderName(fileList[i]);
            if (gobj.cutDirNameReg.exec(checkPath) == null) {
                result.push(fileList[i]);
            }
        }
        return result;
    }

    /**
     * カット番号のフォルダに入れる
     */
    function createDir(path)
    {
        var path = path || "";
        if (path == "") {
            return;
        }

        if (gobj.fso.FolderExists(path)) {
            return;
        }
        gobj.fso.CreateFolder(path);
    }

    /**
     * カット番号のフォルダに入れる
     */
    function moveToCutDir(fileList)
    {
        var result = [];
        var fileList = fileList || [];
        var check_name = "";
        var parentDir = "";
        var hit_name = "";
        var toDir = "";
        var fileName = "";
        for (var i in fileList) {
            check_name = gobj.fso.GetBaseName(fileList[i]);
            hit_name = gobj.fileNameReg.exec(check_name);
            if (hit_name == null) {
                continue;
            }
            parentDir = gobj.fso.GetParentFolderName(fileList[i]);
            toDir = parentDir + "\\" + gobj.cutDirIndex + hit_name[1];
            createDir(toDir);
            try {
                gobj.fso.MoveFile(fileList[i], toDir + "\\" + check_name);
            } catch(e) {
                print(e.message);
                toolMes.cantMove(fileList[i]);
            }
        }
        return result;
    }

    /**---------------------------------------------------------------
     * main
     */
    function main()
    {
        toolMes.title();
        toolMes.checking();

        var drop_files = getFilesFromArgs();
        var err_files = {};
        if (drop_files.length == 0) {
            toolMes.non();
            toolMes.footer();
            return;
        }

        var tag_list = checkFileParentDirIsCutNum(drop_files);
        moveToCutDir(tag_list);

        toolMes.footer();
        return;
    }

    // run
    main()

})();
// EOF