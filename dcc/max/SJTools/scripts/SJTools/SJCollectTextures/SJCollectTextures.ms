/**
* -----------------------------------------------------------------------------
*
*  SJTools
*
* -----------------------------------------------------------------------------
* @fileoverview CollectAllTextures.
* @copyright (c)2018 CaptainHansode.
* @license MIT
* @author 半袖船長
* 自前のツールの転用です
*/
(

/**-----------------------------------------------------------------------------
 * 本体
 */
struct SJCollectTextures
(
    SJCollectTexRol,
    TOOL_NAME = "soutai",
    TOOL_VERSION = "0.0.0.1",
    AUTHOR = "半袖船長 CaptainHansode",
    WEB = "",
    mainRolWidth = 210,
    mainRolheight = 450,
    iniFilePath = "SJCollectTextures.ini",
    defaultIni = "",

    function GetMyDocPath =
    (
        speFld = dotNetClass "System.Environment+specialFolder";
        sysEnv = dotNetClass "System.Environment";
        return sysEnv.getfolderPath speFld.MyDocuments;
    ),

    function SaveIni =
    (

    ),

    function SetIniPath =
    (
        iniFilePath = GetMyDocPath() \
                + "\\SJTools" \
                + "\\config" \
                + "\\SJCollectTextures" \
                + "\\SJCollectTextures.ini";
        if (doesFileExist iniFilePath) == False do (
            makeDir (getFilenamePath iniFilePath);
            copyFile "SJCollectTextures.ini" iniFilePath;
        )
    ),

    function CloseDialogByName digName = (
        dig = UIAccessor.GetPopupDialogs();
        for d in dig do (
            winTxt = uiAccessor.getWindowText d;
            if (findstring winTxt digName) != undefined do (
                print(format "% is Close." winTxt);
                UIAccessor.CloseDialog d;
            )
        )
    ),

    function init =
    (
        SetIniPath();
    ),

    DEBUG = False;
)

global SJCltTex = SJCollectTextures();
SJCltTex.init();

SJCltTex.SJCollectTexRol = (
    local winTitle = SJCltTex.TOOL_NAME + " " + SJCltTex.TOOL_VERSION;
    rollout SJCollectTexRol winTitle width:165 height:168
    (
        button 'saveAsBt' "test" pos:[12,120] width:140 height:32 align:#left
        label 'eLbl' "test" pos:[20,48] width:28 height:16 align:#left

        on SJCollectTexRol close do (
        )

        on SJCollectTexRol moved val do
        (
            setINISetting SJCltTex.iniFilePath \
                        "SJCollectTex" \
                        "rolPosX" (val[1] as String);
            setINISetting SJCltTex.iniFilePath \
                        "SJCollectTex" \
                        "rolPosY" (val[2] as String);
        )
    )
)


/**-----------------------------------------------------------------------------
 * TODO:Executeになおす
 */
function SJCollectTexRun =
(
    -- SJCltTex は glonbal にある
    local posX = execute(
        getINISetting SJCltTex.iniFilePath "SJCollectTex" "rolPosX");
    local posY = execute(
        getINISetting SJCltTex.iniFilePath "SJCollectTex" "rolPosY");

    local styleList = #(#style_border,
        #style_toolwindow,
        #style_sysmenu,
        #style_resizing,
        #style_minimizebox
        );

    SJCltTex.CloseDialogByName(SJCltTex.TOOL_NAME);
    CreateDialog SJCltTex.SJCollectTexRol pos:[posX, posY] style:styleList;
)

SJCollectTexRun();
)
