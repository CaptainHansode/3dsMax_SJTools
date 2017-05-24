/*******************************************************
System J Tools 
********************************************************
Name:sj_animkey_preview
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

(
-----------------------------------------------------------------------------------------------------------
-- グローバルローカル周り
-----------------------------------------------------------------------------------------------------------
global sj_animkey_preview_rol
--Version etc
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJAnimKeyPreviewToolName");

-----------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_animkey_preview_rol)catch()
try(cui.unRegisterDialogBar sj_animkey_preview_rol)catch()
try(closeRolloutFloater sj_animkey_preview_rol) catch()
try(destroydialog sj_animkey_preview_rol)catch()
try(closeRolloutFloater sj_rs_hitobj_rol) catch()
try(destroydialog sj_rs_hitobj_rol)catch()
try(destroydialog sj_progressBar_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu renamerMenuBar
(
subMenu "ファイル"
(
/*
menuItem saveFileMi "レイヤーを保存" enabled:true
menuItem loadFileMi "レイヤーを読み込み" enabled:true
--menuItem mergeFileMi "レイヤー状態を合成" enabled:true
seperator sep01
menuItem saveSettingFileMi "設定プリセットを保存" enabled:true
menuItem loadSettingFileMi "設定プリセットを読み込み" enabled:true	
seperator sep02
*/
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
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=8656" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
on layerPresetrMenuBar update do
(
)
)--rcMenu end
-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_animkey_preview_rol nameAndVersion width:200 height:120;
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--初期化
--////////////////////////////////////////////////
fn initialize_Fn = (
	/*
	sj_animkey_preview_rol.newNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordNews");
	sj_animkey_preview_rol.beforeEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceA");
	sj_animkey_preview_rol.afterEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceB");
	sj_animkey_preview_rol.multiNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordAdd");
	sj_animkey_preview_rol.searchNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordSearch");
	sj_animkey_preview_rol.newNameSpn1.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "BaseNumber");
	sj_animkey_preview_rol.newNameSpn2.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Steps");
	sj_animkey_preview_rol.newNameSpn3.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Digit");
	sj_animkey_preview_rol.nNumberSpn.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "nNumber");
	
	sj_animkey_preview_rol.withNumberChk.checked = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Numbering");
	sj_animkey_preview_rol.addNumberChk.checked = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "OnlyNumbering");
	*/
);--end

fn saveIni_Fn = (
	/*
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordNews" sj_animkey_preview_rol.newNameEdt.text);
	*/
);--end

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////

		--GroupBox grp1 "プレビュー" pos:[8,8] width:184 height:88
		button previewBt "キーごとにプレビューを作成" pos:[16,30] width:168 height:24
/*	
		button allLayerDeleteBt "全て削除" pos:[16,62] width:168 height:24
		
		edittext layerDelByNameTxt "" pos:[12,124] width:172 height:16
		button layerDelByNameBt "名前でレイヤーを削除" pos:[16,148] width:168 height:24

		edittext allLayerPfxTxt "" pos:[12,180] width:172 height:16
		button allLayerPfxBt "全レイヤーにプレフィックス" pos:[16,204] width:168 height:24

		edittext allLayerDlPxTxt "" pos:[12,236] width:172 height:16
		button allLayerDlPxBt "全レイヤー対象文字を削除" pos:[16,260] width:168 height:24


		GroupBox grp2 "レイヤー設定プリセット" pos:[8,300] width:184 height:188
		edittext layerPresetEdt "" pos:[12,320] width:172 height:16 
		listbox layerPresetCbx "" pos:[16,336] width:168 height:9 selection:1 items:#("aaa","bbb","ccc")
		GroupBox grp5 "文字列で整理" pos:[8,104] width:184 height:188
		label lbl1 "ダブルクリックで切り替えます" pos:[16,466] width:144 height:16

			local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
			ImgTag resizeImg "Bitmap" pos:[190,482] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);
*/

	
-----------------------------------------------------------------------------------------------------------
--未使用を削除
-----------------------------------------------------------------------------------------------------------
	--名前変更など
	--エンターが押された時
	on previewBt pressed do
	(
		local selNode = selection[1];
		local bipNode = undefined;
		local animKeys = #();
		local previewKeys = #();
		local k=0, j=0;
		local isBip = false;
		local isDoit = false;
		
		--bitArrayでかぶり防止
		--local animKeys = #{};
		
		append animKeys 0f;
		
		--選択したモノはBipedか？
		if (classOf selNode == Biped_Object) then
		(
			bipNode = selNode.controller.rootNode;
			isBip = true;
			print "選択はBipedです";
		)
		/*
		else if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--リファレンス対策
				(
			bipNode = selNode.controller.rootNode;
			isBip = true;
			print "選択はリファレンスのBipedです";
		)
		*/
		else(
				if ((classOf selNode) == XRefObject) then --リファレンスだった場合
				(
				if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--リファレンス対策
				(
					bipNode = selNode.controller.rootNode;
					isBip = true;
					print "選択はリファレンスのBipedです";
				)else(
					messageBox("選択物のリファレンス先がBipedではないようです\nBipedを選択して実行してください") title:"お知らせ";
					isBip = false;					
				);--if end
				)else
				(
				--すべて失敗だった場合
					messageBox("選択物がBipedではないようです\nBipedを選択して実行してください") title:"お知らせ";
					isBip = false;
				);--if end
			
			);--if end
/*
		try(			
		if ((classOf selNode) == XRefObject) do --リファレンスだった場合
		(

		if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--リファレンス対策
		(
			bipNode = selNode.controller.rootNode;
			isBip = true;
		)
		else(
			--messageBox("選択物がBipedではないようです\nBipedを選択して実行してください") title:"お知らせ";
			isBip = false;
			);--if end
		);--if end
		)catch();
*/
		
		
		if isBip do(
	--////////////////////////////////////////////////
	--キーを回収
	--////////////////////////////////////////////////
		--ルート
		--日本語コントローラーが含まれているので現在は機能しない
		for i in (bipNode.controller.keys) do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--左腕
		for i in (biped.getNode bipNode 1).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--右腕
		for i in (biped.getNode bipNode 2).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--左足
		for i in (biped.getNode bipNode 5).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--右足
		for i in (biped.getNode bipNode 6).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--背骨
		for i in (biped.getNode bipNode 9).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--頭
		for i in (biped.getNode bipNode 11).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--しっぽ
		try(
		for i in (biped.getNode bipNode 10).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		)catch();
		
		--キーを整理
		sort animKeys;
		makeUniqueArray animKeys;
		
		--print animKeys[0];
		
		for i=2 to animKeys.count do
		(
			--抜け落ちるフレームを計算
			k = animKeys[i] - animKeys[i-1];
			--print k
			--抜け落ちるフレーム数分キーを回収
			for j=1 to k do
			(
				append previewKeys animKeys[i];
			);
			--for k in 
			--append animKeys i;
			
		);--for end
		
		print previewKeys[1];
		
		if (previewKeys[1] != undefined) and (previewKeys[1] < 0) then
		(
			
			print"キーは正常です";
			
			if (queryBox("マイナスフレームにキー  ("+ (previewKeys[1] as String) + ")  が打たれております\n続行しますか?
				
マイナスフレームにキーが打たれている場合は
タイムレンジをマイナスから始めてください\n
") title:"お知らせ") then
			(
				isDoit = true;
			)else(
				isDoit = false;
				--break();
			);
		)
		else if (previewKeys[1] != undefined) and (previewKeys[1] >= 0) then
		(
				isDoit = true;
		)else
		(
				--すべて失敗だった場合
				messageBox("作成するキーがありませんでした") title:"お知らせ";
				isDoit = false;
				--break();
		);--if end

		
		
		if isDoit do
		(
	--////////////////////////////////////////////////
	--プレビュー作成
	--////////////////////////////////////////////////
		preview_name = (getDir #preview)+"/quickpreview.avi"
		view_size = getViewSize()
		anim_bmp = bitmap view_size.x view_size.y filename:preview_name
			for t in previewKeys do
			(
				sliderTime = t
				dib = gw.getViewportDib()
				copy dib anim_bmp
				save anim_bmp
			);--for end
			close anim_bmp
			gc()
			ramplayer preview_name ""
			
			messageBox("動画の保存先は"+((getDir #preview)+"\quickpreview.avi")+"です") title:"お知らせ"
		);--if end
			
			
		);--if end
		
	);--end
	
	--////////////////////////////////////////////////
	--開いたとき
	--////////////////////////////////////////////////
	on sj_animkey_preview_rol open do
	(
		messageBox("試作品です")title:"お知らせ";
	)


	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_rs_hitobj_rol resized val do
	(

		width = 200;
		height = 336;
		
		--valがリサイズ時の大きさ
		--1が幅
		--print val;
		listWidth = 184;
		listHeight = 98;
		
		posTemp = [16,276];
		posTempB = [104,276];
		
		if ((sj_rs_hitobj_rol.width >= 200) and (sj_rs_hitobj_rol.height >= 336)) then
		(
			ratioW = (val[1] as float) / (width as float);
			ratioH = (val[2] as float) / (height as float);
			
			hitOjList.width = val[1] - 16;
			hitOjList.height = val[2] - 110;

			posTemp[2] = val[2] - 82;
			
			info2.pos = posTemp;
			
			--posTemp = val[2] - height;
			posTempB[2] = posTemp[2] = val[2] - 62;
			
			allSelBt.pos = posTemp;
			closeBt.pos = posTempB;
			
			posTemp[2] = val[2] - 30;
			numberingBt.pos = posTemp;
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
			
		)
		else
		(
		sj_rs_hitobj_rol.width = 200;
		sj_rs_hitobj_rol.height = 336;
		);--if end

		
	)--end			



	
)--rollout end

-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_animkey_preview_rol /*pos:[50,50]*/ menu:renamerMenuBar style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu

)--end macroscript
