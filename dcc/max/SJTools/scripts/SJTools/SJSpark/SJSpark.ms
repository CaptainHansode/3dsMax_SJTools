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
 *
 * Smart Preset And Rig Kit
 *
 */
global sj_spark_rol;
global sj_sparksub_rol;
include "$scripts\SJTools\lib\progresBar.ms";

(
local nameAndVersion = "すぱーくん";
local NearSearchTagObj;

try(cui.FloatDialogBar sj_spark_rol)catch();
try(cui.unRegisterDialogBar sj_spark_rol)catch();
try(CloseRolloutFloater sj_spark_rol)catch();
try(destroydialog sj_spark_rol)catch();

rcMenu sparkMenuBar
(
    subMenu "ヘルプ"
    (
        menuItem helpMi "ヘルプ"
        menuItem emailMi "E-Mail"
    )
    on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5896" "";
    on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
    on poserMenuBar update do
    (
    )
)

--切り替えタブ用
rollout sj_spark_tabs_rol "タブ切り替えボタン"
(
)


--オブジェクト関連、構造関連
rollout sj_spark_objects_rol "Spark!! Objects"
(
    include "$scripts/SJTools/SJSpark/ParentButton.ms"
    include "$scripts/SJTools/SJSpark/HelperVisualChange.ms"
    include "$scripts/SJTools/SJSpark/HelperGa.ms"
    include "$scripts/SJTools/SJSpark/DummyBoxSizeChange.ms"
    include "$scripts/SJTools/SJSpark/SnapShotMaster.ms"
    include "$scripts/SJTools/SJSpark/Select.ms"
    include "$scripts/SJTools/SJSpark/ArraySort.ms"
    include "$scripts/SJTools/SJSpark/Text2EditableMesh.ms"
    include "$scripts/SJTools/SJSpark/LayerLayer.ms"
)

--アニメーション関連
rollout sj_spark_animations_rol "Spark!! Animtions"
(
    include "$scripts/SJTools/SJSpark/CameraConverter.ms"
    include "$scripts/SJTools/SJSpark/PickTheCopy.ms"
    include "$scripts/SJTools/SJSpark/BipControll.ms"
    include "$scripts/SJTools/SJSpark/AnimKeyDelete.ms"
)

--コントローラー関連
rollout sj_spark_contorollers_rol "Spark!! Controllers"
(
    include "$scripts/SJTools/SJSpark/SetController.ms"
    include "$scripts/SJTools/SJSpark/ObjectsDistance.ms"
    include "$scripts/SJTools/SJSpark/ObjectsLinker.ms"
    include "$scripts/SJTools/SJSpark/ParamerLinker.ms"
    include "$scripts/SJTools/SJSpark/MakeLookatPoint.ms"
)

--構造、ツール関連
rollout sj_spark_tools_rol "Spark!! Tools"
(
    include "$scripts/SJTools/SJSpark/MrSkiner.ms"
    include "$scripts/SJTools/SJSpark/PolyMan.ms"
    include "$scripts/SJTools/SJSpark/Zweihander.ms"
    include "$scripts/SJTools/SJSpark/SoundCnt.ms"
    include "$scripts/SJTools/SJSpark/ExportBatch.ms"
    include "$scripts/SJTools/SJSpark/ScaleChecker.ms"
)

--その他、特殊
rollout sj_spark_other_rol "Spark!! Other"
(
    include "$scripts/SJTools/SJSpark/Others.ms"
)

rollout sj_spark_rol nameAndVersion width:200 height:980
(
    subrollout sj_sparkarea pos:[0,60] width:sj_spark_rol.width height:920;
    button sparkTabsS "S" pos:[0,8] width:40 height:46;
    button sparkTabsP "P" pos:[40,8] width:40 height:46;
    button sparkTabsA "A" pos:[80,8] width:40 height:46;
    button sparkTabsR "R" pos:[120,8] width:40 height:46;
    button sparkTabsK "K" pos:[160,8] width:40 height:46;

    --タブ切り替えアクション
    on sparkTabsS pressed do
    (
        removeSubRollout sj_sparkarea sj_spark_animations_rol
        removeSubRollout sj_sparkarea sj_spark_contorollers_rol
        removeSubRollout sj_sparkarea sj_spark_tools_rol
        removeSubRollout sj_sparkarea sj_spark_other_rol
        addSubRollout sj_sparkarea sj_spark_objects_rol
    )
    on sparkTabsP pressed do
    (
        removeSubRollout sj_sparkarea sj_spark_objects_rol
        removeSubRollout sj_sparkarea sj_spark_contorollers_rol
        removeSubRollout sj_sparkarea sj_spark_tools_rol
        removeSubRollout sj_sparkarea sj_spark_other_rol
        addSubRollout sj_sparkarea sj_spark_animations_rol
    )
    on sparkTabsA pressed do
    (
        removeSubRollout sj_sparkarea sj_spark_objects_rol
        removeSubRollout sj_sparkarea sj_spark_animations_rol
        removeSubRollout sj_sparkarea sj_spark_tools_rol
        removeSubRollout sj_sparkarea sj_spark_other_rol
        addSubRollout sj_sparkarea sj_spark_contorollers_rol
    )
    on sparkTabsR pressed do
    (
        removeSubRollout sj_sparkarea sj_spark_objects_rol
        removeSubRollout sj_sparkarea sj_spark_animations_rol
        removeSubRollout sj_sparkarea sj_spark_contorollers_rol
        removeSubRollout sj_sparkarea sj_spark_other_rol
        addSubRollout sj_sparkarea sj_spark_tools_rol
    )
    on sparkTabsK pressed do
    (
        removeSubRollout sj_sparkarea sj_spark_objects_rol
        removeSubRollout sj_sparkarea sj_spark_animations_rol
        removeSubRollout sj_sparkarea sj_spark_contorollers_rol
        removeSubRollout sj_sparkarea sj_spark_tools_rol
        addSubRollout sj_sparkarea sj_spark_other_rol
    )
    on sj_spark_rol open do
    (
    )
    on sj_spark_rol close do
    (
        try (
            gc()
        ) catch (
        );
    )
)
CreateDialog sj_spark_rol style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:sparkMenuBar;
addSubRollout sj_spark_rol.sj_sparkarea sj_spark_objects_rol;
)
