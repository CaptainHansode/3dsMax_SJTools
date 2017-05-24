/*******************************************************
System J Tools 
********************************************************
Name:sj_key_Machine
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

(

-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
global sj_key_Machine_rol --ロールアウト用
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = "SJ Key Machine"
-----------------------------------------------------------------------------------------------------------
Local fileLockID = 6581883285124;

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
--順番は削除して登録
--登録を削除
try(cui.unRegisterDialogBar sj_key_Machine_rol)catch();
--閉じる
try(closeRolloutFloater sj_key_Machine_rol)catch();
--削除	
try(destroydialog sj_key_Machine_rol)catch();
--登録したダイアログを不動にする
try(cui.FloatDialogBar sj_key_Machine_rol)catch();

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_key_Machine_rol nameAndVersion
(

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
	fn menus_Fn =
	(
		rcMenu menuBar
		(
			local modInst
			/*
				menuItem maxPreviewMi "プレビューの設定";
				menuItem createPreviewMi "プレビューを作成";
				menuItem maxRenamePreviewMi "プレビューに名前を付けて保存";
				seperator sep01;
				menuItem reduceKeysMi "キーリダクション";
				seperator sep02;
				menuItem setActiveKeyRangeMi "現在のオブジェクトのキーでレンジ設定";
				seperator sep03;
				menuItem saveBookMi "ブックマークを保存";
				menuItem loadBookMi "ブックマークを読み込み"
				menuItem mergeBookMi "ブックマークを合成"
				menuItem resetBookMi "ブックマークをリセット"
			*/
				--menuItem offsetKeysMi "キーオフセット"
				menuItem testMi "このツールは試験中です"
				seperator sep01;
				menuItem helpMi "ヘルプ!"
				menuItem aboutMi "About"
				menuItem emailMi  "E-Mail"
			
			on maxPreviewMi picked do max preview;
			on createPreviewMi picked do createPreview();
			on maxRenamePreviewMi picked do max renamepreview;
			
			on reduceKeysMi picked do sj_key_Machine_rol.keysReduce_Fn();
			
			on setActiveKeyRangeMi picked do sj_key_Machine_rol.setActiveKeyRange_Fn();
			
			on saveBookMi picked do sj_key_Machine_rol.save_Fn();
			on mergeBookMi picked do sj_key_Machine_rol.merge_Fn();

			on resetBookMi picked do sj_key_Machine_rol.resetBook_Fn();
			
			on loadBookMi picked do sj_key_Machine_rol.load_Fn();
			on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5883" ""
			on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
			on aboutMi picked do sj_functions.sjtools_about_Fn();
			
			on menuBar update do
			(
				 reduceKeysMi.caption = "a";
			);
		)
		menuBar.modInst = this;
		return menuBar;
	)

--////////////////////////////////////////////////
--起動時のアップデート
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--load default
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--save default
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--save ブックマーク
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--load ブックマーク
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--merge ブックマーク
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--ブックマークをリセット
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--ブックマークリストを切り替え
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--インターバルセット
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--現在セット
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--editModeアップデート
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--現在のアニメーションキーで範囲を設定
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--キーリダクション
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--挿入、圧縮、反転
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	local minRange = -1e+009, maxRange = 1e+009
	local bgBitMap = openBitmap "$Scripts/SJTools/Images/SJ_timemachine_bg.bmp"
	--ImgTag backGroundImage "Bitmap" pos:[0,0] width:2400 height:24 enabled:false bitmap:bgBitMap
	--bitmap backGroundImage "" pos:[0,0] width:1600 height:24 enabled:false fileName:"$Scripts/SJTools/Images/SJ_timemachine_bg.png"
	button closeBt "X" pos:[0,0] width:16 height:24 images:#("$Scripts/SJTools/Images//SJ_timemachine03.png", "undefined", 2, 1, 1, 2, 2)
	button maxPreviewBt "プレビュー設定" pos:[20,0] width:78 height:21 enabled:true  toolTip:"プレビュー設定" --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 1, 1, 1, 1, 1);
	button createPreviewBt "プレビュー作成" pos:[104,0] width:78 height:21 enabled:true  toolTip:"プレビュー作成" --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 1, 1, 1, 1, 1);
	button maxRenamePreviewBt "プレビュー保存" pos:[188,0] width:78 height:21 enabled:true  toolTip:"プレビュー保存" --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 1, 1, 1, 1, 1);
	button maxViewPreviewBt "プレビュー表示" pos:[272,0] width:78 height:21 enabled:true  toolTip:"プレビュー保存" --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 1, 1, 1, 1, 1);
	--button helpBt "?" pos:[20,0] width:32 height:24 enabled:true --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 2, 1, 1, 2, 2)

	button keyCopyBt "Key Copy" pos:[372,0] width:128 height:24 enabled:false --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 2, 1, 1, 2, 2)
	button keyPasteBt "Key Paste" pos:[508,0] width:128 height:24 enabled:false --images:#("$Scripts/SJTools/Images//SJ_timemachine02.png", "undefined", 2, 1, 1, 2, 2)

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
	on maxPreviewBt pressed do try(max preview)catch();
	on createPreviewBt pressed do try(createPreview())catch();
	on maxRenamePreviewBt pressed do try(max renamepreview)catch();
	on maxViewPreviewBt pressed do try(max viewpreview)catch();
		
	on closeBt pressed do
	(
		try(cui.unRegisterDialogBar sj_key_Machine_rol)catch()
		try(closeRolloutFloater sj_key_Machine_rol) catch()
		try(destroydialog sj_key_Machine_rol)catch()
		try(destroydialog sj_progressBar_rol)catch()
	);--end

	--////////////////////////////////////////////////
	--Open and Close
	--////////////////////////////////////////////////
	on sj_key_Machine_rol open do
	(
		--ドッキングアクション
		if (queryBox "キーマシンツールバーを\nタイムラインにドッキングしますか?\n
Are you sure you want to dock to the bottom this toolbar to screen?" title:MesseTitleInfoStr) then
		(
		cui.RegisterDialogBar sj_key_Machine_rol style:#(#cui_dock_all,#cui_handles,#cui_floatable,#cui_max_sized);/* minSize:[5,200] style:#(#cui_max_sized );*/
		cui.DockDialogBar sj_key_Machine_rol #cui_dock_bottom;
		);--ドッキングします--if end
		
	)

)--rol end

-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_key_Machine_rol width:1600 height:28/*pos:[50,50]*/ style:#(/*#style_border, #style_titlebar,#style_toolwindow, */#style_toolwindow,#style_sysmenu, #style_resizing, #style_minimizebox) /*menu:CanvasMenu menu:pbakeMenuBar*/;

--cui.RegisterDialogBar sj_key_Machine_rol style:#(#cui_dock_all,#cui_handles,#cui_floatable,#cui_max_sized);/*style:#(#cui_max_sized );--最大サイズで*/
--cui.DockDialogBar sj_key_Machine_rol #cui_dock_bottom;--ドッキング
	
)--end macroscript
