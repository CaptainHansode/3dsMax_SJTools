/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ArraySort.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "�I����e���\�[�g"
	(
		button sortByParentBt "�e�q���Ƀ\�[�g" width:160
		button sortByNameBt "���O���Ń\�[�g" width:160
	)


on sortByParentBt pressed do
(

if selection != 0 then
(
	
--�K�w�\����S�Ď擾
Local myObjAll = #(), delIndex = undefined;
Local selObj = for i in selection collect i;
--Local selObj = selection;
Local objLevel = 1;

--////////////////////////////////////////////////
--�z�������
--////////////////////////////////////////////////
for i = 1 to 256 do
(
	append myObjAll #();
);--for end

--�v���O���X�o�[
sj_functions.sj_progressBar_Fn()

--////////////////////////////////////////////////
--�e���Ȃ��I�u�W�F�N�g������
--////////////////////////////////////////////////
for i in selObj do
(
	myObj = #();
	if i.parent == undefined then
	(
		append myObjAll[1] i;
	);
);--for end

--�e�̖����I�u�W�F�N�g��z�񂩂�r��
for i in myObjAll do
(
	for k in i do
	(
		delIndex = findItem selObj k;
		deleteItem selObj delIndex;
	);--for end	
);--for end

--////////////////////////////////////////////////
--�K�w���x����]��
--////////////////////////////////////////////////

--�v���O���X����
Local progCountAll = selObj.count;
Local progCount = 1;

for i in selObj do
(
	sj_progressBar_rol.processInfo.caption =  "�\����]�����Ă��܂�   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;
	
	myObj = #();
	objLevel = 1;
	obj = i;

	while obj.parent != undefined do
	(
		obj = obj.parent
		objLevel += 1;
	)--while end

		append myObjAll[objLevel] i;
		
);--for end


--////////////////////////////////////////////////
--�I����������
--////////////////////////////////////////////////

clearSelection()

progCountAll = myObjAll.count;
progCount = 1;

for i in myObjAll do
(
	sj_progressBar_rol.processInfo.caption =  "�đI�����Ă��܂�   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;
	
	if i.count != 0 then selectMore i
);--for end

try(destroydialog sj_progressBar_rol)catch()
print "�I���I��";


);--if end

);--end


--////////////////////////////////////////////////
--���O�ŕ��ёւ�
--////////////////////////////////////////////////
on sortByNameBt pressed do
(

if selection != 0 then
(

--�K�w�\����S�Ď擾
Local myObj = #(), myObjAfter = #();
Local selObjName = for i in selection collect i.name;
Local selObjIh = for i in selection collect i.inode.handle;

Local progCountAll = selObjName.count;
Local progCount = 1;
sj_functions.sj_progressBar_Fn()

--�\�[�g
sort selObjName;

clearSelection()

--////////////////////////////////////////////////
--�I����������
--////////////////////////////////////////////////
for i in selObjName do
(
--�v���O���X�o�[
	sj_progressBar_rol.processInfo.caption =  "���O���Ƀ\�[�g���Ă��܂�   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;

	--���̖��O�̃I�u�W�F�N�g�����
	myObj = getNodeByName i all:true;

	--i�n���h���Ŗ��O�̏d�����m�F
	for k in myObj do
	(
		--�������
		if (findItem selObjIh k.inode.handle) != 0 then append myObjAfter k;
	);--for end

);--for end

--�đI��
select myObjAfter;

try(destroydialog sj_progressBar_rol)catch()
print "�I���I��";

);--if end

);--end
