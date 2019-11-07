function UpdateSjSelectonList =
(
    updater = Python.Import "selecton.selecton_update";
    updater.update_sj_selecton_list();
)

function CloseSJSelectonWindow =
(
    updater = Python.Import "selecton.selecton_update";
    updater.close_sj_selecton_window();
)


/**
 * 以下のイベント時にグローバルを空にする
 * ファイルを開く、新規、リセット
 */

callbacks.removeScripts id:#SJSelectonClose
callbacks.addScript #filePreOpen "CloseSJSelectonWindow()" id:#SJSelectonClose
callbacks.addScript #systemPreNew "CloseSJSelectonWindow()" id:#SJSelectonClose
callbacks.addScript #systemPreReset "CloseSJSelectonWindow()" id:#SJSelectonClose
--callbacks.addScript #filePreOpenProcess "DeleteMorpheusGlobalArray()" id:#MorpheusDeleteGlobal

-- ファイルが開かれた
callbacks.removeScripts id:#SJSelectonUpdate
callbacks.addScript #filePostOpenProcess "UpdateSjSelectonList()" id:#SJSelectonUpdate
callbacks.addScript #systemPostNew "UpdateSjSelectonList()" id:#SJSelectonUpdate
callbacks.addScript #systemPostReset "UpdateSjSelectonList()" id:#SJSelectonUpdate
