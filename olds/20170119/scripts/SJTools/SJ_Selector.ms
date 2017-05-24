/*******************************************************
System J Tools 
********************************************************
Name:SJ_Selector
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

(

-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
global sj_selector_rol --ロールアウト用
global sj_selector_rol_pos = #(50,50) --ロールアウト位置確保用
global sj_selector_node = undefined;--アクター確保しselectorRigに引き渡し
global sj_selector_isopened = true;--セレクターは開いたか？
--必要なプロパティは左右の脚の位置、高さ、背骨首の本数、高さ、位置
--最初の位置が分かればあとは減算していけばいい
--global sj_selector_ui = #();--アクター確保しselectorRigに引き渡し
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJSelectorToolName");
-----------------------------------------------------------------------------------------------------------

Local actorArray = #(), cameraArray = #(), tempArray = #(), tempNameArray = #();
Local check = 0, doubleName = #(), singleName = #();

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_selector_rol)catch()
try(cui.unRegisterDialogBar sj_selector_rol)catch()
try(closeRolloutFloater sj_selector_rol) catch()
try(destroydialog sj_selector_rol)catch()
-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu selectorMenuBar
(
/*
subMenu "ファイル"
(
menuItem savePoseFileMi "保存" enabled:true
menuItem loadPoseFileMi "開く" enabled:true
menuItem mergePoseFileMi "合成" enabled:true
seperator sep01
menuItem closeMi "終了" enabled:true
)
*/
subMenu "ヘルプ"
( 
menuItem helpMi "ヘルプ"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
)
--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5979" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
);--menu end

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_selector_rol nameAndVersion width:144 height:372
(
--ロールアウトに変数を追加
Local old_selectorRig_rol_pos = #(50,50) --ロールアウト位置確保用

--////////////////////////////////////////////////
--リグセレクタ機動
--////////////////////////////////////////////////
fn sj_rigSelector_Fn=
(
	--UIの値を決定しておく
	--必要なプロパティは左右の脚の位置、高さ、背骨首の本数、高さ、位置
	--最初の位置が分かればあとは減算していけばいい
	--sj_selector_ui = #();--一端初期化
	
	
--一端削除
try(cui.FloatDialogBar sj_selectorRig_rol)catch();
try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
try(closeRolloutFloater sj_selectorRig_rol) catch();
try(destroydialog sj_selectorRig_rol)catch();
	--スクリプトを実行
	macros.run "SJTools" "SJ_Selector_Rig";
)--fn end
	
		
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--ビヨンドとカメラ検索
--////////////////////////////////////////////////
fn searchActorAndCam_Fn =
(
	actorArray = #();
	cameraArray = #();
	--bip用の変数
	testBip = undefined;
	local tempBip = undefined;
	local tempBipArray = #();
	local tempXrefArray = #();
	
	--////////////////////////////////////////////////
	--アクターとカメラを回収
	for i in objects do
	(
		if (classOf i == SJ_Helper) do
		(
			append actorArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false);
			--append tempArray i;
		);--if end
		
		if (classOf i == Freecamera) do
		(
			--append cameraArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false)
			append tempArray i;
		);--if end
		
		--ターゲットカメラも
		if (classOf i == Targetcamera)  do
		(
			--append cameraArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false)
			append tempArray i;
			append tempArray i.target;
		);--if end
		
		--V-rayカメラを回収
		if (classOf i == VRayDomeCamera) or (classOf i == VRayPhysicalCamera) do
		(
			--append cameraArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false)
			append tempArray i;
			--ターゲットカメラの場合ならば
			if (i.target != undefined) do append tempArray i.target;
		);--if end

		--Bipを回収、iはBipedか？
		if ((classOf i) == Biped_Object) do
		(
			--マズコントローラーを回収
			tempBip = i.controller
			--ルートノードを回収
			tempBip = tempBip.rootNode
			--改めてノードのコントローラーを代入
			
			--一端普通の配列へnodeTransformMonitorを使わずに
			--nodeハンドルIndexを利用して、Index値見つからなかった場合のみindexを回収
			if ((findItem tempBipArray tempBip.inode.handle) < 1) do append tempBipArray tempBip.inode.handle
		);--if end
		
	--////////////////////////////////////////////////
	--リファレンス対策
	--////////////////////////////////////////////////
		--Xrefを回収
		if ((classOf i) == XRefObject) do
		(
			append tempXrefArray i;
		);--if end
		
	);--for end
	
	--////////////////////////////////////////////////
	--リファレンス対策
	--////////////////////////////////////////////////
	for i in tempXrefArray do
	(
		--local tempClassName = i.GetSourceObject true
		if ((classOf (i.GetSourceObject true)) == SJ_Helper) do
		(
			append actorArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false);
			--append tempArray i;
		);--if end
		
		--Bipを回収、iはBipedか？
		if ((classOf (i.GetSourceObject true)) == Biped_Object) do
		(
			--マズコントローラーを回収
			tempBip = i.controller
			--ルートノードを回収
			tempBip = tempBip.rootNode
			--改めてノードのコントローラーを代入
			
			--一端普通の配列へnodeTransformMonitorを使わずに
			--nodeハンドルIndexを利用して、Index値見つからなかった場合のみindexを回収
			if ((findItem tempBipArray tempBip.inode.handle) < 1) do append tempBipArray tempBip.inode.handle
		);--if end
		
		--if ((classOf (i.GetSourceObject true)) == Freecamera) or ((classOf (i.GetSourceObject true)) == Targetcamera) do
		if ((classOf (i.GetSourceObject true)) == Freecamera) do
		(
			--append cameraArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false)
			append tempArray i;
		);--if end
		
		--カメラのターゲットも
		if ((classOf (i.GetSourceObject true)) == Targetcamera) do
		(
			--append cameraArray (nodeTransformMonitor node:i forwardTransformChangeMsgs:false)
			append tempArray i;
			append tempArray i.target;
		);--if end
		
		--V-rayカメラを回収
		if ((classOf (i.GetSourceObject true)) == VRayDomeCamera) or ((classOf (i.GetSourceObject true)) == VRayPhysicalCamera) do
		(
			append tempArray i;
			--ターゲットカメラの場合ならば
			if (i.target != undefined) do append tempArray i.target;
		);--if end
	);--for end
			--print tempArray
	
	--////////////////////////////////////////////////
	--Bipedかぶった項目を一掃する
	makeUniqueArray tempBipArray;
	--nodeハンドルからオブジェクトを回収
	for i in tempBipArray do
	(
		append actorArray (nodeTransformMonitor node:(maxOps.getNodeByHandle i) forwardTransformChangeMsgs:false);
	);--for end

	
	--////////////////////////////////////////////////
	--カメラの名前順ソート
	tempNameArray = for i in tempArray collect i.name;
	sort tempNameArray;

	--print tempNameArray;
	--print "一度中身をチェック";

	--////////////////////////////////////////////////
	--カメラの名前の重複を確認
	doubleName = #();
	singleName = #();
	i = 1;
	
	--iがカウントを満たすまで
	--名前を前後で調べ上げてがぶったものはダブルネーム、かぶらないものはシングルネーム
	while i <= tempNameArray.count do
	(
	check = 0;
	--////////////////////////////////////////////////
	--名前をチェック、重複が確認できた配列はスキップ
		for k = (i+1) to tempNameArray.count do
		(
		--同じか？大文字小文字も比較対照
		if tempNameArray[i] == tempNameArray[k] then check += 1;
		);--for end
		
		--チェックが無ければ、iは次へ、あれば別の変数へ格納
		if check != 0 then
		(
			append doubleName tempNameArray[i]
			i += (check+1);
		)else(
			append singleName tempNameArray[i]
			i += 1;
		);--if end
	);--whiel end

	--////////////////////////////////////////////////
	--再び選択
	cameraArray = #();
	
	--シングル
	for i in singleName do 
	(
		k = (getNodeByName i ignoreCase:false all:false);
		if (classOf k == Freecamera) or
		(classOf k == Targetcamera) or
		(classOf k == Targetobject) or
		(classOf k == VRayDomeCamera) or
		(classOf k == VRayPhysicalCamera) do
		(
			append cameraArray (nodeTransformMonitor node:k forwardTransformChangeMsgs:false)
		);--if end
	);--for end

	--シングル
	try(
	for i in singleName do 
	(
	k = (getNodeByName i ignoreCase:false all:false);
	if ((classOf (k.GetSourceObject true)) == Freecamera) or
		((classOf (k.GetSourceObject true)) == Targetcamera) or
		((classOf (k.GetSourceObject true)) == Targetobject) or
		((classOf (k.GetSourceObject true)) == VRayDomeCamera) or
		((classOf (k.GetSourceObject true)) == VRayPhysicalCamera) do
	(
		append cameraArray (nodeTransformMonitor node:k forwardTransformChangeMsgs:false)
	);--if end
	);--for end	
	)catch();
	
	--ダブル
	for i in doubleName do 
	(
		--大文字小文字も含め一致するもの
		k = (getNodeByName i ignoreCase:false all:true);
			for j in k do(
			if (classOf j == Freecamera) or
				(classOf j == Targetcamera) or
				(classOf j == Targetobject) or
				(classOf j == VRayDomeCamera) or
				(classOf j == VRayPhysicalCamera) do
			(
				append cameraArray (nodeTransformMonitor node:j forwardTransformChangeMsgs:false)
			);--if end
		);--for end
	);--for end

	
	--ダブル
	try(
	for i in doubleName do 
	(
		--大文字小文字も含め一致するもの
		k = (getNodeByName i ignoreCase:false all:true);
			for j in k do(
			if ((classOf (k.GetSourceObject true)) == Freecamera) or
				((classOf (k.GetSourceObject true)) == Targetcamera) or
				((classOf (k.GetSourceObject true)) == Targetobject) or
				((classOf (k.GetSourceObject true)) == VRayDomeCamera) or
				((classOf (k.GetSourceObject true)) == VRayPhysicalCamera) do
			(
				append cameraArray (nodeTransformMonitor node:j forwardTransformChangeMsgs:false)
			);--if end
		);--for end
	);--for end
	)catch();
	
	if doubleName.count != 0 then messageBox "名称が重複しているカメラがあります" title:"警告"


	--////////////////////////////////////////////////
	--最後にリストに追加
	
	tempArray = #();
	
		for i in actorArray do
		(
			append tempArray i.node.name
		);
		sj_selector_rol.actorList.items = tempArray;
		tempArray = #()
		for i in cameraArray do
		(
			append tempArray i.node.name
		);
		sj_selector_rol.cameraList.items = tempArray;

	tempArray = #()	
	doubleName = #();
	singleName = #();
	tempXrefArray = #();

);--fn end

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	GroupBox selectorGrp "Actor and Camera List" pos:[4,4] width:136 height:364

	checkbox actorFocusChk "フォーカス" pos:[12,20] width:84 height:20
	checkbox rigSelectorChk "RIGセレクタ" pos:[12,36] width:108 height:20
	listbox actorList "アクター" pos:[12,60] width:120 height:8
	button allSelectABt "A" pos:[112,56] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2) toolTip:"全て選択"

	checkbox camFocusChk "フォーカス" pos:[12,190] width:84 height:20
	listbox cameraList "カメラ" pos:[12,212] width:120 height:8
	button allSelectCBt "A" pos:[112,208] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2) toolTip:"全て選択"
	button refrechBt "リフレッシュ" pos:[12,344] width:120 height:20 enabled:true toolTip:"リストを最新の状態に更新" --images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2)

	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[134,362] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

	on actorList doubleclicked state do
	(
		try(
		select actorArray[state].node;
		sj_selector_node = actorArray[state].node;
		if actorFocusChk.checked do max zoomext sel;
		)catch();
		if rigSelectorChk.checked do sj_rigSelector_Fn();
		
	);--end

	on cameraList doubleclicked state do
	(
		try(
		select cameraArray[state].node;
		if camFocusChk.checked do max zoomext sel;
		)catch();
	);--end

	on refrechBt pressed do
	(
		suspendEditing()--サスペンドモード
		with redraw off
		(--再描画禁止
		searchActorAndCam_Fn()
		)--with redraw end	
		resumeEditing()--再びアクティブに
	);--end

	on allSelectABt pressed do
	(
		Local allSel = #();
		for i in actorArray do append allSel i.node;
		select allSel;
		if actorFocusChk.checked do max zoomext sel;
		max zoom in 2x;
	)
	
	on allSelectCBt pressed do
	(
		--削除対策ひとまずtrycatch
		try(
		Local allSel = #();
		for i in cameraArray do append allSel i.node;
		select allSel;
		if camFocusChk.checked do max zoomext sel;
		)catch();
	);--end

	on sj_selector_rol open do
	(
		sj_selector_isopened = true;
		suspendEditing()--サスペンドモード
		with redraw off
		(--再描画禁止
		searchActorAndCam_Fn()
		)--with redraw end	
		resumeEditing()--再びアクティブに
		
		callbacks.removescripts id:#SJ_Selector_Refresh; ---コールバックが重複登録されないように、安全対策
		callbacks.addScript #filePostOpenProcess "sj_selector_rol.searchActorAndCam_Fn()" id:#SJ_Selector_Refresh; --ロールアウト内のファンクションを直接登録
		
	);--end
	
	on sj_selector_rol close do
	(
		sj_selector_isopened = false;
		
		---コールバックが重複登録されないように、安全対策
		callbacks.removescripts id:#SJ_Selector_Refresh;
	);--end

	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_selector_rol resized val do
	(
		width = 144;
		height = 372;

		refrechBtPos = [12,344];
		refrechBtPosTemp = [12,344];
		
		if ((sj_selector_rol.width >= 144) and (sj_selector_rol.height >= 372)) do
		(
			--差分を出す
			addH = val[2] - height;
			
			--リストの幅
			selectorGrp.width = cameraList.width = actorList.width =  val[1] - 24;
			selectorGrp.width = selectorGrp.width + 16;
			--refrechBt.width = 30;--ん？幅のプロパティがねぇ・・・

			--高さは増えた増分+元の大きさ、リストは2つあるので2で割っている
			actorList.height = cameraList.height = 110 + (addH/2.0);
			selectorGrp.height = val[2] - 8;
			
			--ポジションの80は適当に合わせた、増分はアクターリストと同じ
			camFocusChk.pos = [12,80 + actorList.height]
		
			--118は適当に合わせて
			cameraList.pos = [12,118 + actorList.height]
			allSelectCBt.pos = [112,98 + actorList.height]
			
			refrechBtPosTemp[2] = refrechBtPos[2] + addH;
			refrechBt.pos = refrechBtPosTemp;
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
		
		);--if end
	)--end
	
	--ウィンドウの移動時にグローバル変数を確保
	on sj_selector_rol moved val do
	(
		sj_selector_rol_pos[1] = val[1];
		sj_selector_rol_pos[2] = val[2];
	);--end
	 
	
)--rol end

-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
createDialog sj_selector_rol pos:[50,50] menu:selectorMenuBar /*bgColor:[0,0,0]*/ style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu


)--end macroscript
