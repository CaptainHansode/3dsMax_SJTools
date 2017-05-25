/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Others.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Corve Hide/UnHide"
	(
		button cvHideBt "�\���؂�ւ�" width:160
	)

	group "Boost Heap"
	(
		button boostHeapBt "���E�܂Ńq�[�v�̈���m��" width:160;
		button heapSizeUpBt "�l�Ńq�[�v�̈���m��" width:160;
		spinner heapSizeUpSpn "�P�ʂ�M�ł�" range:[0.1,999,1] type:#integer width:160 align:#center;
	)

	group "Inode Handle Check"
	(
		button ihCheckBt "Inode Handle Call" width:160
	)

	group "Show Propaties & Class"
	(
		button showPBt "Show Properties " width:160
		editText showPTxt "�v���p�e�B��" width:160 height:16
		label showLbl1 "baseObject--�x�[�X�I�u�W�F�N�g" width:160
		label showLbl2 "modifiers[#Control]--���f�B�t�@�C�A" width:160
		label showLbl3 "CustomNodes--�C��" width:160	
		button showCBt "Show Class" width:160
		editText showCTxt "�N���X��" width:160 height:16
		label showCLbl1 "path*--���C���h�J�[�h���ۂ�" width:160
	)

/*
	group "nodeTransformMonitor"
	(
		pickbutton ntmAddBt "add"
		editText ntmNameTxt "�ϐ���"--pos:[12,80] width:172 height:16 
		spinner ntmIndex "" range:[1,1000,1] type:#integer --pos:[220,116]  width:80 height:16 
	)
*/


--////////////////////////////////////////////////
--Action
--////////////////////////////////////////////////
--////////////
--�J�[�u��\��
--///////////
	on cvHideBt pressed do
	(
		if selection.count != 0 then
		(
			actionMan.executeAction 0 "276"
		)
		else
		(
			messageBox ("�I�u�W�F�N�g��I�����Ă�����s���Ă�������") title:"�x��"
		)--if end
	)--

--////////////////////////
--�q�[�v�̈���m��
--////////////////////////
	on boostHeapBt pressed do
	(

	if queryBox ("
****************************************************************
�x��

�q�[�v�̈���ی��Ȃ����x�܂ň����グ�܂���
Max�̓��삪�s����ɂȂ�܂�
�\�����Ȃ��V���b�g�_�E�����N����\��������܂�

���₵���q�[�v�̈�͌��炷���Ƃ��o���܂���
�q�[�v�̈�����Z�b�g����ꍇ��Max���ċN�����Ă�������

���s���܂���?

****************************************************************
"
) == true do (
		Local bHError = false;
		while bHError == false do
		(	
			--10M�Âq�[�v�T�C�Y���グ��
			try(heapSize += 10000000)catch(bHError = true)
		);--while end
		
		messageBox ("�ȉ��̃T�C�Y�܂Ńq�[�v�̈���m�ۂ��܂���\n" + (heapSize as String)) title:"���b�Z�[�W"
		
);--if end
		
	);--end
	
--////////////////////////
--�q�[�v�̈���g��
--////////////////////////
	on heapSizeUpBt pressed do
	(
		try(heapSize += (heapSizeUpSpn.value * 1000000);
		messageBox ("�ȉ��̃T�C�Y�܂Ńq�[�v�̈���m�ۂ��܂���\n" + (heapSize as String)) title:"���b�Z�[�W"
		)catch(messageBox"�g���Ɏ��s���܂����B�q�[�v�T�C�Y�����₹�܂���" title:"�G���[");
	);--end
	

--////////////////////////
--InodeHandleCheck
--////////////////////////
	on ihCheckBt pressed do
	(
		Local ihNom = 0
		if selection.count != 0 do
		(
			for i = 1 to selection.count do
			(	
			ihNom = selection[i].inode.handle
			messageBox ((selection[i].name as String) + " is\n" + (ihNom as String))
			)
		--message "�R���X�g���C���g�Ώۂ̃I�u�W�F�N�g��I�����Ă��������B"
		)
	)
	
--////////////////////////
--Show 
--////////////////////////
	on showPBt pressed do
	(
		if showPTxt.text != "" then(
			for i in selection do
			(
				temp = "$"+ i.name + "." + showPTxt.text;
				try(
				temp = execute(temp);
				ShowProperties temp;
				)catch();
			)--for end
		)
		else(
			for i in selection do ShowProperties i;
		)--if end
	)--end
	
	on showCBt pressed do
	(
		showClass showCTxt.text
	)--end

	
--////////////////////////
--�I���W�I���g�����
--////////////////////////
	on srchnumBt pressed do
	(
		local float gnum = 0
		local float v = 0
		local float f = 0
		local float tmesh = 0
		--local float s = selection.count

			for i = 1 to selection.count do
			(
				try(	--�I�u�W�F�N�g�����b�V���������ꍇ�����ȉ������s
				tmesh = snapshotAsMesh selection[i] --TriMesh �X�i�b�v�V���b�g���쐬���܂��ATriMesh�X�i�b�v�V���b�g�����邱�ƂŐ��m�ȃ|���S�����Ȃǂ𓾂��܂�
				v += tmesh.numverts
				f += tmesh.numfaces
				gnum += 1
				--v += tmesh.verts.count�@--�R���ł�������
				--f += tmesh.faces.count
				)catch()--try end
			)--for end
			infoSelect.caption = gnum as string
			infoVers.caption = v as string
			infoFaces.caption =  f as string
	)
	
--////////////////////////
--�G�L�X�|�[�g
--////////////////////////
	on makeFileBt pressed do
	(
		local float v = 0
		local float f = 0
		local float smesh = 0
		local float tmesh = 0
		local float num_verts = 0
		local float num_face = 0
		local float Selectnum = 0
		local out_name = getSaveFileName types:"Object Info(*.txt)|*.txt"	--Max�f�t�H���g�̃f�B���N�g���ʒu�ɐݒ肷��ϐ�

		try(	

		out_file = createfile out_name	--out_name�Ńt�@�C�������w�肵���t�@�C�����쐬����ϐ���錾

			--�I���I�u�W�F�N�g�̏����t�@�C���ɏ�������
			for i = 1 to selection.count do
			(
			
			try(	--�I�u�W�F�N�g�����b�V���������ꍇ�����ȉ������s
			
				smesh = snapshotAsMesh selection[i]
				Selectnum += 1
				v += smesh.numverts
				f += smesh.numfaces
			
			)catch()
			
			)
			format "Total,%\nTotalVertex,%\nTotalFace,%" Selectnum v f to:out_file

			format "\n" to:out_file	--�r���ɉ��s������
			format "\n" to:out_file	--�r���ɉ��s������

			--��������e�W�I���g��
			for i = 1 to selection.count do
			(
			
			try(	--�I�u�W�F�N�g�����b�V���������ꍇ�����ȉ������s
			
				tmesh = snapshotAsMesh selection[i]
				Name = selection[i].name	--�ϐ��ɑ��
				num_verts = tmesh.numverts	--�ϐ��ɑ��
				num_faces = tmesh.numfaces	--�ϐ��ɑ�
				format "Name,%\nVertex,%\nFace,%" Name num_verts num_faces to:out_file
				format "\n" to:out_file	--�r���ɉ��s������
				--progbar.value = ((100.00/selection.count)*i)
			
			)catch()
			
			)
			close out_file
			--progbar.value = 0
		)catch()
		--edit out_name	--�ۑ���ɓ��e���m�F�������ꍇ�̓R�����g�A�E�g���O��
	)