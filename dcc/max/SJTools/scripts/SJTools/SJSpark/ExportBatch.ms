/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ExportBatch.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "ExportBatch"
	(
		button exportBatchBt "�����o���o�b�`" width:160
		editText exportBatchTxt "" width:160 height:16 align:#center;
		button getExportPathBt "�p�X���擾" width:160 align:#center;
	)

-----------------------------------------------------------------------------------------------------------
--�e�L�X�g�������o��
-----------------------------------------------------------------------------------------------------------
on getExportPathBt pressed do
(
	Local tempLoadFile = undefined;
	tempLoadFile = getOpenFileName types:"�t�@�C���͉��ł����܂��܂���|*.*";
	if (tempLoadFile != undefined) then exportBatchTxt.text = getFilenamePath tempLoadFile;
);--end

--�ЂƂ܂�FBX�̏����o���e�X�g
on exportBatchBt pressed do
(
	if (exportBatchTxt.text != undefined) then
	(
		--�I���Ԃ̂�
		exportFile (exportBatchTxt.text + "Test") selectedOnly:true using:fbx;
	)
	else
	(
		messageBox "�p�X����ł�" title:"�G���[";
	);--if end
);--end
