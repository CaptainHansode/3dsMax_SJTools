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
group "Scale Checker"
(
    button scaleCheckBt "スケールが0かチェック" width:160 hight:20
)

-- 以下処理
on scaleCheckBt pressed do
(
    with redraw off
    (--再描画禁止
        searchTime = animationRange.end - animationRange.start;
        sT = animationRange.start;
        eT = animationRange.end;
        currentScale = undefined;
        falseScale = [0,0,0];
        falseScaleObjects = #();
        for k = sT to eT do
        (
            for i in objects do
            (
                currentScale = (at time k i.scale);
                if ((currentScale == falseScale)) then
                (
                    append falseScaleObjects i;
                )
            )
        )

        if falseScaleObjects.count != 0 do
        (
            messageBox "スケールが不正なオブジェクトがありました";
            select falseScaleObjects;
        )
    )
)
