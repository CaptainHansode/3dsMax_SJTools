/*******************************************************
System J Tools 
********************************************************
Name:SJ_LayerLayer
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバルローカル周り
-----------------------------------------------------------------------------------------------------------
global sj_renamer_rol
global sj_rs_hitobj_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--基本言語ファイル
Local language = getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "Language";
--パスの切り分け
if  (language == "JP") then
(
	--日本語
	Local languageFilePath = "$scripts/SJTools/SJTools_JP.ms";
)else(
	--日本語以外は基本英語
	Local languageFilePath = "$scripts/SJTools/SJTools_EN.ms";
);
--Local languageFile = openFile (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "LanguageFile");
Local languageFile = openFile (languageFilePath);

/*
言語ファイルは、一度readするとStringStream値が移動してしまうので
設定ごとに読み込みをすること！！
*/
--メニュー
/*
skipToString languageFile "rcMenuFileMiStr ="
Local rcMenuFileMiStr ="(readLine languageFile);"
skipToString languageFile "rcMenuHelpMiStr ="
Local rcMenuHelpMiStr =(readLine languageFile);
*/

--全てのツールで共通の文字列
skipToString languageFile "MesseTitleInfoStr =";Local MesseTitleInfoStr = (readLine languageFile);
skipToString languageFile "MesseTitleWngStr =";Local MesseTitleWngStr = (readLine languageFile);
skipToString languageFile "MesseTitleCtnStr =";Local MesseTitleCtnStr = (readLine languageFile);
skipToString languageFile "MesseTitleErrStr =";Local MesseTitleErrStr = (readLine languageFile);
skipToString languageFile "MesseTitleChkStr =";Local MesseTitleChkStr = (readLine languageFile);

skipToString languageFile "MesseCmnErrStr =";Local MesseCmnErrStr = (readLine languageFile);
skipToString languageFile "MesseCmnChkStr =";Local MesseCmnChkStr = (readLine languageFile);
skipToString languageFile "MesseCmnFileErrStr =";Local MesseCmnFileErrStr = (readValue languageFile);
skipToString languageFile "MesseCmnProgStr =";Local MesseCmnProgStr = (readLine languageFile);--しばらくお待ちください

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJRenamerToolName");
-----------------------------------------------------------------------------------------------------------
--なんか色々
Local allOj = #(), hitOj = #(), hitText = undefined, hitCount = 0, k = 0, NumStr = "", NameStr = "";
--フラグ
Local searchType = true

-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_renamer_rol)catch()
try(cui.unRegisterDialogBar sj_renamer_rol)catch()
try(closeRolloutFloater sj_renamer_rol) catch()
try(destroydialog sj_renamer_rol)catch()
try(closeRolloutFloater sj_rs_hitobj_rol) catch()
try(destroydialog sj_rs_hitobj_rol)catch()
try(destroydialog sj_progressBar_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
if  (language == "JP") then
(
rcMenu renamerMenuBar
(
	subMenu "ヘルプ"
	( 
	menuItem helpMi "ヘルプ"
	menuItem aboutMi "About"
	menuItem emailMi "E-Mail"
	seperator sepChangeLang;
	menuItem ChangeLangMi "言語変更(Change Language)";
	)
--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
	on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" ""
	on aboutMi picked do sj_functions.sjtools_about_Fn();
	on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
	on ChangeLangMi	picked do sj_functions.sjtools_changeLanguage_Fn();
on poserMenuBar update do
(
)
)--rcMenu end
)else(
--////////////////////////////////////////////////
--英語
rcMenu renamerMenuBar
(
	subMenu "Help"
	( 
	menuItem helpMi "Help";
	menuItem aboutMi "About";
	menuItem emailMi "E-Mail";
	seperator sepChangeLang;
	menuItem ChangeLangMi "言語変更(Change Language)";
	)
--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
	on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5880" ""
	on aboutMi picked do sj_functions.sjtools_about_Fn();
	on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" "";
	on ChangeLangMi	picked do sj_functions.sjtools_changeLanguage_Fn();
on poserMenuBar update do
(
)
)--rcMenu end
);--if end
-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_renamer_rol nameAndVersion width:200 height:676;
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--検索結果
--////////////////////////////////////////////////
fn hitSelList_Fn=
(
	global sj_rs_hitobj_rol
	try (destroydialog sj_rs_hitobj_rol) catch()
		
		rollout sj_rs_hitobj_rol ((hitOj.count as string) + "件見つかりました" + "  検索結果") width:200 height:336
		(
			Local OjNameTemp = #(), NumStr = "", k = 0;
			
			--////////////////////////////////////////////////
			--レイアウト
			--////////////////////////////////////////////////
				listBox hitOjList "9999件見つかりました" pos:[8,8] width:184 height:17;
				label info2 "ダブルクリックで選択できます" pos:[8,256] width:184 height:16;
				button allSelBt "全て選択" pos:[16,276] width:80 height:24 toolTip:"項目全てを選択します";
				button closeBt "閉じる" pos:[104,276] width:80 height:24 toolTip:"このウィンドウを閉じます";
				button numberingBt "語尾に連番を付ける" pos:[16,308] width:168 height:24 toolTip:"全ての項目の語尾に連番を付けます";
				
			local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
			ImgTag resizeImg "Bitmap" pos:[190,326] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);
			
			
			--////////////////////////////////////////////////
			--アクション
			--////////////////////////////////////////////////			
			on sj_rs_hitobj_rol open do --ロールアウトが開いたとき
			(
				OjNameTemp = #()
				for i=1 to hitOj.count do append OjNameTemp (hitOj[i].name as String)
				hitOjList.items = OjNameTemp
				sj_rs_hitobj_rol.hitOjList.caption = (hitOj.count as string) + "件見つかりました";			
			)--open do end

			--////////////////////////////////////////////////
			--ダブルクリック
			--////////////////////////////////////////////////	
			on hitOjList doubleclicked s do --ダブルクリックで実行するイベントハンドラ
			(
			clearSelection()
			try(selectMore hitOj[s])catch(messageBox("選択した名前のオブジェクトがありません!"))
			)--end

			--////////////////////////////////////////////////
			--全て選択
			--////////////////////////////////////////////////
			on allSelBt pressed do
			(
			suspendEditing()--サスペンドモード
			with redraw off
			(--再描画禁止
			
			sj_functions.sj_progressBar_Fn()
			sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
			clearSelection()
			 	k = 1;
			 	for i in hitOj do--選択テスト開始
				 (
					try(selectMore i)catch(
					messageBox("オブジェクトがシーン上にありません")
					)
				k += 1;
				sj_progressBar_rol.progbar.value = ((100.00/hitOj.count) * k);
				)--for end
				sj_progressBar_rol.progbar.value = 0
				try(destroydialog sj_progressBar_rol)catch()
				
			)--with redraw end	
			resumeEditing()--再びアクティブに
			)--end

			--////////////////////////////////////////////////
			--ナンバリング
			--////////////////////////////////////////////////
			on numberingBt pressed do
			(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
			
			sj_functions.sj_progressBar_Fn()
			sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
				OjNameTemp = #()
			 	k = 1;
			 	for i in hitOj do--選択テスト開始
				 (
					NumStr = (k as String);
					if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
					
					try(
						i.name = i.name + "_" + NumStr;
						append OjNameTemp (i.name as String)
					)
					catch
					(
					messageBox("オブジェクトがシーン上にありません")
					)
				sj_progressBar_rol.progbar.value = ((100.00/hitOj.count) * k);
				k += 1;
				)--for end
				sj_progressBar_rol.progbar.value = 0
				try(destroydialog sj_progressBar_rol)catch()
				hitOjList.items = OjNameTemp
				--try (destroydialog rs_hitobj_rol) catch() --ダイアログを閉じる
	)--with redraw end	
	resumeEditing()--再びアクティブに
			)--end
			
			--////////////////////////////////////////////////
			--キャンセル
			--////////////////////////////////////////////////
			on closeBt pressed do
			(
				try (destroydialog sj_rs_hitobj_rol) catch() --ダイアログを閉じる
			)--end
			
	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_rs_hitobj_rol resized val do
	(
	/*
				listBox hitOjList "9999件見つかりました" pos:[8,8] width:184 height:17
				label info2 "ダブルクリックで選択できます" pos:[8,256] width:184 height:16
				button  "全て選択" pos:[16,276] width:80 height:24
				button  "閉じる" pos:[104,276] width:80 height:24
				button numberingBt "語尾に連番を付ける" pos:[16,308] width:168 height:24
	*/
		
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
			
			
			
		)--rollout rs_hitobj_rol

		--////////////////////////////////////////////////
		--ダイアログクリエート
		--////////////////////////////////////////////////	
		CreateDialog sj_rs_hitobj_rol /*pos:[sj_renamer_rol.pos[1],sj_renamer_rol.pos[2]]*/ style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_resizing, #style_toolwindow) --pos:[50,50]
)--fn end

--////////////////////////////////////////////////
--新規名前
--////////////////////////////////////////////////
fn newName_Fn =
(
suspendEditing()--サスペンドモード
with redraw off
(--再描画禁止
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
	
	if sj_renamer_rol.newNameEdt.text != "" then
	(NameStr = sj_renamer_rol.newNameEdt.text)else(NameStr = "Empty");
	
	--数の設定
	NumStr = "";
	k = 0;
	digitNum = sj_renamer_rol.newNameSpn3.value;
	
	if sj_renamer_rol.withNumberChk.checked then
	(
		--一度代入
		NumStr = (sj_renamer_rol.newNameSpn1.value as String);
		
		for i in selection do
		(
			--数字文字列を合成
			NumStr = ((sj_renamer_rol.newNameSpn1.value + (k*sj_renamer_rol.newNameSpn2.value)) as String);
			
			--桁は足りているか?
			while ( NumStr.count < digitNum) do NumStr = ("0" + NumStr);
			--if NumStr.count < digitNum
			--if NumStr.count == 1 then NumStr = ("0" + NumStr);
			
			--名前を合成
			if sj_renamer_rol.addNumberChk.checked then
			(i.name = i.name + NumStr)else(i.name = NameStr + NumStr);
			
			--プログレス
			sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k);
			k += 1;
		);--for end
		
	)else(
		for i in selection do
		(
			i.name = NameStr;
			sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k);
			k += 1;
		);--for end
	);--if end

	try(destroydialog sj_progressBar_rol)catch()
)--with redraw end	
resumeEditing()--再びアクティブに
);--fn end
--////////////////////////////////////////////////
--置換
--////////////////////////////////////////////////
fn replaceName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
	hitText = undefined
		if sj_renamer_rol.beforeEdt.text != "" then
		(
			k = 1;
			for i in selection do	--sから始まり選択の数だけ！（このときにsという変数が宣言されています）
			(
				hitText = findString i.name sj_renamer_rol.beforeEdt.text	--aに選択オブジェクトから文字列を探す
				if hitText != undefined then	--文字が見つかったら！（検索結果undefindでなければ）
				(
					i.name = replace i.name hitText sj_renamer_rol.beforeEdt.text.count sj_renamer_rol.afterEdt.text	--hitText文字目からxx文字数までを置き換えます
				)--if end
			sj_progressBar_rol.progbar.value = ((100.00/selection.count) * k)
			k += 1;
			)--for end
		sj_progressBar_rol.progbar.value = 0
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);--for end
--////////////////////////////////////////////////
--プレフィックス
--////////////////////////////////////////////////
fn prefixName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
		if sj_renamer_rol.multiNameEdt.text != "" then	--文字列が空かどうか？
		(
			for i=1 to selection.count do
			(
				selection[i].name = sj_renamer_rol.multiNameEdt.text + selection[i].name	--文字を置き換えます
				sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i)
			)--for end
		sj_progressBar_rol.progbar.value = 0
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);-- end
--////////////////////////////////////////////////
--サフィックス
--////////////////////////////////////////////////
fn suffixName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
		if sj_renamer_rol.multiNameEdt.text != "" then
		(
			for i=1 to selection.count do --sから始まり選択の数だけ！（このときにsという変数が宣言されています）
			(
				selection[i].name = selection[i].name + sj_renamer_rol.multiNameEdt.text	--文字を置き換えます
				sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i)
			)--for end
		sj_progressBar_rol.progbar.value = 0
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);--end

--////////////////////////////////////////////////
--n番目プレフィックス
--////////////////////////////////////////////////
fn nPrefixName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
		if sj_renamer_rol.multiNameEdt.text != "" then	--文字列が空かどうか？
		(
			k = selection.count;
			j = 0;
			errorCount = 0;
			nNum = sj_renamer_rol.nNumberSpn.value;
			for i in selection do
			(
				--先頭からn番目までの文字を格納
				tempStrA = substring i.name 1 nNum;--1～指定数まで
				tempStrB = substring i.name (nNum+1) -1;--指定数から最後まで
				i.name = tempStrA + sj_renamer_rol.multiNameEdt.text + tempStrB;--文字列を合成
				sj_progressBar_rol.progbar.value = ((100.00/k) * j)
				j += 1;
			);--for end
		sj_progressBar_rol.progbar.value = 0
		
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
		if (errorCount != 0) then (messageBox("いくつかの名前の変更に失敗しています"))
		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);-- end
--////////////////////////////////////////////////
--n番目サフィックス
--////////////////////////////////////////////////
fn nSuffixName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
		if sj_renamer_rol.multiNameEdt.text != "" then	--文字列が空かどうか？
		(
			k = selection.count;
			j = 0;
			errorCount = 0;
			nNum = sj_renamer_rol.nNumberSpn.value;
			for i in selection do
			(
				--指定文字数を超えていたら
				if (i.name.count < nNum) then
				(
					--名前以上の数値が設定されていたら、先頭に追加するだけでよい
					i.name = sj_renamer_rol.multiNameEdt.text + i.name;
				)
				else
				(
					--先頭からn番目までの文字を格納
					tempStrA = substring i.name 1 (i.name.count - nNum);--1文字目から～指定文字まで
					tempStrB = substring i.name (i.name.count - nNum+1) -1;--指定数から～最後まで
					i.name = tempStrA + sj_renamer_rol.multiNameEdt.text + tempStrB;--文字列を合成
					sj_progressBar_rol.progbar.value = ((100.00/k) * j)
					j += 1;
				);--if end
			);--for end
		sj_progressBar_rol.progbar.value = 0
		
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
		if (errorCount != 0) then (messageBox("いくつかの名前の変更に失敗しています"))

		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);--end

--////////////////////////////////////////////////
--削除
--////////////////////////////////////////////////
fn deleteName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
	hitText = undefined
		if sj_renamer_rol.multiNameEdt.text != "" then
		(
			for i=1 to selection.count do
			(
				hitText = findString selection[i].name sj_renamer_rol.multiNameEdt.text	--aに選択オブジェクトから文字列を探します
				if hitText != undefined then	--文字が見つかったら！（検索結果undefindでなければ）
				(
					selection[i].name = replace selection[i].name hitText sj_renamer_rol.multiNameEdt.text.count ""--文字を置き換えます
				)
				sj_progressBar_rol.progbar.value = ((100.00/selection.count) * i)
			)--for end
		sj_progressBar_rol.progbar.value = 0
		try(destroydialog sj_progressBar_rol)catch()
		)
		else
		(
			try(destroydialog sj_progressBar_rol)catch()
			messageBox("検索文字列が空です!")
		)--if end
		
	)--with redraw end	
	resumeEditing()--再びアクティブに
);-- end
--////////////////////////////////////////////////
--検索
--////////////////////////////////////////////////
fn searchName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
	
	try (destroydialog sj_rs_hitobj_rol) catch() --ダイアログを閉じる
	hitOj = #()
	
	if sj_renamer_rol.searchNameEdt.text != "" then
	(
	allOj = for i in objects collect i --オブジェクトの数だけオブジェクト内容を収集
		k = 1;
		for i in allOj do
		(
			if (findString (i.name as String) sj_renamer_rol.searchNameEdt.text) != undefined do append hitOj i
			sj_progressBar_rol.progbar.value = ((100.00/allOj.count) * k)
			k += 1;
		)--for end

	sj_progressBar_rol.progbar.value = 0
	try(destroydialog sj_progressBar_rol)catch()

		if hitOj.count != 0 then
		(
			hitSelList_Fn()
		)
		else
		(
			messageBox("見つかりませんでした") title:"検索結果"
		)--if end

	)else
	(
		try(destroydialog sj_progressBar_rol)catch()
		messageBox("検索文字列が空です!")
	)--if end
	
	)--with redraw end	
	resumeEditing()--再びアクティブに
);-- end

--////////////////////////////////////////////////
--近い名前
--////////////////////////////////////////////////
fn similarSearchBt_Fn =
(
	Local resultList = #();
	Local tempObj = #();
	hitOj = #();
	
	try (destroydialog sj_rs_hitobj_rol) catch() --ダイアログを閉じる
	allOj = for i in objects collect i.name --オブジェクトの数だけオブジェクト内容を収集
	--判定レベル2で実行
	resultList = sj_functions.sj_searchSimilarStrings_Fn sj_renamer_rol.searchNameEdt.text allOj 3;
	
	--かぶっているものを排除
	resultList = makeUniqueArray resultList;
	--print resultList;
	
	--名前で選択してhitOjに格納
	for i in resultList do
	(
		--いったん配列に回収
		tempObj = (getNodeByName i exact:false ignoreCase:false all:true);
		for u in tempObj do append hitOj u;
	);--for end
	
		if hitOj.count != 0 then
		(
			temp
			hitSelList_Fn()
		)
		else
		(
			messageBox("見つかりませんでした") title:"検索結果"
		)--if end
	
	--クリア
	allOj = undefined;
	gc();

)

--////////////////////////////////////////////////
--ダブルネーム
--////////////////////////////////////////////////
fn doubleNameName_Fn =
(
	suspendEditing()--サスペンドモード
	with redraw off
	(--再描画禁止
	
	sj_functions.sj_progressBar_Fn()
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください"
	
	try (destroydialog sj_rs_hitobj_rol) catch() --ダイアログを閉じる

	allOj = for i in objects collect i --オブジェクトの数だけオブジェクト内容を収集
	hitOj = #()
	hitCount = 0
		k = 1;
		for i in allOj do
		(
		hitCount = 0
			for u in allOj do
			(
			if (matchPattern i.name pattern:u.name ignoreCase:SearchType) == true do hitCount += 1;
			)--for end
		if hitCount > 1 do append hitOj i --カウントが2以上だったら
		
		sj_progressBar_rol.progbar.value = ((100.00/allOj.count) * k)
		k += 1;
		)--for end

	sj_progressBar_rol.progbar.value = 0
	try(destroydialog sj_progressBar_rol)catch()

		if hitOj.count != 0 then
		(
			hitSelList_Fn()
		)
		else
		(
			messageBox("見つかりませんでした") title:"検索結果"
		)--if end

	)--with redraw end	
	resumeEditing()--再びアクティブに
);--end


--////////////////////////////////////////////////
--初期化
--////////////////////////////////////////////////
fn initialize_Fn = (
	sj_renamer_rol.newNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordNews");
	sj_renamer_rol.beforeEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceA");
	sj_renamer_rol.afterEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceB");
	sj_renamer_rol.multiNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordAdd");
	sj_renamer_rol.searchNameEdt.text = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordSearch");
	sj_renamer_rol.newNameSpn1.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "BaseNumber");
	sj_renamer_rol.newNameSpn2.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Steps");
	sj_renamer_rol.newNameSpn3.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Digit");
	sj_renamer_rol.nNumberSpn.value = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "nNumber");
	
	sj_renamer_rol.withNumberChk.checked = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Numbering");
	sj_renamer_rol.addNumberChk.checked = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "OnlyNumbering");

		--uiを設定
		if (sj_renamer_rol.withNumberChk.checked) then
		(
			sj_renamer_rol.baseNoLbl.enabled  = true;
			sj_renamer_rol.stepLbl.enabled  = true;
			sj_renamer_rol.digitLbl.enabled  = true;
			sj_renamer_rol.newNameSpn1.enabled  = true;
			sj_renamer_rol.newNameSpn2.enabled  = true;
			sj_renamer_rol.newNameSpn3.enabled  = true;
			sj_renamer_rol.addNumberChk.enabled = true;
		)
		else
		(
			sj_renamer_rol.baseNoLbl.enabled  = false;
			sj_renamer_rol.stepLbl.enabled  = false;
			sj_renamer_rol.digitLbl.enabled  = false;
			sj_renamer_rol.newNameSpn1.enabled  = false;
			sj_renamer_rol.newNameSpn2.enabled  = false;
			sj_renamer_rol.newNameSpn3.enabled  = false;
			sj_renamer_rol.addNumberChk.enabled = false;
		);--if end
		
		--uiを設定
		if (sj_renamer_rol.addNumberChk.checked) then
		(
			sj_renamer_rol.basenameLbl.enabled = false;
			sj_renamer_rol.newNameEdt.enabled = false;
		)else
		(
			sj_renamer_rol.basenameLbl.enabled = true;
			sj_renamer_rol.newNameEdt.enabled = true;
		);
-----------------------------------------------------------------------------------------------------------
-- UIを設定
-----------------------------------------------------------------------------------------------------------
	--設定するロールアウト
	local rol = sj_renamer_rol
	languageFile = openFile(languageFilePath);
	skipToString languageFile "[SJ_Renamer.ms]";--必ず対象のツールまで一度飛ばす
	skipToString languageFile "similarSearchBt =";
	rol.similarSearchBt.caption = (readLine languageFile);
	skipToString languageFile "toolTip =";
	rol.similarSearchBt.tooltip = (readLine languageFile);
	--Local similarSearchBtStr = (readLine languageFile);
	--print similarSearchBtStr

);--end

--////////////////////////////////////////////////
--設定を保存
--////////////////////////////////////////////////
fn saveIni_Fn = (
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordNews" sj_renamer_rol.newNameEdt.text);
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceA" sj_renamer_rol.beforeEdt.text);
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordReplaceB" sj_renamer_rol.afterEdt.text);
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordAdd" sj_renamer_rol.multiNameEdt.text);
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "LastKeyWordSearch" sj_renamer_rol.searchNameEdt.text);
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "BaseNumber" ((sj_renamer_rol.newNameSpn1.value) as String));
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Steps" ((sj_renamer_rol.newNameSpn2.value) as String));
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Digit" ((sj_renamer_rol.newNameSpn3.value) as String));
	(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "nNumber" ((sj_renamer_rol.nNumberSpn.value) as String));

	
		(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "Numbering" ((sj_renamer_rol.withNumberChk.checked) as String));
		(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJRenamer" "OnlyNumbering" ((sj_renamer_rol.addNumberChk.checked) as String));
);--end

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	GroupBox grp1 "新規" pos:[8,8] width:184 height:188
	label basenameLbl "基本の名前" pos:[16,28] width:164 height:16
	edittext newNameEdt "" pos:[12,44] width:172 height:16
	checkbox withNumberChk "番号付き" pos:[16,66] width:82 height:16 checked:true toolTip:"基本に連番を追加します";
	checkbox addNumberChk "連番だけ" pos:[104,66] width:86 height:16 checked:false toolTip:"基本を付けず連番だけ追加します";
	label baseNoLbl "基本の番号" pos:[16,88] width:72 height:16
	label stepLbl "ステップ" pos:[104,88] width:72 height:16
	label digitLbl "連番の桁数" pos:[16,124] width:72 height:16
	spinner newNameSpn1 "" pos:[16,104] width:80 height:16 range:[0,9999,1] type:#integer scale:1
	spinner newNameSpn2 "" pos:[104,104] width:80 height:16 range:[1,999,1] type:#integer scale:1
	spinner newNameSpn3 "" pos:[16,140] width:80 height:16 range:[1,12,1] type:#integer scale:1
	button newNameBt "名前を変更" pos:[16,164] width:168 height:24 toolTip:"名前を変更"
	
	GroupBox grp2 "置換" pos:[8,204] width:184 height:132
	label beforLbl "検索文字列" pos:[16,224] width:164 height:16
	edittext beforeEdt "" pos:[12,240] width:172 height:16
	label afterLbl "置換文字列" pos:[16,264] width:164 height:16
	edittext afterEdt "" pos:[12,280] width:172 height:16
	button renameSubstringBt "置換" pos:[16,304] width:168 height:24 toolTip:"上記文字列で置換"

	GroupBox grp3 "追加 削除" pos:[8,344] width:184 height:176
	edittext multiNameEdt "" pos:[12,364] width:172 height:16
	button addFNameBt "先頭に追加" pos:[16,388] width:80 height:24 toolTip:"名前の先頭に追加します"
	button addBNameBt "語尾に追加" pos:[104,388] width:80 height:24 toolTip:"名前の語尾に追加します"
	
	label nNumberLbl "n番目に追加" pos:[16,416] width:72 height:16
	spinner nNumberSpn "" pos:[16,432] width:80 height:16 range:[1,99,1] type:#integer scale:1
	button nAddFNameBt "先頭からn番目" pos:[16,456] width:80 height:24 toolTip:"先頭からn番目に追加します"
	button nAddBNameBt "語尾からn番目" pos:[104,456] width:80 height:24 toolTip:"語尾からn番目に追加します"
	
	button deleteNameBt "文字列を削除" pos:[16,488] width:168 height:24 toolTip:"指定の文字列を削除します"

	GroupBox grp4 "検索" pos:[8,528] width:184 height:140
	edittext searchNameEdt "" pos:[12,548] width:172 height:16
	button SearchBt "検索" pos:[16,572] width:168 height:24 toolTip:"指定の文字列で検索します"
	button similarSearchBt "近い名称を検索" pos:[16,604] width:168 height:24 enabled:true toolTip:"指定の文字列に近い名前のオブジェクトを検索します"
	button doubleNameBt "重複名称検索" pos:[16,636] width:168 height:24 toolTip:"シーンから重複した名前を検索します"

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
	on withNumberChk changed state do
	(
		--uiを設定
		if state then
		(
			baseNoLbl.enabled  = true;
			stepLbl.enabled  = true;
			digitLbl.enabled  = true;
			newNameSpn1.enabled  = true;
			newNameSpn2.enabled  = true;
			newNameSpn3.enabled  = true;
			addNumberChk.enabled = true;
		)
		else
		(
			baseNoLbl.enabled  = false;
			stepLbl.enabled  = false;
			digitLbl.enabled  = false;
			newNameSpn1.enabled  = false;
			newNameSpn2.enabled  = false;
			newNameSpn3.enabled  = false;
			addNumberChk.enabled = false;
		);--if end
		
		saveIni_Fn();
	);
	
	on addNumberChk changed state do
	(
		--uiを設定
		if state then
		(
			basenameLbl.enabled = false;
			newNameEdt.enabled = false;
		)else
		(
			basenameLbl.enabled = true;
			newNameEdt.enabled = true;
		);
		
		saveIni_Fn();
	);--end

	on newNameBt pressed do newName_Fn();
	on renameSubstringBt pressed do replaceName_Fn()
	on addFNameBt pressed do prefixName_Fn()
	on addBNameBt pressed do suffixName_Fn()
	on nAddFNameBt pressed do nPrefixName_Fn()
	on nAddBNameBt pressed do nSuffixName_Fn()
	on deleteNameBt pressed do deleteName_Fn()
	on SearchBt pressed do searchName_Fn()
	on similarSearchBt pressed do similarSearchBt_Fn()
	on doubleNameBt pressed do doubleNameName_Fn()

	on newNameEdt changed txt do saveIni_Fn();
	on beforeEdt changed txt do saveIni_Fn();
	on afterEdt changed txt do saveIni_Fn();
	on multiNameEdt changed txt do saveIni_Fn();
	on searchNameEdt changed txt do saveIni_Fn();
	on newNameSpn1 changed val do saveIni_Fn();
	on newNameSpn2 changed val do saveIni_Fn();
	on newNameSpn3 changed val do saveIni_Fn();
	on newNameSpn1 changed val do saveIni_Fn();
	on nNumberSpn changed  val do saveIni_Fn();
	
	on sj_renamer_rol open do initialize_Fn();
)--rollout end

-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_renamer_rol pos:[50,50] menu:renamerMenuBar style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu

)--end macroscript
