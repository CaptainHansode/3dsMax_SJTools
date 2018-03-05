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
    toolTip:"りねーまー"
    buttonText:"りねーまー"
    Icon:#("SJTools_Icon01", 3)
    (
        include "$scripts/SJTools/SJRenamer/SJRenamer.ms"
    )

    -- SJSpark
    macroScript SJSpark
    category:"SJTools"
    toolTip:"すぱーくん"
    buttonText:"すぱーくん"
    Icon:#("SJTools_Icon01", 4)
    (
        include "$scripts/SJTools/SJSpark/SJSpark.ms"
    )

)