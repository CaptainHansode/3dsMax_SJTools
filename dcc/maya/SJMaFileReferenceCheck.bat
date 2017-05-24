@if(0)==(0) ECHO OFF
rem 遅延設定
setlocal enabledelayedexpansion

rem ------------------------------------------------------------------
rem
rem SJ Maファイルのリファレンス切れをチェックしちゃうアレ！
rem (c) SAKAIDEN and Captain Hansode 半袖船長
rem
rem ご注意
rem このスクリプトを利用して生じたいかなる損害も
rem 著者は一切責任を負いません。
rem
rem 使い方
rem Mayaのmaファイル(ascii)の入ったフォルダ、
rem またはmaファイルをドロップすると
rem ファイル内のリファレンス切れをチェックし結果を返します
rem
rem @Auther Captain Hansode 半袖船長
rem @Web http://www.sakaiden.com/
rem @Email sakaiden@live.jp
rem @Git https://github.com/CaptainHansode/SJTools
rem
rem ------------------------------------------------------------------

cscript.exe //nologo //E:JScript "%~f0" %*

@pause
GOTO :EOF
@end

(function() {

    /**----------------------------------------------------------------
     * modules
     */
    var sjMFRC = (function() {

        //	グローバルかモジュールかどっちか悩むね
        var debug = false;
        var start_time = new Date();

        return {
            TOOL_NAME		: "SJ Ma File Reference Check",
            TOOL_VERSION	: "1.0.6",
            TOOL_DATE		: "05/13/2017",
            DESCRIPTION		: "Maファイルのリファレンス切れをチェックするアレ！",
            AOUTHER			: "(c) Captain Hansode 半袖船長",
            WEB				: "Web http://www.sakaiden.com/",
            MAIL			: "Email sakaiden@live.jp",

            LOG_FILE_NAME	: "Reference_Error.log",
            LOG_FOLDER		: getSpFolderPath("Desktop"),

            fso 			:
                WScript.CreateObject("Scripting.FileSystemObject"),
            wsh				:
                WScript.CreateObject("WScript.Shell"),

            start_time		: start_time,
            debug			: debug

        }

    })();


    /**----------------------------------------------------------------
     * globals
     */
    var gobj = {};
    gobj.folder = getSpFolderPath("Desktop");
    gobj.start_time = new Date();
    gobj.wsh = WScript.CreateObject("WScript.Shell");


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
            print("");
            print(indent + sjMFRC.DESCRIPTION + sjMFRC.TOOL_VERSION);
            print("");
            print(indent + "! 注意 ! mbファイルはチェックしません");
            print("");
            print(indent + sjMFRC.AOUTHER);
            print("");
            print(indent + sjMFRC.WEB);
            print(indent + sjMFRC.MAIL);
            print("");
            print(strMlt("-", 60));
            print("");
            print(indent
                  + "maファイルをドロップしてリファレンス切れをチェック！");
            print("");
        },

        attention : function()
        {
            print("");
            print(this.indent + "注意mbファイルはチェックしません");
            print("");
        },

        non : function()
        {
            print(this.indent + "どうやらmaファイルはないよ！");
            print("");
        },

        checking : function()
        {
            print(this.indent + "ファイルを確認しているよ！");
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
            print(this.indent + "エラーはなかったよ！！");
            print("");
        },

        err : function()
        {
            print(this.indent + "エラーがあったよ！！");
            print(this.indent + "このファイルがおかしいよ！");
        },

        footer: function()
        {
            var etime = (new Date - sjMFRC.start_time) / 60000.0;
            etime = Math.floor(etime, 100) / 100;
            print(strMlt("-", 60));
            print("");
            print(this.indent + "終了するよ！  :  "
                  + etime + "分かかった");
            print("");
            print(this.indent + "ログはここにあるよ！");
            print(this.indent
                  + sjMFRC.LOG_FOLDER + "\\" + sjMFRC.LOG_FILE_NAME);
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
//		WScript.StdOut.WriteLine(str);
        return;
    }


    /**----------------------------------------------------------------
     * logger
     * @param {str} string
     * @param {file_name} ログファイル名
     */
    function log(str, log_path)
    {
        var log_path = log_path
            || sjMFRC.LOG_FOLDER + "\\" + sjMFRC.LOG_FILE_NAME;
        var fso = sjMFRC.fso;
        var ForAppending = 8;
        var TristateUseDefault = -2;
        //fso.CreateTextFile(log_path, True);
        var stream = fso.OpenTextFile(log_path,
                                      ForAppending, true
                                     );
        stream.WriteLIne(str);
        stream.Close();
        //Response.Write("");
//sjMFRC.fso.CreateTextFile("c:\testfile.txt", True)
//   Response.Write "ファイルを書き込んでいます。<BR>"
//   '1 行書き込みます。
//   f1.Write ("これはテストです。")

//		var cmd =
//			[
//			"cmd.exe /c echo",
//			str,
//			">>",
//			log_path
//			]
//
//		//	loging
//		sjMFRC.wsh.Exec(cmd.join(" "))
    }


    // log reset
    function resetLog(log_path)
    {
        var log_path = log_path
            || sjMFRC.LOG_FOLDER + "\\" + sjMFRC.LOG_FILE_NAME;

        if (log_path == "") {
            return;
        }

        var cmd = "cmd.exe /c type NUL > " + log_path;

        sjMFRC.wsh.Exec(cmd);

    }


    // logDelete
    function deleteLog(log_path)
    {

        var log_path = log_path
            || sjMFRC.LOG_FOLDER + "\\" + sjMFRC.LOG_FILE_NAME;

        if (log_path == "") {
            return;
        }

        var fso = sjMFRC.fso;
        if (fso.FileExists(log_path)) {
            fso.DeleteFile(log_path);
        }

    }


    /**----------------------------------------------------------------
     * arrayMarge
     * @param {object[]} 引数は幾つでも
     */
    function arrayMarge()
    {
        if (arguments.length == 0) {
            return false
        }

        var i = 0;
        var len = arguments.length;
        var key;
        var result = [];

        for (i = 0; i < len; i++) {

            if (typeof arguments[i] !== 'object') {
                continue;
            }

            for (key in arguments[i]) {
                if (isFinite(key)) {
                    result.push(arguments[i][key]);
                } else {
                    result[key] = arguments[i][key];
                }
            }
        }

        return result;
    }


    /**---------------------------------------------------------------
     * 配列整理
     * @param {Object[]} array or dictionary
     */
    function arrayUnique(array)
    {
        if (array.length == 0) {
            return [];
        }

        var i = 0;
        var j = 0;
        var count = array.length;
        var result = [];
        var check = true;
        for (i = 0; i < count; i++) {
            check = true;
            //for (j = 0; j < result.length; j++) {
            for (j = result.length; j--;) {
                if (array[i] == result[j]) {
                    check = false;
                }
            }
            if (check) {
                result.push(array[i]);
            }
        }
        return result;
    }


    /**----------------------------------------------------------------
     * arrayにfindプロパティを追加
     * @param {object} array or dictiona
     *
     */
//	if (!Array.prototype.find) {
//		Array.prototype.find = function(predicate) {
//			if (this === null) {
//				//throw new TypeError('Array.prototype.find called on null or undefined');
//			}
//			if (typeof predicate !== 'function') {
//				//throw new TypeError('predicate must be a function');
//			}
//
//			var list = Object(this);
//			var length = list.length >>> 0;
//			var thisArg = arguments[1];
//			var value;
//
//			for (var i = 0; i < length; i++) {
//				value = list[i];
//				if (predicate.call(thisArg, value, i, list)) {
//				  return value;
//				}
//			}
//			return undefined;
//		};
//	}


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


    /**----------------------------------------------------------------
     * Mayaのリファレンスがあるか？
     * @param {string} ma_file ma_file
     * @return {object} 問題のあったファイルリスト
     *
     */
    function checkRefPathExists(ma_file, err_files)
    {
        // @bref 全部のリファレンスパスを回収
        function _getRefPath(fso, path, reg)
        {
            var str = fso.OpenTextFile(path);

            if(str.AtEndOfStream){
                return [];
            }

            var line = str.ReadLine();
            var files = [];

//			while ((arr = reg.exec(line)) != null)
//			{
//				print(arr[1])
//				reg.lastIndex;
//			}
            //	requiresが出て来ると終わり
            while (line.indexOf("requires maya") == -1) {

                if ((line = reg.exec(line)) != null) {
                    if (fso.GetParentFolderName(line[1])) {
                        files.push(line[1]);
                    }
                }
                line = str.ReadLine();
            }
            return files;
        }

        var ma_file = ma_file || "";
        var err_files = err_files || {};

        var ref_files = [];
        if (ma_file == "") {
            return [];
        }

        var fso = sjMFRC.fso;
        //	パスを取得する正規表現、Maya2017から改行してる
        //var reg = /.+"(.+)"/g;
        var reg = /.+"(.+)"/;

        ref_files = _getRefPath(fso, ma_file, reg);
        ref_files = arrayUnique(ref_files);

        var count = ref_files.length;
        for(var i = 0; i < count; i++) {

            //	ファイルがない
            if (!fso.FileExists(ref_files[i])) {
                //err_files.push(ref_files[i]);
                err_files[ref_files[i]] = toolMes.error_tyep1;
                continue;
            }

            //	拡張子がmbだからチェックできない
            if (!checkFileType(ref_files[i])) {
                err_files[ref_files[i]] = toolMes.error_tyep2;
                continue;
            }
            //	再帰
            checkRefPathExists((ref_files[i]), err_files);
        }
        return err_files;
    }


    /**----------------------------------------------------------------
     * リファレンスチェック
     * @param {string} ma_file ma_file
     * @return {object} 問題のあったファイルリスト(object)
     */
    function checkMaReference(ma_files)
    {
        var err_files = {};
        var result = {};

        var count = ma_files.length;
        for(var i = 0; i < count; i++) {

            toolMes.prog(i + 1, count);

            //	mbはチェックしない
            if (!checkFileType(ma_files[i])) {
                err_files[ma_files[i]] = toolMes.error_tyep2;
                continue;
            }

            //	実際にチェック
            result = checkRefPathExists(ma_files[i]);
            err_files = arrayMarge(err_files, result);

        }
        toolMes.lf();
        return err_files;
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
     * ディクショナリカウント
     * @return {number} カウント数
     */
    function getDiscCount(dictionary)
    {
        var count = 0;
        for (var key in dictionary) {
            count++;
        }
        return count;
    }


    /**---------------------------------------------------------------
     * ディクショナリ中身確認
     */
    function lookDickey(dictionary)
    {
        for (var key in dictionary) {
            print(key);
        }
    }


    /**---------------------------------------------------------------
     * エラー表示
     */
    function displayErrorAndLog(err_files)
    {
        var err_files = err_files || {}
        var line = "";

        deleteLog();
        //resetLog();

        for (var key in err_files) {
            line = key + "\t" + err_files[key];
            log(line);
            print(toolMes.indent + line);
        }
        log();
        toolMes.lf();
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

        var wsh = sjMFRC.wsh;
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
        var fso = sjMFRC.fso;

        var count = WScript.Arguments.Count();
        var item;

        for (var i = 0; i < count; i++) {

            item = WScript.Arguments.Item(i);
            if (fso.FolderExists(item)) {
                //	ファイルのフィルタ指定はココ
                file_list =
                    file_list.concat(getFilesInDir(item, "ma"));
            } else {
                file_list.push(item);
            }

        }
        return file_list;
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

        err_files = checkMaReference(drop_files);

        if (getDiscCount(err_files) == 0) {
            toolMes.clear();
        } else {

            toolMes.err();
            displayErrorAndLog(err_files)
        }
        toolMes.footer();
        return;
    }

    // run
    main()

})();
// EOF