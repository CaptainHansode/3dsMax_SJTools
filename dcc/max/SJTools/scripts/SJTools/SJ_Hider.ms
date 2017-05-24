/*******************************************************
System J Tools 
********************************************************
Name:SJ_Hider
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_hider_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJHiderToolName");

-----------------------------------------------------------------------------------------------------------
--Main
--メインのリスト、一つのフェイスグループ、表示非表示、名前リスト
Local faceList = #();
--facesGroup = #(), faceListFlag = #(), faceListName = #();
Local temp, tempSub, tempName, tempValue = #(), tempGroup = #{};

--ストリング類
Local defaultNameStr = "Group", NumStr = "01", visibleOrHide = #(" | visible"," | hide")
errorStr01 = "ポリゴンが選択されていません"
mesTitle01 = "メッセージ"
errorStr02 = "設定ができません"
mesTitle02 = "メッセージ";

--Local poseListName = #(), poseValue = #(), MasterNodes = undefined, allNodes = #(), customNodes = #(), custom_RNodes = #(), custom_LNodes = #()
--色々
/*
Local  faceListCount = 0, poseValueCount = 0, NumStr = "01", pasteMiss = 0
Local fileLockID = 6564646162
*/
-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_hider_rol)catch()
try(cui.unRegisterDialogBar sj_hider_rol)catch()
try(closeRolloutFloater sj_hider_rol) catch()	
try(destroydialog sj_hider_rol)catch()
-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu hiderMenuBar
(
	subMenu "ファイル"
	(
	menuItem savePoseFileMi "保存" enabled:true;
	menuItem loadPoseFileMi "開く" enabled:true;
	seperator sep01
	menuItem closeMi "終了" enabled:true;
	)--end

	subMenu "ヘルプ"
	( 
	menuItem helpMi "ヘルプ"
	menuItem aboutMi "About"
	menuItem emailMi "E-Mail"
	)--end

	--////////////////////////////////////////////////
	--アクション
	--////////////////////////////////////////////////
	on closeMi  picked do
	(
	try(cui.unRegisterDialogBar sj_hider_rol)catch()
	try(closeRolloutFloater sj_hider_rol) catch()	
	try(destroydialog sj_hider_rol)catch()
	)
	on savePoseFileMi picked do sj_hider_rol.save_Fn();
	on loadPoseFileMi picked do sj_hider_rol.load_Fn();
	on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5890" ""
	on aboutMi picked do sj_functions.sjtools_about_Fn();
	on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
	
	--メニューを開くたびに実行されるアップデート
	on hiderMenuBar update do
	(
	)--end
);--rcMenu end

-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_hider_rol nameAndVersion width:144 height:324;
(

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--
--
--
--リストとその編集
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--リストを作成
/*
アクティブxでリストを作るopen時にこのファンクションを実行
*/
--////////////////////////////////////////////////

/*
fn makeListView_Fn list =
(
	--ビューの種類
	--list.View = #lvwReport;
	--グリッドラインの有無
	list.gridLines = false;
	--上のヘッドラインを表示するか?
	list.View = #lvwReport;
	--選択時に行全体を選択するかの有無
	list.fullRowSelect = true;
	--マルチセレクト
	list.MultiSelect = true;
	
	--レイアウト
	list.Appearance = #ccFlat;
	list.BorderStyle = #ccNone;
	--リストの背景色
	--list.backColor = color 255 255 255;
	
	--チェックボックスを有効にする
	list.checkboxes = true;
	--リストのヘッダーと幅、リストは多次元配列
	Local layout_def = #(#("On/Off",80), #("Num",40));
	--layout_def = #(#("On",40), #("Object Name",120), #("Object Class",80), #("Verts",45), #("Faces",45), #("Material",120));

	--設定した配列を追加
	for i in layout_def do
	(
		column = list.ColumnHeaders.add();
		column.text = i[1];
	);
*/
	/*
	ユーザー変数を2種作成、アドレスと、列の幅
	windowsHandleに送るidが含まれている
	windowsのActiveXコントロールのプログラミングなので、詳しくはWindowsActiveXを参照する
	*/
	
/*
	LV_FIRST = 0x1000;
	LV_SETCOLUMNWIDTH = (LV_FIRST + 30);
	--MaxScriptの配列Indexが1で始まるのに対し、ActiveX側が0で始まる不都合を取り除く
	for i = 0 to layout_def.count-1 do windows.sendMessage list.hwnd LV_SETCOLUMNWIDTH i layout_def[1+i][2];
);--fn end
*/

--////////////////////////////////////////////////
--リストのテスト用
--////////////////////////////////////////////////
fn addTest_Fn list =
(
/*リストをすべてくりあ*/
--.ListSubItemsリストのサブアイテムにアクセスできる
list.ListItems.clear()
 
/*1から順にリストに追加*/
temp = undefined;
	for i = 1 to 12 do
	(
		temp = list.ListItems.add();
		temp.checked = true;
		temp.text = "Group01";

		sub_li = temp.ListSubItems.add();
		sub_li.text = "9999";
		
	);--for end
);--fn end

--////////////////////////////////////////////////
--アップデート
--リストの表示のアップデートを一括で行う
--////////////////////////////////////////////////
fn updateList_Fn =
(
	--一端初期化
	sj_hider_rol.hideListSw.items = #();
	sj_hider_rol.hideListName.items = #();
	if (faceList.count != 0) then
	(
		--まずはOn/Off
		for i=1 to faceList.count do
		(
			if (faceList[i][2]) then
			(
				sj_hider_rol.hideListSw.items[i] = "On";
				--表示を更新
				sj_hider_rol.hideListSw.items =sj_hider_rol.hideListSw.items;
			)else
			(
				sj_hider_rol.hideListSw.items[i] = "Off";
				--表示を更新
				sj_hider_rol.hideListSw.items =sj_hider_rol.hideListSw.items;				
			);--if end
		--次は名前
			sj_hider_rol.hideListName.items[i] = faceList[i][3];
			sj_hider_rol.hideListName.items = sj_hider_rol.hideListName.items;
		);--for end
	);--if end

);--fn end



--////////////////////////////////////////////////
--ポリゴングループを追加
--////////////////////////////////////////////////
fn addList_Fn =
(
	if selection[1].selectedFaces.count == 0 then
	(messageBox(errorStr01)title:mesTitle01)else(
	
	tempName = undefined
	temp = #()
	tempValue = #()
	tempGroup = #{};
	
	for i in selection[1].selectedFaces do
	(
		--選択しているフェイスIndexを回収
		--BitArrayなのでかぶることが無い
		append tempGroup i.index;
	);
	
	--ポリゴングループを格納
	append temp tempGroup;
	
	--フラグ、初期値はtrue（表示）
	append temp true;
	
	--append faceList tempGroup;
	
	--////////////////////////////////////////////////
	--リストの名前の処理
	--////////////////////////////////////////////////
	--数は
	NumStr = (faceList.count as String);
	--数が1だったら、2桁にする
	if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
	--名前を合成する、名前の後ろにはポリゴン数を入れる
	tempName = defaultNameStr + NumStr;
	--tempName = defaultNameStr + NumStr + "   |   " + (selection[1].selectedFaces.count as String);
	
	--次に上記名前を回収
	append temp tempName;
	
	--最後にメインのリストに入れる
	append faceList temp;
	
	--print faceList;
	--アップデートでリストに追加
	updateList_Fn();

	--初期化
	tempName = undefined
	temp = #()
	tempValue = #()
	tempGroup = #{};
	);--if end
);--fn end

--////////////////////////////////////////////////
--allCheck
--////////////////////////////////////////////////
fn checkAllList_Fn list check = 
(
	for i in list.ListItems do
	(
		--print i;
		i.checked = check;
		sj_hider_rol.setPolygonHide_Fn list;
	);--for end
);--fn end

/*通常のコンボボックス用*/

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
--
--
--
--普通のファンクション
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--選択状態をチェック
--////////////////////////////////////////////////
fn selectionCheck_Fn =
(
	--選択しているか?
	if selection.count !=0 then
	(
	--選択物は
		if ((classOf selection[1].baseobject == Editable_Poly) or (classOf selection[1].baseobject == Editable_mesh)) then
		(	
			--チェック結果が良好なら
			return true;
		);--if end
	)--if end
	--チェック結果は気まずい
	return false;
);--fn end

--////////////////////////////////////////////////
--ポリゴンの表示 非表示
--一括で表示非表示を切り替える
--////////////////////////////////////////////////
fn setPolygonHide_Fn =
(
	if selection.count !=0 then
	(
		
		temp = selection[1];
		tempGroup = #{};
	
	with redraw off (--再描画禁止
	undo on (
	
	if (classOf temp.baseobject == Editable_Poly) then
	(
		--一旦すべて表示
		polyOp.unHideAllFaces temp;
		
		--リストの全ての表示非表示を行う
		for i = 1 to faceList.count do
		(
			--false非表示、trueで表示
			if (faceList[i][2] == false) then
			(
				for k in faceList[i][1] do append tempGroup k;
			);--if end
		);--for end
		try(polyOp.setHiddenFaces temp tempGroup)catch(messageBox(errorStr02) title:mesTitle02);

	) else if (classOf temp.baseobject == Editable_mesh) then (
		--一旦すべて表示
		meshOp.setHiddenFaces temp #();
		
		for i = 1 to faceList.count do
		(
			--false非表示、trueで表示
			if (faceList[i][2] == false) then
			(
				for k in faceList[i][1] do append tempGroup k;
			);--if end
		);--for end
		try(meshOp.setHiddenFaces temp tempGroup)catch(messageBox(errorStr02) title:mesTitle02);		
	);--if end

	);--undo end
	);--with redraw end	
	);--if end
	redrawViews()--再描画
);

--////////////////////////////////////////////////
--save
--////////////////////////////////////////////////
fn save_Fn = 
(
	local saveFile = getSaveFileName types:"(*.txt)|*.txt|All(*.*)|*.*" caption:"ポリゴンリストを保存";

	if saveFile != undefined do
	(
		saveFileTemp = createFile saveFile
		format "%\n" faceList to:saveFileTemp
		close saveFileTemp
	);--if end
	
)--fn end

--////////////////////////////////////////////////
--通常の読み込み
--////////////////////////////////////////////////
fn load_Fn =
(
	faceList = #();
	local loadFile = getOpenFileName types:"(*.txt)|*.txt|All(*.*)|*.*" caption:"ポリゴンリストの読み込み";
	
	if loadFile != undefined do
	(
		loadFileTemp = openFile loadFile;
	--バグ回避用にtry catch
	try(
		tempValue = readValue loadFileTemp;
		--既に配列になっているので問題ない
		faceList = tempValue;
		close loadFileTemp;
		updateList_Fn();
	)catch(/*messageBox "未知の形式です\n読み込めませんでした" title:"エラー"*/);
	);--if end

);--fn end

--////////////////////////////////////////////////
--面選択
--////////////////////////////////////////////////
fn faceSelect_Fn sel =
(
--ポリゴン選択
	if ( selection.count !=0 and sel != 0) then
	(
	temp = selection[1];
	--with redraw off (--再描画禁止
	undo on (
	
	if (classOf temp.baseobject == Editable_Poly) then
	(
		try(
			temp.setSelection #Face faceList[sel][1];
		)catch(messageBox(errorStr02) title:mesTitle02);
	) else if (classOf temp.baseobject == Editable_mesh) then (
		try(
		setFaceSelection temp faceList[sel][1];
		)catch(messageBox(errorStr02) title:mesTitle02);
	);--if end

	);--undo end
	--);--with redraw end	
	);--if end
	redrawViews()--再描画

);--fnend

--////////////////////////////////////////////////
--面選択反転
--////////////////////////////////////////////////
fn faceSelectReverse_Fn =
(
	tempGroup = #{};
	tempValue = #{};
	
	if ( selection.count != 0 ) then
	(
	temp = selection[1];
	with redraw off (--再描画禁止
	undo on (
	
	if (classOf temp.baseobject == Editable_Poly) then
	(
		for i in temp.selectedFaces do
		(
			--選択しているIndexを回収
			append tempGroup i.index;	
		);
		--全部の面のIDと比較して配列を反転
		for i in temp.Faces do
		(
			--見つからなければ選択していない
			if ((findItem tempGroup i.index) == 0) then append tempValue i.index;
		);--for end
		try(
		temp.setSelection #Face tempValue;
		)catch(messageBox(errorStr02) title:mesTitle02);
	) else if (classOf temp.baseobject == Editable_mesh) then (
		for i in temp.selectedFaces do
		(
			--選択しているIndexを回収
			append tempGroup i.index;	
		);
		--全部の面のIDと比較して配列を反転
		for i in temp.Faces do
		(
			--見つからなければ選択していない
			if ((findItem tempGroup i.index) == 0) then append tempValue i.index;
		);--for end
		try(
		setFaceSelection temp tempValue;
		)catch(messageBox(errorStr02) title:mesTitle02);
	);--if end

	);--undo end
	);--with redraw end	
	);--if end
	
	tempGroup = #{};
	tempValue = #();
	redrawViews()--再描画

);--fnend



	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
	GroupBox hiderGb "Hider" pos:[4,4] width:136 height:318;
	--edittext hideEdt "" pos:[8,44] width:123 height:16;
	--listbox hideCbx "" pos:[12,60] width:120 height:15 selection:1;
	button addFaceListBt "" pos:[12,20] width:20 height:20 enabled:true toolTip:"リストに追加" images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2);

	button allSelBt "" pos:[36,20] width:20 height:20 enabled:true toolTip:"ポリゴンの選択" images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2)
	button selReverseBt "" pos:[60,20] width:20 height:20 enabled:true toolTip:"選択の反転" images:#("$Scripts/SJTools/Images//SJ_button_replace.png", "$Scripts/SJTools/Images//SJ_button_replace_a.png", 2, 1, 1, 2, 2)

	button deleteBt "" pos:[84,20] width:20 height:20 enabled:true toolTip:"リストの削除" images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2);
	button clearBt "" pos:[108,20] width:20 height:20 enabled:true toolTip:"リストのクリア" images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2);

	--ハイドボタン
	button hideBt "on/off" pos:[12,44] width:44 height:20 enabled:true toolTip:"選択を非表示" --images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2)
	button allUnhideBt "" pos:[60,44] width:20 height:20 enabled:true toolTip:"全て非表示" images:#("$Scripts/SJTools/Images//SJ_button_on.png", "$Scripts/SJTools/Images//SJ_button_on_a.png", 2, 1, 1, 2, 2);
	button allHideBt "" pos:[84,44] width:20 height:20 enabled:true toolTip:"全て表示" images:#("$Scripts/SJTools/Images//SJ_button_off.png", "$Scripts/SJTools/Images//SJ_button_off_a.png", 2, 1, 1, 2, 2);

	editText hideListEdt "" pos:[8,68] width:123 height:16 toolTip:"名前編集";
	listbox hideListSw "" pos:[12,86] width:46 height:15 selection:1 --items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	listbox hideListName "" pos:[56,86] width:76 height:15 selection:1--items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	--listbox hideList "" pos:[82,68] width:34 height:15 selection:1 items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	label mesLbl "ダブルクリックでも\n切り替えられます" pos:[12,290] width:123 height:28;


	--アクティブXリストボックス	
	--activeXControl faceListActiveX "MSComctlLib.ListViewCtrl" pos:[12,900] width:120 height:242;
	
	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[134,314] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

-----------------------------------------------------------------------------------------------------------
-- アクション
-----------------------------------------------------------------------------------------------------------
	--////////////////////////////////////////////////
	--リスト編集
	--////////////////////////////////////////////////
	on addFaceListBt pressed do
	(
		--print faceListActiveX.SelectedItem;
		if selectionCheck_Fn() then (addList_Fn())else();--if end
	);--on end	
	--全て表示
	on allHideBt pressed do
	(
		--全てのフラグをfalseに切り替える
		for i in faceList do i[2] = false;
		setPolygonHide_Fn();
		updateList_Fn();
	);
	--全て非表示
	on allUnhideBt pressed do
	(
		--全てのフラグをtrueに切り替える
		for i in faceList do i[2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
	);
	--削除
	on deleteBt pressed do
	(
		if (faceList.count != 0 and hideListSw.selection != undefined) do deleteItem faceList hideListSw.selection;
		updateList_Fn();
	);
	--クリア
	on clearBt pressed do
	(
		if (faceList.count != 0) do faceList = #();
		updateList_Fn();		
	);--

	--ポリゴン選択
	on allSelBt pressed do
	(
		--空じゃなければ
		if (hideListSw.items.count != 0) do
		(
			faceSelect_Fn hideListSw.selection;
			updateList_Fn();
		);--if end
	);--
	
	--反転
	on selReverseBt pressed do faceSelectReverse_Fn();

	on hideBt pressed do
	(
		--空じゃなければ
		if (hideListSw.items.count != 0) do
		(
		--変数のフラグ部分にアクセス
		if (faceList[hideListSw.selection][2]) then faceList[hideListSw.selection][2] = false else faceList[hideListSw.selection][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);--on end
	
	--ダブルクリックで非表示切り替え
	on hideListSw doubleclicked sel do
	(
		--空じゃなければ
		if (hideListSw.items.count != 0) do
		(
		--変数のフラグ部分にアクセス
		if (faceList[sel][2]) then faceList[sel][2] = false else faceList[sel][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);
	
	on hideListName doubleclicked sel do
	(
		--空じゃなければ
		if (hideListSw.items.count != 0) do
		(
		--変数のフラグ部分にアクセス
		if (faceList[sel][2]) then faceList[sel][2] = false else faceList[sel][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);
	
	--////////////////////////////////////////////////
	--通常のコンボボックス版
	--////////////////////////////////////////////////
	--左右のリストの選択を同期
	on hideListSw selected sel do
	(
		if (sel != 0) do
		(
			hideListName.selection = hideListSw.selection;
			hideListEdt.text = hideListName.selected;
		);--if end
		--hideEdt.text = hideCbx.selected;
	);--on end
	on hideListName selected sel do
	(
		if (sel != 0) do
		(
			hideListSw.selection = hideListName.selection;
			hideListEdt.text = hideListName.selected;
		);--if end
		--hideEdt.text = hideCbx.selected;
	);--on end
	
	--名前変更など
	--エンターが押された時
	on hideListEdt entered str do
	(
		print hideListName.selected;
		
		--空でなければ
		if (str != "" and hideListName.items.count != 0) then
		(
			hideListName.selected = str;
			hideListName.items = hideListName.items;
			hideListName.selection = hideListName.selection;
			hideListEdt.text = str;
			--選択中のindexのグループ名を変更
			faceList[hideListName.selection][3] = str;
		);--if end
	);--end
	
	--変更されたとき
	on hideListEdt changed str do
	(
		if (str != "" and hideListName.items.count != 0) then
		(
			hideListName.selected = str;
		hideListName.items = hideListName.items;
		hideListName.selection = hideListName.selection;
		hideListEdt.text = str;
		--選択中のindexのグループ名を変更
		faceList[hideListName.selection][3] = str;
		);--if end
	);--end
	
	/*
	リストを上下使っていない
	*/
	on upBt pressed do ( if poseCbx.selection != 0 and poseCbx.selection != 1 do ());	
	on downBt pressed do (if poseCbx.selection != 0 and  poseCbx.items.count > poseCbx.selection do ());


	--////////////////////////////////////////////////
	--リサイズイベント
	--////////////////////////////////////////////////
	on sj_hider_rol resized val do
	(
		--基本の大きさを入力
		width = 144;
		height = 324;
		
		--valがリサイズ時の大きさ
		listWidth = 120;
		listHeight = 242;

		if ((sj_hider_rol.width >= 144) and (sj_hider_rol.height >= 320)) do
		(
			--変更する倍率
			ratioW = (val[1] as float) / (width as float);
			ratioH = (val[2] as float) / (height as float);
			--テキストフィールドは-24
			hideListEdt.width = val[1] - 25;
			
			hideListSw.width = 46;
			hideListSw.height =  val[2] - 123;
			
			--リストの幅+10が位置
			--hideListName.pos = [(hideListSw.width+10),86];
			hideListName.width = val[1] - 68;
			hideListName.height = val[2] - 123;
			
			hiderGb.width = val[1] - 8;
			hiderGb.height = val[2] - 8;		
			
			mesLbl.pos = [12,(hideListSw.height+89)];
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
			
		);--if end

	)--end


	--////////////////////////////////////////////////
	--hide and unhide
	--////////////////////////////////////////////////
	on sj_hider_rol open do
	(
		--makeListView_Fn faceListActiveX;
		--addListView_Fn faceListActiveX;
	);--end
	on sj_hider_rol close do
	(
	--gc();
	);

);--rollout end
createDialog sj_hider_rol pos:[50,50] menu:hiderMenuBar /*bgColor:[0,0,0]*/ style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;

);--end macroscript