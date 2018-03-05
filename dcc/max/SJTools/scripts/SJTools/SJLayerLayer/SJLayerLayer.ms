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
 * SJ LayerLayer
 *
 */

global sj_layerlayer_rol
include "$scripts\SJTools\lib\progresBar.ms";

(
/**-----------------------------------------------------------------------------
 * Rollouts削除
 */
try(cui.FloatDialogBar sj_layerlayer_rol)catch()
try(cui.unRegisterDialogBar sj_layerlayer_rol)catch()
try(closeRolloutFloater sj_layerlayer_rol)catch()
try(destroydialog sj_layerlayer_rol)catch()

local nameAndVersion = "れいやーれいやー";

--レイヤープリセット用
local allLayerPresets = #();
local LayerPresets = #();
local languageFile = "JP";

--(getINISetting(languageFilePath) "SJ_LayerLayer" "MesseCapPSStr");
local defaultNameStr = "";
local NumStr = "1";
local fileLockID = 2256788990;

/**-----------------------------------------------------------------------------
 * メニュー
 */
rcMenu renamerMenuBar
(
    subMenu "ファイル"
    (
        menuItem saveLayerMi "レイヤーを保存" enabled:true
        menuItem loadLayerMi "レイヤーを読み込み" enabled:true
        --menuItem mergeFileMi "レイヤー状態を合成" enabled:true
        seperator sep01
        menuItem savePresetMi "プリセットを保存" enabled:true
        menuItem loadPresetMi "プリセットを読み込み" enabled:true
        seperator sep02
        menuItem closeMi "終了" enabled:true
    )

    subMenu "ヘルプ"
    (
        menuItem helpMi "ヘルプ"
        --menuItem aboutMi "About"
        --menuItem emailMi "E-Mail"
        --seperator sepChangeLang;
        --menuItem ChangeLangMi "言語変更(Change Language)";
    )

    --////////////////////////////////////////////////
    --アクション
    --////////////////////////////////////////////////
    on savePresetMi picked do sj_layerlayer_rol.savePreset_Fn();
    on loadPresetMi picked do sj_layerlayer_rol.loadPreset_Fn();
    on saveLayerMi picked do sj_layerlayer_rol.saveLayer_Fn();
    on loadLayerMi picked do sj_layerlayer_rol.loadLayer_Fn();
    on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=8656" "";

    on layerPresetrMenuBar update do
    (
    )
)

/**-----------------------------------------------------------------------------
 *
 */
fn initialize_Fn =
(
    local rol = sj_layerlayer_rol;
    sj_layerlayer_rol.editLNameTxt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJLayerLayer" "LastEditLNameTxt");
    rol.grpDelete.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "grpDelete");
    rol.uselessLayerDeleteBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "uselessLayerDeleteBt");
    rol.allLayerDeleteBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "allLayerDeleteBt");
    rol.grpStrings.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "grpStrings");
    rol.allLayerPfxBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "allLayerPfxBt");
    rol.allLayerSfxBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "allLayerSfxBt");
    rol.allLayerDlPxBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "allLayerDlPxBt");
    rol.layerDelByNameBt.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "layerDelByNameBt");
    rol.grpPreset.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "grpPreset");
    rol.presetLbl.caption = (getINISetting(languageFilePath) "SJ_LayerLayer" "presetLbl");
)

--初期設定記録
fn saveIni_Fn =
(
    (setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJLayerLayer" "LastEditLNameTxt" sj_layerlayer_rol.editLNameTxt.text);
)

--アップダウン
fn selUp_Fn selUpList selUpIndex =
(
    next = selUpList[ selUpIndex - 1 ]
    selUpList[ selUpIndex - 1 ] = selUpList[selUpIndex]
    selUpList[selUpIndex] = next
)

fn selDown_Fn selDownList selDownIndex =
(
    next = selDownList[ selDownIndex + 1 ]
    selDownList[ selDownIndex + 1 ] = selDownList[selDownIndex]
    selDownList[selDownIndex] = next
)

--Del clear
fn delList_Fn list i =
(
    deleteItem list i;
    deleteItem allLayerPresets i;
)

fn clearList_Fn =
(
    sj_layerlayer_rol.layerPresetCbx.items = #();
    allLayerPresets = #();
    sj_layerlayer_rol.layerPresetEdt.text = "";
)
--////////////////////////////////////////////////
--save default
--////////////////////////////////////////////////
fn saveDefault_Fn =
(
    /*
    書き出し順は
    プリセット数、
        プリセット名
            レイヤー数
            各レイヤー設定
        プリセット名
            レイヤー数
            各レイヤー設定
    */

    --なんとなく暗号化
    LayerLayerDefalutFile = createFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp";

    --プリセットの数を書き込み
    format "%\n" allLayerPresets.count to:LayerLayerDefalutFile;

    --カウント用
    u = 1;
    --各要素を書き出し
    for i in allLayerPresets do
    (
        --プリセット名を書き込み
        format "%\n" sj_layerlayer_rol.layerPresetCbx.items[u] to:LayerLayerDefalutFile;
        --レイヤー数を書き込み
        format "%\n" i.count to:LayerLayerDefalutFile;
        for k in i do
        (
            --レイヤー要素を書き込み
            for j in k do format "%\n" j to:LayerLayerDefalutFile;
        )
        u += 1;
    )

    close LayerLayerDefalutFile;
    encryptFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp" "$Scripts/SJTools/SJLayerLayer/LayerLayerDefalut.dat" fileLockID;
    return true;
)

--load default
fn loadDefault_Fn =
(
    local tempValue = undefined;
    local tempArray = #();--ひとつひとつレイヤーを回収
    local tempArrayAll = #();--プリセットとする配列
    --プリセット名設定
    local tempName = "";
    local tempNameArray = #();

    allLayerPresets = #();
    --なんとなく暗号化
    LayerLayerDefalutFile = openEncryptedFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.dat" fileLockID;

    --プリセット数（繰り返す回数
    i = readValue LayerLayerDefalutFile;
    for k =1 to i do
    (
        --プリセット名を読み込み
        tempName = (readLine LayerLayerDefalutFile);
        append tempNameArray tempName;

        --プリセットに含まれるレイヤーの数
        u = (readValue LayerLayerDefalutFile);
        --レイヤーの数だけ繰り返す
        for j = 1 to u do
        (
            tempArray = #();
            --各要素を取り出し
                --まずは名前
                tempValue = (readLine LayerLayerDefalutFile);
                append tempArray tempValue;

            /*その他の要素
            要素が増えた場合はその都度
            配列に合わせて読み込み数を変える*/
            for o = 2 to 41 do
            (
                tempValue = (readValue LayerLayerDefalutFile);
                append tempArray tempValue;
            )
            append tempArrayAll tempArray;
        )
        --プリセットに追加
        append allLayerPresets tempArrayAll;
        tempArrayAll = #();
    )
    close LayerLayerDefalutFile;
    --リストに追加
    sj_layerlayer_rol.layerPresetCbx.items = tempNameArray;
    return true;
)

--////////////////////////////////////////////////
--saveプリセット
--////////////////////////////////////////////////
fn savePreset_Fn =
(
    local saveFile = getSaveFileName types:"SJ Layer Preset File (*.SLP)|*.slp|All(*.*)|*.*" caption:"";
    if saveFile != undefined do
    (
        --なんとなく暗号化
        LayerLayerDefalutFile = createFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp"
        --プリセットの数を書き込み
        format "%\n" allLayerPresets.count to:LayerLayerDefalutFile;

        --カウント用
        u = 1;
        --各要素を書き出し
        for i in allLayerPresets do
        (
            --プリセット名を書き込み
            format "%\n" sj_layerlayer_rol.layerPresetCbx.items[u] to:LayerLayerDefalutFile;
            --レイヤー数を書き込み
            format "%\n" i.count to:LayerLayerDefalutFile;
            for k in i do
            (
                --レイヤー要素を書き込み
                for j in k do format "%\n" j to:LayerLayerDefalutFile;
            )
            u += 1;
        )

        close LayerLayerDefalutFile;
        encryptFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp" saveFile fileLockID;
        return true;
    )
)

--////////////////////////////////////////////////
--loadプリセット
--////////////////////////////////////////////////
fn loadPreset_Fn =
(
    local loadFile = getOpenFileName types:"SJ Layer Preset File (*.SLP)|*.slp|All(*.*)|*.*" caption:"";
    if loadFile == undefined do
    (
        return false;
    )

    local tempValue = undefined;
    local tempArray = #();--ひとつひとつレイヤーを回収
    local tempArrayAll = #();--プリセットとする配列
    --プリセット名設定
    local tempName = "";
    local tempNameArray = #();
    allLayerPresets = #();
    --バグ回避用にtry catch
    try (
        --なんとなく暗号化
        LayerLayerDefalutFile = openEncryptedFile loadFile fileLockID;

        --プリセット数（繰り返す回数
        i = readValue LayerLayerDefalutFile;

        for k =1 to i do
        (
            --プリセット名を読み込み
            tempName = (readLine LayerLayerDefalutFile);
            append tempNameArray tempName;

            --プリセットに含まれるレイヤーの数
            u = (readValue LayerLayerDefalutFile);
            --レイヤーの数だけ繰り返す
            for j = 1 to u do
            (
                tempArray = #();
                --各要素を取り出し
                --まずは名前
                tempValue = (readLine LayerLayerDefalutFile);
                append tempArray tempValue;

                /*その他の要素
                要素が増えた場合はその都度
                配列に合わせて読み込み数を変える*/
                for o = 2 to 41 do
                (
                    tempValue = (readValue LayerLayerDefalutFile);
                    append tempArray tempValue;
                )
                append tempArrayAll tempArray;
            )

            --プリセットに追加
            append allLayerPresets tempArrayAll;
            tempArrayAll = #();
        )
        close LayerLayerDefalutFile;
        --リストに追加
        sj_layerlayer_rol.layerPresetCbx.items = tempNameArray;
        return true;
    ) catch (
        messageBox MesseCmnFileErrStr title:MesseTitleErrStr
        return false
    )
    return true;
)

--////////////////////////////////////////////////
--saveレイヤー
--////////////////////////////////////////////////
fn saveLayer_Fn =
(
    local saveFile = getSaveFileName types:"SJ Layer Setting File (*.SLS)|*.sls|All(*.*)|*.*" caption:"";
    if saveFile != undefined do
    (
        return false;
    )

    --なんとなく暗号化
    LayerSettingFile = createFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp"

    --レイヤー0を除いたレイヤー数
    format "%\n" (layermanager.count - 1) to:LayerSettingFile;

    local saveTempArray = sj_layerlayer_rol.getLayerPreset_Fn();
    --各要素を書き出し
    for i in saveTempArray do
    (
        for k in i do
        (
            format "%\n" k to:LayerSettingFile;
        )
    )

    close LayerSettingFile;
    encryptFile "$Scripts/SJTools/SJLayerLayer//LayerLayerDefalut.tmp" saveFile fileLockID;
    return true;
)

--loadレイヤー
fn loadLayer_Fn =
(
    local loadFile = getOpenFileName types:"SJ Layer Setting File (*.SLS)|*.sls|All(*.*)|*.*" caption:"";

    if loadFile == undefined do
    (
        return false;
    )

    --バグ回避用にtry catch
    try (
        --なんとなく暗号化
        LayerSettingFile = openEncryptedFile loadFile fileLockID;

        --レイヤー数
        i = readValue LayerSettingFile;
        --0レイヤーの名前は読むが無視
        myLayerName = readLine LayerSettingFile;

        --最初にレイヤー0を設定
        myLayer = LayerManager.getLayer 0;
            --各設定を順に設定
            myLayer.on = readValue LayerSettingFile;--表示設定
            myLayer.lock = readValue LayerSettingFile;--フリーズ設定
            myLayer.renderable = readValue LayerSettingFile;
            myLayer.xray = readValue LayerSettingFile;
            myLayer.boxmode = readValue LayerSettingFile;
            myLayer.backfacecull = readValue LayerSettingFile;
            myLayer.alledges = readValue LayerSettingFile;
            myLayer.vertexTicks = readValue LayerSettingFile;
            myLayer.showTrajectory = readValue LayerSettingFile;
            myLayer.ignoreExtents = readValue LayerSettingFile;
            myLayer.showFrozenInGray = readValue LayerSettingFile;
            myLayer.showVertexColors = readValue LayerSettingFile;
            myLayer.vertexColorsShaded = readValue LayerSettingFile;
            myLayer.isGIExcluded = readValue LayerSettingFile;
            myLayer.inheritVisibility = readValue LayerSettingFile;
            myLayer.primaryVisibility = readValue LayerSettingFile;
            myLayer.secondaryVisibility = readValue LayerSettingFile;
            myLayer.receiveshadows = readValue LayerSettingFile;
            myLayer.castShadows = readValue LayerSettingFile;
            myLayer.applyAtmospherics = readValue LayerSettingFile;
            myLayer.renderOccluded = readValue LayerSettingFile;
            myLayer.motionblurOn = readValue LayerSettingFile;
            myLayer.motionblur = readValue LayerSettingFile;
            myLayer.imageMotionBlurMultiplier = readValue LayerSettingFile;
            myLayer.wireColor = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIOccluder = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIReceiver = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIRayMult = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIDiffuse = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGISpecular = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIExcludedFromRegather = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIUseGlobalMeshing = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMeshingEnabled = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIUseAdaptiveSubdivision = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMinMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIContrastThreshold = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIInitialMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.nbGIRefineSteps = readValue LayerSettingFile;
            myLayer.INodeGIProperties.nbGIRefineStepsDone = readValue LayerSettingFile;

        for k=1 to i do
        (
            --名前を拾って
            myLayerName = (readLine LayerSettingFile);
            myLayer = LayerManager.getLayerFromName myLayerName;
            --レイヤーが無ければ作る
            if myLayer == undefined do
            (
                myLayer = LayerManager.newLayerFromName myLayerName;
            )

            --各設定を順に設定
            myLayer.on = readValue LayerSettingFile;--表示設定
            myLayer.lock = readValue LayerSettingFile;--フリーズ設定
            myLayer.renderable = readValue LayerSettingFile;
            myLayer.xray = readValue LayerSettingFile;
            myLayer.boxmode = readValue LayerSettingFile;
            myLayer.backfacecull = readValue LayerSettingFile;
            myLayer.alledges = readValue LayerSettingFile;
            myLayer.vertexTicks = readValue LayerSettingFile;
            myLayer.showTrajectory = readValue LayerSettingFile;
            myLayer.ignoreExtents = readValue LayerSettingFile;
            myLayer.showFrozenInGray = readValue LayerSettingFile;
            myLayer.showVertexColors = readValue LayerSettingFile;
            myLayer.vertexColorsShaded = readValue LayerSettingFile;
            myLayer.isGIExcluded = readValue LayerSettingFile;
            myLayer.inheritVisibility = readValue LayerSettingFile;
            myLayer.primaryVisibility = readValue LayerSettingFile;
            myLayer.secondaryVisibility = readValue LayerSettingFile;
            myLayer.receiveshadows = readValue LayerSettingFile;
            myLayer.castShadows = readValue LayerSettingFile;
            myLayer.applyAtmospherics = readValue LayerSettingFile;
            myLayer.renderOccluded = readValue LayerSettingFile;
            myLayer.motionblurOn = readValue LayerSettingFile;
            myLayer.motionblur = readValue LayerSettingFile;
            myLayer.imageMotionBlurMultiplier = readValue LayerSettingFile;
            myLayer.wireColor = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIOccluder = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIReceiver = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIRayMult = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIDiffuse = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGISpecular = readValue LayerSettingFile;
            myLayer.INodeGIProperties.isGIExcludedFromRegather = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIUseGlobalMeshing = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMeshingEnabled = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIUseAdaptiveSubdivision = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIMinMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIContrastThreshold = readValue LayerSettingFile;
            myLayer.INodeGIProperties.GIInitialMeshSize = readValue LayerSettingFile;
            myLayer.INodeGIProperties.nbGIRefineSteps = readValue LayerSettingFile;
            myLayer.INodeGIProperties.nbGIRefineStepsDone = readValue LayerSettingFile;
        )
        close LayerSettingFile;
    ) catch (
        messageBox MesseCmnFileErrStr title:MesseTitleErrStr
        return false;
    )
    return true;
)--fn end


--プリセットを取得
fn getLayerPreset_Fn =
(
    local layerCount, layer, layerRT;
    local tempArray = #();--ひとつひとつレイヤーを回収
    local tempArrayAll = #();--プリセットとする配列
    local myLayer = undefined;

    --レイヤーの数
    layerCount = (layermanager.count - 1);

    for i=0 to layerCount do
    (
        myLayer = LayerManager.getLayer i;
        tempArray = #();

        --各設定を順に確保
        --名前
        append tempArray myLayer.name;
        --表示設定
        append tempArray myLayer.on;
        --フリーズ設定
        append tempArray myLayer.lock;
        --レンダリング設定
        append tempArray myLayer.renderable;
        --シースルー
        append tempArray myLayer.xray;
        --ボックスで表示
        append tempArray myLayer.boxmode;
        --背面非表示
        append tempArray myLayer.backfacecull;
        --エッジのみ表示
        append tempArray myLayer.alledges;
        --頂点数
        append tempArray myLayer.vertexTicks;
        --モーションパスを表示
        append tempArray myLayer.showTrajectory;
        --全範囲を無視
        append tempArray myLayer.ignoreExtents;
        --フリーズをグレー表示
        append tempArray myLayer.showFrozenInGray;
        --頂点カラー
        append tempArray myLayer.showVertexColors;
        --シェーディングON/OFF
        append tempArray myLayer.vertexColorsShaded;

        --ラジオシティの処理から除外
        append tempArray myLayer.isGIExcluded;
        --可視性を継承
        append tempArray myLayer.inheritVisibility;
        --カメラに対して可視
        append tempArray myLayer.primaryVisibility;
        --反射屈折に可視
        append tempArray myLayer.secondaryVisibility;
        --他からの影
        append tempArray myLayer.receiveshadows;
        --影付け
        append tempArray myLayer.castShadows;
        --環境効果の適応
        append tempArray myLayer.applyAtmospherics;
        --隠れたオブジェクトのレンダリング
        append tempArray myLayer.renderOccluded;

        --モーションブラー
        append tempArray myLayer.motionblurOn
        --モーションブラー
        append tempArray myLayer.motionblur
        --モーションブラー強度
        append tempArray myLayer.imageMotionBlurMultiplier

        --ワイヤーカラー26
        append tempArray myLayer.wireColor;

        --アドバンスドライティング
        --アドバンスドライティング影付け27
        append tempArray myLayer.INodeGIProperties.isGIOccluder;
        --発光を他から受ける28
        append tempArray myLayer.INodeGIProperties.isGIReceiver;
        --光の数だかなんだか29
        append tempArray myLayer.INodeGIProperties.GIRayMult;

        --???
        --myLayer.INodeGIProperties.GIByLayer = true
        --拡散光30
        append tempArray myLayer.INodeGIProperties.isGIDiffuse;
        --鏡面反射31
        append tempArray myLayer.INodeGIProperties.isGISpecular;
        --リザギャザリング32
        append tempArray myLayer.INodeGIProperties.isGIExcludedFromRegather;
        --グローバルサブディヴィジョン使用33
        append tempArray myLayer.INodeGIProperties.GIUseGlobalMeshing;
        --サブディバイド34
        append tempArray myLayer.INodeGIProperties.GIMeshingEnabled;
        --サブディバイド35
        append tempArray myLayer.INodeGIProperties.GIUseAdaptiveSubdivision;
        --各メッシュ設定36,37,38,39
        append tempArray myLayer.INodeGIProperties.GIMeshSize;
        append tempArray myLayer.INodeGIProperties.GIMinMeshSize;
        append tempArray myLayer.INodeGIProperties.GIContrastThreshold;
        append tempArray myLayer.INodeGIProperties.GIInitialMeshSize;

        --max2013以降の設定40,41
        append tempArray myLayer.INodeGIProperties.nbGIRefineSteps;
        append tempArray myLayer.INodeGIProperties.nbGIRefineStepsDone;

        --最後にメインのレイヤー配列に追加
        append tempArrayAll tempArray;
    )
    return tempArrayAll;
)

--プリセットを設定
fn setLayerPreset_Fn index =
(
    local layerCount, layer, layerRT;
    local tempArray = #();--ひとつひとつレイヤーを回収
    local tempArrayAll = #();--プリセットとする配列
    local myLayer = undefined;
    local tempName = "";
    local tempNameArray = sj_layerlayer_rol.layerPresetCbx.items;--名前管理用
    --レイヤーの数
    layerCount = (layermanager.count - 1);

    for i in allLayerPresets[index] do
    (
        --名前のレイヤーがあるか？
        myLayer = LayerManager.getLayerFromName i[1];
        --レイヤーがあれば
        if myLayer == undefined do
        (
            continue;
        )
        --各設定を順に設定
        --表示設定
        myLayer.on = i[2];
        --	フリーズ設定
        myLayer.lock = i[3];
        --レンダリング設定
        myLayer.renderable = i[4];
        --シースルー
        myLayer.xray = i[5];
        --ボックスで表示
        myLayer.boxmode = i[6];
        --背面非表示
        myLayer.backfacecull = i[7];
        --エッジのみ表示
        myLayer.alledges = i[8];
        --頂点数
        myLayer.vertexTicks = i[9];
        --モーションパスを表示
        myLayer.showTrajectory = i[10];
        --全範囲を無視
        myLayer.ignoreExtents = i[11];
        --フリーズをグレー表示
        myLayer.showFrozenInGray = i[12];
        --頂点カラー
        myLayer.showVertexColors = i[13];
        --シェーディングON/OFF
        myLayer.vertexColorsShaded = i[14];

        --ラジオシティの処理から除外
        myLayer.isGIExcluded = i[15];
        --可視性を継承
        myLayer.inheritVisibility = i[16];
        --カメラに対して可視
        myLayer.primaryVisibility = i[17];
        --反射屈折に可視
        myLayer.secondaryVisibility = i[18];
        --他からの影
        myLayer.receiveshadows = i[19];
        --影付け
        myLayer.castShadows = i[20];
        --環境効果の適応
        myLayer.applyAtmospherics = i[21];
        --隠れたオブジェクトのレンダリング
        myLayer.renderOccluded = i[22];

        --モーションブラー
        myLayer.motionblurOn = i[23];
        --モーションブラー
        myLayer.motionblur = i[24];
        --モーションブラー強度
        myLayer.imageMotionBlurMultiplier = i[25];

        --ワイヤーカラー
        myLayer.wireColor = i[26];

        --アドバンスドライティング
        --アドバンスドライティング影付け27
        myLayer.INodeGIProperties.isGIOccluder = i[27];
        --発光を他から受ける28
        myLayer.INodeGIProperties.isGIReceiver = i[28];
        --光の数だかなんだか29
        myLayer.INodeGIProperties.GIRayMult = i[29];

        --???
        --myLayer.INodeGIProperties.GIByLayer = true
        --拡散光30
        myLayer.INodeGIProperties.isGIDiffuse = i[30];
        --鏡面反射31
        myLayer.INodeGIProperties.isGISpecular = i[31];
        --リザギャザリング32
        myLayer.INodeGIProperties.isGIExcludedFromRegather = i[32];
        --グローバルサブディヴィジョン使用33
        myLayer.INodeGIProperties.GIUseGlobalMeshing = i[33];
        --サブディバイド34
        myLayer.INodeGIProperties.GIMeshingEnabled = i[34];
        --サブディバイド35
        myLayer.INodeGIProperties.GIUseAdaptiveSubdivision = i[35];
        --各メッシュ設定36,37,38,39
        myLayer.INodeGIProperties.GIMeshSize = i[36];
        myLayer.INodeGIProperties.GIMinMeshSize = i[37];
        myLayer.INodeGIProperties.GIContrastThreshold = i[38];
        myLayer.INodeGIProperties.GIInitialMeshSize = i[39];

        --max2013以降の設定40,41
        myLayer.INodeGIProperties.nbGIRefineSteps = i[40];
        myLayer.INodeGIProperties.nbGIRefineStepsDone = i[41];
    )
)


/**
 * メイン Rollout
 */
rollout sj_layerlayer_rol nameAndVersion width:200 height:494;
(
    --レイアウト
    GroupBox grpDelete "レイヤーを削除" pos:[8,8] width:184 height:88
    button uselessLayerDeleteBt "未使用を削除" pos:[16,30] width:168 height:24
    button allLayerDeleteBt "全て削除" pos:[16,62] width:168 height:24

    GroupBox grpStrings "文字列で整理" pos:[8,104] width:184 height:168
    edittext editLNameTxt "" pos:[12,124] width:172 height:16
    --edittext allLayerPfxTxt "" pos:[12,180] width:172 height:16
    button allLayerPfxBt "全レイヤー先頭に文字を追加" pos:[16,148] width:168 height:24
    button allLayerSfxBt "全レイヤー語尾に文字を追加" pos:[16,178] width:168 height:24
    --edittext allLayerDlPxTxt "" pos:[12,236] width:172 height:16
    button allLayerDlPxBt "対象文字を削除" pos:[16,208] width:168 height:24
    button layerDelByNameBt "名前でレイヤーを削除" pos:[16,238] width:168 height:24

    GroupBox grpPreset "レイヤー設定プリセット" pos:[8,280] width:184 height:206;
    button addListBt "Ad" pos:[16,296] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2) toolTip:"選択を追加";
    button upListBt "Up" pos:[40,296] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.png", "$Scripts/SJTools/Images//SJ_button_up_a.png", 2, 1, 1, 2, 2) toolTip:"Up";
    button downListBt "Dw" pos:[64,296] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.png", "$Scripts/SJTools/Images//SJ_button_down_a.png", 2, 1, 1, 2, 2) toolTip:"Down";
    button delBt "Dl" pos:[88,296] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2) toolTip:"削除";
    button clearBt "Cl" pos:[112,296] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2) toolTip:"クリア";

    edittext layerPresetEdt "" pos:[12,321] width:172 height:16;
    listbox layerPresetCbx "" pos:[16,340] width:168 height:9 /*items:#("aaa", "bbb", "ccc")*/ selection:1
    label presetLbl "ダブルクリックで切り替えます" pos:[14,468] width:144 height:16;

    local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
    ImgTag resizeImg "Bitmap" pos:[190,484] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

    --初期設定を保存
    on editLNameTxt changed str do saveIni_Fn();
    on editLNameTxt entered str do saveIni_Fn();

    --レイヤープリセット
    on addListBt pressed do
    (
        tempArray = getLayerPreset_Fn();
        --プリセットを追加
        append allLayerPresets tempArray;

        --プリセット名設定
        local tempName = "";
        local tempNameArray = sj_layerlayer_rol.layerPresetCbx.items;--名前管理用
        NumStr = (allLayerPresets.count as String);
        if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
        tempName = defaultNameStr + NumStr;
        append tempNameArray tempName;

        --表示を更新
        sj_layerlayer_rol.layerPresetCbx.items = tempNameArray;

        saveDefault_Fn();
        tempArray = tempName = tempNameArray = undefined;
    )


    on layerPresetCbx doubleclicked index do setLayerPreset_Fn index;
    on upListBt pressed do
    (
        if layerPresetCbx.selection != 0 and layerPresetCbx.selection != 1 do
        (
            selUp_Fn sj_layerlayer_rol.layerPresetCbx.items sj_layerlayer_rol.layerPresetCbx.selection;
            selUp_Fn allLayerPresets sj_layerlayer_rol.layerPresetCbx.selection
            layerPresetCbx.items = layerPresetCbx.items --表示更新
            layerPresetCbx.selection -= 1 --選択更新用
            layerPresetCbx.selection = layerPresetCbx.selection --選択更新
            saveDefault_Fn();
        )
    )

    on downListBt pressed do
    (
        if layerPresetCbx.selection != 0 and layerPresetCbx.items.count > layerPresetCbx.selection do
        (
            selDown_Fn sj_layerlayer_rol.layerPresetCbx.items sj_layerlayer_rol.layerPresetCbx.selection;
            selDown_Fn allLayerPresets sj_layerlayer_rol.layerPresetCbx.selection;
            layerPresetCbx.items = layerPresetCbx.items --表示更新
            layerPresetCbx.selection += 1 --選択更新用
            layerPresetCbx.selection = layerPresetCbx.selection --選択更新
            saveDefault_Fn();
        )
    )

    on delBt pressed do
    (
        if layerPresetCbx.selection != 0 then
        (
            delList_Fn sj_layerlayer_rol.layerPresetCbx.items sj_layerlayer_rol.layerPresetCbx.selection
            layerPresetCbx.items = layerPresetCbx.items
        )
        saveDefault_Fn();
    )

    on clearBt pressed do
    (
        clearList_Fn();
        saveDefault_Fn();
    )

    --プリセットを編集
    --リストの選択が変更されたら
    on layerPresetCbx selected sel do layerPresetEdt.text = layerPresetCbx.selected;
    --名前変更など
    --エンターが押された時
    on layerPresetEdt entered str do
    (
        --空でなければ
        if (str != "" and layerPresetCbx.items.count != 0) then
        (
            layerPresetCbx.selected = str;
            layerPresetCbx.items = layerPresetCbx.items;
            layerPresetCbx.selection = layerPresetCbx.selection;
            layerPresetCbx.text = str;


        )
    )

    --変更されたとき
    on layerPresetEdt changed str do
    (
        --空でなければ
        if (str != "" and layerPresetCbx.items.count != 0) then
        (
            layerPresetCbx.selected = str;
            layerPresetCbx.items = layerPresetCbx.items;
            layerPresetCbx.selection = layerPresetCbx.selection;
            layerPresetCbx.text = str;
        )
    )

    --未使用を削除
    on uselessLayerDeleteBt pressed do
    (
        local layerCount, layer, layerRT;
        local tagLayer = #();
        --レイヤーの数
        layerCount = (layermanager.count - 1);
        --レイヤー内にオブジェクトが無いレイヤーの名前を回収
        for i = 1 to layerCount do
        (
            --レイヤーを取得
            layer = layermanager.getlayer i;
            --refs.dependents用に登録
            layerRT = layer.layerAsRefTarg;

            --従属性がカウント3未満だった場合にその名前を回収
            if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
        )
        --いざレイヤー削除
        for i in tagLayer do layermanager.deleteLayerByName i
    )

    --全部削除
    on allLayerDeleteBt pressed do
    (
        local msgAStr = "本当に全てのレイヤーを削除しますか?\n\nレイヤー内のオブジェクトは削除されません\n0レイヤーへ移動します";
        if (queryBox (msgAStr) title:MesseTitleChkStr) then
        (
            local layerCount, layer, layerRT;
            local tagLayer = #();
            --レイヤーの数
            layerCount = (layermanager.count - 1);
            --基本レイヤーを確保
            layer = layermanager.getlayer 0;
            --カレントに設定
            layer.current = true;

            --全オブジェクトをレイヤー0番に移動
            --レイヤーに追加
            for i in objects do layer.addnode i;

            --レイヤー内にオブジェクトが無いレイヤーの名前を回収
            for i = 1 to layerCount do
            (
                --レイヤーを取得
                layer = layermanager.getlayer i;
                append tagLayer layer.name;
            )

            --いざレイヤー削除
            for i in tagLayer do layermanager.deleteLayerByName i;
        )
    )

    --名前でレイヤーを削除
    on layerDelByNameBt pressed do
    (
        if (editLNameTxt.text != "") then
        (
            --プログレス
            local layerCount, layer, layerRT, layerRefs, hitText;
            local tagLayer = #(), tagObj = undefined;
            local baseLayer = LayerManager.getLayer 0;
            clearSelection();
            suspendEditing();--サスペンドモード
            max create mode--クリエートモードに変更
            with redraw off
            (
                --レイヤーの数
                layerCount = (layermanager.count - 1);

                --初期化
                tagObj = undefined;
                local msgCStr = "を削除しますか?";

                --レイヤー内にオブジェクトが無いレイヤーの名前を回収
                for i = 1 to layerCount do
                (
                    --レイヤーを取得
                    layer = layermanager.getlayer i;
                    --refs.dependents用に登録
                    layerRT = layer.layerAsRefTarg;
                    --従属性がカウント3未満だった場合にその名前を回収
                    --レイヤーの名前から見つけて削除
                    hitText = findString layer.name editLNameTxt.text;

                    --文字が見つかったら！（検索結果undefindでなければ）
                    if hitText != undefined then
                    (
                        if (queryBox(layer.name + "  " + msgCStr)title:MesseTitleChkStr) do
                        (
                            append tagLayer layer.name;
                            layerRefs = refs.dependents layerRT;
                            --オブジェクトを移動
                            --一旦選択を解除
                            clearSelection();
                            --全選択
                            layer.select true;
                            --レイヤに加えて終わり
                            for i in selection do baseLayer.addnode i;
                            clearSelection();
                        )
                    )
                    tagObj = undefined;
                )
                --いざレイヤー削除
                for i in tagLayer do try( layermanager.deleteLayerByName i )catch();
            )
            resumeEditing()--再びアクティブに
        )
    )

    --全てのレイヤーにプレフィックス
    on allLayerPfxBt pressed do
    (
        local msgBStr = "テキストが入力されていません";
        --テキストはあるか？
        if (editLNameTxt.text != "") then
        (
            local layerCount, layer, layerRT;
            local tagLayer = #();

            --レイヤーの数
            layerCount = (layermanager.count - 1);

            --レイヤー内にオブジェクトが無いレイヤーの名前を回収
            for i = 1 to layerCount do
            (
                --レイヤーを取得
                layer = layermanager.getlayer i;
                --レイヤーの名前を変える
                layer.setname (editLNameTxt.text + layer.name);

            )
        ) else (
            messageBox msgBStr title:MesseTitleErrStr
        )
    )

    --全てのレイヤーにサフィックス
    on allLayerSfxBt pressed do
    (
        local msgBStr = "テキストが入力されていません";
        --テキストはあるか？
        if (editLNameTxt.text != "") then
        (
            local layerCount, layer, layerRT;
            local tagLayer = #();

            --レイヤーの数
            layerCount = (layermanager.count - 1);

            --レイヤー内にオブジェクトが無いレイヤーの名前を回収
            for i = 1 to layerCount do
            (
                --レイヤーを取得
                layer = layermanager.getlayer i;
                --レイヤーの名前を変える
                layer.setname (layer.name + editLNameTxt.text);
            )
        ) else (
            messageBox msgBStr title:MesseTitleErrStr
        )
    )

    --全てのレイヤーのプレフィックスを削除
    on allLayerDlPxBt pressed do
    (
        local msgBStr = "テキストが入力されていません";
        --テキストはあるか？
        if (editLNameTxt.text != "") then
        (
            local layerCount, layer, layerRT, hitText, myText;
            local tagLayer = #();

            --レイヤーの数
            layerCount = (layermanager.count - 1);

            --レイヤー内にオブジェクトが無いレイヤーの名前を回収
            for i = 1 to layerCount do
            (
                --レイヤーを取得
                layer = layermanager.getlayer i;
                --レイヤーの名前から見つけて削除
                hitText = findString layer.name editLNameTxt.text;
                --文字が見つかったら！（検索結果undefindでなければ）
                if hitText != undefined then
                (
                    --文字列を空にはしない
                    if (layer.name.count != editLNameTxt.text.count) then
                    (
                        --文字数分を空の文字に文字を置き換えます
                        --<対象のString> <開始文字番号> <置き換える文字数> <置き換える文字>
                        myText = replace layer.name hitText editLNameTxt.text.count "";
                        layer.setname myText;
                    )
                )
            )
        ) else (
            messageBox msgBStr title:MesseTitleErrStr
        )
    )

    --リサイズイベント
    on sj_layerlayer_rol resized val do
    (
        --増えた差分を計算
        width = val[1] - 200;
        height =  val[2] - 494;

        if ((sj_layerlayer_rol.width >= 200) and (sj_layerlayer_rol.height >= 494)) then
        (
            --リサイズイメージの位置
            resizeImg.pos = [(val[1]-10),(val[2]-10)];
            grpPreset.width = 184 + width;
            grpPreset.height = 206 + height;
            layerPresetEdt.width = 168 + width;
            layerPresetCbx.width = 168 + width;
            layerPresetCbx.height = 123 + height;
            presetLbl.pos = [14,(468 + height)];
        ) else (
        )
    )

    on sj_layerlayer_rol open do
    (
        initialize_Fn();
        loadDefault_Fn();
    )

    on sj_layerlayer_rol close do
    (
        saveDefault_Fn();
    )
)

/**
 * rollout
 */
--local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
--local posX = execute(getINISetting iniPath "SJRenamer" "rolPosX");
--local posY = execute(getINISetting iniPath "SJRenamer" "rolPosY");
CreateDialog sj_layerlayer_rol pos:[50,50] menu:renamerMenuBar style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu
)
