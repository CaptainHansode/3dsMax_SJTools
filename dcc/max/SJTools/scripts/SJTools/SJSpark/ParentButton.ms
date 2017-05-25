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
group "Maya風親子づけボタン"
(
    button setParentBt "ペアレント" width:160 hight:20
    button cutParentBt "カット" width:160 hight:20
    label parentButtonLbl "2番目以降の選択物を親子づけ" width:160 align:#center
)
on setParentBt pressed do
(
    if (selection.count > 1) do
    (
        for i=2 to selection.count do
        (
            try(selection[i].parent = selection[1])catch(print "Fail");
        )
    )
)

on cutParentBt pressed do
(
    if (selection.count != 0) do
    (
        for i in selection do
        (
            try(i.parent = undefined)catch();
        )
    )
)