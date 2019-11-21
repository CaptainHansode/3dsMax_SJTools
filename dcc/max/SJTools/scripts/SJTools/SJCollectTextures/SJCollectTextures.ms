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
struct SJCollectTextures
(
    SJCollectTexRol,
    TOOL_NAME = "テクスチャ収集マシーン",
    TOOL_VERSION = "0.0.0.1",
    AUTHOR = "半袖船長 CaptainHansode",
    WEB = "",
    mainRolWidth = 216,
    mainRolheight = 200,
    iniFilePath = "SJCollectTextures.ini",

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
        defini = @"..\\SJCollectTextures.ini";
        if (doesFileExist iniFilePath) == False do (
            makeDir (getFilenamePath iniFilePath);
            copyFile defini iniFilePath;
        )
    ),

    function getFolderPath defPath =
    (
        f = getOpenFileName caption:"何かファイルを選択してください:" \
        filename:(getFilenamePath defPath) \
        historyCategory:"MAXScriptFileOpenSave";
        result = "";
        if (f != undefined) do
        (
            result = f;
        )
        return result;
    ),

    function PathNormalize path_str =
    (
        local result = path_str;
        local last_str = path_str[path_str.count];
        if (last_str == "\\") or (last_str == "/") do
        (
            return result;
        )
        return result + @"\";
    ),

    /**
     */
     function CollectTexFile filePath setRelative =
     (
        local result = #();
        if ((doesFileExist filePath) == false) do
        (
            try(
                makeDir filePath;
            ) catch(
                append result "フォルダを作成できません";
                return result;
            )
        );

        tex_count = (GetClassInstances BitmapTexture).count;
        prog_count = 0;
        local ret = true;

        charas = #("ゆうしゃ", "せんし", "そうりょ", "まほうつかい", "とうぞく", "しょうにん")
        chara_id = random 1 charas.count;

        append result (charas[chara_id] + " はコピーをかいしした!");

        if (tex_count == 0) do
        (
            append result ("テクスチャーがない!");
        )

        for map in (GetClassInstances BitmapTexture) do
        (
            if (doesFileExist map.filename) == False do (
                append result ("ファイルがない! " + map.filename);
                continue;
            )
            if (findstring map.filename "UV_Checker.png") != undefined do (
                continue;
            )

            SJToolsProgress.update ("コピー中 " + map.filename) prog_count;
            local tex_name = filenameFromPath map.filename;
            local new_path = filePath + tex_name;
            -- print(new_path);

            local cmd = "echo F| xcopy /Y \"" \
                    + map.filename + "\" \"" + new_path + "\""
            ret = HiddenDOSCommand cmd;

            if (ret == false) do (
                append result (map.filename + " はコピーできない!");
                continue;
            )
            append result (map.filename + " をコピーした!");

            map.filename = new_path;

            -- 相対化
            if (setRelative == true) do (
            map.filename = "..\\" + tex_name;
            )
        )
        append result ("コピーがしゅうりょうした!");
        return result;
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

    on Create do
    (
        SetIniPath();

    )
)

-- 構造体とグローバル変数名を同じにしない
global SJCltTex = SJCollectTextures();

SJCltTex.SJCollectTexRol =
(
    local winTitle = SJCltTex.TOOL_NAME + " " + SJCltTex.TOOL_VERSION;
    rollout SJCollectTexRol winTitle width:460 height:200
    (
        editText 'texPath' "コピー先" pos:[16,16] width:408 height:16 align:#left
        button 'getPathBt' "..."  pos:[424,16] width:24 height:16 align:#left
        button 'runBt' "テクスチャ収集" pos:[16,40] width:432 height:32 align:#left
        edittext 'info' "" pos:[12,80] width:434 height:104 align:#left

        on getPathBt pressed do
        (
            local dir_name = SJCltTex.getFolderPath texPath.text;
            if (dir_name != "") do
            (
                texPath.text = getFilenamePath dir_name;
            )
        )

        on runBt pressed do
        (
            -- python.ExecuteFile @"..\\str_replace.py";

            info.text = "";
            if (texPath.text == "") do (
                return false;
            )
            tex_path = SJCltTex.PathNormalize texPath.text;
            SJToolsProgress.show();
            ret = SJCltTex.CollectTexFile tex_path false;
            SJToolsProgress.hide();
            local msg = "";
            for r in ret do (
                msg = msg + r + "\n";
            )
            info.text = msg;
            messageBox("おわったお");
        )

        on SJCollectTexRol open do
        (
            texPath.text = SJCltTex.GetMyDocPath();
            local def_paht = maxfilePath;
            if (def_paht != "") do
            (
                texPath.text = def_paht;
            )
        )

        on SJCollectTexRol close do (
        )

        on SJCollectTexRol moved val do
        (
            /*
            setINISetting SJCltTex.iniFilePath \
                        "SJCollectTex" \
                        "rolPosX" (val[1] as String);
            setINISetting SJCltTex.iniFilePath \
                        "SJCollectTex" \
                        "rolPosY" (val[2] as String);
            */
        )

        on SJCollectTexRol resized val do
        (
            -- 大きさが元の大きさを超えていれば
            if ((val[1] <= SJCltTex.mainRolWidth) \
            and (val[2] <= SJCltTex.mainRolheight)) then
            (
                return false;
            )
            texPath.width = val[1] - 92;
            getPathBt.pos = [val[1] - 36, 16]
            info.width = val[1] - 30;
            info.height = val[2] - 100;
        )
    )
)

/**-----------------------------------------------------------------------------
 * TODO:Executeになおす
 */
function SJCollectTexRun =
(
    -- SJCltTex は glonbal にある
    /*
    local posX = execute(
        getINISetting SJCltTex.iniFilePath "SJCollectTex" "rolPosX");
    local posY = execute(
        getINISetting SJCltTex.iniFilePath "SJCollectTex" "rolPosY");
    */
    local styleList = #(
        #style_border,
        #style_toolwindow,
        #style_sysmenu,
        #style_resizing,
        #style_minimizebox
    )
    SJCltTex.CloseDialogByName(SJCltTex.TOOL_NAME);
    -- CreateDialog SJCltTex.SJCollectTexRol pos:[posX, posY] style:styleList;
    CreateDialog SJCltTex.SJCollectTexRol style:styleList;

)

SJCollectTexRun();

