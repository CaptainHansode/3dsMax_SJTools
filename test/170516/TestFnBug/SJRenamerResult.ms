global sjRenamerResultRol;
try (destroydialog sjRenamerResultRol) catch ();

rollout sjRenamerResultRol ((sjRnmResult.count as string) + "件見つかりました" + "  検索結果") width:200 height:336
(
    local OjNameTemp = #(), NumStr = "", k = 0;

    --レイアウト
    listBox sjRnmResultList "9999件見つかりました" pos:[8,8] width:184 height:17;
    label info2 "ダブルクリックで選択できます" pos:[8,256] width:184 height:16;
    button allSelBt "全て選択" pos:[16,276] width:80 height:24 toolTip:"項目全てを選択します";
    button closeBt "閉じる" pos:[104,276] width:80 height:24 toolTip:"このウィンドウを閉じます";
    button numberingBt "語尾に連番を付ける" pos:[16,308] width:168 height:24 toolTip:"全ての項目の語尾に連番を付けます";

    local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
    ImgTag resizeImg "Bitmap" pos:[190,326] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

    --アクション
    on sjRenamerResultRol open do --ロールアウトが開いたとき
    (
        OjNameTemp = #()
        for i=1 to sjRnmResult.count do append OjNameTemp (sjRnmResult[i].name as String)
        sjRnmResultList.items = OjNameTemp
        sjRenamerResultRol.sjRnmResultList.caption = (sjRnmResult.count as string) + "件見つかりました";
    )

    --ダブルクリック
    on sjRnmResultList doubleclicked s do
    (
        clearSelection();
        try(selectMore sjRnmResult[s])catch(messageBox("選択した名前のオブジェクトがありません!"));
    )

    --全て選択
    on allSelBt pressed do
    (
        suspendEditing();
        with redraw off
        (
            --sj_functions.sj_progressBar_Fn();
            --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
            clearSelection();
            k = 1;
            for i in sjRnmResult do--選択テスト開始
            (
                try(selectMore i)catch(
                    messageBox("オブジェクトがシーン上にありません");
                )
                k += 1;
                --sj_progressBar_rol.progbar.value = ((100.00/sjRnmResult.count) * k);
            )
            --sj_progressBar_rol.progbar.value = 0
            --try(destroydialog sj_progressBar_rol)catch();
        )
        resumeEditing();
    )

    --ナンバリング
    on numberingBt pressed do
    (
        suspendEditing();
        with redraw off
        (
            --sj_functions.sj_progressBar_Fn();
            --sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
            OjNameTemp = #();
            k = 1;
            for i in sjRnmResult do
            (
                NumStr = (k as String);
                if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
                try(
                    i.name = i.name + "_" + NumStr;
                    append OjNameTemp (i.name as String);
                ) catch (
                    messageBox("オブジェクトがシーン上にありません");
                )
                --sj_progressBar_rol.progbar.value = ((100.00/sjRnmResult.count) * k);
                k += 1;
            )
            --sj_progressBar_rol.progbar.value = 0;
            --try(destroydialog sj_progressBar_rol)catch();
            sjRnmResultList.items = OjNameTemp;
        )
        resumeEditing();
    )

    --キャンセル
    on closeBt pressed do
    (
        try (destroydialog sjRenamerResultRol) catch ();
    )

    --リサイズイベント
    on sjRenamerResultRol resized val do
    (
        width = 200;
        height = 336;

        listWidth = 184;
        listHeight = 98;

        posTemp = [16,276];
        posTempB = [104,276];

        if ((sjRenamerResultRol.width >= 200) and (sjRenamerResultRol.height >= 336)) then
        (
            ratioW = (val[1] as float) / (width as float);
            ratioH = (val[2] as float) / (height as float);

            sjRnmResultList.width = val[1] - 16;
            sjRnmResultList.height = val[2] - 110;

            posTemp[2] = val[2] - 82;

            info2.pos = posTemp;

            posTempB[2] = posTemp[2] = val[2] - 62;

            allSelBt.pos = posTemp;
            closeBt.pos = posTempB;

            posTemp[2] = val[2] - 30;
            numberingBt.pos = posTemp;

            resizeImg.pos = [(val[1]-10),(val[2]-10)];

        ) else (
            sjRenamerResultRol.width = 200;
            sjRenamerResultRol.height = 336;
        )
    )
)
--////////////////////////////////////////////////
--ダイアログクリエート
CreateDialog sjRenamerResultRol /*pos:[sjRenamerRol.pos[1],sjRenamerRol.pos[2]]*/ style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_resizing, #style_toolwindow) --pos:[50,50]