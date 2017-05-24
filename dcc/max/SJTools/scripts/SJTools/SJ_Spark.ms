r/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_spark_rol
global sj_sparksub_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJSparkToolName");
-----------------------------------------------------------------------------------------------------------
Local NearSearchTagObj;
-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_spark_rol)catch()
try(cui.unRegisterDialogBar sj_spark_rol)catch()
try( CloseRolloutFloater sj_spark_rol) catch()
try(destroydialog sj_spark_rol)catch()

-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu sparkMenuBar
(
subMenu "ヘルプ"
( 
menuItem helpMi "ヘルプ"
menuItem aboutMi "About"
menuItem emailMi "E-Mail"
)

--////////////////////////////////////////////////
--アクション
--////////////////////////////////////////////////
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5896" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
on poserMenuBar update do
(
)
)--rcMenu end

-----------------------------------------------------------------------------------------------------------
--切り替えタブ用
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_tabs_rol "タブ切り替えボタン"-- width:224 height:800
(

	
)--rol end


-----------------------------------------------------------------------------------------------------------
--オブジェクト関連、構造関連
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_objects_rol "Spark!! Objects"-- width:224 height:800
(
	include "$scripts/SJTools/SJScripts/SJ_Spark_ParentButton.ms"	
	include "$scripts/SJTools/SJScripts/SJ_Spark_HelperVisualChange.ms"	
	include "$scripts/SJTools/SJScripts/SJ_Spark_HelperGa.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_DummyBoxSizeChange.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_SnapShotMaster.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_Select.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_ArraySort.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_Text2EditableMesh.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_LayerLayer.ms"
	
)--rol end


-----------------------------------------------------------------------------------------------------------
--アニメーション関連
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_animations_rol "Spark!! Animtions"-- width:224 height:800
(
	include "$scripts/SJTools/SJScripts/SJ_Spark_CameraConverter.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_PickTheCopy.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_BipControll.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_AnimKeyDelete.ms"
		
)--rol end


-----------------------------------------------------------------------------------------------------------
--コントローラー関連
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_contorollers_rol "Spark!! Controllers"
(
	include "$scripts/SJTools/SJScripts/SJ_Spark_SetController.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_ObjectsDistance.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_ObjectsLinker.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_ParamerLinker.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_MakeLookatPoint.ms"
	--include "$scripts/SJTools/SJScripts/SJ_Spark_AllBeyondArrayCheck.ms"

)--end

-----------------------------------------------------------------------------------------------------------
--構造、ツール関連
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_tools_rol "Spark!! Tools"
(
	include "$scripts/SJTools/SJScripts/SJ_Spark_MrSkiner.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_PolyMan.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_Zweihander.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_SoundCnt.ms"	
	include "$scripts/SJTools/SJScripts/SJ_Spark_ExportBatch.ms"
	include "$scripts/SJTools/SJScripts/SJ_Spark_ScaleChecker.ms"
)--end

-----------------------------------------------------------------------------------------------------------
--その他、特殊
-----------------------------------------------------------------------------------------------------------
rollout sj_spark_other_rol "Spark!! Other"
(
	include "$scripts/SJTools/SJScripts/SJ_Spark_Others.ms"
	--include "$scripts/SJTools/SJScripts/SJ_Spark_AllBeyondArrayCheck.ms"

)--end

-----------------------------------------------------------------------------------------------------------
--その他
-----------------------------------------------------------------------------------------------------------



rollout sj_spark_rol nameAndVersion width:234 height:980
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--アクティブXの設定
--activeXcontrol menuTabs "MSComctlLib.TabStrip.2" height:20;

--ロールアウト設定
--サブロールアウトのエリアを2つ設定する

--タブ切り替えロールアウト
--subrollout sj_sparkTabs pos:[0,0] width:sj_spark_rol.width height:20;
--メインのロールアウト
subrollout sj_sparkarea pos:[0,60] width:sj_spark_rol.width height:920;
	button sparkTabsS "S" pos:[0,8] width:46 height:46;
	button sparkTabsP "P" pos:[47,8] width:46 height:46;
	button sparkTabsA "A" pos:[94,8] width:46 height:46;
	button sparkTabsR "R" pos:[141,8] width:46 height:46;
	button sparkTabsK "K" pos:[188,8] width:46 height:46;

	--タブ切り替えアクション
	on sparkTabsS pressed do
		(
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_objects_rol
		)--on end
	on sparkTabsP pressed do
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_animations_rol
		)--on end
	on sparkTabsA pressed do
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_contorollers_rol
		)--on end
	on sparkTabsR pressed do
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_tools_rol
		)--on end
	on sparkTabsK pressed do
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		addSubRollout sj_sparkarea sj_spark_other_rol
		)--on end


--アクティブXの切り替えアクション
/*
on menuTabs Click do
(
	case menuTabs.SelectedItem.index of
	(
		1:
		(
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_objects_rol
		)--case 1 end
		2:
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_animations_rol
		)--case 2 end
		3:
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_contorollers_rol
		)--case 2 end
		4:
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_other_rol
		addSubRollout sj_sparkarea sj_spark_tools_rol
		)--case 2 end
		5:
		(
		removeSubRollout sj_sparkarea sj_spark_objects_rol
		removeSubRollout sj_sparkarea sj_spark_animations_rol
		removeSubRollout sj_sparkarea sj_spark_contorollers_rol
		removeSubRollout sj_sparkarea sj_spark_tools_rol
		addSubRollout sj_sparkarea sj_spark_other_rol
		)--case 2 end
	)--case end
)
*/

on sj_spark_rol open do
(

--Local aaa = #("$Scripts/SJTools/Images//SJ_button_add.gif", "$Scripts/SJTools/Images//SJ_button_add_a.gif", 2, 1, 1, 2, 2);
--print aaa
--showProperties menuTabs.ImageList
--print menuTabs.ImageList.count
--menuTabs[1].Image = aaa
--menuTabs.Image = #("$Scripts/SJTools/Images//SJ_button_pose.gif", "$Scripts/SJTools/Images//SJ_button_pose_a.gif", 2, 1, 1, 2, 2);

	/*アクティブXの設定
	menuTabs.tabs[1].caption = "S"
	menuTabs.tabs.add pvCaption:"P"
	menuTabs.tabs.add pvCaption:"A"
	menuTabs.tabs.add pvCaption:"R"
	menuTabs.tabs.add pvCaption:"K"
	*/
);

on sj_spark_rol close do try(gc())catch();

);--endMainRollout



-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_spark_rol pos:[50,50] style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:sparkMenuBar;
--CreateDialog sj_spark_rol pos:[50,50] menu:sparkMenuBar style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox) menu:CanvasMenu


--サブロールアウトを追加
--タブ用
--addSubRollout sj_spark_rol.sj_sparkTabs sj_spark_tabs_rol;
--オブジェクト用
addSubRollout sj_spark_rol.sj_sparkarea sj_spark_objects_rol;
--こんな風にも追加可能
--addSubRollout sj_spark_rol.sj_sparkarea sj_spark_tools_rol



--addSubRollout sj_spark_rol.sj_sparkarea sj_spark_animations_rol
--addSubRollout sj_spark_rol.sj_sparkarea sj_spark_contorollers_rol

)--end macroscript