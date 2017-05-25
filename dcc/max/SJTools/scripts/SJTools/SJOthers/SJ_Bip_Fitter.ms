/*******************************************************
System J Tools 
********************************************************
Name:SJ_Bip_Fitter
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
	
-----------------------------------------------------------------------------------------------------------
-- �O���[�o������
-----------------------------------------------------------------------------------------------------------
--���[���A�E�g�p
global sj_bipfitter_rol
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
-----------------------------------------------------------------------------------------------------------
-- ���ꏉ����
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--Version etc ���O���̂�SJTools.ini����
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJBipFitterToolName");

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_bipfitter_rol)catch()
try(cui.unRegisterDialogBar sj_bipfitter_rol)catch()
try( CloseRolloutFloater sj_bipfitter_rol) catch()
try(destroydialog sj_bipfitter_rol)catch()

-----------------------------------------------------------------------------------------------------------
--���j���[
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--���j���[
--////////////////////////////////////////////////
rcMenu bipfitterMenuBar
(
subMenu "�w���v"
( 
menuItem helpMi "�w���v"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
);

--////////////////////////////////////////////////
--�A�N�V����
--////////////////////////////////////////////////
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=1031" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""

on bipfitterMenuBar update do
(
);

);--rcMenu end

rollout sj_bipfitter_rol nameAndVersion width:452 height:400
(
-----------------------------------------------------------------------------------------------------------
-- �t�@���N�V����
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Layout
-----------------------------------------------------------------------------------------------------------
--Bake�^�C�v�I��
/*
	GroupBox grp_bakeType "�^�C�v" pos:[8,4] width:64 height:84	
	radiobuttons pbTypeRb "" pos:[12,20] width:61 height:48 labels:#("PBake", "BBake", "Plot") default:1 columns:1
	
--Bake�I�v�V����
	GroupBox grp_bakeOptions "�I�v�V����" pos:[80,4] width:80 height:84
	--checkbox offsetChk "�I�t�Z�b�g" pos:[88,20] width:64 height:16 enabled:false
	checkbox mirrorChk "�~���[" pos:[88,20] width:56 height:16 enabled:false
	radiobuttons pbOpRb "" pos:[88,34] width:86 height:32 enabled:false labels:#("�|�C���g", "�I���W�i��") default:1 columns:1
	
--�t���[���ݒ�
	GroupBox grp_frame "�t���[��" pos:[168,4] width:200 height:84
	label startLbl "�X�^�[�g" pos:[176,20] width:48 height:16
	label endLbl "�G���h" pos:[176,40] width:48 height:16
	label stepLbl "�X�e�b�v" pos:[176,60] width:48 height:16
	spinner startFm "" pos:[220,20] width:80 height:16 range:[-1e+009,1e+009,animationRange.Start] type:#integer
	spinner endFm "" pos:[220,40] width:80 height:16 range:[-1e+009,1e+009,animationRange.End] type:#integer
	spinner stepFm "" pos:[220,60] width:80 height:16 range:[1,100,1] type:#integer
	button nowTimeSBt "Now" pos:[304,20] width:56 height:16
	button nowTimeEBt "Now" pos:[304,40] width:56 height:16
	checkbox sBySCb "byStep" pos:[304,60] width:57 height:15 checked:false --width:48 height:16
	
--�L�[�ݒ�
	GroupBox grp_key "�L�[" pos:[376,4] width:68 height:84
	checkbox posCb "�ʒu" pos:[384,20] width:56 height:16 checked:true
	checkbox rotCb "��]" pos:[384,36] width:56 height:16 checked:true
	checkbox scaleCb "�X�P�[��" pos:[384,52] width:56 height:16 checked:true

*/

--Bake�{�^��
/*
	button pBakeBt "P Bake !" pos:[8,364] width:436 height:32 toolTip:"�����ς��߂悤���b!"

	GroupBox grp_list "���X�g" pos:[8,92] width:436 height:268
	
	listbox pb_listL "" pos:[16,132] width:208 height:16;
	button addListBtL "" pos:[16,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.gif", "$Scripts/SJTools/Images//SJ_button_add_a.gif", 2, 1, 1, 2, 2) toolTip:"�I����ǉ�"
	button allSelListBtL "" pos:[40,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allsel.gif", "$Scripts/SJTools/Images//SJ_button_allsel_a.gif", 2, 1, 1, 2, 2) toolTip:"�S�I��"
	button upListBtL "" pos:[64,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.gif", "$Scripts/SJTools/Images//SJ_button_up_a.gif", 2, 1, 1, 2, 2) toolTip:"Up"
	button downListBtL "" pos:[88,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.gif", "$Scripts/SJTools/Images//SJ_button_down_a.gif", 2, 1, 1, 2, 2) toolTip:"Down"
	button sortBtL "�\�[�g" pos:[112,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_sort.gif", "$Scripts/SJTools/Images//SJ_button_sort_a.gif", 2, 1, 1, 2, 2) toolTip:"���X�g�𖼑O���Ń\�[�g����"
	button delBtL "" pos:[136,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.gif", "$Scripts/SJTools/Images//SJ_button_delete_a.gif", 2, 1, 1, 2, 2) toolTip:"�폜"
	button clearBtL "" pos:[160,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_clear.gif", "$Scripts/SJTools/Images//SJ_button_clear_a.gif", 2, 1, 1, 2, 2) toolTip:"�N���A"
	label listCntL "0" pos:[184,112] width:40 height:13;
--�E
	listbox pb_listR "" pos:[228,132] width:208 height:16;
	button addListBtR "" pos:[228,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_add.gif", "$Scripts/SJTools/Images//SJ_button_add_a.gif", 2, 1, 1, 2, 2) toolTip:"�I����ǉ�"
	button allSelListBtR "" pos:[252,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allsel.gif", "$Scripts/SJTools/Images//SJ_button_allsel_a.gif", 2, 1, 1, 2, 2) toolTip:"�S�I��"
	button upListBtR "" pos:[276,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.gif", "$Scripts/SJTools/Images//SJ_button_up_a.gif", 2, 1, 1, 2, 2) toolTip:"Up"
	button downListBtR "" pos:[300,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.gif", "$Scripts/SJTools/Images//SJ_button_down_a.gif", 2, 1, 1, 2, 2) toolTip:"Down"
	button sortBtR "�\�[�g" pos:[324,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_sort.gif", "$Scripts/SJTools/Images//SJ_button_sort_a.gif", 2, 1, 1, 2, 2) toolTip:"���X�g�𖼑O���Ń\�[�g����"
	button delBtR "" pos:[348,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_delete.gif", "$Scripts/SJTools/Images//SJ_button_delete_a.gif", 2, 1, 1, 2, 2) toolTip:"�폜"
	button clearBtR "" pos:[372,108] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_clear.gif", "$Scripts/SJTools/Images//SJ_button_clear_a.gif", 2, 1, 1, 2, 2) toolTip:"�N���A"
	label listCntR "0" pos:[396,112] width:40 height:13;
*/
);--end rollout
-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_bipfitter_rol menu:bipfitterMenuBar style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu;

);--end