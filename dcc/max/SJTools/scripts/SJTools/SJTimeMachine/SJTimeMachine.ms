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
 * SJTimeMachine
 * 誰だよ、このウンコード書いたの・・・あ、俺か・・・
 *
 */

(

--------------------------------------------------------------------------------
-- グローバル周り
--------------------------------------------------------------------------------
global SjTimeMachineRol --ロールアウト用

Local nameAndVersion = "SJ Time Machine";
Local fileLockID = 6581883285124;

--ステータス
Local bookFm = #( #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0) )
Local bookFmFlag = #( #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false) )

Local editMode = 1;
Local obj = undefined;
Local scaleValue = 1;
Local bookLN = 1;

--------------------------------------------------------------------------------
-- ロールアウト周り
--------------------------------------------------------------------------------
try(cui.unRegisterDialogBar SjTimeMachineRol)catch()
try(closeRolloutFloater SjTimeMachineRol)catch()
try(destroydialog SjTimeMachineRol)catch()
try(cui.FloatDialogBar SjTimeMachineRol)catch()

try(closeRolloutFloater sj_tm_reduce_rol) catch()
try(destroydialog sj_tm_reduce_rol)catch()
try(destroydialog sj_tm_merge_rol) catch()
try(destroydialog sj_progressBar_rol)catch()


/**-----------------------------------------------------------------------------
 * キーリダクション
 */
fn SjTimeMachineKeysReduce =
(
    global sj_tm_reduce_rol
    try (destroydialog sj_tm_reduce_rol) catch()

    rollout sj_tm_reduce_rol "キーリダクション" width:140 height:152
    (
        Local obj = undefined
        --キーリダクション
        fn reduceStepKeys_Fn i reduceFm=
        (
            --プロパティに"Position"があればture
            if (isProperty i.controller "Position") then
            (
                --オブジェクトのキーを回収
                posKeys = for k in i.pos.controller.keys collect k.time;
                rotKeys = for k in i.rotation.controller.keys collect k.time;
                scaKeys = for k in i.scale.controller.keys collect k.time;

                --位置
                --削除時は後ろから
                delIndex = for k in reduceFm collect findItem posKeys k;
                j = delIndex.count;
                while j != 0 do
                (
                    if delIndex[j] != 0 then deleteKey i.pos.controller delIndex[j];
                    j -= 1;
                )

                delIndex = for k in reduceFm collect findItem rotKeys k;
                j = delIndex.count;
                while j != 0 do
                (
                    if delIndex[j] != 0 then deleteKey i.rotation.controller delIndex[j];
                    j -= 1;
                )

                delIndex = for k in reduceFm collect findItem scaKeys k;
                j = delIndex.count;
                while j != 0 do
                (
                    if delIndex[j] != 0 then deleteKey i.scale.controller delIndex[j];
                    j -= 1;
                )
            )
        )

        --レイアウト
        groupBox Grp "Key Reduce" pos:[4,4] width:132 height:144
        label threshLbl "Thresh" pos:[10,20] width:59 height:16
        label stepLbl "Step" pos:[71,20] width:59 height:16
        spinner threshSp "" pos:[10,36] width:56 height:16 range:[0,1000,1] type:#float scale:0.01
        spinner stepSp "" pos:[71,36] width:56 height:16 range:[0,1000,1] type:#float scale:0.01

        checkbox regularlyChk "" pos:[11,56] width:16 height:16 enabled:true
        label regularlyLbl "定期フレーム" pos:[31,58] width:100 height:16 enabled:true
        spinner regularlySpn "" pos:[10,76] width:117 height:16 enabled:false range:[1,1000,1] type:#integer

        checkbox selOnlyRedChk "" pos:[12,100] width:16 height:16 enabled:true
        label selOnlyRedLbl "選択のみ" pos:[32,102] width:100 height:16 enabled:true
        button setReduceBt "実行" pos:[10,124] width:56 height:20
        button cancelReduceBt "キャンセル" pos:[72,124] width:56 height:20

        on regularlyChk changed state do
        (
            sj_tm_reduce_rol.regularlySpn.enabled = state;
            sj_tm_reduce_rol.threshLbl.enabled = not state;
            sj_tm_reduce_rol.stepLbl.enabled = not state;
            sj_tm_reduce_rol.threshSp.enabled = not state;
            sj_tm_reduce_rol.stepSp.enabled = not state;
        )

        on selOnlyRedChk changed state do
        (
            if state then
            (
            SjTimeMachineRol.selectedOnlyChk.checked = state;
            ) else (
            SjTimeMachineRol.selectedOnlyChk.checked = false;
            )
        )

        --実行
        on setReduceBt pressed do
        (
            --maxの余分な処理を押さえ　処理速度を高速化
            suspendEditing()  --サスペンドモード
            max create mode  --クリエートモードに変更
            with redraw off  --再描画禁止
            (
                undo off
                (
                    --ふつうのリダクション
                    if (not regularlyChk.checked) then
                    (
                        if SjTimeMachineRol.selectedOnlyChk.checked then (
                            obj = selection
                        ) else (
                            obj = for i in objects collect i
                        )
                        reduceKeys obj threshSp.value stepSp.value (interval animationRange.start animationRange.end)

                    ) else (
                    --定期フレーム
                    --フレームが現在のレンジを越えていなければ
                        if regularlySpn.value < (animationRange.end-(animationRange.start)) then
                        (
                            messageBox "定期フレームの場合、トランスフォームにのみ処理を行います\nその他のアニメーションキーは対象外となります\n使用にはご注意ください\n " title:"お知らせ";
                            sj_functions.sj_progressBar_Fn()

                            local reduceFm = #(), delIndex = #(), posKeys = #(), rotKeys = #(), scaKeys = #()
                            local fm = animationRange.start;
                            --プログレスバー用
                            local n, m;
                            --削除するフレームを回収
                            while fm < animationRange.end do
                            (
                                for j=1 to regularlySpn.value do
                                (
                                    k = fm + j;
                                    if k < animationRange.end then append reduceFm k;
                                )
                                fm += (regularlySpn.value+1)
                            )

                            sort reduceFm;
                            if SjTimeMachineRol.selectedOnlyChk.checked then
                            (obj = selection) else (obj = for i in objects collect i)

                            --キーを処理
                            n = obj.count;
                            m = 1;

                            for i in obj do
                            (
                                sj_progressBar_rol.processInfo.caption = i.name + "を処理中   " + (floor((100.0/n) * (m-1)) as String) + "% 完了";
                                reduceStepKeys_Fn i reduceFm;
                                sj_progressBar_rol.progbar.value = ((100.0/n) * m)
                                m += 1;
                            )
                            sj_progressBar_rol.progbar.value = 0;
                            destroydialog sj_progressBar_rol;
                        ) else (messageBox "フレーム設定が現在のフレーム範囲を超えています" title:"警告")
                    )

                    try(closeRolloutFloater sj_tm_reduce_rol) catch()
                    try(destroydialog sj_tm_reduce_rol)catch()
                    try(destroydialog sj_progressBar_rol)catch()
                )
            )
            resumeEditing()
        )

        --キャンセル
        on cancelReduceBt pressed do
        (
            try(closeRolloutFloater sj_tm_reduce_rol) catch()
            try(destroydialog sj_tm_reduce_rol)catch()
            try(destroydialog sj_progressBar_rol)catch()
        )

        --ダイアログオープン
        on sj_tm_reduce_rol open do
        (
            selOnlyRedChk.checked = SjTimeMachineRol.selectedOnlyChk.checked;
        )
    )
    --ダイアログクリエート
    CreateDialog sj_tm_reduce_rol style:#(#style_titlebar, #style_minimizebox)
)


/**-----------------------------------------------------------------------------
 * マージ
 */
fn SjTimeMachineMerge =
(
    global sj_tm_reduce_rol
    try (destroydialog sj_tm_merge_rol) catch()

    rollout sj_tm_merge_rol "マージオプション" width:140 height:82
    (
        radioButtons mergeTypeRdo "" pos:[12,20] width:96 height:32 labels:#("端詰め", "タイムメモ欄単位") columns:1
        button MergeBt "OK" pos:[10,54] width:56 height:20
        button cancelMergeBt "キャンセル" pos:[72,54] width:56 height:20
        GroupBox mergeGrp "Merge Option" pos:[4,4] width:132 height:74

        --////////////////////////////////////////////////
        --実行
        --////////////////////////////////////////////////
        on MergeBt pressed do
        (
            local loadFile = getOpenFileName types:"テキスト(*.txt)|*.txt|All(*.*)|*.*" caption:"ブックマークを合成"

            --バックアップ
            local bookFmFlagBack = bookFmFlag, bookFmBack = bookFm;

            if loadFile != undefined do
            (
                loadFileTemp = openFile loadFile;
                tempName = #()
                tempValue = #()
                temp = 0;
                tempA = #()
                tempB = #()
                tempC = 1;

            --バグ回避用にtry catch
                try (
                    case mergeTypeRdo.state of
                    (
                        --端詰め
                        1:(
                            tempName = readValue loadFileTemp;--1行目
                            tempValue = readValue loadFileTemp;--2行目
                            tempC = 1;
                            for i = 1 to 10 do
                            (
                                tempC = 1;
                                for k = 1 to 7 do
                                (
                                    --falseだったら読み込み
                                    if (not bookFmFlag[i][k]) then
                                    (
                                        bookFmFlag[i][k] = tempName[i][k];
                                        bookFm[i][tempC] = tempValue[i][tempC];
                                        bookFm[i][k*2] = tempValue[i][k*2];
                                    )
                                    tempC += 2;
                                )
                            )
                        )

                        --タイムメモ単位
                        2:(
                            tempName = readValue loadFileTemp;--1行目
                            tempValue = readValue loadFileTemp;--2行目

                            --先に配列を調べて確保
                            for i = 1 to 10 do
                            (
                                temp = 0;
                                for k = 1 to 7 do
                                (
                                    if tempName[i][k] then temp += 1;
                                )

                                --タイムメモが確認できれば
                                if (temp != 0) then
                                (
                                    append tempA tempName[i];
                                    append tempB tempValue[i];
                                )
                            )

                            tempC = 1;
                            for i = 1 to 10 do
                            (
                                temp = 0;
                                for k = 1 to 7 do
                                (
                                    if bookFmFlag[i][k] then temp += 1;
                                )
                                --記録が1つも無ければ
                                if (temp == 0) then
                                (
                                    if tempA[tempC] != undefined then bookFmFlag[i] = tempA[tempC];
                                    if tempB[tempC] != undefined then bookFm[i] = tempB[tempC];
                                    tempC += 1;
                                )
                            )
                        )
                    )

                    close loadFileTemp;
                    tempName = #()
                    tempValue = #()
                    temp = 0;
                    tempA = #()
                    tempB = #()
                    bookFmFlagBack = #()
                    bookFmBack = #()

                    --SjTimeMachineRol.
                    if bookFmFlag[bookLN][1] then SjTimeMachineRol.bookBt01.caption = (bookFm[bookLN][1] as String) + "-" + (bookFm[bookLN][2] as String)
                    if bookFmFlag[bookLN][2] then SjTimeMachineRol.bookBt02.caption = (bookFm[bookLN][3] as String) + "-" + (bookFm[bookLN][4] as String)
                    if bookFmFlag[bookLN][3] then SjTimeMachineRol.bookBt03.caption = (bookFm[bookLN][5] as String) + "-" + (bookFm[bookLN][6] as String)
                    if bookFmFlag[bookLN][4] then SjTimeMachineRol.bookBt04.caption = (bookFm[bookLN][7] as String) + "-" + (bookFm[bookLN][8] as String)
                    if bookFmFlag[bookLN][5] then SjTimeMachineRol.bookBt05.caption = (bookFm[bookLN][9] as String) + "-" + (bookFm[bookLN][10] as String)

                    if bookFmFlag[bookLN][6] then SjTimeMachineRol.bookBt06.caption = (bookFm[bookLN][11] as String) + "-" + (bookFm[bookLN][12] as String)
                    if bookFmFlag[bookLN][7] then SjTimeMachineRol.bookBt07.caption = (bookFm[bookLN][13] as String) + "-" + (bookFm[bookLN][14] as String)
                ) catch (
                    messageBox "未知の形式です\n読み込めませんでした" title:"エラー";
                    --復元
                    bookFmFlag = bookFmFlagBack;
                    bookFm = bookFmBack;
                    bookFmFlagBack = #()
                    bookFmBack = #()
                )
            )
            try(closeRolloutFloater sj_tm_merge_rol) catch()
            try (destroydialog sj_tm_merge_rol) catch()

        )
        --キャンセル
        on cancelMergeBt pressed do
        (
            try(closeRolloutFloater sj_tm_merge_rol) catch()
            try (destroydialog sj_tm_merge_rol) catch()
        )
    )
    --ダイアログクリエート
    CreateDialog sj_tm_merge_rol style:#(/*#style_border,  #style_sysmenu,*/ #style_titlebar, #style_minimizebox)
)


/**-----------------------------------------------------------------------------
 * @Main
 */
rollout SjTimeMachineRol nameAndVersion
(
    --////////////////////////////////////////////////
    --メニュー
    fn menus_Fn =
    (
        rcMenu menuBar
        (
            local modInst
            menuItem maxPreviewMi "プレビューの設定";
            menuItem createPreviewMi "プレビューを作成";
            menuItem maxRenamePreviewMi "プレビューに名前を付けて保存";
            menuItem maxviewpreviewMi "プレビューを表示";
            seperator sep01;
            menuItem reduceKeysMi "キーリダクション";
            seperator sep02;
            menuItem setActiveKeyRangeMi "現在のオブジェクトのキーでレンジ設定";
            seperator sep03;
            menuItem saveBookMi "ブックマークを保存";
            menuItem loadBookMi "ブックマークを読み込み"
            menuItem mergeBookMi "ブックマークを合成"
            menuItem resetBookMi "ブックマークをリセット"
            --menuItem offsetKeysMi "キーオフセット"
            seperator sep04;
            menuItem helpMi "ヘルプ!"
            menuItem aboutMi "About"
            menuItem emailMi  "E-Mail"

            on maxPreviewMi picked do max preview;
            on createPreviewMi picked do createPreview()
            on maxRenamePreviewMi picked do max renamepreview;
            on maxviewpreviewMi picked do max viewpreview;

            on reduceKeysMi picked do SjTimeMachineKeysReduce()

            on setActiveKeyRangeMi picked do SjTimeMachineRol.setActiveKeyRange_Fn()

            on saveBookMi picked do SjTimeMachineRol.save_Fn()
            on mergeBookMi picked do SjTimeMachineMerge()

            on resetBookMi picked do SjTimeMachineRol.resetBook_Fn()

            on loadBookMi picked do SjTimeMachineRol.load_Fn()
            on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5883" ""
            on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
            on aboutMi picked do sj_functions.sjtools_about_Fn()

            on menuBar update do
            (
                 reduceKeysMi.caption = "a";
            )
        )
        menuBar.modInst = this;
        return menuBar;
    )

    --////////////////////////////////////////////////
    --起動時のアップデート
    --////////////////////////////////////////////////
    fn Load_RangeUpdate_Fn =
    (
        SjTimeMachineRol.startRangeSp.value = animationRange.start;
        SjTimeMachineRol.endRangeSp.value = animationRange.end;
        SjTimeMachineRol.frameRateSp.value = frameRate;
        if editMode == 2 then SjTimeMachineRol.editTimeSp.value = animationRange.end - animationRange.start;

        --スピナーがつぶれる現象を回避
        SjTimeMachineRol.backGroundImage.pos = [0,24];
        SjTimeMachineRol.backGroundImage.pos = [0,0];
    )

    --////////////////////////////////////////////////
    --load default
    --////////////////////////////////////////////////
    fn loadDefault_Fn =
    (
        --なんとなく暗号化
        TimeMachineDefalutFile = openEncryptedFile "$Scripts/SJTools/SJTimeMachine/TimeMachineDefalut.dat" fileLockID
        tempName = #()

        tempName = readValue TimeMachineDefalutFile
        bookFmFlag = tempName;
        tempName = readValue TimeMachineDefalutFile
        bookFm = tempName;

        if bookFmFlag[bookLN][1] then SjTimeMachineRol.bookBt01.caption = (bookFm[bookLN][1] as String) + "-" + (bookFm[bookLN][2] as String)
        if bookFmFlag[bookLN][2] then SjTimeMachineRol.bookBt02.caption = (bookFm[bookLN][3] as String) + "-" + (bookFm[bookLN][4] as String)
        if bookFmFlag[bookLN][3] then SjTimeMachineRol.bookBt03.caption = (bookFm[bookLN][5] as String) + "-" + (bookFm[bookLN][6] as String)
        if bookFmFlag[bookLN][4] then SjTimeMachineRol.bookBt04.caption = (bookFm[bookLN][7] as String) + "-" + (bookFm[bookLN][8] as String)
        if bookFmFlag[bookLN][5] then SjTimeMachineRol.bookBt05.caption = (bookFm[bookLN][9] as String) + "-" + (bookFm[bookLN][10] as String)
        if bookFmFlag[bookLN][6] then SjTimeMachineRol.bookBt06.caption = (bookFm[bookLN][11] as String) + "-" + (bookFm[bookLN][12] as String)
        if bookFmFlag[bookLN][7] then SjTimeMachineRol.bookBt07.caption = (bookFm[bookLN][13] as String) + "-" + (bookFm[bookLN][14] as String)
        close TimeMachineDefalutFile
        tempName = #()
    )

    --////////////////////////////////////////////////
    --save default
    --////////////////////////////////////////////////
    fn saveDefault_Fn =
    (
        --なんとなく暗号化
        TimeMachineDefalutFile = createFile "$Scripts/SJTools/SJTimeMachine/TimeMachineDefalut.tmp"
        format "%\n" bookFmFlag to:TimeMachineDefalutFile
        format "%\n" bookFm to:TimeMachineDefalutFile
        close TimeMachineDefalutFile
        encryptFile "$Scripts/SJTools/SJTimeMachine/TimeMachineDefalut.tmp" "$Scripts/SJTools/SJTimeMachine/TimeMachineDefalut.dat" fileLockID
    )

    --////////////////////////////////////////////////
    --save ブックマーク
    --////////////////////////////////////////////////
    fn save_Fn =
    (
        local saveFile = getSaveFileName types:"テキスト(*.txt)|*.txt|All(*.*)|*.*" caption:"ブックマークを保存"
        if saveFile != undefined do
        (
            --なんとなく暗号化
            saveFileTemp = createFile saveFile
            format "%\n" bookFmFlag to:saveFileTemp
            format "%\n" bookFm to:saveFileTemp
            close saveFileTemp
        )
    )

    --////////////////////////////////////////////////
    --load ブックマーク
    --////////////////////////////////////////////////
    fn load_Fn =
    (
        local loadFile = getOpenFileName types:"テキスト(*.txt)|*.txt|All(*.*)|*.*" caption:"ブックマークを読み込み"

        --バックアップ
        local bookFmFlagBack = bookFmFlag, bookFmBack = bookFm;

        if loadFile != undefined do
        (
            loadFileTemp = openFile loadFile;
            tempName = #()
            --バグ回避用にtry catch
            try(

                tempName = readValue loadFileTemp;
                bookFmFlag = tempName;

                tempName = readValue loadFileTemp;
                bookFm = tempName;
                if bookFmFlag[bookLN][1] then SjTimeMachineRol.bookBt01.caption = (bookFm[bookLN][1] as String) + "-" + (bookFm[bookLN][2] as String)
                if bookFmFlag[bookLN][2] then SjTimeMachineRol.bookBt02.caption = (bookFm[bookLN][3] as String) + "-" + (bookFm[bookLN][4] as String)
                if bookFmFlag[bookLN][3] then SjTimeMachineRol.bookBt03.caption = (bookFm[bookLN][5] as String) + "-" + (bookFm[bookLN][6] as String)
                if bookFmFlag[bookLN][4] then SjTimeMachineRol.bookBt04.caption = (bookFm[bookLN][7] as String) + "-" + (bookFm[bookLN][8] as String)
                if bookFmFlag[bookLN][5] then SjTimeMachineRol.bookBt05.caption = (bookFm[bookLN][9] as String) + "-" + (bookFm[bookLN][10] as String)

                if bookFmFlag[bookLN][6] then SjTimeMachineRol.bookBt06.caption = (bookFm[bookLN][11] as String) + "-" + (bookFm[bookLN][12] as String)
                if bookFmFlag[bookLN][7] then SjTimeMachineRol.bookBt07.caption = (bookFm[bookLN][13] as String) + "-" + (bookFm[bookLN][14] as String)
                close loadFileTemp;
                tempName = #()
                bookFmFlagBack = #()
                bookFmBack = #()
            ) catch (
                messageBox "未知の形式です\n読み込めませんでした" title:"エラー";
                --復元
                bookFmFlag = bookFmFlagBack;
                bookFm = bookFmBack;
                bookFmFlagBack = #()
                bookFmBack = #()
            )
        )
    )

    --////////////////////////////////////////////////
    --ブックマークをリセット
    --////////////////////////////////////////////////
    fn resetBook_Fn =
    (

        bookFm = #( #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0), #(0,0,0,0,0,0,0,0,0,0,0,0,0,0) )
        bookFmFlag = #( #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false), #(false,false,false,false,false,false,false) )

        SjTimeMachineRol.bookBt01.caption =  "未使用";
        SjTimeMachineRol.bookBt02.caption =  "未使用";
        SjTimeMachineRol.bookBt03.caption =  "未使用";
        SjTimeMachineRol.bookBt04.caption =  "未使用";
        SjTimeMachineRol.bookBt05.caption =  "未使用";

        SjTimeMachineRol.bookBt06.caption = "未使用";
        SjTimeMachineRol.bookBt07.caption = "未使用";
    )

    --////////////////////////////////////////////////
    --ブックマークリストを切り替え
    --////////////////////////////////////////////////
    fn changeListBook_Fn =
    (
        if bookFmFlag[bookLN][1] then SjTimeMachineRol.bookBt01.caption = (bookFm[bookLN][1] as String) + "-" + (bookFm[bookLN][2] as String)
        else(SjTimeMachineRol.bookBt01.caption = "未使用")
        if bookFmFlag[bookLN][2] then SjTimeMachineRol.bookBt02.caption = (bookFm[bookLN][3] as String) + "-" + (bookFm[bookLN][4] as String)
        else(SjTimeMachineRol.bookBt02.caption = "未使用")
        if bookFmFlag[bookLN][3] then SjTimeMachineRol.bookBt03.caption = (bookFm[bookLN][5] as String) + "-" + (bookFm[bookLN][6] as String)
        else(SjTimeMachineRol.bookBt03.caption = "未使用")
        if bookFmFlag[bookLN][4] then SjTimeMachineRol.bookBt04.caption = (bookFm[bookLN][7] as String) + "-" + (bookFm[bookLN][8] as String)
        else(SjTimeMachineRol.bookBt04.caption = "未使用")
        if bookFmFlag[bookLN][5] then SjTimeMachineRol.bookBt05.caption = (bookFm[bookLN][9] as String) + "-" + (bookFm[bookLN][10] as String)
        else(SjTimeMachineRol.bookBt05.caption = "未使用")

        if bookFmFlag[bookLN][6] then SjTimeMachineRol.bookBt06.caption = (bookFm[bookLN][11] as String) + "-" + (bookFm[bookLN][12] as String)
        else(SjTimeMachineRol.bookBt06.caption = "未使用")
        if bookFmFlag[bookLN][7] then SjTimeMachineRol.bookBt07.caption = (bookFm[bookLN][13] as String) + "-" + (bookFm[bookLN][14] as String)
        else(SjTimeMachineRol.bookBt07.caption = "未使用")
    )

    --////////////////////////////////////////////////
    --インターバルセット
    --////////////////////////////////////////////////
    fn IntervalSet_Fn s e =
    (
        if s < e do
        (
            animationRange = interval s e;
            SjTimeMachineRol.endRangeSp.value = e;
            SjTimeMachineRol.startRangeSp.value = s;
            if editMode == 2 then SjTimeMachineRol.editTimeSp.value = animationRange.end - animationRange.start;
        )
    )

    --////////////////////////////////////////////////
    --現在セット
    --////////////////////////////////////////////////
    fn currentTimeSet_Fn t =
    (
        sliderTime = t
    )

    --////////////////////////////////////////////////
    --editModeアップデート
    --////////////////////////////////////////////////
    fn editModeUpdateSet_Fn =
    (
        if editMode == 1 then SjTimeMachineRol.editTimeSp.value = 0;
        if editMode == 2 then SjTimeMachineRol.editTimeSp.value = animationRange.end - animationRange.start;
        if editMode == 3 then SjTimeMachineRol.editTimeSp.value = 0;
    )


    --////////////////////////////////////////////////
    --現在のアニメーションキーで範囲を設定
    --////////////////////////////////////////////////
    fn setActiveKeyRange_Fn =
    (
        messageBox("現在のオブジェクトが持っているトランスフォームの\nキー範囲でタイムレンジを設定します\nBipedやその他のアニメーションは対象外です\nご注意ください\n ") title:"お知らせ";
        Local allKeysTime = #(), posKeys = #(), rotKeys = #(), scaKeys = #()
        for i in objects do
        (
            --トランスフォームコントローラーはprsか?
            --プロパティに"Position"があればture
            if (isProperty i.controller "Position") then
            (
                posKeys = for k in i.pos.controller.keys collect k.time;
                rotKeys = for k in i.rotation.controller.keys collect k.time;
                scaKeys = for k in i.scale.controller.keys collect k.time;

                --配列をくっつける
                join allKeysTime posKeys;
                join allKeysTime rotKeys;
                join allKeysTime scaKeys;
            )
        )
        --ソート
        sort allKeysTime;
        makeUniqueArray allKeysTime;
        --配列に含まれた情報は2以上か?
        --MakeUniqueを実行している以上事実上2以上あれば最小と最大である
        undo on (
            if (allKeysTime.count > 2 ) then
            (
                --インターバルを設定
                animationRange = interval (amin allKeysTime) (amax allKeysTime)
                --結果をツールに反映
                SjTimeMachineRol.endRangeSp.value = (amax allKeysTime)
                SjTimeMachineRol.startRangeSp.value = (amin allKeysTime)
                if editMode == 2 then SjTimeMachineRol.editTimeSp.value = animationRange.end - animationRange.start;
            ) else (
                messageBox "時間を設定できません!\nアニメーションキーが見つりませんでした" title:"お知らせ";
            )
        )
    )

    --////////////////////////////////////////////////
    --挿入、圧縮、反転
    --////////////////////////////////////////////////
    fn editKeysTime_Fn time =
    (
        undo on
        (
            if SjTimeMachineRol.selectedOnlyChk.checked then
            (obj = selection) else (obj = for i in objects collect i)
            if editMode == 1 then insertTime obj currentTime time
            if editMode == 2 then
            (
                scaleValue = (1.0*time)/(1.0*(animationRange.end - animationRange.start))
                scaleTime obj animationRange.start animationRange.end scaleValue;
                if not SjTimeMachineRol.selectedOnlyChk.checked then
                (
                    animationRange = interval animationRange.start (animationRange.start+time)
                    SjTimeMachineRol.endRangeSp.value = animationRange.end;
                    SjTimeMachineRol.startRangeSp.value = animationRange.start;
                )
            )
            if editMode == 3 then reverseTime obj animationRange.start animationRange.end;
        )
    )

    --////////////////////////////////////////////////
    --レイアウト
    --////////////////////////////////////////////////
    local minRange = -1e+009, maxRange = 1e+009;
    local bgBitMap = openBitmap "$Scripts/SJTools/Images/SJ_timemachine_bg.png"
    ImgTag backGroundImage "Bitmap" pos:[0,0] width:2400 height:28 enabled:false bitmap:bgBitMap
    button closeBt "X" pos:[0,0] width:16 height:24 images:#("$Scripts/SJTools/Images//SJ_timemachine03.png", "undefined", 2, 1, 1, 2, 2) toolTip:"閉じる";
    button helpBt "Menu" pos:[20,0] width:58 height:24 enabled:true images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 1, 1, 1, 1, 1) toolTip:"メニュー";
    button preViewBt "Rec" pos:[82,0] width:24 height:24 enabled:true images:#("$Scripts/SJTools/Images//SJ_timemachine_rec.png", "undefined", 1, 1, 1, 1, 1) toolTip:"プレビュー";

    spinner startRangeSp "" pos:[154,4] width:80 height:16 enabled:true range:[-1e+009,1e+009,0] type:#integer scale:1
    spinner endRangeSp "" pos:[298,4] width:80 height:16 enabled:true range:[-1e+009,1e+009,0] type:#integer scale:1
    spinner frameRateSp "" pos:[444,4] width:55 height:16 enabled:true range:[-1e+009,1e+009,0] type:#integer scale:1
    button nowStartBt "now" pos:[238,4] width:32 height:16 --images:#("$Scripts/SJTools/Images//SJ_timemachine04.png", "undefined", 1, 1, 1, 2, 2)
    button nowEndBt "now" pos:[382,4] width:32 height:16 --images:#("$Scripts/SJTools/Images//SJ_timemachine04.png", "undefined", 1, 1, 1, 2, 2)

    dropdownList bookListDdl "" pos:[521,2] width:90 height:22 items:#("ブックマーク1", "ブックマーク2", "ブックマーク3", "ブックマーク4", "ブックマーク5", "ブックマーク6", "ブックマーク7", "ブックマーク8", "ブックマーク9", "ブックマーク10")

    button bookBt01 "未使用" pos:[618,0] width:68 height:24 border:false enabled:true
    button bookDelBt01 "X" pos:[686,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt02 "未使用" pos:[706,0] width:68 height:24 border:false  enabled:true
    button bookDelBt02 "X" pos:[774,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt03 "未使用" pos:[794,0] width:68 height:24 border:false enabled:true
    button bookDelBt03 "X" pos:[862,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt04 "未使用" pos:[882,0] width:68 height:24 border:false enabled:true
    button bookDelBt04 "X" pos:[950,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt05 "未使用" pos:[970,0] width:68 height:24 border:false enabled:true
    button bookDelBt05 "X" pos:[1038,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt06 "未使用" pos:[1058,0] width:68 height:24 border:false enabled:true
    button bookDelBt06 "X" pos:[1126,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    button bookBt07 "未使用" pos:[1146,0] width:68 height:24 border:false enabled:true
    button bookDelBt07 "X" pos:[1214,0] width:16 height:24 border:false images:#("$Scripts/SJTools/Images//SJ_timemachine01.png", "undefined", 2, 1, 1, 2, 2)

    spinner editTimeSp "" pos:[1280,4] width:56 height:16 enabled:true range:[-1e+009,1e+009,0] type:#integer scale:1
    button editSetBt "Set!" pos:[1340,4] width:32 height:16 --images:#("$Scripts/SJTools/Images//SJ_timemachine05.png", "undefined", 1, 1, 1, 2, 2)
    checkbox insertChk "" pos:[1378,4] width:15 height:15 checked:true
    checkbox scaleChk "" pos:[1422,4] width:15 height:15 checked:false
    checkbox reverseChk "" pos:[1468,4] width:15 height:15 checked:false
    checkbox selectedOnlyChk "" pos:[1512,4] width:15 height:15 checked:true ight:15

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
    --on keyMachineBt pressed do macros.run "SJTools" "SJ_Key_Machine";

    on closeBt pressed do
    (
        saveDefault_Fn()
        try(cui.unRegisterDialogBar SjTimeMachineRol)catch()
        try(closeRolloutFloater SjTimeMachineRol) catch()
        try(destroydialog SjTimeMachineRol)catch()
        try(closeRolloutFloater sj_tm_reduce_rol) catch()
        try(destroydialog sj_tm_reduce_rol)catch()
        try(destroydialog sj_progressBar_rol)catch()
    )

    on helpBt pressed do
    (
        menuSys = menus_Fn()
        popUpMenu menuSys rollout:presets_rol
    )

    on editSetBt pressed do
    (
        if (queryBox "BipedやIKに対してリダクションを実行した際\n多重にキーを処理するバグをがあります\n使用にはご注意ください\n実行しますか?\n " title:"確認") then
        (
            editKeysTime_Fn editTimeSp.value;
        )
    )

    on startRangeSp changed state do IntervalSet_Fn state endRangeSp.value;
    on endRangeSp changed state do IntervalSet_Fn startRangeSp.value state;
    on frameRateSp changed state do
    (
        startRangeSp.value = animationRange.start;
        endRangeSp.value = animationRange.end;
        frameRate = state;
    )

    on nowStartBt pressed do
    (
        if currentTime < endRangeSp.value do startRangeSp.value = currentTime
        IntervalSet_Fn startRangeSp.value endRangeSp.value
    )

    on nowEndBt pressed do
    (
        if currentTime > startRangeSp.value do endRangeSp.value = currentTime
        IntervalSet_Fn startRangeSp.value endRangeSp.value
    )

    --////////////////////////////////////////////////
    --チェック
    --////////////////////////////////////////////////
    on insertChk changed state do
    (
        if state then
        (
            editMode = 1;
            scaleChk.checked = false
            reverseChk.checked = false
            editModeUpdateSet_Fn()
        ) else (
            insertChk.checked = true
        )
    )

    on scaleChk changed state do
    (
        if state then
        (
            editMode = 2;
            insertChk.checked = false
            reverseChk.checked = false
            editModeUpdateSet_Fn()
        ) else (
            scaleChk.checked = true
        )
    )
    on reverseChk changed state do
    (
        if state then
        (
            editMode = 3;
            scaleChk.checked = false
            insertChk.checked = false
            editModeUpdateSet_Fn()
        ) else (
            reverseChk.checked = true
        )
    )

    --////////////////////////////////////////////////
    --ブックマーク
    --////////////////////////////////////////////////
    on bookListDdl selected state do
    (
        bookLN = state;
        changeListBook_Fn()
    )

    --ブック1
    on bookBt01 pressed do
    (
        if bookFmFlag[bookLN][1] then
        (
            animationRange.start = bookFm[bookLN][1];
            animationRange.end = bookFm[bookLN][2];
            IntervalSet_Fn bookFm[bookLN][1] bookFm[bookLN][2];

        ) else (
            bookFm[bookLN][1] = animationRange.start;
            bookFm[bookLN][2] = animationRange.end;
            bookBt01.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][1] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt01 pressed do
    (
        bookBt01.caption = "未使用";
        bookFmFlag[bookLN][1] = false;
    )

    --ブック2
    on bookBt02 pressed do
    (
        if bookFmFlag[bookLN][2] then
        (
            animationRange.start = bookFm[bookLN][3];
            animationRange.end = bookFm[bookLN][4];
            IntervalSet_Fn bookFm[bookLN][3] bookFm[bookLN][4];
        ) else (
            bookFm[bookLN][3] = animationRange.start;
            bookFm[bookLN][4] = animationRange.end;
            bookBt02.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][2] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt02 pressed do
    (
        bookBt02.caption = "未使用";
        bookFmFlag[bookLN][2] = false;
    )

    --ブック3
    on bookBt03 pressed do
    (
        if bookFmFlag[bookLN][3] then
        (
            animationRange.start = bookFm[bookLN][5];
            animationRange.end = bookFm[bookLN][6];
            IntervalSet_Fn bookFm[bookLN][5] bookFm[bookLN][6];
        ) else (
            bookFm[bookLN][5] = animationRange.start;
            bookFm[bookLN][6] = animationRange.end;
            bookBt03.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][3] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt03 pressed do
    (
        bookBt03.caption = "未使用";
        bookFmFlag[bookLN][3] = false;
    )

    --ブック4
    on bookBt04 pressed do
    (
        if bookFmFlag[bookLN][4] then
        (
            animationRange.start = bookFm[bookLN][7];
            animationRange.end = bookFm[bookLN][8];
            IntervalSet_Fn bookFm[bookLN][7] bookFm[bookLN][8];
        ) else (
            bookFm[bookLN][7] = animationRange.start;
            bookFm[bookLN][8] = animationRange.end;
            bookBt04.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][4] = true;
            saveDefault_Fn()
        )
    )

    on bookDelBt04 pressed do
    (
        bookBt04.caption = "未使用";
        bookFmFlag[bookLN][4] = false;
    )

    --ブック5
    on bookBt05 pressed do
    (
        if bookFmFlag[bookLN][5] then
        (
            animationRange.start = bookFm[bookLN][9];
            animationRange.end = bookFm[bookLN][10];
            IntervalSet_Fn bookFm[bookLN][9] bookFm[bookLN][10];
        ) else (
            bookFm[bookLN][9] = animationRange.start;
            bookFm[bookLN][10] = animationRange.end;
            bookBt05.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][5] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt05 pressed do
    (
        bookBt05.caption = "未使用";
        bookFmFlag[bookLN][5] = false;
    )

    --ブック6
    on bookBt06 pressed do
    (
        if bookFmFlag[bookLN][6] then
        (
            animationRange.start = bookFm[bookLN][11];
            animationRange.end = bookFm[bookLN][12];
            IntervalSet_Fn bookFm[bookLN][11] bookFm[bookLN][12];
        ) else (
            bookFm[bookLN][11] = animationRange.start;
            bookFm[bookLN][12] = animationRange.end;
            bookBt06.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][6] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt06 pressed do
    (
        bookBt06.caption = "未使用";
        bookFmFlag[bookLN][6] = false;
    )

    --ブック7
    on bookBt07 pressed do
    (
        if bookFmFlag[bookLN][7] then
        (
            animationRange.start = bookFm[bookLN][13];
            animationRange.end = bookFm[bookLN][14];
            IntervalSet_Fn bookFm[bookLN][13] bookFm[bookLN][14];
        ) else (
            bookFm[bookLN][13] = animationRange.start;
            bookFm[bookLN][14] = animationRange.end;
            bookBt07.caption = (animationRange.start as String) + "-" + (animationRange.end as String)
            bookFmFlag[bookLN][7] = true;
            saveDefault_Fn()
        )
    )
    on bookDelBt07 pressed do
    (
        bookBt07.caption = "未使用";
        bookFmFlag[bookLN][7] = false;
    )

    --////////////////////////////////////////////////
    --Open and Close
    --////////////////////////////////////////////////
    on SjTimeMachineRol close do
    (
        saveDefault_Fn()
        callbacks.removescripts id:#Load_RangeUpdate;
    )

    on SjTimeMachineRol open do
    (
        loadDefault_Fn()
        startRangeSp.value = animationRange.start;
        endRangeSp.value = animationRange.end;
        frameRateSp.value = frameRate;
        callbacks.removescripts id:#Load_RangeUpdate; ---コールバックが重複登録されないように、安全対策
        --callbacks.removescripts id:#NewFile_RangeUpdate; ---コールバックが重複登録されないように、安全対策
        callbacks.addScript #filePostOpenProcess "SjTimeMachineRol.Load_RangeUpdate_Fn()" id:#Load_RangeUpdate; --ロールアウト内のファンクションを直接登録
        --callbacks.addScript #filePostOpen "SjTimeMachineRol.Load_RangeUpdate_Fn()" id:#NewFile_RangeUpdate; --ロールアウト内のファンクションを直接登録
        saveDefault_Fn()
    )
)

--------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
--------------------------------------------------------------------------------
CreateDialog SjTimeMachineRol width:1600 height:28 style:#(#style_toolwindow,#style_sysmenu, #style_resizing, #style_minimizebox)
cui.RegisterDialogBar SjTimeMachineRol style:#(#cui_dock_all,#cui_handles,#cui_floatable)
cui.DockDialogBar SjTimeMachineRol #cui_dock_bottom;
)
