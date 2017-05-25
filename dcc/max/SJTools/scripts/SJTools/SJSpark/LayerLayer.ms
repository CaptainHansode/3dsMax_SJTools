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
 */
group "レイヤー　レイヤー"
(
    button uselessLayerDeleteBt "未使用レイヤー削除" width:160;
    button allLayerDeleteBt "全てのレイヤーを削除" width:160;
    button layerDelByNameBt "名前でレイヤー削除" width:160;
    editText layerDelByNameTxt "" width:160 height:16 align:#center;
    button allLayerPfxBt "全レイヤーにプレフィックス" width:160
    editText allLayerPfxTxt "" width:160 height:16 align:#center;
    button allLayerDlPxBt "全レイヤー対象文字を削除" width:160
    editText allLayerDlPxTxt "" width:160 height:16 align:#center;
)

--未使用を削除
on uselessLayerDeleteBt pressed do
(
    local layerCount, layer, layerRT;
    local tagLayer = #();

    --レイヤーの数
    layerCount = (layermanager.count - 1);
    --レイヤー内にオブジェクトが無いレイヤーの名前を回収
    for i = 1 to layerCount do
    (
        --レイヤーを取得
        layer = layermanager.getlayer i;
        --refs.dependents用に登録
        layerRT = layer.layerAsRefTarg;

        --従属性がカウント3未満だった場合にその名前を回収
        if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;

    )
    --いざレイヤー削除
    for i in tagLayer do layermanager.deleteLayerByName i
)

--全部削除
on allLayerDeleteBt pressed do
(
    local layerCount, layer, layerRT;
    local tagLayer = #();
    --レイヤーの数
    layerCount = (layermanager.count - 1);
    --基本レイヤーを確保
    layer = layermanager.getlayer 0;
    --カレントに設定
    layer.current = true;
    --全オブジェクトをレイヤー0番に移動
    for i in objects do
    (
        --レイヤーに追加
        layer.addnode i;
    )
    --レイヤー内にオブジェクトが無いレイヤーの名前を回収
    for i = 1 to layerCount do
    (
        --レイヤーを取得
        layer = layermanager.getlayer i;
        append tagLayer layer.name;
    )
    for i in tagLayer do layermanager.deleteLayerByName i
)

--名前でレイヤーを削除
on layerDelByNameBt pressed do
(
    if (layerDelByNameTxt.text != "") then
    (

        clearSelection();
        suspendEditing();--サスペンドモード
        max create mode--クリエートモードに変更
        with redraw off
        (

            local layerCount, layer, layerRT, layerRefs, hitText
            local tagLayer = #(), tagObj = undefined;

            --レイヤーの数
            layerCount = (layermanager.count - 1);

            --レイヤー0のオブジェクトを削除
            if (queryBox("0レイヤーのオブジェクトを削除しますか?")title:"メッセージ") then
            (
                layer = layermanager.getlayer 0;
                layerRT = layer.layerAsRefTarg;
                layerRefs = refs.dependents layerRT;
                if layerRefs.count >= 3 then
                (
                    --レイヤーを参照しているオブジェクトを回収
                    layer.nodes &tagObj;
                    delete tagObj;
                )
            )

            --初期化
            tagObj = undefined;

            --レイヤー内にオブジェクトが無いレイヤーの名前を回収
            for i = 1 to layerCount do
            (
                --レイヤーを取得
                layer = layermanager.getlayer i;
                --refs.dependents用に登録
                layerRT = layer.layerAsRefTarg;
                --従属性がカウント3未満だった場合にその名前を回収
                if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
                --レイヤーの名前から見つけて削除
                hitText = findString layer.name layerDelByNameTxt.text;
                --文字が見つかったら！（検索結果undefindでなければ）
                if hitText != undefined then
                (
                    append tagLayer layer.name;
                    layerRefs = refs.dependents layerRT;

                    --ヒットしたレイヤーのオブジェクトを削除
                    if (queryBox(layer.name + "  はオブジェクトごと削除しますか?")title:"メッセージ") then
                    (
                        if layerRefs.count >= 3 then
                        (
                            layer.nodes &tagObj;
                            delete tagObj;
                        )
                    )
                )
                tagObj = undefined;
            )
            --いざレイヤー削除
            for i in tagLayer do try( layermanager.deleteLayerByName i )catch();
        )
        resumeEditing()--再びアクティブに
    )
)

--全てのレイヤーにプレフィックス
on allLayerPfxBt pressed do
(
    --テキストはあるか？
    if (allLayerPfxTxt.text != "") then
    (

        local layerCount, layer, layerRT;
        local tagLayer = #();
        --レイヤーの数
        layerCount = (layermanager.count - 1);

        --レイヤー内にオブジェクトが無いレイヤーの名前を回収
        for i = 1 to layerCount do
        (
            --レイヤーを取得
            layer = layermanager.getlayer i;
            --レイヤーの名前を変える
            layer.setname (allLayerPfxTxt.text + layer.name);
        )

    )else(messageBox"テキストが入力されていません"title:"エラー");--if end
)

--全てのレイヤーのプレフィックスを削除
on allLayerDlPxBt pressed do
(
    --テキストはあるか？
    if (allLayerDlPxTxt.text != "") then
    (
        local layerCount, layer, layerRT, hitText, myText;
        local tagLayer = #();
        --レイヤーの数
        layerCount = (layermanager.count - 1);
        --レイヤー内にオブジェクトが無いレイヤーの名前を回収
        for i = 1 to layerCount do
        (
            --レイヤーを取得
            layer = layermanager.getlayer i;
            --レイヤーの名前から見つけて削除
            hitText = findString layer.name allLayerDlPxTxt.text;
            --文字が見つかったら！（検索結果undefindでなければ）
            if hitText != undefined then
            (
                --文字列を空にはしない
                if (layer.name.count != allLayerDlPxTxt.text.count) then
                (
                --文字数分を空の文字に文字を置き換えます
                --<対象のString> <開始文字番号> <置き換える文字数> <置き換える文字>
                myText = replace layer.name hitText allLayerDlPxTxt.text.count "";
                layer.setname myText;
                )
            )
        )

    ) else (
        messageBox"テキストが入力されていません"title:"エラー"
    )
)

