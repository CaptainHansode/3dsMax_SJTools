/**
 * -----------------------------------------------------------------------------
 *
 *  SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @github https://github.com/CaptainHansode/SJTools
 *
 */
(
    -- SJRenamer
    macroScript SJRenamer
    category:"SJTools"
    toolTip:"SJRenamer"
    buttonText:"SJRenamer"
    -- Icon:#("SJTools_Icon01", 3)
    (
        include "$scripts/SJTools/SJRenamer/SJRenamer.ms"
    )

    -- SJSpark
    macroScript SJSpark
    category:"SJTools"
    toolTip:"SJSpark"
    buttonText:"SJSpark"
    -- Icon:#("SJTools_Icon01", 4)
    (
        include "$scripts/SJTools/SJSpark/SJSpark.ms"
    )

    -- SJTimeMachine
    macroScript SJTimeMachine
    category:"SJTools"
    toolTip:"SJTimeMachine"
    buttonText:"SJTimeMachine"
    -- Icon:#("SJTools_Icon01", 4)
    (
        include "$scripts/SJTools/SJTimeMachine/SJTimeMachine.ms"
    )

    macroScript SJRendPathEdit
    category:"SJTools"
    toolTip:"SJRendPathEdit"
    buttonText:"SJRendPathEdit"
    -- Icon:#("SJTools_Icon01", 4)
    (
        -- TODO: fileinじゃなくてinclude出来るように直す
        filein "$scripts/SJTools/SJRendPathEdit/SJRendPathEdit.ms"
        -- include "$scripts/SJTools/SJRendPathEdit/SJRendPathEdit.ms"
    )
)