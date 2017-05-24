/**
 * -----------------------------------------------------------------------------
 *
 *  SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 * TODO:削除予定
 *
 */

/**
 * 構造体定義
 * 構造体はカンマで区切る事！
 */
struct sj_functions
(
    --////////////////////////////////////////////////
    --アバウト
    fn sjtools_about_Fn =
    (
        try (
            --ログファイルを指定
            logFile = (openFile ((getDir #scripts) + "\SJTools\SJTools_Log.ms"));
            --指定の文字列まで読み込む
            messageBox((readDelimitedString logFile "//")) title:"About";
        ) catch ();
    ),

    --////////////////////////////////////////////////
    --言語切り替え
    fn sjtools_changeLanguage_Fn =
    (
        if ((getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Language") != "JP") then
        (
            --日本語へ
            if (queryBox("SJToolsの言語を日本語へ切り替えますか?\n\nDo you switch the language to Japanese?\n") title:"Check") do
            (
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Language" "JP";

                --ツール名を全て変更
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJPBakeToolName" "ぴーべいく";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJRenamerToolName" "りねーまー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSparkToolName" "すぱーくん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJBioSkinPlusToolName" "ばいきん+";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJTimeMachineToolName" "たいむましん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSelectorToolName" "せれくにゃー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSelectorRigToolName" "せれくにゃーはりけーん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJAdjusterToolName" "あじゃすたー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJPoserToolName" "ぽーちゃん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJHiderToolName" "はいだー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJRollerToolName" "ろーらー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJBipFitterToolName" "びっぷふぃったー";

                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSceneSlicerToolName" "しーんすらいちゃん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJLayerLayerToolName" "れいやーれいやぁ～";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJAnimKeyPreviewToolName" "あにきー";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJKeyMachineToolName" "きーましん";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJMultiPRSToolName" "まるちにゃー";

                --再読み込み
                --マクロの除去
                --2011-2012
                deleteFile ("$ui\macroscripts\SJTools.mcr");
                --2013-
                deleteFile ("$max\Macroscripts\SJTools.mcr");

                --マクロのコピー
                --2011-2012
                copyFile "$max\Scripts\SJTools\SJTools_jp.mcr" "$ui\macroscripts\SJTools.mcr";
                --2013-
                copyFile "$max\Scripts\SJTools\SJTools_jp.mcr" "$max\MacroScripts\SJTools.mcr";

                --2011-2012
                try(macros.load("$ui\macroscripts\\"))catch();
                --2013-
                --try(macros.load((getDir #maxroot) + "\Macroscripts\\"))catch();
                try(macros.load("$max\Macroscripts\\"))catch();

                --お知らせ
                messageBox("切り替えが終わりました\nツールを再起動してください\n\nComplete\nPlease Reboot this tool.\n") title:"Complete";
            )
        ) else (
            --英語へ
            if (queryBox("SJToolsの言語を英語へ切り替えますか?\n\nDo you switch the language to English?\n") title:"Check") do
            (
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Language" "EN";

                --ツール名を全て変更
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJPBakeToolName" "SJ PBake";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJRenamerToolName" "SJ Renamer";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSparkToolName" "SJ Spark";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJBioSkinPlusToolName" "SJ Bio Skin +";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJTimeMachineToolName" "SJ Time Machine";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSelectorToolName" "SJ Selector";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSelectorRigToolName" "SJ Selector Hurricane";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJAdjusterToolName" "SJ Adjuster";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJPoserToolName" "SJ Poser";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJHiderToolName" "SJ Hider";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJRollerToolName" "SJ Roller";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJBipFitterToolName" "SJ Bip Fitter";

                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJSceneSlicerToolName" "SJ Scene Slicer";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJLayerLayerToolName" "SJ Layer Layer";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJAnimKeyPreviewToolName" "SJ Anim Key Preview";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJKeyMachineToolName" "SJ Key Mathine";
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJToolsToolName" "SJMultiPRSToolName" "SJ MultiRPS";

                --再読み込み
                --マクロの除去
                --2011-2012
                deleteFile ("$ui\macroscripts\SJTools.mcr");
                --2013-
                deleteFile ("$max\Macroscripts\SJTools.mcr");

                --マクロのコピー
                --2011-2012
                copyFile "$max\Scripts\SJTools\SJTools_en.mcr" "$ui\macroscripts\SJTools.mcr";
                --2013-
                copyFile "$max\Scripts\SJTools\SJTools_en.mcr" "$max\MacroScripts\SJTools.mcr";

                --2011-2012
                try(macros.load("$ui\macroscripts\\"))catch();
                --2013-
                try(macros.load("$max\Macroscripts\\"))catch();

                --お知らせ
                messageBox("切り替えが終わりました\nツールを再起動してください\n\nComplete\nPlease Reboot this tool.\n") title:"Complete";
            )
        )
        return true;
    ),

    --////////////////////////////////////////////////
    --アイコン
    fn sjtools_changeIcon_Fn=
    (
        if ((getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Icon") != "Standard") then
        (
            --通常アイコン
            if (queryBox("ガゥガゥ！ガゥガゥガァ～～?\n(アイコンを元に戻しますか?)\n\nGow gow! gow gow gow?\n(Change to Standard Icon?)\n") title:"Check") do
            (
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Icon" "Standard";

                /************************************
                max2010 - 2012
                *************************************/
                deleteFile "$ui\Icons\SJTools_Icon01_16i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon01_24i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon02_16i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon02_24i.bmp";

                /************************************
                max2013
                *************************************/
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_16i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_24i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_16i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_24i.bmp");
                --Dark用
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");

                /************************************
                max2011-2012
                *************************************/
                dir = getDir #maxroot;
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "ui\icons\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "ui\icons\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "ui\icons\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "ui\icons\SJTools_Icon02_24i.bmp");
                /************************************
                max2013
                *************************************/
                --マクロ
                dir = getDir #maxroot;
                --アイコン
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_24i.bmp");
                --Dark用
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");

                --アイコンを再読み込み
                colorman.reInitIcons();

            )
        ) else (
            --通常アイコン
            if (queryBox("ガゥガゥガゥゥ?ウガァ～～?\n(アイコンをヘンなのに変えますか?)\n\nGow gow gowww! Uga?\n(Change to Animal Icon?)\n") title:"Check") do
            (
                setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Icon" "Animal";

                /************************************
                max2010 - 2012
                *************************************/
                deleteFile "$ui\Icons\SJTools_Icon01_16i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon01_24i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon02_16i.bmp";
                deleteFile "$ui\Icons\SJTools_Icon02_24i.bmp";

                /************************************
                max2013
                *************************************/
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_16i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_24i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_16i.bmp");
                deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_24i.bmp");
                --Dark用
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
                deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");


                /************************************
                max2011-2012
                *************************************/
                dir = getDir #maxroot;
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i_Aml.bmp" (dir + "ui\icons\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i_Aml.bmp" (dir + "ui\icons\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i_Aml.bmp" (dir + "ui\icons\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i_Aml.bmp" (dir + "ui\icons\SJTools_Icon02_24i.bmp");
                /************************************
                max2013
                *************************************/
                --マクロ
                dir = getDir #maxroot;
                --アイコン
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i_Aml.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i_Aml.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i_Aml.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i_Aml.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_24i.bmp");
                --Dark用
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i_Aml.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i_Aml.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i_Aml.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
                copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i_Aml.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");

                --アイコンを再読み込み
                colorman.reInitIcons();
            )
        )
        return true;
    ),


    --////////////////////////////////////////////////
    --プログレスバー
    fn sj_progressBar_Fn =
    (
        global sj_progressBar_rol
        try (destroydialog sj_progressBar_rol) catch ();
        rollout sj_progressBar_rol "" width:416 height:56
        (
            progressBar progbar "" pos:[8,8] width:400 height:24 color:(color 30 10 190);
            label processInfo "" pos:[8,36] width:400 height:16;
        )
        CreateDialog sj_progressBar_rol style:#(/*#style_border, #style_titlebar, #style_sysmenu, #style_resizing,*/ #style_toolwindow, #style_minimizebox) --pos:[50,50]
    ),

    --////////////////////////////////////////////////
    --hide
    fn sj_SetHide_Fn nodes state =
    (
        for i in nodes do
        (
            hide i.node
        )

        if state then
        (
            for i in nodes do
            (
                unhide i.node
            )
        )
    ),

    --////////////////////////////////////////////////
    --freeze
    fn sj_SetFreeze_Fn nodes state =
    (
        for i in nodes do
        (
            freeze i.node
        )

        if state then
        (
            for i in nodes do
            (
            unfreeze i.node
            )
        )
    ),

    --////////////////////////////////////////////////
    --showFrozenInGray
    fn sj_SetFrozenGray_Fn nodes =
    (
        for i in nodes do
        (
            i.node.showFrozenInGray = off
        )
    ),

    --////////////////////////////////////////////////
    --select
    fn sj_SelectNodes_Fn nodes =
    (
        for i in nodes do
        (
            selectMore i.node
        )
    ),

    --////////////////////////////////////////////////
    --オブジェクトを選択しているのか??
    fn sj_SelectCheck_Fn =
    (
        if (selection.count != 0) then
        (
            return true;
        ) else (
            --オブジェクトが無い場合実行出来ない故、選択後実行を促す
            messageBox("オブジェクトが選択されていません\nなにかオブジェクトを選択して実行ください\n ")title:"メッセージ";
            return false;
        )
    ),

    /**
     * SJ_selectbranch_Fn
     * 指定のオブジェクト以下の構造を選択する
     */
    fn sj_selectBranch_Fn obj pram =
    (
        --新・構造を全部選択する
        with redraw off
        (
            local objRoot = obj;
            local objectBranch = #();--回収した子供
            checkObj = undefined;--チェックするオブジェクト
            checkChildren = #();--チェックするオブジェクトの配列
            --一つでも選択しているか？
            if (obj != undefined) do
            (
                --構造を全体を選択するならば
                if (pram != 1) do
                (
                    --選択したものの階層をさかのぼり、親オブジェクトが無くなったら回収
                    while objRoot.parent != undefined do
                    (
                        objRoot = objRoot.parent;
                    )
                )
                --配列に格納
                append objectBranch objRoot;

                --子供の数を入れる
                numChild = objRoot.children.count;
                --初期回収
                for i =1 to objRoot.children.count do
                (
                    --2つに回収
                    append checkChildren objRoot.children[i];
                    append objectBranch objRoot.children[i];
                )

                --0になるまで繰り返す
                while numChild != 0 do
                (
                    checkObj = checkChildren[numChild];

                    --チェック用配列からのおしりから削除
                    deleteItem checkChildren numChild;
                    numChild -= 1;

                    --子はあるか？
                    if (checkObj.children.count != 0) then
                    (
                        --print "有り";
                        numChild += checkObj.children.count;--カウントアップ
                        for i =1 to checkObj.children.count do
                        (
                            append checkChildren checkObj.children[i];
                            append objectBranch checkObj.children[i];
                        )
                    ) else (
                        --print "無し"
                    )
                )
            )
            return objectBranch;
        )

    ),

    --////////////////////////////////////////////////
    --配列内のオブジェクトを名前でソートする
    fn sj_nameStringSort_Fn s1 s2 =
    (
        --名前の文字列を比較した結果を代入
        local a = (stricmp s1.name s2.name);
        --比較結果から仕分けを行う
        case of
        (
            (a < 0.): -1
            (a > 0.): 1
            default: 0
        )
    ),

    /**
     * SJ_sortByBranch
     * 配列内容を親子順にソートしなおす
     * 引数は調べるオブジェクト配列
     * 返り値 並べ直した配列
     */
    fn sj_sortByBranch_Fn objArray =
    (
        --階層構造を全て取得
        local myObjAll = #(), delIndex = undefined;
            --local selObj = for i in selection collect i;
        local selObj = objArray;
        local objLevel = 1;
        local myObj = #();--作業用、兼最後に返す配列
        --////////////////////////////////////////////////
        --配列を準備
        --////////////////////////////////////////////////
        for i = 1 to 256 do
        (
            append myObjAll #();
        )
        --プログレスバー
        sj_functions.sj_progressBar_Fn();

        --////////////////////////////////////////////////
        --階層レベルを評価
        local progCountAll = selObj.count;
        local progCount = 1;

        for i in selObj do
        (
            sj_progressBar_rol.processInfo.caption =  "構造を評価しています   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
            sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
            progCount += 1;

            myObj = #();
            objLevel = 1;
            obj = i;
            --親が無くなるまで何回かかったか？=階層レベル
            while obj.parent != undefined do
            (
                obj = obj.parent
                objLevel += 1;
            )
            append myObjAll[objLevel] i;
        )

        --////////////////////////////////////////////////
        --配列内を名前でソート
        progCountAll = myObjAll.count;
        progCount = 1;
        for i in myObjAll do
        (
            sj_progressBar_rol.processInfo.caption =  "リストをソートしています   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
            sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
            progCount += 1;
            if i.count != 0 then
            (
                --一つ以上であれば名前で配列をソート--また名前を比較しながら配列内をソートする
                if (i.count > 1) do qsort i sj_functions.sj_nameStringSort_Fn;
            )
        )
        --////////////////////////////////////////////////
        --ひとつの配列にまとめる
        myObj=#();
        --配列が0で無ければ
        for i in myObjAll do if (i.count != 0) do join myObj i;
        try (destroydialog sj_progressBar_rol) catch ();
        return myObj;
    ),

    /**
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

        --プログレスバー
        sj_functions.sj_progressBar_Fn()
        sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
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

            --プログレスを更新
            sj_progressBar_rol.progbar.value = ((100.00/srchList.count) * progCount)
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

        --プログレス終了
        try (destroydialog sj_progressBar_rol) catch ();
        return resultList;
    ),

    /**
     * SJ_checkObjByName
     * 指定の名前のオブジェクトはシーン内にあるか？
     * 引数は調べるオブジェクト名
     * 返り値 true / false
     */
    fn sj_checkObjByName_Fn objName =
    (
        --オブジェクトを確保--大文字小文字判定あり
         getNodeTemp = (getNodeByName i exact:false ignoreCase:false all:true);
         --上のgetNodeBynameは配列が返されるので注意！

        --オブジェクトはあるか?配列の数が0ならば
        if (getNodeTemp.count == 0) then
        (
            messageBox("以下のオブジェクトがシーン上にありません\n" + i) title:"エラー";
            return false;
        )

        --同じ名前のオブジェクトがあるか?
        if (getNodeTemp.count >= 2) do doubleNameCheck = true;

        --bipかどうか確認
        --前のヤツif ((sj_pbake_rol.pbTypeRb.state == 1) or (sj_pbake_rol.pbTypeRb.state == 3)) then
        if (sj_pbake_rol.pbTypeRb.state == 3) then
        (
            tempObj = getNodeByName i;
            if ((classOf tempObj) == Biped_Object) or ((classOf tempObj.controller) == BipSlave_Control) then
            (
                messageBox("PlotはBipedに対応していません。\n" + i) title:"エラー";
                return false;
            )
        )
    ),

    --ファンクションエンド、カンマ区切りをミスしないように
    fn sj_fnEnd_Fn =
    (
        return print"fnEnd";
    )
)