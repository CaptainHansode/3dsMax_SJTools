/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Zweihander.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "�ȈՃe�N�X�`���p�X�u��"
	(
		button texPathChangeBt "�e�N�X�`���p�X��u��" width:160
		editText texPathChangeTxt "" width:160 height:16 align:#center;
		button getTexPathBt "�p�X���擾" width:160 align:#center;
	)

-----------------------------------------------------------------------------------------------------------
--���g�p���폜
-----------------------------------------------------------------------------------------------------------
on getTexPathBt pressed do
(
	Local tempLoadFile = undefined;
	tempLoadFile = getOpenFileName types:"�t�@�C���͉��ł����܂��܂���|*.*";
	if (tempLoadFile != undefined) then texPathChangeTxt.text = getFilenamePath tempLoadFile;
);--end
on texPathChangeBt pressed do
(
	Local myBitMap = undefined, myFile = undefined, newPath = undefined, oldFile = undefined, oldPath = undefined;
	--�V�[���Ɏg���Ă���}�e���A���͂��邩�H
	if (sceneMaterials.count == 0) then
	(messageBox("�V�[���Ɏg���Ă���}�e���A��������܂���") title:"���b�Z�[�W";
	)else(

		if (texPathChangeTxt.text == "") then
		(messageBox("�p�X�����͂���Ă��܂���") title:"���b�Z�[�W";
		)else(
		
		if (queryBox("���̍�Ƃ̓A���h�D�ł��܂���\n\n�V�[���̃}�e���A���̃p�X��u�����܂���?")title:"���b�Z�[�W") then
		(
		/*************************************************
		#�����̃t�@�C���p�X�����������遫��		
		**************************************************/
		--newPath = "D:\\FFFF\\";
		newPath = texPathChangeTxt.text;
		
		for i in sceneMaterials do
		(
			--////////////////////////////////////////////////
			--diffuseMap�}�b�v
			--////////////////////////////////////////////////
			try(
			--print i.name
			oldFile = i.diffuseMap.bitmap.fileName;
			oldPath = getFilenamePath oldFile;
			
			--�p�X�����ւ�
			--<�Ώۂ�String> <�J�n�����ԍ�> <�u�������镶����> <�u�������镶��>
			myFile = replace oldFile 1 oldPath.count newPath;
			
			--�r�b�g�}�b�v���擾
			myBitMap = openBitMap myFile;
			
			--�����œ���ւ���
			i.diffuseMap.bitmap = myBitMap;
			)catch();
			
			--////////////////////////////////////////////////
			--opacity�}�b�v
			--////////////////////////////////////////////////
			try(
			--print i.name
			oldFile = i.opacityMap.bitmap.fileName;
			oldPath = getFilenamePath oldFile;
			
			--�p�X�����ւ�
			--<�Ώۂ�String> <�J�n�����ԍ�> <�u�������镶����> <�u�������镶��>
			myFile = replace oldFile 1 oldPath.count newPath;
			
			--�r�b�g�}�b�v���擾
			myBitMap = openBitMap myFile;
			
			--�����œ���ւ���
			i.opacityMap.bitmap = myBitMap;
			)catch();
		);--for end
			
		);--if end--����ւ��̖₢���킹IF
		
		);--if end
		
	);--if end
);
