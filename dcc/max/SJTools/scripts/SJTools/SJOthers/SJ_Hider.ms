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
-- �O���[�o������
-----------------------------------------------------------------------------------------------------------
--���[���A�E�g�p
global sj_hider_rol
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--Version etc ���O���̂�SJTools.ini����
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJHiderToolName");

-----------------------------------------------------------------------------------------------------------
--Main
--���C���̃��X�g�A��̃t�F�C�X�O���[�v�A�\����\���A���O���X�g
Local faceList = #();
--facesGroup = #(), faceListFlag = #(), faceListName = #();
Local temp, tempSub, tempName, tempValue = #(), tempGroup = #{};

--�X�g�����O��
Local defaultNameStr = "Group", NumStr = "01", visibleOrHide = #(" | visible"," | hide")
errorStr01 = "�|���S�����I������Ă��܂���"
mesTitle01 = "���b�Z�[�W"
errorStr02 = "�ݒ肪�ł��܂���"
mesTitle02 = "���b�Z�[�W";

--Local poseListName = #(), poseValue = #(), MasterNodes = undefined, allNodes = #(), customNodes = #(), custom_RNodes = #(), custom_LNodes = #()
--�F�X
/*
Local  faceListCount = 0, poseValueCount = 0, NumStr = "01", pasteMiss = 0
Local fileLockID = 6564646162
*/
-----------------------------------------------------------------------------------------------------------
-- ���[���A�E�g����
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_hider_rol)catch()
try(cui.unRegisterDialogBar sj_hider_rol)catch()
try(closeRolloutFloater sj_hider_rol) catch()	
try(destroydialog sj_hider_rol)catch()
-----------------------------------------------------------------------------------------------------------
--���j���[
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--���j���[
--////////////////////////////////////////////////
rcMenu hiderMenuBar
(
	subMenu "�t�@�C��"
	(
	menuItem savePoseFileMi "�ۑ�" enabled:true;
	menuItem loadPoseFileMi "�J��" enabled:true;
	seperator sep01
	menuItem closeMi "�I��" enabled:true;
	)--end

	subMenu "�w���v"
	( 
	menuItem helpMi "�w���v"
	menuItem aboutMi "About"
	menuItem emailMi "E-Mail"
	)--end

	--////////////////////////////////////////////////
	--�A�N�V����
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
	
	--���j���[���J�����тɎ��s�����A�b�v�f�[�g
	on hiderMenuBar update do
	(
	)--end
);--rcMenu end

-----------------------------------------------------------------------------------------------------------
-- ���C�� Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_hider_rol nameAndVersion width:144 height:324;
(

-----------------------------------------------------------------------------------------------------------
-- �t�@���N�V����
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--
--
--
--���X�g�Ƃ��̕ҏW
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--���X�g���쐬
/*
�A�N�e�B�ux�Ń��X�g�����open���ɂ��̃t�@���N�V���������s
*/
--////////////////////////////////////////////////

/*
fn makeListView_Fn list =
(
	--�r���[�̎��
	--list.View = #lvwReport;
	--�O���b�h���C���̗L��
	list.gridLines = false;
	--��̃w�b�h���C����\�����邩?
	list.View = #lvwReport;
	--�I�����ɍs�S�̂�I�����邩�̗L��
	list.fullRowSelect = true;
	--�}���`�Z���N�g
	list.MultiSelect = true;
	
	--���C�A�E�g
	list.Appearance = #ccFlat;
	list.BorderStyle = #ccNone;
	--���X�g�̔w�i�F
	--list.backColor = color 255 255 255;
	
	--�`�F�b�N�{�b�N�X��L���ɂ���
	list.checkboxes = true;
	--���X�g�̃w�b�_�[�ƕ��A���X�g�͑������z��
	Local layout_def = #(#("On/Off",80), #("Num",40));
	--layout_def = #(#("On",40), #("Object Name",120), #("Object Class",80), #("Verts",45), #("Faces",45), #("Material",120));

	--�ݒ肵���z���ǉ�
	for i in layout_def do
	(
		column = list.ColumnHeaders.add();
		column.text = i[1];
	);
*/
	/*
	���[�U�[�ϐ���2��쐬�A�A�h���X�ƁA��̕�
	windowsHandle�ɑ���id���܂܂�Ă���
	windows��ActiveX�R���g���[���̃v���O���~���O�Ȃ̂ŁA�ڂ�����WindowsActiveX���Q�Ƃ���
	*/
	
/*
	LV_FIRST = 0x1000;
	LV_SETCOLUMNWIDTH = (LV_FIRST + 30);
	--MaxScript�̔z��Index��1�Ŏn�܂�̂ɑ΂��AActiveX����0�Ŏn�܂�s�s������菜��
	for i = 0 to layout_def.count-1 do windows.sendMessage list.hwnd LV_SETCOLUMNWIDTH i layout_def[1+i][2];
);--fn end
*/

--////////////////////////////////////////////////
--���X�g�̃e�X�g�p
--////////////////////////////////////////////////
fn addTest_Fn list =
(
/*���X�g�����ׂĂ��肠*/
--.ListSubItems���X�g�̃T�u�A�C�e���ɃA�N�Z�X�ł���
list.ListItems.clear()
 
/*1���珇�Ƀ��X�g�ɒǉ�*/
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
--�A�b�v�f�[�g
--���X�g�̕\���̃A�b�v�f�[�g���ꊇ�ōs��
--////////////////////////////////////////////////
fn updateList_Fn =
(
	--��[������
	sj_hider_rol.hideListSw.items = #();
	sj_hider_rol.hideListName.items = #();
	if (faceList.count != 0) then
	(
		--�܂���On/Off
		for i=1 to faceList.count do
		(
			if (faceList[i][2]) then
			(
				sj_hider_rol.hideListSw.items[i] = "On";
				--�\�����X�V
				sj_hider_rol.hideListSw.items =sj_hider_rol.hideListSw.items;
			)else
			(
				sj_hider_rol.hideListSw.items[i] = "Off";
				--�\�����X�V
				sj_hider_rol.hideListSw.items =sj_hider_rol.hideListSw.items;				
			);--if end
		--���͖��O
			sj_hider_rol.hideListName.items[i] = faceList[i][3];
			sj_hider_rol.hideListName.items = sj_hider_rol.hideListName.items;
		);--for end
	);--if end

);--fn end



--////////////////////////////////////////////////
--�|���S���O���[�v��ǉ�
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
		--�I�����Ă���t�F�C�XIndex�����
		--BitArray�Ȃ̂ł��Ԃ邱�Ƃ�����
		append tempGroup i.index;
	);
	
	--�|���S���O���[�v���i�[
	append temp tempGroup;
	
	--�t���O�A�����l��true�i�\���j
	append temp true;
	
	--append faceList tempGroup;
	
	--////////////////////////////////////////////////
	--���X�g�̖��O�̏���
	--////////////////////////////////////////////////
	--����
	NumStr = (faceList.count as String);
	--����1��������A2���ɂ���
	if NumStr.count == 1 then NumStr = ( "0"+ NumStr );
	--���O����������A���O�̌��ɂ̓|���S����������
	tempName = defaultNameStr + NumStr;
	--tempName = defaultNameStr + NumStr + "   |   " + (selection[1].selectedFaces.count as String);
	
	--���ɏ�L���O�����
	append temp tempName;
	
	--�Ō�Ƀ��C���̃��X�g�ɓ����
	append faceList temp;
	
	--print faceList;
	--�A�b�v�f�[�g�Ń��X�g�ɒǉ�
	updateList_Fn();

	--������
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

/*�ʏ�̃R���{�{�b�N�X�p*/

--////////////////////////////////////////////////
--�A�b�v�_�E��
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
--���ʂ̃t�@���N�V����
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--�I����Ԃ��`�F�b�N
--////////////////////////////////////////////////
fn selectionCheck_Fn =
(
	--�I�����Ă��邩?
	if selection.count !=0 then
	(
	--�I�𕨂�
		if ((classOf selection[1].baseobject == Editable_Poly) or (classOf selection[1].baseobject == Editable_mesh)) then
		(	
			--�`�F�b�N���ʂ��ǍD�Ȃ�
			return true;
		);--if end
	)--if end
	--�`�F�b�N���ʂ͋C�܂���
	return false;
);--fn end

--////////////////////////////////////////////////
--�|���S���̕\�� ��\��
--�ꊇ�ŕ\����\����؂�ւ���
--////////////////////////////////////////////////
fn setPolygonHide_Fn =
(
	if selection.count !=0 then
	(
		
		temp = selection[1];
		tempGroup = #{};
	
	with redraw off (--�ĕ`��֎~
	undo on (
	
	if (classOf temp.baseobject == Editable_Poly) then
	(
		--��U���ׂĕ\��
		polyOp.unHideAllFaces temp;
		
		--���X�g�̑S�Ă̕\����\�����s��
		for i = 1 to faceList.count do
		(
			--false��\���Atrue�ŕ\��
			if (faceList[i][2] == false) then
			(
				for k in faceList[i][1] do append tempGroup k;
			);--if end
		);--for end
		try(polyOp.setHiddenFaces temp tempGroup)catch(messageBox(errorStr02) title:mesTitle02);

	) else if (classOf temp.baseobject == Editable_mesh) then (
		--��U���ׂĕ\��
		meshOp.setHiddenFaces temp #();
		
		for i = 1 to faceList.count do
		(
			--false��\���Atrue�ŕ\��
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
	redrawViews()--�ĕ`��
);

--////////////////////////////////////////////////
--save
--////////////////////////////////////////////////
fn save_Fn = 
(
	local saveFile = getSaveFileName types:"(*.txt)|*.txt|All(*.*)|*.*" caption:"�|���S�����X�g��ۑ�";

	if saveFile != undefined do
	(
		saveFileTemp = createFile saveFile
		format "%\n" faceList to:saveFileTemp
		close saveFileTemp
	);--if end
	
)--fn end

--////////////////////////////////////////////////
--�ʏ�̓ǂݍ���
--////////////////////////////////////////////////
fn load_Fn =
(
	faceList = #();
	local loadFile = getOpenFileName types:"(*.txt)|*.txt|All(*.*)|*.*" caption:"�|���S�����X�g�̓ǂݍ���";
	
	if loadFile != undefined do
	(
		loadFileTemp = openFile loadFile;
	--�o�O���p��try catch
	try(
		tempValue = readValue loadFileTemp;
		--���ɔz��ɂȂ��Ă���̂Ŗ��Ȃ�
		faceList = tempValue;
		close loadFileTemp;
		updateList_Fn();
	)catch(/*messageBox "���m�̌`���ł�\n�ǂݍ��߂܂���ł���" title:"�G���["*/);
	);--if end

);--fn end

--////////////////////////////////////////////////
--�ʑI��
--////////////////////////////////////////////////
fn faceSelect_Fn sel =
(
--�|���S���I��
	if ( selection.count !=0 and sel != 0) then
	(
	temp = selection[1];
	--with redraw off (--�ĕ`��֎~
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
	redrawViews()--�ĕ`��

);--fnend

--////////////////////////////////////////////////
--�ʑI�𔽓]
--////////////////////////////////////////////////
fn faceSelectReverse_Fn =
(
	tempGroup = #{};
	tempValue = #{};
	
	if ( selection.count != 0 ) then
	(
	temp = selection[1];
	with redraw off (--�ĕ`��֎~
	undo on (
	
	if (classOf temp.baseobject == Editable_Poly) then
	(
		for i in temp.selectedFaces do
		(
			--�I�����Ă���Index�����
			append tempGroup i.index;	
		);
		--�S���̖ʂ�ID�Ɣ�r���Ĕz��𔽓]
		for i in temp.Faces do
		(
			--������Ȃ���ΑI�����Ă��Ȃ�
			if ((findItem tempGroup i.index) == 0) then append tempValue i.index;
		);--for end
		try(
		temp.setSelection #Face tempValue;
		)catch(messageBox(errorStr02) title:mesTitle02);
	) else if (classOf temp.baseobject == Editable_mesh) then (
		for i in temp.selectedFaces do
		(
			--�I�����Ă���Index�����
			append tempGroup i.index;	
		);
		--�S���̖ʂ�ID�Ɣ�r���Ĕz��𔽓]
		for i in temp.Faces do
		(
			--������Ȃ���ΑI�����Ă��Ȃ�
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
	redrawViews()--�ĕ`��

);--fnend



	--////////////////////////////////////////////////
	--���C�A�E�g
	--////////////////////////////////////////////////
	GroupBox hiderGb "Hider" pos:[4,4] width:136 height:318;
	--edittext hideEdt "" pos:[8,44] width:123 height:16;
	--listbox hideCbx "" pos:[12,60] width:120 height:15 selection:1;
	button addFaceListBt "" pos:[12,20] width:20 height:20 enabled:true toolTip:"���X�g�ɒǉ�" images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2);

	button allSelBt "" pos:[36,20] width:20 height:20 enabled:true toolTip:"�|���S���̑I��" images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2)
	button selReverseBt "" pos:[60,20] width:20 height:20 enabled:true toolTip:"�I���̔��]" images:#("$Scripts/SJTools/Images//SJ_button_replace.png", "$Scripts/SJTools/Images//SJ_button_replace_a.png", 2, 1, 1, 2, 2)

	button deleteBt "" pos:[84,20] width:20 height:20 enabled:true toolTip:"���X�g�̍폜" images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2);
	button clearBt "" pos:[108,20] width:20 height:20 enabled:true toolTip:"���X�g�̃N���A" images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2);

	--�n�C�h�{�^��
	button hideBt "on/off" pos:[12,44] width:44 height:20 enabled:true toolTip:"�I�����\��" --images:#("$Scripts/SJTools/Images//SJ_button_allsel.png", "$Scripts/SJTools/Images//SJ_button_allsel_a.png", 2, 1, 1, 2, 2)
	button allUnhideBt "" pos:[60,44] width:20 height:20 enabled:true toolTip:"�S�Ĕ�\��" images:#("$Scripts/SJTools/Images//SJ_button_on.png", "$Scripts/SJTools/Images//SJ_button_on_a.png", 2, 1, 1, 2, 2);
	button allHideBt "" pos:[84,44] width:20 height:20 enabled:true toolTip:"�S�ĕ\��" images:#("$Scripts/SJTools/Images//SJ_button_off.png", "$Scripts/SJTools/Images//SJ_button_off_a.png", 2, 1, 1, 2, 2);

	editText hideListEdt "" pos:[8,68] width:123 height:16 toolTip:"���O�ҏW";
	listbox hideListSw "" pos:[12,86] width:46 height:15 selection:1 --items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	listbox hideListName "" pos:[56,86] width:76 height:15 selection:1--items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	--listbox hideList "" pos:[82,68] width:34 height:15 selection:1 items:#("a", "b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s");
	label mesLbl "�_�u���N���b�N�ł�\n�؂�ւ����܂�" pos:[12,290] width:123 height:28;


	--�A�N�e�B�uX���X�g�{�b�N�X	
	--activeXControl faceListActiveX "MSComctlLib.ListViewCtrl" pos:[12,900] width:120 height:242;
	
	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[134,314] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

-----------------------------------------------------------------------------------------------------------
-- �A�N�V����
-----------------------------------------------------------------------------------------------------------
	--////////////////////////////////////////////////
	--���X�g�ҏW
	--////////////////////////////////////////////////
	on addFaceListBt pressed do
	(
		--print faceListActiveX.SelectedItem;
		if selectionCheck_Fn() then (addList_Fn())else();--if end
	);--on end	
	--�S�ĕ\��
	on allHideBt pressed do
	(
		--�S�Ẵt���O��false�ɐ؂�ւ���
		for i in faceList do i[2] = false;
		setPolygonHide_Fn();
		updateList_Fn();
	);
	--�S�Ĕ�\��
	on allUnhideBt pressed do
	(
		--�S�Ẵt���O��true�ɐ؂�ւ���
		for i in faceList do i[2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
	);
	--�폜
	on deleteBt pressed do
	(
		if (faceList.count != 0 and hideListSw.selection != undefined) do deleteItem faceList hideListSw.selection;
		updateList_Fn();
	);
	--�N���A
	on clearBt pressed do
	(
		if (faceList.count != 0) do faceList = #();
		updateList_Fn();		
	);--

	--�|���S���I��
	on allSelBt pressed do
	(
		--�󂶂�Ȃ����
		if (hideListSw.items.count != 0) do
		(
			faceSelect_Fn hideListSw.selection;
			updateList_Fn();
		);--if end
	);--
	
	--���]
	on selReverseBt pressed do faceSelectReverse_Fn();

	on hideBt pressed do
	(
		--�󂶂�Ȃ����
		if (hideListSw.items.count != 0) do
		(
		--�ϐ��̃t���O�����ɃA�N�Z�X
		if (faceList[hideListSw.selection][2]) then faceList[hideListSw.selection][2] = false else faceList[hideListSw.selection][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);--on end
	
	--�_�u���N���b�N�Ŕ�\���؂�ւ�
	on hideListSw doubleclicked sel do
	(
		--�󂶂�Ȃ����
		if (hideListSw.items.count != 0) do
		(
		--�ϐ��̃t���O�����ɃA�N�Z�X
		if (faceList[sel][2]) then faceList[sel][2] = false else faceList[sel][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);
	
	on hideListName doubleclicked sel do
	(
		--�󂶂�Ȃ����
		if (hideListSw.items.count != 0) do
		(
		--�ϐ��̃t���O�����ɃA�N�Z�X
		if (faceList[sel][2]) then faceList[sel][2] = false else faceList[sel][2] = true;
		setPolygonHide_Fn();
		updateList_Fn();
		);--if end
	);
	
	--////////////////////////////////////////////////
	--�ʏ�̃R���{�{�b�N�X��
	--////////////////////////////////////////////////
	--���E�̃��X�g�̑I���𓯊�
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
	
	--���O�ύX�Ȃ�
	--�G���^�[�������ꂽ��
	on hideListEdt entered str do
	(
		print hideListName.selected;
		
		--��łȂ����
		if (str != "" and hideListName.items.count != 0) then
		(
			hideListName.selected = str;
			hideListName.items = hideListName.items;
			hideListName.selection = hideListName.selection;
			hideListEdt.text = str;
			--�I�𒆂�index�̃O���[�v����ύX
			faceList[hideListName.selection][3] = str;
		);--if end
	);--end
	
	--�ύX���ꂽ�Ƃ�
	on hideListEdt changed str do
	(
		if (str != "" and hideListName.items.count != 0) then
		(
			hideListName.selected = str;
		hideListName.items = hideListName.items;
		hideListName.selection = hideListName.selection;
		hideListEdt.text = str;
		--�I�𒆂�index�̃O���[�v����ύX
		faceList[hideListName.selection][3] = str;
		);--if end
	);--end
	
	/*
	���X�g���㉺�g���Ă��Ȃ�
	*/
	on upBt pressed do ( if poseCbx.selection != 0 and poseCbx.selection != 1 do ());	
	on downBt pressed do (if poseCbx.selection != 0 and  poseCbx.items.count > poseCbx.selection do ());


	--////////////////////////////////////////////////
	--���T�C�Y�C�x���g
	--////////////////////////////////////////////////
	on sj_hider_rol resized val do
	(
		--��{�̑傫�������
		width = 144;
		height = 324;
		
		--val�����T�C�Y���̑傫��
		listWidth = 120;
		listHeight = 242;

		if ((sj_hider_rol.width >= 144) and (sj_hider_rol.height >= 320)) do
		(
			--�ύX����{��
			ratioW = (val[1] as float) / (width as float);
			ratioH = (val[2] as float) / (height as float);
			--�e�L�X�g�t�B�[���h��-24
			hideListEdt.width = val[1] - 25;
			
			hideListSw.width = 46;
			hideListSw.height =  val[2] - 123;
			
			--���X�g�̕�+10���ʒu
			--hideListName.pos = [(hideListSw.width+10),86];
			hideListName.width = val[1] - 68;
			hideListName.height = val[2] - 123;
			
			hiderGb.width = val[1] - 8;
			hiderGb.height = val[2] - 8;		
			
			mesLbl.pos = [12,(hideListSw.height+89)];
			
			--���T�C�Y�C���[�W�̈ʒu
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