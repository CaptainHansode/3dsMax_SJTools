/*******************************************************
System J Tools 
********************************************************
Name:SJ_Scene_Slicer
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
	
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_scene_slicer_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJSceneSlicerToolName");
-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_scene_slicer_rol)catch()
try(cui.unRegisterDialogBar sj_scene_slicer_rol)catch()
try( CloseRolloutFloater sj_scene_slicer_rol) catch()
try(destroydialog sj_scene_slicer_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu scene_slicerMenuBar
(
subMenu "ファイル"
(
menuItem saveFileMi "設定を保存" enabled:true
menuItem loadFileMi "設定を開く" enabled:true
)
subMenu "ヘルプ"
( 
menuItem helpMi "ヘルプ"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
);

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
on saveFileMi picked do sj_scene_slicer_rol.saveListFile_Fn();
on loadFileMi picked do sj_scene_slicer_rol.loadListFile_Fn();
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5908" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""


on scene_slicerMenuBar update do
(
);

);--rcMenu end

rollout sj_scene_slicer_rol nameAndVersion width:200 height:816;
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--save
--////////////////////////////////////////////////	
fn saveListFile_Fn =
(
		--保存は全設定を書き出す
		local saveFile = getSaveFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"設定を保存"
		
		--保存ファイルが設定されていれば
		if saveFile != undefined do
		(
			--保存ファイルを作成
			saveFileList = createFile saveFile;
			
			format "%\n" sj_scene_slicer_rol.sliceAChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceATxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceATxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceASSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceAESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceBChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceBTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceBTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceBSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceBESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceCChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceCTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceCTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceCSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceCESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceDChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceDTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceDTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceDSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceDESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceEChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceETxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceETxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceESSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceEESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceFChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceFTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceFTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceFSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceFESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceGChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceGTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceGTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceGSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceGESpn.value to:saveFileList;
			
			format "%\n" sj_scene_slicer_rol.sliceHChk.checked to:saveFileList;
			if sj_scene_slicer_rol.sliceHTxt.text != "" then(format "%\n" sj_scene_slicer_rol.sliceHTxt.text to:saveFileList)else(format "%\n" "undefined" to:saveFileList);
			format "%\n" sj_scene_slicer_rol.sliceHSSpn.value to:saveFileList;
			format "%\n" sj_scene_slicer_rol.sliceHESpn.value to:saveFileList;
			
			--ファイルを閉じる
			close saveFileList
		)--if end

);--fn end

--////////////////////////////////////////////////
--load
--////////////////////////////////////////////////	
fn loadListFile_Fn =
(
	local tempText = undefined;
	--保存ファイルを取得
	local loadFile = getOpenFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"設定を開く"
	
	if loadFile != undefined do
	(
		--ファイルを開く
		loadFileList = openFile loadFile;

		sj_scene_slicer_rol.sliceAChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined" then (sj_scene_slicer_rol.sliceATxt.text = tempText)else(sj_scene_slicer_rol.sliceATxt.text = "");
		sj_scene_slicer_rol.sliceASSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceAESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceBChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined" then (sj_scene_slicer_rol.sliceBTxt.text = tempText)else(sj_scene_slicer_rol.sliceBTxt.text = "");
		sj_scene_slicer_rol.sliceBSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceBESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceCChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined"then (sj_scene_slicer_rol.sliceCTxt.text = tempText)else(sj_scene_slicer_rol.sliceCTxt.text = "");
		sj_scene_slicer_rol.sliceCSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceCESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceDChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined"then (sj_scene_slicer_rol.sliceDTxt.text = tempText)else(sj_scene_slicer_rol.sliceDTxt.text = "");
		sj_scene_slicer_rol.sliceDSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceDESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceEChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined"then (sj_scene_slicer_rol.sliceETxt.text = tempText)else(sj_scene_slicer_rol.sliceETxt.text = "");
		sj_scene_slicer_rol.sliceESSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceEESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceFChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined"then (sj_scene_slicer_rol.sliceFTxt.text = tempText)else(sj_scene_slicer_rol.sliceFTxt.text = "");
		sj_scene_slicer_rol.sliceFSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceFESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceGChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined" then (sj_scene_slicer_rol.sliceGTxt.text = tempText)else(sj_scene_slicer_rol.sliceGTxt.text = "");
		sj_scene_slicer_rol.sliceGSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceGESpn.value = readValue loadFileList;
		
		sj_scene_slicer_rol.sliceHChk.checked = readValue loadFileList;
		tempText = (( readLine loadFileList ) as String);
		if tempText != "undefined"then (sj_scene_slicer_rol.sliceHTxt.text = tempText)else(sj_scene_slicer_rol.sliceHTxt.text = "");
		sj_scene_slicer_rol.sliceHSSpn.value = readValue loadFileList;
		sj_scene_slicer_rol.sliceHESpn.value = readValue loadFileList;
		
		close loadFileList
	)--if end

);--fn end
--////////////////////////////////////////////////
--インターバルセット
--////////////////////////////////////////////////
fn saveAndIntervalSet_Fn fileName  sT eT =
(
--	with redraw off
--	(--再描画禁止
	
	if sT < eT do
	(
	animationRange = interval sT eT;
	)--if end
	
	--テキストが空じゃないならファイルを保存
	if (sj_scene_slicer_rol.savePathTxt.text != "") and (fileName != "") do saveMaxFile (sj_scene_slicer_rol.savePathTxt.text + fileName);
	
	
--	)
)--fn end

--////////////////////////////////////////////////
--範囲外のキーを削除
--////////////////////////////////////////////////
fn delOutRangeKey_Fn =
(
			for i in objects do
			(
				--キー選択を解除	
				deselectKeys i;
				--範囲外のキーを選択
				selectkeys i (interval -100000 (animationRange.start-1));			
				--選択したキーを削除
				deleteKeys i #selection;
				
				--キー選択を解除	
				deselectKeys i;
				--範囲外のキーを選択
				selectkeys i (interval (animationRange.end+1) 100000);
				--選択したキーを削除
				deleteKeys i #selection;
			);--for end
	
);--fn end

--////////////////////////////////////////////////
--警告
--////////////////////////////////////////////////
fn warningNoFileName_Fn txt =
(
	messageBox (txt + "のファイル名が入力されていません!") title:"警告";
);--fn end

--////////////////////////////////////////////////
--UIの有効を設定
--////////////////////////////////////////////////
fn uiSet_Fn f t s e  =
(
	if f then
	(
		t.enabled = f;
		s.enabled = f;
		e.enabled = f;
	)else(
		t.enabled = f;
		s.enabled = f;
		e.enabled = f;
	);--if end
	
)--fn end


-----------------------------------------------------------------------------------------------------------
-- Layout
-----------------------------------------------------------------------------------------------------------

	--設定
	GroupBox settingGp "設定" pos:[8,8] width:184 height:156
	label savePathLbl "保存先" pos:[16,28] width:136 height:16
	edittext savePathTxt "" pos:[12,44] width:172 height:16 text:"C:/"
	button savePathBt "パスを取得" pos:[16,68] width:168 height:24

	checkbox delOutRangeKeyChk "範囲外キーの削除" pos:[16,100] width:132 height:16 checked:true
	checkbox saveOriginalChk "オリジナルの保存" pos:[16,120] width:132 height:16 checked:false;
	edittext saveOriginalTxt "Name" pos:[16,140] width:168 height:16 enabled:false;

	button sliceBt "スライス!" pos:[16,768] width:168 height:24


	GroupBox sliceGrp "切り出し範囲" pos:[8,172] width:184 height:628;

	checkbox sliceAChk "切り出し 1" pos:[16,192] width:96 height:16 checked:true;
	edittext sliceATxt "Name" pos:[16,212] width:168 height:16;
	spinner sliceASSpn "" pos:[16,236] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceAESpn "" pos:[104,236] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceBChk "切り出し 2" pos:[16,264] width:96 height:16 checked:true;
	edittext sliceBTxt "Name" pos:[16,284] width:168 height:16;
	spinner sliceBSSpn "" pos:[16,308] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceBESpn "" pos:[104,308] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceCChk "切り出し 3" pos:[16,336] width:96 height:16 checked:true;
	edittext sliceCTxt "Name" pos:[16,356] width:168 height:16;
	spinner sliceCSSpn "" pos:[16,380] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceCESpn "" pos:[104,380] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceDChk "切り出し 4" pos:[16,408] width:96 height:16 checked:true;
	edittext sliceDTxt "Name" pos:[16,428] width:168 height:16;
	spinner sliceDSSpn "" pos:[16,452] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceDESpn "" pos:[104,452] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceEChk "切り出し 5" pos:[16,480] width:96 height:16 checked:true;
	edittext sliceETxt "Name" pos:[16,500] width:168 height:16;
	spinner sliceESSpn "" pos:[16,524] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceEESpn "" pos:[104,524] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceFChk "切り出し 6" pos:[16,552] width:96 height:16 checked:true;
	edittext sliceFTxt "Name" pos:[16,572] width:168 height:16;
	spinner sliceFSSpn "" pos:[16,596] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceFESpn "" pos:[104,596] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceGChk "切り出し 7" pos:[16,624] width:96 height:16 checked:true;
	edittext sliceGTxt "Name" pos:[16,644] width:168 height:16;
	spinner sliceGSSpn "" pos:[16,668] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceGESpn "" pos:[104,668] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

	checkbox sliceHChk "切り出し 8" pos:[16,696] width:96 height:16 checked:true;
	edittext sliceHTxt "Name" pos:[16,716] width:168 height:16;
	spinner sliceHSSpn "" pos:[16,740] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;
	spinner sliceHESpn "" pos:[104,740] width:80 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1;

-----------------------------------------------------------------------------------------------------------
-- パスを取得
-----------------------------------------------------------------------------------------------------------
	on savePathBt pressed do
	(
		--変数を用意
		Local tempLoadFile = undefined;
		--ファイルを取得
		tempLoadFile = getOpenFileName types:"ファイルは何でもかまいません|*.*";
		--ファイルからパスを取得
		if (tempLoadFile != undefined) then savePathTxt.text = getFilenamePath tempLoadFile;
	);--end


-----------------------------------------------------------------------------------------------------------
-- UI設定
-----------------------------------------------------------------------------------------------------------	
	on sliceAChk changed state do uiSet_Fn state sliceATxt sliceASSpn sliceAESpn;
	on sliceBChk changed state do uiSet_Fn state sliceBTxt sliceBSSpn sliceBESpn;
	on sliceCChk changed state do uiSet_Fn state sliceCTxt sliceCSSpn sliceCESpn;
	on sliceDChk changed state do uiSet_Fn state sliceDTxt sliceDSSpn sliceDESpn;
	on sliceEChk changed state do uiSet_Fn state sliceETxt sliceESSpn sliceEESpn;
	on sliceFChk changed state do uiSet_Fn state sliceFTxt sliceFSSpn sliceFESpn;
	on sliceGChk changed state do uiSet_Fn state sliceGTxt sliceGSSpn sliceGESpn;
	on sliceHChk changed state do uiSet_Fn state sliceHTxt sliceHSSpn sliceHESpn;	

	on saveOriginalChk changed state do saveOriginalTxt.enabled = state;

-----------------------------------------------------------------------------------------------------------
-- スライス
-----------------------------------------------------------------------------------------------------------
	on sliceBt pressed do
	(

		if (savePathTxt.text == "") then
		(
			messageBox "保存先のパスが入力されていません!" title:"警告";
			--リターンで処理終了!
			return ();
		);--if end

		suspendEditing()--サスペンドモード
		max create mode--クリエートモードに変更
		with redraw off
		(--再描画禁止
		
			
		--オリジナルを保存
		if saveOriginalChk.state then
		(
			if (saveOriginalTxt.text != "") then
			(
				saveMaxFile (savePathTxt.text + saveOriginalTxt.text);
			)else(warningNoFileName_Fn "オリジナル保存");--if end
		);--if end
		
		
		--////////////////////////////////////////////////
		--範囲外キーを削除
		--////////////////////////////////////////////////
		if delOutRangeKeyChk.state then
		(
			
			
		if (sliceAChk.state) and (sliceASSpn.value < sliceAESpn.value) then saveAndIntervalSet_Fn sliceATxt.text sliceASSpn.value sliceAESpn.value;
		if (sliceBChk.state) and (sliceBSSpn.value < sliceBESpn.value) then saveAndIntervalSet_Fn sliceBTxt.text sliceBSSpn.value sliceBESpn.value;
		if (sliceCChk.state) and (sliceCSSpn.value < sliceCESpn.value) then saveAndIntervalSet_Fn sliceCTxt.text sliceCSSpn.value sliceCESpn.value;
		if (sliceDChk.state) and (sliceDSSpn.value < sliceDESpn.value) then saveAndIntervalSet_Fn sliceDTxt.text sliceDSSpn.value sliceDESpn.value;
		if (sliceEChk.state) and (sliceESSpn.value < sliceEESpn.value) then saveAndIntervalSet_Fn sliceETxt.text sliceESSpn.value sliceEESpn.value;
		if (sliceFChk.state) and (sliceFSSpn.value < sliceFESpn.value) then saveAndIntervalSet_Fn sliceFTxt.text sliceFSSpn.value sliceFESpn.value;
		if (sliceGChk.state) and (sliceGSSpn.value < sliceGESpn.value) then saveAndIntervalSet_Fn sliceGTxt.text sliceGSSpn.value sliceGESpn.value;
		if (sliceHChk.state) and (sliceHSSpn.value < sliceHESpn.value) then saveAndIntervalSet_Fn sliceHTxt.text sliceHSSpn.value sliceHESpn.value;
			
			
			if sliceAChk.state then
			(
				if (sliceATxt.text != "") then
				(
					if sliceASSpn.value < sliceAESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceATxt.text + ".max");
					animationRange = interval sliceASSpn.value sliceAESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceATxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し1");--if end
			);--if end
				
			if sliceBChk.state then
			(
				if (sliceBTxt.text != "") then
				(
					if sliceBSSpn.value < sliceBESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceBTxt.text + ".max");
					animationRange = interval sliceBSSpn.value sliceBESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceBTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し2");--if end
			);--if end
			
			if sliceCChk.state then
			(
				if (sliceATxt.text != "") then
				(
					if sliceCSSpn.value < sliceCESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceCTxt.text + ".max");
					animationRange = interval sliceCSSpn.value sliceCESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceCTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し3");--if end
			);--if end
			
			if sliceDChk.state then
			(
				if (sliceDTxt.text != "") then
				(
					if sliceDSSpn.value < sliceDESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceDTxt.text + ".max");
					animationRange = interval sliceDSSpn.value sliceDESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceDTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し4");--if end
			);--if end
			
			if sliceEChk.state then
			(
				if (sliceETxt.text != "") then
				(
					if sliceESSpn.value < sliceEESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceETxt.text + ".max");
					animationRange = interval sliceESSpn.value sliceEESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceETxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し5");--if end
			);--if end
			
			if sliceFChk.state then
			(
				if (sliceFTxt.text != "") then
				(
					if sliceFSSpn.value < sliceFESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceFTxt.text + ".max");
					animationRange = interval sliceFSSpn.value sliceFESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceFTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し6");--if end
			);--if end
			
			if sliceGChk.state then
			(
				if (sliceGTxt.text != "") then
				(
					if sliceGSSpn.value < sliceGESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceGTxt.text + ".max");
					animationRange = interval sliceGSSpn.value sliceGESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceGTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し7");--if end
			);--if end
			
			if sliceHChk.state then
			(
				if (sliceHTxt.text != "") then
				(
					if sliceHSSpn.value < sliceHESpn.value do
					(
					loadMaxFile (savePathTxt.text + sliceHTxt.text + ".max");
					animationRange = interval sliceHSSpn.value sliceHESpn.value;
					--すべてのオブジェクトのキーを削除		
					delOutRangeKey_Fn();
					saveMaxFile (savePathTxt.text + sliceHTxt.text + ".max");
					);--if end
				)else(warningNoFileName_Fn "切り出し8");--if end
			);--if end
			
		)else(
		--////////////////////////////////////////////////
		--インターバルを設定して保存
		--////////////////////////////////////////////////
		if sliceAChk.state then saveAndIntervalSet_Fn sliceATxt.text sliceASSpn.value sliceAESpn.value;
		if sliceBChk.state then saveAndIntervalSet_Fn sliceBTxt.text sliceBSSpn.value sliceBESpn.value;
		if sliceCChk.state then saveAndIntervalSet_Fn sliceCTxt.text sliceCSSpn.value sliceCESpn.value;
		if sliceDChk.state then saveAndIntervalSet_Fn sliceDTxt.text sliceDSSpn.value sliceDESpn.value;
		if sliceEChk.state then saveAndIntervalSet_Fn sliceETxt.text sliceESSpn.value sliceEESpn.value;
		if sliceFChk.state then saveAndIntervalSet_Fn sliceFTxt.text sliceFSSpn.value sliceFESpn.value;
		if sliceGChk.state then saveAndIntervalSet_Fn sliceGTxt.text sliceGSSpn.value sliceGESpn.value;
		if sliceHChk.state then saveAndIntervalSet_Fn sliceHTxt.text sliceHSSpn.value sliceHESpn.value;

		);--if end
	
		);--end redraw
		
		resumeEditing()--再びアクティブに
		
	);--end
	
	
	
);--end rollout
-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_scene_slicer_rol menu:scene_slicerMenuBar style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;

);--end






