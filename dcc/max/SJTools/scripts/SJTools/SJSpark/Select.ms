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
group "Select"
(
    button selectAllBranchBt "親子構造を全選択" width:160
)
on selectAllBranchBt pressed do
(
    with redraw off
    (
        --階層構造を全て取得
        if selection.count != 0 then
        (
            --変数を準備
            local objRoot = selection[1],
            obj = undefined;
            objectBranch = #();--回収した子供
            checkObj = undefined;--チェックするオブジェクト
            checkChildren = #();--チェックするオブジェクトの配列

            --選択したものの階層をさかのぼり、親オブジェクトが無くなったら回収
            while objRoot.parent != undefined do
            (
                objRoot = objRoot.parent
            )

            --配列に格納
            append objectBranch objRoot

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
                --deleteItem checkChildren 1;
                checkObj = checkChildren[numChild];
                --チェック用配列からのおしりから削除
                deleteItem checkChildren numChild;
                numChild -= 1;
                --子はあるか？
                if (checkObj.children.count != 0) then
                (
                    numChild += checkObj.children.count;--カウントアップ
                    for i =1 to checkObj.children.count do
                    (
                        append checkChildren checkObj.children[i];
                        append objectBranch checkObj.children[i];
                    )
                ) else (
                )
            )
            --最後に選択
            select objectBranch;
            print "選択終了";
        )
    )
)
