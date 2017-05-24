/**
 * -----------------------------------------------------------------------------
 *
 *  SJ Tools
 *
 * -----------------------------------------------------------------------------
 * (c) Copyright 2017 sakaiden and Captain Hansode. All rights reserved.
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 * SJ Renamer
 * 選択物リネームする
 *
 */

(

/**-----------------------------------------------------------------------------
 * global
 */
global sjRenamerRol;
global sjRnmResult = #();

--基本言語ファイル
--Local language = getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Language";
local language = "JP";

--Version
local nameAndVersion = "りねーまー";
--なんか色々
local allOj = #(), hitText = undefined, hitCount = 0, k = 0, NumStr = "", NameStr = "";

--フラグ
local searchType = true

/**-----------------------------------------------------------------------------
 * Rollouts削除
 */
try(cui.FloatDialogBar sjRenamerRol)catch();
try(cui.unRegisterDialogBar sjRenamerRol)catch();
try(closeRolloutFloater sjRenamerRol)catch();
try(destroydialog sjRenamerRol)catch();
try(closeRolloutFloater sjRenamerResultRol)catch();
try(destroydialog sjRenamerResultRol)catch();
--try(destroydialog sj_progressBar_rol)catch();

/**-----------------------------------------------------------------------------
 * メニュー
 */
if (language == "JP") then
(
    rcMenu renamerMenuBar
    (
        subMenu "ヘルプ"
        (
            menuItem helpMi "ヘルプ";
            menuItem aboutMi "About";
            menuItem emailMi "E-Mail";
            seperator sepChangeLang;
            menuItem ChangeLangMi "言語変更(Change Language)";
        )
        --アクション
        on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" "";
        on aboutMi picked do sj_functions.sjtools_about_Fn();
        on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
        on ChangeLangMi	picked do sj_functions.sjtools_changeLanguage_Fn();
        on poserMenuBar update do
        (
        )
    )
) else (
    --////////////////////////////////////////////////
    --英語
    rcMenu renamerMenuBar
    (
        subMenu "Help"
        (
            menuItem helpMi "Help";
            menuItem aboutMi "About";
            menuItem emailMi "E-Mail";
            seperator sepChangeLang;
            menuItem ChangeLangMi "言語変更(Change Language)";
        )
        --アクション
        on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" "";
        on aboutMi picked do sj_functions.sjtools_about_Fn();
        on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
        on ChangeLangMi	picked do sj_functions.sjtools_changeLanguage_Fn();
        on poserMenuBar update do
        (
        )
    )
)

/**-----------------------------------------------------------------------------
 * 検索結果
 */
fn hitSelList_Fn=
(
    fileIn ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamerResult.ms");
)

/**-----------------------------------------------------------------------------
 * 新規名前
 */
fn newName_Fn =
(
    suspendEditing();
    with redraw off
    (
        --sj_functions.sj_progressBar_Fn();
        ----sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";

        if sjRenamerRol.newNameEdt.text != "" then
        (NameStr = sjRenamerRol.newNameEdt.text) else (NameStr = "Empty");

        --数の設定
        NumStr = "";
        k = 0;
        digitNum = sjRenamerRol.newNameSpn3.value;

        if sjRenamerRol.withNumberChk.checked then
        (
            --一度代入
            NumStr = (sjRenamerRol.newNameSpn1.value as String);

            for i in selection do
            (
                --数字文字列を合成
                NumStr = ((sjRenamerRol.newNameSpn1.value + (k*sjRenamerRol.newNameSpn2.value)) as String);

                --桁は足りているか?
                while ( NumStr.count < digitNum) do NumStr = ("0" + NumStr);

                --名前を合成
                if sjRenamerRol.addNumberChk.checked then
                (i.name = i.name + NumStr) else (i.name = NameStr + NumStr);

                --プログレス
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k);
                k += 1;
            )

        ) else (
            for i in selection do
            (
                i.name = NameStr;
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k);
                k += 1;
            )
        )
        --try(destroydialog sj_progressBar_rol)catch();
    )
    resumeEditing();
)

/**-----------------------------------------------------------------------------
 * 置換
 */
fn replaceName_Fn =
(
    suspendEditing();
    with redraw off
    (
        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        hitText = undefined
        if sjRenamerRol.beforeEdt.text != "" then
        (
            k = 1;
            --sから始まり選択の数だけ！（このときにsという変数が宣言されています）
            for i in selection do
            (
                --aに選択オブジェクトから文字列を探す
                hitText = findString i.name sjRenamerRol.beforeEdt.text;
                --文字が見つかったら！（検索結果undefindでなければ）
                if hitText != undefined then
                (
                    i.name = replace i.name hitText sjRenamerRol.beforeEdt.text.count sjRenamerRol.afterEdt.text	--hitText文字目からxx文字数までを置き換えます
                )
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k)
                k += 1;
            )
            --sj_progressBar_rol.progbar.value = 0
            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!")
        )
    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * プレフィックス
 */
fn prefixName_Fn =
(
    suspendEditing();--サスペンドモード
    with redraw off
    (
        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        if sjRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            for i=1 to selection.count do
            (
                --文字を置き換えます
                selection[i].name = sjRenamerRol.multiNameEdt.text + selection[i].name;
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i);
            )
            --sj_progressBar_rol.progbar.value = 0
            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!")
        )
    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * サフィックス
 */
fn suffixName_Fn =
(
    suspendEditing();--サスペンドモード
    with redraw off
    (--再描画禁止

        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        if sjRenamerRol.multiNameEdt.text != "" then
        (
            for i=1 to selection.count do --sから始まり選択の数だけ！（このときにsという変数が宣言されています）
            (
                selection[i].name = selection[i].name + sjRenamerRol.multiNameEdt.text	--文字を置き換えます
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i)
            )
            --sj_progressBar_rol.progbar.value = 0
            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!");
        )
    )
    resumeEditing();--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * n番目プレフィックス
 */
fn nPrefixName_Fn =
(
    suspendEditing()--サスペンドモード
    with redraw off
    (--再描画禁止

        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        if sjRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            k = selection.count;
            j = 0;
            errorCount = 0;
            nNum = sjRenamerRol.nNumberSpn.value;
            for i in selection do
            (
                --先頭からn番目までの文字を格納
                tempStrA = substring i.name 1 nNum;--1～指定数まで
                tempStrB = substring i.name (nNum+1) -1;--指定数から最後まで
                i.name = tempStrA + sjRenamerRol.multiNameEdt.text + tempStrB;--文字列を合成
                --sj_progressBar_rol.progbar.value = ((100.00/k) * j);
                j += 1;
            )
            --sj_progressBar_rol.progbar.value = 0

            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!")
        )
        if (errorCount != 0) then (messageBox("いくつかの名前の変更に失敗しています"));
    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * n番目サフィックス
 */
fn nSuffixName_Fn =
(
    suspendEditing()--サスペンドモード
    with redraw off
    (--再描画禁止

        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        if sjRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            k = selection.count;
            j = 0;
            errorCount = 0;
            nNum = sjRenamerRol.nNumberSpn.value;
            for i in selection do
            (
                --指定文字数を超えていたら
                if (i.name.count < nNum) then
                (
                    --名前以上の数値が設定されていたら、先頭に追加するだけでよい
                    i.name = sjRenamerRol.multiNameEdt.text + i.name;
                ) else (
                    --先頭からn番目までの文字を格納
                    tempStrA = substring i.name 1 (i.name.count - nNum);--1文字目から～指定文字まで
                    tempStrB = substring i.name (i.name.count - nNum+1) -1;--指定数から～最後まで
                    i.name = tempStrA + sjRenamerRol.multiNameEdt.text + tempStrB;--文字列を合成
                    --sj_progressBar_rol.progbar.value = ((100.00/k) * j);
                    j += 1;
                )
            )
            --sj_progressBar_rol.progbar.value = 0

            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!");
        )
        if (errorCount != 0) then (messageBox("いくつかの名前の変更に失敗しています"))
    )
    resumeEditing();
)

/**-----------------------------------------------------------------------------
 * 削除
 */
fn deleteName_Fn =
(
    suspendEditing()--サスペンドモード
    with redraw off --再描画禁止
    (
        --sj_functions.sj_progressBar_Fn();
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
        hitText = undefined;
        if sjRenamerRol.multiNameEdt.text != "" then
        (
            for i=1 to selection.count do
            (
                --aに選択オブジェクトから文字列を探します
                hitText = findString selection[i].name sjRenamerRol.multiNameEdt.text;
                if hitText != undefined then	--文字が見つかったら！（検索結果undefindでなければ）
                (
                    --文字を置き換えます
                    selection[i].name = replace selection[i].name hitText sjRenamerRol.multiNameEdt.text.count "";
                )
                --sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i);
            )
            --sj_progressBar_rol.progbar.value = 0;
            --try(destroydialog sj_progressBar_rol)catch();
        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!")
        )

    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * 検索
 */
fn searchName_Fn =
(
    suspendEditing()--サスペンドモード
    with redraw off
    (
        --sj_functions.sj_progressBar_Fn()
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"

        try (destroydialog sjRenamerResultRol) catch();
        sjRnmResult = #()

        if sjRenamerRol.searchNameEdt.text != "" then
        (
            allOj = for i in objects collect i --オブジェクトの数だけオブジェクト内容を収集
            k = 1;
            for i in allOj do
            (
                if (findString (i.name as String) sjRenamerRol.searchNameEdt.text) != undefined do append sjRnmResult i
                --sj_progressBar_rol.progbar.value = ((100.00/allOj.count) * k)
                k += 1;
            )

            --sj_progressBar_rol.progbar.value = 0
            --try(destroydialog sj_progressBar_rol)catch()

            if sjRnmResult.count != 0 then
            (
                hitSelList_Fn();
            ) else (
                messageBox("見つかりませんでした") title:"検索結果";
            )

        ) else (
            --try(destroydialog sj_progressBar_rol)catch();
            messageBox("検索文字列が空です!")
        )
    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * 近い名前
 */
fn similarSearchBt_Fn =
(
    Local resultList = #();
    Local tempObj = #();
    sjRnmResult = #();

    try (destroydialog sjRenamerResultRol) catch();
    allOj = for i in objects collect i.name --オブジェクトの数だけオブジェクト内容を収集
    --判定レベル2で実行
    resultList = sj_functions.sj_searchSimilarStrings_Fn sjRenamerRol.searchNameEdt.text allOj 3;

    --かぶっているものを排除
    resultList = makeUniqueArray resultList;

    --名前で選択してsjRnmResultに格納
    for i in resultList do
    (
        --いったん配列に回収
        tempObj = (getNodeByName i exact:false ignoreCase:false all:true);
        for u in tempObj do append sjRnmResult u;
    )

    if sjRnmResult.count != 0 then
    (
        temp
        hitSelList_Fn()
    ) else (
        messageBox("見つかりませんでした") title:"検索結果"
    )

    --クリア
    allOj = undefined;
    gc();
)

/**-----------------------------------------------------------------------------
 * ダブルネーム
 */
fn doubleNameName_Fn =
(
    suspendEditing();--サスペンドモード
    --再描画禁止
    with redraw off
    (

        --sj_functions.sj_progressBar_Fn()
        --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"

        try (destroydialog sjRenamerResultRol) catch();

        allOj = for i in objects collect i --オブジェクトの数だけオブジェクト内容を収集
        sjRnmResult = #()
        hitCount = 0
        k = 1;
        for i in allOj do
        (
            hitCount = 0
            for u in allOj do
            (
                if (matchPattern i.name pattern:u.name ignoreCase:SearchType) == true do hitCount += 1;
            )
            if hitCount > 1 do append sjRnmResult i; --カウントが2以上だったら
            --sj_progressBar_rol.progbar.value = ((100.00/allOj.count) * k);
            k += 1;
        )

        --sj_progressBar_rol.progbar.value = 0;
        --try(destroydialog sj_progressBar_rol)catch();

        if sjRnmResult.count != 0 then
        (
            hitSelList_Fn()
        ) else (
            messageBox("見つかりませんでした") title:"検索結果";
        )
    )
    resumeEditing()--再びアクティブに
)

/**-----------------------------------------------------------------------------
 * 初期化
 */
fn initialize_Fn = (
    local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    sjRenamerRol.newNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordNews");
    sjRenamerRol.beforeEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordReplaceA");
    sjRenamerRol.afterEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordReplaceB");
    sjRenamerRol.multiNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordAdd");
    sjRenamerRol.searchNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordSearch");
    sjRenamerRol.newNameSpn1.value = execute(getINISetting iniPath "SJRenamer" "BaseNumber");
    sjRenamerRol.newNameSpn2.value = execute(getINISetting iniPath "SJRenamer" "Steps");
    sjRenamerRol.newNameSpn3.value = execute(getINISetting iniPath "SJRenamer" "Digit");
    sjRenamerRol.nNumberSpn.value = execute(getINISetting iniPath "SJRenamer" "nNumber");

    sjRenamerRol.withNumberChk.checked = execute(getINISetting iniPath "SJRenamer" "Numbering");
    sjRenamerRol.addNumberChk.checked = execute(getINISetting iniPath "SJRenamer" "OnlyNumbering");

    --uiを設定
    if (sjRenamerRol.withNumberChk.checked) then
    (
        sjRenamerRol.baseNoLbl.enabled  = true;
        sjRenamerRol.stepLbl.enabled  = true;
        sjRenamerRol.digitLbl.enabled  = true;
        sjRenamerRol.newNameSpn1.enabled  = true;
        sjRenamerRol.newNameSpn2.enabled  = true;
        sjRenamerRol.newNameSpn3.enabled  = true;
        sjRenamerRol.addNumberChk.enabled = true;
    ) else (
        sjRenamerRol.baseNoLbl.enabled  = false;
        sjRenamerRol.stepLbl.enabled  = false;
        sjRenamerRol.digitLbl.enabled  = false;
        sjRenamerRol.newNameSpn1.enabled  = false;
        sjRenamerRol.newNameSpn2.enabled  = false;
        sjRenamerRol.newNameSpn3.enabled  = false;
        sjRenamerRol.addNumberChk.enabled = false;
    )

    --uiを設定
    if (sjRenamerRol.addNumberChk.checked) then
    (
        sjRenamerRol.basenameLbl.enabled = false;
        sjRenamerRol.newNameEdt.enabled = false;
    ) else (
        sjRenamerRol.basenameLbl.enabled = true;
        sjRenamerRol.newNameEdt.enabled = true;
    )
)

/**-----------------------------------------------------------------------------
 * 設定を保存
 */
fn saveIni_Fn = (
    local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    (setINISetting iniPath "SJRenamer" "LastKeyWordNews" sjRenamerRol.newNameEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordReplaceA" sjRenamerRol.beforeEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordReplaceB" sjRenamerRol.afterEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordAdd" sjRenamerRol.multiNameEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordSearch" sjRenamerRol.searchNameEdt.text);
    (setINISetting iniPath "SJRenamer" "BaseNumber" ((sjRenamerRol.newNameSpn1.value) as String));
    (setINISetting iniPath "SJRenamer" "Steps" ((sjRenamerRol.newNameSpn2.value) as String));
    (setINISetting iniPath "SJRenamer" "Digit" ((sjRenamerRol.newNameSpn3.value) as String));
    (setINISetting iniPath "SJRenamer" "nNumber" ((sjRenamerRol.nNumberSpn.value) as String));

    (setINISetting iniPath "SJRenamer" "Numbering" ((sjRenamerRol.withNumberChk.checked) as String));
    (setINISetting iniPath "SJRenamer" "OnlyNumbering" ((sjRenamerRol.addNumberChk.checked) as String));
)

/**----------------------------------------------------------------------------------------------------------------------------------------------------------
 * メイン Rollout
 */
rollout sjRenamerRol nameAndVersion width:200 height:676;
(
    GroupBox grp1 "新規" pos:[8,8] width:184 height:188
    label basenameLbl "基本の名前" pos:[16,28] width:164 height:16
    edittext newNameEdt "" pos:[12,44] width:172 height:16
    checkbox withNumberChk "番号付き" pos:[16,66] width:82 height:16 checked:true toolTip:"基本に連番を追加します";
    checkbox addNumberChk "連番だけ" pos:[104,66] width:86 height:16 checked:false toolTip:"基本を付けず連番だけ追加します";
    label baseNoLbl "基本の番号" pos:[16,88] width:72 height:16
    label stepLbl "ステップ" pos:[104,88] width:72 height:16
    label digitLbl "連番の桁数" pos:[16,124] width:72 height:16
    spinner newNameSpn1 "" pos:[16,104] width:80 height:16 range:[0,9999,1] type:#integer scale:1
    spinner newNameSpn2 "" pos:[104,104] width:80 height:16 range:[1,999,1] type:#integer scale:1
    spinner newNameSpn3 "" pos:[16,140] width:80 height:16 range:[1,12,1] type:#integer scale:1
    button newNameBt "名前を変更" pos:[16,164] width:168 height:24 toolTip:"名前を変更"

    GroupBox grp2 "置換" pos:[8,204] width:184 height:132
    label beforLbl "検索文字列" pos:[16,224] width:164 height:16
    edittext beforeEdt "" pos:[12,240] width:172 height:16
    label afterLbl "置換文字列" pos:[16,264] width:164 height:16
    edittext afterEdt "" pos:[12,280] width:172 height:16
    button renameSubstringBt "置換" pos:[16,304] width:168 height:24 toolTip:"上記文字列で置換"

    GroupBox grp3 "追加 削除" pos:[8,344] width:184 height:176
    edittext multiNameEdt "" pos:[12,364] width:172 height:16
    button addFNameBt "先頭に追加" pos:[16,388] width:80 height:24 toolTip:"名前の先頭に追加します"
    button addBNameBt "語尾に追加" pos:[104,388] width:80 height:24 toolTip:"名前の語尾に追加します"

    label nNumberLbl "n番目に追加" pos:[16,416] width:72 height:16
    spinner nNumberSpn "" pos:[16,432] width:80 height:16 range:[1,99,1] type:#integer scale:1
    button nAddFNameBt "先頭からn番目" pos:[16,456] width:80 height:24 toolTip:"先頭からn番目に追加します"
    button nAddBNameBt "語尾からn番目" pos:[104,456] width:80 height:24 toolTip:"語尾からn番目に追加します"

    button deleteNameBt "文字列を削除" pos:[16,488] width:168 height:24 toolTip:"指定の文字列を削除します"

    GroupBox grp4 "検索" pos:[8,528] width:184 height:140
    edittext searchNameEdt "" pos:[12,548] width:172 height:16
    button SearchBt "検索" pos:[16,572] width:168 height:24 toolTip:"指定の文字列で検索します"
    button similarSearchBt "近い名称を検索" pos:[16,604] width:168 height:24 enabled:true toolTip:"指定の文字列に近い名前のオブジェクトを検索します"
    button doubleNameBt "重複名称検索" pos:[16,636] width:168 height:24 toolTip:"シーンから重複した名前を検索します"

    /**-----------------------------------------------------------------------------
     * イベント
     */
    on withNumberChk changed state do
    (
        --uiを設定
        if state then
        (
            baseNoLbl.enabled  = true;
            stepLbl.enabled  = true;
            digitLbl.enabled  = true;
            newNameSpn1.enabled  = true;
            newNameSpn2.enabled  = true;
            newNameSpn3.enabled  = true;
            addNumberChk.enabled = true;
        ) else (
            baseNoLbl.enabled  = false;
            stepLbl.enabled  = false;
            digitLbl.enabled  = false;
            newNameSpn1.enabled  = false;
            newNameSpn2.enabled  = false;
            newNameSpn3.enabled  = false;
            addNumberChk.enabled = false;
        )
        saveIni_Fn();
    )

    on addNumberChk changed state do
    (
        --uiを設定
        if state then
        (
            basenameLbl.enabled = false;
            newNameEdt.enabled = false;
        ) else (
            basenameLbl.enabled = true;
            newNameEdt.enabled = true;
        )
        saveIni_Fn();
    )

    on newNameBt pressed do newName_Fn();
    on renameSubstringBt pressed do replaceName_Fn()
    on addFNameBt pressed do prefixName_Fn()
    on addBNameBt pressed do suffixName_Fn()
    on nAddFNameBt pressed do nPrefixName_Fn()
    on nAddBNameBt pressed do nSuffixName_Fn()
    on deleteNameBt pressed do deleteName_Fn()
    on SearchBt pressed do searchName_Fn()
    on similarSearchBt pressed do similarSearchBt_Fn()
    on doubleNameBt pressed do doubleNameName_Fn()

    on newNameEdt changed txt do saveIni_Fn();
    on beforeEdt changed txt do saveIni_Fn();
    on afterEdt changed txt do saveIni_Fn();
    on multiNameEdt changed txt do saveIni_Fn();
    on searchNameEdt changed txt do saveIni_Fn();
    on newNameSpn1 changed val do saveIni_Fn();
    on newNameSpn2 changed val do saveIni_Fn();
    on newNameSpn3 changed val do saveIni_Fn();
    on newNameSpn1 changed val do saveIni_Fn();
    on nNumberSpn changed  val do saveIni_Fn();

    on sjRenamerRol resized val do
    (
        width = 200;
        height = 676;
        if ((sjRenamerRol.width <= width) and (sjRenamerRol.height <= height)) then
        (
            return false;
        )
        textWidth = val[1] - 32;
        grpWidth = val[1] - 16;
        sjRenamerRol.height = height;
        sjRenamerRol.beforeEdt.width = textWidth;
        sjRenamerRol.afterEdt.width = textWidth;
        sjRenamerRol.newNameEdt.width = textWidth;
        sjRenamerRol.multiNameEdt.width = textWidth;
        sjRenamerRol.searchNameEdt.width = textWidth;
        sjRenamerRol.grp1.width = grpWidth;
        sjRenamerRol.grp2.width = grpWidth;
        sjRenamerRol.grp3.width = grpWidth;
        sjRenamerRol.grp4.width = grpWidth;
    )

    on sjRenamerRol open do initialize_Fn();
    on sjRenamerRol moved val do
    (
        local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
        (setINISetting iniPath "SJRenamer" "rolPosX" (val[1] as String));
        (setINISetting iniPath "SJRenamer" "rolPosY" (val[2] as String));
    )
)

/**-----------------------------------------------------------------------------
 * End of rollout & Create Dialog / Floater
 */
local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
local posX = execute(getINISetting iniPath "SJRenamer" "rolPosX");
local posY = execute(getINISetting iniPath "SJRenamer" "rolPosY");
CreateDialog sjRenamerRol pos:[posX, posY] menu:renamerMenuBar style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu

)
