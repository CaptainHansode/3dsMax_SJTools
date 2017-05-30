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
 * SJ Renamer
 * 選択物リネームする
 *
 */

/**-----------------------------------------------------------------------------
 * global
 */
global SJRenamerRol;
global sjRnmResult = #();

include "$scripts\SJTools\lib\progresBar.ms";


(

/**-----------------------------------------------------------------------------
 * Rollouts削除
 */
try(cui.FloatDialogBar SJRenamerRol)catch();
try(cui.unRegisterDialogBar SJRenamerRol)catch();
try(closeRolloutFloater SJRenamerRol)catch();
try(destroydialog SJRenamerRol)catch();
try(closeRolloutFloater sjRenamerResultRol)catch();
try(destroydialog sjRenamerResultRol)catch();

--基本言語ファイル
local language = "JP";

--Version
local nameAndVersion = "りねーまー";

--なんか色々
local allOj = #(), hitText = undefined, hitCount = 0, k = 0, NumStr = "", NameStr = "";

--フラグ
local searchType = true

/**-----------------------------------------------------------------------------
 * メニュー
 */
rcMenu renamerMenuBar
(
    subMenu "ヘルプ"
    (
        menuItem helpMi "ヘルプ";
        menuItem emailMi "E-Mail";
        seperator sepChangeLang;
        --menuItem ChangeLangMi "言語変更(Change Language)";
    )
    --アクション
    on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" "";
    on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
    on poserMenuBar update do
    (
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
    if SJRenamerRol.newNameEdt.text != "" then
    (NameStr = SJRenamerRol.newNameEdt.text) else (NameStr = "Empty");

    --数の設定
    NumStr = "";
    k = 0;
    digitNum = SJRenamerRol.newNameSpn3.value;

    if SJRenamerRol.withNumberChk.checked then
    (
        --一度代入
        NumStr = (SJRenamerRol.newNameSpn1.value as String);

        for i in selection do
        (
            --数字文字列を合成
            NumStr = ((SJRenamerRol.newNameSpn1.value + (k*SJRenamerRol.newNameSpn2.value)) as String);

            --桁は足りているか?
            while ( NumStr.count < digitNum) do NumStr = ("0" + NumStr);

            --名前を合成
            if SJRenamerRol.addNumberChk.checked then
            (i.name = i.name + NumStr) else (i.name = NameStr + NumStr);

            k += 1;
        )
    ) else (
        for i in selection do
        (
            i.name = NameStr;
            k += 1;
        )
    )
)

/**-----------------------------------------------------------------------------
 * 置換
 */
fn replaceName_Fn =
(
    suspendEditing();
    with redraw off
    (
        hitText = undefined
        if SJRenamerRol.beforeEdt.text != "" then
        (
            k = 1;
            --sから始まり選択の数だけ！（このときにsという変数が宣言されています）
            for i in selection do
            (
                --aに選択オブジェクトから文字列を探す
                hitText = findString i.name SJRenamerRol.beforeEdt.text;
                --文字が見つかったら！（検索結果undefindでなければ）
                if hitText != undefined then
                (
                    i.name = replace i.name hitText SJRenamerRol.beforeEdt.text.count SJRenamerRol.afterEdt.text	--hitText文字目からxx文字数までを置き換えます
                )
                k += 1;
            )
        ) else (
            messageBox("検索文字列が空です!");
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
        if SJRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            for i=1 to selection.count do
            (
                --文字を置き換えます
                selection[i].name = SJRenamerRol.multiNameEdt.text + selection[i].name;
            )
        ) else (
            messageBox("検索文字列が空です!");
        )
    )
    resumeEditing();
)

/**-----------------------------------------------------------------------------
 * サフィックス
 */
fn suffixName_Fn =
(
    suspendEditing();--サスペンドモード
    with redraw off
    (
        if SJRenamerRol.multiNameEdt.text != "" then
        (
            for i=1 to selection.count do --sから始まり選択の数だけ！（このときにsという変数が宣言されています）
            (
                selection[i].name = selection[i].name + SJRenamerRol.multiNameEdt.text	--文字を置き換えます
            )
        ) else (
            messageBox("検索文字列が空です!");
        )
    )
    resumeEditing();
)

/**-----------------------------------------------------------------------------
 * n番目プレフィックス
 */
fn nPrefixName_Fn =
(
    suspendEditing()--サスペンドモード
    with redraw off
    (
        if SJRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            k = selection.count;
            j = 0;
            errorCount = 0;
            nNum = SJRenamerRol.nNumberSpn.value;
            for i in selection do
            (
                --先頭からn番目までの文字を格納
                tempStrA = substring i.name 1 nNum;--1～指定数まで
                tempStrB = substring i.name (nNum+1) -1;--指定数から最後まで
                i.name = tempStrA + SJRenamerRol.multiNameEdt.text + tempStrB;--文字列を合成
                j += 1;
            )
        ) else (
            messageBox("検索文字列が空です!");
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
    (
        if SJRenamerRol.multiNameEdt.text != "" then	--文字列が空かどうか？
        (
            k = selection.count;
            j = 0;
            errorCount = 0;
            nNum = SJRenamerRol.nNumberSpn.value;
            for i in selection do
            (
                --指定文字数を超えていたら
                if (i.name.count < nNum) then
                (
                    --名前以上の数値が設定されていたら、先頭に追加するだけでよい
                    i.name = SJRenamerRol.multiNameEdt.text + i.name;
                ) else (
                    --先頭からn番目までの文字を格納
                    tempStrA = substring i.name 1 (i.name.count - nNum);--1文字目から～指定文字まで
                    tempStrB = substring i.name (i.name.count - nNum+1) -1;--指定数から～最後まで
                    i.name = tempStrA + SJRenamerRol.multiNameEdt.text + tempStrB;--文字列を合成
                    j += 1;
                )
            )
        ) else (
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
        hitText = undefined;
        if SJRenamerRol.multiNameEdt.text != "" then
        (
            for i=1 to selection.count do
            (
                --aに選択オブジェクトから文字列を探します
                hitText = findString selection[i].name SJRenamerRol.multiNameEdt.text;
                if hitText != undefined then	--文字が見つかったら！（検索結果undefindでなければ）
                (
                    --文字を置き換えます
                    selection[i].name = replace selection[i].name hitText SJRenamerRol.multiNameEdt.text.count "";
                )
            )
        ) else (
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
        sjRnmResult = #()

        if SJRenamerRol.searchNameEdt.text != "" then
        (
            allOj = for i in objects collect i --オブジェクトの数だけオブジェクト内容を収集
            k = 1;
            for i in allOj do
            (
                if (findString (i.name as String) SJRenamerRol.searchNameEdt.text) != undefined do append sjRnmResult i
                k += 1;
            )
            if sjRnmResult.count != 0 then
            (
                hitSelList_Fn();
            ) else (
                messageBox("見つかりませんでした") title:"検索結果";
            )

        ) else (
            messageBox("検索文字列が空です!");
        )
    )
    resumeEditing();
)


/**-----------------------------------------------------------------------------
 * SJ_searchSimilarStrings
 * 似た名前を調べる
 * 引数は調べる文字列、対象の文字列、評価レベル、順に、string array value
 * 判定レベルは10～0、10では100点のみ、0点はほぼすべてを送り返す
 * 返り値 調べ上げた文字列すべて
 */
fn sj_searchSimilarStrings_Fn tagStr srchList judgLevel =
(
    /*文字の組み合わせは、最大が文字数
    最小は1文字
    隣あった文字の組み合わせは
    例えば、4文字の場合
    最大の4文字は一つ、	一文字に分解すると4つある
    3文字の組み合わせは2つ
    2文字の組み合わせは3つ
    最大=文字数
    最大-（最大-1）=最大と最小のあいだの組み合わせ数
    最小=1文字
    */
    --テスト用
    --tagStr = "abcdefg";
    --srchList = #("abasdcdefadsfwe","343as","4","cab","abcdefg","tyui","bac");

    local resultList = #();--結果の配列
    local scoreList = #(#(),#(),#(),#(),#(),#(),#(),#(),#(),#(),#());--点数順に結果を回収する、右から100-0点の10区画

    --配列のインデックス値、1:100、2:90、3:80、4:70、5:60、6:50、7:40、8:30、9:20、10:10、11:0
    local strHit = 0;--一致したかず
    local i = tagStr.count;
    local u = 0;--連続文字の分解回数
    local j = 1;--文字の合成回数、最小は1から
    local compStr = "";--合成文字
    local analysisTagStr = #();--調べ上げる文字列の組み合わせ

    --文字の最大数分繰り返す
    while i > 0 do
    (
        --合成回数を設定
        u = j;
        while u > 0 do
        (
            --一旦文字を初期化
            compStr = "";

            --K文字目からi文字数分の文字列を合成
            for k = u to (u+(i-1)) do
            (
                compStr += tagStr[k];
            )
            append analysisTagStr compStr;
            u -= 1;
        )
        --カウントを一つ移動する
        i -= 1;
        j += 1;
    )

    local progCount = 1;
    for k in srchList do
    (
        --カウントを0
        strHit = 0;
        --格納した文字列がどれくらいあるか比較する
        for i in analysisTagStr do
        (
            --文字列があれば
            if ((findString k i) != undefined) do strHit += 1;
        )

        --どれだけ一致したか評価する
        --ワザと小数点をかけて計算する
        strHit = (((strHit*1.0) / ((analysisTagStr.count)*1.0)) * 100);

        --全て一致している場合は、文字数を最後に比較
        --1文字2点で減点する、つまり50文字以上の文字列は検索対象外
        --absで絶対値化
        tempVal = (abs(tagStr.count - k.count)) * 2;
        --減点
        strHit = strHit - tempVal;

        --点数順に振り分け
        --配列のインデックス値、1:100、2:90、3:80、4:70、5:60、6:50、7:40、8:30、9:20、10:10、11:0
        --100点以上
        if (strHit >= 100) then (append scoreList[1] k)
        else if (strHit >= 90) then (append scoreList[2] k)
        else if (strHit >= 80) then (append scoreList[3] k)
        else if (strHit >= 70) then (append scoreList[4] k)
        else if (strHit >= 60) then (append scoreList[5] k)
        else if (strHit >= 50) then (append scoreList[6] k)
        else if (strHit >= 40) then (append scoreList[7] k)
        else if (strHit >= 30) then (append scoreList[8] k)
        else if (strHit >= 20) then (append scoreList[9] k)
        else if (strHit >= 10) then (append scoreList[10] k)
        else if (strHit >= 0) then (append scoreList[11] k);

        progCount += 1;
    )

    --各配列をソート
    sort scoreList[1];
    sort scoreList[2];
    sort scoreList[3];
    sort scoreList[4];
    sort scoreList[5];
    sort scoreList[6];
    sort scoreList[7];
    sort scoreList[8];
    sort scoreList[9];
    sort scoreList[10];
    sort scoreList[11];

    --リザルトに回収、ただし、回収するかはジャッジレベルに依存
    if (scoreList[1].count != 0) and (judgLevel <= 10) do join resultList scoreList[1];
    if (scoreList[2].count != 0) and (judgLevel <= 9) do join resultList scoreList[2];
    if (scoreList[3].count != 0) and (judgLevel <= 8) do join resultList scoreList[3];
    if (scoreList[4].count != 0) and (judgLevel <= 7) do join resultList scoreList[4];
    if (scoreList[5].count != 0) and (judgLevel <= 6) do join resultList scoreList[5];
    if (scoreList[6].count != 0) and (judgLevel <= 5) do join resultList scoreList[6];
    if (scoreList[7].count != 0) and (judgLevel <= 4) do join resultList scoreList[7];
    if (scoreList[8].count != 0) and (judgLevel <= 3) do join resultList scoreList[8];
    if (scoreList[9].count != 0) and (judgLevel <= 2) do join resultList scoreList[9];
    if (scoreList[10].count != 0) and (judgLevel <= 1) do join resultList scoreList[10];
    if (scoreList[11].count != 0) and (judgLevel <= 0) do join resultList scoreList[11];

    return resultList;
)


/**-----------------------------------------------------------------------------
 * 近い名前
 */
fn similarSearchBt_Fn =
(
    local resultList = #();
    local tempObj = #();
    sjRnmResult = #();

    allOj = for i in objects collect i.name --オブジェクトの数だけオブジェクト内容を収集

    --判定レベル2で実行
    resultList = sj_searchSimilarStrings_Fn SJRenamerRol.searchNameEdt.text allOj 3;

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
    SJProgressBar.show();

    allObj = for i in objects collect i; --オブジェクトの数だけオブジェクト内容を収集
    allNames = for i in objects collect i.name;
    sjRnmResult = #();
    local cnt = 1;
    local ret;
    local findObjs = #();
    for i in allObj do
    (
        SJProgressBar.update (floor ((100.0 / allObj.count) * cnt)) i.name;
        ret = findItem allNames i.name;
        if (ret != cnt) do (
            append findObjs i;
        )
        cnt += 1;
    )

    for i in findObjs do
    (
        for n in allNames do
        (
            if (n == i.name) do (
                append sjRnmResult i;
            )
        )
    )

    if sjRnmResult.count != 0 then
    (
        hitSelList_Fn();
    ) else (
        messageBox("見つかりませんでした") title:"検索結果";
    )
    SJProgressBar.hide();
)

/**-----------------------------------------------------------------------------
 * 初期化
 */
fn initialize_Fn = (
    local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    SJRenamerRol.newNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordNews");
    SJRenamerRol.beforeEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordReplaceA");
    SJRenamerRol.afterEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordReplaceB");
    SJRenamerRol.multiNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordAdd");
    SJRenamerRol.searchNameEdt.text = (getINISetting iniPath "SJRenamer" "LastKeyWordSearch");
    SJRenamerRol.newNameSpn1.value = execute(getINISetting iniPath "SJRenamer" "BaseNumber");
    SJRenamerRol.newNameSpn2.value = execute(getINISetting iniPath "SJRenamer" "Steps");
    SJRenamerRol.newNameSpn3.value = execute(getINISetting iniPath "SJRenamer" "Digit");
    SJRenamerRol.nNumberSpn.value = execute(getINISetting iniPath "SJRenamer" "nNumber");

    SJRenamerRol.withNumberChk.checked = execute(getINISetting iniPath "SJRenamer" "Numbering");
    SJRenamerRol.addNumberChk.checked = execute(getINISetting iniPath "SJRenamer" "OnlyNumbering");

    --uiを設定
    if (SJRenamerRol.withNumberChk.checked) then
    (
        SJRenamerRol.baseNoLbl.enabled  = true;
        SJRenamerRol.stepLbl.enabled  = true;
        SJRenamerRol.digitLbl.enabled  = true;
        SJRenamerRol.newNameSpn1.enabled  = true;
        SJRenamerRol.newNameSpn2.enabled  = true;
        SJRenamerRol.newNameSpn3.enabled  = true;
        SJRenamerRol.addNumberChk.enabled = true;
    ) else (
        SJRenamerRol.baseNoLbl.enabled  = false;
        SJRenamerRol.stepLbl.enabled  = false;
        SJRenamerRol.digitLbl.enabled  = false;
        SJRenamerRol.newNameSpn1.enabled  = false;
        SJRenamerRol.newNameSpn2.enabled  = false;
        SJRenamerRol.newNameSpn3.enabled  = false;
        SJRenamerRol.addNumberChk.enabled = false;
    )

    --uiを設定
    if (SJRenamerRol.addNumberChk.checked) then
    (
        SJRenamerRol.basenameLbl.enabled = false;
        SJRenamerRol.newNameEdt.enabled = false;
    ) else (
        SJRenamerRol.basenameLbl.enabled = true;
        SJRenamerRol.newNameEdt.enabled = true;
    )
)

/**-----------------------------------------------------------------------------
 * 設定を保存
 */
fn saveIni_Fn = (
    local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    (setINISetting iniPath "SJRenamer" "LastKeyWordNews" SJRenamerRol.newNameEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordReplaceA" SJRenamerRol.beforeEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordReplaceB" SJRenamerRol.afterEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordAdd" SJRenamerRol.multiNameEdt.text);
    (setINISetting iniPath "SJRenamer" "LastKeyWordSearch" SJRenamerRol.searchNameEdt.text);
    (setINISetting iniPath "SJRenamer" "BaseNumber" ((SJRenamerRol.newNameSpn1.value) as String));
    (setINISetting iniPath "SJRenamer" "Steps" ((SJRenamerRol.newNameSpn2.value) as String));
    (setINISetting iniPath "SJRenamer" "Digit" ((SJRenamerRol.newNameSpn3.value) as String));
    (setINISetting iniPath "SJRenamer" "nNumber" ((SJRenamerRol.nNumberSpn.value) as String));

    (setINISetting iniPath "SJRenamer" "Numbering" ((SJRenamerRol.withNumberChk.checked) as String));
    (setINISetting iniPath "SJRenamer" "OnlyNumbering" ((SJRenamerRol.addNumberChk.checked) as String));
)

/**----------------------------------------------------------------------------------------------------------------------------------------------------------
 * メイン Rollout
 */
rollout SJRenamerRol nameAndVersion width:200 height:676;
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

    on newNameBt pressed do
    (
        suspendEditing();
        with redraw off
        (
            newName_Fn();
        )
        resumeEditing();
    )

    on renameSubstringBt pressed do replaceName_Fn();
    on addFNameBt pressed do prefixName_Fn();
    on addBNameBt pressed do suffixName_Fn();
    on nAddFNameBt pressed do nPrefixName_Fn();
    on nAddBNameBt pressed do nSuffixName_Fn();
    on deleteNameBt pressed do deleteName_Fn();
    on SearchBt pressed do searchName_Fn();
    on similarSearchBt pressed do similarSearchBt_Fn();

    on doubleNameBt pressed do
    (
        suspendEditing();
        with redraw off
        (
            doubleNameName_Fn();
        )
        resumeEditing();
    )

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

    on SJRenamerRol resized val do
    (
        width = 200;
        height = 676;
        if ((SJRenamerRol.width <= width) and (SJRenamerRol.height <= height)) then
        (
            return false;
        )
        textWidth = val[1] - 32;
        grpWidth = val[1] - 16;
        SJRenamerRol.height = height;
        SJRenamerRol.beforeEdt.width = textWidth;
        SJRenamerRol.afterEdt.width = textWidth;
        SJRenamerRol.newNameEdt.width = textWidth;
        SJRenamerRol.multiNameEdt.width = textWidth;
        SJRenamerRol.searchNameEdt.width = textWidth;
        SJRenamerRol.grp1.width = grpWidth;
        SJRenamerRol.grp2.width = grpWidth;
        SJRenamerRol.grp3.width = grpWidth;
        SJRenamerRol.grp4.width = grpWidth;
    )

    on SJRenamerRol open do initialize_Fn();
    on SJRenamerRol moved val do
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
CreateDialog SJRenamerRol pos:[posX, posY] menu:renamerMenuBar style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;

)
