/*******************************************************
System J Tools 
********************************************************
Name:SJ_Poser
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_poser_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJOthers/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = "poser"
-----------------------------------------------------------------------------------------------------------
--Main
Local poseListName = #(), poseValue = #(), MasterNodes = undefined, allNodes = #(), customNodes = #(), custom_RNodes = #(), custom_LNodes = #()
Local defaultNameStr = "New Pose ", NumStr = "01";
--色々
Local temp, tempName, tempValue = #(), poseListCount = 0, poseValueCount = 0, pasteMiss = 0;
Local fileLockID = 6564646162;
Local mT = #(1,-1,-1,-1,1,1,-1,1,1,-1,1,1), mirrorMenu = #(true,false,false,false,false,false,false,false,false);
-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_poser_rol)catch()
try(cui.unRegisterDialogBar sj_poser_rol)catch()
try(closeRolloutFloater sj_poser_rol) catch()	
try(destroydialog sj_poser_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu poserMenuBar
(
subMenu "ファイル"
(
menuItem savePoseFileMi "保存" enabled:true
menuItem loadPoseFileMi "開く" enabled:true
menuItem mergePoseFileMi "合成" enabled:true
seperator sep01
menuItem closeMi "終了" enabled:true
)
subMenu "設定"
( 
menuItem mirrorYZplaneMi "YZ平面ミラー" checked:true
menuItem mirrorXZplaneMi "XZ平面ミラー" checked:false
menuItem mirrorXYplaneMi "XY平面ミラー" checked:false
/*
seperator sep02
menuItem mirrorXFripZMi "X軸ミラーフリップZ" enabled:false
menuItem mirrorYFripZMi "Y軸ミラーフリップZ" enabled:false
menuItem mirrorZFripZMi "Z軸ミラーフリップZ" enabled:false
seperator sep03
menuItem mirrorXFripYMi "X軸ミラーフリップY" enabled:false
menuItem mirrorYFripYMi "Y軸ミラーフリップY" enabled:false
menuItem mirrorZFripYMi "Z軸ミラーフリップY" enabled:false
*/
)
subMenu "ヘルプ"
( 
menuItem helpMi "ヘルプ"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
)

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
on closeMi  picked do
(
try(cui.unRegisterDialogBar sj_poser_rol)catch()
try(closeRolloutFloater sj_poser_rol) catch()	
try(destroydialog sj_poser_rol)catch()
)
on savePoseFileMi picked do sj_poser_rol.savePoseFile_Fn sj_poser_rol.poseCbx.items
on loadPoseFileMi picked do sj_poser_rol.loadPoseFile_Fn true
on mergePoseFileMi picked do sj_poser_rol.loadPoseFile_Fn false
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=1031" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
on mirrorYZplaneMi picked do (
mT = #(1,-1,-1,-1,1,1,-1,1,1,-1,1,1)
mirrorMenu = #(true,false,false,false,false,false,false,false,false))
on mirrorXZplaneMi picked do (
mT = #(-1,1,-1,1,-1,1,1,-1,1,1,-1,1)
mirrorMenu = #(false,true,false,false,false,false,false,false,false))
on mirrorXYplaneMi picked do (
mT = #(-1,-1,1,1,1,-1,1,1,-1,1,1,-1)
mirrorMenu = #(false,false,true,false,false,false,false,false,false))
on mirrorXFripZMi picked do (
mT = #(-1,1,1,-1,1,1,1,-1,-1,-1,1,1)
mirrorMenu = #(false,false,false,true,false,false,false,false,false))
on mirrorYFripZMi picked do (
mT = #(1,-1,1,1,-1,1,-1,1,-1,1,-1,1)
mirrorMenu = #(false,false,false,false,true,false,false,false,false))
on mirrorZFripZMi picked do (
mT = #(1,1,-1,1,1,-1,-1,-1,1,1,1,-1)
mirrorMenu = #(false,false,false,false,false,true,false,false,false))
on mirrorXFripYMi picked do (
mT = #(-1,1,1,1,-1,-1,-1,1,1,-1,1,1)
mirrorMenu = #(false,false,false,false,false,false,true,false,false))
on mirrorYFripYMi picked do (
mT = #(1,-1,1,-1,1,-1,1,-1,1,1,-1,1)
mirrorMenu = #(false,false,false,false,false,false,false,true,false))
on mirrorZFripYMi picked do (
mT = #(1,1,-1,-1,-1,1,1,1,-1,1,1,-1)
mirrorMenu = #(false,false,false,false,false,false,false,false,true))

--メニューを開くたびに実行されるアップデート
on poserMenuBar update do
(
poserMenuBar.mirrorYZplaneMi.checked = mirrorMenu[1]
poserMenuBar.mirrorXZplaneMi.checked = mirrorMenu[2]
poserMenuBar.mirrorXYplaneMi.checked = mirrorMenu[3]
/*
poserMenuBar.mirrorXFripZMi.checked = mirrorMenu[4]
poserMenuBar.mirrorYFripZMi.checked = mirrorMenu[5]
poserMenuBar.mirrorZFripZMi.checked = mirrorMenu[6]
poserMenuBar.mirrorXFripYMi.checked = mirrorMenu[7]
poserMenuBar.mirrorYFripYMi.checked = mirrorMenu[8]
poserMenuBar.mirrorZFripYMi.checked = mirrorMenu[9]
*/
)
)--rcMenu end

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_poser_rol nameAndVersion width:144 height:320
(

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--clear
--////////////////////////////////////////////////
fn clearList_Fn = 
(
	sj_poser_rol.poseCbx.items = #()
	poseListName = #()
	poseValue = #()
	sj_poser_rol.poseEdt.text = ""
)
--////////////////////////////////////////////////
--アップダウン
--////////////////////////////////////////////////
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
--////////////////////////////////////////////////
--Del
--////////////////////////////////////////////////
fn delPoseList_Fn list i = 
(
	deleteItem list i
	deleteItem poseValue i
)
--////////////////////////////////////////////////
--Rename使ってない
--////////////////////////////////////////////////
fn renamePoseList_Fn str =
(
	temp = #()
	tempName = str
	append temp tempName
	--sj_poser_rol.poseCbx.item = temp
	temp = #()
)--fn end
--////////////////////////////////////////////////
--save default
--////////////////////////////////////////////////
fn saveDefault_Fn list = 
(
--なんとなく暗号化
poserDefalutFile = createFile "$Scripts/SJTools//PoserDefalut.tmp"
format "%\n" list.count to:poserDefalutFile
for i=1 to list.count do
(
	format "%\n" list[i] to:poserDefalutFile
	
		----------------------
		--save Transform value
		format "%\n" poseValue[i].count to:poserDefalutFile
		for u in poseValue[i] do
		(
			format "%\n" u 	to:poserDefalutFile
		)--for end
		----------------------
		--save CustomNode Transform
		
)--for end
close poserDefalutFile

encryptFile "$Scripts/SJTools//PoserDefalut.tmp" "$Scripts/SJTools//PoserDefalut.dat" fileLockID
--deleteFile "$Scripts/SJTools//PoserDefalut.tmp"
)--fn end

--////////////////////////////////////////////////
--load default
--////////////////////////////////////////////////
fn loadDefault_Fn = 
(
poseListCount = 0
poseValueCount = 0

--なんとなく暗号化
poserDefalutFile = openEncryptedFile "$Scripts/SJTools//PoserDefalut.dat" fileLockID
poseListCount = readValue poserDefalutFile
for i=1 to poseListCount do
(
	tempValue = #()
	----------------------
	--load list name
	temp = #()
	tempName = readLine poserDefalutFile
	append temp tempName
	sj_poser_rol.poseCbx.items += temp
	tempName = undefined
		----------------------
		--load transform
		poseValueCount = readValue poserDefalutFile
		for u=1 to poseValueCount do
		(
			append tempValue (readValue poserDefalutFile)
		)--for end
			append poseValue tempValue
)--for end

close poserDefalutFile
temp = #()
)--fn end

--////////////////////////////////////////////////
--
--
--
--ここから通常側
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--通常の保存
--////////////////////////////////////////////////
fn savePoseFile_Fn list = 
(
--なんとなく暗号化
local saveName = getSaveFileName caption:"ポーズを保存" filename:"PoseList.pf" types:"Poser File (*.pf)|*.pf|All(*.*)|*.*"

if saveName != undefined do
(

poserDefalutFile = createFile "$Scripts/SJTools//PoserDefalut.tmp"
format "%\n" list.count to:poserDefalutFile
for i=1 to list.count do
(
	format "%\n" list[i] to:poserDefalutFile

		----------------------
		--save Transform value
		format "%\n" poseValue[i].count	to:poserDefalutFile
		for u in poseValue[i] do
		(
			format "%\n" u 	to:poserDefalutFile
		)--for end
		
)--for end
close poserDefalutFile

encryptFile "$Scripts/SJTools//PoserDefalut.tmp" saveName fileLockID
--deleteFile "$Scripts/SJTools//PoserDefalut.tmp"

)--if end
)--fn end

--////////////////////////////////////////////////
--通常の読み込み
--////////////////////////////////////////////////
fn loadPoseFile_Fn isClear = 
(
poseListCount = 0
poseValueCount = 0

local loadName = getOpenFileName caption:"ポーズを読み込み" types:"Poser File (*.pf)|*.pf|All(*.*)|*.*"

if loadName != undefined do
(

if isClear then clearList_Fn()

--なんとなく暗号化
poserDefalutFile = openEncryptedFile loadName fileLockID
poseListCount = readValue poserDefalutFile
for i=1 to poseListCount do
(
	tempValue = #()	
	----------------------
	--load list name
	temp = #()
	tempName = readLine poserDefalutFile
	append temp tempName
	sj_poser_rol.poseCbx.items += temp
	tempName = undefined
		----------------------
		--load transform
		poseValueCount = readValue poserDefalutFile

		for u=1 to poseValueCount do
		(
			append tempValue (readValue poserDefalutFile)
		)--for end
			append poseValue tempValue
			print poseVaue
)--for end

close poserDefalutFile

)--if end
temp = #()
)--fn end
--////////////////////////////////////////////////
--Is it Masterset?
--////////////////////////////////////////////////
fn checkNodes_Fn =
(
	----------------------
	--階層のトップから選択
	try(
	obj = selection[1].parent
	while obj.parent != undefined do
	(
		obj = obj.parent
	)--while end
	)catch(
		messageBox "コントローラーではありません" title:"エラー"
		return false
	)
	
	--is it?
	if isvalidnode obj.children[12].MasterNodes[1].node then
	(
		if obj.parent == undefined then MasterNodes = obj.children[12]
		return true
	)
	else
	(
		return false
	)
)
--////////////////////////////////////////////////
--アップデート
--////////////////////////////////////////////////
fn updateList_Fn =
(
	sj_poser_rol.poseCbx.items = #()
	loadDefault_Fn()
	try(sj_poser_rol.poseEdt.text = sj_poser_rol.PoseCbx.selected)catch()
)--fn end

--////////////////////////////////////////////////
--Collect 通常のコントローラー
--////////////////////////////////////////////////
fn collectAllNodes_Fn =
(
	checkNodes_Fn()
	allNodes = #()
	customNodes = #();
	custom_RNodes = #();
	custom_LNodes = #();
	
	----------------------
	--allNodeに登録
	--全登録数は固定回数	
	--for i in MasterNodes.ControlNodes do append allNodes i.node
	append allNodes MasterNodes.SpineSubControlNodes[2].node--2--allRoot--1
	----------------------
	--spine
	append allNodes MasterNodes.ControlNodes[1].node--1--2
	append allNodes MasterNodes.ControlNodes[2].node--2--3
	----------------------
	--順を入れ替える事で、ズレを防ぐ
	for i=3 to 7 do append allNodes MasterNodes.SpineSubControlNodes[i].node
	append allNodes MasterNodes.ControlNodes[3].node--3--4


	----------------------
	--neck
	append allNodes MasterNodes.ControlNodes[4].node--4--5
	----------------------
	--順を入れ替える事で、ズレを防ぐ
	--ヘッドコントローラーが一度の貼り付けでずれるのは構造のせい
	--ひとまず2回貼り付けてごまかす
	for i=1 to 4 do append allNodes MasterNodes.NecSubControlNodes[i].node
	append allNodes MasterNodes.ControlNodes[5].node--5--6
	append allNodes MasterNodes.ControlNodes[5].node--5--7


	----------------------
	--arm
	append allNodes MasterNodes.ControlNodes[6].node--6--8
	append allNodes MasterNodes.ControlNodes[7].node--7--9
	append allNodes MasterNodes.ControlNodes[8].node--8--10
	append allNodes MasterNodes.ControlNodes[9].node--9--11
	----------------------
	--順を入れ替える事で、ズレを防ぐ
	for i=1 to 8 do append allNodes MasterNodes.ArmSubControlNodes[i].node
	append allNodes MasterNodes.ControlNodes[10].node--10--12
	append allNodes MasterNodes.ControlNodes[11].node--11--13

	
	----------------------
	--leg
	append allNodes MasterNodes.ControlNodes[12].node--12--14
	append allNodes MasterNodes.ControlNodes[13].node--13--15
	append allNodes MasterNodes.ControlNodes[14].node--14--16
	append allNodes MasterNodes.ControlNodes[15].node--15--17
	for i=1 to 12 do append allNodes MasterNodes.LegSubControlNodes[i].node
	
	----------------------
	--hand 47 48
	--指はトランスフォームではない
	append allNodes MasterNodes.ControlNodes[16].node
	append allNodes MasterNodes.ControlNodes[17].node
	
	----------------------
	--Custom
	for i in MasterNodes.AllCustomNodes[1].node.Custom01ControlNodes do append customNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom02ControlNodes do append customNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom03ControlNodes do append customNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom04ControlNodes do append customNodes i.node
	
	for i in MasterNodes.AllCustomNodes[1].node.Custom01_RControlNodes do append custom_RNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom02_RControlNodes do append custom_RNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom03_RControlNodes do append custom_RNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom04_RControlNodes do append custom_RNodes i.node
	
	for i in MasterNodes.AllCustomNodes[1].node.Custom01_LControlNodes do append custom_LNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom02_LControlNodes do append custom_LNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom03_LControlNodes do append custom_LNodes i.node
	for i in MasterNodes.AllCustomNodes[1].node.Custom04_LControlNodes do append custom_LNodes i.node
)--fn end

--////////////////////////////////////////////////
--add pose
--////////////////////////////////////////////////
fn addPose_Fn =
(
if checkNodes_Fn() then
(
	temp = #()
	tempValue = #();
	customNodes = #();
	custom_RNodes = #();
	custom_LNodes = #();

	collectallNodes_Fn()
	
	--////////////////////////////////////////////////
	--リストの名前の処理
	--////////////////////////////////////////////////
	NumStr = (poseValue.count as String);
	if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
	tempName = defaultNameStr + NumStr;
	append temp tempName
	sj_poser_rol.poseCbx.items += temp
	tempName = undefined
	temp = #()
	tempValue = #()
	
	----------------------
	--add transform value
	for i=1 to 46 do append tempValue allNodes[i].transform

	----------------------
	--finger params全52パラメーター
	--R
	append tempValue allNodes[47].modifiers[#Control].FingerThumbSet.thumb01
	append tempValue allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Splay
	append tempValue allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Twist
	append tempValue allNodes[47].modifiers[#Control].FingerThumbSet.thumb02
	append tempValue allNodes[47].modifiers[#Control].FingerThumbSet.thumb03
	append tempValue allNodes[47].modifiers[#Control].FingerIndexSet.index01
	append tempValue allNodes[47].modifiers[#Control].FingerIndexSet.index01Splay
	append tempValue allNodes[47].modifiers[#Control].FingerIndexSet.index00
	append tempValue allNodes[47].modifiers[#Control].FingerIndexSet.index02
	append tempValue allNodes[47].modifiers[#Control].FingerIndexSet.index03
	append tempValue allNodes[47].modifiers[#Control].FingerMiddleSet.middle01
	append tempValue allNodes[47].modifiers[#Control].FingerMiddleSet.middle01Splay
	append tempValue allNodes[47].modifiers[#Control].FingerMiddleSet.middle00
	append tempValue allNodes[47].modifiers[#Control].FingerMiddleSet.middle02
	append tempValue allNodes[47].modifiers[#Control].FingerMiddleSet.middle03
	append tempValue allNodes[47].modifiers[#Control].FingerRingSet.ring01
	append tempValue allNodes[47].modifiers[#Control].FingerRingSet.ring01Splay
	append tempValue allNodes[47].modifiers[#Control].FingerRingSet.ring00
	append tempValue allNodes[47].modifiers[#Control].FingerRingSet.ring02
	append tempValue allNodes[47].modifiers[#Control].FingerRingSet.ring03
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little01
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little01Splay
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little00
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little00Splay
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little02
	append tempValue allNodes[47].modifiers[#Control].FingerLittleSet.little03
	--L
	append tempValue allNodes[48].modifiers[#Control].FingerThumbSet.thumb01
	append tempValue allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Splay
	append tempValue allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Twist
	append tempValue allNodes[48].modifiers[#Control].FingerThumbSet.thumb02
	append tempValue allNodes[48].modifiers[#Control].FingerThumbSet.thumb03
	append tempValue allNodes[48].modifiers[#Control].FingerIndexSet.index01
	append tempValue allNodes[48].modifiers[#Control].FingerIndexSet.index01Splay
	append tempValue allNodes[48].modifiers[#Control].FingerIndexSet.index00
	append tempValue allNodes[48].modifiers[#Control].FingerIndexSet.index02
	append tempValue allNodes[48].modifiers[#Control].FingerIndexSet.index03
	append tempValue allNodes[48].modifiers[#Control].FingerMiddleSet.middle01
	append tempValue allNodes[48].modifiers[#Control].FingerMiddleSet.middle01Splay
	append tempValue allNodes[48].modifiers[#Control].FingerMiddleSet.middle00
	append tempValue allNodes[48].modifiers[#Control].FingerMiddleSet.middle02
	append tempValue allNodes[48].modifiers[#Control].FingerMiddleSet.middle03
	append tempValue allNodes[48].modifiers[#Control].FingerRingSet.ring01
	append tempValue allNodes[48].modifiers[#Control].FingerRingSet.ring01Splay
	append tempValue allNodes[48].modifiers[#Control].FingerRingSet.ring00
	append tempValue allNodes[48].modifiers[#Control].FingerRingSet.ring02
	append tempValue allNodes[48].modifiers[#Control].FingerRingSet.ring03
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little01
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little01Splay
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little00
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little00Splay
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little02
	append tempValue allNodes[48].modifiers[#Control].FingerLittleSet.little03
	
	----------------------
	--ここまでで98

	----------------------
	--Custom
	for i in customNodes do append tempValue i.transform
	for i in custom_RNodes do append tempValue i.transform
	for i in custom_LNodes do append tempValue i.transform
	
	----------------------
	--add value
	append poseValue tempValue

)--if end
)--fn end
--////////////////////////////////////////////////
--pose paste
--////////////////////////////////////////////////
fn pastePose_Fn i isCustom isAllRoot = 
(
if checkNodes_Fn() then
(
	if i != 0 then
	(
		collectallNodes_Fn()
		----------------------
		--is it all root transform
		if isAllRoot then allNodes[1].transform = poseValue[i][1]
		
		----------------------
		--nomal control transform
		for u=2 to 46 do
		(
			allNodes[u].transform = poseValue[i][u]
		)--for end
		
		----------------------
		--Finger
		--R
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01 = poseValue[i][47]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Splay = poseValue[i][48]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Twist = poseValue[i][49]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb02 = poseValue[i][50]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb03 = poseValue[i][51]
		allNodes[47].modifiers[#Control].FingerIndexSet.index01 = poseValue[i][52]
		allNodes[47].modifiers[#Control].FingerIndexSet.index01Splay = poseValue[i][53]
		allNodes[47].modifiers[#Control].FingerIndexSet.index00 = poseValue[i][54]
		allNodes[47].modifiers[#Control].FingerIndexSet.index02 = poseValue[i][55]
		allNodes[47].modifiers[#Control].FingerIndexSet.index03 = poseValue[i][56]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle01 = poseValue[i][57]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle01Splay = poseValue[i][58]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle00 = poseValue[i][59]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle02 = poseValue[i][60]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle03 = poseValue[i][61]
		allNodes[47].modifiers[#Control].FingerRingSet.ring01 = poseValue[i][62]
		allNodes[47].modifiers[#Control].FingerRingSet.ring01Splay = poseValue[i][63]
		allNodes[47].modifiers[#Control].FingerRingSet.ring00 = poseValue[i][64]
		allNodes[47].modifiers[#Control].FingerRingSet.ring02 = poseValue[i][65]
		allNodes[47].modifiers[#Control].FingerRingSet.ring03 = poseValue[i][66]
		allNodes[47].modifiers[#Control].FingerLittleSet.little01 = poseValue[i][67]
		allNodes[47].modifiers[#Control].FingerLittleSet.little01Splay = poseValue[i][68]
		allNodes[47].modifiers[#Control].FingerLittleSet.little00 = poseValue[i][69]
		allNodes[47].modifiers[#Control].FingerLittleSet.little00Splay = poseValue[i][70]
		allNodes[47].modifiers[#Control].FingerLittleSet.little02 = poseValue[i][71]
		allNodes[47].modifiers[#Control].FingerLittleSet.little03 = poseValue[i][72]
		--L
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01 = poseValue[i][73]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Splay = poseValue[i][74]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Twist = poseValue[i][75]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb02 = poseValue[i][76]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb03 = poseValue[i][77]
		allNodes[48].modifiers[#Control].FingerIndexSet.index01 = poseValue[i][78]
		allNodes[48].modifiers[#Control].FingerIndexSet.index01Splay = poseValue[i][79]
		allNodes[48].modifiers[#Control].FingerIndexSet.index00 = poseValue[i][80]
		allNodes[48].modifiers[#Control].FingerIndexSet.index02 = poseValue[i][81]
		allNodes[48].modifiers[#Control].FingerIndexSet.index03 = poseValue[i][82]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle01 = poseValue[i][83]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle01Splay = poseValue[i][84]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle00 = poseValue[i][85]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle02 = poseValue[i][86]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle03 = poseValue[i][87]
		allNodes[48].modifiers[#Control].FingerRingSet.ring01 = poseValue[i][88]
		allNodes[48].modifiers[#Control].FingerRingSet.ring01Splay = poseValue[i][89]
		allNodes[48].modifiers[#Control].FingerRingSet.ring00 = poseValue[i][90]
		allNodes[48].modifiers[#Control].FingerRingSet.ring02 = poseValue[i][91]
		allNodes[48].modifiers[#Control].FingerRingSet.ring03 = poseValue[i][92]
		allNodes[48].modifiers[#Control].FingerLittleSet.little01 = poseValue[i][93]
		allNodes[48].modifiers[#Control].FingerLittleSet.little01Splay = poseValue[i][94]
		allNodes[48].modifiers[#Control].FingerLittleSet.little00 = poseValue[i][95]
		allNodes[48].modifiers[#Control].FingerLittleSet.little00Splay = poseValue[i][96]
		allNodes[48].modifiers[#Control].FingerLittleSet.little02 = poseValue[i][97]
		allNodes[48].modifiers[#Control].FingerLittleSet.little03 = poseValue[i][98]
		
		if isCustom then
		(
			Local k = 99;
			for u in customNodes do
			(
				if poseValue[i][k] != undefined then
				(
					u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););
				k += 1;
			)-- for end
			for u in custom_RNodes do
			(
				if poseValue[i][k] != undefined then
				(
					u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););
				k += 1;
			)-- for end
			for u in custom_LNodes do
			(
				if poseValue[i][k] != undefined then
				(
					u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););				
				k += 1;
			)-- for end
		)--if end	
		
	)--if end
)--if end
)--fn end

--////////////////////////////////////////////////
--pose mirror paste
--////////////////////////////////////////////////
fn pasteMirrorPose_Fn i isCustom isAllRoot =
(
if checkNodes_Fn() then
(
	if i != 0 then
	(
		collectallNodes_Fn()
		----------------------
		--is it all root transform
		if isAllRoot then
		(
			allNodes[1].transform =
			(
			matrix3 \
			[(mT[1] * poseValue[i][1][1][1]),(mT[2] * poseValue[i][1][1][2]),(mT[3] * poseValue[i][1][1][3])]\
			[(mT[4] * poseValue[i][1][2][1]),(mT[5] * poseValue[i][1][2][2]),(mT[6] * poseValue[i][1][2][3])]\
			[(mT[7] * poseValue[i][1][3][1]),(mT[8] * poseValue[i][1][3][2]),(mT[9] * poseValue[i][1][3][3])]\
			[(mT[10] * poseValue[i][1][4][1]),(mT[11] * poseValue[i][1][4][2]),(mT[12] * poseValue[i][1][4][3])]
			)
		)
		
		----------------------
		--nomal control transform
		for u=2 to 16 do
		(
			allNodes[u].transform =
			(
			matrix3 \
			[(mT[1] * poseValue[i][u][1][1]),(mT[2] * poseValue[i][u][1][2]),(mT[3] * poseValue[i][u][1][3])]\
			[(mT[4] * poseValue[i][u][2][1]),(mT[5] * poseValue[i][u][2][2]),(mT[6] * poseValue[i][u][2][3])]\
			[(mT[7] * poseValue[i][u][3][1]),(mT[8] * poseValue[i][u][3][2]),(mT[9] * poseValue[i][u][3][3])]\
			[(mT[10] * poseValue[i][u][4][1]),(mT[11] * poseValue[i][u][4][2]),(mT[12] * poseValue[i][u][4][3])]
			)
		)--for end
		----------------------
		--nomal control transform
		u = 18;
		while u < 46 do
		--for u=18 to 46 do
		(
			allNodes[u-1].transform =
			(
			matrix3 \
			[(mT[1] * poseValue[i][u][1][1]),(mT[2] * poseValue[i][u][1][2]),(mT[3] * poseValue[i][u][1][3])]\
			[(mT[4] * poseValue[i][u][2][1]),(mT[5] * poseValue[i][u][2][2]),(mT[6] * poseValue[i][u][2][3])]\
			[(mT[7] * poseValue[i][u][3][1]),(mT[8] * poseValue[i][u][3][2]),(mT[9] * poseValue[i][u][3][3])]\
			[(mT[10] * poseValue[i][u][4][1]),(mT[11] * poseValue[i][u][4][2]),(mT[12] * poseValue[i][u][4][3])]
			)
			u += 2;
		)--for end
		----------------------
		--nomal control transform
		u = 17;
		while u < 45 do
		(
			allNodes[u+1].transform =
			(
			matrix3 \
			[(mT[1] * poseValue[i][u][1][1]),(mT[2] * poseValue[i][u][1][2]),(mT[3] * poseValue[i][u][1][3])]\
			[(mT[4] * poseValue[i][u][2][1]),(mT[5] * poseValue[i][u][2][2]),(mT[6] * poseValue[i][u][2][3])]\
			[(mT[7] * poseValue[i][u][3][1]),(mT[8] * poseValue[i][u][3][2]),(mT[9] * poseValue[i][u][3][3])]\
			[(mT[10] * poseValue[i][u][4][1]),(mT[11] * poseValue[i][u][4][2]),(mT[12] * poseValue[i][u][4][3])]
			)
			u += 2;
		)--for end
		----------------------
		--Finger左右逆なのでLRを入れ替え
		--R
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01 = poseValue[i][47]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Splay = poseValue[i][48]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb01Twist = poseValue[i][49]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb02 = poseValue[i][50]
		allNodes[48].modifiers[#Control].FingerThumbSet.thumb03 = poseValue[i][51]
		allNodes[48].modifiers[#Control].FingerIndexSet.index01 = poseValue[i][52]
		allNodes[48].modifiers[#Control].FingerIndexSet.index01Splay = poseValue[i][53]
		allNodes[48].modifiers[#Control].FingerIndexSet.index00 = poseValue[i][54]
		allNodes[48].modifiers[#Control].FingerIndexSet.index02 = poseValue[i][55]
		allNodes[48].modifiers[#Control].FingerIndexSet.index03 = poseValue[i][56]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle01 = poseValue[i][57]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle01Splay = poseValue[i][58]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle00 = poseValue[i][59]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle02 = poseValue[i][60]
		allNodes[48].modifiers[#Control].FingerMiddleSet.middle03 = poseValue[i][61]
		allNodes[48].modifiers[#Control].FingerRingSet.ring01 = poseValue[i][62]
		allNodes[48].modifiers[#Control].FingerRingSet.ring01Splay = poseValue[i][63]
		allNodes[48].modifiers[#Control].FingerRingSet.ring00 = poseValue[i][64]
		allNodes[48].modifiers[#Control].FingerRingSet.ring02 = poseValue[i][65]
		allNodes[48].modifiers[#Control].FingerRingSet.ring03 = poseValue[i][66]
		allNodes[48].modifiers[#Control].FingerLittleSet.little01 = poseValue[i][67]
		allNodes[48].modifiers[#Control].FingerLittleSet.little01Splay = poseValue[i][68]
		allNodes[48].modifiers[#Control].FingerLittleSet.little00 = poseValue[i][69]
		allNodes[48].modifiers[#Control].FingerLittleSet.little00Splay = poseValue[i][70]
		allNodes[48].modifiers[#Control].FingerLittleSet.little02 = poseValue[i][71]
		allNodes[48].modifiers[#Control].FingerLittleSet.little03 = poseValue[i][72]
		--L
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01 = poseValue[i][73]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Splay = poseValue[i][74]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb01Twist = poseValue[i][75]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb02 = poseValue[i][76]
		allNodes[47].modifiers[#Control].FingerThumbSet.thumb03 = poseValue[i][77]
		allNodes[47].modifiers[#Control].FingerIndexSet.index01 = poseValue[i][78]
		allNodes[47].modifiers[#Control].FingerIndexSet.index01Splay = poseValue[i][79]
		allNodes[47].modifiers[#Control].FingerIndexSet.index00 = poseValue[i][80]
		allNodes[47].modifiers[#Control].FingerIndexSet.index02 = poseValue[i][81]
		allNodes[47].modifiers[#Control].FingerIndexSet.index03 = poseValue[i][82]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle01 = poseValue[i][83]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle01Splay = poseValue[i][84]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle00 = poseValue[i][85]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle02 = poseValue[i][86]
		allNodes[47].modifiers[#Control].FingerMiddleSet.middle03 = poseValue[i][87]
		allNodes[47].modifiers[#Control].FingerRingSet.ring01 = poseValue[i][88]
		allNodes[47].modifiers[#Control].FingerRingSet.ring01Splay = poseValue[i][89]
		allNodes[47].modifiers[#Control].FingerRingSet.ring00 = poseValue[i][90]
		allNodes[47].modifiers[#Control].FingerRingSet.ring02 = poseValue[i][91]
		allNodes[47].modifiers[#Control].FingerRingSet.ring03 = poseValue[i][92]
		allNodes[47].modifiers[#Control].FingerLittleSet.little01 = poseValue[i][93]
		allNodes[47].modifiers[#Control].FingerLittleSet.little01Splay = poseValue[i][94]
		allNodes[47].modifiers[#Control].FingerLittleSet.little00 = poseValue[i][95]
		allNodes[47].modifiers[#Control].FingerLittleSet.little00Splay = poseValue[i][96]
		allNodes[47].modifiers[#Control].FingerLittleSet.little02 = poseValue[i][97]
		allNodes[47].modifiers[#Control].FingerLittleSet.little03 = poseValue[i][98]
		
		if isCustom then
		(
			Local k = 99;
			for u in customNodes do
			(
				if poseValue[i][k] != undefined then
				(
					u.transform =
					(
					matrix3 \
					[(mT[1] * poseValue[i][k][1][1]),(mT[2] * poseValue[i][k][1][2]),(mT[3] * poseValue[i][k][1][3])]\
					[(mT[4] * poseValue[i][k][2][1]),(mT[5] * poseValue[i][k][2][2]),(mT[6] * poseValue[i][k][2][3])]\
					[(mT[7] * poseValue[i][k][3][1]),(mT[8] * poseValue[i][k][3][2]),(mT[9] * poseValue[i][k][3][3])]\
					[(mT[10] * poseValue[i][k][4][1]),(mT[11] * poseValue[i][k][4][2]),(mT[12] * poseValue[i][k][4][3])]
					)
					--u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););
				k += 1;
			)-- for end
			for u=1 to custom_RNodes.count do
			(
				if poseValue[i][k] != undefined then
				(
					custom_LNodes[u].transform =
					(
					matrix3 \
					[(mT[1] * poseValue[i][k][1][1]),(mT[2] * poseValue[i][k][1][2]),(mT[3] * poseValue[i][k][1][3])]\
					[(mT[4] * poseValue[i][k][2][1]),(mT[5] * poseValue[i][k][2][2]),(mT[6] * poseValue[i][k][2][3])]\
					[(mT[7] * poseValue[i][k][3][1]),(mT[8] * poseValue[i][k][3][2]),(mT[9] * poseValue[i][k][3][3])]\
					[(mT[10] * poseValue[i][k][4][1]),(mT[11] * poseValue[i][k][4][2]),(mT[12] * poseValue[i][k][4][3])]
					)
					--u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););
				k += 1;
			)-- for end
			for u=1 to custom_LNodes.count do
			(
				if poseValue[i][k] != undefined then
				(
					custom_RNodes[u].transform =
					(
					matrix3 \
					[(mT[1] * poseValue[i][k][1][1]),(mT[2] * poseValue[i][k][1][2]),(mT[3] * poseValue[i][k][1][3])]\
					[(mT[4] * poseValue[i][k][2][1]),(mT[5] * poseValue[i][k][2][2]),(mT[6] * poseValue[i][k][2][3])]\
					[(mT[7] * poseValue[i][k][3][1]),(mT[8] * poseValue[i][k][3][2]),(mT[9] * poseValue[i][k][3][3])]\
					[(mT[10] * poseValue[i][k][4][1]),(mT[11] * poseValue[i][k][4][2]),(mT[12] * poseValue[i][k][4][3])]
					)
					--u.transform = poseValue[i][k];
				)else(messageBox("以下のコントローラーの貼り付けに失敗しました\n"+u.name););
				k += 1;
			)-- for end
		)--if end	
		
	)--if end
)--if end
)--fn end

	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
	groupBox poseGrp "Pose" pos:[4,4] width:136 height:312
	editText poseEdt "" pos:[8,108] width:123 height:16
	listBox poseCbx "" pos:[12,126] width:119 height:13 items:#() selection:1
	button poseBt "" pos:[12,20] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_pose.png", "$Scripts/SJTools/Images//SJ_button_pose_a.png", 2, 1, 1, 2, 2)
	button pasteBt "" pos:[36,20] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_pose_paste.png", "$Scripts/SJTools/Images//SJ_button_pose_paste_a.png", 2, 1, 1, 2, 2)
	button pasteMirrorBt "" pos:[60,20] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_pose_paste_mirror.png", "$Scripts/SJTools/Images//SJ_button_pose_paste_mirror_a.png", 2, 1, 1, 2, 2)
	button pasteSymBt "" pos:[84,20] width:20 height:20 enabled:false images:#("$Scripts/SJTools/Images//SJ_button_pose_paste_sym.png", "$Scripts/SJTools/Images//SJ_button_pose_paste_sym_a.png", 2, 1, 1, 2, 2)

	button upBt "" pos:[12,84] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_up.png", "$Scripts/SJTools/Images//SJ_button_up_a.png", 2, 1, 1, 2, 2)
	button downBt "" pos:[36,84] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_down.png", "$Scripts/SJTools/Images//SJ_button_down_a.png", 2, 1, 1, 2, 2)
	button deleteBt "" pos:[60,84] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2)
	button clearBt "" pos:[84,84] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2)
	--button sortBt "" pos:[108,84] width:20 height:20 enabled:false images:#("$Scripts/SJTools/Images//SJ_button_sort.png", "$Scripts/SJTools/Images//SJ_button_sort_a.png", 2, 1, 1, 2, 2)


	checkbox customChk "カスタム含む" pos:[12,44] width:84 height:20
	checkbox allRootChk "AllRoot含む" pos:[12,64] width:84 height:20

	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[134,310] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

-----------------------------------------------------------------------------------------------------------
-- アクション
-----------------------------------------------------------------------------------------------------------
	--////////////////////////////////////////////////
	--リスト編集
	--////////////////////////////////////////////////
	on poseCbx selected sel do poseEdt.text = poseCbx.selected
	on poseEdt entered str do if (str != "" and poseCbx.items.count != 0) then poseCbx.selected = str
	on poseEdt changed str do
	(
	if (str != "" and poseCbx.items.count != 0) then
	(
		poseCbx.selected = str	
		poseCbx.items = poseCbx.items
		poseCbx.selection = poseCbx.selection
		poseEdt.text = str
	);--if end
	);--end
	--on poseCbx entered str do if str != "" then sj_poser_rol.poseCbx.selected = str

	on deleteBt pressed do
	(
		if sj_poser_rol.poseCbx.selection != 0 then
		(
		delPoseList_Fn sj_poser_rol.poseCbx.items sj_poser_rol.poseCbx.selection
		sj_poser_rol.poseCbx.items = sj_poser_rol.poseCbx.items
		)--if end
	)
	on clearBt pressed do clearList_Fn()
	on upBt pressed do
	(
	if poseCbx.selection != 0 and poseCbx.selection != 1 do
	(
	selUp_Fn sj_poser_rol.poseCbx.items sj_poser_rol.poseCbx.selection;
	selUp_Fn poseValue sj_poser_rol.poseCbx.selection
		poseCbx.items = poseCbx.items --表示更新
		poseCbx.selection -= 1 --選択更新用
		poseCbx.selection = poseCbx.selection --選択更新
	);--if end
	);
	on downBt pressed do
	(
	if poseCbx.selection != 0 and  poseCbx.items.count > poseCbx.selection do
	(
	selDown_Fn sj_poser_rol.poseCbx.items sj_poser_rol.poseCbx.selection;
	selDown_Fn poseValue sj_poser_rol.poseCbx.selection;
		poseCbx.items = poseCbx.items --表示更新
		poseCbx.selection += 1 --選択更新用
		poseCbx.selection = poseCbx.selection --選択更新
	);--if end
	);

	--////////////////////////////////////////////////
	--ポーズ追加
	--////////////////////////////////////////////////
	on poseBt pressed do
	(
		if selection.count !=0 then
		(
		addPose_Fn()
		saveDefault_Fn sj_poser_rol.poseCbx.items
		)--if end
	)--on end
	on pasteBt pressed do
	(
	--suspendEditing()--サスペンドモード
	with redraw off (--再描画禁止
	undo on (
		if selection.count !=0 then
		(
		pastePose_Fn sj_poser_rol.poseCbx.selection customChk.checked allRootChk.checked
		)--if end
	);--undo end
	);--with redraw end	
	--resumeEditing()--再びアクティブに
	)--end
	on pasteMirrorBt pressed do
	(
	with redraw off (--再描画禁止
	undo on (
		if selection.count !=0 then
		(
		pasteMirrorPose_Fn sj_poser_rol.poseCbx.selection customChk.checked allRootChk.checked
		)--if end
	);--undo end
	);--with redraw end
	)--end
	
	
	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_poser_rol resized val do
	(
		--元の大きさ
		width = 144;
		height = 320;
		
		--valがリサイズ時の大きさ
		--1が幅
		--print val;
		listWidth = 120;
		listHeight = 98;

		
		if ((sj_poser_rol.width >= 144) and (sj_poser_rol.height >= 320)) do
		(
			ratioW = (val[1] as float) / (width as float);
			ratioH = (val[2] as float) / (height as float);
			
			poseEdt.width = poseCbx.width =  poseGrp.width = val[1] - 26;
			poseGrp.width = poseGrp.width + 18;
			
			poseCbx.height = val[2] - 145;
			poseGrp.height = val[2] - 8;
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
			
		);--if end

		
	)--end
	
	on sj_poser_rol open do updateList_Fn()

	on sj_poser_rol close do
	(
	saveDefault_Fn sj_poser_rol.poseCbx.items;
	--gc();
	);
	
)--rollout end
createDialog sj_poser_rol menu:poserMenuBar /*bgColor:[0,0,0]*/ style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu
--try(cui.RegisterDialogBar sj_poser_rol /*maxsize:[232,640]*/)catch()	--ドッキング可能にします

)--end macroscript