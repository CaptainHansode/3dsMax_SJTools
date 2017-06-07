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
                        SJRdPathEditDialog
                      );
try(cui.FloatDialogBar SJRdPathEdit.SJRdPathEditRol)catch();
try(cui.unRegisterDialogBar SJRdPathEdit.SJRdPathEditRol)catch();
try(closeRolloutFloater SJRdPathEdit.SJRdPathEditRol)catch();
try(destroydialog SJRdPathEdit.SJRdPathEditRol)catch();
try(destroydialog SJRdPathEdit.SJRdPathEditDialog)catch();

SJRdPathEdit = SJRendPathEdit();

--include "$scripts\SJTools\lib\progresBar.ms";

/**-----------------------------------------------------------------------------
 * 編集
 */
function getFolderPath defPath =
(
    f = getOpenFileName caption:"何かファイルを選択してください:" \
    filename:defPath
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

function setRendPath rendPath elmEdtList =
(
    rendOutputFilename = rendPath;
    re = maxOps.GetCurRenderElementMgr();
    for n = 0 to (re.numrenderelements () - 1) do
    (
        re.SetRenderElementFilename n elmEdtList[n + 1].text;
    )
    renderSceneDialog.update();
)

function delRendPath rendPath elmEdtList =
(
    rendPath.text = "";
    for e = 1 to elmEdtList.count do
    (
        elmEdtList[e].text = "";
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
    for e = 1 to elmEdtList.count do
    (
        elmEdtList[e].text = (replaceText elmEdtList[e].text findStr repStr);
    )
)


/**-----------------------------------------------------------------------------
 * 初期化
 */
function initialize rol =
(
    rol.rendPathEdt.text = rendOutputFilename;
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

    re = maxOps.GetCurRenderElementMgr();
    for n = 0 to (re.numrenderelements () - 1) do
    (
        rol.elmEdtList[n + 1].text = re.GetRenderElementFileName n;
        el = re.getrenderelement n;
        rol.elmLblList[n + 1].caption = el.elementname;
    )
)

/**-----------------------------------------------------------------------------
 * 設定を保存
 */
function saveIni = (
    --local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
    --(setINISetting iniPath "SJRenamer" "LastKeyWordNews" SJRenamerRol.newNameEdt.text);
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
    rollout SJRdPathEditRol "パスチカン" width:310 height:960;
    (
        local elmEdtList = #();
        local elmLblList = #();

        GroupBox 'grp1' "一括設定" pos:[8,8] width:296 height:84 align:#left
        button 'allSetBtn' "レンダリング出力パスを全てのエレメントに" pos:[16,28] width:276 height:24 align:#left
        button 'allDelBtn' "全て空欄" pos:[16,60] width:276 height:24 align:#left

        GroupBox 'grp2' "置換" pos:[8,100] width:296 height:148 align:#left
        edittext 'findEdt' "" pos:[12,140] width:280 height:20 align:#left
        label 'lbl1' "検索文字" pos:[16,122] width:168 height:16 align:#left
        edittext 'repEdt' "" pos:[12,184] width:280 height:20 align:#left
        label 'lbl2' "置換文字" pos:[16,166] width:168 height:16 align:#left
        button 'repBtn' "置換" pos:[16,212] width:276 height:24 align:#left

        GroupBox 'grp5' "適応" pos:[8,256] width:296 height:84 align:#left
        button 'updateBtn' "更新" pos:[20,276] width:272 height:24 align:#left
        button 'allOKBtn' "適応" pos:[20,308] width:272 height:24 align:#left

        GroupBox 'grp3' "レンダリング出力" pos:[8,348] width:296 height:52 align:#left
        edittext 'rendPathEdt' "" pos:[13,372] width:231 height:20 align:#left
        button 'rendPathBtn' "..." pos:[248,372] width:20 height:20 align:#left
        button 'rendOKBtn' "OK" pos:[272,372] width:20 height:20 align:#left

        GroupBox 'grp4' "Render Elements" pos:[8,404] width:296 height:592 align:#left
        edittext 'remElmEdt01' "" pos:[13,442] width:231 height:20 align:#left
        button 'rEPathBtn01' "..." pos:[248,442] width:20 height:20 align:#left
        button 'rEOKBtn01' "OK" pos:[272,442] width:20 height:20 align:#left
        label 'rnElmLbl01' "エレメント1" pos:[16,424] width:168 height:16 align:#left
        edittext 'remElmEdt02' "" pos:[12,486] width:231 height:20 align:#left
        button 'rEPathBtn02' "..." pos:[247,486] width:20 height:20 align:#left
        button 'rEOKBtn02' "OK" pos:[271,486] width:20 height:20 align:#left
        label 'rnElmLbl02' "エレメント2" pos:[15,468] width:168 height:16 align:#left
        edittext 'remElmEdt03' "" pos:[12,530] width:231 height:20 align:#left
        button 'rEPathBtn03' "..." pos:[247,530] width:20 height:20 align:#left
        button 'rEOKBtn03' "OK" pos:[271,530] width:20 height:20 align:#left
        label 'rnElmLbl03' "エレメント3" pos:[15,512] width:168 height:16 align:#left
        edittext 'remElmEdt04' "" pos:[12,574] width:231 height:20 align:#left
        button 'rEPathBtn04' "..." pos:[247,574] width:20 height:20 align:#left
        button 'rEOKBtn04' "OK" pos:[271,574] width:20 height:20 align:#left
        label 'rnElmLbl04' "エレメント4" pos:[15,556] width:168 height:16 align:#left
        checkbutton 'ckb1' "CheckButton" pos:[76,648] width:0 height:0 align:#left
        edittext 'remElmEdt05' "" pos:[13,618] width:231 height:20 align:#left
        button 'rEPathBtn05' "..." pos:[248,618] width:20 height:20 align:#left
        button 'rEOKBtn05' "OK" pos:[272,618] width:20 height:20 align:#left
        label 'rnElmLbl05' "エレメント5" pos:[16,600] width:168 height:16 align:#left
        edittext 'remElmEdt06' "" pos:[12,662] width:231 height:20 align:#left
        button 'rEPathBtn06' "..." pos:[247,662] width:20 height:20 align:#left
        button 'rEOKBtn06' "OK" pos:[271,662] width:20 height:20 align:#left
        label 'rnElmLbl06' "エレメント6" pos:[15,644] width:168 height:16 align:#left
        edittext 'remElmEdt07' "" pos:[12,706] width:231 height:20 align:#left
        button 'rEPathBtn07' "..." pos:[247,706] width:20 height:20 align:#left
        button 'rEOKBtn07' "OK" pos:[271,706] width:20 height:20 align:#left
        label 'rnElmLbl07' "エレメント7" pos:[15,688] width:168 height:16 align:#left
        edittext 'remElmEdt08' "" pos:[12,750] width:231 height:20 align:#left
        button 'rEPathBtn08' "..." pos:[247,750] width:20 height:20 align:#left
        button 'rEOKBtn08' "OK" pos:[271,750] width:20 height:20 align:#left
        label 'rnElmLbl08' "エレメント8" pos:[15,732] width:168 height:16 align:#left
        edittext 'remElmEdt09' "" pos:[13,794] width:231 height:20 align:#left
        button 'rEPathBtn09' "..." pos:[248,794] width:20 height:20 align:#left
        button 'rEOKBtn09' "OK" pos:[272,794] width:20 height:20 align:#left
        label 'rnElmLbl09' "エレメント9" pos:[16,776] width:168 height:16 align:#left
        edittext 'remElmEdt10' "" pos:[12,838] width:231 height:20 align:#left
        button 'rEPathBtn10' "..." pos:[247,838] width:20 height:20 align:#left
        button 'rEOKBtn10' "OK" pos:[271,838] width:20 height:20 align:#left
        label 'rnElmLbl10' "エレメント10" pos:[15,820] width:168 height:16 align:#left
        edittext 'remElmEdt11' "" pos:[12,882] width:231 height:20 align:#left
        button 'rEPathBtn11' "..." pos:[247,882] width:20 height:20 align:#left
        button 'rEOKBtn11' "OK" pos:[271,882] width:20 height:20 align:#left
        label 'rnElmLbl11' "エレメント11" pos:[15,864] width:168 height:16 align:#left
        edittext 'remElmEdt12' "" pos:[12,926] width:231 height:20 align:#left
        button 'rEPathBtn12' "..." pos:[247,926] width:20 height:20 align:#left
        button 'rEOKBtn12' "OK" pos:[271,926] width:20 height:20 align:#left
        label 'rnElmLbl12' "エレメント12" pos:[16,908] width:168 height:16 align:#left

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
            setRendPath rendPathEdt.text elmEdtList;
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

        on SJRdPathEditRol resized val do
        (
            /*
            width = 200;
            height = 676;
            if ((SJRenamerRol.width <= width) and (SJRenamerRol.height <= height)) then
            (
                return false;
            )
            textWidth = val[1] - 32;
            grpWidth = val[1] - 16;
            */
        )

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
--local iniPath = ((getDir #scripts) + "\SJTools\SJRenamer\SJRenamer.ini");
--local posX = execute(getINISetting iniPath "SJRenamer" "rolPosX");
--local posY = execute(getINISetting iniPath "SJRenamer" "rolPosY");
posX = 150;
posY = 150;
SJRdPathEdit.SJRdPathEditDialog = CreateDialog SJRdPathEdit.SJRdPathEditRol /*pos:[posX, posY]*/ menu:SJRdPathEditMenu style:#(#style_border, #style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;
/*
on execute do
(
)
*/