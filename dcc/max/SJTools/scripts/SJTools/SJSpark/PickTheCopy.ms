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
group "Pick The Copy"
(
    button pickCopyBt "ピックザコピー" width:160 hight:20
    button selCopyBt "セレクトザコピー" width:160 hight:20
)

on pickCopyBt pressed do
(
    if selection.count != 0 then
    (
        local pickedObj = undefined;
        messageBox "コピー先のオブジェクトを選択してください" title:"メッセージ"
        pickedObj = PickObject count:1 select:false message:"オブジェクトを選択してください" ForceListenerFocus:true;

        try(
        pickedObj.controller = copy selection[1].controller;
        move pickedObj [0,0,0]; --リフレッシュ用　0距離移動
        )catch();
    )
    else
    (
        messageBox("コピー元のオブジェクトを選択してください") title:"メッセージ";
    )
)

on selCopyBt pressed do
(
    if selection.count >= 2 then
    (
        try(
            selection[2].controller = copy selection[1].controller;
            move selection[2] [0,0,0]; --リフレッシュ用　0距離移動
            sliderTime = (currenttime + 1);
            sliderTime = (currenttime - 1);

        --再描画
        max views redraw;

        )catch();
    )
    else
    (
        messageBox("最初にコピー元、2番目にコピー先を選んでください") title:"メッセージ";
    )
)