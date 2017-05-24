@if(0)==(0) ECHO OFF
rem �x���ݒ�
setlocal enabledelayedexpansion

rem ------------------------------------------------------------------
rem
rem SJ Ma�t�@�C���̃��t�@�����X�؂���`�F�b�N�����Ⴄ�A���I
rem (c) SAKAIDEN and Captain Hansode �����D��
rem
rem ������
rem ���̃X�N���v�g�𗘗p���Đ����������Ȃ鑹�Q��
rem ���҂͈�ؐӔC�𕉂��܂���B
rem
rem �g����
rem Maya��ma�t�@�C��(ascii)�̓������t�H���_�A
rem �܂���ma�t�@�C�����h���b�v�����
rem �t�@�C�����̃��t�@�����X�؂���`�F�b�N�����ʂ�Ԃ��܂�
rem
rem @Auther Captain Hansode �����D��
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

        //	�O���[�o�������W���[�����ǂ������Y�ނ�
        var debug = false;
        var start_time = new Date();

        return {
            TOOL_NAME		: "SJ Ma File Reference Check",
            TOOL_VERSION	: "1.0.6",
            TOOL_DATE		: "05/13/2017",
            DESCRIPTION		: "Ma�t�@�C���̃��t�@�����X�؂���`�F�b�N����A���I",
            AOUTHER			: "(c) Captain Hansode �����D��",
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
     * �c�[���ŕ\���������
     * ���W���[���Œ�`����Ɖ��s�ŋ�������x�^����
     */
    var toolMes = {
        id : "    ",
        error_tyep1 : "�t�@�C��������܂���",
        error_tyep2 : "mb�t�@�C���͒��ׂ��܂���",
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
            print(indent + "! ���� ! mb�t�@�C���̓`�F�b�N���܂���");
            print("");
            print(indent + sjMFRC.AOUTHER);
            print("");
            print(indent + sjMFRC.WEB);
            print(indent + sjMFRC.MAIL);
            print("");
            print(strMlt("-", 60));
            print("");
            print(indent
                  + "ma�t�@�C�����h���b�v���ă��t�@�����X�؂���`�F�b�N�I");
            print("");
        },

        attention : function()
        {
            print("");
            print(this.indent + "����mb�t�@�C���̓`�F�b�N���܂���");
            print("");
        },

        non : function()
        {
            print(this.indent + "�ǂ����ma�t�@�C���͂Ȃ���I");
            print("");
        },

        checking : function()
        {
            print(this.indent + "�t�@�C�����m�F���Ă����I");
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
            print(this.indent + "�G���[�͂Ȃ�������I�I");
            print("");
        },

        err : function()
        {
            print(this.indent + "�G���[����������I�I");
            print(this.indent + "���̃t�@�C��������������I");
        },

        footer: function()
        {
            var etime = (new Date - sjMFRC.start_time) / 60000.0;
            etime = Math.floor(etime, 100) / 100;
            print(strMlt("-", 60));
            print("");
            print(this.indent + "�I�������I  :  "
                  + etime + "����������");
            print("");
            print(this.indent + "���O�͂����ɂ����I");
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
     * �v�����g��progress�p
     * @param {string} str string
     * @param {boolean} carriage_return �s�̏㏑���ݒ�
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
     * @param {file_name} ���O�t�@�C����
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
//   Response.Write "�t�@�C������������ł��܂��B<BR>"
//   '1 �s�������݂܂��B
//   f1.Write ("����̓e�X�g�ł��B")

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
     * @param {object[]} �����͊�ł�
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
     * �z�񐮗�
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
     * array��find�v���p�e�B��ǉ�
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
     * �g���q�`�F�b�Nmb�̓`�F�b�N���Ȃ�
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
     * Maya�̃��t�@�����X�����邩�H
     * @param {string} ma_file ma_file
     * @return {object} ���̂������t�@�C�����X�g
     *
     */
    function checkRefPathExists(ma_file, err_files)
    {
        // @bref �S���̃��t�@�����X�p�X�����
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
            //	requires���o�ė���ƏI���
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
        //	�p�X���擾���鐳�K�\���AMaya2017������s���Ă�
        //var reg = /.+"(.+)"/g;
        var reg = /.+"(.+)"/;

        ref_files = _getRefPath(fso, ma_file, reg);
        ref_files = arrayUnique(ref_files);

        var count = ref_files.length;
        for(var i = 0; i < count; i++) {

            //	�t�@�C�����Ȃ�
            if (!fso.FileExists(ref_files[i])) {
                //err_files.push(ref_files[i]);
                err_files[ref_files[i]] = toolMes.error_tyep1;
                continue;
            }

            //	�g���q��mb������`�F�b�N�ł��Ȃ�
            if (!checkFileType(ref_files[i])) {
                err_files[ref_files[i]] = toolMes.error_tyep2;
                continue;
            }
            //	�ċA
            checkRefPathExists((ref_files[i]), err_files);
        }
        return err_files;
    }


    /**----------------------------------------------------------------
     * ���t�@�����X�`�F�b�N
     * @param {string} ma_file ma_file
     * @return {object} ���̂������t�@�C�����X�g(object)
     */
    function checkMaReference(ma_files)
    {
        var err_files = {};
        var result = {};

        var count = ma_files.length;
        for(var i = 0; i < count; i++) {

            toolMes.prog(i + 1, count);

            //	mb�̓`�F�b�N���Ȃ�
            if (!checkFileType(ma_files[i])) {
                err_files[ma_files[i]] = toolMes.error_tyep2;
                continue;
            }

            //	���ۂɃ`�F�b�N
            result = checkRefPathExists(ma_files[i]);
            err_files = arrayMarge(err_files, result);

        }
        toolMes.lf();
        return err_files;
    }


    /**---------------------------------------------------------------
     * ������Multiply
     * @param {string} str ���₵��������
     * @param {number} number ���₵������
     * @return {string} ����������
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
     * �f�B�N�V���i���J�E���g
     * @return {number} �J�E���g��
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
     * �f�B�N�V���i�����g�m�F
     */
    function lookDickey(dictionary)
    {
        for (var key in dictionary) {
            print(key);
        }
    }


    /**---------------------------------------------------------------
     * �G���[�\��
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
     * �f�B���N�g���ȉ��t�@�C���S�����
     * Get File in dir, and get files in sub dir.
     * @param {string} path �p�X
     * @param {string} file_type �t�B���^�[�^�C�v
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
     * �h���b�v���ꂽ��������t�@�C���ނ��擾
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
                //	�t�@�C���̃t�B���^�w��̓R�R
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