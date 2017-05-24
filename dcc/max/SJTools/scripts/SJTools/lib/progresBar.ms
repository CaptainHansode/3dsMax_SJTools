/**
 * -----------------------------------------------------------------------------
 *
 * SJTools Prog bar
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 */
struct SJProgressBar
(
    /**
     * 拡張子なしのファイル名
     */
    function show =
    (
        global SJProgressBarRol;
        try (destroydialog SJProgressBarRol) catch ();
        rollout SJProgressBarRol "" width:416 height:50
        (
            progressBar bar "" pos:[8,8] width:400 height:18 color:(color 72 192 192);
            label info "" pos:[40,28] width:400 height:16;
        )
        CreateDialog SJProgressBarRol style:#(#style_toolwindow, #style_minimizebox);
    ),

    function hide =
    (
        try (destroydialog SJProgressBarRol) catch ();
    ),

    function init =
    (
        SJProgressBarRol.info.text = "";
        SJProgressBarRol.bar.value = 0;
        SJProgressBarRol.title = "";
    ),

    function info infoStr =
    (
        SJProgressBarRol.info.text = infoStr;
    ),

    function val barVal =
    (
        SJProgressBarRol.bar.value = barVal;
    ),

    function title titleStr =
    (
        SJProgressBarRol.title = titleStr;
    )
)
