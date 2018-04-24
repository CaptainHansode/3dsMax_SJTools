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
    iniFile = "SJCollectTextures.ini",
    function SaveIni =
    (
        
    ),
    DEBUG = False
)

try(cui.FloatDialogBar SJCltTex.SJCollectTexRol)catch();
try(cui.unRegisterDialogBar SJCltTex.SJCollectTexRol)catch();
try(closeRolloutFloater SJCltTex.SJCollectTexRol) catch();
try(destroydialog SJCltTex.SJCollectTexRol)catch();

global SJCltTex = SJCollectTextures();
SJCltTex.SJCollectTexRol = (
    local SJCollectTexRol;
    local winTitle = SJCltTex.TOOL_NAME + " " + SJCltTex.TOOL_VERSION;
    rollout SJCollectTexRol winTitle width:165 height:168
    (
        button 'saveAsBt' "_AOをつけて別名保存" pos:[12,120] width:140 height:32 align:#left
        label 'eLbl' "max" pos:[20,48] width:28 height:16 align:#left

        on SJCollectTexRol close do (
        )

        on SJCollectTexRol moved val do
        (
            print("a")
            setINISetting SJCltTex.iniFile "SJCollectTex" "rolPosX" (val[1] as String);
            setINISetting SJCltTex.iniFile "SJCollectTex" "rolPosY" (val[2] as String);
        )
    )
)

/**-----------------------------------------------------------------------------
 * TODO:Executeになおす
 */
local posX = execute(getINISetting SJCltTex.iniFile "SJCollectTex" "rolPosX");
local posY = execute(getINISetting SJCltTex.iniFile "SJCollectTex" "rolPosY");
local posX = 0;
local posY = 0;
local styleList = #(#style_border,
    #style_toolwindow,
    #style_sysmenu,
    #style_resizing,
    #style_minimizebox
    );

CreateDialog SJCltTex.SJCollectTexRol pos:[posX, posY] style:styleList
)
