/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_MeSkiner
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "�ȈՃX�L���Ǘ�"
	(
		button mrSkinerBt "�ȉ��̒l�̒��_��I��" width:160 hight:20
		spinner mrSkinerCheckWeight "" range:[0,1,1] type:#float scale:0.001 width:160 align:#center
	)
--////////////////////////////////////////////////
--�m��
--////////////////////////////////////////////////
	on mrSkinerBt pressed do
	(
	--�C���p�l���ɂ��Ȃ��ƃG���[���o��
	max modify mode	
	Local selectVertsArray = #{}, checkResult = false, myObj = selection[1], vertsCount = 0;
	Local weightArray = #();
	append weightArray mrSkinerCheckWeight.value;
	
	--�I�u�W�F�N�g�͑I�����Ă��邩�H
	if sj_functions.sj_SelectCheck_Fn() do
	(
	
	--�X�L�������t�@�C�A�͂��邩
	if (myObj.modifiers["Skin"] != undefined) then
	(
		vertsCount = selection[1].verts.count;
		if (skinOps.GetNumberBones myObj.skin) != 0 then
		(
			--1���_���Ƃɒ��ׂ�
			for i = 1 to vertsCount do
			(
				checkResult = false;
				--���_�̃E�F�C�g�̉e������
				for k = 1 to (skinops.GetVertexWeightCount myObj.skin i) do
				(
					--�w��̃E�F�C�g������Ό��ʂ�true��
					if (findItem weightArray (skinops.getVertexWeight myObj.skin i k) == 0) do checkResult = true;
				);--for end
				--�E�F�C�g����̒��_�����
				if not checkResult then append selectVertsArray i;
				--print selectVertsArray;
			);--for end
			
			--�I��
			skinOps.SelectVertices myObj.skin selectVertsArray;
			if (selectVertsArray.numberSet != 0) then messageBox("�ȉ��̐��������_��I�����܂���\n" + (selectVertsArray.numberSet as String) + "  ������܂���") title:"���b�Z�[�W";
			
		)else(
			messageBox("�{�[��������܂���")title:"���b�Z�[�W";
		);--if end
	)else(
		messageBox("�X�L�����a�t�@�C�A������܂���")title:"���b�Z�[�W";
	);--if end
	
	);--if end�I�u�W�F�N�g�I���`�F�b�N

	);--end