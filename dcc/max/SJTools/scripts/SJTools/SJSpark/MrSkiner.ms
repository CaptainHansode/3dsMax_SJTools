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
group "簡易スキン管理"
(
    button mrSkinerBt "以下の値の頂点を選択" width:160 hight:20
    spinner mrSkinerCheckWeight "" range:[0,1,1] type:#float scale:0.001 width:160 align:#center
)
--////////////////////////////////////////////////
--確保
--////////////////////////////////////////////////
on mrSkinerBt pressed do
(
--修正パネルにしないとエラーが出る
max modify mode
Local selectVertsArray = #{}, checkResult = false, myObj = selection[1], vertsCount = 0;
Local weightArray = #();
append weightArray mrSkinerCheckWeight.value;

--オブジェクトは選択しているか？
if sj_functions.sj_SelectCheck_Fn() do
(

--スキンもぢファイアはあるか
if (myObj.modifiers["Skin"] != undefined) then
(
    vertsCount = selection[1].verts.count;
    if (skinOps.GetNumberBones myObj.skin) != 0 then
    (
        --1頂点ごとに調べる
        for i = 1 to vertsCount do
        (
            checkResult = false;
            --頂点のウェイトの影響数分
            for k = 1 to (skinops.GetVertexWeightCount myObj.skin i) do
            (
                --指定のウェイトがあれば結果をtrueに
                if (findItem weightArray (skinops.getVertexWeight myObj.skin i k) == 0) do checkResult = true;
            );--for end
            --ウェイトが空の頂点を回収
            if not checkResult then append selectVertsArray i;
            --print selectVertsArray;
        );--for end

        --選択
        skinOps.SelectVertices myObj.skin selectVertsArray;
        if (selectVertsArray.numberSet != 0) then messageBox("以下の数だけ頂点を選択しました\n" + (selectVertsArray.numberSet as String) + "  見つかりました") title:"メッセージ";

    )else(
        messageBox("ボーンがありません")title:"メッセージ";
    );--if end
)else(
    messageBox("スキンモヂファイアがありません")title:"メッセージ";
);--if end

);--if endオブジェクト選択チェック

);--end
