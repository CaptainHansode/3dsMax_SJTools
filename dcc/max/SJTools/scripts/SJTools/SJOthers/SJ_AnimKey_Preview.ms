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
-- �O���[�o�����[�J������
-----------------------------------------------------------------------------------------------------------
global sj_animkey_preview_rol
--Version etc
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc ���O���̂�SJTools.ini����
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
--���j���[
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--���j���[
--////////////////////////////////////////////////
rcMenu renamerMenuBar
(
subMenu "�t�@�C��"
(
/*
menuItem saveFileMi "���C���[��ۑ�" enabled:true
menuItem loadFileMi "���C���[��ǂݍ���" enabled:true
--menuItem mergeFileMi "���C���[��Ԃ�����" enabled:true
seperator sep01
menuItem saveSettingFileMi "�ݒ�v���Z�b�g��ۑ�" enabled:true
menuItem loadSettingFileMi "�ݒ�v���Z�b�g��ǂݍ���" enabled:true	
seperator sep02
*/
menuItem closeMi "�I��" enabled:true
)
	
subMenu "�w���v"
( 
menuItem helpMi "�w���v"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
)

--////////////////////////////////////////////////
--�A�N�V����
--////////////////////////////////////////////////
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=8656" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
on layerPresetrMenuBar update do
(
)
)--rcMenu end
-----------------------------------------------------------------------------------------------------------
-- ���C�� Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_animkey_preview_rol nameAndVersion width:200 height:120;
(
-----------------------------------------------------------------------------------------------------------
-- �t�@���N�V����
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--������
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
--���C�A�E�g
--////////////////////////////////////////////////

		--GroupBox grp1 "�v���r���[" pos:[8,8] width:184 height:88
		button previewBt "�L�[���ƂɃv���r���[���쐬" pos:[16,30] width:168 height:24
/*	
		button allLayerDeleteBt "�S�č폜" pos:[16,62] width:168 height:24
		
		edittext layerDelByNameTxt "" pos:[12,124] width:172 height:16
		button layerDelByNameBt "���O�Ń��C���[���폜" pos:[16,148] width:168 height:24

		edittext allLayerPfxTxt "" pos:[12,180] width:172 height:16
		button allLayerPfxBt "�S���C���[�Ƀv���t�B�b�N�X" pos:[16,204] width:168 height:24

		edittext allLayerDlPxTxt "" pos:[12,236] width:172 height:16
		button allLayerDlPxBt "�S���C���[�Ώە������폜" pos:[16,260] width:168 height:24


		GroupBox grp2 "���C���[�ݒ�v���Z�b�g" pos:[8,300] width:184 height:188
		edittext layerPresetEdt "" pos:[12,320] width:172 height:16 
		listbox layerPresetCbx "" pos:[16,336] width:168 height:9 selection:1 items:#("aaa","bbb","ccc")
		GroupBox grp5 "������Ő���" pos:[8,104] width:184 height:188
		label lbl1 "�_�u���N���b�N�Ő؂�ւ��܂�" pos:[16,466] width:144 height:16

			local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
			ImgTag resizeImg "Bitmap" pos:[190,482] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);
*/

	
-----------------------------------------------------------------------------------------------------------
--���g�p���폜
-----------------------------------------------------------------------------------------------------------
	--���O�ύX�Ȃ�
	--�G���^�[�������ꂽ��
	on previewBt pressed do
	(
		local selNode = selection[1];
		local bipNode = undefined;
		local animKeys = #();
		local previewKeys = #();
		local k=0, j=0;
		local isBip = false;
		local isDoit = false;
		
		--bitArray�ł��Ԃ�h�~
		--local animKeys = #{};
		
		append animKeys 0f;
		
		--�I���������m��Biped���H
		if (classOf selNode == Biped_Object) then
		(
			bipNode = selNode.controller.rootNode;
			isBip = true;
			print "�I����Biped�ł�";
		)
		/*
		else if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--���t�@�����X�΍�
				(
			bipNode = selNode.controller.rootNode;
			isBip = true;
			print "�I���̓��t�@�����X��Biped�ł�";
		)
		*/
		else(
				if ((classOf selNode) == XRefObject) then --���t�@�����X�������ꍇ
				(
				if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--���t�@�����X�΍�
				(
					bipNode = selNode.controller.rootNode;
					isBip = true;
					print "�I���̓��t�@�����X��Biped�ł�";
				)else(
					messageBox("�I�𕨂̃��t�@�����X�悪Biped�ł͂Ȃ��悤�ł�\nBiped��I�����Ď��s���Ă�������") title:"���m�点";
					isBip = false;					
				);--if end
				)else
				(
				--���ׂĎ��s�������ꍇ
					messageBox("�I�𕨂�Biped�ł͂Ȃ��悤�ł�\nBiped��I�����Ď��s���Ă�������") title:"���m�点";
					isBip = false;
				);--if end
			
			);--if end
/*
		try(			
		if ((classOf selNode) == XRefObject) do --���t�@�����X�������ꍇ
		(

		if ((classOf (selNode.GetSourceObject true)) == Biped_Object) then--���t�@�����X�΍�
		(
			bipNode = selNode.controller.rootNode;
			isBip = true;
		)
		else(
			--messageBox("�I�𕨂�Biped�ł͂Ȃ��悤�ł�\nBiped��I�����Ď��s���Ă�������") title:"���m�点";
			isBip = false;
			);--if end
		);--if end
		)catch();
*/
		
		
		if isBip do(
	--////////////////////////////////////////////////
	--�L�[�����
	--////////////////////////////////////////////////
		--���[�g
		--���{��R���g���[���[���܂܂�Ă���̂Ō��݂͋@�\���Ȃ�
		for i in (bipNode.controller.keys) do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--���r
		for i in (biped.getNode bipNode 1).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--�E�r
		for i in (biped.getNode bipNode 2).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--����
		for i in (biped.getNode bipNode 5).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--�E��
		for i in (biped.getNode bipNode 6).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--�w��
		for i in (biped.getNode bipNode 9).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--��
		for i in (biped.getNode bipNode 11).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		
		--������
		try(
		for i in (biped.getNode bipNode 10).controller.keys do
		(
			appendIfUnique animKeys i.time
		);--for end
		)catch();
		
		--�L�[�𐮗�
		sort animKeys;
		makeUniqueArray animKeys;
		
		--print animKeys[0];
		
		for i=2 to animKeys.count do
		(
			--����������t���[�����v�Z
			k = animKeys[i] - animKeys[i-1];
			--print k
			--����������t���[�������L�[�����
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
			
			print"�L�[�͐���ł�";
			
			if (queryBox("�}�C�i�X�t���[���ɃL�[  ("+ (previewKeys[1] as String) + ")  ���ł���Ă���܂�\n���s���܂���?
				
�}�C�i�X�t���[���ɃL�[���ł���Ă���ꍇ��
�^�C�������W���}�C�i�X����n�߂Ă�������\n
") title:"���m�点") then
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
				--���ׂĎ��s�������ꍇ
				messageBox("�쐬����L�[������܂���ł���") title:"���m�点";
				isDoit = false;
				--break();
		);--if end

		
		
		if isDoit do
		(
	--////////////////////////////////////////////////
	--�v���r���[�쐬
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
			
			messageBox("����̕ۑ����"+((getDir #preview)+"\quickpreview.avi")+"�ł�") title:"���m�点"
		);--if end
			
			
		);--if end
		
	);--end
	
	--////////////////////////////////////////////////
	--�J�����Ƃ�
	--////////////////////////////////////////////////
	on sj_animkey_preview_rol open do
	(
		messageBox("����i�ł�")title:"���m�点";
	)


	--////////////////////////////////////////////////
	--���T�C�Y�C�x���g
	--////////////////////////////////////////////////
	on sj_rs_hitobj_rol resized val do
	(

		width = 200;
		height = 336;
		
		--val�����T�C�Y���̑傫��
		--1����
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
			
			--���T�C�Y�C���[�W�̈ʒu
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