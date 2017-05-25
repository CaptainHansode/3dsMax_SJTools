/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_AnimKeyDelete.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

	group "Delete All Keys"
	(
		button delOutRangeKeysBt "�͈͊O�L�[���폜" width:160
		label delAllKeysLdl1"Transform" width:160
		button delAllPosKeysBt "�S�Ă̈ʒu�L�[���폜" width:160
		button delAllRotKeysBt "�S�Ẳ�]�L�[���폜" width:160
		button delAllScanKeysBt "�S�ẴX�P�[���L�[���폜" width:160
	)

--////////////////////////////////////////////////
--del
--////////////////////////////////////////////////
	on delOutRangeKeysBt pressed do
	(
		for i in objects do
		(
			--�L�[�I��������	
			deselectKeys i;
			--�͈͊O�̃L�[��I��
			selectkeys i (interval -100000 (animationRange.start-1));			
			--�I�������L�[���폜
			deleteKeys i #selection;
			
			--�L�[�I��������	
			deselectKeys i;
			--�͈͊O�̃L�[��I��
			selectkeys i (interval (animationRange.end+1) 100000);
			--�I�������L�[���폜
			deleteKeys i #selection;
		);--for end
	);--end
	
--////////////////////////////////////////////////
--del
--////////////////////////////////////////////////
	on delAllPosKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.pos.controller.keys.count;
		--�L�[�J�E���g���Ȃ��Ȃ�܂�
		--�z��̂��K����폜
		while j > 0 do
		(
			deleteKey i.pos.controller.keys j;
			j -= 1;
		);--while end
		
		--transform��߂�
		i.transform = oldTransform;
		);--for end
		)catch()--try end
		/*
		--�܂���x�L�[��K���ȃR���g���[���[�ɕς��ׂ�
		$.pos.controller = Position_Expression ()
		--���ɖ߂�
		$.pos.controller = Position_XYZ ()
		*/
	);--end

	on delAllRotKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.rotation.controller.keys.count;
		--�L�[�J�E���g���Ȃ��Ȃ�܂�
		--�z��̂��K����폜
		while j > 0 do
		(
			deleteKey i.rotation.controller.keys j;
			j -= 1;
		);--while end
		i.transform = oldTransform;
		);--for end
		)catch()--try end
	);--end
	
	on delAllScanKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.scale.controller.keys.count;
		--�L�[�J�E���g���Ȃ��Ȃ�܂�
		--�z��̂��K����폜
		while j > 0 do
		(
			deleteKey i.scale.controller.keys j;
			j -= 1;
		);--while end
		i.transform = oldTransform;
		);--for end
		)catch()--try end
	);--end