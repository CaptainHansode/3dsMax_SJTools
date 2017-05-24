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

/*--------------------------------------------------------------------------------
 * 定数
 */
var VERSION = "0.0.1 beta";
var TOOLNAME = "SJ Save In File Size";
var AUTHOR = "Captain Hansode";

var SUPPORT_TYPES = {jpg:"jpeg!"};
var LONG_SIDE_MODE = true;
var MAX_FILES = 32;
var MAX_FILE_SIZE = 999999999; // 1Gを超えるファイル

//var DEBUG_MODE = getini(sjToolsSetting.ini, "SJSaveFileSize", "debag"); //=> "値1"
//import java.awt.Dimension;
//var winsize = Toolkit.getDefaultToolkit().getScreenSize();
//java.awt.GraphicsEnvironment env = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
//java.awt.DisplayMode displayMode = env.getDefaultScreenDevice().getDisplayMode()

/**--------------------------------------------------------------------------------
 *  言語対応
 */
function setLangurigeType()
{
    alert("a");
}

/**--------------------------------------------------------------------------------
 * プログレス
 * @param {number} max
 */
function progress(max, title, value, message, show)
{
    var max = max || 100;
    var title = title || "Progress";
    var value = value || 0;
    var message = message || "Progress";
//	var show = show || true;

    if (show){
        uDlg = new Window('window', title, undefined);
        uDlg.pBar = uDlg.add("progressbar", [10,30,10+384,30+15], 0, max);
        uDlg.messagetext = uDlg.add('statictext', [10,30,10+384,30+15], message);
        uDlg.pBar.value = value;
        uDlg.show();
    }else if (!show){
        uDlg.close();
    }
}


function progressUpdate(value, message)
{
    var value = value || 0;
    var message = message || "Progress";
    uDlg.pBar.value = value;
    uDlg.messagetext.text = message;
}


function debugWriteLog(text)
{
    var logobj = new File("sjtoolslog.txt");
    var log = "";
    var flag = logobj.open("r");

    if (flag == true){
        log = logobj.read();
        log = log + text;
        logobj.close();
    }

    flag = logobj.open("w");

    if (flag == true)
    {
        logobj.writeln(log);
//		logobj.write(text);
        logobj.close();
    }else{
//		alert("ファイルが開けませんでした");
    }
}

/**--------------------------------------------------------------------------------
 * save in filesize の根幹部分
 * @param {string} folderpath
 */
function saveInFileSize(folderpath, maxsize, range, indexstr, doactck, doact, maxtrycount)
{
    //	引数の基本値
    var folderpath	= folderpath || "C:\\";	//	ファイルパス
    var maxsize		= maxsize || 20000000;	//	指定サイズ
    var range		= range || 10.0;		//	誤差
    var inxstr		= indexstr || "copy_";	//	名前
    var doactck		= doactck || false;	//	名前
    var doact		= doact || "";	//	名前
//	var maxtrycount	= maxtrycount || 10;	//	最大調整回数
    var maxtrycount	= maxtrycount || 15;	//	最大調整回数

    //	値の補正
    maxsize	= parseFloat(maxsize);
    maxsize	= maxsize * 1000000;

    range	= parseFloat(range);
    range	= range / 100.0;

    //	パスを確認
    var fpath	= new File(folderpath);
    var flag	= fpath.exists;

    if (!flag) {
        alert("フォルダがありません！");
        return null;
    };

    //	ファイル取得
    var folderobj = Folder(fpath);
//	var filelist = folderobj.getFiles(["*.psd", "*.tif", "*.jpg", "*.jpeg"]);
    var filelist = folderobj.getFiles("*.jpg");

    alert(filelist.length + " のファイルを処理");

    //	変数類
    var wh				= [0,0];
    var filetype		= "";
    var filename		= "";
    var fileopt			= null;

    var saveasfile		= "";
    var originalfile	= null;
    var tempfile		= null;

    var originalsize	= 0.0;
    var sizerange		= getFileSizeRange(maxsize, range);
    var compsize		= 0.0;
    var oldcompsize		= 0.0;
    var tagetsize		= 0.0;

    var compratio		= 0.5;
    var oldcompratio	= 0.5;	//	初期値は0.5

    var checksize = true;
    var n = 1;

    //	プログレス
    progress(max = filelist.length,
             title = "のぞいちゃダメ!",
             value = 0,
             message = "開始!",
             show = true
            );

    //---------------------------------------------------
    //
    //	ファイルの数だけ
    //
    for (var f in filelist) {

        //	ファイルタイプ
        filetype = getFileType(filelist[f]);

        //	拡張子が対応していれば継続
        if (SUPPORT_TYPES[filetype] == undefined){
            continue;
        }

        //	ファイルサイズは超えているか？
        if (checkFileSize(maxsize, range, filelist[f])){
            //	プログレス
            progressUpdate(value = f,
                           message = filelist[f] + "は処理する必要がありません"
                          );
            continue;
        }

        //	ファイル開く
        if (filelist[f] instanceof File) {
            open(filelist[f]);
        }

        //	プログレス
        progressUpdate(value = f, message = activeDocument.name);


        //	開いたファイルを確保する
        originalfile = activeDocument;

        originalsize = getFileSize(activeDocument);

        //	一時ファイルを確保
        tempfile = fpath + "/" + "temp_ajustfilesize" + "." + filetype;

        newfileobj = new File(tempfile);
        fileopt = getFileOptions(filetype);

        compratio = 0.5;
        oldcompratio = 0.5;
        checksize = true;
        n = 1;
        tagetsize = originalsize - sizerange;

        //	ロングサイドモードでは探索は行わない
        if (LONG_SIDE_MODE){
            checksize = false;
        }

        while (checksize) {
            //	プログレス
            progressUpdate(value = f,
                           message = activeDocument.name + " :　ファイルサイズ調整中..."
                          );

            //	保存
            activeDocument.saveAs(newfileobj, fileopt, true, Extension.LOWERCASE);

            //	開く
            app.open(newfileobj);

            //　リサイズ
            resizeDocument(activeDocument, compratio);

            //	保存
            activeDocument.save();

            //	容量を確認
            compsize = getFileSize(activeDocument);

            if (n==1) {
                oldcompsize = compsize;
            }

            //	閉じる
            activeDocument.close(SaveOptions.DONOTSAVECHANGES);

            //	圧縮率 減算よりも
//			compratio = compsize * 1.0 / originalsize * 1.0;
//			compsize = originalsize - compsize;

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

            //	圧縮率を計算
            //	0.5 : 減ったサイズ = x : 目的まで減らすサイズ
            //	x = 0.5 * 目的まで減らすサイズ / 減ったサイズ

            compratio =  (compratio * (originalsize - sizerange)) / (originalsize - compsize);
            alert(compratio);
            compratio = oldcompratio * (oldcompratio / compratio);
            alert(compratio);
            n++;

            if (checkFileSize(maxsize, range, newfileobj)){
                checksize = false;
            }

            if (n == maxtrycount){
                //	プログレス
                progressUpdate(value = f,
                           message = activeDocument.name + " : ごめんムリだった...orz"
                          );
                checksize = false;
            }
        }

        //	削除
        newfileobj.remove();

        //	保存しなおして終わり！
        if (doactck) {
            var actstr = doact.toString().split("---");
            doAction(actstr[1], actstr[0]);
        }

        if(LONG_SIDE_MODE){
            resizeDocumentAtLongSide(activeDocument, 1920)
        }else{
            resizeDocument(activeDocument, compratio);
        }

        tempfile = fpath + "/" + inxstr + activeDocument.name;
        newfileobj = new File(tempfile);
        activeDocument.saveAs(newfileobj, fileopt, true, Extension.LOWERCASE);

        //	閉じる
        activeDocument.close(SaveOptions.DONOTSAVECHANGES);

    }

    //	ファイルの数だけ
    //---------------------------------------------------

    //	プログレス
    progress(max = 100,
             title = "おわり!",
             value = 100,
             message = "おわり!",
             show = false
            );

    alert("終了しました!");
}


/**--------------------------------------------------------------------------------
 * ファイルオプションを取得
 * @param {string} type
 * @return {object}
*/
function getFileOptions(type)
{
    switch(type){
        case "jpg":
                var ret = new JPEGSaveOptions();
                ret.embedColorProfile = true;
                ret.quality = 12;
                ret.formatOptions = FormatOptions.PROGRESSIVE;
                ret.scans = 3;
                ret.matte = MatteType.NONE;
                break;
        case "psd":
                break;
    }
    return ret;
}


/**--------------------------------------------------------------------------------
 * ドキュメントサイズ
 * @return {number[]}
 */
function getDocumentSize(docment)
{
    preferences.rulerUnits = Units.PIXELS;
    var ret = [docment.width.value, docment.height.value];
    return ret;
}


/**--------------------------------------------------------------------------------
 * 辺の長い方でリサイズドキュメントサイズ
 * @param {object} docment
 */
function resizeDocumentAtLongSide(docment, longside)
{
    preferences.rulerUnits = Units.PIXELS;
    var wh			= getDocumentSize(docment);
    var ratio		= 0;
    var shortside	= 0;

    //	幅の方がおおきい
    if (wh[0] >= wh[1]){

        ratio		= longside / wh[0];
        shortside	= wh[1] * ratio;
        activeDocument.resizeImage(longside,shortside);

    }else{

        ratio		= longside / wh[1];
        shortside	= wh[0] * ratio;
        activeDocument.resizeImage(shortside,longside);

    }
}


/**--------------------------------------------------------------------------------
 * リサイズドキュメント
 * @param {number} ratio 比率 0.1-100
 */
function resizeDocument(docment, ratio)
{
    var ratio = ratio || 0.50;
    preferences.rulerUnits = Units.PIXELS;
    var wh = getDocumentSize(docment);
    activeDocument.resizeImage(wh[0] * ratio, wh[1] * ratio);
}


/**--------------------------------------------------------------------------------
 * フォルダのファイルを取得
*/
function getFileOnFolder(folderpath)
{
    var fpath = folderpath || "C:\\";
    alert(fpath);
}


/**--------------------------------------------------------------------------------
 * ファイルの種類
 * @return {string}
 */
function getFileType(filepath)
{
    var checktype = new File(filepath);
    var ret = checktype.fsName.substr(checktype.fsName.length-3,3);
    return ret.toLowerCase()
}


/**--------------------------------------------------------------------------------
 * ファイル容量を取得
 * @return {number}
 */
function getFileSize(docs)
{
    var fileobj = new File(docs.fullName);
    return fileobj.length
}

/**
 * アクションセットを取得
 * @return {string[]}
 */
function getActionSets()
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


/**
 * アクションセット内のアクションを取得
 * @return {string[]}
 */
function getActions(aset)
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


/**--------------------------------------------------------------------------------
 * ファイルサイズを確認
 * @return {boolean}
 */
function checkFileSize(maxsize, range, filepath)
{
    var fileobj = new File(filepath);
    var minsize = maxsize - (maxsize * range);

    if ((fileobj.length >= maxsize) || (fileobj.length <= minsize)){
//	if ((filesize >= maxsize) || (filesize <= minsize)){
        return false;
    }else{
        return true;
    }
}



/**--------------------------------------------------------------------------------
 * ファイルサイズレンジ
 * @return {number}
 */
function getFileSizeRange(maxsize, range)
{
    var minsize = maxsize - (maxsize * range);
    var ret = (maxsize + minsize) / 2.0;
    return ret
}


/**--------------------------------------------------------------------------------
 * Ui ダイアログ
 */
function doIt()
{
    //--------------------------------------------------------------
    //	UI
    //
    //	パス
//	folderObj = new File(app.path);
    //	これでデスクトップを指定する
    folderObj = new File("~/Desktop/test");
    fsname = folderObj.fsName;

    var box = new Window('dialog', TOOLNAME + " " + VERSION);
        box.alignChildren = "fill";
        box.opacity = 1.0;

        //	パネル追加
        box.plfolder = box.add('panel', undefined, "フォルダを指定");
        box.plfolder.orientation = "row";
        box.plfolder.alignChildren = "fill";

            box.fpath = box.plfolder.add('edittext', [0,0,356,24], fsname);
            box.btfolder = box.plfolder.add("button", [0,0,30,24], "...", {name:"folder"});

        //	ファイルサイズ
        box.plfsize = box.add('panel', undefined, "ファイルサイズを指定");
        box.plfsize.orientation = "column";
        box.plfsize.alignChildren = "fill";

        //	一行目
        box.plfsize.grpfs = box.plfsize.add('group', undefined );
        box.plfsize.grpfs.orientation='row';
        box.plfsize.grpfs.alignChildren="fill";

            box.plfsize.grpfs.text1 = box.plfsize.grpfs.add('statictext', undefined, "最大");
            box.plfsize.grpfs.fsize = box.plfsize.grpfs.add('edittext', [0,0,120,24], 2.0);
            box.plfsize.grpfs.fsize.justify = "right";
            box.plfsize.grpfs.text1 = box.plfsize.grpfs.add('statictext', undefined, "Mbyte");

//		box.panel2.group = box.panel2.add('group', undefined );
//		box.panel2.group.orientation='row';
//		box.panel2.group.alignChildren="fill";

            box.plfsize.grpfs.text1 = box.plfsize.grpfs.add('statictext', undefined, "誤差");
            box.plfsize.grpfs.range = box.plfsize.grpfs.add('edittext', [0,0,124,24], 10.0);
            box.plfsize.grpfs.range.justify = "right";
            box.plfsize.grpfs.text1 = box.plfsize.grpfs.add('statictext', undefined, "%");

        box.plfsize.grpinfo = box.plfsize.add('group', undefined );
        box.plfsize.grpinfo.orientation='row';
        box.plfsize.grpinfo.alignChildren="fill";

//			var sizeinfo = "Info  " + "2.0Mbyte - 1.98Mbyte の範囲で保存されます"
            var sizeinfo = "Info  " + "誤差は10% ~ 50%です"
            box.plfsize.grpinfo.info = box.plfsize.grpinfo.add('statictext', undefined, sizeinfo);

        box.plindex = box.add('panel', undefined, "保存時に付ける頭文字");
        box.plindex.orientation='row';
        box.plindex.alignChildren="fill";

            box.indexstr = box.plindex.add('edittext', [0,0,394,24], "Resize_");

        //	パネル追加
        //	ファイルサイズ
        box.pldoact = box.add('panel', undefined, "保存時に実行するアクション");
        box.pldoact.orientation = "column";
        box.pldoact.alignChildren = "fill";

        //	一行目
        box.pldoact.grpactck = box.pldoact.add('group', undefined );
        box.pldoact.grpactck.orientation='row';
        box.pldoact.grpactck.alignChildren="fill";

        box.pldoact.grpactck.doactchk = box.pldoact.grpactck.add('checkbox', [0,0,394,24], "実行する");
        box.pldoact.grpactck.doactchk.value = true;

        box.pldoact.grpactList = box.pldoact.add('group', undefined );
        box.pldoact.grpactList.orientation='row';
        box.pldoact.grpactList.alignChildren="fill";

        var actionList = getActionSets();
        var actionItems = [];
        for (var i in actionList) {
            for (var k in actionList[i].actions) {
                var actName = actionList[i] + "---" + actionList[i].actions[k];
                actionItems.push(actName);
            }
        }

        // alert(actions);
        box.pldoact.grpactList.actlist = box.pldoact.grpactList.add("dropdownlist",[0,0,394,24], actionItems);
        box.pldoact.grpactList.actlist.selection = 0;

        //	パネル追加
        box.plRun = box.add('panel', undefined, "");
        box.plRun.orientation = "row";
        box.plRun.alignChildren = "fill";

            box.btrun = box.plRun.add("button", [0,0,193,36], "実行", {name:"ok"});
            box.btcancel = box.plRun.add("button", [0,0,193,36], "キャンセル", {name:"cancel"});

    //--------------------------------------------------------------
    //
    //	Events
    //
    //--------------------------------------------------------------
    //	フォルダボタン
    box.btfolder.onClick = function(){

        foldername = Folder.selectDialog("フォルダを指定してください");
        if (foldername)
        {
            folderObj = new File(foldername);
            fsname = folderObj.fsName;
            box.fpath.text = fsname;
        }
    }

    //--------------------------------------------------------------
    //	ok

//	alert(box.plfsize.grpfs.fsize);
//	sizeval		= Integer.parseInt(sizeval);
//	sizeval		= sizeval * 1000000;

    box.btrun.onClick = function(){
        var sel = box.pldoact.grpactList.actlist.selection;
        box.pldoact.grpactList.actlist[sel];
        saveInFileSize(
            folderpath 	= box.fpath.text,
            maxsize = box.plfsize.grpfs.fsize.text,
            range = box.plfsize.grpfs.range.text,
            indexstr = box.indexstr.text,
            doactck = box.pldoact.grpactck.doactchk.value,
            doact = box.pldoact.grpactList.actlist.selection
        )
    };

    box.show();

}

doIt();
