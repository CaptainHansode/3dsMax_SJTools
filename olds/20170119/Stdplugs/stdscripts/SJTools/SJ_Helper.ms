/*******************************************************
System J Tools 
********************************************************
Name:SJ_Helper
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

plugin Helper SJ_Helper
name:"SJ Helper"
classID:#(0x48114aa, 0x76ba2190)
category:"SJTools"
extends:dummy
version:1.08--バージョン管理

(
	--メッシュのサイズとメッシュ自身の変数
	Local lastSize, meshObj
	
	--Version etc

	parameters SJ_HelperParam rollout:setting_rol
	(
		--Prifix
		PrefixName type:#string default:""
		--マスター
		MasterNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--スキンオブジェクト
		SkinObjectNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--コントローラー
		ControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--サブコントローラー表示非表示用、純粋にサブコントローラーノードのみ
		SpineSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		NecSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ArmSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		LegSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Hand_RSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Hand_LSubControlNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--デフォーム表示非表示用、純粋にデフォームに使うノードのみ
		SpineDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		NecDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ArmDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		LegDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--手だけは兼用
		Hand_RDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Hand_LDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--ボーン
		MainBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		SubBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		SpineBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		NecBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		UpperArm_RBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ForeArm_RBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Thigh_RBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Calf_RBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Hand_RBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		UpperArm_LBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ForeArm_LBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Thigh_LBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Calf_LBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Hand_LBoneNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--SplinePos
		SpineSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		NecSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		UpperArm_RSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ForeArm_RSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Thigh_RSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Calf_RSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		UpperArm_LSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ForeArm_LSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Thigh_LSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		Calf_LSplinePosNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		

		/***********別オブジェクト管理***********/
		--その他
		AllOtherNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		--カスタム
		AllCustomNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		
		--デフォームとサブコントローラーデフォーム時に使用
		/***********ここれはCollectには含まない***********/
		SpineSubAndDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		NecSubAndDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		ArmSubAndDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		LegSubAndDefNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
		/***********ここれはCollectには含まない***********/

		--NomalCtrl
		NomalHideSet type:#boolean animatable:false ui:hideSetNomCkb
		--SkinObj
		SkinObjHideSet type:#boolean animatable:false ui:hideSetModCkb
		--Bone
		BoneHideSet type:#boolean animatable:false ui:hideSetBoneCkb
		--Cutom01Ctrl
		Custom01CtrlHideSet type:#boolean animatable:false ui:hideSetCtm01Ckb
		--Cutom02Ctrl
		Custom02CtrlHideSet type:#boolean animatable:false ui:hideSetCtm02Ckb
		--Cutom03Ctrl
		Custom03CtrlHideSet type:#boolean animatable:false ui:hideSetCtm03Ckb
		--Cutom04Ctrl
		Custom04CtrlHideSet type:#boolean animatable:false ui:hideSetCtm04Ckb
		--スケールアニメーションフラグ
		ScaleAnimSet type:#boolean animatable:false ui:scaleAnimSetCkb
		--カラーパレット用
		ColorSet type:#color animatable:false ui:colorSetCp default:[0,169,255]
		--オフセット位置用
		Size type:#float animatable:false ui:size --default:40.0
		OffSetPos type:#float animatable:true ui:offSetPosSpn default:100.0
		
	)--end param

	rollout setting_rol "Setting"
	(
	--////////////////////////////////////////////////
	--ローカル変数
	--////////////////////////////////////////////////
		Local allNodes = #(), picObj = undefined, tempNodes = #(), selectIndexTemp = #(1,2,6,7,8,9,12,13,14,15), imagePass = "$Scripts/SJTools/Images//"
	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
	--表示
		GroupBox prefixGrp "Prefix" pos:[4,8] width:185 height:40
		edittext prefix "" pos:[8,24] width:124 height:16 bold:false text:PrefixName
		GroupBox hideSetGrp "表示 / 非表示" pos:[4,56] width:185 height:116
		checkbutton hideSetNomCkb "ノーマル" pos:[12,72] width:120 height:20 checked:false
		checkbutton hideSetModCkb "モデル" pos:[12,96] width:56 height:20 checked:false
		checkbutton hideSetBoneCkb "ボーン" pos:[76,96] width:56 height:20 checked:false
		checkbutton hideSetCtm01Ckb "カスタム1" pos:[12,120] width:56 height:20 checked:false
		checkbutton hideSetCtm02Ckb "カスタム2" pos:[76,120] width:56 height:20 checked:false
		checkbutton hideSetCtm03Ckb "カスタム3" pos:[12,144] width:56 height:20 checked:false
		checkbutton hideSetCtm04Ckb "カスタム4" pos:[76,144] width:56 height:20 checked:false

		GroupBox selGrp "セレクト" pos:[4,180] width:185 height:116
		button allSelBt "全て" pos:[12,196] width:120 height:20 checked:false
		button allMoveBt "全移動" pos:[12,220] width:56 height:20 checked:false
		button boneSelBt "ボーン" pos:[76,220] width:56 height:20 checked:false
		button ctm01SelBt "カスタム1" pos:[12,244] width:56 height:20 checked:false
		button ctm02SelBt "カスタム2" pos:[76,244] width:56 height:20 checked:false
		button ctm03SelBt "カスタム3" pos:[12,268] width:56 height:20 checked:false
		button ctm04SelBt "カスタム4" pos:[76,268] width:56 height:20 checked:false
		
		GroupBox optionGrp "オプション" pos:[4,304] width:185 height:120
		dropDownList ddl1 "" pos:[12,320] width:120 height:22 items:#("カスタム区分", "カスタム 1 - 4", "カスタム 5 - 8", "カスタム 9 - 12") enabled:false
		checkbutton scaleAnimSetCkb "スケール On / Off" pos:[12,348] width:120 height:20 enabled:false
		button convertFkBt "コンバートFK" pos:[12,372] width:120 height:20 enabled:false
		button deleteBt "削除" pos:[12,396] width:120 height:20

		GroupBox modelGrp "モデル" pos:[4,432] width:185 height:180
		checkbutton addListCkb "" pos:[12,448] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.gif", "$Scripts/SJTools/Images//SJ_button_add_a.gif", 2, 1, 1, 2, 2)
		button selAllListBt "" pos:[36,448] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allsel.gif", "$Scripts/SJTools/Images//SJ_button_allsel_a.gif", 2, 1, 1, 2, 2)
		button delListBt "" pos:[60,448] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.gif", "$Scripts/SJTools/Images//SJ_button_delete_a.gif", 2, 1, 1, 2, 2)
		colorPicker colorSetCp "" pos:[112,452] width:20 height:16 color:[0,169,255]
		listbox modelList "" pos:[12,472] width:120 height:10
		
		GroupBox sizeOffsetGrp "サイズ / オフセット" pos:[4,620] width:185 height:40
		spinner size "" pos:[12,636] width:56 height:16 range:[-1e+008,1e+008,40]
		spinner offSetPosSpn "" pos:[76,636] width:56 height:16 range:[-1e+008,1e+008,100]

	--////////////////////////////////////////////////
	--ファンクションとか
	--////////////////////////////////////////////////
		fn warning01_Fn = messageBox"設定できません" title:"警告"
		fn warning02_Fn = queryBox"" title:"警告"

	--////////////////////////////////////////////////
	--すべてのnodeを格納
	--////////////////////////////////////////////////
		fn collectallNodes_Fn =
		(
			allNodes = #()

			--iはnodeの数だけnode内容をallnodeに格納
			for i in $.SkinObjectNodes do append allNodes i.node
			for i in $.MasterNodes do append allNodes i.node
			for i in $.AllOtherNodes do append allNodes i.node
			for i in $.AllCustomNodes do append allNodes i.node
			for i in $.ControlNodes do append allNodes i.node
			--SubCont
			for i in $.SpineSubControlNodes do append allNodes i.node
			for i in $.NecSubControlNodes do append allNodes i.node
			for i in $.ArmSubControlNodes do append allNodes i.node
			for i in $.LegSubControlNodes do append allNodes i.node
			for i in $.Hand_RSubControlNodes do append allNodes i.node
			for i in $.Hand_LSubControlNodes do append allNodes i.node
			--Def
			for i in $.SpineDefNodes do append allNodes i.node
			for i in $.NecDefNodes do append allNodes i.node
			for i in $.ArmDefNodes do append allNodes i.node
			for i in $.LegDefNodes do append allNodes i.node
			for i in $.Hand_RDefNodes do append allNodes i.node
			for i in $.Hand_LDefNodes do append allNodes i.node
			--Bones
			for i in $.MainBoneNodes do append allNodes i.node
			for i in $.SubBoneNodes do append allNodes i.node
			for i in $.SpineBoneNodes do append allNodes i.node
			for i in $.NecBoneNodes do append allNodes i.node

			for i in $.UpperArm_RBoneNodes do append allNodes i.node
			for i in $.ForeArm_RBoneNodes do append allNodes i.node
			for i in $.Thigh_RBoneNodes do append allNodes i.node
			for i in $.Calf_RBoneNodes do append allNodes i.node	
			for i in $.Hand_RBoneNodes do append allNodes i.node
	
			for i in $.UpperArm_LBoneNodes do append allNodes i.node
			for i in $.ForeArm_LBoneNodes do append allNodes i.node
			for i in $.Thigh_LBoneNodes do append allNodes i.node
			for i in $.Calf_LBoneNodes do append allNodes i.node	
			for i in $.Hand_LBoneNodes do append allNodes i.node
			--Spline
			for i in $.SpineSplinePosNodes do append allNodes i.node
			for i in $.NecSplinePosNodes do append allNodes i.node
			
			for i in $.UpperArm_RSplinePosNodes do append allNodes i.node
			for i in $.ForeArm_RSplinePosNodes do append allNodes i.node
			for i in $.Thigh_RSplinePosNodes do append allNodes i.node
			for i in $.Calf_RSplinePosNodes do append allNodes i.node
			
			for i in $.UpperArm_LSplinePosNodes do append allNodes i.node
			for i in $.ForeArm_LSplinePosNodes do append allNodes i.node
			for i in $.Thigh_LSplinePosNodes do append allNodes i.node
			for i in $.Calf_LSplinePosNodes do append allNodes i.node
			
			--
			for i in $.AllOtherNodes[1].node.SpineOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.NecOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.ArmOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.LegOtherNodes do append allNodes i.node
			
			for i in $.AllCustomNodes[1].node.Custom01Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01_LControlNodes do if isvalidnode i.node then append allNodes i.node
			
			for i in $.AllCustomNodes[1].node.Custom02Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02_LControlNodes do if isvalidnode i.node then append allNodes i.node
			
			for i in $.AllCustomNodes[1].node.Custom03Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03_LControlNodes do if isvalidnode i.node then append allNodes i.node

			for i in $.AllCustomNodes[1].node.Custom04Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04_LControlNodes do if isvalidnode i.node then append allNodes i.node
		)--fn end

	--////////////////////////////////////////////////
	--アップデート
	--////////////////////////////////////////////////
		fn update_Fn =
		(
			modelListArray = #()
			for i in SkinObjectNodes do
			(
				if isvalidnode i.node then append modelListArray i.node.name
			)
			--sort NodeNames
			--リストに追加する場合は配列で
			modelList.items = modelListArray
			
			--アイテムの数が0以上なら
			if modelListArray.count != 0 then
			(
			--無効なオブジェクトを除外
				for i in 1 to modelListArray.count do
				(
					if (isvalidnode SkinObjectNodes[i].node == false) then (deleteItem SkinObjectNodes i)
				)--for end
			)else SkinObjectNodes = #()
		)--fn end

	--////////////////////////////////////////////////
	--pickObject時のためのフィルター、nodeを除外する
	--////////////////////////////////////////////////
		fn pickFilter_Fn o = ((findItem allNodes o) == 0)

	--////////////////////////////////////////////////
	--アクション
	--////////////////////////////////////////////////
		on setting_rol open do update_Fn()
		on prefix entered newPrefix do
		(
			--SkinObjectが削除されていた場合に備え1度アップデート
			update_Fn()
			collectallNodes_Fn()
			--print allNodes
			--PrefixNameが空だった場合
			if PrefixName == "" then
			(
				for i in allNodes do--allNodesの数だけ
				(
					i.name = (newPrefix + (i.name))
				)--for end
				PrefixName = newPrefix
			)--if end
			--変更
			else
			(
				for i in allNodes do--allNodesの数だけ
				(
					i.name = replace i.name 1 PrefixName.count newPrefix
					--1文字目からPrefixName数目文字までnewPrefixで置換、空なら削除される
				)--for end
				PrefixName = newPrefix
			)--if end
			
			prefix.text = newPrefix
			update_Fn()
			allNodes = #()
		)--end on prefix
		
	--////////////////////////////////////////////////
	--表示非表示
	--////////////////////////////////////////////////
		--Nomal
		on hideSetNomCkb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn ControlNodes state
			sj_functions.sj_SetFreeze_Fn ControlNodes state
			--offの場合のみ
			if not state then	
			(
			sj_functions.sj_SetHide_Fn SpineSubControlNodes state;
			sj_functions.sj_SetHide_Fn NecSubControlNodes state;
			sj_functions.sj_SetHide_Fn ArmSubControlNodes state;
			sj_functions.sj_SetHide_Fn LegSubControlNodes state;
			sj_functions.sj_SetHide_Fn Hand_RSubControlNodes state;
			sj_functions.sj_SetHide_Fn Hand_LSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn SpineSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn NecSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn ArmSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn LegSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn Hand_RSubControlNodes state;
			sj_functions.sj_SetFreeze_Fn Hand_LSubControlNodes state;
			);--if end
			)catch()
			
			try(
			sj_functions.sj_SetHide_Fn $.MainBoneNodes
			)catch()
			
			try(
			if state then
			(
			unhide $.AllOtherNodes[1].node.ArmOtherNodes[13].node
			unhide $.AllOtherNodes[1].node.ArmOtherNodes[14].node
			unhide $.AllOtherNodes[1].node.LegOtherNodes[9].node
			unhide $.AllOtherNodes[1].node.LegOtherNodes[10].node
			freeze $.AllOtherNodes[1].node.ArmOtherNodes[13].node
			freeze $.AllOtherNodes[1].node.ArmOtherNodes[14].node
			freeze $.AllOtherNodes[1].node.LegOtherNodes[9].node
			freeze $.AllOtherNodes[1].node.LegOtherNodes[10].node
			)
			else(
			hide $.AllOtherNodes[1].node.ArmOtherNodes[13].node
			hide $.AllOtherNodes[1].node.ArmOtherNodes[14].node
			hide $.AllOtherNodes[1].node.LegOtherNodes[9].node
			hide $.AllOtherNodes[1].node.LegOtherNodes[10].node
			freeze $.AllOtherNodes[1].node.ArmOtherNodes[13].node
			freeze $.AllOtherNodes[1].node.ArmOtherNodes[14].node
			freeze $.AllOtherNodes[1].node.LegOtherNodes[9].node
			freeze $.AllOtherNodes[1].node.LegOtherNodes[10].node
			)
			)catch()
			
		)
		--Model
		on hideSetModCkb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn SkinObjectNodes state
			sj_functions.sj_SetFreeze_Fn SkinObjectNodes false
			)catch()
		)
		--Bone
		on hideSetBoneCkb changed state do
		(
			tempNodes = #()
			for i in $.MainBoneNodes do append tempNodes i			
			for i in $.SubBoneNodes do append tempNodes i			
			for i in $.SpineBoneNodes do append tempNodes i
			for i in $.NecBoneNodes do append tempNodes i
			
			for i in $.UpperArm_RBoneNodes do append tempNodes i
			for i in $.ForeArm_RBoneNodes do append tempNodes i
			for i in $.Thigh_RBoneNodes do append tempNodes i
			for i in $.Calf_RBoneNodes do append tempNodes i
			for i in $.Hand_RBoneNodes do append tempNodes i
			
			for i in $.UpperArm_LBoneNodes do append tempNodes i
			for i in $.ForeArm_LBoneNodes do append tempNodes i
			for i in $.Thigh_LBoneNodes do append tempNodes i
			for i in $.Calf_LBoneNodes do append tempNodes i
			for i in $.Hand_LBoneNodes do append tempNodes i

			for i in $.AllCustomNodes[1].node.Custom01BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom02BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom03BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom04BoneNodes do append tempNodes i
			try(
			sj_functions.sj_SetHide_Fn tempNodes state
			sj_functions.sj_SetFreeze_Fn tempNodes false
			)catch()
			tempNodes = #()
		)
		--custom1
		on hideSetCtm01Ckb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom01ControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom01ControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom01_RControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom01_RControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom01_LControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom01_LControlNodes state
			)catch()
		)
		--custom2
		on hideSetCtm02Ckb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom02ControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom02ControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom02_RControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom02_RControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom02_LControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom02_LControlNodes state
			)catch()
		)
		--custom3
		on hideSetCtm03Ckb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom03ControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom03ControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom03_RControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom03_RControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom03_LControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom03_LControlNodes state
			)catch()
		)
		--custom4
		on hideSetCtm04Ckb changed state do
		(
			try(
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom04ControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom04ControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom04_RControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom04_RControlNodes state
			sj_functions.sj_SetHide_Fn AllCustomNodes[1].node.Custom04_LControlNodes state
			sj_functions.sj_SetFreeze_Fn AllCustomNodes[1].node.Custom04_LControlNodes state
			)catch()
		)

	--////////////////////////////////////////////////
	--選択処理
	--////////////////////////////////////////////////
		--All
		on allSelBt pressed do
		(
			tempNodes = selection[1]
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.ControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.SpineSubControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.NecSubControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.ArmSubControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.LegSubControlNodes)catch()
			--for i in $.Hand_RSubControlNodes)catch()
			--for i in $.Hand_LSubControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom01ControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom02ControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom03ControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom04ControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom01_RControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom02_RControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom03_RControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom04_RControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom01_LControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom02_LControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom03_LControlNodes)catch()
			try(sj_functions.sj_SelectNodes_Fn tempNodes.AllCustomNodes[1].node.Custom04_LControlNodes)catch()
			tempNodes = #()
		)
		--AllMove
		on allMoveBt pressed do
		(
			tempNodes = #()
			for i=1 to 10 do append tempNodes $.ControlNodes[selectIndexTemp[i]]
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn tempNodes)catch()
			tempNodes = #()
		)
		--Bone
		on boneSelBt pressed do
		(
			tempNodes = #()
			for i in $.MainBoneNodes  do append tempNodes i
			for i in $.SubBoneNodes  do append tempNodes i
			for i in $.SpineBoneNodes do append tempNodes i
			for i in $.NecBoneNodes do append tempNodes i
			
			for i in $.UpperArm_RBoneNodes do append tempNodes i
			for i in $.ForeArm_RBoneNodes do append tempNodes i
			for i in $.Thigh_RBoneNodes do append tempNodes i
			for i in $.Calf_RBoneNodes do append tempNodes i
			for i in $.Hand_RBoneNodes do append tempNodes i
			
			for i in $.UpperArm_LBoneNodes do append tempNodes i
			for i in $.ForeArm_LBoneNodes do append tempNodes i
			for i in $.Thigh_LBoneNodes do append tempNodes i
			for i in $.Calf_LBoneNodes do append tempNodes i
			for i in $.Hand_LBoneNodes do append tempNodes i

			for i in $.AllCustomNodes[1].node.Custom01BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom02BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom03BoneNodes do append tempNodes i
			for i in $.AllCustomNodes[1].node.Custom04BoneNodes do append tempNodes i
			
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn tempNodes)catch()
			tempNodes = #()
		)
		--custom1
		on ctm01SelBt pressed do
		(
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom01ControlNodes)catch()
			try(
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom01_RControlNodes
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom01_LControlNodes
			)catch()
		)
		--custom2
		on ctm02SelBt pressed do
		(
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom02ControlNodes)catch()
			try(
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom02_RControlNodes
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom02_LControlNodes
			)catch()
		)
		--custom3
		on ctm03SelBt pressed do
		(
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom03ControlNodes)catch()
			try(
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom03_RControlNodes
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom03_LControlNodes
			)catch()
		)
		--custom4
		on ctm04SelBt pressed do
		(
			clearSelection()
			try(sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom04ControlNodes)catch()
			try(
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom04_RControlNodes
			sj_functions.sj_SelectNodes_Fn AllCustomNodes[1].node.Custom04_LControlNodes
			)catch()
		)
		
		on deleteBt pressed do
		(
			if queryBox("本当に削除しますか?") then (
			allNodes = #()
			--iはnodeの数だけnode内容をallnodeに格納
			if queryBox("スキンオブジェクトも削除しますか?") then for i in $.SkinObjectNodes do append allNodes i.node;
			for i in $.MasterNodes do append allNodes i.node
			for i in $.AllOtherNodes do append allNodes i.node
			for i in $.AllCustomNodes do append allNodes i.node
			for i in $.ControlNodes do append allNodes i.node
			for i in $.SpineSubControlNodes do append allNodes i.node
			for i in $.NecSubControlNodes do append allNodes i.node
			for i in $.ArmSubControlNodes do append allNodes i.node
			for i in $.LegSubControlNodes do append allNodes i.node
			for i in $.Hand_RSubControlNodes do append allNodes i.node
			for i in $.Hand_LSubControlNodes do append allNodes i.node
			for i in $.SpineDefNodes do append allNodes i.node
			for i in $.NecDefNodes do append allNodes i.node
			for i in $.ArmDefNodes do append allNodes i.node
			for i in $.LegDefNodes do append allNodes i.node
			for i in $.Hand_RDefNodes do append allNodes i.node
			for i in $.Hand_LDefNodes do append allNodes i.node
			for i in $.MainBoneNodes do append allNodes i.node
			for i in $.SubBoneNodes do append allNodes i.node
			for i in $.SpineBoneNodes do append allNodes i.node
			for i in $.NecBoneNodes do append allNodes i.node
			for i in $.UpperArm_RBoneNodes do append allNodes i.node
			for i in $.ForeArm_RBoneNodes do append allNodes i.node
			for i in $.Thigh_RBoneNodes do append allNodes i.node
			for i in $.Calf_RBoneNodes do append allNodes i.node	
			for i in $.Hand_RBoneNodes do append allNodes i.node
			for i in $.UpperArm_LBoneNodes do append allNodes i.node
			for i in $.ForeArm_LBoneNodes do append allNodes i.node
			for i in $.Thigh_LBoneNodes do append allNodes i.node
			for i in $.Calf_LBoneNodes do append allNodes i.node	
			for i in $.Hand_LBoneNodes do append allNodes i.node
			for i in $.SpineSplinePosNodes do append allNodes i.node
			for i in $.NecSplinePosNodes do append allNodes i.node
			for i in $.UpperArm_RSplinePosNodes do append allNodes i.node
			for i in $.ForeArm_RSplinePosNodes do append allNodes i.node
			for i in $.Thigh_RSplinePosNodes do append allNodes i.node
			for i in $.Calf_RSplinePosNodes do append allNodes i.node
			for i in $.UpperArm_LSplinePosNodes do append allNodes i.node
			for i in $.ForeArm_LSplinePosNodes do append allNodes i.node
			for i in $.Thigh_LSplinePosNodes do append allNodes i.node
			for i in $.Calf_LSplinePosNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.SpineOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.NecOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.ArmOtherNodes do append allNodes i.node
			for i in $.AllOtherNodes[1].node.LegOtherNodes do append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom01_LControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom02_LControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom03_LControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04Nodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04BoneNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04ControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04_RControlNodes do if isvalidnode i.node then append allNodes i.node
			for i in $.AllCustomNodes[1].node.Custom04_LControlNodes do if isvalidnode i.node then append allNodes i.node

			delete allNodes
			allNodes = #()
			);--if end
			gc()
			clearSelection()
		)
		
	--////////////////////////////////////////////////
	--オブジェクトリスト処理
	--////////////////////////////////////////////////
		on addListCkb changed state do
		(
			if state == on then
			(
				picObj = undefined
				collectallNodes_Fn()
				picObj = pickObject message:"オブジェクトを選択してください:" count:1 forceListenerFocus:false filter:pickFilter_Fn
				--picObj = pickObject message:"オブジェクトを選択してください:" count:#multiple forceListenerFocus:false filter:pickFilter_Fn
				
				if isvalidnode picObj do
				(
					if prefix.text != "" then
					(
						--先頭文字列にprefix名が無かったら
						if substring picObj.name 1 prefix.text.count != prefix.text then picObj.name = (prefix.text + picObj.name)
					)--if end
					append SkinObjectNodes (nodeTransformMonitor node:picObj forwardTransformChangeMsgs:false)
					picObj.wirecolor = ColorSet
					picObj.showFrozenInGray = off				
					update_Fn()
				)--if end

				addListCkb.state = off
			)
			else
			(
				max move
				allNodes = #()
			)--if end
		)--on end
		on selAllListBt pressed do try(sj_functions.sj_SelectNodes_Fn SkinObjectNodes)catch()
		on delListBt pressed do
		(
			if modelList.selection != 0 do
			(
				unhide SkinObjectNodes[modelList.selection].node
				unfreeze SkinObjectNodes[modelList.selection].node
				deleteItem SkinObjectNodes modelList.selection
			)--if end
			update_Fn()
		)--on end
		on modelList doubleClicked sel do select SkinObjectNodes[sel].node

	)--rol end
	
	--////////////////////////////////////////////////
	--ロールアウト
	--////////////////////////////////////////////////
	rollout sj_about_rol "About"
	(
Local sjHelperAboutStr = "
Beyond
Version:ProtoType ver:1.08
Last up date:09.12.13

Created By:CaptainHansode
(c)2005-2011

WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
"
		bitmap bmp_BackGround "" pos:[0,0] width:160 height:213 enabled:false fileName:"$Scripts/SJTools/Images/SJ_rogo.gif"
		
		groupBox aboutGrp "About" pos:[0,252] width:160 height:200
		label aboutLbl "" pos:[12,268] width:120 height:160
		
		on sj_about_rol open do aboutLbl.caption = sjHelperAboutStr
	)--end rol

--////////////////////////////////////////////////
--ヘルパーオブジェクトアクション
--getDisplayMeshでオブジェクト生成する
--パラーメーターはlasSize
--////////////////////////////////////////////////
on getDisplayMesh do
(
	if (meshObj == undefined) do
	(
	--このパラメーターはこのオブジェクトに変数として格納されている
		meshObj = createInstance Cylinder smooth:off heightsegs:1 capsegs:1 sides:24 height:0 radius:40 mapcoords:false
		lastSize = 40.0
		
	--シーン上のオブジェクトもメッシュとして選択できる
	--meshObj = $Cylinder01 --.createInstance Cylinder smooth:on heightsegs:5 capsegs:1 sides:18 height:0.293703 radius:40.1288 mapcoords:false
	--Circle radius:22.3695--box length:20 width:40 height:0 mapCoords:false
	);--if end

	if size != lastSize do
	(
	meshObj.radius = size;
	lastSize = size;
	);--if end
	meshObj.mesh;
	
)--end getDosplay

--オブジェクト生成時のアクション、画面をクリックすると1つ作成する
tool create
( 
	on mousePoint click do
	(
	nodeTM.translation = gridPoint;#stop 
	)
) 

/*
on update do
(
	if version == 1 then
	(
		print ""
	)
)--end on update
*/

)--end script