/**
 * -----------------------------------------------------------------------------
 *
 *  SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @copyright (c) Copyright 2018 sakaiden and Captain Hansode. All rights reserved.
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 *
 * サイズを一気に変えるマン
 *
 */
#target photoshop

/**---------------------------------------------------------------
 *
 * プログレスバー
 *
 */
function SjProgbar()
{
    /**--------------------------------------------------------------------------------
     * プログレス
     * @param {number} max
     */
    this.Progress = function(max, title, value, message, show)
    {
        var max = max || 100;
        var title = title || "Progress";
        var value = value || 0;
        var message = message || "Progress";
        // var show = show || true;

        if (show){
            uDlg = new Window('window', title, undefined);
            uDlg.pBar = uDlg.add("progressbar", [10,30,10+384,30+15], 0, max);
            uDlg.messagetext = uDlg.add('statictext', [10,30,10+384,30+15], message);
            uDlg.pBar.value = value;
            uDlg.show();
        } else if (!show){
            uDlg.close();
        }
    }

    this.ProgressUpdate = function(value, message)
    {
        var value = value || 0;
        var message = message || "Progress";
        uDlg.pBar.value = value;
        uDlg.messagetext.text = message;
    }
}


/**---------------------------------------------------------------
 *
 * 汎用ユーティリティ 自前のものを転用
 *
 */
function SjPsCommonLib()
{
    /**---------------------------------------------------------------
     * test run
     */
    this.TestRun = function(in_msg)
    {
        var msg = in_msg || "Empty";
        alert(msg);
        return "";
    }
    /**---------------------------------------------------------------
     * debug
     * @param {string} text
     */
    this.DebugWriteLog = function(text)
    {
        var logobj = new File("sjtoolslog.txt");
        var log = "";
        var flag = logobj.open("r");

        if (flag == true) {
            log = logobj.read();
            log = log + text;
            logobj.close();
        }

        flag = logobj.open("w");

        if (flag == true) {
            logobj.writeln(log);
            // logobj.write(text);
            logobj.close();
        } else {
            // alert("ファイルが開けませんでした");
        }
    }

    /**--------------------------------------------------------------------------------
     * Exsits Path
     * @param {string} folderpath
     */
    this.ExistsPath = function(folderpath)
    {
        // パスを確認
        var fpath = new File(folderpath);
        var flag = fpath.exists;
        var result = true;
        if (!flag) {
            result = false;
        }
        return result;
    }

    /**--------------------------------------------------------------------------------
     * ファイルの種類
     * @return {string}
     */
    this.GetFileType = function(filepath)
    {
        var checktype = new File(filepath);
        var ret = checktype.fsName.substr(checktype.fsName.length-3, 3);
        return ret.toLowerCase();
    }

    /**--------------------------------------------------------------------------------
     * ファイル容量を取得
     * @return {number}
     */
    this.GetFileSize = function(docs)
    {
        var fileobj = new File(docs.fullName);
        return fileobj.length
    }

    /**--------------------------------------------------------------------------------
     * ドキュメントサイズ
     * @return {number[]}
     */
    this.GetDocumentSize = function(docment)
    {
        preferences.rulerUnits = Units.PIXELS;
        var ret = [docment.width.value, docment.height.value];
        return ret;
    }


    /**--------------------------------------------------------------------------------
     * ファイルオプションを取得
     * @param {string} type
     * @return {object}
    */
    this.GetFileOptions = function(type)
    {
        var ret = null;
        switch (type) {
            case "psd":
                var ret = new PhotoshopSaveOptions();
                break;
            case "tif":
                var ret = new TiffSaveOptions();
                ret.imageCompression = TIFFEncoding.NONE;
                break;
            case "jpg":
                var ret = new JPEGSaveOptions();
                ret.embedColorProfile = true;
                ret.quality = 12;
                ret.formatOptions = FormatOptions.PROGRESSIVE;
                ret.scans = 3;
                ret.matte = MatteType.NONE;
                break;
            case "png":
                var ret = new PNGSaveOptions();
                ret.interlaced = false;
                break;
            case "gif":
                var ret = new GIFSaveOptions();
                ret.interlaced = false;
                break;
            case "tga":
                var ret = new TargaSaveOptions();
                break;
            case "bmp":
                var ret = new BMPSaveOptions();
                break;
        }
        return ret;
    }

    /**
     * アクションセット内のアクションを取得
     * @return {string[]}
     */
    this.GetActions = function(aset)
    {
        cTID = function(s) { return app.charIDToTypeID(s); };
        sTID = function(s) { return app.stringIDToTypeID(s); };

        var i = 1;
        var names = [];
        if (!aset) {
            throw "Action set must be specified";
        }
        while (true) {
            var ref = new ActionReference();
            ref.putIndex(cTID("ASet"), i);
            var desc;
            try {
                desc = executeActionGet(ref);
            } catch (e) {
                break;    // all done
            }

            if (desc.hasKey(cTID("Nm  "))) {

            var name = desc.getString(cTID("Nm  "));
                if (name == aset) {
                    var count = desc.getInteger(cTID("NmbC"));
                    var names = [];
                    for (var j = 1; j <= count; j++) {
                    var ref = new ActionReference();
                    ref.putIndex(cTID('Actn'), j);
                    ref.putIndex(cTID('ASet'), i);
                    var adesc = executeActionGet(ref);
                    var actName = adesc.getString(cTID('Nm  '));
                    names.push(actName);
                    }
                    break;
                }
            }
            i++;
        }
        return names;
    }

    /**
     * アクションセットを取得
     * @return {string[]}
     */
    this.GetActionSets = function()
    {
        cTID = function(s) { return app.charIDToTypeID(s); };
        sTID = function(s) { return app.stringIDToTypeID(s); };

        var i = 1;
        var sets = [];
        while (true) {
            var ref = new ActionReference();
            ref.putIndex(cTID("ASet"), i);
            var desc;
            var lvl = $.level;
            $.level = 0;
            try {
                desc = executeActionGet(ref);
            } catch (e) {
                break;// all done
            } finally {
                $.level = lvl;
            }

            if (desc.hasKey(cTID("Nm  "))) {
                var set = {};
                set.index = i;
                set.name = desc.getString(cTID("Nm  "));
                set.toString = function() { return this.name; };
                set.count = desc.getInteger(cTID("NmbC"));
                set.actions = [];

                for (var j = 1; j <= set.count; j++) {
                    var ref = new ActionReference();
                    ref.putIndex(cTID('Actn'), j);
                    ref.putIndex(cTID('ASet'), set.index);
                    var adesc = executeActionGet(ref);
                    var actName = adesc.getString(cTID('Nm  '));
                    set.actions.push(actName);
                }
                sets.push(set);
            }
            i++;
        }
        return sets;
    }

}


/**--------------------------------------------------------------------------------
 * SJ Image Resizer
 */
function SjImageResizer()
{
    /*--------------------------------------------------------------------------------
    * 定数
    */
    this.VERSION = "0.0.1";
    this.TOOLNAME = "SJ Image Resizer";
    this.AUTHOR = "Captain Hansode";

    this.SUPPORT_TYPES = {
        bmp: "*.bmp",
        gif: "*.gif",
        png: "*.png",
        psd: "*.psd",
        tga: "*.tga",
        tif: "*.tif",
        jpg: "*.jpg"
    };

    this.Scml = new SjPsCommonLib();  // 汎用ライブラリ
    this.Prog = new SjProgbar();

    /**--------------------------------------------------------------------------------
     * 辺の長い方でリサイズ ドキュメントサイズ
     * @param {object} docment
     */
    this.ResizeDocumentAtLongSide = function(docment, longside)
    {
        preferences.rulerUnits = Units.PIXELS;
        var wh = Scml.GetDocumentSize(docment);
        var ratio = 0;
        var shortside = 0;

        if (wh[0] >= wh[1]) {
            // 幅の方がおおきい
            ratio  = longside / wh[0];
            shortside = wh[1] * ratio;
            activeDocument.resizeImage(longside, shortside);
        } else {
            // 立てがおおきい
            ratio  = longside / wh[1];
            shortside = wh[0] * ratio;
            activeDocument.resizeImage(shortside, longside);
        }
    }

    /**--------------------------------------------------------------------------------
     * イメージリサイズ
     * @param {string} folderpath
     */
    this.ImageResize = function(fpath, files, indexstr, imgsize, doact, actname)
    {
        // 引数の基本値
        var fpath = fpath || "";
        var indexstr = indexstr || "copy_";  // プレフィックス
        var doact = doact || false;  // アクション実行フラグ
        var actname = actname || "";  // アクション実行名
        var filetype = "";
        var fileopt = null;
        var tempfile  = null;

        // プログレス
        Prog.Progress(files.length, "のぞいちゃダメ!",　0, "開始!", true);

        for (var f in files) {
            // ファイルタイプ
            filetype = Scml.GetFileType(files[f]);
            // 拡張子が対応していれば継続
            if (SUPPORT_TYPES[filetype] == undefined) {
                continue;
            }
            fileopt = Scml.GetFileOptions(filetype);

            // ファイル開く
            if (files[f] instanceof File) {
                open(files[f]);
            }

            Prog.ProgressUpdate(f, activeDocument.name);

            // アクション実行
            if (doact) {
                var actstr = actname.toString().split("---");
                doAction(actstr[1], actstr[0]);
            }

            ResizeDocumentAtLongSide(activeDocument, imgsize);

            // 名前を付けて保存
            tempfile = fpath + "/" + indexstr + activeDocument.name;
            newfileobj = new File(tempfile);
            activeDocument.saveAs (
                newfileobj,
                fileopt,
                true,
                Extension.LOWERCASE
            );

            // 閉じる
            activeDocument.close(SaveOptions.DONOTSAVECHANGES);
        }

        Prog.Progress(100, "おわり!", 100, "おわり!", false);
        return true;
    }

    /**
     * UI
     */
    // folderObj = new File(app.path);
    // これでデスクトップを指定する
    folderObj = new File("~/Desktop/");
    fsname = folderObj.fsName;

    var dig = new Window('dialog', TOOLNAME + " " + VERSION);
    dig.alignChildren = "fill";
    dig.opacity = 1.0;

    // パネル追加
    dig.plfolder = dig.add('panel', undefined, "フォルダを指定");
    dig.plfolder.orientation = "row";
    dig.plfolder.alignChildren = "fill";

    dig.fpath = dig.plfolder.add('edittext', [0,0,356,24], fsname);
    dig.btfolder = dig.plfolder.add("button", [0,0,30,24], "...", {name:"folder"});

    // ファイルサイズ
    dig.plfsize = dig.add('panel', undefined, "リサイズ");
    dig.plfsize.orientation = "column";
    dig.plfsize.alignChildren = "fill";

    dig.plfsize.grprb = dig.plfsize.add("group", undefined);
    dig.plfsize.grprb.orientation ='column';
    // dig.plfsize.alignChildren = "fill";
    dig.plfsize.alignChildren = "left";
    // dig.plfsize.grprb.alignment = ['fill', 'top'];
    // dig.plfsize.grprb.rdBtHdtv = dig.plfsize.grprb.add("radiobutton", [0, 0, 650, 16],"HDTV 1280");
    dig.plfsize.grprb.rdBtHdTv = dig.plfsize.grprb.add("radiobutton", [0, 0, 220, 16], "HDTV 1280");
    dig.plfsize.grprb.rdBtFullHd = dig.plfsize.grprb.add("radiobutton", [0, 0, 220, 16],"FullHD 1920");
    dig.plfsize.grprb.rdBtWqHd = dig.plfsize.grprb.add("radiobutton", [0, 0, 220, 16],"WQHD 2560");
    dig.plfsize.grprb.rdBt4K = dig.plfsize.grprb.add("radiobutton", [0, 0, 220, 16],"4K 3840");
    dig.plfsize.grprb.rdBt8K = dig.plfsize.grprb.add("radiobutton", [0, 0, 220, 16],"8K 7680");
    dig.plfsize.grprb.rdBtFullHd.value = true;

    // 一行目
    dig.plfsize.grpfs = dig.plfsize.add('group', undefined);
    dig.plfsize.grpfs.orientation = 'row';
    dig.plfsize.grpfs.alignChildren = "fill";

    dig.plfsize.grpfs.text1 = dig.plfsize.grpfs.add('statictext', undefined, "辺の長さ");
    dig.plfsize.grpfs.fsize = dig.plfsize.grpfs.add('edittext', [0,0,120,24], 1920);
    dig.plfsize.grpfs.fsize.justify = "right";
    dig.plfsize.grpfs.text2 = dig.plfsize.grpfs.add('statictext', undefined, "px");

    dig.plfsize.grpinfo = dig.plfsize.add('group', undefined);
    dig.plfsize.grpinfo.orientation = 'row';
    dig.plfsize.grpinfo.alignChildren = "fill";

    var info = "ヒント  " + "リサイズは長い辺にあわせ適応され、画像のアスペクト比は維持されます"
    dig.plfsize.grpinfo.info = dig.plfsize.grpinfo.add('statictext', undefined, info);

    dig.plindex = dig.add('panel', undefined, "保存時に付ける頭文字");
    dig.plindex.orientation = 'row';
    dig.plindex.alignChildren = "fill";

    dig.indexstr = dig.plindex.add('edittext', [0,0,394,24], "Resize_");

    // パネル追加
    dig.pldoact = dig.add('panel', undefined, "リサイズ時に実行するアクション");
    dig.pldoact.orientation = "column";
    dig.pldoact.alignChildren = "fill";

    // 一行目
    dig.pldoact.grpactck = dig.pldoact.add('group', undefined);
    dig.pldoact.grpactck.orientation = 'row';
    dig.pldoact.grpactck.alignChildren = "fill";

    dig.pldoact.grpactck.doactchk = dig.pldoact.grpactck.add('checkbox', [0,0,394,24], "実行する");
    dig.pldoact.grpactck.doactchk.value = false;

    dig.pldoact.grpactList = dig.pldoact.add('group', undefined);
    dig.pldoact.grpactList.orientation = 'row';
    dig.pldoact.grpactList.alignChildren = "fill";

    var actionList = Scml.GetActionSets();
    var actionItems = [];
    // actionItems.push("実行しない");
    for (var i in actionList) {
        for (var k in actionList[i].actions) {
            var actName = actionList[i] + "---" + actionList[i].actions[k];
            actionItems.push(actName);
        }
    }

    dig.pldoact.grpactList.actlist = dig.pldoact.grpactList.add("dropdownlist",[0,0,394,24], actionItems);
    dig.pldoact.grpactList.actlist.selection = 0;

    // パネル追加
    dig.plRun = dig.add('panel', undefined, "");
    dig.plRun.orientation = "row";
    dig.plRun.alignChildren = "fill";

    dig.btrun = dig.plRun.add("button", [0,0,193,36], "実行", {name:"ok"});
    dig.btcancel = dig.plRun.add("button", [0,0,193,36], "閉じる", {name:"cancel"});
    dig.bthint = dig.plRun.add("button", [0,0,36,36], "ヒント", {name:"hint"});

    /**
     * Events
     */
    dig.btfolder.onClick = function() {
        foldername = Folder.selectDialog("フォルダを指定してください");
        if (foldername) {
            folderObj = new File(foldername);
            fsname = folderObj.fsName;
            dig.fpath.text = fsname;
        }
    }

    dig.plfsize.grprb.rdBtHdTv.onClick = function()
    {
        dig.plfsize.grpfs.fsize.text = "1280";
    }

    dig.plfsize.grprb.rdBtFullHd.onClick = function()
    {
        dig.plfsize.grpfs.fsize.text = "1920";
    }

    dig.plfsize.grprb.rdBtWqHd.onClick = function()
    {
        dig.plfsize.grpfs.fsize.text = "2560";
    }

    dig.plfsize.grprb.rdBt4K.onClick = function()
    {
        dig.plfsize.grpfs.fsize.text = "3840";
    }

    dig.plfsize.grprb.rdBt8K.onClick = function()
    {
        dig.plfsize.grpfs.fsize.text = "7680";
    }

    dig.btrun.onClick = function()
    {
        var fpath = dig.fpath.text;
        var sval = parseInt(dig.plfsize.grpfs.fsize.text);
        // if (Number.isNaN(sval)) {
        if (isNaN(sval)) {
            alert("サイズは半角数値を入力してください");
            return false;
        }

        if (sval < 1) {
            alert("1px 以上のサイズを指定してください");
            return false;
        }

        // パスを確認
        if (Scml.ExistsPath(fpath) == false) {
            alert("フォルダがありません！");
            return false;
        }

        // ファイル取得
        var files = [];
        var fobj = Folder(fpath);
        for (var st in SUPPORT_TYPES) {
            files = files.concat(fobj.getFiles(SUPPORT_TYPES[st]));
        }

        if (files.length == 0) {
            alert("ファイルがありません");
            return true;
        }

        alert(files.length + " のファイルを処理します");

        doact = dig.pldoact.grpactck.doactchk.value;
        aname = dig.pldoact.grpactList.actlist.selection;
        ImageResize(fpath, files, dig.indexstr.text, sval, doact, aname);

        alert("終了しました!");
        return true;
    }

    dig.show();
}

/**
 * Run
 */
SjImageResizer();
