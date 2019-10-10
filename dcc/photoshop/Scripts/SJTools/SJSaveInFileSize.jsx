/**
 * -----------------------------------------------------------------------------
 *
 *  SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @copyright (c) Copyright 2017 sakaiden and Captain Hansode. All rights reserved.
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 *
 * フォトショップで容量を指定して保存を実行するスクリプトです。
 * ファイルの縦横サイズを小さくすることで、指定の容量までファイルサイズを落とします。
 */
#target photoshop

//var DEBUG_MODE = getini(sjToolsSetting.ini, "SJSaveFileSize", "debag"); //=> "値1"
//import java.awt.Dimension;
//var winsize = Toolkit.getDefaultToolkit().getScreenSize();
//java.awt.GraphicsEnvironment env = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
//java.awt.DisplayMode displayMode = env.getDefaultScreenDevice().getDisplayMode()

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

        if (show) {
            uDlg = new Window('window', title, undefined);
            uDlg.pBar = uDlg.add("progressbar", [10,30,10+384,30+15], 0, max);
            uDlg.messagetext = uDlg.add('statictext', [10,30,10+384,30+15], message);
            uDlg.pBar.value = value;
            uDlg.show();
        } else if (!show) {
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
                break;  // all done
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
 * Ui ダイアログ
 */
function SJSaveInFileSize()
{
    /*--------------------------------------------------------------------------------
    * 定数
    */
    this.VERSION = "0.0.1 beta";
    this.TOOLNAME = "SJ Save In File Size";
    this.AUTHOR = "Captain Hansode";

    this.SUPPORT_TYPES = {jpg: "jpeg!"};
    // this.LONG_SIDE_MODE = true;
    this.MAX_FILES = 32;
    this.MAX_FILE_SIZE = 999999999; // 1Gを超えるファイル

    this.Scml = new SjPsCommonLib();  // 汎用ライブラリ
    this.Prog = new SjProgbar();

    /**--------------------------------------------------------------------------------
     * ファイルサイズレンジ
     * @return {number}
     */
    this.getFileSizeRange = function(maxsize, range)
    {
        var minsize = maxsize - (maxsize * range);
        var ret = (maxsize + minsize) / 2.0;
        return ret
    }

    /**--------------------------------------------------------------------------------
     * ファイルサイズを確認
     * @return {boolean}
     */
    this.checkFileSize = function(maxsize, range, filepath)
    {
        var fileobj = new File(filepath);
        var minsize = maxsize - (maxsize * range);

        if ((fileobj.length >= maxsize) || (fileobj.length <= minsize)) {
        // if ((filesize >= maxsize) || (filesize <= minsize)){
            return false;
        } else {
            return true;
        }
    }

    /**--------------------------------------------------------------------------------
     * ファイル容量を取得
     * @return {number}
     */
    this.getFileSize = function(docs)
    {
        var fileobj = new File(docs.fullName);
        return fileobj.length
    }

    /**--------------------------------------------------------------------------------
     * リサイズドキュメント
     * @param {number} ratio 比率 0.1-100
     */
    this.resizeDocument = function(docment, ratio)
    {
        var ratio = ratio || 0.50;
        preferences.rulerUnits = Units.PIXELS;
        var wh = Scml.GetDocumentSize(docment);
        activeDocument.resizeImage(wh[0] * ratio, wh[1] * ratio);
    }

    /**--------------------------------------------------------------------------------
     * save in filesize の根幹部分
     * @param {string} folderpath
     */
    this.saveInFileSize = function(folderpath, maxsize, range, indexstr, doactck, doact, maxtrycount)
    {
        // 引数の基本値
        var folderpath = folderpath || "C:\\"; // ファイルパス
        var maxsize = maxsize || 20000000; // 指定サイズ
        var range = range || 10.0;  // 誤差
        var inxstr = indexstr || "copy_"; // 名前
        var doactck = doactck || false; // 名前
        var doact = doact || ""; // 名前
    // var maxtrycount = maxtrycount || 10; // 最大調整回数
        var maxtrycount = maxtrycount || 15; // 最大調整回数

        // 値の補正
        maxsize = parseFloat(maxsize);
        maxsize = maxsize * 1000000;

        range = parseFloat(range);
        range = range / 100.0;

        // パスを確認
        var fpath = new File(folderpath);
        var flag = fpath.exists;

        if (!flag) {
            alert("フォルダがありません！");
            return null;
        }

        // ファイル取得
        var folderobj = Folder(fpath);
    // var filelist = folderobj.getFiles(["*.psd", "*.tif", "*.jpg", "*.jpeg"]);
        var filelist = folderobj.getFiles("*.jpg");

        alert(filelist.length + " のファイルを処理");

        // 変数類
        var wh = [0,0];
        var filetype = "";
        var filename = "";
        var fileopt = null;

        var saveasfile = "";
        var originalfile = null;
        var tempfile = null;

        var originalsize = 0.0;
        var sizerange = Scml.getFileSizeRange(maxsize, range);
        var compsize = 0.0;
        var oldcompsize = 0.0;
        var tagetsize = 0.0;

        var compratio = 0.5;
        var oldcompratio = 0.5; // 初期値は0.5

        var checksize = true;
        var n = 1;

        // プログレス
        Prog.Progress(filelist.length, "のぞいちゃダメ!", 0, "開始!", true);

        //---------------------------------------------------
        //
        // ファイルの数だけ
        //
        for (var f in filelist) {
            // ファイルタイプ
            filetype = Scml.GetFileType(filelist[f]);
            // 拡張子が対応していれば継続
            if (SUPPORT_TYPES[filetype] == undefined) {
                continue;
            }
            // ファイルサイズは超えているか？
            if (Scml.checkFileSize(maxsize, range, filelist[f])) {
                // プログレス
                Prog.ProgressUpdate(f, filelist[f] + "は処理する必要がありません");
                continue;
            }
            // ファイル開く
            if (filelist[f] instanceof File) {
                open(filelist[f]);
            }
            // プログレス
            Prog.ProgressUpdate(f, activeDocument.name);
            // 開いたファイルを確保する
            originalfile = activeDocument;
            originalsize = getFileSize(activeDocument);
            // 一時ファイルを確保
            tempfile = fpath + "/" + "temp_ajustfilesize" + "." + filetype;

            newfileobj = new File(tempfile);
            fileopt = Scml.GetFileOptions(filetype);

            compratio = 0.5;
            oldcompratio = 0.5;
            checksize = true;
            n = 1;
            tagetsize = originalsize - sizerange;

            while (checksize) {
                // プログレス
                Prog.ProgressUpdate(f, activeDocument.name + " :　ファイルサイズ調整中...");
                // 保存
                activeDocument.saveAs(newfileobj, fileopt, true, Extension.LOWERCASE);
                // 開く
                app.open(newfileobj);
                //　リサイズ
                resizeDocument(activeDocument, compratio);
                // 保存
                activeDocument.save();
                // 容量を確認
                compsize = getFileSize(activeDocument);
                if (n==1) {
                    oldcompsize = compsize;
                }
                // 閉じる
                activeDocument.close(SaveOptions.DONOTSAVECHANGES);

                // 圧縮率 減算よりも
                // compratio = compsize * 1.0 / originalsize * 1.0;
                // compsize = originalsize - compsize;
                oldcompratio = compratio;
                //
                var logtextalert = n + "回目" + "\t" +
                        "オリジナルサイズ" + "\t" + originalsize + "\t" +
                        "目的サイズ" + "\t" + sizerange + "\t" +
                        "縮小後" + "\t" + compsize + "\t" +
                        "減らすサイズ" + "\t" + (originalsize - sizerange) + "\t" +
                        "減ったサイズ" + "\t" + (originalsize - compsize) + "\t" +
                        "縮小率" + "\t" + compratio + "\t" +
                        "X" + "\t" + ((compratio * (originalsize - sizerange)) / (originalsize - compsize)) + "\t" +
                        "次の縮小率" + "\t" + "-";
                debugWriteLog(logtextalert);

                // 圧縮率を計算
                // 0.5 : 減ったサイズ = x : 目的まで減らすサイズ
                // x = 0.5 * 目的まで減らすサイズ / 減ったサイズ

                compratio = (compratio * (originalsize - sizerange)) / (originalsize - compsize);
                alert(compratio);
                compratio = oldcompratio * (oldcompratio / compratio);
                alert(compratio);
                n++;

                if (Scml.checkFileSize(maxsize, range, newfileobj)){
                    checksize = false;
                }

                if (n == maxtrycount){
                    // プログレス
                    Prog.ProgressUpdate(f, activeDocument.name + " : ごめんムリだった...orz");
                    checksize = false;
                }
            }

            // 削除
            newfileobj.remove();

            // 保存しなおして終わり！
            if (doactck) {
                var actstr = doact.toString().split("---");
                doAction(actstr[1], actstr[0]);
            }

            resizeDocument(activeDocument, compratio);

            tempfile = fpath + "/" + inxstr + activeDocument.name;
            newfileobj = new File(tempfile);
            activeDocument.saveAs(newfileobj, fileopt, true, Extension.LOWERCASE);

            // 閉じる
            activeDocument.close(SaveOptions.DONOTSAVECHANGES);

        }

        // プログレス
        Prog.Progress(100, "おわり!", 100, "おわり!", false);
        alert("終了しました!");
    }

    //--------------------------------------------------------------
    // UI
    //
    // folderObj = new File(app.path);
    // これでデスクトップを指定する
    folderObj = new File("~/Desktop/test");
    fsname = folderObj.fsName;

    var dig = new Window('dialog', TOOLNAME + " " + VERSION);
    dig.alignChildren = "fill";
    dig.opacity = 1.0;

    // パネル追加
    dig.menubar = dig.add('panel', undefined, "フォルダを指定");
    dig.menubar.orientation = "row";
    dig.menubar.alignChildren = "fill";

    dig.menu1 = dig.menubar.add('edittext', [0,0,356,24], fsname);
    dig.menu2 = dig.menubar.add("button", [0,0,30,24], "...", {name:"folder"});

    // パネル追加
    dig.plfolder = dig.add('panel', undefined, "フォルダを指定");
    dig.plfolder.orientation = "row";
    dig.plfolder.alignChildren = "fill";

    dig.fpath = dig.plfolder.add('edittext', [0,0,356,24], fsname);
    dig.btfolder = dig.plfolder.add("button", [0,0,30,24], "...", {name:"folder"});

    // ファイルサイズ
    dig.plfsize = dig.add('panel', undefined, "ファイルサイズを指定");
    dig.plfsize.orientation = "column";
    dig.plfsize.alignChildren = "fill";

    // 一行目
    dig.plfsize.grpfs = dig.plfsize.add('group', undefined);
    dig.plfsize.grpfs.orientation='row';
    dig.plfsize.grpfs.alignChildren="fill";

    dig.plfsize.grpfs.text1 = dig.plfsize.grpfs.add('statictext', undefined, "最大");
    dig.plfsize.grpfs.fsize = dig.plfsize.grpfs.add('edittext', [0,0,120,24], 2.0);
    dig.plfsize.grpfs.fsize.justify = "right";
    dig.plfsize.grpfs.text1 = dig.plfsize.grpfs.add('statictext', undefined, "Mbyte");

    // dig.panel2.group = dig.panel2.add('group', undefined );
    // dig.panel2.group.orientation='row';
    // dig.panel2.group.alignChildren="fill";

    dig.plfsize.grpfs.text1 = dig.plfsize.grpfs.add('statictext', undefined, "誤差");
    dig.plfsize.grpfs.range = dig.plfsize.grpfs.add('edittext', [0,0,124,24], 10.0);
    dig.plfsize.grpfs.range.justify = "right";
    dig.plfsize.grpfs.text1 = dig.plfsize.grpfs.add('statictext', undefined, "%");

    dig.plfsize.grpinfo = dig.plfsize.add('group', undefined );
    dig.plfsize.grpinfo.orientation='row';
    dig.plfsize.grpinfo.alignChildren="fill";

    // var sizeinfo = "Info  " + "2.0Mbyte - 1.98Mbyte の範囲で保存されます"
    var sizeinfo = "Info  " + "誤差は10% ~ 50%です"
    dig.plfsize.grpinfo.info = dig.plfsize.grpinfo.add('statictext', undefined, sizeinfo);

    dig.plindex = dig.add('panel', undefined, "保存時に付ける頭文字");
    dig.plindex.orientation='row';
    dig.plindex.alignChildren="fill";

    dig.indexstr = dig.plindex.add('edittext', [0,0,394,24], "Resize_");

    // パネル追加
    // ファイルサイズ
    dig.pldoact = dig.add('panel', undefined, "保存時に実行するアクション");
    dig.pldoact.orientation = "column";
    dig.pldoact.alignChildren = "fill";

    // 一行目
    dig.pldoact.grpactck = dig.pldoact.add('group', undefined);
    dig.pldoact.grpactck.orientation='row';
    dig.pldoact.grpactck.alignChildren="fill";

    dig.pldoact.grpactck.doactchk = dig.pldoact.grpactck.add('checkbox', [0,0,394,24], "実行する");
    dig.pldoact.grpactck.doactchk.value = true;

    dig.pldoact.grpactList = dig.pldoact.add('group', undefined);
    dig.pldoact.grpactList.orientation='row';
    dig.pldoact.grpactList.alignChildren="fill";

    var actionList = Scml.GetActionSets();
    var actionItems = [];
    for (var i in actionList) {
        for (var k in actionList[i].actions) {
            var actName = actionList[i] + "---" + actionList[i].actions[k];
            actionItems.push(actName);
        }
    }

    // alert(actions);
    dig.pldoact.grpactList.actlist = dig.pldoact.grpactList.add("dropdownlist", [0,0,394,24], actionItems);
    dig.pldoact.grpactList.actlist.selection = 0;

    // パネル追加
    dig.plRun = dig.add('panel', undefined, "");
    dig.plRun.orientation = "row";
    dig.plRun.alignChildren = "fill";

    dig.btrun = dig.plRun.add("button", [0,0,193,36], "実行", {name:"ok"});
    dig.btcancel = dig.plRun.add("button", [0,0,193,36], "キャンセル", {name:"cancel"});

    //--------------------------------------------------------------
    //
    // Events
    //
    //--------------------------------------------------------------
    // フォルダボタン
    dig.btfolder.onClick = function()
    {
        foldername = Folder.selectDialog("フォルダを指定してください");
        if (foldername)
        {
            folderObj = new File(foldername);
            fsname = folderObj.fsName;
            dig.fpath.text = fsname;
        }
    }

    //--------------------------------------------------------------
    // ok

    // alert(dig.plfsize.grpfs.fsize);
    // sizeval  = Integer.parseInt(sizeval);
    // sizeval  = sizeval * 1000000;

    dig.btrun.onClick = function()
    {
        var sel = dig.pldoact.grpactList.actlist.selection;
        dig.pldoact.grpactList.actlist[sel];
        saveInFileSize(
            dig.fpath.text,
            dig.plfsize.grpfs.fsize.text,
            dig.plfsize.grpfs.range.text,
            dig.indexstr.text,
            dig.pldoact.grpactck.doactchk.value,
            dig.pldoact.grpactList.actlist.selection
        )
    }

    dig.show();
}

/**
 * Run
 */
SJSaveInFileSize();
