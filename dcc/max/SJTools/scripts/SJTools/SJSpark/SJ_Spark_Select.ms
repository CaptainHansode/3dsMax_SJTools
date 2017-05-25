/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Select.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
		group "Select"
		(
			button selectAllBranchBt "�e�q�\����S�I��" width:160
		)
-----------------------------------------------------------------------------------------------------------
-- �ȉ�����
-----------------------------------------------------------------------------------------------------------
--////////////
--�I�����b�V���̑I�𒸓_��Null��z�u����
--///////////
	on selectAllBranchBt pressed do
	(
--�V�E�\����S���I������
	with redraw off
	(--�ĕ`��֎~
	
	--�K�w�\����S�Ď擾
	if selection.count != 0 then
	(
	--�ϐ�������
	Local objRoot = selection[1],
	obj = undefined;
	objectBranch = #();--��������q��
	checkObj = undefined;--�`�F�b�N����I�u�W�F�N�g
	checkChildren = #();--�`�F�b�N����I�u�W�F�N�g�̔z��
		
		--�I���������̂̊K�w�������̂ڂ�A�e�I�u�W�F�N�g�������Ȃ�������
		while objRoot.parent != undefined do
		(
			 objRoot = objRoot.parent
		)--while end
	
		--�z��Ɋi�[
		append objectBranch objRoot
		
		--�q���̐�������
		numChild = objRoot.children.count;
		--�������
		for i =1 to objRoot.children.count do
		(
			--2�ɉ��
			append checkChildren objRoot.children[i];
			append objectBranch objRoot.children[i];
		);--for end
		
		--0�ɂȂ�܂ŌJ��Ԃ�
		while numChild != 0 do
		(
			--deleteItem checkChildren 1;
			checkObj = checkChildren[numChild];
			
			--�`�F�b�N�p�z�񂩂�̂����肩��폜
			deleteItem checkChildren numChild;
			numChild -= 1;			
			
			--�q�͂��邩�H
			if (checkObj.children.count != 0) then
			(
				--print "�L��";
				numChild += checkObj.children.count;--�J�E���g�A�b�v
				for i =1 to checkObj.children.count do
				(
					append checkChildren checkObj.children[i];
					append objectBranch checkObj.children[i];
				);--for end
			)else
			(
				--�q��������Ȃ����
				--print "����"
			);--if end
			--checkObj += objRoot.children[numChild];
		);
		--�Ō�ɑI��
		select objectBranch;
		print "�I���I��";

	);--if end
	
	)--with redraw end
		
	/*************************����	
	with redraw off
	(--�ĕ`��֎~
	
	--�K�w�\����S�Ď擾
	if selection.count != 0 then
	(
	--�ϐ�������
	Local objectBranch = #()
	allObj = for i in objects collect i;
	objRoot = selection[1];
	obj = undefined;
		
		--�I���������̂̊K�w�������̂ڂ�A�e�I�u�W�F�N�g�������Ȃ�������
		while objRoot.parent != undefined do
		(
			 objRoot = objRoot.parent
		)--while end
	
		--�z��Ɋi�[
		append objectBranch objRoot
	
		--���ׂẴI�u�W�F�N�g����
		for i in allObj do
		(
		 obj = i;
		
		--�I�u�W�F�N�g�̐e���������Ă����
		 while obj.parent != undefined do
		 (
			obj = obj.parent;
		 )--while end
		
		 --�����Ƃ��e�̊K�w�������Ȃ�΃I�u�W�F�N�g��z�񖳂��ɉ��
		 if obj == objRoot then append objectBranch i;
		)--for end
	
	--�Ō�ɑI��
	select objectBranch
	
	);--if end
	
	)--with redraw end
	*****************************************/
	
	);

	