/**
* -----------------------------------------------------------------------------
*
*  SJTools
*
* -----------------------------------------------------------------------------
* @fileoverview EditDuummySize.
* @copyright (c)2019 CaptainHansode.
* @license GLP
* @author 半袖船長
*
*/

struct SJToolsProgress
(
    function show =
    (
        global SJToolsProgBar;
        try (destroydialog SJToolsProgBar) catch();
        rollout SJToolsProgBar "" width:316 height:56
        (
            progressBar bar "" pos:[8,8] width:300 height:16;
            label info "" pos:[10,30] width:300 height:16;
        )
        CreateDialog SJToolsProgBar style:#(#style_toolwindow, #style_minimizebox);
    ),

    function hide =
    (
        try (destroydialog SJToolsProgBar) catch ();
    ),

    function update infoStr value =
    (
        SJToolsProgBar.info.text = infoStr;
        SJToolsProgBar.bar.value = value;
    )
)

/**-----------------------------------------------------------------------------
 * 本体
 */
struct SJEditDuummySize
(
    SJEditDmySize,
    TOOL_NAME = "DummySize",
    TOOL_VERSION = "0.0.0.1",
    AUTHOR = "半袖船長 CaptainHansode",
    WEB = "",
    mainRolWidth = 160,
    mainRolheight = 100,
    iniFilePath = "SJEditDuummySize.ini",

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
        -- iniFilePath = GetMyDocPath() \
        --         + "\\SJTools" \
        --         + "\\config" \
        --         + "\\SJEditDuummySize" \
        --         + "\\SJEditDuummySize.ini";
        -- defini = @"..\\SJEditDuummySize.ini";
        -- if (doesFileExist iniFilePath) == False do (
        --     makeDir (getFilenamePath iniFilePath);
        --     copyFile defini iniFilePath;
        -- )
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

    function GetDmSize =
    (
        print("aaaaaa")
    ),

    function SetDmSize obj size =
    (

    ),

    on Create do
    (
        -- SetIniPath();

    )
)

-- 構造体とグローバル変数名を同じにしない
global SJEds = SJEditDuummySize();

SJEds.SJEditDmySize =
(
    local winTitle = SJEds.TOOL_NAME + " " + SJEds.TOOL_VERSION;
    rollout SJEditDmySize winTitle width:160 height:100
    (
        spinner 'xspn' "" pos:[16,16] width:112 height:16 align:#left
        spinner 'yspn' "" pos:[16,40] width:112 height:16 align:#left
        spinner 'zspn' "" pos:[16,64] width:112 height:16 align:#left

        on runBt pressed do
        (

        )

        function _setDmSize =
        (
            for i in selection do (
                if ((classof i) == Dummy) do (
                    i.boxsize = [xspn.value, yspn.value, zspn.value];
                )
            )
        )

        on xspn changed val do
        (
            _setDmSize();
        )

        on yspn changed val do (
            _setDmSize();
        )

        on zspn changed val do (
            _setDmSize();
        )

        function _getDmSize =
        (
            if ((classof selection[1]) == Dummy) do (
                size = selection[1].boxsize
                xspn.value = size[1];
                yspn.value = size[2];
                zspn.value = size[3];
            )
        )

        on SJEditDmySize open do
        (
            callbacks.removeScripts id:#TestRuns
            callbacks.addScript #selectionSetChanged "SJEds.SJEditDmySize._getDmSize()" id:#TestRuns
        )

        on SJEditDmySize close do (
            -- callbacks.removeScripts [<callback_type_name>] [id:<name>] 	
            callbacks.removeScripts id:#TestRuns
        )

        on SJEditDmySize resized val do
        (
            -- 大きさが元の大きさを超えていれば
            if ((val[1] <= SJEds.mainRolWidth) \
            and (val[2] <= SJEds.mainRolheight)) then
            (
                return false;
            )
            -- tex	Path.width = val[1] - 92;
            -- getPathBt.pos = [val[1] - 36, 16]
            -- info.width = val[1] - 30;
            -- info.height = val[2] - 100;
        )
    )
)

/**-----------------------------------------------------------------------------
 * TODO:Executeになおす
 */
function SJCollectTexRun =
(
    -- SJEds は glonbal にある
    /*
    local posX = execute(
        getINISetting SJEds.iniFilePath "SJCollectTex" "rolPosX");
    local posY = execute(
        getINISetting SJEds.iniFilePath "SJCollectTex" "rolPosY");
    */
    local styleList = #(
        #style_border,
        #style_toolwindow,
        #style_sysmenu,
        #style_resizing,
        #style_minimizebox
    )
    SJEds.CloseDialogByName(SJEds.TOOL_NAME);
    -- CreateDialog SJEds.SJEditDmySize pos:[posX, posY] style:styleList;
    CreateDialog SJEds.SJEditDmySize style:styleList;

)

SJCollectTexRun();

