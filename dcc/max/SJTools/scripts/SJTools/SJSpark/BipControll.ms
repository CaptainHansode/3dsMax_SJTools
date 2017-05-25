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
group "Bip Controll"
(
    button slidingToFreeBt "Bip Slide to Free" width:160
    button freeToSlidingBt "Bip Free to Slide" width:160
)

--////////////////////////////////////////////////
--Action
--////////////////////////////////////////////////
on slidingToFreeBt pressed do
(
    if (queryBox("手足全てのキーをフリーキーにします\n実行しますか?\n ")title:"確認") do
    (
    Local tempK = #()
    suspendEditing()--サスペンドモード
    if maxOps.getSetKeyMode() == true do max set key mode --セットキーモードだった場合にセットキーモードをoff

    try(
    for i=1 to 2 do
    (
        tempObj = biped.getNode $ i
        tempBip = tempObj.transform.controller

        if tempBip.keys.count != 0 then
        (
        for u=1 to tempBip.keys.count do
        (
        append tempK tempBip.keys[u].time
        )--for end

        for k=1 to tempK.count do
        (
        sliderTime = tempK[k]
        biped.setFreeKey tempObj
        )--for end
        tempK = #()
        )--if end
    )--for end
    for i=5 to 6 do
    (
        tempObj = biped.getNode $ i
        tempBip = tempObj.transform.controller

        if tempBip.keys.count != 0 then
        (
        for u=1 to tempBip.keys.count do
        (
        append tempK tempBip.keys[u].time
        )--for end

        for k=1 to tempK.count do
        (
        sliderTime = tempK[k]
        biped.setFreeKey tempObj
        )--for end
        tempK = #()
        )--if end
    )--for end
    )catch(messageBox("失敗しました")title:"メッセージ");
    --)--with redraw end
    resumeEditing()--再びアクティブに
    );--if end
)

on freeToSlidingBt pressed do
(
    if (queryBox("手足全てのキーをスライドキーにします\n実行しますか?\n ")title:"確認") do
    (
    Local tempK = #()
    suspendEditing()--サスペンドモード
    if maxOps.getSetKeyMode() == true do max set key mode --セットキーモードだった場合にセットキーモードをoff
    --set animate off

    --with redraw off
    --(--再描画禁止

    try(
    for i=1 to 2 do
    (
        tempObj = biped.getNode $ i

        tempBip = tempObj.transform.controller
        if tempBip.keys.count != 0 then
        (
        for u=1 to tempBip.keys.count do
        (
        append tempK tempBip.keys[u].time
        )--for end

        for k=1 to tempK.count do
        (
        sliderTime = tempK[k]
        biped.setSlidingKey tempObj
        )--for end
        tempK = #()
        )--if end
    )--for end
    for i=5 to 6 do
    (
        tempObj = biped.getNode $ i

        tempBip = tempObj.transform.controller
        if tempBip.keys.count != 0 then
        (
        for u=1 to tempBip.keys.count do
        (
        append tempK tempBip.keys[u].time
        )--for end

        for k=1 to tempK.count do
        (
        sliderTime = tempK[k]
        biped.setSlidingKey tempObj
        )--for end
        tempK = #()
        )--if end
    )--for end

    )catch(messageBox("失敗しました")title:"メッセージ");
    --)--with redraw end
    resumeEditing()--再びアクティブに
    );--if end
)
