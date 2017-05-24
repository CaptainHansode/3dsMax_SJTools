/*******************************************************
System J Tools 
********************************************************
Name:SJ_Adjuster
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_adjuster_rol
global sj_body_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJAdjusterToolName");
-----------------------------------------------------------------------------------------------------------
--ボーンテスト用の変数
--local testBones = #($B_in_Spine02, $B_in_Spine01)
--local testBoneSplinePos = #($SpineSplinePos02, $SpineSplinePos03, $SpineSplinePos01)

--テンポラリー,ツール内で使用する全比率用、ツールモード用など
Local temp, tempNodes, RatioTemp, tempPosA, tempPosB, tempPosC, tempPosFx, tempPosFh, tempObj = undefined, modeFlag = 0
Local delNum = 0, Apos = 0, Arot = 0, tempLayer, rcMenuFlag = false--設定値
Local localPosArrayR = #(), localPosArrayL = #(), xFripR = #(), xFripL = #(), mirrorTmR = #(), mirrorTmL = #()

--MasterSet
Local MasterNodes

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_adjuster_rol)catch()
try(cui.unRegisterDialogBar sj_adjuster_rol)catch()
try(closeRolloutFloater sj_adjuster_rol) catch()
try(destroydialog sj_adjuster_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu adjusterMenuBar
(
subMenu "ファイル"
(
menuItem saveBodyBoneMi "ボーンデータ保存" enabled:false
menuItem loadBodyBoneMi "ボーンデータ開く" enabled:false
seperator sep01
menuItem saveFaceBoneMi "フェイシャルボーンデータ保存" enabled:false
menuItem loadFaceBoneMi "フェイシャルボーンデータ開く" enabled:false
seperator sep02
menuItem closeMi "終了" enabled:true
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
on saveBodyBoneMi picked do sj_body_rol.saveBodyBone_Fn()
on loadBodyBoneMi picked do sj_body_rol.loadBodyBone_Fn()
on closeMi  picked do
(
try(cui.unRegisterDialogBar sj_adjuster_rol)catch()		--ドッキング可能な MAXScript ウィンドウを未登録にします
try(closeRolloutFloater sj_adjuster_rol) catch()	--ロールアウトフローターが開いていたら一端閉じる
try(destroydialog sj_adjuster_rol)catch()		--ダイアログが既に開いていた場合は一度閉じるを試みます
)

on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=1031" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""

--メニューを開くたびに実行されるアップデート
on adjusterMenuBar update do
(
adjusterMenuBar.saveBodyBoneMi.enabled = rcMenuFlag
adjusterMenuBar.loadBodyBoneMi.enabled = rcMenuFlag
adjusterMenuBar.closeMi.enabled = not rcMenuFlag
)
)--rcMenu end

-----------------------------------------------------------------------------------------------------------
--ボディ
-----------------------------------------------------------------------------------------------------------
rollout sj_body_rol "ボディ" width:356 height:470
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--セットキーモード解除
--////////////////////////////////////////////////
fn setKeyModeFalse_Fn state =
(
	if (set animate on) == true do maxOps.setKeyMode = true
	if maxOps.getSetKeyMode() == true do maxOps.setKeyMode = false
	--アニメーションキー作成を禁止
	set animate off
	AnimButtonEnabled = true
	maxOps.setKeyMode = false
	maxOps.setKeySuspend = false
	maxOps.setSetKeyFilterState #all false
	maxOps.setSetKeyFilterState #position true
	maxOps.setSetKeyFilterState #rotation true
	maxOps.setSetKeyFilterState #scale false
	maxOps.setSetKeyFilterState #ikParams false
	maxOps.setSetKeyFilterState #objParams false
	maxOps.setSetKeyFilterState #custAttribs true
	maxOps.setSetKeyFilterState #modifiers false
	maxOps.setSetKeyFilterState #materials false
	maxOps.setSetKeyFilterState #other true
	
	if state then
	(
	set animate off
	AnimButtonEnabled = false
	--maxOps.setKeyMode = false
	maxOps.setKeySuspend = true
	maxOps.setSetKeyFilterState #all false
	maxOps.setSetKeyFilterState #position false
	maxOps.setSetKeyFilterState #rotation false
	maxOps.setSetKeyFilterState #scale false
	maxOps.setSetKeyFilterState #ikParams false
	maxOps.setSetKeyFilterState #objParams false
	maxOps.setSetKeyFilterState #custAttribs false
	maxOps.setSetKeyFilterState #modifiers false
	maxOps.setSetKeyFilterState #materials false
	maxOps.setSetKeyFilterState #other false
	)--if end
)

-----------------------------------------------------------------------------------------------------------
--ボディ用ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--ボディボーンデータ保存
--////////////////////////////////////////////////
fn saveBodyBone_Fn =
(
local saveName = getSaveFileName types:"Body Bone File(*.bbf)|*.bbf|All(*.*)|*.*"
	
	if saveName != undefined do
	(
		saveFile = createfile saveName
		
	------------------------------------------
	--本数
			format "%," MasterNodes.SpineBoneNodes.count to:saveFile
			format "%," MasterNodes.NecBoneNodes.count to:saveFile
			--arm
			format "%," MasterNodes.UpperArm_RBoneNodes.count to:saveFile
			format "%," MasterNodes.ForeArm_RBoneNodes.count to:saveFile
			format "%," MasterNodes.UpperArm_LBoneNodes.count to:saveFile
			format "%," MasterNodes.ForeArm_LBoneNodes.count to:saveFile
			--leg
			format "%," MasterNodes.Thigh_RBoneNodes.count to:saveFile
			format "%," MasterNodes.Calf_RBoneNodes.count to:saveFile
			format "%," MasterNodes.Thigh_LBoneNodes.count to:saveFile
			format "%\n" MasterNodes.Calf_LBoneNodes.count to:saveFile
			
			--保存Spine
			for i=1 to 3 do
			(
				format "%\n" MasterNodes.SpineSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			for i=4 to 6 do
			(
				format "%\n" (in coordsys parent MasterNodes.SpineSubAndDefNodes[i].node.pos) to:saveFile
			)--for end
			for i=7 to 8 do
			(
				format "%\n" MasterNodes.SpineSubAndDefNodes[i].node.transform to:saveFile
			)--for end

			--保存Neck
			for i=1 to 2 do
			(
				format "%\n" MasterNodes.NecSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			for i=4 to 5 do
			(
				format "%\n" (in coordsys parent MasterNodes.NecSubAndDefNodes[i].node.pos) to:saveFile
			)--for end
			for i=6 to 7 do
			(
				format "%\n" MasterNodes.NecSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			--2回書き込んでごまかす1回目
			for i=3 to 3 do
			(
				format "%\n" MasterNodes.NecSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			--2回書き込んでごまかす2回目
			for i=3 to 3 do
			(
				format "%\n" MasterNodes.NecSubAndDefNodes[i].node.transform to:saveFile
			)--for end

			--Arm順番に注意
			for i=1 to 8 do
			(
				format "%\n" MasterNodes.ArmSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			
			for i=13 to 20 do
			(
				format "%\n" (in coordsys parent MasterNodes.ArmSubAndDefNodes[i].node.pos) to:saveFile
			)--for end
			
			for i=9 to 12 do
			(
				format "%\n" MasterNodes.ArmSubAndDefNodes[i].node.transform to:saveFile
			)--for end

			--LegToeTopの順番に注意
			for i=1 to 10 do
			(
				format "%\n" MasterNodes.LegSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			
			for i=13 to 22 do
			(
				format "%\n" (in coordsys parent MasterNodes.LegSubAndDefNodes[i].node.pos) to:saveFile
			)--for end

			for i=11 to 12 do
			(
				format "%\n" MasterNodes.LegSubAndDefNodes[i].node.transform to:saveFile
			)--for end
			
			for i=1 to 38 do
			(
				format "%\n" MasterNodes.Hand_RDefNodes[i].node.transform to:saveFile
				format "%\n" MasterNodes.Hand_LDefNodes[i].node.transform to:saveFile
			)--for end
			
				--arm
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] to:saveFile

				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitUpY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateUpY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitDownY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateDownY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitUpX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateUpX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitDownX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateDownX to:saveFile

				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] to:saveFile

				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitUpY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateUpY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitDownY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateDownY to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitUpX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateUpX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitDownX to:saveFile
				format "%\n" MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateDownX to:saveFile
				
				--leg
				format "%\n" MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] to:saveFile
				
				format "%\n" MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] to:saveFile
				format "%\n" MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] to:saveFile

				for i=1 to MasterNodes.MainBoneNodes.count do
				(
					format "%\n" MasterNodes.MainBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.MainBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.SubBoneNodes.count do
				(
					format "%\n" MasterNodes.SubBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.SubBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.SpineBoneNodes.count do
				(
					format "%\n" MasterNodes.SpineBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.SpineBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.NecBoneNodes.count do
				(
					format "%\n" MasterNodes.NecBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.NecBoneNodes[i].node.width to:saveFile
				)
				--R
				for i=1 to MasterNodes.UpperArm_RBoneNodes.count do
				(
					format "%\n" MasterNodes.UpperArm_RBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.UpperArm_RBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.ForeArm_RBoneNodes.count do
				(
					format "%\n" MasterNodes.ForeArm_RBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.ForeArm_RBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Thigh_RBoneNodes.count do
				(
					format "%\n" MasterNodes.Thigh_RBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Thigh_RBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Calf_RBoneNodes.count do
				(
					format "%\n" MasterNodes.Calf_RBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Calf_RBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Hand_RBoneNodes.count do
				(
					format "%\n" MasterNodes.Hand_RBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Hand_RBoneNodes[i].node.width to:saveFile
				)
				--L
				for i=1 to MasterNodes.UpperArm_LBoneNodes.count do
				(
					format "%\n" MasterNodes.UpperArm_LBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.UpperArm_LBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.ForeArm_LBoneNodes.count do
				(
					format "%\n" MasterNodes.ForeArm_LBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.ForeArm_LBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Thigh_LBoneNodes.count do
				(
					format "%\n" MasterNodes.Thigh_LBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Thigh_LBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Calf_LBoneNodes.count do
				(
					format "%\n" MasterNodes.Calf_LBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Calf_LBoneNodes[i].node.width to:saveFile
				)
				for i=1 to MasterNodes.Hand_LBoneNodes.count do
				(
					format "%\n" MasterNodes.Hand_LBoneNodes[i].node.length to:saveFile
					format "%\n" MasterNodes.Hand_LBoneNodes[i].node.width to:saveFile
				)
		close saveFile
	)--if end
)--fn end
--////////////////////////////////////////////////
--ボディボーンデータ読み込み
--////////////////////////////////////////////////
fn loadBodyBone_Fn =
(
suspendEditing()--サスペンドモード
with redraw off
(--再描画禁止
undo off
(
local loadName = getOpenFileName types:"Body Bone File(*.bbf)|*.bbf|All(*.*)|*.*"

	if loadName != undefined do
	(
		loadFile = openFile loadName
		--////////////////////////////////////////////////
		--復元作業本数
		--spine
		x = (readValue loadFile)
		sj_body_rol.boneNumSpineSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.SpineBoneNodes MasterNodes.SpineSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x+1)) 2 -1 false
		--nec
		x = (readValue loadFile)
		sj_body_rol.boneNumNeckSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.NecBoneNodes MasterNodes.NecSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x+1)) 2 -1 false
		--Ruparm
		x = (readValue loadFile)
		sj_body_rol.boneNumUpArmRSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.UpperArm_RBoneNodes MasterNodes.UpperArm_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1)) 3 -2 true
		--Rforarm
		x = (readValue loadFile)
		sj_body_rol.boneNumForeArmRSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.ForeArm_RBoneNodes MasterNodes.ForeArm_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		--Luparm
		x = (readValue loadFile)
		sj_body_rol.boneNumUpArmLSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.UpperArm_LBoneNodes MasterNodes.UpperArm_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1)) 3 -2 true
		--Lforarm
		x = (readValue loadFile)
		sj_body_rol.boneNumForeArmLSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.ForeArm_LBoneNodes MasterNodes.ForeArm_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		--Rthigh
		x = (readValue loadFile)
		sj_body_rol.boneNumThighRSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.Thigh_RBoneNodes MasterNodes.Thigh_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1))  3 -2 true
		--Rcalf
		x = (readValue loadFile)
		sj_body_rol.boneNumCalfRSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.Calf_RBoneNodes MasterNodes.Calf_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		--Lthigh
		x = (readValue loadFile)
		sj_body_rol.boneNumThighLSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.Thigh_LBoneNodes MasterNodes.Thigh_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1))  3 -2 true
		--Lcalf
		x = (readValue loadFile)
		sj_body_rol.boneNumCalfLSpn.value = x
		sj_body_rol.boneDuplicater_Fn MasterNodes.Calf_LBoneNodes MasterNodes.Calf_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false

			--トランスフォーム復元spine
			for i=1 to 3 do
			(
				MasterNodes.SpineSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			for i=4 to 6 do
			(
				in coordsys parent MasterNodes.SpineSubAndDefNodes[i].node.pos = (readValue loadFile)
			)--for end
			for i=7 to 8 do
			(
				MasterNodes.SpineSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end

			--トランスフォーム復元Neck
			for i=1 to 2 do
			(
				MasterNodes.NecSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			for i=4 to 5 do
			(
				in coordsys parent MasterNodes.NecSubAndDefNodes[i].node.pos = (readValue loadFile)
			)--for end
			for i=6 to 7 do
			(
				MasterNodes.NecSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			--2回読み込んでごまかす1回目
			for i=3 to 3 do
			(
				MasterNodes.NecSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			--2回読み込んでごまかす1回目
			for i=3 to 3 do
			(
				MasterNodes.NecSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end


			--Arm順番に注意
			for i=1 to 8 do
			(
				MasterNodes.ArmSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			
			for i=13 to 20 do
			(
				in coordsys parent MasterNodes.ArmSubAndDefNodes[i].node.pos = (readValue loadFile)
			)--for end
			
			for i=9 to 12 do
			(
				MasterNodes.ArmSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end

			--LegToeTopの順に注意
			for i=1 to 10 do
			(
				MasterNodes.LegSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end
			
			for i=13 to 22 do
			(
				in coordsys parent MasterNodes.LegSubAndDefNodes[i].node.pos = (readValue loadFile)
			)--for end

			for i=11 to 12 do
			(
				MasterNodes.LegSubAndDefNodes[i].node.transform = (readValue loadFile)
			)--for end

			for i=1 to 38 do
			(
				MasterNodes.Hand_RDefNodes[i].node.transform = (readValue loadFile)
				MasterNodes.Hand_LDefNodes[i].node.transform = (readValue loadFile)
			)--for end

				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKLimit = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.SoftIKRate = (readValue loadFile)

				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitUpY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateUpY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitDownY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateDownY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitUpX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateUpX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.LimitDownX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[3].node.modifiers[#Control].ArmSet.RateDownX = (readValue loadFile)

				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKLimit = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKNumSetting[2] = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.SoftIKRate = (readValue loadFile)

				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitUpY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateUpY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitDownY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateDownY = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitUpX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateUpX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.LimitDownX = (readValue loadFile)
				MasterNodes.ArmSubAndDefNodes[4].node.modifiers[#Control].ArmSet.RateDownX = (readValue loadFile)
				
				--leg
				MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKLimit = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[3].node.modifiers[#Control].LegSet.SoftIKRate = (readValue loadFile)

				MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKNumSetting[2] = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKLimit = (readValue loadFile)
				MasterNodes.LegSubAndDefNodes[4].node.modifiers[#Control].LegSet.SoftIKRate = (readValue loadFile)

				for i=1 to MasterNodes.MainBoneNodes.count do
				(
					MasterNodes.MainBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.MainBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.SubBoneNodes.count do
				(
					MasterNodes.SubBoneNodes[i].node.length = (readValue loadFile)	
					MasterNodes.SubBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.SpineBoneNodes.count do
				(
					MasterNodes.SpineBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.SpineBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.NecBoneNodes.count do
				(
					MasterNodes.NecBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.NecBoneNodes[i].node.width = (readValue loadFile)
				)
				--R
				for i=1 to MasterNodes.UpperArm_RBoneNodes.count do
				(
					MasterNodes.UpperArm_RBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.UpperArm_RBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.ForeArm_RBoneNodes.count do
				(
					MasterNodes.ForeArm_RBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.ForeArm_RBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Thigh_RBoneNodes.count do
				(
					MasterNodes.Thigh_RBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Thigh_RBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Calf_RBoneNodes.count do
				(
					MasterNodes.Calf_RBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Calf_RBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Hand_RBoneNodes.count do
				(
					MasterNodes.Hand_RBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Hand_RBoneNodes[i].node.width = (readValue loadFile)
				)
				--L
				for i=1 to MasterNodes.UpperArm_LBoneNodes.count do
				(
					MasterNodes.UpperArm_LBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.UpperArm_LBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.ForeArm_LBoneNodes.count do
				(
					MasterNodes.ForeArm_LBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.ForeArm_LBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Thigh_LBoneNodes.count do
				(
					MasterNodes.Thigh_LBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Thigh_LBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Calf_LBoneNodes.count do
				(
					MasterNodes.Calf_LBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Calf_LBoneNodes[i].node.width = (readValue loadFile)
				)
				for i=1 to MasterNodes.Hand_LBoneNodes.count do
				(
					MasterNodes.Hand_LBoneNodes[i].node.length = (readValue loadFile)
					MasterNodes.Hand_LBoneNodes[i].node.width = (readValue loadFile)
				)

		sj_body_rol.boneHeightSet_Fn()
		sj_body_rol.clavicleReset_Fn true true
		sj_functions.sj_SetHide_Fn MasterNodes.SpineSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.NecSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.UpperArm_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.ForeArm_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Thigh_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Calf_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.UpperArm_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.ForeArm_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Thigh_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Calf_LSplinePosNodes false
			
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LSplinePosNodes false
			
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes false
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes false
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes false

		/*
		while not eof loadFile do
		(
		)--while end
		*/
	close loadFile
	)--if end
)--undo off end
)--with redraw end	
resumeEditing()--再びアクティブに
)--fn end

--////////////////////////////////////////////////
--配列取得
--////////////////////////////////////////////////
fn getAdjustArray_Fn =
(
	gc()
	--MasterSet
	MasterNodes = $.MasterNodes[1].node
	
	--現在のボーン数で設定
	sj_body_rol.boneNumSpineSpn.value = MasterNodes.SpineBoneNodes.count
	sj_body_rol.boneNumNeckSpn.value = MasterNodes.NecBoneNodes.count

	sj_body_rol.boneNumUpArmRSpn.value = MasterNodes.UpperArm_RBoneNodes.count
	sj_body_rol.boneNumForeArmRSpn.value = MasterNodes.ForeArm_RBoneNodes.count
	sj_body_rol.boneNumUpArmLSpn.value = MasterNodes.UpperArm_LBoneNodes.count
	sj_body_rol.boneNumForeArmLSpn.value = MasterNodes.ForeArm_LBoneNodes.count

	sj_body_rol.boneNumThighRSpn.value = MasterNodes.Thigh_RBoneNodes.count
	sj_body_rol.boneNumCalfRSpn.value = MasterNodes.Calf_RBoneNodes.count
	sj_body_rol.boneNumThighLSpn.value = MasterNodes.Thigh_LBoneNodes.count
	sj_body_rol.boneNumCalfLSpn.value = MasterNodes.Calf_LBoneNodes.count
	
)--fn end
--////////////////////////////////////////////////
--編集モード用サスペンド
--////////////////////////////////////////////////
fn editModeSuspend_Fn state =
(
	--アニメーションキー作成を禁止
	set animate off
	AnimButtonEnabled = true
	maxOps.setKeyMode = false
	maxOps.setKeySuspend = false
	maxOps.setSetKeyFilterState #all false
	maxOps.setSetKeyFilterState #position true
	maxOps.setSetKeyFilterState #rotation true
	maxOps.setSetKeyFilterState #scale false
	maxOps.setSetKeyFilterState #ikParams false
	maxOps.setSetKeyFilterState #objParams false
	maxOps.setSetKeyFilterState #custAttribs true
	maxOps.setSetKeyFilterState #modifiers false
	maxOps.setSetKeyFilterState #materials false
	maxOps.setSetKeyFilterState #other true
	--レイアウト有効無効

	sj_body_rol.editBodyChk.enabled = false
	sj_body_rol.editArmChk.enabled = false
	sj_body_rol.editLegChk.enabled = false
	sj_body_rol.editHandChk.enabled = false

	sj_body_rol.allSizeGrp.enabled = false
	sj_body_rol.allSizeBt.enabled = false
	sj_body_rol.allSizeSpn.enabled = false
	
	sj_body_rol.boneNnmGrp.enabled = false
	sj_body_rol.boneNnmLbl01.enabled = false
	sj_body_rol.boneNumSpineSpn.enabled = false
	sj_body_rol.boneNnmLbl02.enabled = false
	sj_body_rol.boneNumNeckSpn.enabled = false

	sj_body_rol.boneNnmLbl03.enabled = false
	sj_body_rol.boneNumUpArmRSpn.enabled = false
	sj_body_rol.boneNnmLbl04.enabled = false
	sj_body_rol.boneNumForeArmRSpn.enabled = false
	sj_body_rol.boneNnmLbl05.enabled = false
	sj_body_rol.boneNumUpArmLSpn.enabled = false
	sj_body_rol.boneNnmLbl06.enabled = false
	sj_body_rol.boneNumForeArmLSpn.enabled = false

	sj_body_rol.boneNnmLbl07.enabled = false
	sj_body_rol.boneNumThighRSpn.enabled = false
	sj_body_rol.boneNnmLbl08.enabled = false
	sj_body_rol.boneNumCalfRSpn.enabled = false
	sj_body_rol.boneNnmLbl09.enabled = false
	sj_body_rol.boneNumThighLSpn.enabled = false
	sj_body_rol.boneNnmLbl10.enabled = false
	sj_body_rol.boneNumCalfLSpn.enabled = false

	sj_body_rol.boneNumSetBt.enabled = false
		
	sj_body_rol.symmetryGrp.enabled = false
	sj_body_rol.symmetryBt.enabled = false
	sj_body_rol.typeRob.enabled = false

	sj_body_rol.symmetryArmChk.enabled = false
	sj_body_rol.symmetryHandChk.enabled = false
	sj_body_rol.symmetryLegChk.enabled = false

	sj_body_rol.autoSetGrp.enabled = false
	sj_body_rol.armAutoSetBt.enabled = false
	sj_body_rol.legAutoSetBt.enabled = false
	sj_body_rol.clavicleResetBt.enabled = false
	sj_body_rol.autoSetRChk.enabled = false
	sj_body_rol.autoSetLChk.enabled = false

	sj_body_rol.boneSizeGrp.enabled = false
	sj_body_rol.boneSizeEditCb.enabled = false
	sj_body_rol.boneSizeLbl1.enabled = false
	sj_body_rol.boneLengthSpn.enabled = false
	sj_body_rol.boneSizeLbl2.enabled = false
	sj_body_rol.boneWidthSpn.enabled = false
	sj_body_rol.boneAllSizeBt.enabled = false
	sj_body_rol.boneAllSizeSpn.enabled = false
	sj_body_rol.boneHeightSetBt.enabled = false
	
	--チェックをはずす
	sj_body_rol.boneSizeEditCb.checked = false

	--タブメニュー切り替え
	sj_adjuster_rol.menuTabs.enabled = true
	
	--メニューバーを有効
	rcMenuFlag = false

	--変数が格納済みなら
	--表示非表示コントロール
	--ボーンをフリーズ
	try(
	sj_functions.sj_SetFreeze_Fn MasterNodes.MainBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.SubBoneNodes state

	sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes state
		
	sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes state
	
	sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes state
	sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes state
	)catch()

	if state then
	(
	------------------------------------------
	--無効にする
	set animate off
	AnimButtonEnabled = false
	maxOps.setKeyMode = false
	maxOps.setKeySuspend = true
	maxOps.setSetKeyFilterState #all false
	maxOps.setSetKeyFilterState #position false
	maxOps.setSetKeyFilterState #rotation false
	maxOps.setSetKeyFilterState #scale false
	maxOps.setSetKeyFilterState #ikParams false
	maxOps.setSetKeyFilterState #objParams false
	maxOps.setSetKeyFilterState #custAttribs false
	maxOps.setSetKeyFilterState #modifiers false
	maxOps.setSetKeyFilterState #materials false
	maxOps.setSetKeyFilterState #other false
	
	sj_body_rol.editBodyChk.enabled = true
	sj_body_rol.editArmChk.enabled = true
	sj_body_rol.editLegChk.enabled = true
	sj_body_rol.editHandChk.enabled = true

	sj_body_rol.editBodyChk.checked = true
	sj_body_rol.editArmChk.checked = true
	sj_body_rol.editLegChk.checked = true
	sj_body_rol.editHandChk.checked = true
		
	sj_body_rol.allSizeGrp.enabled = true
	sj_body_rol.allSizeBt.enabled = true
	sj_body_rol.allSizeSpn.enabled = true
	
	sj_body_rol.boneNnmGrp.enabled = true
	sj_body_rol.boneNnmLbl01.enabled = true
	sj_body_rol.boneNumSpineSpn.enabled = true
	sj_body_rol.boneNnmLbl02.enabled = true
	sj_body_rol.boneNumNeckSpn.enabled = true

	sj_body_rol.boneNnmLbl03.enabled = true
	sj_body_rol.boneNumUpArmRSpn.enabled = true
	sj_body_rol.boneNnmLbl04.enabled = true
	sj_body_rol.boneNumForeArmRSpn.enabled = true
	sj_body_rol.boneNnmLbl05.enabled = true
	sj_body_rol.boneNumUpArmLSpn.enabled = true
	sj_body_rol.boneNnmLbl06.enabled = true
	sj_body_rol.boneNumForeArmLSpn.enabled = true

	sj_body_rol.boneNnmLbl07.enabled = true
	sj_body_rol.boneNumThighRSpn.enabled = true
	sj_body_rol.boneNnmLbl08.enabled = true
	sj_body_rol.boneNumCalfRSpn.enabled = true
	sj_body_rol.boneNnmLbl09.enabled = true
	sj_body_rol.boneNumThighLSpn.enabled = true
	sj_body_rol.boneNnmLbl10.enabled = true
	sj_body_rol.boneNumCalfLSpn.enabled = true
	
	sj_body_rol.boneNumSetBt.enabled = true
		
	sj_body_rol.symmetryGrp.enabled = true
	sj_body_rol.symmetryBt.enabled = true
	sj_body_rol.typeRob.enabled = true
	sj_body_rol.symmetryArmChk.enabled = true
	sj_body_rol.symmetryHandChk.enabled = true
	sj_body_rol.symmetryLegChk.enabled = true

	sj_body_rol.autoSetGrp.enabled = true
	sj_body_rol.armAutoSetBt.enabled = true
	sj_body_rol.legAutoSetBt.enabled = true
	sj_body_rol.clavicleResetBt.enabled = true
	sj_body_rol.autoSetRChk.enabled = true
	sj_body_rol.autoSetLChk.enabled = true

	sj_body_rol.boneSizeGrp.enabled = true
	sj_body_rol.boneSizeEditCb.enabled = true
	sj_body_rol.boneSizeLbl1.enabled = true
	sj_body_rol.boneLengthSpn.enabled = true
	sj_body_rol.boneSizeLbl2.enabled = true
	sj_body_rol.boneWidthSpn.enabled = true
	sj_body_rol.boneAllSizeBt.enabled = true
	sj_body_rol.boneAllSizeSpn.enabled = true
	sj_body_rol.boneHeightSetBt.enabled = true
	
	--タブメニュー切り替え有効
	sj_adjuster_rol.menuTabs.enabled = false
	
	--メニューバーを有効
	rcMenuFlag = true
	
	)--if end
	
)--fn end

--////////////////////////////////////////////////
--肩をリセット
--////////////////////////////////////////////////
fn clavicleReset_Fn Rstate Lstate =
(
	--右
	if Rstate then
	(
	MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[1].node.transform = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[2].node.transform
	)
	if Lstate then
	(
	MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[3].node.transform = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[4].node.transform
	)
)

--////////////////////////////////////////////////
--シンメトリー
--////////////////////////////////////////////////
fn boneSymmetry_Fn isArm isLeg isFinger isRL localPosArrayR localPosArrayL xFripR xFripL mirrorTmR mirrorTmL =
(
temp = undefined
suspendEditing()--サスペンドモード
with redraw off
(--再描画禁止
undo off
(
	------------------------------------------
	--mirror
	for i=1 to mirrorTmR.count do
	(
		mirrorTmL[i].transform = 
		(
		matrix3 \
			[mirrorTmR[i].transform[1][1],-mirrorTmR[i].transform[1][2],-mirrorTmR[i].transform[1][3]]\
			[-mirrorTmR[i].transform[2][1],mirrorTmR[i].transform[2][2],mirrorTmR[i].transform[2][3]]\
			[-mirrorTmR[i].transform[3][1],mirrorTmR[i].transform[3][2],mirrorTmR[i].transform[3][3]]\
			[-mirrorTmR[i].transform[4][1],mirrorTmR[i].transform[4][2],mirrorTmR[i].transform[4][3]]
		)
	)--for end

		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1	
	
	------------------------------------------
	--Xが反転
	for i=1 to xFripR.count do
	(
		xFripL[i].transform = 
		(
		matrix3 \
			[xFripR[i].transform[1][1],xFripR[i].transform[1][2],xFripR[i].transform[1][3]]\
			[xFripR[i].transform[2][1],xFripR[i].transform[2][2],xFripR[i].transform[2][3]]\
			[xFripR[i].transform[3][1],xFripR[i].transform[3][2],xFripR[i].transform[3][3]]\
			[-xFripR[i].transform[4][1],xFripR[i].transform[4][2],xFripR[i].transform[4][3]]
		)
	)--for end

		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1

	------------------------------------------
	--ローカル数値をコピーするだけ
	for i=1 to localPosArrayR.count do
	(
		in coordsys parent localPosArrayL[i].pos.z = in coordsys parent localPosArrayR[i].pos.z
	)--for end
	
		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1
	
	--SoftIKと肩の設定
	if isArm then
	(
		--もう面倒だからこの変数を流用
		localPosArrayR = #()
		localPosArrayL = #()
		localPosArrayR = MasterNodes.ArmSubAndDefNodes[3].node
		localPosArrayL = MasterNodes.ArmSubAndDefNodes[4].node
		if isRL then
		(
				localPosArrayL.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = localPosArrayR.modifiers[#Control].ArmSet.SoftIKNumSetting[1]
				localPosArrayL.modifiers[#Control].ArmSet.SoftIKLimit = localPosArrayR.modifiers[#Control].ArmSet.SoftIKLimit
				localPosArrayL.modifiers[#Control].ArmSet.SoftIKNumSetting[2] = localPosArrayR.modifiers[#Control].ArmSet.SoftIKNumSetting[2]
				localPosArrayL.modifiers[#Control].ArmSet.SoftIKRate = localPosArrayR.modifiers[#Control].ArmSet.SoftIKRate

				localPosArrayL.modifiers[#Control].ArmSet.LimitUpY = localPosArrayR.modifiers[#Control].ArmSet.LimitUpY
				localPosArrayL.modifiers[#Control].ArmSet.RateUpY = localPosArrayR.modifiers[#Control].ArmSet.RateUpY
				localPosArrayL.modifiers[#Control].ArmSet.LimitDownY = localPosArrayR.modifiers[#Control].ArmSet.LimitDownY
				localPosArrayL.modifiers[#Control].ArmSet.RateDownY = localPosArrayR.modifiers[#Control].ArmSet.RateDownY
				localPosArrayL.modifiers[#Control].ArmSet.LimitUpX = localPosArrayR.modifiers[#Control].ArmSet.LimitUpX
				localPosArrayL.modifiers[#Control].ArmSet.RateUpX = localPosArrayR.modifiers[#Control].ArmSet.RateUpX
				localPosArrayL.modifiers[#Control].ArmSet.LimitDownX = localPosArrayR.modifiers[#Control].ArmSet.LimitDownX
				localPosArrayL.modifiers[#Control].ArmSet.RateDownX = localPosArrayR.modifiers[#Control].ArmSet.RateDownX
		)else
		(
				localPosArrayR.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = localPosArrayL.modifiers[#Control].ArmSet.SoftIKNumSetting[1]
				localPosArrayR.modifiers[#Control].ArmSet.SoftIKLimit = localPosArrayL.modifiers[#Control].ArmSet.SoftIKLimit
				localPosArrayR.modifiers[#Control].ArmSet.SoftIKNumSetting[2] = localPosArrayL.modifiers[#Control].ArmSet.SoftIKNumSetting[2]
				localPosArrayR.modifiers[#Control].ArmSet.SoftIKRate = localPosArrayL.modifiers[#Control].ArmSet.SoftIKRate

				localPosArrayR.modifiers[#Control].ArmSet.LimitUpY = localPosArrayL.modifiers[#Control].ArmSet.LimitUpY
				localPosArrayR.modifiers[#Control].ArmSet.RateUpY = localPosArrayL.modifiers[#Control].ArmSet.RateUpY
				localPosArrayR.modifiers[#Control].ArmSet.LimitDownY = localPosArrayL.modifiers[#Control].ArmSet.LimitDownY
				localPosArrayR.modifiers[#Control].ArmSet.RateDownY = localPosArrayL.modifiers[#Control].ArmSet.RateDownY
				localPosArrayR.modifiers[#Control].ArmSet.LimitUpX = localPosArrayL.modifiers[#Control].ArmSet.LimitUpX
				localPosArrayR.modifiers[#Control].ArmSet.RateUpX = localPosArrayL.modifiers[#Control].ArmSet.RateUpX
				localPosArrayR.modifiers[#Control].ArmSet.LimitDownX = localPosArrayL.modifiers[#Control].ArmSet.LimitDownX
				localPosArrayR.modifiers[#Control].ArmSet.RateDownX = localPosArrayL.modifiers[#Control].ArmSet.RateDownX
		)--if end
		localPosArrayR = #()
		localPosArrayL = #()
	)--if end
	
		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1
	
	--SoftIKと肩の設定
	if isLeg then
	(
		localPosArrayR = #()
		localPosArrayL = #()
		localPosArrayR = MasterNodes.LegSubAndDefNodes[3].node
		localPosArrayL = MasterNodes.LegSubAndDefNodes[4].node
		if isRL then
		(
				localPosArrayL.modifiers[#Control].LegSet.SoftIKNumSetting[1] = localPosArrayR.modifiers[#Control].LegSet.SoftIKNumSetting[1]
				localPosArrayL.modifiers[#Control].LegSet.SoftIKNumSetting[2] = localPosArrayR.modifiers[#Control].LegSet.SoftIKNumSetting[2]
				localPosArrayL.modifiers[#Control].LegSet.SoftIKLimit = localPosArrayR.modifiers[#Control].LegSet.SoftIKLimit
				localPosArrayL.modifiers[#Control].LegSet.SoftIKRate = localPosArrayR.modifiers[#Control].LegSet.SoftIKRate
		)else
		(
				localPosArrayR.modifiers[#Control].LegSet.SoftIKNumSetting[1] = localPosArrayL.modifiers[#Control].LegSet.SoftIKNumSetting[1]
				localPosArrayR.modifiers[#Control].LegSet.SoftIKNumSetting[2] = localPosArrayL.modifiers[#Control].LegSet.SoftIKNumSetting[2]
				localPosArrayR.modifiers[#Control].LegSet.SoftIKLimit = localPosArrayL.modifiers[#Control].LegSet.SoftIKLimit
				localPosArrayR.modifiers[#Control].LegSet.SoftIKRate = localPosArrayL.modifiers[#Control].LegSet.SoftIKRate
		)
		localPosArrayR = #()
		localPosArrayL = #()
	)--if end

		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1

	--指のマイナス処理
	if isFinger then
	(
		--もう面倒だからこの変数を流用
		localPosArrayR = #()
		localPosArrayL = #()
		append localPosArrayR MasterNodes.Hand_RDefNodes[9].node
		append localPosArrayR MasterNodes.Hand_RDefNodes[17].node
		append localPosArrayR MasterNodes.Hand_RDefNodes[25].node
		append localPosArrayR MasterNodes.Hand_RDefNodes[31].node
		append localPosArrayR MasterNodes.Hand_RDefNodes[33].node
		append localPosArrayL MasterNodes.Hand_LDefNodes[9].node
		append localPosArrayL MasterNodes.Hand_LDefNodes[17].node
		append localPosArrayL MasterNodes.Hand_LDefNodes[25].node
		append localPosArrayL MasterNodes.Hand_LDefNodes[31].node
		append localPosArrayL MasterNodes.Hand_LDefNodes[33].node
		--左右？
		if isRL then
		(
		in coordsys parent MasterNodes.Hand_LDefNodes[2].node.pos.z = -(in coordsys parent MasterNodes.Hand_RDefNodes[2].node.pos.z)
		
		--軸回転が別のモノ親指
		temp = MasterNodes.Hand_RDefNodes[1].node
		MasterNodes.Hand_LDefNodes[1].node.transform = 
		(
		matrix3 \
			[temp.transform[1][1],-temp.transform[1][2],-temp.transform[1][3]]\
			[-temp.transform[2][1],temp.transform[2][2],temp.transform[2][3]]\
			[-temp.transform[3][1],temp.transform[3][2],temp.transform[3][3]]\
			[-temp.transform[4][1],temp.transform[4][2],temp.transform[4][3]]
		)
		in coordsys local rotate MasterNodes.Hand_LDefNodes[1].node (angleaxis 180 [1,0,0])
		
		--回転が別物
			for i=1 to localPosArrayR.count do
			(
			localPosArrayL[i].transform = 
			(
			matrix3 \
				[-localPosArrayR[i].transform[1][1],localPosArrayR[i].transform[1][2],localPosArrayR[i].transform[1][3]]\
				[localPosArrayR[i].transform[2][1],-localPosArrayR[i].transform[2][2],-localPosArrayR[i].transform[2][3]]\
				[-localPosArrayR[i].transform[3][1],localPosArrayR[i].transform[3][2],localPosArrayR[i].transform[3][3]]\
				[-localPosArrayR[i].transform[4][1],localPosArrayR[i].transform[4][2],localPosArrayR[i].transform[4][3]]
			)
			)--for end
		)
		else(
		in coordsys parent MasterNodes.Hand_RDefNodes[2].node.pos.z = -(in coordsys parent MasterNodes.Hand_LDefNodes[2].node.pos.z)
		--軸回転が別のモノ
		temp = MasterNodes.Hand_LDefNodes[1].node
		MasterNodes.Hand_RDefNodes[1].node.transform = 
		(
		matrix3 \
			[temp.transform[1][1],-temp.transform[1][2],-temp.transform[1][3]]\
			[-temp.transform[2][1],temp.transform[2][2],temp.transform[2][3]]\
			[-temp.transform[3][1],temp.transform[3][2],temp.transform[3][3]]\
			[-temp.transform[4][1],temp.transform[4][2],temp.transform[4][3]]
		)
		in coordsys local rotate MasterNodes.Hand_RDefNodes[1].node (angleaxis -180 [1,0,0])	
		
		--回転が別物
			for i=1 to localPosArrayR.count do
			(
			localPosArrayR[i].transform = 
			(
			matrix3 \
				[-localPosArrayL[i].transform[1][1],localPosArrayL[i].transform[1][2],localPosArrayL[i].transform[1][3]]\
				[localPosArrayL[i].transform[2][1],-localPosArrayL[i].transform[2][2],-localPosArrayL[i].transform[2][3]]\
				[-localPosArrayL[i].transform[3][1],localPosArrayL[i].transform[3][2],localPosArrayL[i].transform[3][3]]\
				[-localPosArrayL[i].transform[4][1],localPosArrayL[i].transform[4][2],localPosArrayL[i].transform[4][3]]
			)
			)--for end
		)--if end
		
		localPosArrayR = #()
		localPosArrayL = #()
	)--if end	

)--undo off end
)--with redraw end
resumeEditing()--再びアクティブに
		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1
)

--////////////////////////////////////////////////
--ボーン設定
--////////////////////////////////////////////////
fn boneDuplicater_Fn boneArray splinePosArray x xBoneDup xSPnSet Apos Arot ix ux oneBone =
(
suspendEditing()--サスペンドモード
with redraw off
(--再描画禁止
undo off
(
	--
	delNum = 0
	tempObj = undefined
	--レイヤー処理複製時に既定レイヤーに複製
	tempLayer = layermanager.getlayer 0
	tempLayer.current = true
	------------------------------------------
	--ボーンを1まで削除
	delNum = boneArray.count
	while delNum > 1 do
	(
		delete boneArray[delNum].node
		deleteItem boneArray delNum
		delNum -= 1
	)--while end
	
	------------------------------------------
	--ボーン複製 複製回数は xBoneDup
	if x != 1 then
	(
		for i=1 to xBoneDup do
		(
			tempObj = copy boneArray[1].node
			tempObj.wirecolor = boneArray[1].node.wirecolor
			tempObj.showFrozenInGray = false
			append boneArray (nodeTransformMonitor node:tempObj forwardTransformChangeMsgs:false)
			tempObj.parent = boneArray[i].node
			--名前処理
			if MasterNodes.PrefixName != "" do tempObj.Name = replace tempObj.name 1 MasterNodes.PrefixName.count MasterNodes.PrefixName
			
		)--for end
	)--if end

	------------------------------------------
	--SplinePosを2まで削除
	delNum = splinePosArray.count
	while delNum > 1 do
	(
		delete splinePosArray[delNum].node
		deleteItem splinePosArray delNum
		delNum -= 1
	)

	------------------------------------------
	--SplinePos複製 複製回数は x
		for i=1 to x do
		(
			tempObj = copy splinePosArray[1].node
			tempObj.wirecolor = splinePosArray[1].node.wirecolor
			tempObj.showFrozenInGray = false
			append splinePosArray (nodeTransformMonitor node:tempObj forwardTransformChangeMsgs:false)
			--名前処理
			if MasterNodes.PrefixName != "" do tempObj.Name = replace tempObj.name 1 MasterNodes.PrefixName.count MasterNodes.PrefixName
			
		)--for end
	------------------------------------------
	--SplinePos位置設定 設定回数は x+1 xSPnSet
		for i=2 to xSPnSet do
		(
			splinePosArray[i].node.pos.controller.percent.controller = Float_Script()
			splinePosArray[i].node.pos.controller.percent.controller.script = ((Apos * (i-1))as String)
		)--for end

		for i=ix to xSPnSet do
		(
			splinePosArray[i].node.rotation.controller.weight[1] = 100.0-(Arot*(i+ux))
			splinePosArray[i].node.rotation.controller.weight[2] = (Arot*(i+ux))
		)--for end
		
		--設定数が1で1本設定が必要な場合
		if x == 1 and oneBone then
		(
			splinePosArray[2].node.rotation.controller.weight[1] = 0
			splinePosArray[2].node.rotation.controller.weight[2] = 100			
		)
	------------------------------------------
	--Bone設定 設定回数は x
		for i=1 to x do
		(
			boneArray[i].node.pos.controller.deleteTarget 1
			boneArray[i].node.pos.controller.appendTarget splinePosArray[i].node 50.0
			boneArray[i].node.rotation.controller.deleteTarget 1
			boneArray[i].node.rotation.controller.appendTarget splinePosArray[i+1].node 50.0
			boneArray[i].node.rotation.controller.pickUpNode =  splinePosArray[i+1].node
		)--for end

)--undo off end
)--with redraw end	
resumeEditing()--再びアクティブに
)--fn end
--////////////////////////////////////////////////
--自動設定
--////////////////////////////////////////////////
fn optimizeArm_Fn Rstate Lstate =
(
tempPosFx = undefined
tempPosFh = undefined
tempPosA = undefined
tempPosB = undefined
tempPosC = undefined
tempObj = Dummy pos:[0,0,0]

	--右用
	if Rstate then
	(
		tempPosA = (in coordsys parent MasterNodes.ArmSubAndDefNodes[15].node.pos.z)
		tempPosB = (in coordsys parent MasterNodes.ArmSubAndDefNodes[17].node.pos.z)
		tempPosC = (distance MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[5].node MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[7].node)
		
		--xの長さ
		tempPosFx = ((tempPosA*tempPosA) - (tempPosB*tempPosB) + (tempPosC*tempPosC)) / (2*tempPosC)
		--高さ
		tempPosFh = sqrt((tempPosA*tempPosA)-(tempPosFx*tempPosFx))
		
		tempObj.parent = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[8].node
		tempObj.transform = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[8].node.transform

		--最終的な位置を確定
		--print tempPosFx
		in coordsys parent tempObj.pos.z = tempPosFx
		in coordsys parent tempObj.pos.y = tempPosFh + ((tempPosA/3)*2)
		
		MasterNodes.ArmSubAndDefNodes[3].node.transform = tempObj.transform
	)--if end
	
	--左用
	if Lstate then
	(
		tempPosA = (in coordsys parent MasterNodes.ArmSubAndDefNodes[16].node.pos.z)
		tempPosB = (in coordsys parent MasterNodes.ArmSubAndDefNodes[18].node.pos.z)
		tempPosC = (distance MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[9].node MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[11].node)
		
		--xの長さ
		tempPosFx = ((tempPosA*tempPosA) - (tempPosB*tempPosB) + (tempPosC*tempPosC)) / (2*tempPosC)
		--高さ
		tempPosFh = sqrt((tempPosA*tempPosA)-(tempPosFx*tempPosFx))
		
		tempObj.parent = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[12].node
		tempObj.transform = MasterNodes.AllOtherNodes[1].node.ArmOtherNodes[12].node.transform

		--最終的な位置を確定
		in coordsys parent tempObj.pos.z = tempPosFx
		in coordsys parent tempObj.pos.y = tempPosFh + ((tempPosA/3)*2)
		
		MasterNodes.ArmSubAndDefNodes[4].node.transform = tempObj.transform
	)--if end
	
	--初期化
	tempPosFx = undefined
	tempPosFh = undefined
	tempPosA = undefined
	tempPosB = undefined
	tempPosC = undefined
	delete tempObj
)--fn end

fn optimizeLeg_Fn Rstate Lstate =
(
tempPosFx = undefined
tempPosFh = undefined
tempPosA = undefined
tempPosB = undefined
tempPosC = undefined
tempObj = Dummy pos:[0,0,0]

	--右用
	if Rstate then
	(
		tempPosA = (in coordsys parent MasterNodes.LegSubAndDefNodes[13].node.pos.z)
		tempPosB = (in coordsys parent MasterNodes.LegSubAndDefNodes[15].node.pos.z)
		tempPosC = (distance MasterNodes.AllOtherNodes[1].node.LegOtherNodes[1].node MasterNodes.AllOtherNodes[1].node.LegOtherNodes[3].node)
		
		--xの長さ
		tempPosFx = ((tempPosA*tempPosA) - (tempPosB*tempPosB) + (tempPosC*tempPosC)) / (2*tempPosC)
		--高さ
		tempPosFh = sqrt((tempPosA*tempPosA)-(tempPosFx*tempPosFx))
		
		tempObj.parent = MasterNodes.AllOtherNodes[1].node.LegOtherNodes[4].node
		tempObj.transform = MasterNodes.AllOtherNodes[1].node.LegOtherNodes[4].node.transform

		--最終的な位置を確定
		--print tempPosFx
		in coordsys parent tempObj.pos.z = tempPosFx
		in coordsys parent tempObj.pos.y = -(tempPosFh + ((tempPosA/3)*2))
		
		MasterNodes.LegSubAndDefNodes[3].node.transform = tempObj.transform
	)--if end
	
	--左用
	if Lstate then
	(
		tempPosA = (in coordsys parent MasterNodes.LegSubAndDefNodes[14].node.pos.z)
		tempPosB = (in coordsys parent MasterNodes.LegSubAndDefNodes[16].node.pos.z)
		tempPosC = (distance MasterNodes.AllOtherNodes[1].node.LegOtherNodes[5].node MasterNodes.AllOtherNodes[1].node.LegOtherNodes[7].node)
		
		--xの長さ
		tempPosFx = ((tempPosA*tempPosA) - (tempPosB*tempPosB) + (tempPosC*tempPosC)) / (2*tempPosC)
		--高さ
		tempPosFh = sqrt((tempPosA*tempPosA)-(tempPosFx*tempPosFx))
		
		tempObj.parent = MasterNodes.AllOtherNodes[1].node.LegOtherNodes[8].node
		tempObj.transform = MasterNodes.AllOtherNodes[1].node.LegOtherNodes[8].node.transform

		--最終的な位置を確定
		in coordsys parent tempObj.pos.z = tempPosFx
		in coordsys parent tempObj.pos.y = -(tempPosFh + ((tempPosA/3)*2))
		
		MasterNodes.LegSubAndDefNodes[4].node.transform = tempObj.transform
	)--if end
	
	--初期化
	tempPosFx = undefined
	tempPosFh = undefined
	tempPosA = undefined
	tempPosB = undefined
	tempPosC = undefined
	delete tempObj
)--fn end
--////////////////////////////////////////////////
--連続間接ボーンの長さを設定
--////////////////////////////////////////////////
fn boneHeightSet_Fn = 
(
	--spine
	for i=1 to MasterNodes.SpineBoneNodes.count do
	(
		MasterNodes.SpineBoneNodes[i].node.height = (in coordsys parent MasterNodes.SpineDefNodes[1].node.pos.z) /  MasterNodes.SpineBoneNodes.count
	)--for end
	--neck
	for i=1 to MasterNodes.NecBoneNodes.count do
	(
		MasterNodes.NecBoneNodes[i].node.height = (in coordsys parent MasterNodes.NecDefNodes[2].node.pos.z) /  MasterNodes.NecBoneNodes.count
	)--for end
	--Arm
	for i=1 to MasterNodes.UpperArm_RBoneNodes.count do
	(
		MasterNodes.UpperArm_RBoneNodes[i].node.height = (in coordsys parent MasterNodes.ArmDefNodes[11].node.pos.z) /  MasterNodes.UpperArm_RBoneNodes.count
	)--for end
	for i=1 to MasterNodes.UpperArm_LBoneNodes.count do
	(
		MasterNodes.UpperArm_LBoneNodes[i].node.height = (in coordsys parent MasterNodes.ArmDefNodes[12].node.pos.z) /  MasterNodes.UpperArm_LBoneNodes.count
	)--for end
	for i=1 to MasterNodes.ForeArm_RBoneNodes.count do
	(
		MasterNodes.ForeArm_RBoneNodes[i].node.height = (in coordsys parent MasterNodes.ArmDefNodes[13].node.pos.z) /  MasterNodes.ForeArm_RBoneNodes.count
	)--for end
	for i=1 to MasterNodes.ForeArm_LBoneNodes.count do
	(
		MasterNodes.ForeArm_LBoneNodes[i].node.height = (in coordsys parent MasterNodes.ArmDefNodes[14].node.pos.z) /  MasterNodes.ForeArm_LBoneNodes.count
	)--for end
	--Leg
	for i=1 to MasterNodes.Thigh_RBoneNodes.count do
	(
		MasterNodes.Thigh_RBoneNodes[i].node.height = (in coordsys parent MasterNodes.LegDefNodes[9].node.pos.z) /  MasterNodes.Thigh_RBoneNodes.count
	)--for end
	for i=1 to MasterNodes.Thigh_LBoneNodes.count do
	(
		MasterNodes.Thigh_LBoneNodes[i].node.height = (in coordsys parent MasterNodes.LegDefNodes[10].node.pos.z) /  MasterNodes.Thigh_LBoneNodes.count
	)--for end
	for i=1 to MasterNodes.Calf_RBoneNodes.count do
	(
		MasterNodes.Calf_RBoneNodes[i].node.height = (in coordsys parent MasterNodes.LegDefNodes[11].node.pos.z) /  MasterNodes.Calf_RBoneNodes.count
	)--for end
	for i=1 to MasterNodes.Calf_LBoneNodes.count do
	(
		MasterNodes.Calf_LBoneNodes[i].node.height = (in coordsys parent MasterNodes.LegDefNodes[12].node.pos.z) /  MasterNodes.Calf_LBoneNodes.count
	)--for end
)--fn end
--////////////////////////////////////////////////
--全位置を縮尺
--////////////////////////////////////////////////
fn allDefPosSize_Fn Nodes Ratio = 
(
tempPosA = #()
tempPosB = [0,0,0]
	--ポジション計算
	for i = 1 to Nodes.count do
	(
		tempPosB = (in coordsys parent Nodes[i].node.pos) * Ratio
		append tempPosA tempPosB
	)--for end
	--ポジション代入
	for i = 1 to Nodes.count do
	(
		in coordsys parent Nodes[i].node.pos = tempPosA[i]
	)--for end
tempPosA = #()
tempPosB = [0,0,0]
)--fn end
--////////////////////////////////////////////////
--全ての骨のサイズを縮尺
--////////////////////////////////////////////////
fn allBoneSize_Fn Nodes Ratio =
(
	for i = 1 to Nodes.count do
	(
		Nodes[i].node.length = Nodes[i].node.length * Ratio
		Nodes[i].node.width = Nodes[i].node.width * Ratio
	)--for end
)--fn end


--////////////////////////////////////////////////
--ボディレイアウト
--////////////////////////////////////////////////
	GroupBox editModeGrp "編集" pos:[8,4] width:216 height:68
	checkbutton editModeCb "編集モード" pos:[16,20] width:200 height:20
	checkbox editBodyChk "体" pos:[16,48] width:40 height:20 checked:true enabled:false
	checkbox editArmChk "腕" pos:[56,48] width:40 height:20 checked:true enabled:false
	checkbox editLegChk "脚" pos:[96,48] width:32 height:20 checked:true enabled:false
	checkbox editHandChk "手" pos:[136,48] width:44 height:20 checked:true enabled:false
	
	GroupBox allSizeGrp "全体サイズ%" pos:[232,4] width:112 height:68 enabled:false
	button allSizeBt "セット" pos:[240,20] width:96 height:20 enabled:false
	spinner allSizeSpn "" pos:[240,48] width:96 height:16 range:[1,1000,100] enabled:false

	GroupBox boneNnmGrp "ボーン数" pos:[8,80] width:216 height:164 enabled:false
	label boneNnmLbl01 "背骨" pos:[16,96] width:32 height:20 enabled:false
	spinner boneNumSpineSpn "" pos:[59,96] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl02 "首" pos:[120,96] width:32 height:20 enabled:false
	spinner boneNumNeckSpn "" pos:[163,96] width:52 height:16 range:[1,32,2] type:#integer enabled:false

	label boneNnmLbl03 "右上腕" pos:[16,120] width:44 height:20 enabled:false
	spinner boneNumUpArmRSpn "" pos:[59,120] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl04 "右前腕" pos:[16,144] width:44 height:20 enabled:false
	spinner boneNumForeArmRSpn "" pos:[59,144] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl05 "左上腕" pos:[120,120] width:44 height:20 enabled:false
	spinner boneNumUpArmLSpn "" pos:[163,120] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl06 "左前腕" pos:[120,144] width:44 height:20 enabled:false
	spinner boneNumForeArmLSpn "" pos:[163,144] width:52 height:16 range:[1,32,3] type:#integer enabled:false

	label boneNnmLbl07 "右腿" pos:[16,168] width:44 height:20 enabled:false
	spinner boneNumThighRSpn "" pos:[59,168] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl08 "右膝" pos:[16,192] width:44 height:20 enabled:false
	spinner boneNumCalfRSpn "" pos:[59,192] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl09 "左腿" pos:[120,168] width:44 height:20 enabled:false
	spinner boneNumThighLSpn "" pos:[163,168] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	label boneNnmLbl10 "左膝" pos:[120,192] width:44 height:20 enabled:false
	spinner boneNumCalfLSpn "" pos:[163,192] width:52 height:16 range:[1,32,3] type:#integer enabled:false
	
	button boneNumSetBt "セット" pos:[16,216] width:200 height:20 enabled:false
		
	GroupBox symmetryGrp "シンメトリー" pos:[232,80] width:112 height:164 enabled:false
	button symmetryBt "シンメトリー" pos:[240,96] width:96 height:20 enabled:false
	radioButtons typeRob "" pos:[240,124] width:76 height:20 labels:#("右-->左", "左-->右") default:1 columns:1 enabled:false
	checkbox symmetryArmChk "腕" pos:[240,164] width:36 height:20 checked:true enabled:false
	checkbox symmetryLegChk "脚" pos:[240,184] width:32 height:20 checked:true enabled:false
	checkbox symmetryHandChk "手" pos:[240,204] width:32 height:20 checked:true enabled:false

	GroupBox autoSetGrp "自動設定" pos:[8,252] width:216 height:72 enabled:false
	button armAutoSetBt "腕コントローラー" pos:[16,268] width:96 height:20 enabled:false
	button legAutoSetBt "膝コントローラー" pos:[120,268] width:96 height:20 enabled:false
	button clavicleResetBt "鎖骨をリセット" pos:[16,296] width:96 height:20 enabled:false
	checkbox autoSetRChk "右" pos:[120,296] width:32 height:20 enabled:false checked:true
	checkbox autoSetLChk "左" pos:[160,296] width:32 height:20 enabled:false checked:true

	GroupBox boneSizeGrp "ボーンサイズ" pos:[8,332] width:216 height:124 enabled:false
	checkbutton boneSizeEditCb "ボーン選択モード" pos:[16,348] width:200 height:20 enabled:false
	button boneAllSizeBt "全体サイズ%" pos:[16,376] width:96 height:20 enabled:false
	spinner boneAllSizeSpn "" pos:[120,378] width:96 height:16 enabled:false range:[1,1000,100]
	button boneHeightSetBt "長さをセット" pos:[16,404] width:200 height:20 enabled:false
	label boneSizeLbl1 "Length" pos:[16,432] width:44 height:20 enabled:false
	spinner boneLengthSpn "" pos:[59,432] width:52 height:16 enabled:false range:[0.1,1000,10]
	label boneSizeLbl2 "Width" pos:[120,432] width:36 height:20 enabled:false
	spinner boneWidthSpn "" pos:[163,432] width:52 height:16 enabled:false range:[0.1,1000,10]


	GroupBox ctrlEditModeGrp "コントローラー" pos:[232,252] width:112 height:44 enabled:true
	checkbutton ctrlEditModeCb "編集" pos:[240,268] width:96 height:20 enabled:true

-----------------------------------------------------------------------------------------------------------
--ボディ用アクション
-----------------------------------------------------------------------------------------------------------
	on editModeCb changed state do
	(
		editModeSuspend_Fn false
		modeFlag = 0
		try(
		tempNodes = #()
		for i in MasterNodes.SpineSubAndDefNodes do append tempNodes i
		for i in MasterNodes.NecSubAndDefNodes do append tempNodes i
		for i in MasterNodes.ArmSubAndDefNodes do append tempNodes i
		for i in MasterNodes.LegSubAndDefNodes do append tempNodes i
		for i in MasterNodes.Hand_RDefNodes do append tempNodes i
		for i in MasterNodes.Hand_LDefNodes do append tempNodes i
		sj_functions.sj_SetHide_Fn tempNodes false
		sj_functions.sj_SetFreeze_Fn tempNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.MainBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.SubBoneNodes state
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes state
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes state
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes state
		
		)catch()

		------------------------------------
		--編集モードOn
		if state then
		(
		try(
			if isvalidnode $.MasterNodes[1].node then
			(
				editModeSuspend_Fn state
				getAdjustArray_Fn()
				messageBox"編集モード\nアニメーションキーを付けないよう注意してください\n肩のリセットもお忘れなく" title:"メッセージ"
				modeFlag = 1
				
				--機能停止
				MasterNodes.ControlNodes[6].node.modifiers[#Control].ArmSet.SoftIKSet = off
				MasterNodes.ControlNodes[7].node.modifiers[#Control].ArmSet.SoftIKSet = off
				MasterNodes.ControlNodes[12].node.modifiers[#Control].LegSet.SoftIKSet = off
				MasterNodes.ControlNodes[13].node.modifiers[#Control].LegSet.SoftIKSet = off
				MasterNodes.ControlNodes[12].node.modifiers[#Control].LegSet.FcSet = off
				MasterNodes.ControlNodes[13].node.modifiers[#Control].LegSet.FcSet = off
				MasterNodes.ControlNodes[6].node.modifiers[#Control].ArmSet.ClavicleAutoAnim = off
				MasterNodes.ControlNodes[7].node.modifiers[#Control].ArmSet.ClavicleAutoAnim = off
				
				--表示非表示
				sj_functions.sj_SetHide_Fn MasterNodes.ControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.ControlNodes false
				sj_functions.sj_SetHide_Fn MasterNodes.SpineSubControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.SpineSubControlNodes false
				--sj_functions.sj_SetHide_Fn MasterNodes.NecSubAndDefNodes false
				--sj_functions.sj_SetFreeze_Fn MasterNodes.NecSubAndDefNodes false
				sj_functions.sj_SetHide_Fn MasterNodes.ArmSubControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.ArmSubControlNodes false
				sj_functions.sj_SetHide_Fn MasterNodes.LegSubControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.LegSubControlNodes false
				sj_functions.sj_SetHide_Fn MasterNodes.Hand_RSubControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RSubControlNodes false
				sj_functions.sj_SetHide_Fn MasterNodes.Hand_LSubControlNodes false
				sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LSubControlNodes false
				MasterNodes.NomalHideSet = false
				
				--Bone
				tempNodes = #()
				for i in MasterNodes.MainBoneNodes do append tempNodes i			
				for i in MasterNodes.SubBoneNodes do append tempNodes i			
				for i in MasterNodes.SpineBoneNodes do append tempNodes i
				for i in MasterNodes.NecBoneNodes do append tempNodes i
				for i in MasterNodes.UpperArm_RBoneNodes do append tempNodes i
				for i in MasterNodes.ForeArm_RBoneNodes do append tempNodes i
				for i in MasterNodes.Thigh_RBoneNodes do append tempNodes i
				for i in MasterNodes.Calf_RBoneNodes do append tempNodes i
				for i in MasterNodes.Hand_RBoneNodes do append tempNodes i
				for i in MasterNodes.UpperArm_LBoneNodes do append tempNodes i
				for i in MasterNodes.ForeArm_LBoneNodes do append tempNodes i
				for i in MasterNodes.Thigh_LBoneNodes do append tempNodes i
				for i in MasterNodes.Calf_LBoneNodes do append tempNodes i
				for i in MasterNodes.Hand_LBoneNodes do append tempNodes i
				/*
				for i in MasterNodes.AllCustomNodes[1].node.Custom01BoneNodes do append tempNodes i
				for i in MasterNodes.AllCustomNodes[1].node.Custom02BoneNodes do append tempNodes i
				for i in MasterNodes.AllCustomNodes[1].node.Custom03BoneNodes do append tempNodes i
				for i in MasterNodes.AllCustomNodes[1].node.Custom04BoneNodes do append tempNodes i
				*/
				sj_functions.sj_SetHide_Fn tempNodes state
				sj_functions.sj_SetFreeze_Fn tempNodes false
				MasterNodes.BoneHideSet = state

				--デフォーム
				tempNodes = #()
				for i in MasterNodes.SpineSubAndDefNodes do append tempNodes i			
				for i in MasterNodes.NecSubAndDefNodes do append tempNodes i			
				for i in MasterNodes.ArmSubAndDefNodes do append tempNodes i
				for i in MasterNodes.LegSubAndDefNodes do append tempNodes i
				for i in MasterNodes.Hand_RDefNodes do append tempNodes i
				for i in MasterNodes.Hand_LDefNodes do append tempNodes i
				sj_functions.sj_SetHide_Fn tempNodes state
				sj_functions.sj_SetFreeze_Fn tempNodes true

			)--if end
			)catch(
			messageBox "MasterSetを選択してから実行してください。" title:"エラー"
			editModeCb.checked = false
			editModeSuspend_Fn false
			modeFlag = 0
		)--try catch end
		)--if end
	tempNodes = #()
	)--end
	on editBodyChk changed state do
	(
		sj_functions.sj_SetHide_Fn MasterNodes.SpineSubAndDefNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineSubAndDefNodes state
		sj_functions.sj_SetHide_Fn MasterNodes.NecSubAndDefNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecSubAndDefNodes state		
	)
	on editArmChk changed state do
	(
		sj_functions.sj_SetHide_Fn MasterNodes.ArmSubAndDefNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ArmSubAndDefNodes state
	)
	on editLegChk changed state do
	(
		sj_functions.sj_SetHide_Fn MasterNodes.LegSubAndDefNodes  state
		sj_functions.sj_SetFreeze_Fn MasterNodes.LegSubAndDefNodes state
	)
	on editHandChk changed state do
	(
		tempNodes = #()
		for i in MasterNodes.Hand_RDefNodes do append tempNodes i
		for i in MasterNodes.Hand_LDefNodes do append tempNodes i
		sj_functions.sj_SetHide_Fn tempNodes state
		sj_functions.sj_SetFreeze_Fn tempNodes state
	)
-----------------------------------------------------------------------------------------------------------
--ボーン設定
-----------------------------------------------------------------------------------------------------------
	on boneNumSetBt pressed do
	(
max create mode
suspendEditing()--サスペンドモード
with redraw off (--再描画禁止
		--fn boneDuplicater_Fn boneArray splinePosArray x xBoneDup xSPnSet Apos Arot ix ux type=
		
		if MasterNodes.SpineBoneNodes.count != boneNumSpineSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x+1.0))
		--設定は2番目以降
		x = boneNumSpineSpn.value
		boneDuplicater_Fn MasterNodes.SpineBoneNodes MasterNodes.SpineSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x+1)) 2 -1 false
		)--if end
		if MasterNodes.NecBoneNodes.count != boneNumNeckSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x+1.0))
		--設定は2番目以降
		x = boneNumNeckSpn.value
		boneDuplicater_Fn MasterNodes.NecBoneNodes MasterNodes.NecSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x+1)) 2 -1 false
		)--if end
		
		--右上腕
		if MasterNodes.UpperArm_RBoneNodes.count != boneNumUpArmRSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x-1.0))
		--設定は3番目以降
		x = boneNumUpArmRSpn.value
		boneDuplicater_Fn MasterNodes.UpperArm_RBoneNodes MasterNodes.UpperArm_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1)) 3 -2 true
		)--if end
		--右前腕		
		if MasterNodes.ForeArm_RBoneNodes.count != boneNumForeArmRSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x))
		--設定は3番目以降
		x = boneNumForeArmRSpn.value
		boneDuplicater_Fn MasterNodes.ForeArm_RBoneNodes MasterNodes.ForeArm_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		)--if end
		
		--左上腕
		if MasterNodes.UpperArm_LBoneNodes.count != boneNumUpArmLSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x-1.0))
		--設定は3番目以降
		x = boneNumUpArmLSpn.value
		boneDuplicater_Fn MasterNodes.UpperArm_LBoneNodes MasterNodes.UpperArm_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1)) 3 -2 true
		)--if end
		--左前腕		
		if MasterNodes.ForeArm_LBoneNodes.count != boneNumForeArmLSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x))
		--設定は3番目以降
		x = boneNumForeArmLSpn.value
		boneDuplicater_Fn MasterNodes.ForeArm_LBoneNodes MasterNodes.ForeArm_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		)--if end

		--右大腿
		if MasterNodes.Thigh_RBoneNodes.count != boneNumThighRSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x-1.0))
		--設定は3番目以降
		x = boneNumThighRSpn.value
		boneDuplicater_Fn MasterNodes.Thigh_RBoneNodes MasterNodes.Thigh_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1))  3 -2 true
		)--if end
		--右脹ら脛		
		if MasterNodes.Calf_RBoneNodes.count != boneNumCalfRSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x))
		--設定は3番目以降
		x = boneNumCalfRSpn.value
		boneDuplicater_Fn MasterNodes.Calf_RBoneNodes MasterNodes.Calf_RSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		)--if end

		--左大腿
		if MasterNodes.Thigh_LBoneNodes.count != boneNumThighLSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x-1.0))
		--設定は3番目以降
		x = boneNumThighLSpn.value
		boneDuplicater_Fn MasterNodes.Thigh_LBoneNodes MasterNodes.Thigh_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x-1))  3 -2 true
		)--if end
		--左脹ら脛		
		if MasterNodes.Calf_LBoneNodes.count != boneNumCalfLSpn.value then
		(
		--骨の複製回数 x-1
		--スプラインの設定回数は x+1
		--位置設定値 (1.0/x)
		--回転設定値 (100.0/(x))
		--設定は3番目以降
		x = boneNumCalfLSpn.value
		boneDuplicater_Fn MasterNodes.Calf_LBoneNodes MasterNodes.Calf_LSplinePosNodes x (x-1) (x+1) (1.0/x) (100.0/(x)) 3 -2 false
		)--if end
		
		boneHeightSet_Fn()
	
		sj_functions.sj_SetHide_Fn MasterNodes.SpineSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.NecSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.UpperArm_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.ForeArm_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Thigh_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Calf_RSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.UpperArm_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.ForeArm_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Thigh_LSplinePosNodes false
		sj_functions.sj_SetHide_Fn MasterNodes.Calf_LSplinePosNodes false
			
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LSplinePosNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LSplinePosNodes false
			
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes false
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes false
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes false
		
);--with redraw end
resumeEditing()--再びアクティブに
	);--end
-----------------------------------------------------------------------------------------------------------
--自動設定
-----------------------------------------------------------------------------------------------------------
	on clavicleResetBt pressed do clavicleReset_Fn autoSetRChk.checked autoSetLChk.checked	
	on armAutoSetBt pressed do optimizeArm_Fn autoSetRChk.checked autoSetLChk.checked	
	on legAutoSetBt pressed do  optimizeLeg_Fn autoSetRChk.checked autoSetLChk.checked

-----------------------------------------------------------------------------------------------------------
--ボディ用 シンメトリー
-----------------------------------------------------------------------------------------------------------
	on symmetryBt pressed do
	(
			--arm
			if symmetryArmChk.checked then
			(
			------------------------------------------
			--mirror通常
			append mirrorTmR MasterNodes.ArmSubAndDefNodes[1].node
			append mirrorTmR MasterNodes.ArmSubAndDefNodes[7].node
			append mirrorTmR MasterNodes.ArmSubAndDefNodes[11].node
			append mirrorTmL MasterNodes.ArmSubAndDefNodes[2].node
			append mirrorTmL MasterNodes.ArmSubAndDefNodes[8].node
			append mirrorTmL MasterNodes.ArmSubAndDefNodes[12].node
			------------------------------------------
			--Xが反転
			append xFripR MasterNodes.ArmSubAndDefNodes[3].node
			append xFripR MasterNodes.ArmSubAndDefNodes[5].node
			append xFripL MasterNodes.ArmSubAndDefNodes[4].node
			append xFripL MasterNodes.ArmSubAndDefNodes[6].node
			------------------------------------------
			--ローカルzをコピーするだけ
			--R
			append localPosArrayR MasterNodes.ArmSubAndDefNodes[13].node
			append localPosArrayR MasterNodes.ArmSubAndDefNodes[15].node
			append localPosArrayR MasterNodes.ArmSubAndDefNodes[17].node
			append localPosArrayR MasterNodes.ArmSubAndDefNodes[19].node
			--L
			append localPosArrayL MasterNodes.ArmSubAndDefNodes[14].node
			append localPosArrayL MasterNodes.ArmSubAndDefNodes[16].node
			append localPosArrayL MasterNodes.ArmSubAndDefNodes[18].node
			append localPosArrayL MasterNodes.ArmSubAndDefNodes[20].node
			)--if end
			if symmetryLegChk.checked then
			(
			------------------------------------------
			--mirror通常
			append mirrorTmR MasterNodes.LegSubAndDefNodes[1].node
			append mirrorTmR MasterNodes.LegSubAndDefNodes[9].node
			append mirrorTmL MasterNodes.LegSubAndDefNodes[2].node
			append mirrorTmL MasterNodes.LegSubAndDefNodes[10].node
			------------------------------------------
			--Xが反転
			append xFripR MasterNodes.LegSubAndDefNodes[3].node
			append xFripR MasterNodes.LegSubAndDefNodes[5].node
			append xFripR MasterNodes.LegSubAndDefNodes[7].node
			append xFripR MasterNodes.LegSubAndDefNodes[11].node
			append xFripL MasterNodes.LegSubAndDefNodes[4].node
			append xFripL MasterNodes.LegSubAndDefNodes[6].node
			append xFripL MasterNodes.LegSubAndDefNodes[8].node
			append xFripL MasterNodes.LegSubAndDefNodes[12].node
			------------------------------------------
			--ローカルzをコピーするだけ
			--R Leg
			append localPosArrayR MasterNodes.LegSubAndDefNodes[13].node
			append localPosArrayR MasterNodes.LegSubAndDefNodes[15].node
			append localPosArrayR MasterNodes.LegSubAndDefNodes[17].node
			append localPosArrayR MasterNodes.LegSubAndDefNodes[19].node
			append localPosArrayR MasterNodes.LegSubAndDefNodes[21].node
			--L
			append localPosArrayL MasterNodes.LegSubAndDefNodes[14].node
			append localPosArrayL MasterNodes.LegSubAndDefNodes[16].node
			append localPosArrayL MasterNodes.LegSubAndDefNodes[18].node
			append localPosArrayL MasterNodes.LegSubAndDefNodes[20].node
			append localPosArrayL MasterNodes.LegSubAndDefNodes[22].node
			)--if end
			if symmetryHandChk.checked then
			(
			------------------------------------------
			--mirror通常
			append mirrorTmR MasterNodes.Hand_RDefNodes[3].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[5].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[7].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[11].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[13].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[15].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[19].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[21].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[23].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[27].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[29].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[35].node
			append mirrorTmR MasterNodes.Hand_RDefNodes[37].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[3].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[5].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[7].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[11].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[13].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[15].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[19].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[21].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[23].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[27].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[29].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[35].node
			append mirrorTmL MasterNodes.Hand_LDefNodes[37].node
			------------------------------------------
			--Local pos z copy
			--R Hand
			--append localPosArrayR MasterNodes.Hand_RDefNodes[2].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[4].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[6].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[8].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[10].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[12].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[14].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[16].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[18].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[20].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[22].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[24].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[26].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[28].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[30].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[32].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[34].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[36].node
			append localPosArrayR MasterNodes.Hand_RDefNodes[38].node
			--L
			--append localPosArrayL MasterNodes.Hand_LDefNodes[2].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[4].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[6].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[8].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[10].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[12].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[14].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[16].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[18].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[20].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[22].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[24].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[26].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[28].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[30].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[32].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[34].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[36].node
			append localPosArrayL MasterNodes.Hand_LDefNodes[38].node
			--L Hand
			)--if end
			
			case typeRob.state of
			(
			1:(boneSymmetry_Fn symmetryArmChk.checked symmetryLegChk.checked symmetryHandChk.checked true localPosArrayR localPosArrayL xFripR xFripL mirrorTmR mirrorTmL)
			2:(boneSymmetry_Fn symmetryArmChk.checked symmetryLegChk.checked symmetryHandChk.checked false localPosArrayL localPosArrayR xFripL xFripR mirrorTmL mirrorTmR)
			) --case end
		 localPosArrayR = #(); localPosArrayL = #()
	)	
-----------------------------------------------------------------------------------------------------------
--ボディ用 All Size
-----------------------------------------------------------------------------------------------------------
	on allSizeBt pressed do
	(
		if allSizeSpn.value != 100 do
		(
		RatioTemp = allSizeSpn.value / 100
		
		tempNodes = #()
		append tempNodes MasterNodes.SpineSubAndDefNodes[1]
		append tempNodes MasterNodes.SpineSubAndDefNodes[2]
		append tempNodes MasterNodes.SpineSubAndDefNodes[3]
		append tempNodes MasterNodes.SpineSubAndDefNodes[4]
		append tempNodes MasterNodes.SpineSubAndDefNodes[5]
		append tempNodes MasterNodes.SpineSubAndDefNodes[6]
		append tempNodes MasterNodes.SpineSubAndDefNodes[7]
		append tempNodes MasterNodes.SpineSubAndDefNodes[8]
		
		append tempNodes MasterNodes.NecSubAndDefNodes[1]
		append tempNodes MasterNodes.NecSubAndDefNodes[2]
		append tempNodes MasterNodes.NecSubAndDefNodes[3]
		append tempNodes MasterNodes.NecSubAndDefNodes[4]
		append tempNodes MasterNodes.NecSubAndDefNodes[5]
		append tempNodes MasterNodes.NecSubAndDefNodes[6]

		append tempNodes MasterNodes.ArmSubAndDefNodes[1]
		append tempNodes MasterNodes.ArmSubAndDefNodes[2]
		append tempNodes MasterNodes.ArmSubAndDefNodes[3]
		append tempNodes MasterNodes.ArmSubAndDefNodes[4]
		append tempNodes MasterNodes.ArmSubAndDefNodes[5]
		append tempNodes MasterNodes.ArmSubAndDefNodes[6]
		append tempNodes MasterNodes.ArmSubAndDefNodes[13]
		append tempNodes MasterNodes.ArmSubAndDefNodes[14]
		append tempNodes MasterNodes.ArmSubAndDefNodes[15]
		append tempNodes MasterNodes.ArmSubAndDefNodes[16]
		append tempNodes MasterNodes.ArmSubAndDefNodes[17]
		append tempNodes MasterNodes.ArmSubAndDefNodes[18]

		append tempNodes MasterNodes.LegSubAndDefNodes[1]
		append tempNodes MasterNodes.LegSubAndDefNodes[2]
		append tempNodes MasterNodes.LegSubAndDefNodes[3]
		append tempNodes MasterNodes.LegSubAndDefNodes[4]
		append tempNodes MasterNodes.LegSubAndDefNodes[5]
		append tempNodes MasterNodes.LegSubAndDefNodes[6]
		append tempNodes MasterNodes.LegSubAndDefNodes[7]
		append tempNodes MasterNodes.LegSubAndDefNodes[8]

		append tempNodes MasterNodes.LegSubAndDefNodes[13]
		append tempNodes MasterNodes.LegSubAndDefNodes[14]
		append tempNodes MasterNodes.LegSubAndDefNodes[15]
		append tempNodes MasterNodes.LegSubAndDefNodes[16]

		--Hand
		append tempNodes MasterNodes.Hand_RDefNodes[1]
		append tempNodes MasterNodes.Hand_RDefNodes[2]
		append tempNodes MasterNodes.Hand_RDefNodes[4]
		append tempNodes MasterNodes.Hand_RDefNodes[6]
		append tempNodes MasterNodes.Hand_RDefNodes[7]
		append tempNodes MasterNodes.Hand_RDefNodes[8]
		append tempNodes MasterNodes.Hand_RDefNodes[10]
		append tempNodes MasterNodes.Hand_RDefNodes[12]
		append tempNodes MasterNodes.Hand_RDefNodes[14]
		append tempNodes MasterNodes.Hand_RDefNodes[15]
		append tempNodes MasterNodes.Hand_RDefNodes[16]
		append tempNodes MasterNodes.Hand_RDefNodes[18]
		append tempNodes MasterNodes.Hand_RDefNodes[20]
		append tempNodes MasterNodes.Hand_RDefNodes[22]	
		append tempNodes MasterNodes.Hand_RDefNodes[23]
		append tempNodes MasterNodes.Hand_RDefNodes[24]
		append tempNodes MasterNodes.Hand_RDefNodes[26]
		append tempNodes MasterNodes.Hand_RDefNodes[28]
		append tempNodes MasterNodes.Hand_RDefNodes[30]	
		append tempNodes MasterNodes.Hand_RDefNodes[31]
		append tempNodes MasterNodes.Hand_RDefNodes[32]
		append tempNodes MasterNodes.Hand_RDefNodes[34]
		append tempNodes MasterNodes.Hand_RDefNodes[36]
		append tempNodes MasterNodes.Hand_RDefNodes[38]
		append tempNodes MasterNodes.Hand_LDefNodes[1]
		append tempNodes MasterNodes.Hand_LDefNodes[2]
		append tempNodes MasterNodes.Hand_LDefNodes[4]
		append tempNodes MasterNodes.Hand_LDefNodes[6]
		append tempNodes MasterNodes.Hand_LDefNodes[7]
		append tempNodes MasterNodes.Hand_LDefNodes[8]
		append tempNodes MasterNodes.Hand_LDefNodes[10]
		append tempNodes MasterNodes.Hand_LDefNodes[12]
		append tempNodes MasterNodes.Hand_LDefNodes[14]
		append tempNodes MasterNodes.Hand_LDefNodes[15]
		append tempNodes MasterNodes.Hand_LDefNodes[16]
		append tempNodes MasterNodes.Hand_LDefNodes[18]
		append tempNodes MasterNodes.Hand_LDefNodes[20]
		append tempNodes MasterNodes.Hand_LDefNodes[22]
		append tempNodes MasterNodes.Hand_LDefNodes[23]
		append tempNodes MasterNodes.Hand_LDefNodes[24]
		append tempNodes MasterNodes.Hand_LDefNodes[26]
		append tempNodes MasterNodes.Hand_LDefNodes[28]
		append tempNodes MasterNodes.Hand_LDefNodes[30]
		append tempNodes MasterNodes.Hand_LDefNodes[31]
		append tempNodes MasterNodes.Hand_LDefNodes[32]
		append tempNodes MasterNodes.Hand_LDefNodes[34]
		append tempNodes MasterNodes.Hand_LDefNodes[36]
		append tempNodes MasterNodes.Hand_LDefNodes[38]
		
		--SoftIK値を設定
		tempB = 0
		tempB = MasterNodes.ControlNodes[6].node.modifiers[#Control].ArmSet.SoftIKLimit * RatioTemp
		MasterNodes.ControlNodes[6].node.modifiers[#Control].ArmSet.SoftIKLimit = tempB
		MasterNodes.ControlNodes[6].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = tempB

		tempB = 0
		tempB = MasterNodes.ControlNodes[7].node.modifiers[#Control].ArmSet.SoftIKLimit * RatioTemp
		MasterNodes.ControlNodes[7].node.modifiers[#Control].ArmSet.SoftIKLimit = tempB
		MasterNodes.ControlNodes[7].node.modifiers[#Control].ArmSet.SoftIKNumSetting[1] = tempB
		
		tempB = 0
		tempB = MasterNodes.ControlNodes[12].node.modifiers[#Control].LegSet.SoftIKLimit * RatioTemp
		MasterNodes.ControlNodes[12].node.modifiers[#Control].LegSet.SoftIKLimit = tempB
		MasterNodes.ControlNodes[12].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] = tempB

		tempB = 0
		tempB = MasterNodes.ControlNodes[13].node.modifiers[#Control].LegSet.SoftIKLimit * RatioTemp
		MasterNodes.ControlNodes[13].node.modifiers[#Control].LegSet.SoftIKLimit = tempB
		MasterNodes.ControlNodes[13].node.modifiers[#Control].LegSet.SoftIKNumSetting[1] = tempB
		
		tempB = 0
		allDefPosSize_Fn tempNodes RatioTemp
		--めんどくさいからスライダータイムで描画更新
		sliderTime = sliderTime + 1
		sliderTime = sliderTime - 1
		
		--ToeTopの位置を設定、描画更新後でないと調子が悪い
		MasterNodes.LegSubAndDefNodes[11].node.pos = MasterNodes.LegSubAndDefNodes[1].node.pos
		MasterNodes.LegSubAndDefNodes[12].node.pos = MasterNodes.LegSubAndDefNodes[2].node.pos

		--SingleFoot
		MasterNodes.LegSubAndDefNodes[17].node.pos = MasterNodes.LegSubAndDefNodes[1].node.pos
		MasterNodes.LegSubAndDefNodes[18].node.pos = MasterNodes.LegSubAndDefNodes[2].node.pos
		
		--DubleFoot
		in coordsys parent MasterNodes.ArmSubAndDefNodes[19].node.pos.z = (in coordsys parent MasterNodes.ArmSubAndDefNodes[20].node.pos.z) * RatioTemp
		in coordsys parent MasterNodes.ArmSubAndDefNodes[20].node.pos.z = (in coordsys parent MasterNodes.ArmSubAndDefNodes[20].node.pos.z) * RatioTemp
		in coordsys parent MasterNodes.LegSubAndDefNodes[19].node.pos.z = (in coordsys parent MasterNodes.LegSubAndDefNodes[19].node.pos.z) * RatioTemp
		in coordsys parent MasterNodes.LegSubAndDefNodes[20].node.pos.z = (in coordsys parent MasterNodes.LegSubAndDefNodes[20].node.pos.z) * RatioTemp
		in coordsys parent MasterNodes.LegSubAndDefNodes[21].node.pos.z = (in coordsys parent MasterNodes.LegSubAndDefNodes[21].node.pos.z) * RatioTemp
		in coordsys parent MasterNodes.LegSubAndDefNodes[22].node.pos.z = (in coordsys parent MasterNodes.LegSubAndDefNodes[22].node.pos.z) * RatioTemp
		
		--MasterNodes.OffSetPos = MasterNodes.OffSetPos * RatioTemp
		
		--ボーンの長さを設定
		boneHeightSet_Fn ()
		
		clavicleReset_Fn true true
		
		tempNodes = #()
		allSizeSpn.value = 100

		)--if end
	)
-----------------------------------------------------------------------------------------------------------
--ボディ用 ボーンサイズ
-----------------------------------------------------------------------------------------------------------
	on boneSizeEditCb changed state do
	(
		sj_functions.sj_SetFreeze_Fn MasterNodes.MainBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.SubBoneNodes state
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes state
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes state
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes state
	)--on end
	on boneLengthSpn changed state do
	(
		try(
			for i = 1 to selection.count do selection[i].length = state
		)catch()
	)--button end
	on boneWidthSpn changed state do
	(
		try(
			for i = 1 to selection.count do selection[i].width = state
		)catch()
	)--end
	on boneAllSizeBt pressed do
	(
		RatioTemp = boneAllSizeSpn.value / 100
		allBoneSize_Fn MasterNodes.MainBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.SubBoneNodes RatioTemp
		
		allBoneSize_Fn MasterNodes.SpineBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.NecBoneNodes RatioTemp
		
		allBoneSize_Fn MasterNodes.UpperArm_RBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.ForeArm_RBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Thigh_RBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Calf_RBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Hand_RBoneNodes RatioTemp
	
		allBoneSize_Fn MasterNodes.UpperArm_LBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.ForeArm_LBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Thigh_LBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Calf_LBoneNodes RatioTemp
		allBoneSize_Fn MasterNodes.Hand_LBoneNodes RatioTemp
		
		boneAllSizeSpn.value = 100
	)--on end
	on boneHeightSetBt pressed do boneHeightSet_Fn()

-----------------------------------------------------------------------------------------------------------
--ボディ用ファンクション Edit Ctrl
-----------------------------------------------------------------------------------------------------------
	on ctrlEditModeCb changed state do
	(
		try(
			subobjectLevel = 0
			max select --セレクトモードにする
			modPanel.setCurrentObject selection[1].modifiers[#Control]
		)catch()
	
		if state then
		(
			sj_body_rol.setKeyModeFalse_Fn state
		try(
			max modify mode --編集モードにする
			modPanel.setCurrentObject selection[1].baseObject
			subobjectLevel = 3
			splineOps.selectByID $
			toolMode.uniformScale()
			toolMode.coordsys #parent
			toolMode.transformCenter()
		)catch(messageBox ("編集できません")title:"エラー"
			ctrlEditModeCb.state = false)
		)	
	)--end

)

-----------------------------------------------------------------------------------------------------------
--フェイシャル
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--フェイシャルロールアウト
--////////////////////////////////////////////////
rollout sj_face_rol "フェイシャル" width:356 height:470
(

)--face rol end

-----------------------------------------------------------------------------------------------------------
--カスタム
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--カスタム
--////////////////////////////////////////////////
rollout sj_custom_rol "カスタム" width:320 height:470
(
	Local delIndex = #()
	GroupBox editModeGrp "Test" pos:[8,4] width:336 height:376
	checkbutton editModeCb "" pos:[16,20] width:200 height:20
	button c1Bt "1" pos:[16,48] width:96 height:20 enabled:true
	button c1bBt "1Bone" pos:[120,48] width:96 height:20 enabled:true
	button c1cBt "1CNT" pos:[16,72] width:96 height:20 enabled:true
	button c1rBt "1R" pos:[16,96] width:96 height:20 enabled:true
	button c1lBt "1L" pos:[120,96] width:96 height:20 enabled:true
	button c2Bt "2" pos:[16,120] width:96 height:20 enabled:true
	button c2bBt "2Bone" pos:[120,120] width:96 height:20 enabled:true
	button c2cBt "2CNT" pos:[16,144] width:96 height:20 enabled:true
	button c2rBt "2R" pos:[16,168] width:96 height:20 enabled:true
	button c2lBt "2L" pos:[120,168] width:96 height:20 enabled:true
	button c3Bt "3" pos:[16,192] width:96 height:20 enabled:true
	button c3bBt "3Bone" pos:[120,192] width:96 height:20 enabled:true
	button c3cBt "3CNT" pos:[16,216] width:96 height:20 enabled:true
	button c3rBt "3R" pos:[16,240] width:96 height:20 enabled:true
	button c3lBt "3L" pos:[120,240] width:96 height:20 enabled:true
	button c4Bt "4" pos:[16,264] width:96 height:20 enabled:true
	button c4bBt "4Bone" pos:[120,264] width:96 height:20 enabled:true
	button c4cBt "4CNT" pos:[16,288] width:96 height:20 enabled:true
	button c4rBt "4R" pos:[16,312] width:96 height:20 enabled:true
	button c4lBt "4L" pos:[120,312] width:96 height:20 enabled:true
	button cleanUpBt "クリーンアップ" pos:[16,336] width:96 height:20 enabled:true
	button checkBt "チェック" pos:[120,336] width:96 height:20 enabled:true
-----------------------------------------------------------------------------------------------------------
--Custom用ファンクション
-----------------------------------------------------------------------------------------------------------
	on cleanUpBt pressed do
	(
		delIndex = #()
		for i=1 to $CustomNodes.Custom01Nodes.count do
		(if not isvalidnode $CustomNodes.Custom01Nodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom01Nodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom01BoneNodes.count do
		(if not isvalidnode $CustomNodes.Custom01BoneNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom01BoneNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom01ControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom01ControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom01ControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom01_RControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom01_RControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom01_RControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom01_LControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom01_LControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom01_LControlNodes delIndex[k];
			k -= 1;
		);
		---------------------------------
		delIndex = #()
		for i=1 to $CustomNodes.Custom02Nodes.count do
		(if not isvalidnode $CustomNodes.Custom02Nodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom02Nodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom02BoneNodes.count do
		(if not isvalidnode $CustomNodes.Custom02BoneNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom02BoneNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom02ControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom02ControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom02ControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom02_RControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom02_RControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom02_RControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom02_LControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom02_LControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom02_LControlNodes delIndex[k];
			k -= 1;
		);
		---------------------------------
		delIndex = #()
		for i=1 to $CustomNodes.Custom03Nodes.count do
		(if not isvalidnode $CustomNodes.Custom03Nodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom03Nodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom03BoneNodes.count do
		(if not isvalidnode $CustomNodes.Custom03BoneNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom03BoneNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom03ControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom03ControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom03ControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom03_RControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom03_RControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom03_RControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom03_LControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom03_LControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom03_LControlNodes delIndex[k];
			k -= 1;
		);
		---------------------------------
		delIndex = #()
		for i=1 to $CustomNodes.Custom04Nodes.count do
		(if not isvalidnode $CustomNodes.Custom04Nodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom04Nodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom04BoneNodes.count do
		(if not isvalidnode $CustomNodes.Custom04BoneNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom04BoneNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom04ControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom04ControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom04ControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom04_RControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom04_RControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom04_RControlNodes delIndex[k];
			k -= 1;
		);
		delIndex = #()
		for i=1 to $CustomNodes.Custom04_LControlNodes.count do
		(if not isvalidnode $CustomNodes.Custom04_LControlNodes[i].node then append delIndex i)
		k = delIndex.count;
		while k > 0 do
		(
			deleteItem $CustomNodes.Custom04_LControlNodes delIndex[k];
			k -= 1;
		);
		---------------------------------
	)
	on checkBt pressed do
	(
		for i in $CustomNodes.Custom01Nodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom01Nodes"
		)
		for i in $CustomNodes.Custom01BoneNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom01BoneNodes"
		)
		for i in $CustomNodes.Custom01ControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom01ControlNodes"
		)
		for i in $CustomNodes.Custom01_RControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom01_RControlNodes"
		)
		for i in $CustomNodes.Custom01_LControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom01_LControlNodes"
		)
		--------------
		for i in $CustomNodes.Custom02Nodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom02Nodes"
		)
		for i in $CustomNodes.Custom02BoneNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom02BoneNodes"
		)
		for i in $CustomNodes.Custom02ControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom02ControlNodes"
		)
		for i in $CustomNodes.Custom02_RControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom02_RControlNodes"
		)
		for i in $CustomNodes.Custom02_LControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom02_LControlNodes"
		)
		--------------
		for i in $CustomNodes.Custom03Nodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom03Nodes"
		)
		for i in $CustomNodes.Custom03BoneNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom03BoneNodes"
		)
		for i in $CustomNodes.Custom03ControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom03ControlNodes"
		)
		for i in $CustomNodes.Custom03_RControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom03_RControlNodes"
		)
		for i in $CustomNodes.Custom03_LControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom03_LControlNodes"
		)
		--------------
		for i in $CustomNodes.Custom04Nodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom04Nodes"
		)
		for i in $CustomNodes.Custom04BoneNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom04BoneNodes"
		)
		for i in $CustomNodes.Custom04ControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom04ControlNodes"
		)
		for i in $CustomNodes.Custom04_RControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom04_RControlNodes"
		)
		for i in $CustomNodes.Custom04_LControlNodes do
		(
		print i.node
		if not isvalidnode i.node then messageBox "undefined node in \nCustom04_LControlNodes"
		)
	)
	
	on c1Bt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom01Nodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c1bBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom01BoneNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c1cBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom01ControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c1rBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom01_RControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c1lBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom01_LControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)

	on c2Bt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom02Nodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c2bBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom02BoneNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c2cBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom02ControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c2rBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom02_RControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c2lBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom02_LControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)

	on c3Bt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom03Nodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c3bBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom03BoneNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c3cBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom03ControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c3rBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom03_RControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c3lBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom03_LControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)

	on c4Bt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom04Nodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c4bBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom04BoneNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c4cBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom04ControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c4rBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom04_RControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)
	on c4lBt pressed do
	(
		for i=1 to selection.count do
		(
		append $CustomNodes.Custom04_LControlNodes (nodeTransformMonitor node:selection[i] forwardTransformChangeMsgs:false)
		)--for end
	)

)--custom rol end


rollout sj_adjuster_rol nameAndVersion width:360 height:540
(

subRollout theSubRollout pos:[0,36] width:360 height:495
	button adjusterTabsBody "Body" pos:[0,8] width:63 height:24;
	button adjusterTabsFace "Face" pos:[64,8] width:63 height:24;
	button adjusterTabsCustom "Custom" pos:[128,8] width:63 height:24;
		
--タブ
--activeXcontrol menuTabs "MSComctlLib.TabStrip.2" height:20

--タブ切り替えアクション
	on adjusterTabsBody pressed do
		(
		removeSubRollout theSubRollout sj_face_rol
		removeSubRollout theSubRollout sj_custom_rol
		addSubRollout theSubRollout sj_body_rol 
		)--on end
	on adjusterTabsFace pressed do
		(
		removeSubRollout theSubRollout sj_body_rol
		removeSubRollout theSubRollout sj_custom_rol
		addSubRollout theSubRollout sj_face_rol 
		)--on end
	on adjusterTabsCustom pressed do
		(
		removeSubRollout theSubRollout sj_body_rol
		removeSubRollout theSubRollout sj_face_rol
		addSubRollout theSubRollout sj_custom_rol
		)--on end

	
/*	
on menuTabs Click do
(
	--タブメニュー
	case menuTabs.SelectedItem.index of
	(
		1:
		(
		removeSubRollout theSubRollout sj_face_rol
		removeSubRollout theSubRollout sj_custom_rol
		addSubRollout theSubRollout sj_body_rol 
		)--case 1 end
		2:
		(
		removeSubRollout theSubRollout sj_body_rol
		removeSubRollout theSubRollout sj_custom_rol
		addSubRollout theSubRollout sj_face_rol 
		)--case 2 end
		3:
		(
		removeSubRollout theSubRollout sj_body_rol
		removeSubRollout theSubRollout sj_face_rol
		addSubRollout theSubRollout sj_custom_rol
		)--case 2 end
	)--case end
);
*/

on sj_adjuster_rol open do
(
--menuTabs.tabs[1].caption = "ボディ"
--menuTabs.tabs.add pvCaption:"フェイシャル"
--menuTabs.tabs.add pvCaption:"カスタム"
--menuTabs.Image = images:#("$Scripts/SJTools/Images//SJ_button_pose.gif", "$Scripts/SJTools/Images//SJ_button_pose_a.gif", 2, 1, 1, 2, 2);
);


on sj_adjuster_rol close do
(
	
--強制終了に備える
if modeFlag > 0 then
(
sj_body_rol.setKeyModeFalse_Fn false
	set animate off
	AnimButtonEnabled = true
	maxOps.setKeyMode = false
	maxOps.setKeySuspend = false
	maxOps.setSetKeyFilterState #all false
	maxOps.setSetKeyFilterState #position true
	maxOps.setSetKeyFilterState #rotation true
	maxOps.setSetKeyFilterState #scale false
	maxOps.setSetKeyFilterState #ikParams false
	maxOps.setSetKeyFilterState #objParams false
	maxOps.setSetKeyFilterState #custAttribs true
	maxOps.setSetKeyFilterState #modifiers false
	maxOps.setSetKeyFilterState #materials false
	maxOps.setSetKeyFilterState #other true
		try(
		tempNodes = #()
		for i in MasterNodes.SpineSubAndDefNodes do append tempNodes i
		for i in MasterNodes.NecSubAndDefNodes do append tempNodes i
		for i in MasterNodes.ArmSubAndDefNodes do append tempNodes i
		for i in MasterNodes.LegSubAndDefNodes do append tempNodes i
		for i in MasterNodes.Hand_RDefNodes do append tempNodes i
		for i in MasterNodes.Hand_LDefNodes do append tempNodes i
		sj_functions.sj_SetHide_Fn tempNodes false
		sj_functions.sj_SetFreeze_Fn tempNodes false
		sj_functions.sj_SetFreeze_Fn MasterNodes.MainBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.SubBoneNodes state
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.SpineBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.NecBoneNodes state
		
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_RBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_RBoneNodes state
	
		sj_functions.sj_SetFreeze_Fn MasterNodes.UpperArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.ForeArm_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Thigh_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Calf_LBoneNodes state
		sj_functions.sj_SetFreeze_Fn MasterNodes.Hand_LBoneNodes state
		)catch()
messageBox "編集モードを終了します！" title:"警告"
gc()

)--if end
)--on end
--////////////////////////////////////////////////
--End
--////////////////////////////////////////////////
)-- ロールアウト終了

createDialog sj_adjuster_rol menu:adjusterMenuBar /*bgColor:[0,0,0]*/ style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;
addSubRollout sj_adjuster_rol.theSubRollout sj_body_rol

)
