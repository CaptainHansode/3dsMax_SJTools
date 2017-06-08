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
 * SJRendPathEdit
 *
 */

/**-----------------------------------------------------------------------------
 * global
 */
global SJRdPathEdit;
struct SJRendPathEdit (
                        SJRdPathEditRol,
                        mainRolWidth = 310,
                        mainRolheight = 450,
                        TOOL_NAME = "パスチカン",
                        TOOL_VERSION = "試作品",
                        AUTHOR = "半袖船長 CaptainHansode",
                        WEB = "試作品",
                        emlBtnName = "エレメント",
                        grpWidth = 296,
                        edtWidth = 231,

                        edtPosX = 12,
                        lblPosX = 16,
                        pathBtnPosX = 248,
                        okBtnPosX = 272,
                        rendBtnPosY = 372,
                        elmLblPosY = 424,
                        elmBtnPosY = 442
                      );

try(cui.FloatDialogBar SJRdPathEdit.SJRdPathEditRol)catch();
try(cui.unRegisterDialogBar SJRdPathEdit.SJRdPathEditRol)catch();
try(closeRolloutFloater SJRdPathEdit.SJRdPathEditRol)catch();
try(destroydialog SJRdPathEdit.SJRdPathEditRol)catch();

SJRdPathEdit = SJRendPathEdit();

--include "$scripts\SJTools\lib\progresBar.ms";

/**-----------------------------------------------------------------------------
 * 編集
 */
function getFolderPath defPath =
(
    f = getOpenFileName caption:"何かファイルを選択してください:" \
    filename:(getFilenamePath defPath);
    --filename:(GetDir #renderoutput)
    result = "";
    if (f != undefined) do
    (
        --result = getFilenamePath f;
        result = f;
    )
    return result;
)

function setEditTxt toTxt defPath =
(
    local txt = getFolderPath("");
    if (txt != "") do
    (
        toTxt.text = txt;
    )
)

function setAllRendPath rendPath elmEdtList =
(
    rendOutputFilename = rendPath;
    re = maxOps.GetCurRenderElementMgr();
    for n = 0 to (re.numrenderelements () - 1) do
    (
        re.SetRenderElementFilename n elmEdtList[n + 1].text;
    )
    renderSceneDialog.update();
)

function setEmlRendPath n pathStr =
(
    re = maxOps.GetCurRenderElementMgr();
    re.SetRenderElementFilename (n - 1) pathStr;
    renderSceneDialog.update();
)


function delRendPath rendPath elmEdtList =
(
    rendPath.text = "";
    for el = 1 to elmEdtList.count do
    (
        elmEdtList[el].text = "";
    )
)

function replaceText originalStr findStr repStr =
(
    local hit = findString originalStr findStr;
    result = originalStr;
    if hit != undefined then
    (
        result = replace originalStr hit findStr.count repStr;
    )
    return result;
)

function replacePath rendPath elmEdtList findStr repStr =
(
    rendPath.text = (replaceText rendPath.text findStr repStr);
    for el = 1 to elmEdtList.count do
    (
        elmEdtList[el].text = (replaceText elmEdtList[el].text findStr repStr);
    )
)

/**-----------------------------------------------------------------------------
 * 初期化
 */
function initialize rol =
(
    append rol.elmEdtList rol.remElmEdt01;
    append rol.elmEdtList rol.remElmEdt02;
    append rol.elmEdtList rol.remElmEdt03;
    append rol.elmEdtList rol.remElmEdt04;
    append rol.elmEdtList rol.remElmEdt05;
    append rol.elmEdtList rol.remElmEdt06;
    append rol.elmEdtList rol.remElmEdt07;
    append rol.elmEdtList rol.remElmEdt08;
    append rol.elmEdtList rol.remElmEdt09;
    append rol.elmEdtList rol.remElmEdt10;
    append rol.elmEdtList rol.remElmEdt11;
    append rol.elmEdtList rol.remElmEdt12;

    append rol.elmLblList rol.rnElmLbl01;
    append rol.elmLblList rol.rnElmLbl02;
    append rol.elmLblList rol.rnElmLbl03;
    append rol.elmLblList rol.rnElmLbl04;
    append rol.elmLblList rol.rnElmLbl05;
    append rol.elmLblList rol.rnElmLbl06;
    append rol.elmLblList rol.rnElmLbl07;
    append rol.elmLblList rol.rnElmLbl08;
    append rol.elmLblList rol.rnElmLbl09;
    append rol.elmLblList rol.rnElmLbl10;
    append rol.elmLblList rol.rnElmLbl11;
    append rol.elmLblList rol.rnElmLbl12;

    append rol.elmBtList rol.rEOKBtn01;
    append rol.elmBtList rol.rEOKBtn02;
    append rol.elmBtList rol.rEOKBtn03;
    append rol.elmBtList rol.rEOKBtn04;
    append rol.elmBtList rol.rEOKBtn05;
    append rol.elmBtList rol.rEOKBtn06;
    append rol.elmBtList rol.rEOKBtn07;
    append rol.elmBtList rol.rEOKBtn08;
    append rol.elmBtList rol.rEOKBtn09;
    append rol.elmBtList rol.rEOKBtn10;
    append rol.elmBtList rol.rEOKBtn11;
    append rol.elmBtList rol.rEOKBtn12;

    append rol.elmPhList rol.rEPathBtn01;
    append rol.elmPhList rol.rEPathBtn02;
    append rol.elmPhList rol.rEPathBtn03;
    append rol.elmPhList rol.rEPathBtn04;
    append rol.elmPhList rol.rEPathBtn05;
    append rol.elmPhList rol.rEPathBtn06;
    append rol.elmPhList rol.rEPathBtn07;
    append rol.elmPhList rol.rEPathBtn08;
    append rol.elmPhList rol.rEPathBtn09;
    append rol.elmPhList rol.rEPathBtn10;
    append rol.elmPhList rol.rEPathBtn11;
    append rol.elmPhList rol.rEPathBtn12;

    local lbY = SJRdPathEdit.elmLblPosY;
    local btY = SJRdPathEdit.elmBtnPosY;

    local lbX = SJRdPathEdit.lblPosX;
    local edX = SJRdPathEdit.edtPosX;
    local pBtX = SJRdPathEdit.pathBtnPosX;
    local okBtX = SJRdPathEdit.okBtnPosX;

    rol.rendPathEdt.text = rendOutputFilename;
    re = maxOps.GetCurRenderElementMgr();

    local elmPath = "";

    for n = 0 to (re.numrenderelements () - 1) do
    (
        i = n + 1;
        elmPath = re.GetRenderElementFileName n;
        if (elmPath != undefined) do
        (
            rol.elmEdtList[i].text = elmPath;
        )
        el = re.getrenderelement n;
        rol.elmLblList[i].caption = el.elementname;

        rol.elmLblList[i].pos = [lbX, lbY]
        rol.elmEdtList[i].pos = [edX, btY];
        rol.elmPhList[i].pos = [pBtX, btY];
        rol.elmBtList[i].pos = [okBtX, btY];

        lbY += 44;
        btY += 44;
    )

    rol.height = SJRdPathEdit.mainRolheight + (re.numrenderelements () * 48);
)

/**-----------------------------------------------------------------------------
 * 設定を保存
 */
function saveIni = (
    --local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    --(setINISetting iniPath "SJRenamer" "LastKeyWordNews" SJRenamerRol.newNameEdt.text);
)

/**-----------------------------------------------------------------------------
 * リサイズ
 */
function resizeRol rol val = (
    local width = SJRdPathEdit.mainRolWidth;
    local height = SJRdPathEdit.mainRolWidth;
    if ((rol.width <= width) and (rol.height <= height)) then
    (
        return false;
    )

    local offsetW = val[1] - width;
    local grpOffset = 14;
    local edtOffset = 34;
    local rendOffset = 84;
    local pathBtX = SJRdPathEdit.pathBtnPosX + offsetW;
    local okBtX = SJRdPathEdit.okBtnPosX + offsetW;
    local posY = SJRdPathEdit.rendBtnPosY;

    rol.repGrp.width = val[1] - grpOffset;
    rol.findEdt.width = val[1] - edtOffset;
    rol.repEdt.width = val[1] - edtOffset;
    rol.rendGrp.width = val[1] - grpOffset;
    rol.rendPathEdt.width = val[1] - rendOffset;
    rol.rendPathBtn.pos = [pathBtX, posY];
    rol.rendOKBtn.pos = [okBtX, posY];
    rol.emlGrp.width = val[1] - grpOffset;

    posY = SJRdPathEdit.elmBtnPosY;

    re = maxOps.GetCurRenderElementMgr();

    for n = 1 to re.numrenderelements() do
    (
        rol.elmEdtList[n].width = val[1] - rendOffset;
        rol.elmPhList[n].pos = [pathBtX, posY];
        rol.elmBtList[n].pos = [okBtX, posY];
        posY += 44;
    )
)

/**-----------------------------------------------------------------------------
 * メニュー
 */
rcMenu SJRdPathEditMenu
(
    subMenu "ヘルプ"
    (
        menuItem helpMi "ヘルプ";
        menuItem emailMi "E-Mail";
        seperator sepChangeLang;
        --menuItem ChangeLangMi "言語変更(Change Language)";
    )
    --アクション
    on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" "";
    on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
    on SJRdPathEditMenu update do
    (
    )
)

/**----------------------------------------------------------------------------------------------------------------------------------------------------------
 * メイン Rollout
 */
SJRdPathEdit.SJRdPathEditRol =
(
    local SJRdPathEditRol;
    local toolName = SJRdPathEdit.TOOL_NAME + " " + SJRdPathEdit.TOOL_VERSION;
    rollout SJRdPathEditRol toolName width:SJRdPathEdit.mainRolWidth height:SJRdPathEdit.mainRolheight;
    (
        local elmEdtList = #();
        local elmLblList = #();
        local elmBtList = #();
        local elmPhList = #();

        GroupBox 'grp1' "一括設定" pos:[8,8] width:296 height:84 align:#left
        button 'allSetBtn' "レンダリング出力パスを全てのエレメントに" pos:[16,28] width:276 height:24 align:#left
        button 'allDelBtn' "全て空欄" pos:[16,60] width:276 height:24 align:#left

        GroupBox 'repGrp' "置換" pos:[8,100] width:296 height:148 align:#left
        edittext 'findEdt' "" pos:[12,140] width:280 height:20 align:#left
        label 'lbl1' "検索文字" pos:[16,122] width:168 height:16 align:#left
        edittext 'repEdt' "" pos:[12,184] width:280 height:20 align:#left
        label 'lbl2' "置換文字" pos:[16,166] width:168 height:16 align:#left
        button 'repBtn' "置換" pos:[16,212] width:276 height:24 align:#left

        GroupBox 'grp5' "適応" pos:[8,256] width:296 height:84 align:#left
        button 'updateBtn' "リロード" pos:[20,276] width:272 height:24 align:#left
        button 'allOKBtn' "シーンに適応" pos:[20,308] width:272 height:24 align:#left

        GroupBox 'rendGrp' "レンダリング出力" pos:[8,348] width:296 height:52 align:#left
        edittext 'rendPathEdt' "" pos:[12,372] width:231 height:20 align:#left
        button 'rendPathBtn' "..." pos:[248,372] width:20 height:20 align:#left
        button 'rendOKBtn' "OK" pos:[272,372] width:20 height:20 align:#left

        GroupBox 'emlGrp' "Render Elements" pos:[8,404] width:296 height:592 align:#left
        edittext 'remElmEdt01' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn01' "..." pos:[248,-100] width:20 height:20 align:#left
        button 'rEOKBtn01' "OK" pos:[272,-100] width:20 height:20 align:#left
        label 'rnElmLbl01' "エレメント1" pos:[16,-100] width:168 height:16 align:#left
        edittext 'remElmEdt02' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn02' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn02' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl02' "エレメント2" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt03' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn03' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn03' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl03' "エレメント3" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt04' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn04' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn04' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl04' "エレメント4" pos:[15,-100] width:168 height:16 align:#left
        checkbutton 'ckb1' "CheckButton" pos:[76,-100] width:0 height:0 align:#left
        edittext 'remElmEdt05' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn05' "..." pos:[248,-100] width:20 height:20 align:#left
        button 'rEOKBtn05' "OK" pos:[272,-100] width:20 height:20 align:#left
        label 'rnElmLbl05' "エレメント5" pos:[16,-100] width:168 height:16 align:#left
        edittext 'remElmEdt06' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn06' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn06' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl06' "エレメント6" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt07' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn07' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn07' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl07' "エレメント7" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt08' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn08' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn08' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl08' "エレメント8" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt09' "" pos:[13,-100] width:231 height:20 align:#left
        button 'rEPathBtn09' "..." pos:[248,-100] width:20 height:20 align:#left
        button 'rEOKBtn09' "OK" pos:[272,-100] width:20 height:20 align:#left
        label 'rnElmLbl09' "エレメント9" pos:[16,-100] width:168 height:16 align:#left
        edittext 'remElmEdt10' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn10' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn10' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl10' "エレメント10" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt11' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn11' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn11' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl11' "エレメント11" pos:[15,-100] width:168 height:16 align:#left
        edittext 'remElmEdt12' "" pos:[12,-100] width:231 height:20 align:#left
        button 'rEPathBtn12' "..." pos:[247,-100] width:20 height:20 align:#left
        button 'rEOKBtn12' "OK" pos:[271,-100] width:20 height:20 align:#left
        label 'rnElmLbl12' "エレメント12" pos:[16,-100] width:168 height:16 align:#left

        /**-----------------------------------------------------------------------------
        * イベント
        */
        on allSetBtn pressed do
        (
            local rendPath = rendPathEdt.text;
            remElmEdt01.text = rendPath;
            remElmEdt02.text = rendPath;
            remElmEdt03.text = rendPath;
            remElmEdt04.text = rendPath;
            remElmEdt05.text = rendPath;
            remElmEdt06.text = rendPath;
            remElmEdt07.text = rendPath;
            remElmEdt08.text = rendPath;
            remElmEdt09.text = rendPath;
            remElmEdt10.text = rendPath;
            remElmEdt11.text = rendPath;
            remElmEdt12.text = rendPath;
        )

        on updateBtn pressed do initialize(SJRdPathEditRol);

        on allOKBtn pressed do
        (
            setAllRendPath rendPathEdt.text elmEdtList;
        )

        on allDelBtn pressed do
        (
            delRendPath rendPathEdt elmEdtList;
        )

        on repBtn pressed do
        (
            replacePath rendPathEdt elmEdtList findEdt.text repEdt.text;
        )

        on rendPathBtn pressed do setEditTxt rendPathEdt rendPathEdt.text;
        on rEPathBtn01 pressed do setEditTxt remElmEdt01 remElmEdt01.text;
        on rEPathBtn02 pressed do setEditTxt remElmEdt02 remElmEdt02.text;
        on rEPathBtn03 pressed do setEditTxt remElmEdt03 remElmEdt03.text;
        on rEPathBtn04 pressed do setEditTxt remElmEdt04 remElmEdt04.text;
        on rEPathBtn05 pressed do setEditTxt remElmEdt05 remElmEdt05.text;
        on rEPathBtn06 pressed do setEditTxt remElmEdt06 remElmEdt06.text;
        on rEPathBtn07 pressed do setEditTxt remElmEdt07 remElmEdt07.text;
        on rEPathBtn08 pressed do setEditTxt remElmEdt08 remElmEdt08.text;
        on rEPathBtn09 pressed do setEditTxt remElmEdt09 remElmEdt09.text;
        on rEPathBtn10 pressed do setEditTxt remElmEdt10 remElmEdt10.text;
        on rEPathBtn11 pressed do setEditTxt remElmEdt11 remElmEdt11.text;
        on rEPathBtn12 pressed do setEditTxt remElmEdt12 remElmEdt12.text;

        on rendOKBtn pressed do
        (
            rendOutputFilename = rendPathEdt.text;
            renderSceneDialog.update();
        )
        on rEOKBtn01 pressed do setEmlRendPath 1 remElmEdt01.text;
        on rEOKBtn02 pressed do setEmlRendPath 2 remElmEdt02.text;
        on rEOKBtn03 pressed do setEmlRendPath 3 remElmEdt03.text;
        on rEOKBtn04 pressed do setEmlRendPath 4 remElmEdt04.text;
        on rEOKBtn05 pressed do setEmlRendPath 5 remElmEdt05.text;
        on rEOKBtn06 pressed do setEmlRendPath 6 remElmEdt06.text;
        on rEOKBtn07 pressed do setEmlRendPath 7 remElmEdt07.text;
        on rEOKBtn08 pressed do setEmlRendPath 8 remElmEdt08.text;
        on rEOKBtn09 pressed do setEmlRendPath 9 remElmEdt09.text;
        on rEOKBtn10 pressed do setEmlRendPath 10 remElmEdt10.text;
        on rEOKBtn11 pressed do setEmlRendPath 11 remElmEdt11.text;
        on rEOKBtn12 pressed do setEmlRendPath 12 remElmEdt12.text;

        on SJRdPathEditRol resized val do resizeRol SJRdPathEditRol val;

        on SJRdPathEditRol open do initialize(SJRdPathEditRol);
        on SJRdPathEditRol moved val do
        (
            --local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
            --(setINISetting iniPath "SJRenamer" "rolPosX" (val[1] as String));
            --(setINISetting iniPath "SJRenamer" "rolPosY" (val[2] as String));
        )
    )
)

/**-----------------------------------------------------------------------------
 * End of rollout & Create Dialog / Floater
 */
 function runSJRdPathEdit =
 (
    --local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    --local posX = execute(getINISetting iniPath "SJRenamer" "rolPosX");
    --local posY = execute(getINISetting iniPath "SJRenamer" "rolPosY");
    posX = 150;
    posY = 150;
    CreateDialog SJRdPathEdit.SJRdPathEditRol /*pos:[posX, posY]*/ menu:SJRdPathEditMenu style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;
 )

-- run
runSJRdPathEdit();

/*
on execute do
(
)
*/