/**
 * -----------------------------------------------------------------------------
 *
 * SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @github https://github.com/CaptainHansode/SJTools
 *
 * SJ PBake
 * ひでーなこのコード・・・(；ﾟДﾟ)
 * 誰が書いたんだよ・・・あ、おれかｗ
 *
 */
(
--ロールアウト用
global sj_pbake_rol
global sj_pbake_selset_rol

-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
local MesseTitleInfoStr = "お知らせ";
local MesseTitleWngStr = "警告";
local MesseTitleCtnStr = "注意";
local MesseTitleErrStr = "エラー";
local MesseTitleChkStr = "確認";

local MesseCmnErrStr = "失敗しました";
local MesseCmnChkStr = "実行しますか";
local MesseCmnFileErrStr = "読み込みに失敗しました\n未知の形式のファイルです";
local MesseCmnProgStr = "しばらくお待ちください";

--Version etc 名前自体はSJTools.iniから
local nameAndVersion = "SJ Pbake";
local fileLockID = 8558132647868;

--なんか超いっぱい用
local pbake_bakeType = 1, sByS = 0, bakeFm = #(), f, s, startFmTm, endFmTm, posKeys = #(), rotKeys = #(), scaKeys = #()
local newObj = undefined, lListObj = undefined, rListObj = undefined, tempObj = undefined, bakedSel = #(), itemCount, newObjName = "_Baked", bakeLayer = undefined;

--重複チェック用
local doubleNameCheck = false;

/*
pbake_bakeType
0--全て
1--位置回転
2--位置スケール
3--位置
4--回転スケール
5--回転
6--スケール
*/
--IK格納用
--ikObjに全て格納する、hdikObjはコントローラー削除用
--ikObjContはコントローラー処理中のカウント
local ikCheck = false, ikObjQuery = false, ikObj = #(), hdikObj = #(), ikObjEff = #(), ikObjIndex = #(), ikBakeObj = #(), ikObjCont = 1,ikdependObj = #()
--レイヤー名周り
local newLayer = undefined, numberStr, layerNameStr = "ベイクオブジェクト";
--初期設定、ini内容を上から順に並べている
local iniSetting = #(true,false,true,true,true)
--端から順に、タイプ、オプション、ミラー、スタート、エンド、ステップ、バイステップ、位置キー、回転キー、スケールキー
local toolSetting = #(1,1,false,0,100,1,false,true,true,true)

--ミラーリング
local mT = #(1,-1,-1,-1,1,1,-1,1,1,-1,1,1), mirrorMenu = #(true,false,false,false,false,false,false,false,false)
--オフセット設定
local offsetNum = 1, offsetMenu = #(true,false,false), offsetSetting = #(1,2,3)

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_pbake_rol)catch()
try(cui.unRegisterDialogBar sj_pbake_rol)catch()
try(closeRolloutFloater sj_pbake_rol) catch()
try(destroydialog sj_pbake_rol)catch()
try(destroydialog SjPBakeProg)catch()


function SjPBakeSetDefLayerName =
(
    global sj_pbake_layerName_rol
    try (destroydialog sj_pbake_layerName_rol) catch()
    rollout sj_pbake_layerName_rol "レイヤー名を設定してください" width:200 height:52
    (
        --////////////////////////////////////////////////
        --レイアウト
        edittext newNameEdt "" pos:[4,8] width:188 height:16
        button okBt "OK" pos:[8,28] width:88 height:20 toolTip:"名前を設定します"
        button closeBt "キャンセル" pos:[104,28] width:88 height:20 toolTip:"このウィンドウを閉じます"
        --アクション
        on sj_pbake_layerName_rol open do --ロールアウトが開いたとき
        (
            --変数に適応
            newNameEdt.text = layerNameStr;
        )--open do end
        on okBt pressed do
        (
            layerNameStr = newNameEdt.text;
            --INIに書き込み
            setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJPBake" "BakedLayerName" newNameEdt.text;
            try (destroydialog sj_pbake_layerName_rol) catch() --ダイアログを閉じる
        )
        on closeBt pressed do
        (
            try (destroydialog sj_pbake_layerName_rol) catch() --ダイアログを閉じる
        )
    )
)

--////////////////////////////////////////////////
--ダイアログクリエート
CreateDialog sj_pbake_layerName_rol style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_resizing, #style_toolwindow)

--////////////////////////////////////////////////
--プログレスバー
fn SjPBakeProg =
(
    try (destroydialog SjPBakeProg) catch ();
    global SjPBakeProg
    rollout SjPBakeProg "" width:416 height:56
    (
        progressBar progbar "" pos:[8,8] width:400 height:24 color:(color 30 10 190);
        label processInfo "" pos:[8,36] width:400 height:16;
    )
    CreateDialog SjPBakeProg style:#(/*#style_border, #style_titlebar, #style_sysmenu, #style_resizing,*/ #style_toolwindow, #style_minimizebox) --pos:[50,50]
)

--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu pbakeMenuBar
(
    subMenu "ファイル"
    (
        menuItem saveFileMi "リスト保存" enabled:true
        menuItem loadFileMi "リスト開く" enabled:true
        menuItem mergeFileMi "リスト合成" enabled:true
        seperator sep01
        menuItem saveSettingFileMi "設定を保存" enabled:true
        menuItem loadSettingFileMi "設定を開く" enabled:true
        seperator sep02
        menuItem closeMi "終了" enabled:true
    )

    subMenu "ミラー設定"
    (
        menuItem mirrorYZplaneMi "YZ平面 フリップX" checked:true
        menuItem mirrorXZplaneMi "XZ平面 フリップX" checked:false
        menuItem mirrorXYplaneMi "XY平面 フリップX" checked:false
        seperator sep03
        menuItem mirrorXFripZMi "YZ平面 フリップZ" checked:false
        menuItem mirrorYFripZMi "XZ平面 フリップZ" checked:false
        menuItem mirrorZFripZMi "XY平面 フリップZ" checked:false
        seperator sep04
        menuItem mirrorXFripYMi "YZ平面 フリップY" checked:false
        menuItem mirrorYFripYMi "XZ平面 フリップY" checked:false
        menuItem mirrorZFripYMi "XY平面 フリップY" checked:false
    )
    subMenu "初期設定"
    (
        menuItem loadListMi "前回起動時のリストを維持" enabled:true checked:true;
        menuItem loadSettingMi "前回起動時の設定を維持" enabled:true checked:false;
        seperator sep05
        menuItem pBakedSelectMi "PBake後に選択を解除" enabled:true checked:true;
        seperator sep06
        menuItem bakedLayerMi "BBake後、新しいレイヤーにオブジェクトをまとめる" enabled:true checked:true;
        menuItem bBakedSelectMi "BBake後にオブジェクトを選択" enabled:true checked:true
        seperator sep07
        menuItem bakedLayerNameMi "作成するレイヤー名を設定" enabled:true
    )
    subMenu "ヘルプ"
    (
        menuItem helpMi "ヘルプ"
        menuItem aboutMi "About"
        menuItem emailMi "E-Mail"
    )

    --////////////////////////////////////////////////
    --アクション
    --////////////////////////////////////////////////
    on closeMi  picked do
    (
        try(cui.unRegisterDialogBar sj_pbake_rol)catch()
        try(closeRolloutFloater sj_pbake_rol) catch()
        try(destroydialog sj_pbake_rol)catch()
    )
    on saveFileMi picked do sj_pbake_rol.saveListFile_Fn sj_pbake_rol.pb_listL.items sj_pbake_rol.pb_listR.items
    on loadFileMi picked do sj_pbake_rol.loadListFile_Fn true;

    on saveSettingFileMi picked do sj_pbake_rol.saveSettingFile_Fn()
    on loadSettingFileMi picked do sj_pbake_rol.loadSettingFile_Fn()

    on mergeFileMi picked do sj_pbake_rol.loadListFile_Fn false;
    on mergePoseFileMi picked do sj_pbake_rol.loadPoseFile_Fn false
    on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=4163" ""
    on aboutMi picked do sj_functions.sjtools_about_Fn()
    on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""

    --ミラーリング設定変更
    on mirrorYZplaneMi picked do (
        mT = #(1,-1,-1,-1,1,1,-1,1,1,-1,1,1)
        mirrorMenu = #(true,false,false,false,false,false,false,false,false)
    )
    on mirrorXZplaneMi picked do (
        mT = #(-1,1,-1,1,-1,1,1,-1,1,1,-1,1)
        mirrorMenu = #(false,true,false,false,false,false,false,false,false)
    )
    on mirrorXYplaneMi picked do (
        mT = #(-1,-1,1,1,1,-1,1,1,-1,1,1,-1)
        mirrorMenu = #(false,false,true,false,false,false,false,false,false)
    )
    on mirrorXFripZMi picked do (
        mT = #(-1,1,1,-1,1,1,1,-1,-1,-1,1,1)
        mirrorMenu = #(false,false,false,true,false,false,false,false,false)
    )
    on mirrorYFripZMi picked do (
        mT = #(1,-1,1,1,-1,1,-1,1,-1,1,-1,1)
        mirrorMenu = #(false,false,false,false,true,false,false,false,false)
    )
    on mirrorZFripZMi picked do (
        mT = #(1,1,-1,1,1,-1,-1,-1,1,1,1,-1)
        mirrorMenu = #(false,false,false,false,false,true,false,false,false)
    )
    on mirrorXFripYMi picked do (
        mT = #(-1,1,1,1,-1,-1,-1,1,1,-1,1,1)
        mirrorMenu = #(false,false,false,false,false,false,true,false,false)
    )
    on mirrorYFripYMi picked do (
        mT = #(1,-1,1,-1,1,-1,1,-1,1,1,-1,1)
        mirrorMenu = #(false,false,false,false,false,false,false,true,false)
    )
    on mirrorZFripYMi picked do (
        mT = #(1,1,-1,-1,-1,1,1,1,-1,1,1,-1)
        mirrorMenu = #(false,false,false,false,false,false,false,false,true)
    )

    --初期設定部
    on loadListMi picked do (
        if iniSetting[1] then iniSetting[1] = false else iniSetting[1] = true;
        sj_pbake_rol.saveIni_Fn()
    )
    on loadSettingMi picked do (
        if iniSetting[2] then iniSetting[2] = false else iniSetting[2] = true;
        sj_pbake_rol.saveIni_Fn()
    )
    on pBakedSelectMi picked do (
        if iniSetting[3] then iniSetting[3] = false else iniSetting[3] = true;
        sj_pbake_rol.saveIni_Fn()
    )
    on bakedLayerMi picked do (
        if iniSetting[4] then iniSetting[4] = false else iniSetting[4] = true;
        sj_pbake_rol.saveIni_Fn()
    )
    on bBakedSelectMi picked do (
        if iniSetting[5] then iniSetting[5] = false else iniSetting[5] = true;
        sj_pbake_rol.saveIni_Fn()
    )
    on bakedLayerNameMi picked do
    (
        SjPBakeSetDefLayerName()
    )

    --offset
    on axisHoldMi picked do (
        offsetNum = 1;
        offsetMenu = #(true,false,false)
        offsetSetting =  #(1,2,3)
    )
    on axisReplaceiXYMi picked do (
        offsetNum = 2;
        offsetMenu = #(false,true,false)
        offsetSetting =  #(2,3,1)
    )
    on axisReplaceiXZMi picked do (
        offsetNum = 3;
        offsetMenu = #(false,false,true)
        offsetSetting = #(3,1,2)
    )

    --メニューを開くたびに実行されるアップデート
    on pbakeMenuBar update do
    (
        --ミラー設定
        pbakeMenuBar.mirrorYZplaneMi.checked = mirrorMenu[1]
        pbakeMenuBar.mirrorXZplaneMi.checked = mirrorMenu[2]
        pbakeMenuBar.mirrorXYplaneMi.checked = mirrorMenu[3]
        pbakeMenuBar.mirrorXFripZMi.checked = mirrorMenu[4]
        pbakeMenuBar.mirrorYFripZMi.checked = mirrorMenu[5]
        pbakeMenuBar.mirrorZFripZMi.checked = mirrorMenu[6]
        pbakeMenuBar.mirrorXFripYMi.checked = mirrorMenu[7]
        pbakeMenuBar.mirrorYFripYMi.checked = mirrorMenu[8]
        pbakeMenuBar.mirrorZFripYMi.checked = mirrorMenu[9]


        --初期設定
        pbakeMenuBar.loadListMi.checked = iniSetting[1];
        pbakeMenuBar.loadSettingMi.checked = iniSetting[2];
        pbakeMenuBar.pBakedSelectMi.checked = iniSetting[3];
        pbakeMenuBar.bakedLayerMi.checked = iniSetting[4];
        pbakeMenuBar.bBakedSelectMi.checked = iniSetting[5];

        --offset
        /*
        pbakeMenuBar.axisHoldMi.checked = offsetMenu[1];
        pbakeMenuBar.axisReplaceiXYMi.checked = offsetMenu[2];
        pbakeMenuBar.axisReplaceiXZMi.checked = offsetMenu[3];
        */

        --saveFileMi.caption = "a";
        /*
        pbakeMenuBar.saveBodyBoneMi.enabled = rcMenuFlag
        pbakeMenuBar.loadBodyBoneMi.enabled = rcMenuFlag
        pbakeMenuBar.closeMi.enabled = not rcMenuFlag
        */
    )
)--rcMenu end

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_pbake_rol nameAndVersion width:452 height:404
(
    --////////////////////////////////////////////////
    --初期化
    fn initialize_Fn = (
        --初期設定をiniから読み込む
        inifile = (getDir #scripts) + "\SJTools\SJPBake\SJPBake.ini";
        iniSetting[1] = execute(getINISetting (inifile "SJPBake" "LoadList"))
        iniSetting[2] = execute(getINISetting (inifile "SJPBake" "LoadSetting"))
        iniSetting[3] = execute(getINISetting (inifile "SJPBake" "PBakedSelect"))
        iniSetting[4] = execute(getINISetting (inifile "SJPBake" "BakedLayer"))
        iniSetting[5] = execute(getINISetting (inifile "SJPBake" "BBakedSelect"))

        --変数に適応
        layerNameStr = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJPBake" "BakedLayerName")

        if iniSetting[1] then (
            --Iniファイルから前回起動時の状態を取得
            sj_pbake_rol.pb_listL.items = execute(getINISetting (inifile "SJPBake" "ListL"))
            sj_pbake_rol.pb_listR.items = execute(getINISetting (inifile "SJPBake" "ListR"))
        )

        --変数に適応
        toolSetting = execute(getINISetting (inifile "SJPBake" "ToolSetting"))

        if iniSetting[2] then (
            sj_pbake_rol.pbTypeRb.state = toolSetting[1];
            sj_pbake_rol.pbOpRb.state = toolSetting[2];
            sj_pbake_rol.mirrorChk.checked = toolSetting[3];
            sj_pbake_rol.startFm.value = toolSetting[4];
            sj_pbake_rol.endFm.value = toolSetting[5];
            sj_pbake_rol.stepFm.value = toolSetting[6];
            sj_pbake_rol.sBySCb.checked = toolSetting[7];
            sj_pbake_rol.posCb.checked = toolSetting[8];
            sj_pbake_rol.rotCb.checked = toolSetting[9];
            sj_pbake_rol.scaleCb.checked = toolSetting[10];
        )

        sj_pbake_rol.bakeTypeCheck_Fn()
        sj_pbake_rol.bakeKeyCheck_Fn()
        sj_pbake_rol.listCntL.caption = (sj_pbake_rol.pb_listL.items.count as String)
        sj_pbake_rol.listCntR.caption = (sj_pbake_rol.pb_listR.items.count as String)
    )

    --////////////////////////////////////////////////
    --初期値保存
    fn saveIni_Fn = (
        inifile = (getDir #scripts) + "\SJTools\SJPBake\SJPBake.ini";
        toolSetting[1] = sj_pbake_rol.pbTypeRb.state;
        toolSetting[2] = sj_pbake_rol.pbOpRb.state;
        toolSetting[3] = sj_pbake_rol.mirrorChk.checked;
        toolSetting[4] = sj_pbake_rol.startFm.value;
        toolSetting[5] = sj_pbake_rol.endFm.value;
        toolSetting[6] = sj_pbake_rol.stepFm.value;
        toolSetting[7] = sj_pbake_rol.sBySCb.checked;
        toolSetting[8] = sj_pbake_rol.posCb.checked;
        toolSetting[9] = sj_pbake_rol.rotCb.checked;
        toolSetting[10] = sj_pbake_rol.scaleCb.checked;

        setINISetting (inifile "SJPBake" "LoadList" (iniSetting[1] as String)
        setINISetting (inifile "SJPBake" "LoadSetting" (iniSetting[2] as String)
        setINISetting (inifile "SJPBake" "PBakedSelect" (iniSetting[3] as String)
        setINISetting (inifile "SJPBake" "BakedLayer" (iniSetting[4] as String)
        setINISetting (inifile "SJPBake" "BBakedSelect" (iniSetting[5] as String)
        setINISetting (inifile "SJPBake" "ToolSetting" (toolSetting as String)

        --配列を文字列化
        local arrayStr = "#("
        for i in sj_pbake_rol.pb_listL.items do arrayStr += "\"" + i + "\",";  --\"でダブルクォーテーションのエスケープシーケンス
        if (arrayStr != "#(") then arrayStr = replace arrayStr (arrayStr.count) 1 ")" else arrayStr = "#()";
        setINISetting (inifile "SJPBake" "ListL" arrayStr;

        arrayStr = "#("
        for i in sj_pbake_rol.pb_listR.items do arrayStr += "\"" + i + "\",";--\"でダブルクォーテーションのエスケープシーケンス
        if (arrayStr != "#(") then arrayStr = replace arrayStr (arrayStr.count) 1 ")" else arrayStr = "#()";
        setINISetting (inifile "SJPBake" "ListR" arrayStr;
    )

    --////////////////////////////////////////////////
    --ベイクタイプ判定
    fn bakeTypeCheck_Fn =
    (
        local checkTemp = #()
        case sj_pbake_rol.pbTypeRb.state of
        (
            1:( checkTemp = #(true,false,false))
            2:( checkTemp = #(false,true,true))
            3:( checkTemp = #(false,false,true))
        )

        sj_pbake_rol.mirrorChk.enabled = checkTemp[3];
        --sj_pbake_rol.offsetChk.enabled = checkTemp[1];

        sj_pbake_rol.pbOpRb.enabled = checkTemp[2];
        sj_pbake_rol.pb_listR.enabled = checkTemp[1];
        sj_pbake_rol.addListBtR.enabled = checkTemp[1];
        sj_pbake_rol.upListBtR.enabled = checkTemp[1];
        sj_pbake_rol.downListBtR.enabled = checkTemp[1];
        sj_pbake_rol.sortBtR.enabled = checkTemp[1];
        sj_pbake_rol.pSortBtR.enabled = checkTemp[1];
        sj_pbake_rol.delBtR.enabled = checkTemp[1];
        sj_pbake_rol.clearBtR.enabled = checkTemp[1];
        sj_pbake_rol.allSelListBtR.enabled = checkTemp[1];
        sj_pbake_rol.listCntR.enabled = checkTemp[1];
    )

    --////////////////////////////////////////////////
    --ベイクキーキー判定
    fn bakeKeyCheck_Fn =
    (
        if sj_pbake_rol.posCb.checked == true then
        (
            if sj_pbake_rol.rotCb.checked == true then
            (
                if sj_pbake_rol.scaleCb.checked == true then
                (
                    --全てにキー
                    pbake_bakeType = 0
                    sj_pbake_rol.pBakeBt.enabled = true
                ) else (
                    --位置、回転
                    pbake_bakeType = 1
                    sj_pbake_rol.pBakeBt.enabled = true
                )
            ) else (
                if sj_pbake_rol.scaleCb.checked == true then
                (
                    --位置、スケール
                    pbake_bakeType = 2
                    sj_pbake_rol.pBakeBt.enabled = true
                ) else (
                    --位置のみ
                    pbake_bakeType = 3
                    sj_pbake_rol.pBakeBt.enabled = true
                )
            )
        ) else (
            if sj_pbake_rol.rotCb.checked == true then
            (
                if sj_pbake_rol.scaleCb.checked == true then
                (
                    --回転、スケール
                    pbake_bakeType = 4
                    sj_pbake_rol.pBakeBt.enabled = true
                ) else (
                    --回転のみ
                    pbake_bakeType = 5
                    sj_pbake_rol.pBakeBt.enabled = true
                )
            ) else (
                if sj_pbake_rol.scaleCb.checked == true then
                (
                    --スケールのみ
                    pbake_bakeType = 6
                    sj_pbake_rol.pBakeBt.enabled = true
                ) else (
                    --pBake無効
                    pbake_bakeType = 0
                    sj_pbake_rol.pBakeBt.enabled = false
                )
            )
        )
    )

    --////////////////////////////////////////////////
    --Step by Step　チェック
    fn sBySCheck_Fn stateTm =
    (
        if stateTm != true then
        (
            sj_pbake_rol.stepFm.enabled = true
            sj_pbake_rol.stepLbl.enabled = true
            sByS = 0
        ) else (
            sj_pbake_rol.stepFm.enabled = false
            sj_pbake_rol.stepLbl.enabled = false
            sByS = 1
        )
    )

    --////////////////////////////////////////////////
    --リストは空か？
    fn bakeListCheck_Fn checkList =
    (
        if checkList.count != 0 then
        (
            return true
        )
        else
        (
            messageBox("リストが空ですぅ!") title:MesseTitleInfoStr;
            return false
        )
    )

    --////////////////////////////////////////////////
    --オブジェクトがあるかどうか判定
    fn bakeListSelectCheck_Fn =
    (
        SjPBakeProg.processInfo.caption = "リストをチェック中"
        local checkListTag = sj_pbake_rol.pb_listL.items;--左のアイテム
        local errorFlag = 0, progCount = 1;
        tempObj = undefined;
        local getNodeTemp = undefined;
        local getNodeTempCount = 0;
        --リストはからか？
        if checkListTag.count == 0 do
        (
            messageBox("リストが空です！") title:MesseTitleInfoStr;
            return false;
        )
        --PBake用リスト判定
        if(sj_pbake_rol.pbTypeRb.state == 1)do
        (
            --アイテム数が超えていないか？
            if (sj_pbake_rol.pb_listL.items.count > sj_pbake_rol.pb_listR.items.count) do
            (
                messageBox("ベイクターゲットがありません!\n右リストにターゲットを設定してください") title:MesseTitleInfoStr;
                return false;
            )
        )

        for i in checkListTag do--選択テスト開始
        (
            --オブジェクトを確保--大文字小文字判定あり
            getNodeTemp = (getNodeByName i exact:false ignoreCase:false all:true)
            --上のgetNodeBynameは配列が返されるので注意！
            --オブジェクトはあるか?配列の数が0ならば
            if (getNodeTemp.count == 0) do
            (
                messageBox("以下のオブジェクトがシーン上にありません\n" + i) title:MesseTitleInfoStr;
                return false;
            )
            --同じ名前のオブジェクトがあるか?配列で格納しているので、2以上なら重複名あり
            if (getNodeTemp.count >= 2) do doubleNameCheck = true;
            --Plotの場合の確認bipかどうか確認
            if (sj_pbake_rol.pbTypeRb.state == 3) then
            (
                tempObj = getNodeByName i;
                if ((classOf tempObj) == Biped_Object) or ((classOf tempObj.controller) == BipSlave_Control) then
                (
                    messageBox("PlotはBipedに対応していません。\n" + i) title:MesseTitleInfoStr;
                    return false;
                )
            )
            --プログレス処理
            progCount += 1;
            SjPBakeProg.progbar.color = (color 190 10 30)
            SjPBakeProg.progbar.value = ((100.00/checkListTag.count) * progCount) as Integer;
        )

        getNodeTempCount = 0;
        --pbakeの場合は右リストも検索
        if (sj_pbake_rol.pbTypeRb.state == 1) do
        (
        --一端初期化、左側リストの重複用のフラグはすでに処理済み
        getNodeTemp = undefined;

        checkListTag = sj_pbake_rol.pb_listR.items;
        progCount = 1;

            for i in checkListTag do--選択テスト開始
            (
                --オブジェクトを確保
                getNodeTemp = (getNodeByName i exact:false ignoreCase:false all:true)
                --オブジェクトはあるか?配列の数が0ならば
                if (getNodeTemp.count == 0) do
                (
                    messageBox("以下のオブジェクトがシーン上にありません\n" + i) title:MesseTitleInfoStr;
                    return false;
                )
                --同じ名前のオブジェクトがあるか?
                if (getNodeTemp.count > 1) do doubleNameCheck = true;

                --プログレス
                progCount += 1;
                SjPBakeProg.progbar.color = (color 190 10 30)
                SjPBakeProg.progbar.value = ((100.00/checkListTag.count) * progCount) as Integer;
            )
        )
        --プログレス処理
        SjPBakeProg.progbar.color = (color 30 10 190)
        SjPBakeProg.progbar.value = 0;
        tempObj = undefined;
        return true;
    )


    --////////////////////////////////////////////////
    --IKオブジェクトを確認して格納する
    fn bakeListIKCheck_Fn =
    (
        SjPBakeProg.processInfo.caption = "リストチェック中";
        local checkListTag = sj_pbake_rol.pb_listL.items;
        local progCount = 1, k = undefined;

        --初期化
        ikCheck = false;
        ikObjQuery = false;
        ikObj = #()
        hdikObj = #()
        ikObjEff = #()
        ikObjIndex = #()
        ikBakeObj = #()
        ikObjCont = 1;
        ikdependObj = #()

        for i in checkListTag do--選択テスト開始
        (
            k = (getNodeByName i)
            --Kのオブジェクトがシーンにあるか？
            if (k != undefined ) do
            (
                --IK関連のオブジェクトなら回収
                if ((classOf k.controller) == IKControl) then
                (
                    append ikObj k;
                    --そのindexを回収progCountはLsitのIDと一致している
                    append ikObjIndex progCount;
                    ikCheck = true;
                )

                --HDIKを回収
                if ((classOf k.controller) == IK_ControllerMatrix3Controller) then
                (
                    append ikObj k;
                    append hdikObj k;
                    --そのindexを回収progCountはLsitのIDと一致している
                    append ikObjIndex progCount;
                    ikCheck = true;
                )

                --こっちはエフェクタ
                if ((classOf k) == IK_Chain_Object) then
                (
                    append ikObj k;
                    append ikObjEff k;
                    --そのindexを回収progCountはLsitのIDと一致している
                    append ikObjIndex progCount;
                    ikCheck = true;
                    --append ikObjIndex progCount;
                )
            )
            --progCountはLsitのIDと一致している
            progCount += 1;
            SjPBakeProg.progbar.value = ((100.00/sj_pbake_rol.pb_listL.items.count) * progCount) as Integer;
        )
    )

    --////////////////////////////////////////////////
    --リストに追加ファンクション
    fn addList_Fn =
    (
        local addList = #()
        for i in selection do
        (
            append addList i.name;
        )
        return addList;
    )

    --////////////////////////////////////////////////
    --削除ファンクション 短いけどまぁ、練習のために
    fn deleteList_Fn delList delSel =
    (
        if delList.count != 0 then deleteItem delList delSel --削除
    )

    --////////////////////////////////////////////////
    --アップダウン
    fn selUp_Fn selUpList selUpIndex =
    (
        next = selUpList[ selUpIndex - 1 ]
        selUpList[ selUpIndex - 1 ] = selUpList[selUpIndex]
        selUpList[selUpIndex] = next
    )

    fn selDown_Fn selDownList selDownIndex =
    (
        next = selDownList[ selDownIndex + 1 ]
        selDownList[ selDownIndex + 1 ] = selDownList[selDownIndex]
        selDownList[selDownIndex] = next
    )

    --////////////////////////////////////////////////
    --ソートファンクション　ファンクション化する必要はないけど練習に
    fn sortList_Fn sortList =
    (
        local sortTemp =#()
        sortTemp = sortList
        sort sortTemp
    )

    --////////////////////////////////////////////////
    --親子順にソートする
    fn parentSort_Fn sortList =
    (
        --変数を準備
        local selObj = #()
        local myObjAll = #()
        local addList = #()
        local delName = #()
        local delNameAll = "";
        tempObj = undefined;

        --ソートリストから一端取得する
        for i in sortList do
        (
            tempObj = (getNodeByName i ignoreCase:false all:false)
            --存在してなかったら、警告を出す様に名前を回収
            if (tempObj != undefined) then (append selObj tempObj)else(append delName i )
        )
            tempObj = undefined;
        --確保できたならば
        if selObj.count != 0 then
        (
            myObjAll = (sj_functions.sj_sortByBranch_Fn selObj)--ソート関数に送る
            addList = for i in myObjAll collect i.name;--名前を回収
        --数が減っていたら警告を出す
            if (sortList.count > addList.count) then
            (
                for i in delName do delNameAll += i + ", ";
                messageBox("シーンに存在しかなった以下の項目を削除しました\n"+ delNameAll + "\n ")title:MesseTitleInfoStr;
            )
            --初期化してgc、一応メモリを開放
            selObj = #()
            myObjAll = #()
            delName = #()
            gc()

            return addList;
        ) else (
            messageBox("リスト上のオブジェクトがシーン上にありません\n ")title:MesseTitleInfoStr
        )

        --オブジェクトが無ければそのままリターン
        tempObj = undefined;
        return sortList;
    )

    --////////////////////////////////////////////////
    --全選択
    fn allSelList_Fn selList =
    (
        clearSelection()
        SjPBakeProg();
        SjPBakeProg.processInfo.caption = "選択中"
        if (bakeListCheck_Fn selList) == true do
        (
            for i=1 to selList.count do--選択テスト開始
            (
                try(
                    selectMore (getNodeByName selList[i])
                ) catch (
                    messageBox("以下のオブジェクトがシーン上にありません\n" + (selList[i]))title:MesseTitleInfoStr;
                )
                SjPBakeProg.progbar.value = ((100.00/sj_pbake_rol.pb_listL.items.count) * i)
            )
        )
    )

    --////////////////////////////////////////////////
    --save
    fn saveListFile_Fn saveListL saveListR =
    (
        if saveListL.count != 0 then
        (
            local saveFile = getSaveFileName types:"Bake List File (*.blf)|*.blf|All(*.*)|*.*" caption:"リストを保存"

            if saveFile != undefined do
            (
                saveFileList = createFile saveFile
                format "%\n" saveListL.count to:saveFileList
                for i in saveListL do
                (
                    format "%\n" i to:saveFileList
                )

                format "%\n" saveListR.count to:saveFileList
                for i in saveListR do
                (
                    format "%\n" i to:saveFileList
                )
                close saveFileList
            )
        ) else (
            messageBox("リストが空です!")title:MesseTitleInfoStr;
        )
    )

    --////////////////////////////////////////////////
    --load
    fn loadListFile_Fn isClear =
    (
        local itemName = #(), loadItemCount = 0
        local loadFile = getOpenFileName types:"Bake List File (*.blf)|*.blf|All(*.*)|*.*" caption:"リストを読み込み"

        if loadFile != undefined do
        (
            loadFileList = openFile loadFile;
            loadItemCount = readValue loadFileList;
            for i=1 to loadItemCount do
            (
                append itemName (( readLine loadFileList ) as String)
            )
            if isClear then
            (
                sj_pbake_rol.pb_listL.items = itemName
            ) else (
                sj_pbake_rol.pb_listL.items += itemName
            )

            itemName = #()
            loadItemCount = readValue loadFileList
            for i=1 to loadItemCount do
            (
                append itemName (( readLine loadFileList ) as String)
            )

            if isClear then
            (
                sj_pbake_rol.pb_listR.items = itemName
            ) else (
                sj_pbake_rol.pb_listR.items += itemName
            )

            sj_pbake_rol.listCntL.caption = (sj_pbake_rol.pb_listL.items.count as String)
            sj_pbake_rol.listCntR.caption = (sj_pbake_rol.pb_listR.items.count as String)
            close loadFileList
        )
    )

--////////////////////////////////////////////////
--save
--////////////////////////////////////////////////
fn saveSettingFile_Fn =
(
        local saveFile = getSaveFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"設定を保存"

        if saveFile != undefined do
        (
            saveSetting = createFile saveFile
            format "%" toolSetting to:saveSetting
            close saveSetting
        )
)

--////////////////////////////////////////////////
--load
--////////////////////////////////////////////////
fn loadSettingFile_Fn =
(
    local loadSettingFile = getOpenFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"設定を読み込み"

    if loadSettingFile != undefined do
    (
        loadSetting = openFile loadSettingFile;
        toolSetting = execute(readLine loadSetting)

    sj_pbake_rol.pbTypeRb.state = toolSetting[1];
    sj_pbake_rol.pbOpRb.state = toolSetting[2];
    sj_pbake_rol.mirrorChk.checked = toolSetting[3];
    sj_pbake_rol.startFm.value = toolSetting[4];
    sj_pbake_rol.endFm.value = toolSetting[5];
    sj_pbake_rol.stepFm.value = toolSetting[6];
    sj_pbake_rol.sBySCb.checked = toolSetting[7];
    sj_pbake_rol.posCb.checked = toolSetting[8];
    sj_pbake_rol.rotCb.checked = toolSetting[9];
    sj_pbake_rol.scaleCb.checked = toolSetting[10];

        close loadSetting
    )

    sj_pbake_rol.bakeTypeCheck_Fn()
    sj_pbake_rol.bakeKeyCheck_Fn()
)

--////////////////////////////////////////////////
--レイヤー処理
--////////////////////////////////////////////////
fn createNewLayer_Fn layerNameStr =
(
local i = 1
numberStr = "01"
newLayer = layerNameStr+numberStr
while (layermanager.getLayerFromName newLayer) != undefined do
(
i += 1
numberStr = (i as String)
if numberStr.count == 1 then numberStr = ("0"+NumberStr)
newLayer = layerNameStr + numberStr
)
newLayer = layermanager.newLayerFromName newLayer
newLayer.current = true
)

-----------------------------------------------------------------------------------------------------------
--ベイク処理本体
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--キー取得
--////////////////////////////////////////////////
fn getKeyArray_Fn lListObj bakeFm =
(
    posKeys = #()
    rotKeys = #()
    scaKeys = #()

    try(
    for k in lListObj.pos.controller.keys do
    (if k.time >= startFmTm and k.time <= endFmTm do append posKeys k.time)
    )catch( posKeys = bakeFm )
    try(
    for k in lListObj.rotation.controller.keys do
    (if k.time >= startFmTm and k.time <= endFmTm do append rotKeys k.time)
    )catch( rotKeys = bakeFm )
    try(
    for k in lListObj.scale.controller.keys do
    (if k.time >= startFmTm and k.time <= endFmTm do append scaKeys k.time)
    )catch( scaKeys = bakeFm )

    return posKeys
    return rotKeys
    return scaKeys
)

--////////////////////////////////////////////////
--アニメーションキー処理
--////////////////////////////////////////////////
--Type0 all key
fn allKeyCreate_Fn sel tag frame = ( undo off( for i in frame do animate on (at time i sel.transform = tag.transform) ) )

--Type1 pos rot
fn keyCreateTypeOne_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.pos = tag.pos --位置,オートキーを利用してキーを作成する
            sel.rotation.X_Rotation = (in coordsys world tag.rotation.X_Rotation)
            sel.rotation.Y_Rotation = (in coordsys world tag.rotation.Y_Rotation)
            sel.rotation.Z_Rotation = (in coordsys world tag.rotation.Z_Rotation)
            )
        )
    )
)--undo off end
)

--Type2 pos sca
fn keyCreateTypeTwo_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.pos = tag.pos --位置,オートキーを利用してキーを作成する
            sel.scale = tag.scale
            )
        )
    )
)--undo off end
)

--Type3 pos
fn keyCreateTypeThree_Fn sel tag frame = ( undo off( for i in frame do animate on (at time i sel.pos = tag.pos) ) )

--Type4 rot sca
fn keyCreateTypeFore_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.rotation.X_Rotation = (in coordsys world tag.rotation.X_Rotation)
            sel.rotation.Y_Rotation = (in coordsys world tag.rotation.Y_Rotation)
            sel.rotation.Z_Rotation = (in coordsys world tag.rotation.Z_Rotation)
            sel.scale = tag.scale
            )
        )

    )
)--undo off end
)

--Type5 rot
fn keyCreateTypeFive_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.rotation.X_Rotation = (in coordsys world tag.rotation.X_Rotation)
            sel.rotation.Y_Rotation = (in coordsys world tag.rotation.Y_Rotation)
            sel.rotation.Z_Rotation = (in coordsys world tag.rotation.Z_Rotation)
            )
        )
    )
)--undo off end
)

--Type6 sca
fn keyCreateTypeSix_Fn sel tag frame = ( undo off( for i in frame do animate on (at time i sel.scale = tag.scale) ) )

--step by step
fn keyPosCreate_Fn sel tag frame = ( undo off( for i in frame do animate on at time i sel.pos = tag.pos ) )

--step by step
fn keyRotCreate_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.rotation.X_Rotation = (in coordsys world tag.rotation.X_Rotation) --ワールドに換算した数値を代入する、オートキーを利用してキーを作成する
            sel.rotation.Y_Rotation = (in coordsys world tag.rotation.Y_Rotation)
            sel.rotation.Z_Rotation = (in coordsys world tag.rotation.Z_Rotation)
            )
        )
    )
)--undo off end
)

--step by step
fn keyScaCreate_Fn sel tag frame = ( undo off( for i in frame do animate on at time i sel.scale = tag.scale ) )

--////////////////////////////////////////////////
--アニメーションキー処理ミラー
--////////////////////////////////////////////////
fn keyMirrorCreate_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
            at time i
            (
            sel.transform =
            (
            matrix3 \
            [(mT[1] * tag.transform[1][1]),(mT[2] * tag.transform[1][2]),(mT[3] * tag.transform[1][3])]\
            [(mT[4] * tag.transform[2][1]),(mT[5] * tag.transform[2][2]),(mT[6] * tag.transform[2][3])]\
            [(mT[7] * tag.transform[3][1]),(mT[8] * tag.transform[3][2]),(mT[9] * tag.transform[3][3])]\
            [(mT[10] * tag.transform[4][1]),(mT[11] * tag.transform[4][2]),(mT[12] * tag.transform[4][3])]
            )
            )
        )
    )
)--undo off end
)

--////////////////////////////////////////////////
--アニメーションキー処理オフセット
--////////////////////////////////////////////////
fn keyOffsetCreate_Fn sel tag frame =
(
undo off
(
    for i in frame do
    (
        with animate on
        (
                at time i
                (
                sel.transform =
                (matrix3 tag.transform[offsetSetting[1]] tag.transform[offsetSetting[2]] tag.transform[offsetSetting[3]] tag.transform[4])
                )--at time
        )--animate
    )
)-- un do end

)

--////////////////////////////////////////////////
--アニメーションキー処理BIP
--////////////////////////////////////////////////
fn keyBipCreate_Fn sel tag frame =
(
/*
pbake_bakeType
0--全て
1--位置回転
2--位置スケール
3--位置
4--回転スケール
5--回転
6--スケール
*/
undo off
(
    for i in frame do
    (
        with animate on
        (
                at time i
                (

                if (pbake_bakeType != 4) or (pbake_bakeType != 5) or (pbake_bakeType != 6) then
                (
                biped.setTransform sel #pos (tag.transform.translationpart) true;
                )

                if (pbake_bakeType != 2) or (pbake_bakeType != 3) or (pbake_bakeType != 6) then
                (
                biped.setTransform sel #rotation (tag.transform.rotationpart) true;
                )

                )--at time end
        )--animate end
    )
)--undo off end
)


-----------------------------------------------------------------------------------------------------------
-- Layout
-----------------------------------------------------------------------------------------------------------
--Bakeタイプ選択
    GroupBox grp_bakeType "タイプ" pos:[8,4] width:64 height:84;
    radiobuttons pbTypeRb "" pos:[12,20] width:61 height:48 labels:#("PBake", "BBake", "Plot") default:1 columns:1;

--Bakeオプション
    GroupBox grp_bakeOptions "オプション" pos:[80,4] width:80 height:84
    --checkbox offsetChk "オフセット" pos:[88,20] width:64 height:16 enabled:false
    checkbox mirrorChk "ミラー" pos:[88,20] width:56 height:16 enabled:false
    radiobuttons pbOpRb "" pos:[88,35] width:86 height:32 enabled:false labels:#("ポイント", "オリジナル") default:1 columns:1

--フレーム設定SJ_button_parentsort.png
    GroupBox grp_frame "フレーム" pos:[168,4] width:200 height:84;
    label startLbl "スタート" pos:[176,20] width:48 height:16;
    label endLbl "エンド" pos:[176,40] width:48 height:16;
    label stepLbl "ステップ" pos:[176,60] width:48 height:16;
    spinner startFm "" pos:[220,20] width:80 height:16 range:[-1e+009,1e+009,animationRange.Start] type:#integer;
    spinner endFm "" pos:[220,40] width:80 height:16 range:[-1e+009,1e+009,animationRange.End] type:#integer;
    /*
    spinner startFm "" pos:[220,20] width:80 height:16 range:[-1e+009,1e+009,animationRange.Start] type:#integer;
    spinner endFm "" pos:[220,40] width:80 height:16 range:[-1e+009,1e+009,animationRange.End] type:#integer;
    */
    spinner stepFm "" pos:[220,60] width:80 height:16 range:[1,10000,1] type:#integer;
    button nowTimeSBt "Now" pos:[304,20] width:56 height:16;
    button nowTimeEBt "Now" pos:[304,40] width:56 height:16
    checkbox sBySCb "byStep" pos:[304,60] width:57 height:15 checked:false --width:48 height:16;

--キー設定
    GroupBox grp_key "キー" pos:[376,4] width:68 height:84;
    checkbox posCb "位置" pos:[384,20] width:56 height:16 checked:true;
    checkbox rotCb "回転" pos:[384,36] width:56 height:16 checked:true;
    checkbox scaleCb "スケール" pos:[384,52] width:56 height:16 checked:true;

--Bakeボタン
    button pBakeBt "P Bake !" pos:[8,368] width:436 height:32 toolTip:"おっぱじめようぜッ!";

--左
    GroupBox grp_list "リスト" pos:[8,92] width:436 height:272;

    listbox pb_listL "" pos:[16,132] width:208 height:16;
    button addListBtL "" pos:[16,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2) toolTip:"選択を追加";
    button allSelListBtL "" pos:[40,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2) toolTip:"全選択";
    button upListBtL "" pos:[64,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.png", "$Scripts/SJTools/Images//SJ_button_up_a.png", 2, 1, 1, 2, 2) toolTip:"Up";
    button downListBtL "" pos:[88,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.png", "$Scripts/SJTools/Images//SJ_button_down_a.png", 2, 1, 1, 2, 2) toolTip:"Down";
    button sortBtL "ソート" pos:[112,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_sort.png", "$Scripts/SJTools/Images//SJ_button_sort_a.png", 2, 1, 1, 2, 2) toolTip:"名前順でソートする";
    button pSortBtL "ソート" pos:[136,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_parentsort.png", "$Scripts/SJTools/Images//SJ_button_parentsort_a.png", 2, 1, 1, 2, 2) toolTip:"親子構造順にソートする";
    button delBtL "" pos:[160,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2) toolTip:"削除";
    button clearBtL "" pos:[184,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2) toolTip:"クリア";
    label listCntL "0" pos:[20,348] width:204 height:13;

--右
    listbox pb_listR "" pos:[228,132] width:208 height:16;
    button addListBtR "" pos:[228,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2) toolTip:"選択を追加";
    button allSelListBtR "" pos:[252,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2) toolTip:"全選択";
    button upListBtR "" pos:[276,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.png", "$Scripts/SJTools/Images//SJ_button_up_a.png", 2, 1, 1, 2, 2) toolTip:"Up";
    button downListBtR "" pos:[300,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.png", "$Scripts/SJTools/Images//SJ_button_down_a.png", 2, 1, 1, 2, 2) toolTip:"Down";
    button sortBtR "ソート" pos:[324,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_sort.png", "$Scripts/SJTools/Images//SJ_button_sort_a.png", 2, 1, 1, 2, 2) toolTip:"名前順でソートする";
    button pSortBtR "ソート" pos:[348,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_parentsort.png", "$Scripts/SJTools/Images//SJ_button_parentsort_a.png", 2, 1, 1, 2, 2) toolTip:"親子構造順にソートする";
    button delBtR "" pos:[372,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2) toolTip:"削除";
    button clearBtR "" pos:[396,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2) toolTip:"クリア";
    label listCntR "0" pos:[232,348] width:204 height:13;


    local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
    ImgTag resizeImg "Bitmap" pos:[442,394] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255)

-----------------------------------------------------------------------------------------------------------
-- 設定
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--フレーム処理
--////////////////////////////////////////////////
    on nowTimeSBt pressed do startFm.value = currentTime;
    on nowTimeEBt pressed do endFm.value = currentTime;

--////////////////////////////////////////////////
--ベイクタイプ判定
--////////////////////////////////////////////////
    on pbTypeRb changed state do bakeTypeCheck_Fn()

--////////////////////////////////////////////////
--キー判定処理
--////////////////////////////////////////////////
    on posCb changed state do (bakeKeyCheck_Fn())
    on rotCb changed state do bakeKeyCheck_Fn()
    on scaleCb changed state do bakeKeyCheck_Fn()	;
    on sBySCb changed state do sBySCheck_Fn state

    on offsetChk changed state do
    (
        if state then(
        pbake_bakeType = 7;
        )else(bakeKeyCheck_Fn())
    )

-------------------------------------------------------------------------------------------------------
-- リスト処理
-----------------------------------------------------------------------------------------------------------
--リストからオブジェクトを選択
    on pb_listR doubleclicked sR do --ダブルクリックで実行するイベントハンドラ
    try
    (
        select (getNodeByName pb_listR.items[sR]) -- オブジェクトを選択する
    )catch(messageBox("選択した名前のオブジェクトがありません!")title:MesseTitleInfoStr)

    on pb_listL doubleclicked sL do --ダブルクリックで実行するイベントハンドラ
    try
    (
        select (getNodeByName pb_listL.items[sL]) -- オブジェクトを選択する
    )catch(messageBox("選択した名前のオブジェクトがありません!")title:MesseTitleInfoStr)

--選択追加
    on addListBtR pressed do
    (
        pb_listR.items += addList_Fn()
        listCntR.caption = (pb_listR.items.count as String)
    )
    on addListBtL pressed do
    (
        pb_listL.items += addList_Fn()
        listCntL.caption = (pb_listL.items.count as String)
    )

--Up Down
    on upListBtR pressed do
    (
        if pb_listR.selection != 0 and pb_listR.selection != 1 do -- セレクトされていて、なおかつ配列の最初が選択されていなければ
        (
        (selUp_Fn pb_listR.items pb_listR.selection)
        pb_listR.items = pb_listR.items --表示更新
        pb_listR.selection -= 1 --選択更新用
        pb_listR.selection = pb_listR.selection --選択更新
        )
        listCntR.caption = (pb_listR.items.count as String)
    )
    on upListBtL pressed do
    (
        if pb_listL.selection != 0 and pb_listL.selection != 1 do -- セレクトされていて、なおかつ配列の最初が選択されていなければ
        (
        (selUp_Fn pb_listL.items pb_listL.selection)
        pb_listL.items = pb_listL.items --表示更新
        pb_listL.selection -= 1 --選択更新用
        pb_listL.selection = pb_listL.selection --選択更新
        )
        listCntL.caption = (pb_listL.items.count as String)
    )

    on downListBtR pressed do
    (
        if  pb_listR.selection != 0 and  pb_listR.items.count > pb_listR.selection do --セレクトされていて、なおかつ配列の最後が選択されていなければ
        (
        (selDown_Fn pb_listR.items pb_listR.selection)
        pb_listR.items = pb_listR.items --表示更新
        pb_listR.selection += 1 --選択更新用
        pb_listR.selection = pb_listR.selection --選択更新
        )
        listCntR.caption = (pb_listR.items.count as String)
    )

    on downListBtL pressed do
    (
        if pb_listL.selection != 0 and pb_listL.items.count > pb_listL.selection do --セレクトされていて、なおかつ配列の最後が選択されていなければ
        (
        (selDown_Fn pb_listL.items pb_listL.selection)
        pb_listL.items = pb_listL.items --表示更新
        pb_listL.selection += 1 --選択更新用
        pb_listL.selection = pb_listL.selection --選択更新
        )
        listCntL.caption = (pb_listL.items.count as String)
    )

--sort
    on sortBtR pressed do
    (
        pb_listR.items = sortList_Fn pb_listR.items;
        listCntR.caption = (pb_listR.items.count as String)
    )
    on sortBtL pressed do
    (
        pb_listL.items = sortList_Fn pb_listL.items;
        listCntL.caption = (pb_listL.items.count as String)
    )
    on pSortBtR pressed do
    (
        pb_listR.items = parentSort_Fn pb_listR.items;
        listCntR.caption = (pb_listR.items.count as String)
    )
    on pSortBtL pressed do
    (
        pb_listL.items = parentSort_Fn pb_listL.items;
        listCntL.caption = (pb_listL.items.count as String)
    )

--delete
    on delBtR pressed do
    (
        if pb_listR.selection != 0 do
        (
        (deleteList_Fn pb_listR.items pb_listR.selection)
        pb_listR.items = pb_listR.items --表示更新用
        )
        listCntR.caption = (pb_listR.items.count as String)
    )
    on delBtL pressed do
    (
        if pb_listL.selection != 0 do
        (
        (deleteList_Fn pb_listL.items pb_listL.selection)
        pb_listL.items = pb_listL.items --表示更新用
        )
        listCntL.caption = (pb_listL.items.count as String)
    )

--clear
    on clearBtR pressed do
    (
    pb_listR.items = #()
    listCntR.caption = (pb_listR.items.count as String)
    )
    on clearBtL pressed do
    (
    pb_listL.items = #()
    listCntL.caption = (pb_listL.items.count as String)
    )

--All select
    on allSelListBtR pressed do
    (sj_functions.sj_progressBar_Fn()
    allSelList_Fn pb_listR.items
    try(destroydialog SjPBakeProg)catch())
    on allSelListBtL pressed do
    (sj_functions.sj_progressBar_Fn()
    allSelList_Fn pb_listL.items
    try(destroydialog SjPBakeProg)catch())

--Save
    on saveListBtR pressed do
    (
        saveList_Fn pb_listR.items
        listCntR.caption = (pb_listR.items.count as String)
    )
    on saveListBtL pressed do
    (
        saveList_Fn pb_listL.items
        listCntL.caption = (pb_listL.items.count as String)
    )

--Load
    on loadListBtR pressed do
    (
        loadList_Fn()
        listCntR.caption = (pb_listR.items.count as String)
    )
    on loadListBtL pressed do
    (
        loadList_Fn()
        listCntL.caption = (pb_listL.items.count as String)
    )

--////////////////////////////////////////////////////////////////////////////////////////////////////
--レッツpbake
--////////////////////////////////////////////////////////////////////////////////////////////////////
    on pBakeBt pressed do
    (

    --////////////////////////////////////////////////
    --変数などを設定
    --////////////////////////////////////////////////
    sj_functions.sj_progressBar_Fn()
    --フレーム用
    startFmTm = startFm.value; endFmTm = endFm.value; posKeys = #() rotKeys = #() scaKeys = #()
    --オブジェクト用
    newObj = undefined; lListObj = undefined; rListObj = undefined; bakedSel = #()
    itemCount = pb_listL.items.count --forループ回数

    --重複チェック初期化
    doubleNameCheck = false;

    if not mirrorChk.checked then --Mirror?
    (newObjName = "_Baked")else(newObjName = "_MirrorBaked")

        --------------------------------------------
        --フレームを取得
        bakeFm = #()
        f = ( endFm.value - ( startFm.value ) ) / stepFm.value; --回数
        s = stepFm.value --ステップ数

        --最初のフレームを挿入
        append bakeFm startFm.value;
        --回収
        for i=1 to f do append bakeFm (startFm.value + (i*s))
        --最後のフレームが無ければ挿入
        if (findItem bakeFm endFm.value) == 0 then append bakeFm endFm.value;

    --////////////////////////////////////////////////
    --maxの余分な処理を押さえ　処理速度を高速化
    --////////////////////////////////////////////////
    suspendEditing()--サスペンドモード
    if maxOps.getSetKeyMode() == true do max set key mode --セットキーモードだった場合にセットキーモードをoff
    max create mode--クリエートモードに変更
    with redraw off
    (--再描画禁止

    --設定フレームチェック
    if endFmTm >= startFmTm then
    (
    )--設定フレームチェック
    else
    (
        messageBox("エンドフレームをスタートフレームより大きい時間で設定してください!")title:MesseTitleInfoStr;
        return ()--リターンで終了
    )-- ifエンドフレーム判定

    --リストのオブジェクトはシーン上にあるか?
    --リストの中身をチェック
    if bakeListSelectCheck_Fn() then
    (
        if doubleNameCheck do messageBox("シーン内のオブジェクトの名前が重複しています\n誤動作をする可能性がありますので\nご注意ください\n ")title:MesseTitleChkStr;
    )else(
        try(destroydialog SjPBakeProg)catch()
        return ()--リターンで処理終了
    ) リストのオブジェクト存在チェック


    case pbTypeRb.state of
    (

        --////////////////////////////////////////////////
        --処理1 Pbake
        --////////////////////////////////////////////////
        1:(
                --IKオブジェクトをチェック
                bakeListIKCheck_Fn()

                if ikCheck then
                (
                --IKが見つかったら警告を出す
                if not (queryBox("IKコントローラーが適応されたオブジェクトがあります\n破損する可能性がありますが続行しますか?\n(この作業はアンドゥ出来ません)")title:MesseTitleChkStr) then
                (
                    resumeEditing()--再びアクティブに
                    try(destroydialog SjPBakeProg)catch()

                    --リターンで処理終了
                    return ()
                    --)--with redraw end
                )--IKチェックend
                )--IKcountend

                undo off
                (

                for n=1 to itemCount do
                (
                --ESCキーを押した場合にforloopを中断します
                --escapeEnable = true;

                lListObj = (getNodeByName pb_listL.items[n])
                rListObj = (getNodeByName pb_listR.items[n])
                SjPBakeProg.processInfo.caption = (floor(((100.00/itemCount) * (n - 1))) as String) + "% 完了" + pb_listL.items[n] + "を処理中   ";

                if sByS == 0 then --step by step か？
                (
                --------------------------------------------
                --Bipか?
                if ((classOf  lListObj) != Biped_Object) and ((classOf  lListObj.controller) != BipSlave_Control) then
                (
                --------------------------------------------
                --通常
                    case pbake_bakeType of
                    (
                        0:(allKeyCreate_Fn lListObj rListObj bakeFm)
                        1:(keyCreateTypeOne_Fn lListObj rListObj bakeFm)
                        2:(keyCreateTypeTwo_Fn lListObj rListObj bakeFm)
                        3:(keyCreateTypeThree_Fn lListObj rListObj bakeFm)
                        4:(keyCreateTypeFore_Fn lListObj rListObj bakeFm)
                        5:(keyCreateTypeFive_Fn lListObj rListObj bakeFm)
                        6:(keyCreateTypeSix_Fn lListObj rListObj bakeFm)
                --------------------------------------------
                --オフセット
                        7:(keyOffsetCreate_Fn lListObj rListObj bakeFm)
                    )
                )else(
                    keyBipCreate_Fn lListObj  rListObj bakeFm;
                )--bip if end

                --下はbyStepの分岐
                )else
                (
                --------------------------------------------
                --キーを取得
                getKeyArray_Fn rListObj bakeFm

                --------------------------------------------
                --Bipか?
                if ((classOf  lListObj) != Biped_Object) then
                (
                    case pbake_bakeType of
                    (
                        0:(
                            keyPosCreate_Fn lListObj rListObj posKeys;
                            keyRotCreate_Fn lListObj rListObj rotKeys;
                            keyScaCreate_Fn lListObj rListObj scaKeys;
                        )
                        1:(
                            keyPosCreate_Fn lListObj rListObj posKeys;
                            keyRotCreate_Fn lListObj rListObj rotKeys;
                        )
                        2:(
                            keyPosCreate_Fn lListObj rListObj posKeys;
                            keyScaCreate_Fn lListObj rListObj scaKeys;
                        )
                        3:(
                            keyPosCreate_Fn lListObj rListObj posKeys;
                        )
                        4:(
                            keyRotCreate_Fn lListObj rListObj rotKeys;
                            keyScaCreate_Fn lListObj rListObj scaKeys;
                        )
                        5:(
                            keyRotCreate_Fn lListObj rListObj rotKeys;
                        )
                        6:(
                            keyScaCreate_Fn lListObj rListObj scaKeys;
                        )
                    )
                )else(
                    keyBipCreate_Fn lListObj  rListObj posKeys;
                    keyBipCreate_Fn lListObj  rListObj rotKeys;
                )--bip if end

                )

                SjPBakeProg.progbar.value = ((100.00/itemCount) * n)

                )

            ) undo off

        if iniSetting[3] do clearSelection()

        )


        --////////////////////////////////////////////////
        --処理2 Bake
        --////////////////////////////////////////////////
        2:(
                --新規レイヤー作成
                if iniSetting[4] do createNewLayer_Fn layerNameStr;

                undo off
                (

                for n=1 to itemCount do
                (

                --ESCキーを押した場合にforloopを中断します
                --if keyboard.escPressed do (exit)-- if keyboard End

                SjPBakeProg.processInfo.caption = (floor(((100.00/itemCount) * (n - 1))) as String) + "% 完了" + pb_listL.items[n] + "を処理中   ";
                lListObj = (getNodeByName pb_listL.items[n])
                    case pbOpRb.state of
                    (
                        --ポイントヘルパー作成
                        1:(
                        newObj = Point pos:[0,0,0] --Null作成
                        at time startFmTm newObj.transform = lListObj.transform --最初にトランスフォームを一致させる
                        newObj.parent = Undefined --親子関係はなし
                        newObj.name = pb_listL.items[n] + newObjName
                        )
                        --スナップメッシュ作成
                        2:(
                        newObj = snapshot lListObj at time startFmTm--スナップショット
                        newObj.parent = Undefined --親子関係はなし
                        newObj.name = pb_listL.items[n] + newObjName
                        --newObj.pos.controller = Position_XYZ () --標準コントローラーに変換
                        --newObj.rotation.controller = Euler_XYZ () --標準コントローラーに変換
                        --newObj.scale.controller = bezier_scale () --標準コントローラーに変換
                        )
                    )
                    append bakedSel newObj

                    if sByS == 0 then --step by step か？
                    (
                        if not mirrorChk.checked then --Mirror?
                        (allKeyCreate_Fn newObj lListObj bakeFm)
                        else(keyMirrorCreate_Fn newObj lListObj bakeFm)

                    case pbake_bakeType of
                    (
                        0:()
                        1:(deleteKeys newObj.scale.controller #allKeys)
                        2:(deleteKeys newObj.rotation.controller #allKeys)
                        3:(
                        deleteKeys newObj.rotation.controller #allKeys
                        deleteKeys newObj.scale.controller #allKeys
                        )
                        4:(deleteKeys newObj.pos.controller #allKeys)
                        5:(
                        deleteKeys newObj.pos.controller #allKeys
                        deleteKeys newObj.scale.controller #allKeys
                        )
                        6:(
                        deleteKeys newObj.pos.controller #allKeys
                        deleteKeys newObj.rotation.controller #allKeys
                        )
                    )

                    )else
                    (
                --------------------------------------------
                --キーを取得
                getKeyArray_Fn lListObj bakeFm
                    if not mirrorChk.checked then --Mirror?
                    (
                    keyPosCreate_Fn newObj lListObj posKeys
                    keyRotCreate_Fn newObj lListObj rotKeys
                    keyScaCreate_Fn newObj lListObj scaKeys
                    )
                    else(
                    tempObj = Point pos:[0,0,0]
                    tempObj.name = "mirrorTempObject"
                    keyMirrorCreate_Fn tempObj lListObj bakeFm
                    keyPosCreate_Fn newObj tempObj posKeys
                    keyRotCreate_Fn newObj tempObj rotKeys
                    keyScaCreate_Fn newObj tempObj scaKeys
                    delete tempObj
                    )

                    case pbake_bakeType of
                    (
                        0:()
                        1:(deleteKeys newObj.scale.controller #allKeys)
                        2:(deleteKeys newObj.rotation.controller #allKeys)
                        3:(deleteKeys newObj.rotation.controller #allKeys
                        deleteKeys newObj.scale.controller #allKeys)
                        4:(deleteKeys newObj.pos.controller #allKeys)
                        5:(deleteKeys newObj.pos.controller #allKeys
                        deleteKeys newObj.scale.controller #allKeys)
                        6:(deleteKeys newObj.pos.controller #allKeys
                        deleteKeys newObj.rotation.controller #allKeys)
                    )
                    )

                SjPBakeProg.progbar.value = ((100.00/itemCount) * n)

                )


                )--undo off end

            SjPBakeProg.progbar.value = 0

            if iniSetting[5] do select bakedSel;

        )




        --////////////////////////////////////////////////
        --処理3 Plot
        --////////////////////////////////////////////////
        3:(

            --IK対策を初期化,IKを確認
            bakeListIKCheck_Fn()

                undo off
                (

                    --IKオブジェクト対策
                    if ikCheck then
                    (

                    if (queryBox("IKオブジェクトが確認されました\n
自動的にコントローラーが無効になりますがよろしいですか?
HDIKの場合、破綻を防ぐためにコントローラーは削除されます

IK間接の一部だけをPlotするとアニメーションが破綻します
") title:MesseTitleChkStr) then	(
                    --ik確認を変更
                    ikObjQuery = true;

                    for n in ikObjIndex do
                    (
                        lListObj = (getNodeByName pb_listL.items[n])

                        SjPBakeProg.progbar.value = ((100.00/ikObjIndex.count) * n)
                        SjPBakeProg.processInfo.caption = "IKオブジェクトが確認されました 対処処理を行っています";
                        --ポイントを作成して変数に格納、格納先はikBakeObj
                        tempObj = Point pos:[0,0,0];
                        tempObj.name = lListObj.name + "_IKBaked";
                        tempObj.parent = lListObj.parent;
                        append ikBakeObj tempObj;

                        --ミラーか？
                        if not mirrorChk.checked then
                        (allKeyCreate_Fn tempObj lListObj bakeFm)
                        else(keyMirrorCreate_Fn tempObj lListObj bakeFm)

                        --キーを作成しする
                        if not mirrorChk.checked then
                        (allKeyCreate_Fn tempObj lListObj bakeFm)
                        else(keyMirrorCreate_Fn tempObj lListObj bakeFm)

                    )

                        --コントローラーを削除する
                        for n in hdikObj do
                        (
                            --削除
                            try(HDIKSys.RemoveChain n)catch()
                        )

                        --コントローラーを無効にする
                        for n in ikObjEff do
                        (
                            --なぜかfloat値で設定している
                            n.transform.controller.enabled = 0;
                        )

                        --コントローラーを無効にする
                        --ただし、最後の間接と最初の間接だけ対応
                        for n in ikObj do
                        (
                            --従属オブジェクトを確保
                            ikdependObj = refs.dependents n;

                            for j in ikdependObj do
                            (
                            --IK設定オブジェクトならコントローラーを無効
                            if ((classOf j)==IK_Chain_Object) then j.transform.controller.enabled = 0;
                            )--forend
                        )
                    )

                    )



                for n=1 to itemCount do
                (

                --plotKeyCreate_Fn itemCount lListObj startFmTm

                --IKオブジェクトかどうか確認オブジェクトが格納されていなければ通常処理
                if ( findItem ikObjIndex n ) == 0 then
                (


                --ESCキーを押した場合にforloopを中断します
                --if keyboard.escPressed do (exit)-- if keyboard End

                    SjPBakeProg.progbar.value = ((100.00/itemCount) * n)
                    SjPBakeProg.processInfo.caption = (floor (((100.00/itemCount) * (n - 1))) as String) + "% 完了" + pb_listL.items[n] + "を処理中   ";
                    lListObj = (getNodeByName pb_listL.items[n])

                    newObj = snapshot lListObj at time startFmTm--スナップショット このとき自動的に親子構造が結ばれる
                    addNewkey newObj.controller startFmTm
                    newObj.name = "plotTempObj"

                    --StepByStepの場合、キーを回収
                    if sByS == 1 then
                    (
                    getKeyArray_Fn lListObj bakeFm
                    for k in rotKeys do if (findItem posKeys k) == 0 then append posKeys k
                    for k in scaKeys do if (findItem scaKeys k) == 0 then append posKeys k
                    sort posKeys
                    bakeFm = posKeys
                    )

                        --ミラーか？
                        if not mirrorChk.checked then
                        (allKeyCreate_Fn newObj lListObj bakeFm)
                        else(keyMirrorCreate_Fn newObj lListObj bakeFm)

                    case pbake_bakeType of
                    (
                        0:(
                            try(
                            lListObj.Transform.controller = prs ()
                            lListObj.controller = copy newObj.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        1:(
                            try(
                            lListObj.pos.controller = Position_XYZ () --標準コントローラーに変換
                            lListObj.rotation.controller = Euler_XYZ () --標準コントローラーに変換
                            lListObj.pos.controller = copy newObj.pos.controller
                            lListObj.rotation.controller = copy newObj.rotation.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        2:(
                            try(
                            lListObj.pos.controller = Position_XYZ () --標準コントローラーに変換
                            lListObj.scale.controller = bezier_scale () --標準コントローラーに変換
                            lListObj.pos.controller = copy newObj.pos.controller
                            lListObj.scale.controller = copy newObj.scale.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        3:(
                            try(
                            lListObj.pos.controller = Position_XYZ () --標準コントローラーに変換
                            lListObj.pos.controller = copy newObj.pos.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        4:(
                            try(
                            lListObj.rotation.controller = Euler_XYZ () --標準コントローラーに変換
                            lListObj.scale.controller = bezier_scale () --標準コントローラーに変換
                            lListObj.rotation.controller = copy newObj.rotation.controller
                            lListObj.scale.controller = copy newObj.scale.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        5:(
                            try(
                            lListObj.rotation.controller = Euler_XYZ () --標準コントローラーに変換
                            lListObj.rotation.controller = copy newObj.rotation.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n"+lListObj.name) title:MesseTitleInfoStr)
                        )
                        6:(
                            lListObj.scale.controller = bezier_scale () --標準コントローラーに変換
                            lListObj.scale.controller = copy newObj.scale.controller
                        )
                    )

                    delete newObj;

                )else(

                    --////////////////////////////////////////////////
                    --IKだった場合の処理
                    --////////////////////////////////////////////////
                    --処理にOKが出ていれば
                    if ikObjQuery then
                    (
                    SjPBakeProg.progbar.value = ((100.00/itemCount) * n)
                    SjPBakeProg.processInfo.caption = (floor (((100.00/itemCount) * (n - 1))) as String) + "% 完了" + pb_listL.items[n] + "を処理中   "
                    lListObj = (getNodeByName pb_listL.items[n])

                    case pbake_bakeType of
                    (
                        0:(
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller = prs ()
                            lListObj.controller.FK_Sub_Control.controller = copy ikBakeObj[ikObjCont].controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller = prs ()
                            lListObj.controller.IK_goal.controller = copy ikBakeObj[ikObjCont].controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.Transform.controller = prs ()
                            lListObj.controller = copy ikBakeObj[ikObjCont].controller
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                        1:(
                            --位置回転
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.IK_goal.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.IK_goal.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.controller.IK_goal.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.pos.controller = Position_XYZ ()
                            lListObj.rotation.controller = Euler_XYZ ()
                            lListObj.pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                        2:(
                            --位置スケール
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.IK_goal.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.IK_goal.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.controller.IK_goal.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.pos.controller = Position_XYZ ()
                            lListObj.scale.controller = bezier_scale ()
                            lListObj.pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            lListObj.scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                        3:(
                            --位置
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Pos.controller = Position_XYZ ()
                            lListObj.controller.IK_goal.controller.Pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.pos.controller = Position_XYZ ()
                            lListObj.pos.controller = copy ikBakeObj[ikObjCont].pos.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )

                        )
                        4:(
                            --回転スケール
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.IK_goal.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.IK_goal.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            lListObj.controller.IK_goal.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.rotation.controller = Euler_XYZ ()
                            lListObj.scale.controller = bezier_scale ()
                            lListObj.rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            lListObj.scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                        5:(
                            --回転
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.FK_Sub_Control.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Rotation.controller = Euler_XYZ ()
                            lListObj.controller.IK_goal.controller.Rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.rotation.controller = Euler_XYZ ()
                            lListObj.rotation.controller = copy ikBakeObj[ikObjCont].rotation.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                        6:(
                            --スケール
                            --まずIKの通常コントローラーか?
                            if ((classOf lListObj.controller) == IKControl) then
                            (
                            try(
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.FK_Sub_Control.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --IKのコントローラーか?
                            if ((classOf lListObj) == IK_Chain_Object) then
                            (
                            try(
                            lListObj.controller.IK_goal.controller.Scale.controller = bezier_scale ()
                            lListObj.controller.IK_goal.controller.Scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                            --それ以外(HDIK),これは通常のコントローラーとみなす
                            if (not ((classOf lListObj) == IK_Chain_Object)) and (not ((classOf lListObj.controller) == IKControl)) then
                            (
                            try(
                            lListObj.scale.controller = bezier_scale ()
                            lListObj.scale.controller = copy ikBakeObj[ikObjCont].scale.controller;
                            )catch(messageBox("コントローラーを変更できませんでした\n" + lListObj.name) title:MesseTitleInfoStr)
                            )
                        )
                    )

                    ikObjCont += 1;

                    )

                ) IK確認

                )

                )--undo off end

                SjPBakeProg.progbar.value = 0
                delete ikBakeObj;

        clearSelection()

        )

        )

    --////////////////////////////////////////////////
    --復帰
    --////////////////////////////////////////////////
    )--with redraw end
    resumeEditing()--再びアクティブに
    try(destroydialog SjPBakeProg)catch()

    try( gc light:false delayed:false)catch()--メモリーを解放する

    )--pbake end

    on sj_pbake_rol open do(
        initialize_Fn()
        bakeKeyCheck_Fn()
    )

    on sj_pbake_rol close do saveIni_Fn()

    --////////////////////////////////////////////////
    --リサイズイベント
    --////////////////////////////////////////////////
    on sj_pbake_rol resized val do
    (
        --大きさが元の大きさを超えていれば
        if ((sj_pbake_rol.width >= 452) and (sj_pbake_rol.height >= 404)) then
        (
            widthVal = (val[1] as float / 2.0)

            grp_list.width = val[1] - 16;
            grp_list.height = val[2] - 132;
            --pBakeBt.pos = [val[1],val[2]];
            pBakeBt.pos = [8,(val[2]-36)];
            listCntL.pos = [20,(val[2]-56)];

            pb_listL.width = widthVal-18;
            pb_listL.height = val[2] - 190;

            pb_listR.width = widthVal-18;
            pb_listR.height = val[2] - 190;

            pb_listR.pos = [(widthVal+2),132];
            addListBtR.pos = [(widthVal+2),108];
            allSelListBtR.pos = [(widthVal+26),108];
            upListBtR.pos = [(widthVal+50),108];
            downListBtR.pos = [(widthVal+74),108];
            sortBtR.pos = [(widthVal+98),108];
            pSortBtR.pos = [(widthVal+122),108];
            delBtR.pos = [(widthVal+146),108];
            clearBtR.pos = [(widthVal+170),108];

            listCntR.pos = [(widthVal+6),(val[2]-56)];

            --リサイズイメージの位置
            resizeImg.pos = [(val[1]-10),(val[2]-10)];

        ) else (
            sj_pbake_rol.width = 452;
            sj_pbake_rol.height = 404;
        )
    )
)
-----------------------------------------------------------------------------------------------------------
--ロールアウト
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_pbake_rol pos:[50,50] menu:pbakeMenuBar style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu

)