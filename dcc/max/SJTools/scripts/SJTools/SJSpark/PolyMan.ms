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
group "簡易ポリゴン管理"
(
    button countPAndVBt "ポリゴン頂点カウント" width:160 hight:20
    button fiveGonSelectBt "5角形以上を選択" width:160 hight:20
)
--ポリゴンカウント
on countPAndVBt pressed do
(
    Local myMesh = undefined, totalFaces = 0, totalVerts = 0;
    for i in selection do
    (
        myMesh = snapshotAsMesh i;
        messageBox(i.name+"\n" + (myMesh.faces.count as String) + "\n" + (myMesh.verts.count as String)) title:"Count stats";
        totalFaces += myMesh.faces.count;
        totalVerts +=  myMesh.verts.count;
        delete myMesh;
    )
    messageBox("Total\n" + (totalFaces as String) + "\n" + (totalVerts as String)) title:"Count stats";
)
--////////////////////////////////////////////////
--確保
--////////////////////////////////////////////////
on fiveGonSelectBt pressed do
(
    local selectBitArray = #{};
    for i in selection do
    (
        --Edit_Polyだった場合に
        if classOf i.baseobject != Editable_Poly then
        (
            if (queryBox ("編集可能ポリゴンではありません\nすぐに編集可能ポリゴンに変換しますか？")title:"メッセージ") then
            (
                convertto i editable_poly;
            ) else ()
        ) else (
            for j = 1 to i.faces.count do
            (
                if (polyOp.getFaceDeg i j) >= 5 then append selectBitArray j;
            )

            --最後に選択
            --print selectBitArray
            if (selectBitArray.numberSet != 0) then
            (
                try(
                    i.EditablePoly.SetSelection #Face selectBitArray;
                    --messageBox(i.name + "に5角形以上のポリゴンは\n" + (i.selectedFaces.count as String) + "  ポリゴンありました")title:"メッセージ";
                    messageBox(i.name + "に5角形以上のポリゴンは\n" + (selectBitArray.numberSet as String) + "  ポリゴンありました")title:"メッセージ";
                )catch(messageBox(i.name + "のポリゴン選択に失敗しました")title:"メッセージ");
            ) else (
                messageBox("5角形以上のポリゴンはありません")title:"メッセージ"
            )
        )
        selectBitArray = #{};
    )
)
