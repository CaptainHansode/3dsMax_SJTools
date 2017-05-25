/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_LayerLaer.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.CaptainHansode
*******************************************************/
	group "���C���[�@���C���["
	(
		button uselessLayerDeleteBt "���g�p���C���[�폜" width:160
		
		button allLayerDeleteBt "�S�Ẵ��C���[���폜" width:160
		
		button layerDelByNameBt "���O�Ń��C���[�폜" width:160
		editText layerDelByNameTxt "" width:160 height:16 align:#center;
		
		button allLayerPfxBt "�S���C���[�Ƀv���t�B�b�N�X" width:160
		editText allLayerPfxTxt "" width:160 height:16 align:#center;
		button allLayerDlPxBt "�S���C���[�Ώە������폜" width:160
		editText allLayerDlPxTxt "" width:160 height:16 align:#center;
	);

-----------------------------------------------------------------------------------------------------------
--���g�p���폜
-----------------------------------------------------------------------------------------------------------
on uselessLayerDeleteBt pressed do
(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--���C���[�̐�
	layerCount = (layermanager.count - 1);
	
	--���C���[���ɃI�u�W�F�N�g���������C���[�̖��O�����
	for i = 1 to layerCount do
	(
		--���C���[���擾
		layer = layermanager.getlayer i;
		--refs.dependents�p�ɓo�^
		layerRT = layer.layerAsRefTarg;
		
		--�]�������J�E���g3�����������ꍇ�ɂ��̖��O�����
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;

	);--for end
	
	--print tagLayer;
	--�������C���[�폜	
	for i in tagLayer do layermanager.deleteLayerByName i
	
);

-----------------------------------------------------------------------------------------------------------
--�S���폜
-----------------------------------------------------------------------------------------------------------
on allLayerDeleteBt pressed do
(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--���C���[�̐�
	layerCount = (layermanager.count - 1);
	
	
	--��{���C���[���m��
	layer = layermanager.getlayer 0;
	--�J�����g�ɐݒ�
	layer.current = true;	
	
	--�S�I�u�W�F�N�g�����C���[0�ԂɈړ�
	for i in objects do
	(
		--���C���[�ɒǉ�
		layer.addnode i;
	);--for end
	
	
	--���C���[���ɃI�u�W�F�N�g���������C���[�̖��O�����
	for i = 1 to layerCount do
	(
		--���C���[���擾
		layer = layermanager.getlayer i;
		append tagLayer layer.name;
		
		/*
		--refs.dependents�p�ɓo�^
		layerRT = layer.layerAsRefTarg;
		
		--�]�������J�E���g3�����������ꍇ�ɂ��̖��O�����
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
		*/
		
	);--for end
	
	--print tagLayer;
	--�������C���[�폜	
	for i in tagLayer do layermanager.deleteLayerByName i
	
);
-----------------------------------------------------------------------------------------------------------
--���O�Ń��C���[���폜
-----------------------------------------------------------------------------------------------------------
on layerDelByNameBt pressed do
(
	if (layerDelByNameTxt.text != "") then
	(
	
	--�v���O���X
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "���΂炭���҂���������";
	
	clearSelection();
	suspendEditing()--�T�X�y���h���[�h
	max create mode--�N���G�[�g���[�h�ɕύX
	with redraw off
	(--�ĕ`��֎~
	
	Local layerCount, layer, layerRT, layerRefs, hitText
	Local tagLayer = #(), tagObj = undefined;
	
	--���C���[�̐�
	layerCount = (layermanager.count - 1);
	
	--////////////////////////////////////////////////
	--���C���[0�̃I�u�W�F�N�g���폜
	--////////////////////////////////////////////////
	if (queryBox("0���C���[�̃I�u�W�F�N�g���폜���܂���?")title:"���b�Z�[�W") then
	(
	layer = layermanager.getlayer 0;
	layerRT = layer.layerAsRefTarg;
	layerRefs = refs.dependents layerRT;
	if layerRefs.count >= 3 then
	(
		--���C���[���Q�Ƃ��Ă���I�u�W�F�N�g�����
		layer.nodes &tagObj;
		delete tagObj;
		/**********************
		����͏]����������̑S�Ă�I�����Ă��܂�
		���Ƃ��΁A���C���[���Ⴄ���R���X�g���C���g�Ō��΂�Ă���I�u�W�F�N�g�Ȃ�
		--�I�u�W�F�N�g���폜
		for i = 1 to layerRefs.count do
		(
			--print i;
			--print layerRefs[i];
			--if (layerRefs[i] != ReferenceTarget:BaseLayer) or (layerRefs[i] != ReferenceTarget:Scene) then
			--(append tagObj layerRefs[i]);
			if isvalidnode layerRefs[i] then append tagObj layerRefs[i];
		);--for end
		***********************/
	);--if end
	);--if end
	--////////////////////////////////////////////////
	--�����܂�
	--////////////////////////////////////////////////
	
	--������
	tagObj = undefined;
	
	--���C���[���ɃI�u�W�F�N�g���������C���[�̖��O�����
	for i = 1 to layerCount do
	(
		sj_progressBar_rol.progbar.value = ((100.0/layerCount) * i);
	
		--���C���[���擾
		layer = layermanager.getlayer i;
		--refs.dependents�p�ɓo�^
		layerRT = layer.layerAsRefTarg;
		--�]�������J�E���g3�����������ꍇ�ɂ��̖��O�����
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
		--���C���[�̖��O���猩���č폜
		hitText = findString layer.name layerDelByNameTxt.text;
		--����������������I�i��������undefind�łȂ���΁j
			if hitText != undefined then
			(
				append tagLayer layer.name;
				layerRefs = refs.dependents layerRT;
				
				--////////////////////////////////////////////////
				--�q�b�g�������C���[�̃I�u�W�F�N�g���폜
				--////////////////////////////////////////////////
				if (queryBox(layer.name + "  �̓I�u�W�F�N�g���ƍ폜���܂���?")title:"���b�Z�[�W") then
				(
				if layerRefs.count >= 3 then
				(
					layer.nodes &tagObj;
					delete tagObj;
					/**********************
					����͏]����������̑S�Ă�I�����Ă��܂�
					���Ƃ��΁A���C���[���Ⴄ���R���X�g���C���g�Ō��΂�Ă���I�u�W�F�N�g�Ȃ�
					--�I�u�W�F�N�g���폜
					for i = 1 to layerRefs.count do
					(
						--print i;
						--print layerRefs[i];
						if isvalidnode layerRefs[i] then append tagObj layerRefs[i];
					);--for end
					***********************/
				);--if end
				);--if end
				--////////////////////////////////////////////////
				--�����܂�
				--////////////////////////////////////////////////	
			);--if end
		tagObj = undefined;
	);--for end
	--�������C���[�폜	
	for i in tagLayer do try( layermanager.deleteLayerByName i )catch();
	try(destroydialog sj_progressBar_rol)catch();
	)--with redraw end	
	resumeEditing()--�ĂуA�N�e�B�u��
	);--if end
);

-----------------------------------------------------------------------------------------------------------
--�S�Ẵ��C���[�Ƀv���t�B�b�N�X
-----------------------------------------------------------------------------------------------------------
on allLayerPfxBt pressed do
(
	--�e�L�X�g�͂��邩�H
	if (allLayerPfxTxt.text != "") then
	(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--���C���[�̐�
	layerCount = (layermanager.count - 1);
	
	--���C���[���ɃI�u�W�F�N�g���������C���[�̖��O�����
	for i = 1 to layerCount do
	(
		--���C���[���擾
		layer = layermanager.getlayer i;
		--���C���[�̖��O��ς���
		layer.setname (allLayerPfxTxt.text + layer.name);

	);--for end
	
	)else(messageBox"�e�L�X�g�����͂���Ă��܂���"title:"�G���[");--if end
);
-----------------------------------------------------------------------------------------------------------
--�S�Ẵ��C���[�̃v���t�B�b�N�X���폜
-----------------------------------------------------------------------------------------------------------
on allLayerDlPxBt pressed do
(
	--�e�L�X�g�͂��邩�H
	if (allLayerDlPxTxt.text != "") then
	(

	Local layerCount, layer, layerRT, hitText, myText;
	Local tagLayer = #();
	
	--���C���[�̐�
	layerCount = (layermanager.count - 1);
	
	--���C���[���ɃI�u�W�F�N�g���������C���[�̖��O�����
	for i = 1 to layerCount do
	(
		--���C���[���擾
		layer = layermanager.getlayer i;
		--���C���[�̖��O���猩���č폜
		hitText = findString layer.name allLayerDlPxTxt.text;
		--����������������I�i��������undefind�łȂ���΁j
				if hitText != undefined then
				(
					--���������ɂ͂��Ȃ�
					if (layer.name.count != allLayerDlPxTxt.text.count) then
					(
					--������������̕����ɕ�����u�������܂�
					--<�Ώۂ�String> <�J�n�����ԍ�> <�u�������镶����> <�u�������镶��>
					myText = replace layer.name hitText allLayerDlPxTxt.text.count "";
					layer.setname myText;
					);--if end
				);--ifend
	);--for end
	
	)else(messageBox"�e�L�X�g�����͂���Ă��܂���"title:"�G���[");--if end
);
