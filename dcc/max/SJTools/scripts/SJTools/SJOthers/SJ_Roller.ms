/*******************************************************
System J Tools 
********************************************************
Name:SJ_Roller
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_roller_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJRollerToolName");
-----------------------------------------------------------------------------------------------------------

--全てのローラーオブジェクト	
Local allObj = #(), allObjDelay = #(), allObjTag = #(), allObjRatio = #();
-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_roller_rol)catch()
try(cui.unRegisterDialogBar sj_roller_rol)catch()
try(closeRolloutFloater sj_roller_rol) catch()	
try(destroydialog sj_roller_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu rollerMenuBar
(

subMenu "ヘルプ"
( 
menuItem helpMi "ヘルプ"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
)
/*
subMenu "設定"
( 
menuItem realTimeMi "リアルタイム" checked:true
menuItem btUpMi "ボタンアップ"
menuItem selTypeAMi "選択順" checked:true
menuItem selTypeBMi "階層順"
)
*/

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
on closeMi  picked do
(
try(cui.unRegisterDialogBar sj_roller_rol)catch()
try(closeRolloutFloater sj_roller_rol) catch()	
try(destroydialog sj_roller_rol)catch()
)
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5981" "";
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""

--メニューを開くたびに実行されるアップデート
on rollerMenuBar update do
(
)
)--rcMenu end

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_roller_rol nameAndVersion width:452 height:376
(

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Rot
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--回収
--////////////////////////////////////////////////
fn getRollerObj = (
	local allName = #();
	--初期化
	allObj = #();
	
	suspendEditing();--サスペンドモード
	with redraw off
	(--再描画禁止
		
	for i in objects do
	(
		try(
			if (i.modifiers[1].sjRoller) do append allObj i;
		)catch();
	);
	
	--////////////////////////////////////////////////
	--名前で並び替え
	--////////////////////////////////////////////////
	Local myObj = #(), myObjAfter = #();
	Local selObjName = for i in allObj collect i.name;
	Local selObjIh = for i in allObj collect i.inode.handle;
		--ソート
		sort selObjName;
		for i in selObjName do
		(
			--その名前のオブジェクトを回収
			myObj = getNodeByName i all:true;
			--iハンドルで名前の重複を確認
			for k in myObj do
			(
			--見つかれば
			if (findItem selObjIh k.inode.handle) != 0 then append myObjAfter k;
			);--for end
		);--for end
		
		--print myObjAfter
		--ソート結果を入れる
		allObj = myObjAfter;
	
	);--with redraw end
	--try(destroydialog sj_progressBar_rol)catch();
	resumeEditing();--再びアクティブに
	
	--名前を確保
	allName = for i in allObj collect i.name;
	sj_roller_rol.objectLbx.items = allName;
	allName = #();
	
);--fn end
--////////////////////////////////////////////////
--ターゲットを回収
--////////////////////////////////////////////////	
fn getRollerObjTag = (
	allName = #();
	
	for i in allObj do
	(
			if (i.modifiers[1].targetNode != undefined) and (isvalidnode i.modifiers[1].targetNode.node) then
			(
					--オブジェクトが有効なら
					append allName i.modifiers[1].targetNode.node.name;
			)else(
				--有効でないなら
				append allName "Undefined";
			);--if end
	);--for end
	
	--allObjTag = for i in allObj collect 
	--名前を確保
	--allName = for i in allObjTag collect i.name;
	sj_roller_rol.targetLbx.items = allName;
	allName = #();
);--fn end
--////////////////////////////////////////////////
--Delayを回収
--////////////////////////////////////////////////	
fn getRollerObjDelay = (
	allName = #();

	allObjDelay = for i in allObj collect i.modifiers[1].delay;	
	allName = for i in allObjDelay collect i as String;
	sj_roller_rol.delayLbx.items = allName;
	allName = #();
);--fn end
--////////////////////////////////////////////////
--ratioを回収
--////////////////////////////////////////////////	
fn getRollerObjRatio = (
	allName = #();

	allObjRatio = for i in allObj collect i.modifiers[1].ratio;	
	allName = for i in allObjRatio collect i as String;
	sj_roller_rol.ratioLbx.items = allName;
	allName = #();
);--fn end
--Local allObj = #(), allObjDelay = #(), allObjTag = #(), allObjRatio = #();

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	MultiListBox objectLbx "Object" pos:[16,16] width:128 height:16;
	MultiListBox targetLbx "Target" pos:[148,16] width:128 height:16;
	MultiListBox delayLbx "Delay" pos:[280,16] width:76 height:16;
	MultiListBox ratioLbx "Ratio" pos:[360,16] width:76 height:16;
	groupBox grp1 "" pos:[8,4] width:436 height:364;

	button allSelBt "リスト全選択" pos:[16,252] width:128 height:20;
	pickButton pickBt "ターゲットを選択" pos:[148,252] width:108 height:20;
	button delBt "X" pos:[256,252] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2) toolTip:"削除"
	spinner delaySpn "" pos:[280,252] width:76 height:20 range:[-1e+006,1e+006,0];
	spinner ratioSpn "" pos:[360,252] width:76 height:20 range:[-1e+006,1e+006,0];

	groupBox grp2 "Info" pos:[16,274] width:420 height:72;
	label infoLbl "編集" pos:[24,286] width:400 height:48;
	hyperLink  infoHl "www.sakaiden.com" pos:[24,327] width:400 height:16 address:"http://www.sakaiden.com/?p=7682";
	
	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[442,366] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

-----------------------------------------------------------------------------------------------------------
-- アクション
-----------------------------------------------------------------------------------------------------------
	--////////////////////////////////////////////////
	--同期イベント
	--////////////////////////////////////////////////
	on objectLbx selectionEnd do ratioLbx.selection = delayLbx.selection = targetLbx.selection = objectLbx.selection;
	on targetLbx selectionEnd do delayLbx.selection = objectLbx.selection = ratioLbx.selection = targetLbx.selection;
	on ratioLbx selectionEnd do delayLbx.selection = targetLbx.selection = objectLbx.selection = ratioLbx.selection;
	on delayLbx selectionEnd do ratioLbx.selection = targetLbx.selection = objectLbx.selection = delayLbx.selection;
	on allSelBt pressed do
	(
		local tempArray = #{};
		for i = 1 to objectLbx.items.count do
		(
			append tempArray i
		);--for end
		ratioLbx.selection = delayLbx.selection = targetLbx.selection = objectLbx.selection = tempArray;
	);--end
	--on allSelBt pressed do select allObj;
	--オブジェクト選択
	on objectLbx doubleClicked index do select allObj[index];
	
	on pickBt picked obj do
	(
		for i in targetLbx.selection do
		(
			allObj[i].modifiers[1].targetNode = undefined;
			allObj[i].modifiers[1].targetNode = (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false);
			getRollerObjTag();
		);--for end
	);

	on pickBt picked obj do
	(
		for i in targetLbx.selection do
		(
			allObj[i].modifiers[1].targetNode = undefined;
			allObj[i].modifiers[1].targetNode = (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false);
			getRollerObjTag();
		);--for end
	);
	
	on delBt pressed do
	(
		for i in targetLbx.selection do
		(
			allObj[i].modifiers[1].targetNode = undefined;
			getRollerObjTag();
		);--for end
	);
	
	--数値入力
	on delaySpn changed val inSpin do
	(
		--inSpineは使わない
		for i in delayLbx.selection do
		(
			allObj[i].modifiers[1].delay = val;
			getRollerObjDelay();
		);--for end
	);--for end
	on ratioSpn changed val inSpin do
	(
		--inSpineは使わない
		for i in ratioLbx.selection do
		(
			allObj[i].modifiers[1].ratio = val;
			getRollerObjRatio();
		);--for end
	);--for end
	--数値入力
	on delaySpn entered val inSpin do
	(
		--inSpineは使わない
		for i in delayLbx.selection do
		(
			allObj[i].modifiers[1].delay = delaySpn.value;
			getRollerObjDelay();
		);--for end
	);--for end
	on ratioSpn entered val inSpin do
	(
		--inSpineは使わない
		for i in ratioLbx.selection do
		(
			allObj[i].modifiers[1].ratio = ratioSpn.value;
			getRollerObjRatio();
		);--for end
	);--for end
	
	on sj_roller_rol open do
	(
		infoLbl.caption = "編集対象をObjectsのリストから選択し、各項目の下部から編集します
項目は複数選択可能です
ディレイ設定オブジェクトは下記のサンプルシーンをご覧下さい"
	--取得
	getRollerObj();
	getRollerObjTag();
	getRollerObjDelay();
	getRollerObjRatio();
		
	);

	on sj_roller_rol close do
	(

	--gc();
	);
	
	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_roller_rol resized val do
	(
	--増加分
		local width = val[1] - 452;
		local height = val[2] - 376;

		--大きさが元の大きさを超えていれば
		if ((sj_roller_rol.width >= 452) and (sj_roller_rol.height >= 376)) then
		(
			grp1.width = val[1] - 16;
			grp1.height = val[2] - 12;
			
			objectLbx.width = 128 + width/2.0;
			targetLbx.width = 128 + width/2.0;
			
			objectLbx.height = 214 + height;
			targetLbx.height = 214 + height;
			delayLbx.height = 214 + height;
			ratioLbx.height = 214 + height;
			
			targetLbx.pos = [148 + width/2.0,32 ];
			delayLbx.pos = [280 + width,32 ];
			ratioLbx.pos= [360 + width,32 ];
			
			allSelBt.pos = [16,val[2]-124];
			pickBt.pos = [148 + width/2.0,val[2]-124];
			delBt.pos = [256 + width/2.0,val[2]-124];
			delaySpn.pos = [344 + width ,val[2]-124];
			ratioSpn.pos = [424 + width,val[2]-124];
			
			--info系
			grp2.pos = [16,val[2]-102];
			infoLbl.pos = [24,val[2]-90];
			infoHl.pos = [24,val[2]-52];
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
			
		)else
		(
			/*
			sj_roller_rol.width = 452;
			sj_roller_rol.height = 376;
			*/
		);--if end
		
	);--event end
	
)--rollout end
createDialog sj_roller_rol menu:rollerMenuBar /*bgColor:[0,0,0]*/ style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu

)--end macroscript
