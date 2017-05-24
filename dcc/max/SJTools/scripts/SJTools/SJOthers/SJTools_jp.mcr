/*******************************************************
System J Tools 
********************************************************
Name:SJTools
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

------------------------------------------------
--全ツール準備
------------------------------------------------
(
	-------SJ_PBake
	macroScript SJ_PBake
	category:"SJTools"
	toolTip:"ぴーべいく"
	buttonText:"ぴーべいく"
	Icon:#("SJTools_Icon01",2)
	(
	include "$scripts/SJTools/SJ_PBake.ms"
	)

	-------SJ_Renamer
	macroScript SJ_Renamer
	category:"SJTools"
	toolTip:"りねーまー"
	buttonText:"りねーまー"
	Icon:#("SJTools_Icon01",3)
	(
	include "$scripts/SJTools/SJ_Renamer.ms"
	)

	-------SJ_Spark
	macroScript SJ_Spark
	category:"SJTools" 
	toolTip:"すぱーくん";
	buttonText:"すぱーくん";
	Icon:#("SJTools_Icon01",4)
	(
	include "$scripts/SJTools/SJ_Spark.ms"
	)
	
	-------SJ_BioSkinPlus
	macroScript SJ_Bio_Skin_Plus
	category:"SJTools" 
	toolTip:"ばいきん+";
	buttonText:"ばいきん+";
	Icon:#("SJTools_Icon01",5)
	(
	include "$scripts/SJTools/SJ_Bio_Skin_Plus.ms"
	)

	-------SJ_Time_Machine
	macroScript SJ_Time_Machine
	category:"SJTools"
	toolTip:"たいむましん";
	buttonText:"たいむましん";
	Icon:#("SJTools_Icon01",6)
	(
	include "$scripts/SJTools/SJ_Time_Machine.ms"
	)
	
	-------SJ_Selector
	macroScript SJ_Selector
	category:"SJTools"
	toolTip:"せれくにゃー";
	buttonText:"せれくにゃー";
	Icon:#("SJTools_Icon01",7)
	(
	include "$scripts/SJTools/SJ_Selector.ms"
	)
	
	-------SJ_RigSelector
	--hurricane,typhoon,cyclone
	macroScript SJ_Selector_Rig
	category:"SJTools"
	toolTip:"せれくにゃーはりけーん";
	buttonText:"せれくにゃーはりけーん";
	Icon:#("SJTools_Icon01",7)
	(
	include "$scripts/SJTools/SJ_Selector_Rig.ms"
	)
	
	-------SJ_Adjuster
	macroScript SJ_Adjuster
	category:"SJTools" 
	toolTip:"あじゃすたー";
	buttonText:"あじゃすたー";
	Icon:#("SJTools_Icon01",8)
	(
	include "$scripts/SJTools/SJ_Adjuster.ms"
	)

	-------SJ_Poser
	macroScript SJ_Poser
	category:"SJTools" 
	toolTip:"ぽーちゃん";
	buttonText:"ぽーちゃん";
	Icon:#("SJTools_Icon01",9)
	(
	include "$scripts/SJTools/SJ_Poser.ms"
	)

	-------SJ_Hider
	macroScript SJ_Hider
	category:"SJTools" 
	toolTip:"はいだー";
	buttonText:"はいだー";
	Icon:#("SJTools_Icon01",10)
	(
	include "$scripts/SJTools/SJ_Hider.ms"
	)
	
	-------SJ_Roller
	macroScript SJ_Roller
	category:"SJTools" 
	toolTip:"ろーらー";
	buttonText:"ろーらー";
	Icon:#("SJTools_Icon01",11)
	(
	include "$scripts/SJTools/SJ_Roller.ms"
	)
	
	-------SJ_Bip_Fitter
	macroScript SJ_Bip_Fitter
	category:"SJTools" 
	toolTip:"びっぷふぃったー";
	buttonText:"びっぷふぃったー";
	Icon:#("SJTools_Icon01",12)
	(
	include "$scripts/SJTools/SJ_Bip_Fitter.ms"
	)
	
	-------SJ_Scene_Slicer
	macroScript SJ_Scene_Slicer
	category:"SJTools" 
	toolTip:"しーんすらいちゃん";
	buttonText:"しーんすらいちゃん";
	Icon:#("SJTools_Icon01",13)
	(
	include "$scripts/SJTools/SJ_Scene_Slicer.ms"
	)
	
	-------SJ_LayerLayer
	macroScript SJ_LayerLayer
	category:"SJTools" 
	toolTip:"れいやーれいやぁ～";
	buttonText:"れいやーれいやぁ～";
	Icon:#("SJTools_Icon01",14)
	(
	include "$scripts/SJTools/SJ_LayerLayer.ms"
	)
	
	-------SJ_AnimKey_Preview
	macroScript SJ_AnimKey_Preview
	category:"SJTools" 
	toolTip:"あにきー";
	buttonText:"あにきー";
	Icon:#("SJTools_Icon02",1)
	(
	include "$scripts/SJTools/SJ_AnimKey_Preview.ms"
	)
	
	-------SJ_Time_Machine
	macroScript SJ_Key_Machine
	category:"SJTools"
	toolTip:"きーましん";
	buttonText:"きーましん";
	Icon:#("SJTools_Icon02",2)
	(
	include "$scripts/SJTools/SJ_Key_Machine.ms"
	)
	
/**********************************************
言語設定
**********************************************/
	-------SJ_Language_Setting
	macroScript SJ_Language_Setting
	category:"SJTools" 
	toolTip:"言語設定 (Language Setting)"
	buttonText:"言語設定 (Language Setting)"
	Icon:#("SJTools_Icon01",1)
	(
		sj_functions.sjtools_changeLanguage_Fn();
	)
	
	-------SJ_Icon
	macroScript SJ_Icon_Setting
	category:"SJTools" 
	toolTip:"森の仲間たち (Icon Setting)"
	buttonText:"森の仲間たち (Icon Setting)"
	Icon:#("SJTools_Icon01",1)
	(
		sj_functions.sjtools_changeIcon_Fn();
	)
	
)