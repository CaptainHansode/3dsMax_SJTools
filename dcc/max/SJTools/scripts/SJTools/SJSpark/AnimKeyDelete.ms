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

group "Delete All Keys"
(
    button delOutRangeKeysBt "範囲外キーを削除" width:160
    label delAllKeysLdl1"Transform" width:160
    button delAllPosKeysBt "全ての位置キーを削除" width:160
    button delAllRotKeysBt "全ての回転キーを削除" width:160
    button delAllScanKeysBt "全てのスケールキーを削除" width:160
)

--del
on delOutRangeKeysBt pressed do
(
    for i in objects do
    (
        --キー選択を解除
        deselectKeys i;
        --範囲外のキーを選択
        selectkeys i (interval -100000 (animationRange.start-1));
        --選択したキーを削除
        deleteKeys i #selection;
        --キー選択を解除
        deselectKeys i;
        --範囲外のキーを選択
        selectkeys i (interval (animationRange.end+1) 100000);
        --選択したキーを削除
        deleteKeys i #selection;
    )
)

on delAllPosKeysBt pressed do
(
    local oldTransform = undefined;
    local j = 0;
    try(
        for i in selection do
        (
            oldTransform = i.transform;
            j = i.pos.controller.keys.count;
            --キーカウントがなくなるまで
            --配列のお尻から削除
            while j > 0 do
            (
                deleteKey i.pos.controller.keys j;
                j -= 1;
            )
            --transformを戻す
            i.transform = oldTransform;
        )
    )catch();
)

on delAllRotKeysBt pressed do
(
    local oldTransform = undefined;
    local j = 0;
    try(
        for i in selection do
        (
            oldTransform = i.transform;
            j = i.rotation.controller.keys.count;
            --キーカウントがなくなるまで
            --配列のお尻から削除
            while j > 0 do
            (
                deleteKey i.rotation.controller.keys j;
                j -= 1;
            )
            i.transform = oldTransform;
        )
    )catch();
)

on delAllScanKeysBt pressed do
(
    local oldTransform = undefined;
    local j = 0;
    try(
        for i in selection do
        (
            oldTransform = i.transform;
            j = i.scale.controller.keys.count;
            --キーカウントがなくなるまで
            --配列のお尻から削除
            while j > 0 do
            (
                deleteKey i.scale.controller.keys j;
                j -= 1;
            )
            i.transform = oldTransform;
        )
    )catch();
)