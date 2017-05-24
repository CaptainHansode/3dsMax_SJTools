/*******************************************************
System J Tools 
********************************************************
Name:SJTools
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

------------------------------------------------
--�S�c�[������
------------------------------------------------
(
	-------SJ_PBake
	macroScript SJ_PBake
	category:"SJTools"
	toolTip:"�ҁ[�ׂ���"
	buttonText:"�ҁ[�ׂ���"
	Icon:#("SJTools_Icon01",2)
	(
	include "$scripts/SJTools/SJ_PBake.ms"
	)

	-------SJ_Renamer
	macroScript SJ_Renamer
	category:"SJTools"
	toolTip:"��ˁ[�܁["
	buttonText:"��ˁ[�܁["
	Icon:#("SJTools_Icon01",3)
	(
	include "$scripts/SJTools/SJ_Renamer.ms"
	)

	-------SJ_Spark
	macroScript SJ_Spark
	category:"SJTools" 
	toolTip:"���ρ[����";
	buttonText:"���ρ[����";
	Icon:#("SJTools_Icon01",4)
	(
	include "$scripts/SJTools/SJ_Spark.ms"
	)
	
	-------SJ_BioSkinPlus
	macroScript SJ_Bio_Skin_Plus
	category:"SJTools" 
	toolTip:"�΂�����+";
	buttonText:"�΂�����+";
	Icon:#("SJTools_Icon01",5)
	(
	include "$scripts/SJTools/SJ_Bio_Skin_Plus.ms"
	)

	-------SJ_Time_Machine
	macroScript SJ_Time_Machine
	category:"SJTools"
	toolTip:"�����ނ܂���";
	buttonText:"�����ނ܂���";
	Icon:#("SJTools_Icon01",6)
	(
	include "$scripts/SJTools/SJ_Time_Machine.ms"
	)
	
	-------SJ_Selector
	macroScript SJ_Selector
	category:"SJTools"
	toolTip:"���ꂭ�ɂ�[";
	buttonText:"���ꂭ�ɂ�[";
	Icon:#("SJTools_Icon01",7)
	(
	include "$scripts/SJTools/SJ_Selector.ms"
	)
	
	-------SJ_RigSelector
	--hurricane,typhoon,cyclone
	macroScript SJ_Selector_Rig
	category:"SJTools"
	toolTip:"���ꂭ�ɂ�[�͂肯�[��";
	buttonText:"���ꂭ�ɂ�[�͂肯�[��";
	Icon:#("SJTools_Icon01",7)
	(
	include "$scripts/SJTools/SJ_Selector_Rig.ms"
	)
	
	-------SJ_Adjuster
	macroScript SJ_Adjuster
	category:"SJTools" 
	toolTip:"�����Ⴗ���[";
	buttonText:"�����Ⴗ���[";
	Icon:#("SJTools_Icon01",8)
	(
	include "$scripts/SJTools/SJ_Adjuster.ms"
	)

	-------SJ_Poser
	macroScript SJ_Poser
	category:"SJTools" 
	toolTip:"�ہ[�����";
	buttonText:"�ہ[�����";
	Icon:#("SJTools_Icon01",9)
	(
	include "$scripts/SJTools/SJ_Poser.ms"
	)

	-------SJ_Hider
	macroScript SJ_Hider
	category:"SJTools" 
	toolTip:"�͂����[";
	buttonText:"�͂����[";
	Icon:#("SJTools_Icon01",10)
	(
	include "$scripts/SJTools/SJ_Hider.ms"
	)
	
	-------SJ_Roller
	macroScript SJ_Roller
	category:"SJTools" 
	toolTip:"��[��[";
	buttonText:"��[��[";
	Icon:#("SJTools_Icon01",11)
	(
	include "$scripts/SJTools/SJ_Roller.ms"
	)
	
	-------SJ_Bip_Fitter
	macroScript SJ_Bip_Fitter
	category:"SJTools" 
	toolTip:"�т��Ղӂ������[";
	buttonText:"�т��Ղӂ������[";
	Icon:#("SJTools_Icon01",12)
	(
	include "$scripts/SJTools/SJ_Bip_Fitter.ms"
	)
	
	-------SJ_Scene_Slicer
	macroScript SJ_Scene_Slicer
	category:"SJTools" 
	toolTip:"���[�񂷂炢�����";
	buttonText:"���[�񂷂炢�����";
	Icon:#("SJTools_Icon01",13)
	(
	include "$scripts/SJTools/SJ_Scene_Slicer.ms"
	)
	
	-------SJ_LayerLayer
	macroScript SJ_LayerLayer
	category:"SJTools" 
	toolTip:"�ꂢ��[�ꂢ�₟�`";
	buttonText:"�ꂢ��[�ꂢ�₟�`";
	Icon:#("SJTools_Icon01",14)
	(
	include "$scripts/SJTools/SJ_LayerLayer.ms"
	)
	
	-------SJ_AnimKey_Preview
	macroScript SJ_AnimKey_Preview
	category:"SJTools" 
	toolTip:"���ɂ��[";
	buttonText:"���ɂ��[";
	Icon:#("SJTools_Icon02",1)
	(
	include "$scripts/SJTools/SJ_AnimKey_Preview.ms"
	)
	
	-------SJ_Time_Machine
	macroScript SJ_Key_Machine
	category:"SJTools"
	toolTip:"���[�܂���";
	buttonText:"���[�܂���";
	Icon:#("SJTools_Icon02",2)
	(
	include "$scripts/SJTools/SJ_Key_Machine.ms"
	)
	
/**********************************************
����ݒ�
**********************************************/
	-------SJ_Language_Setting
	macroScript SJ_Language_Setting
	category:"SJTools" 
	toolTip:"����ݒ� (Language Setting)"
	buttonText:"����ݒ� (Language Setting)"
	Icon:#("SJTools_Icon01",1)
	(
		sj_functions.sjtools_changeLanguage_Fn();
	)
	
	-------SJ_Icon
	macroScript SJ_Icon_Setting
	category:"SJTools" 
	toolTip:"�X�̒��Ԃ��� (Icon Setting)"
	buttonText:"�X�̒��Ԃ��� (Icon Setting)"
	Icon:#("SJTools_Icon01",1)
	(
		sj_functions.sjtools_changeIcon_Fn();
	)
	
)