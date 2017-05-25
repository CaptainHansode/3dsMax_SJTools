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
group "選択内容をソート"
(
    button sortByParentBt "親子順にソート" width:160
    button sortByNameBt "名前順でソート" width:160
)

on sortByParentBt pressed do
(
    if selection != 0 then
    (
        --階層構造を全て取得
        local myObjAll = #(), delIndex = undefined;
        local selObj = for i in selection collect i;
        local objLevel = 1;

        --配列を準備
        for i = 1 to 256 do
        (
            append myObjAll #();
        )

        --親がないオブジェクトを検索
        for i in selObj do
        (
            myObj = #();
            if i.parent == undefined then
            (
                append myObjAll[1] i;
            )
        )

        --親の無いオブジェクトを配列から排除
        for i in myObjAll do
        (
            for k in i do
            (
                delIndex = findItem selObj k;
                deleteItem selObj delIndex;
            )
        )

        --階層レベルを評価
        local progCountAll = selObj.count;
        local progCount = 1;
        for i in selObj do
        (
            progCount += 1;
            myObj = #();
            objLevel = 1;
            obj = i;
            while obj.parent != undefined do
            (
                obj = obj.parent;
                objLevel += 1;
            )
            append myObjAll[objLevel] i;
        )

        --選択をし直し
        clearSelection()
        progCountAll = myObjAll.count;
        progCount = 1;
        for i in myObjAll do
        (
            progCount += 1;
            if i.count != 0 then selectMore i
        )
        print "選択終了";
    )
)

--名前で並び替え
on sortByNameBt pressed do
(
    if selection != 0 then
    (
        --階層構造を全て取得
        local myObj = #(), myObjAfter = #();
        local selObjName = for i in selection collect i.name;
        local selObjIh = for i in selection collect i.inode.handle;

        local progCountAll = selObjName.count;
        local progCount = 1;

        --ソート
        sort selObjName;
        clearSelection()

        --選択をし直し
        for i in selObjName do
        (
            --プログレスバー
            progCount += 1;
            --その名前のオブジェクトを回収
            myObj = getNodeByName i all:true;
            --iハンドルで名前の重複を確認
            for k in myObj do
            (
                --見つかれば
                if (findItem selObjIh k.inode.handle) != 0 then append myObjAfter k;
            )
        )
        --再選択
        select myObjAfter;
        print "選択終了";
    )
)

