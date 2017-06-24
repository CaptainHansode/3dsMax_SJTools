@if(0)==(0) ECHO OFF
rem �x���ݒ�
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

        //	�O���[�o�������W���[�����ǂ������Y�ނ�
        var debug = false;
        var start_time = new Date();

        return {
            TOOL_NAME : "",
            TOOL_VERSION : "0.0.0.0",
            TOOL_DATE : "",
            DESCRIPTION : "",
            AOUTHER : "(c) Captain Hansode �����D��",
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
            print(indent + "�t�@�C���̐U�蕪�������s������");
            print(indent + "�t�@�C���Ƃ��t�H���_���h���b�v���Ȃ�");
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
            print(this.indent + "���̃t�@�C������������I");
        },

        cantMove : function(filename)
        {
            print(filename + "\n���̃t�@�C���ړ��ł���I\n");
        },

        footer: function()
        {
            print(strMlt("-", 60));
            print("");
            print(this.indent + "�I�������A���ƃ����V�N�I�I");
            print(this.indent + "���������ȁI(*�e�ցe *)");
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
        return;
    }

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

        var wsh = toolMod.wsh;
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
        var fso = toolMod.fso;

        var count = WScript.Arguments.Count();
        var item;

        for (var i = 0; i < count; i++) {

            item = WScript.Arguments.Item(i);
            if (fso.FolderExists(item)) {
                //	�t�@�C���̃t�B���^�w��̓R�R
                file_list = file_list.concat(getFilesInDir(item));
            } else {
                file_list.push(item);
            }
        }
        return file_list;
    }

    /**
     * �J�b�g�ԍ��̃f�B���N�g���ɓ����Ă��邩�m�F����
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
     * �J�b�g�ԍ��̃t�H���_�ɓ����
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
     * �J�b�g�ԍ��̃t�H���_�ɓ����
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