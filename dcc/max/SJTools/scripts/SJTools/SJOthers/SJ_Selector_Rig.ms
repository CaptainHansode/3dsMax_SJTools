/*******************************************************
System J Tools 
********************************************************
Name:SJ_Selector_Rig
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
global sj_selectorRig_rol, sj_srFinger_rol, sj_srFfaceRigSel_rol, sj_srOthers_rol, sj_srKeying_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"
	
--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini")  "SJToolsToolName" "SJSelectorRigToolName");
-----------------------------------------------------------------------------------------------------------
--アクタータイプ  1>>>Beyond 2>>>Bip
Local actorType = 0;
Local windowDock = false;
Local oldSelectorRigPos = [0,0];
	
--自動アップデート時のアクター名
Local sj_selector_nodeName = undefined;
	
--INI用 先に取得しておく
Local filterLastKeyWords = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FilterLastKeyWords");
Local bodyRol = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "BodyRol");
Local fingerRol = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FingerRol");
Local otherRol = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "OtherRol");
Local serectorRigZoom = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "SerectorRigZoom");

--UI用
Local uiBtFlip =  execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "UIButtonFlip");

--左肩腕上腕、左手、右肩腕上腕、右手、
--設定値より位置反転はココで決定
Local uiBtFlipPos = if uiBtFlip then (#(36,24,116,124,44,36,24,-100,8,116,124,128,-100,164))else(#(116,124,36,24,116,124,128,-100,164,44,36,24,-100,8));
--print uiBtFlipPos;
	
	
--bip用
--bipNode = undefined;
--Local bipNode = sj_selector_node.controller;
Local selFocus = execute(getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "SerectorRigZoom");
Local bipNode = undefined;
--全てのコントローラー
Local allController = #();
	
Local fileLockID = 889165216557487;

--指用配列
local L0fingerNodes = #(), L1fingerNodes = #(),L2fingerNodes = #(),L3fingerNodes = #(),L4fingerNodes = #();
local R0fingerNodes = #(), R1fingerNodes = #(),R2fingerNodes = #(),R3fingerNodes = #(),R4fingerNodes = #();
local L0toeNodes = #(), L1toeNodes = #(),L2toeNodes = #(),L3toeNodes = #(),L4toeNodes = #();
local R0toeNodes = #(), R1toeNodes = #(),R2toeNodes = #(),R3toeNodes = #(),R4toeNodes = #();

--Others用配列
local allOthers = #(), filterOthers = #(); otherName = #()--フィルターを使った際の結果を納入する配列

/*
Local bodyRig = #()
Local armRig = #()
Local legRig = #()
*/

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_selectorRig_rol)catch();
try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
try(closeRolloutFloater sj_selectorRig_rol) catch();
try(destroydialog sj_selectorRig_rol)catch();
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu selectorRigMenuBar
(

	subMenu "設定"
	(
	menuItem uiBtFlipMi "ボタン配置を左右反転" enabled:true  checked:uiBtFlip;
	menuItem focusMi "ズーム" enabled:true  checked:serectorRigZoom;
	--menuItem keyFilterMi "キーフィルタ" enabled:true
	--menuItem settingMi "Selectorにドッキング" enabled:true  checked:false
	--menuItem loadPoseFileMi "開く" enabled:true
	--menuItem mergePoseFileMi "合成" enabled:true
	--seperator sep01
	--menuItem closeMi "終了" enabled:true
	)
	subMenu "ヘルプ"
	( 
	menuItem helpMi "ヘルプ"
	menuItem aboutMi "About"
	menuItem emailMi "E-Mail"
	)
	--////////////////////////////////////////////////
	--アクション
	--////////////////////////////////////////////////
	--on keyFilterMi picked do 
	on focusMi picked do if (selFocus) then
	(
		selFocus = false;
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selFocusChk.checked = false;
		setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "SerectorRigZoom" "false";
	)else(
		selFocus = true;
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selFocusChk.checked = true;
		setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "SerectorRigZoom" "true";
	);
	
	--on keyFilterMi picked do 
	on uiBtFlipMi picked do if (uiBtFlip) then
	(
		uiBtFlip = false
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.uiBtFlipChk.checked = false;
		setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "UIButtonFlip" "false";
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.uiBodySet_Fn();
	)else(
		uiBtFlip = true;
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.uiBtFlipChk.checked = true;
		setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "UIButtonFlip" "true";
		sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.uiBodySet_Fn();
	);
	
	on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5979" "";
	on aboutMi picked do sj_functions.sjtools_about_Fn();
	on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
		
	on selectorRigMenuBar update do
	(
		focusMi.checked = selFocus;
		uiBtFlipMi.checked = uiBtFlip;
	);--end

);--menu end
	
	rollout sj_srFinger_rol "Fingers"
	(
-----------------------------------------------------------------------------------------------------------
-- ファンクションここまで
-----------------------------------------------------------------------------------------------------------
		--////////////////////////////////////////////////
		--UI設定
		--////////////////////////////////////////////////
		fn uiFingerSet_Fn = (
		--プログレスバー
		--sj_functions.sj_progressBar_Fn()
		--suspendEditing();--サスペンドモード
		with redraw off
		(--再描画禁止
			
			--local tempBipObj = undefined;
			local tempBmB = (bitmap 1 1 color:(color 1 2 3));
			local tempBmA =undefined;
			local tempBipCnt = undefined;
			local tempNum = 0;
			local rol = sj_srFinger_rol;--ロールアウトを格納
			
			case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
					--コントローラーを代入
					
					tempBipCnt = sj_selector_node.controller;
				
					--手のコントローラー
					tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 1 link:4).wirecolor);
					rol.fLHandBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
					tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 2 link:4).wirecolor);
					rol.fRHandBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
				
					--数を調べる	--脚は3関節の場合がある
					if (tempBipCnt.legLinks > 3) then
					(
						--4本以上だったら
						tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 5 link:4).wirecolor);
						rol.fLFootBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
						tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 6 link:4).wirecolor);
						rol.fRFootBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
						)else(
						--3本だったら
						tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 5 link:3).wirecolor);
						rol.fLFootBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
						tempBmA = (bitmap 100 100 color:(biped.getNode tempBipCnt 6 link:3).wirecolor);
						rol.fRFootBt.images = #( tempBmA,tempBmB, 1, 1, 2, 2, 2);
					);--if end
					
					------------------------------------------------------------------
					--指関節を配列に代入する
					------------------------------------------------------------------
					--一端初期化
					L0fingerNodes = #();L1fingerNodes = #();L2fingerNodes = #();L3fingerNodes = #();L4fingerNodes = #();
					R0fingerNodes = #();R1fingerNodes = #();R2fingerNodes = #();R3fingerNodes = #();R4fingerNodes = #();
					L0toeNodes = #();L1toeNodes = #();L2toeNodes = #();L3toeNodes = #();L4toeNodes = #();
					R0toeNodes = #();R1toeNodes = #();R2toeNodes = #();R3toeNodes = #();R4toeNodes = #();
					
					--間接数を回収
					linkNum = tempBipCnt.fingerLinks;
					
					--指の数が5本なら
					case tempBipCnt.fingers of (
						--指の数が1本なら
						1:(
						for i=1 to linkNum do
						(
							append L0fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R0fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						);
						--指の数が2本なら
						2:(
						for i=1 to linkNum do
						(
							append L0fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R0fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L1fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R1fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						);
						
						--指の数が3本なら
						3:(
						for i=1 to linkNum do
						(
							append L0fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R0fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L1fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R1fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L2fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R2fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						);
						
						--指の数が4本なら
						4:(						
						for i=1 to linkNum do
						(
							append L0fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R0fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L1fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R1fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L2fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R2fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*3)+1 to linkNum*4 do
						(
							append L3fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R3fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						);
						
						--指の数が5本なら
						5:(
						for i=1 to linkNum do
						(
							append L0fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R0fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L1fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R1fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L2fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R2fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*3)+1 to linkNum*4 do
						(
							append L3fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R3fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						for i=(linkNum*4)+1 to linkNum*5 do
						(
							append L4fingerNodes (biped.getNode tempBipCnt 3 link:i);
							append R4fingerNodes (biped.getNode tempBipCnt 4 link:i);
						);--for end
						);
					);--calseend
					
					--間接数を回収
					linkNum = tempBipCnt.toeLinks;
					
					case tempBipCnt.toes of (
						--つま先の数が1本なら
						1:(
						for i=1 to linkNum do
						(
							append L0toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R0toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						);
						2:(
						for i=1 to linkNum do
						(
							append L1toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R1toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L0toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R0toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						);
						3:(
						for i=1 to linkNum do
						(
							append L2toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R2toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L1toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R1toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L0toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R0toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						);
						4:(
						for i=1 to linkNum do
						(
							append L3toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R3toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L2toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R2toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L1toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R1toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*3)+1 to linkNum*4 do
						(
							append L0toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R0toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						);
						5:(
						for i=1 to linkNum do
						(
							append L4toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R4toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=linkNum+1 to linkNum*2 do
						(
							append L3toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R3toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*2)+1 to linkNum*3 do
						(
							append L2toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R2toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*3)+1 to linkNum*4 do
						(
							append L1toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R1toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						for i=(linkNum*4)+1 to linkNum*5 do
						(
							append L0toeNodes (biped.getNode tempBipCnt 7 link:i);
							append R0toeNodes (biped.getNode tempBipCnt 8 link:i);
						);--for end
						);
					);--case end
					
					------------------------------------------------------------------
					--ボタンを設定する
					------------------------------------------------------------------
					------------------------------------------------------------------
					--指
					------------------------------------------------------------------
					case tempBipCnt.fingers of (
						1:(
								case tempBipCnt.fingerLinks of (
									1:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.enabled = false; rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.R02Bt.enabled = false; rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
									);
									2:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
									);
									3:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.enabled = false
										rol.R04Bt.enabled = false
									);
									4:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.images = #((bitmap 12 20 color:(L0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R04Bt.images = #((bitmap 12 20 color:(R0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
								);--case end
						rol.L10Bt.enabled = false; rol.L11Bt.enabled = false; rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
						rol.L20Bt.enabled = false; rol.L21Bt.enabled = false; rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
						rol.L30Bt.enabled = false; rol.L31Bt.enabled = false; rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
						rol.L40Bt.enabled = false; rol.L41Bt.enabled = false; rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
						rol.R10Bt.enabled = false; rol.R11Bt.enabled = false; rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
						rol.R20Bt.enabled = false; rol.R21Bt.enabled = false; rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
						rol.R30Bt.enabled = false; rol.R31Bt.enabled = false; rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
						rol.R40Bt.enabled = false; rol.R41Bt.enabled = false; rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
						);
						2:(
								case tempBipCnt.fingerLinks of (
									1:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.enabled = false; rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L11Bt.enabled = false; rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.R02Bt.enabled = false; rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R11Bt.enabled = false; rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
									);
									2:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
									);
									3:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.enabled = false
										rol.L13Bt.enabled = false;
										rol.R04Bt.enabled = false
										rol.R13Bt.enabled = false;
									);
									4:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.images = #((bitmap 12 20 color:(L0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L13Bt.images = #((bitmap 12 20 color:(L1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R04Bt.images = #((bitmap 12 20 color:(R0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R13Bt.images = #((bitmap 12 20 color:(R1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
								);--case end
						rol.L20Bt.enabled = false;rol.L21Bt.enabled = false; rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
						rol.L30Bt.enabled = false; rol.L31Bt.enabled = false; rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
						rol.L40Bt.enabled = false; rol.L41Bt.enabled = false; rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
						rol.R20Bt.enabled = false; rol.R21Bt.enabled = false; rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
						rol.R30Bt.enabled = false; rol.R31Bt.enabled = false; rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
						rol.R40Bt.enabled = false; rol.R41Bt.enabled = false; rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
						);
						3:(
								case tempBipCnt.fingerLinks of (
									1:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.enabled = false; rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L11Bt.enabled = false; rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L21Bt.enabled = false; rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.R02Bt.enabled = false; rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R11Bt.enabled = false; rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R21Bt.enabled = false; rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
									);
									2:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
									);
									3:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.enabled = false
										rol.L13Bt.enabled = false;
										rol.L23Bt.enabled = false;
										rol.R04Bt.enabled = false
										rol.R13Bt.enabled = false;
										rol.R23Bt.enabled = false;
									);
									4:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.images = #((bitmap 12 20 color:(L0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L13Bt.images = #((bitmap 12 20 color:(L1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L23Bt.images = #((bitmap 12 20 color:(L2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R04Bt.images = #((bitmap 12 20 color:(R0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R13Bt.images = #((bitmap 12 20 color:(R1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R23Bt.images = #((bitmap 12 20 color:(R2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
							);--case end
						rol.L30Bt.enabled = false; rol.L31Bt.enabled = false; rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
						rol.L40Bt.enabled = false; rol.L41Bt.enabled = false; rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
						rol.R30Bt.enabled = false; rol.R31Bt.enabled = false; rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
						rol.R40Bt.enabled = false; rol.R41Bt.enabled = false; rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
						);
						4:(
								case tempBipCnt.fingerLinks of (
									1:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.enabled = false; rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L11Bt.enabled = false; rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L21Bt.enabled = false; rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.L31Bt.enabled = false; rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
										rol.R02Bt.enabled = false; rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R11Bt.enabled = false; rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R21Bt.enabled = false; rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
										rol.R31Bt.enabled = false; rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
									);
									2:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
										rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
										rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
									);
									3:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L32Bt.images = #((bitmap 12 24 color:(L3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R32Bt.images = #((bitmap 12 24 color:(R3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.enabled = false
										rol.L13Bt.enabled = false;
										rol.L23Bt.enabled = false;
										rol.L33Bt.enabled = false;
										rol.R04Bt.enabled = false
										rol.R13Bt.enabled = false;
										rol.R23Bt.enabled = false;
										rol.R33Bt.enabled = false;
									);
									4:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.images = #((bitmap 12 20 color:(L0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L13Bt.images = #((bitmap 12 20 color:(L1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L23Bt.images = #((bitmap 12 20 color:(L2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L32Bt.images = #((bitmap 12 24 color:(L3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L33Bt.images = #((bitmap 12 20 color:(L3fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R04Bt.images = #((bitmap 12 20 color:(R0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R13Bt.images = #((bitmap 12 20 color:(R1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R23Bt.images = #((bitmap 12 20 color:(R2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R32Bt.images = #((bitmap 12 24 color:(R3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R33Bt.images = #((bitmap 12 20 color:(R3fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
							);--case end
						rol.L40Bt.enabled = false; rol.L41Bt.enabled = false; rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
						rol.R40Bt.enabled = false; rol.R41Bt.enabled = false; rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
						);
						5:(
								case tempBipCnt.fingerLinks of (
									1:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L40Bt.images = #((bitmap 12 28 color:(L4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R40Bt.images = #((bitmap 12 28 color:(R4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.enabled = false; rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L11Bt.enabled = false; rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L21Bt.enabled = false; rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.L31Bt.enabled = false; rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
										rol.L41Bt.enabled = false; rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
										rol.R02Bt.enabled = false; rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R11Bt.enabled = false; rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R21Bt.enabled = false; rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
										rol.R31Bt.enabled = false; rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
										rol.R41Bt.enabled = false; rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
									);
									2:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L40Bt.images = #((bitmap 12 28 color:(L4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L41Bt.images = #((bitmap 12 20 color:(L4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R40Bt.images = #((bitmap 12 28 color:(R4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R41Bt.images = #((bitmap 12 20 color:(R4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.enabled = false; rol.L04Bt.enabled = false
										rol.L12Bt.enabled = false; rol.L13Bt.enabled = false;
										rol.L22Bt.enabled = false; rol.L23Bt.enabled = false;
										rol.L32Bt.enabled = false; rol.L33Bt.enabled = false;
										rol.L42Bt.enabled = false; rol.L43Bt.enabled = false;
										rol.R03Bt.enabled = false; rol.R04Bt.enabled = false
										rol.R12Bt.enabled = false; rol.R13Bt.enabled = false;
										rol.R22Bt.enabled = false; rol.R23Bt.enabled = false;
										rol.R32Bt.enabled = false; rol.R33Bt.enabled = false;
										rol.R42Bt.enabled = false; rol.R43Bt.enabled = false;
									);
									3:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L32Bt.images = #((bitmap 12 24 color:(L3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L40Bt.images = #((bitmap 12 28 color:(L4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L41Bt.images = #((bitmap 12 20 color:(L4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L42Bt.images = #((bitmap 12 20 color:(L4fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R32Bt.images = #((bitmap 12 24 color:(R3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R40Bt.images = #((bitmap 12 28 color:(R4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R41Bt.images = #((bitmap 12 20 color:(R4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R42Bt.images = #((bitmap 12 20 color:(R4fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.enabled = false
										rol.L13Bt.enabled = false;
										rol.L23Bt.enabled = false;
										rol.L33Bt.enabled = false;
										rol.L43Bt.enabled = false;
										rol.R04Bt.enabled = false
										rol.R13Bt.enabled = false;
										rol.R23Bt.enabled = false;
										rol.R33Bt.enabled = false;
										rol.R43Bt.enabled = false;
									);
									4:(
										rol.L01Bt.images = #((bitmap 12 28 color:(L0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L02Bt.images = #((bitmap 12 20 color:(L0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L03Bt.images = #((bitmap 12 20 color:(L0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L04Bt.images = #((bitmap 12 20 color:(L0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L10Bt.images = #((bitmap 12 28 color:(L1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L11Bt.images = #((bitmap 12 20 color:(L1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L12Bt.images = #((bitmap 12 20 color:(L1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L13Bt.images = #((bitmap 12 20 color:(L1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L20Bt.images = #((bitmap 12 28 color:(L2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L21Bt.images = #((bitmap 12 26 color:(L2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L22Bt.images = #((bitmap 12 24 color:(L2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L23Bt.images = #((bitmap 12 20 color:(L2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L30Bt.images = #((bitmap 12 28 color:(L3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L31Bt.images = #((bitmap 12 26 color:(L3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L32Bt.images = #((bitmap 12 24 color:(L3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L33Bt.images = #((bitmap 12 20 color:(L3fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L40Bt.images = #((bitmap 12 28 color:(L4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L41Bt.images = #((bitmap 12 20 color:(L4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L42Bt.images = #((bitmap 12 20 color:(L4fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.L43Bt.images = #((bitmap 12 20 color:(L4fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R01Bt.images = #((bitmap 12 28 color:(R0fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R02Bt.images = #((bitmap 12 20 color:(R0fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R03Bt.images = #((bitmap 12 20 color:(R0fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R04Bt.images = #((bitmap 12 20 color:(R0fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R10Bt.images = #((bitmap 12 28 color:(R1fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R11Bt.images = #((bitmap 12 20 color:(R1fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R12Bt.images = #((bitmap 12 20 color:(R1fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R13Bt.images = #((bitmap 12 20 color:(R1fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R20Bt.images = #((bitmap 12 28 color:(R2fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R21Bt.images = #((bitmap 12 26 color:(R2fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R22Bt.images = #((bitmap 12 24 color:(R2fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R23Bt.images = #((bitmap 12 20 color:(R2fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R30Bt.images = #((bitmap 12 28 color:(R3fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R31Bt.images = #((bitmap 12 26 color:(R3fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R32Bt.images = #((bitmap 12 24 color:(R3fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R33Bt.images = #((bitmap 12 20 color:(R3fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R40Bt.images = #((bitmap 12 28 color:(R4fingerNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R41Bt.images = #((bitmap 12 20 color:(R4fingerNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R42Bt.images = #((bitmap 12 20 color:(R4fingerNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.R43Bt.images = #((bitmap 12 20 color:(R4fingerNodes[4].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
							);--case end
						);
					);--case end
					
					------------------------------------------------------------------
					--脚
					------------------------------------------------------------------					
					case tempBipCnt.toes of (
						1:(
								case tempBipCnt.toeLinks of (
									1:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.enabled = false; rol.fL03Bt.enabled = false;
										rol.fR02Bt.enabled = false; rol.fR03Bt.enabled = false;
									);
									2:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.enabled = false;
										rol.fR03Bt.enabled = false;
									);
									3:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.images = #((bitmap 12 20 color:(L0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR03Bt.images = #((bitmap 12 20 color:(R0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
								);--case end
							rol.fL11Bt.enabled = false; rol.fL12Bt.enabled = false; rol.fL13Bt.enabled = false;
							rol.fL21Bt.enabled = false; rol.fL22Bt.enabled = false; rol.fL23Bt.enabled = false;
							rol.fL31Bt.enabled = false; rol.fL32Bt.enabled = false; rol.fL33Bt.enabled = false;
							rol.fL41Bt.enabled = false; rol.fL42Bt.enabled = false; rol.fL43Bt.enabled = false;
							rol.fR11Bt.enabled = false; rol.fR12Bt.enabled = false; rol.fR13Bt.enabled = false;
							rol.fR21Bt.enabled = false; rol.fR22Bt.enabled = false; rol.fR23Bt.enabled = false;
							rol.fR31Bt.enabled = false; rol.fR32Bt.enabled = false; rol.fR33Bt.enabled = false;
							rol.fR41Bt.enabled = false; rol.fR42Bt.enabled = false; rol.fR43Bt.enabled = false;
						);
						2:(
								case tempBipCnt.toeLinks of (
									1:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.enabled = false; rol.fL03Bt.enabled = false
										rol.fL12Bt.enabled = false; rol.fL13Bt.enabled = false;
										rol.fR02Bt.enabled = false; rol.fR03Bt.enabled = false
										rol.fR12Bt.enabled = false; rol.fR13Bt.enabled = false;
									);
									2:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.enabled = false;
										rol.fL13Bt.enabled = false;
										rol.fR03Bt.enabled = false;
										rol.fR13Bt.enabled = false;
									);
									3:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.images = #((bitmap 12 20 color:(L0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL13Bt.images = #((bitmap 12 20 color:(L1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR03Bt.images = #((bitmap 12 20 color:(R0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR13Bt.images = #((bitmap 12 20 color:(R1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
								);--case end
						rol.fL21Bt.enabled = false; rol.fL22Bt.enabled = false; rol.fL23Bt.enabled = false;
						rol.fL31Bt.enabled = false; rol.fL32Bt.enabled = false; rol.fL33Bt.enabled = false;
						rol.fL41Bt.enabled = false; rol.fL42Bt.enabled = false; rol.fL43Bt.enabled = false;
						rol.fR21Bt.enabled = false; rol.fR22Bt.enabled = false; rol.fR23Bt.enabled = false;
						rol.fR31Bt.enabled = false; rol.fR32Bt.enabled = false; rol.fR33Bt.enabled = false;
						rol.fR41Bt.enabled = false; rol.fR42Bt.enabled = false; rol.fR43Bt.enabled = false;
						);
						3:(
								case tempBipCnt.toeLinks of (
									1:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.enabled = false; rol.fL03Bt.enabled = false;
										rol.fL12Bt.enabled = false; rol.fL13Bt.enabled = false;
										rol.fL22Bt.enabled = false; rol.fL23Bt.enabled = false;
										rol.fR02Bt.enabled = false; rol.fR03Bt.enabled = false;
										rol.fR12Bt.enabled = false; rol.fR13Bt.enabled = false;
										rol.fR22Bt.enabled = false; rol.fR23Bt.enabled = false;
									);
									2:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.enabled = false;
										rol.fL13Bt.enabled = false;
										rol.fL23Bt.enabled = false;
										rol.fR03Bt.enabled = false;
										rol.fR13Bt.enabled = false;
										rol.fR23Bt.enabled = false;
									);
									3:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.images = #((bitmap 12 20 color:(L0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL13Bt.images = #((bitmap 12 20 color:(L1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL23Bt.images = #((bitmap 12 24 color:(L2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR03Bt.images = #((bitmap 12 20 color:(R0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR13Bt.images = #((bitmap 12 20 color:(R1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR23Bt.images = #((bitmap 12 24 color:(R2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);

							);--case end
						rol.fL31Bt.enabled = false; rol.fL32Bt.enabled = false; rol.fL33Bt.enabled = false;
						rol.fL41Bt.enabled = false; rol.fL42Bt.enabled = false; rol.fL43Bt.enabled = false;
						rol.fR31Bt.enabled = false; rol.fR32Bt.enabled = false; rol.fR33Bt.enabled = false;
						rol.fR41Bt.enabled = false; rol.fR42Bt.enabled = false; rol.fR43Bt.enabled = false;
						);
						4:(
								case tempBipCnt.toeLinks of (
									1:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.enabled = false; rol.fL03Bt.enabled = false;
										rol.fL12Bt.enabled = false; rol.fL13Bt.enabled = false;
										rol.fL22Bt.enabled = false; rol.fL23Bt.enabled = false;
										rol.fL32Bt.enabled = false; rol.fL33Bt.enabled = false;
										rol.fR02Bt.enabled = false; rol.fR03Bt.enabled = false;
										rol.fR12Bt.enabled = false; rol.fR13Bt.enabled = false;
										rol.fR22Bt.enabled = false; rol.fR23Bt.enabled = false;
										rol.fR32Bt.enabled = false; rol.fR33Bt.enabled = false;
									);
									2:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL32Bt.images = #((bitmap 12 26 color:(L3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR32Bt.images = #((bitmap 12 26 color:(R3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.enabled = false;
										rol.fL13Bt.enabled = false;
										rol.fL23Bt.enabled = false;
										rol.fL33Bt.enabled = false;
										rol.fR03Bt.enabled = false;
										rol.fR13Bt.enabled = false;
										rol.fR23Bt.enabled = false;
										rol.fR33Bt.enabled = false;
									);
									3:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.images = #((bitmap 12 20 color:(L0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL13Bt.images = #((bitmap 12 20 color:(L1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL23Bt.images = #((bitmap 12 24 color:(L2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL32Bt.images = #((bitmap 12 26 color:(L3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL33Bt.images = #((bitmap 12 24 color:(L3toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR03Bt.images = #((bitmap 12 20 color:(R0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR13Bt.images = #((bitmap 12 20 color:(R1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR23Bt.images = #((bitmap 12 24 color:(R2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR32Bt.images = #((bitmap 12 26 color:(R3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR33Bt.images = #((bitmap 12 24 color:(R3toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
							);--case end
						rol.fL41Bt.enabled = false; rol.fL42Bt.enabled = false; rol.fL43Bt.enabled = false;
						rol.fR41Bt.enabled = false; rol.fR42Bt.enabled = false; rol.fR43Bt.enabled = false;
						);
						5:(
								case tempBipCnt.toeLinks of (
									1:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL41Bt.images = #((bitmap 12 28 color:(L4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR41Bt.images = #((bitmap 12 28 color:(R4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.enabled = false; rol.fL03Bt.enabled = false;
										rol.fL12Bt.enabled = false; rol.fL13Bt.enabled = false;
										rol.fL22Bt.enabled = false; rol.fL23Bt.enabled = false;
										rol.fL32Bt.enabled = false; rol.fL33Bt.enabled = false;
										rol.fL42Bt.enabled = false; rol.fL43Bt.enabled = false;
										rol.fR02Bt.enabled = false; rol.fR03Bt.enabled = false;
										rol.fR12Bt.enabled = false; rol.fR13Bt.enabled = false;
										rol.fR22Bt.enabled = false; rol.fR23Bt.enabled = false;
										rol.fR32Bt.enabled = false; rol.fR33Bt.enabled = false;
										rol.fR42Bt.enabled = false; rol.fR43Bt.enabled = false;
									);
									2:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL32Bt.images = #((bitmap 12 26 color:(L3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL41Bt.images = #((bitmap 12 28 color:(L4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL42Bt.images = #((bitmap 12 20 color:(L4toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR32Bt.images = #((bitmap 12 26 color:(R3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR41Bt.images = #((bitmap 12 28 color:(R4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR42Bt.images = #((bitmap 12 20 color:(R4toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.enabled = false;
										rol.fL13Bt.enabled = false;
										rol.fL23Bt.enabled = false;
										rol.fL33Bt.enabled = false;
										rol.fL43Bt.enabled = false;
										rol.fR03Bt.enabled = false;
										rol.fR13Bt.enabled = false;
										rol.fR23Bt.enabled = false;
										rol.fR33Bt.enabled = false;
										rol.fR43Bt.enabled = false;
									);
									3:(
										rol.fL01Bt.images = #((bitmap 12 28 color:(L0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL02Bt.images = #((bitmap 12 20 color:(L0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL03Bt.images = #((bitmap 12 20 color:(L0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL11Bt.images = #((bitmap 12 28 color:(L1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL12Bt.images = #((bitmap 12 20 color:(L1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL13Bt.images = #((bitmap 12 20 color:(L1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL21Bt.images = #((bitmap 12 28 color:(L2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL22Bt.images = #((bitmap 12 26 color:(L2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL23Bt.images = #((bitmap 12 24 color:(L2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL31Bt.images = #((bitmap 12 28 color:(L3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL32Bt.images = #((bitmap 12 26 color:(L3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL33Bt.images = #((bitmap 12 24 color:(L3toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL41Bt.images = #((bitmap 12 28 color:(L4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL42Bt.images = #((bitmap 12 20 color:(L4toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fL43Bt.images = #((bitmap 12 20 color:(L4toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR01Bt.images = #((bitmap 12 28 color:(R0toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR02Bt.images = #((bitmap 12 20 color:(R0toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR03Bt.images = #((bitmap 12 20 color:(R0toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR11Bt.images = #((bitmap 12 28 color:(R1toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR12Bt.images = #((bitmap 12 20 color:(R1toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR13Bt.images = #((bitmap 12 20 color:(R1toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR21Bt.images = #((bitmap 12 28 color:(R2toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR22Bt.images = #((bitmap 12 26 color:(R2toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR23Bt.images = #((bitmap 12 24 color:(R2toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR31Bt.images = #((bitmap 12 28 color:(R3toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR32Bt.images = #((bitmap 12 26 color:(R3toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR33Bt.images = #((bitmap 12 24 color:(R3toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR41Bt.images = #((bitmap 12 28 color:(R4toeNodes[1].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR42Bt.images = #((bitmap 12 20 color:(R4toeNodes[2].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
										rol.fR43Bt.images = #((bitmap 12 20 color:(R4toeNodes[3].wirecolor)),tempBmB, 1, 1, 2, 2, 2);
									);
							);--case end
						);
					);--case end
					
					
				);
			);--case end
			
		);--with redraw end
		--try(destroydialog sj_progressBar_rol)catch();
		--resumeEditing();--再びアクティブに	
		
		);--fn end
		
		--////////////////////////////////////////////////
		--各部選択　引数は 手1か足2 左1か右2か　指の番号　関節番号
		--SJの場合は0を指定、リンクが無い場合も0を指定
		--////////////////////////////////////////////////		
		fn selFingerControllers_Fn type side fingNum linkNum  = (
		--アクターは有効か?
		if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do(
			
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				
				if keyboard.shiftPressed then
				(
				--////////////////////////////////////////////////		
				--追加選択
				--////////////////////////////////////////////////	
					undo on (
						case type of (
							1:(
						------------------------------------------------
						--手だったら
						case side of (
							1:(
								case fingNum of (
									0:(selectMore L0fingerNodes[linkNum]);
									1:(selectMore L1fingerNodes[linkNum]);
									2:(selectMore L2fingerNodes[linkNum]);
									3:(selectMore L3fingerNodes[linkNum]);
									4:(selectMore L4fingerNodes[linkNum]);
									);--case end
								);--leftend
							2:(
								case fingNum of (
									0:(selectMore R0fingerNodes[linkNum]);
									1:(selectMore R1fingerNodes[linkNum]);
									2:(selectMore R2fingerNodes[linkNum]);
									3:(selectMore R3fingerNodes[linkNum]);
									4:(selectMore R4fingerNodes[linkNum]);
									);--case end
								);--2end
						);--case end左か右か
						
							);--手終わり
						------------------------------------------------
							
						------------------------------------------------
						--脚だったら
							2:(
						case side of (
							1:(
								case fingNum of (
									0:(selectMore L0toeNodes[linkNum]);
									1:(selectMore L1toeNodes[linkNum]);
									2:(selectMore L2toeNodes[linkNum]);
									3:(selectMore L3toeNodes[linkNum]);
									4:(selectMore L4toeNodes[linkNum]);
									);--case end
								);--leftend
							2:(
								case fingNum of (
									0:(selectMore R0toeNodes[linkNum]);
									1:(selectMore R1toeNodes[linkNum]);
									2:(selectMore R2toeNodes[linkNum]);
									3:(selectMore R3toeNodes[linkNum]);
									4:(selectMore R4toeNodes[linkNum]);
									);--2end
								);--case end
						);--case end左か右か
						
							);--脚終わり
						------------------------------------------------
						);--case end手か足か
						
					if (selFocus) do max zoomext sel;
						
					);--undo end
				)else if keyboard.controlPressed then(
					
				--////////////////////////////////////////////////		
				--選択解除
				--////////////////////////////////////////////////	
					undo on (
						case type of (
							1:(
						--手
						case side of (
							1:(
								case fingNum of (
									0:(deselect L0fingerNodes[linkNum]);
									1:(deselect L1fingerNodes[linkNum]);
									2:(deselect L2fingerNodes[linkNum]);
									3:(deselect L3fingerNodes[linkNum]);
									4:(deselect L4fingerNodes[linkNum]);
									);--case end
								);--左終わり
							2:(
								case fingNum of (
									0:(deselect R0fingerNodes[linkNum]);
									1:(deselect R1fingerNodes[linkNum]);
									2:(deselect R2fingerNodes[linkNum]);
									3:(deselect R3fingerNodes[linkNum]);
									4:(deselect R4fingerNodes[linkNum]);
									);--case end
								);--右終わり
						);--左右終わり							
							);--手終わり
							
						--脚
							2:(
						case side of (
							1:(
								case fingNum of (
									0:(deselect L0toeNodes[linkNum]);
									1:(deselect L1toeNodes[linkNum]);
									2:(deselect L2toeNodes[linkNum]);
									3:(deselect L3toeNodes[linkNum]);
									4:(deselect L4toeNodes[linkNum]);
									);--case end
								);--左終わり
							2:(
								case fingNum of (
									0:(deselect R0toeNodes[linkNum]);
									1:(deselect R1toeNodes[linkNum]);
									2:(deselect R2toeNodes[linkNum]);
									3:(deselect R3toeNodes[linkNum]);
									4:(deselect R4toeNodes[linkNum]);
									);--case end
								);--右終わり
						);--左右終わり
							);--脚終わり
						);--手か脚か？end
					);--undo end
					
				)else if keyboard.altPressed then(
				--////////////////////////////////////////////////		
				--ツリー選択
				--////////////////////////////////////////////////	(sj_functions.sj_selectBranch_Fn  1)
					undo on (
						case type of (
							1:(
						--手
						case side of (
							1:(
								case fingNum of (
									0:(selectMore (sj_functions.sj_selectBranch_Fn L0fingerNodes[linkNum] 1));
									1:(selectMore (sj_functions.sj_selectBranch_Fn L1fingerNodes[linkNum] 1));
									2:(selectMore (sj_functions.sj_selectBranch_Fn L2fingerNodes[linkNum] 1));
									3:(selectMore (sj_functions.sj_selectBranch_Fn L3fingerNodes[linkNum] 1));
									4:(selectMore (sj_functions.sj_selectBranch_Fn L4fingerNodes[linkNum] 1));
									);--case end
								);--左終わり
							2:(
								case fingNum of (
									0:(selectMore (sj_functions.sj_selectBranch_Fn R0fingerNodes[linkNum] 1));
									1:(selectMore (sj_functions.sj_selectBranch_Fn R1fingerNodes[linkNum] 1));
									2:(selectMore (sj_functions.sj_selectBranch_Fn R2fingerNodes[linkNum] 1));
									3:(selectMore (sj_functions.sj_selectBranch_Fn R3fingerNodes[linkNum] 1));
									4:(selectMore (sj_functions.sj_selectBranch_Fn R4fingerNodes[linkNum] 1));
									);--case end
								);--右終わり
						);--左右終わり							
							);--手終わり
							
						--脚
							2:(
						case side of (
							1:(
								case fingNum of (
									0:(selectMore (sj_functions.sj_selectBranch_Fn L0toeNodes[linkNum] 1));
									1:(selectMore (sj_functions.sj_selectBranch_Fn L1toeNodes[linkNum] 1));
									2:(selectMore (sj_functions.sj_selectBranch_Fn L2toeNodes[linkNum] 1));
									3:(selectMore (sj_functions.sj_selectBranch_Fn L3toeNodes[linkNum] 1));
									4:(selectMore (sj_functions.sj_selectBranch_Fn L4toeNodes[linkNum] 1));
									);--case end
								);--左終わり
							2:(
								case fingNum of (
									0:(selectMore (sj_functions.sj_selectBranch_Fn R0toeNodes[linkNum] 1));
									1:(selectMore (sj_functions.sj_selectBranch_Fn R1toeNodes[linkNum] 1));
									2:(selectMore (sj_functions.sj_selectBranch_Fn R2toeNodes[linkNum] 1));
									3:(selectMore (sj_functions.sj_selectBranch_Fn R3toeNodes[linkNum] 1));
									4:(selectMore (sj_functions.sj_selectBranch_Fn R4toeNodes[linkNum] 1));
									);--case end
								);--右終わり
						);--左右終わり
							);--脚終わり
						);--手か脚か？end
					);--undo end
					
				)else	(
					
				--////////////////////////////////////////////////		
				--通常の選択
				--////////////////////////////////////////////////	
					undo on (
					clearSelection()
						
						case type of (
							1:(
						--手
						case side of (
							1:(
								case fingNum of (
									0:(select L0fingerNodes[linkNum]);
									1:(select L1fingerNodes[linkNum]);
									2:(select L2fingerNodes[linkNum]);
									3:(select L3fingerNodes[linkNum]);
									4:(select L4fingerNodes[linkNum]);
									);--case end
								);--leftend
							2:(
								case fingNum of (
									0:(select R0fingerNodes[linkNum]);
									1:(select R1fingerNodes[linkNum]);
									2:(select R2fingerNodes[linkNum]);
									3:(select R3fingerNodes[linkNum]);
									4:(select R4fingerNodes[linkNum]);
									);--case end
								);--右終わり
						);--左右終わりcase end
							);--手終わり
							
							2:(
							--脚
						case side of (
							1:(
								case fingNum of (
									0:(select L0toeNodes[linkNum]);
									1:(select L1toeNodes[linkNum]);
									2:(select L2toeNodes[linkNum]);
									3:(select L3toeNodes[linkNum]);
									4:(select L4toeNodes[linkNum]);
									);--case end
								);--leftend
							2:(
								case fingNum of (
									0:(select R0toeNodes[linkNum]);
									1:(select R1toeNodes[linkNum]);
									2:(select R2toeNodes[linkNum]);
									3:(select R3toeNodes[linkNum]);
									4:(select R4toeNodes[linkNum]);
									);--case end
								);--右終わり
						);--左右終わりcase end
							);--脚終わり
						);--手か脚か？end

					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
				
				);--2end
				);--case end
		);--アクターは有効かend
		);--fn end
		
		--////////////////////////////////////////////////
		--列か全体選択　引数は 手1か足2  左1か右2か選択タイプは?(1列 2親以外 3サイド全 4全部) 指の番号0～4　or -1
		--SJの場合は0を指定、リンクが無い場合も0を指定
		--////////////////////////////////////////////////		
		fn selFingAllControllers_Fn type side selType fingNum = (
		--アクターは有効か?
		if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do(
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				
				if keyboard.shiftPressed then
				(
				--////////////////////////////////////////////////		
				--追加選択
				--////////////////////////////////////////////////	
					undo on (
						case type of (
							1:(
						------------------------------------------------
						--手だったら
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(selectMore L0fingerNodes);
									1:(selectMore L1fingerNodes);
									2:(selectMore L2fingerNodes);
									3:(selectMore L3fingerNodes);
									4:(selectMore L4fingerNodes);
									);--case end
									);--列
									2:(
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
									);--親以外
									3:(
										selectMore L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
									);--サイド全
									4:(
										selectMore L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
										selectMore R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(selectMore R0fingerNodes);
									1:(selectMore R1fingerNodes);
									2:(selectMore R2fingerNodes);
									3:(selectMore R3fingerNodes);
									4:(selectMore R4fingerNodes);
									);--case end
									);--列
									2:(
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--親以外
									3:(
										selectMore R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--サイド全
									4:(
										selectMore L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
										selectMore R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--2end
						);--case end左か右か
						
							);--手終わり
						------------------------------------------------
							
						------------------------------------------------
						--脚だったら
							2:(
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(selectMore L0toeNodes);
									1:(selectMore L1toeNodes);
									2:(selectMore L2toeNodes);
									3:(selectMore L3toeNodes);
									4:(selectMore L4toeNodes);
									);--case end
									);--列
									2:(
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
									);--親以外
									3:(
										selectMore L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
									);--サイド全
									4:(
										selectMore L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
										selectMore R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(selectMore R0toeNodes);
									1:(selectMore R1toeNodes);
									2:(selectMore R2toeNodes);
									3:(selectMore R3toeNodes);
									4:(selectMore R4toeNodes);
									);--case end
									);--列
									2:(
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--親以外
									3:(
										selectMore R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--サイド全
									4:(
										selectMore L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
										selectMore R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--全部
								);--選択タイプエンド
							);--右終わり
						);--case end左か右か
						
							);--脚終わり
						------------------------------------------------
						);--case end手か足か
						
					if (selFocus) do max zoomext sel;
						
					);--undo end
				)else if keyboard.controlPressed then(
					
				--////////////////////////////////////////////////		
				--選択解除
				--////////////////////////////////////////////////	
					undo on (
						case type of (
							1:(
						--手
						------------------------------------------------
						--手だったら
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(deselect L0fingerNodes);
									1:(deselect L1fingerNodes);
									2:(deselect L2fingerNodes);
									3:(deselect L3fingerNodes);
									4:(deselect L4fingerNodes);
									);--case end
									);--列
									2:(
										deselect L1fingerNodes;
										deselect L2fingerNodes;
										deselect L3fingerNodes;
										deselect L4fingerNodes;
									);--親以外
									3:(
										deselect L0fingerNodes;
										deselect L1fingerNodes;
										deselect L2fingerNodes;
										deselect L3fingerNodes;
										deselect L4fingerNodes;
									);--サイド全
									4:(
										deselect L0fingerNodes;
										deselect L1fingerNodes;
										deselect L2fingerNodes;
										deselect L3fingerNodes;
										deselect L4fingerNodes;
										deselect R0fingerNodes;
										deselect R1fingerNodes;
										deselect R2fingerNodes;
										deselect R3fingerNodes;
										deselect R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(deselect R0fingerNodes);
									1:(deselect R1fingerNodes);
									2:(deselect R2fingerNodes);
									3:(deselect R3fingerNodes);
									4:(deselect R4fingerNodes);
									);--case end
									);--列
									2:(
										deselect R1fingerNodes;
										deselect R2fingerNodes;
										deselect R3fingerNodes;
										deselect R4fingerNodes;
									);--親以外
									3:(
										deselect R0fingerNodes;
										deselect R1fingerNodes;
										deselect R2fingerNodes;
										deselect R3fingerNodes;
										deselect R4fingerNodes;
									);--サイド全
									4:(
										deselect L0fingerNodes;
										deselect L1fingerNodes;
										deselect L2fingerNodes;
										deselect L3fingerNodes;
										deselect L4fingerNodes;
										deselect R0fingerNodes;
										deselect R1fingerNodes;
										deselect R2fingerNodes;
										deselect R3fingerNodes;
										deselect R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--2end
						);--case end左か右か
						
							);--手終わり
						------------------------------------------------
							
						------------------------------------------------
						--脚だったら
							2:(
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(deselect L0toeNodes);
									1:(deselect L1toeNodes);
									2:(deselect L2toeNodes);
									3:(deselect L3toeNodes);
									4:(deselect L4toeNodes);
									);--case end
									);--列
									2:(
										deselect L1toeNodes;
										deselect L2toeNodes;
										deselect L3toeNodes;
										deselect L4toeNodes;
									);--親以外
									3:(
										deselect L0toeNodes;
										deselect L1toeNodes;
										deselect L2toeNodes;
										deselect L3toeNodes;
										deselect L4toeNodes;
									);--サイド全
									4:(
										deselect L0toeNodes;
										deselect L1toeNodes;
										deselect L2toeNodes;
										deselect L3toeNodes;
										deselect L4toeNodes;
										deselect R0toeNodes;
										deselect R1toeNodes;
										deselect R2toeNodes;
										deselect R3toeNodes;
										deselect R4toeNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(deselect R0toeNodes);
									1:(deselect R1toeNodes);
									2:(deselect R2toeNodes);
									3:(deselect R3toeNodes);
									4:(deselect R4toeNodes);
									);--case end
									);--列
									2:(
										deselect R1toeNodes;
										deselect R2toeNodes;
										deselect R3toeNodes;
										deselect R4toeNodes;
									);--親以外
									3:(
										deselect R0toeNodes;
										deselect R1toeNodes;
										deselect R2toeNodes;
										deselect R3toeNodes;
										deselect R4toeNodes;
									);--サイド全
									4:(
										deselect L0toeNodes;
										deselect L1toeNodes;
										deselect L2toeNodes;
										deselect L3toeNodes;
										deselect L4toeNodes;
										deselect R0toeNodes;
										deselect R1toeNodes;
										deselect R2toeNodes;
										deselect R3toeNodes;
										deselect R4toeNodes;
									);--全部
								);--選択タイプエンド
							);--右終わり
						);--case end左か右か
						
							);--脚終わり
						------------------------------------------------
						);--手か脚か？end
					);--undo end
					
				)else	(
					
				--////////////////////////////////////////////////		
				--通常の選択
				--////////////////////////////////////////////////	
					undo on (
					clearSelection()
						
						case type of (
							1:(
						--手
						------------------------------------------------
						--手だったら
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(select L0fingerNodes);
									1:(select L1fingerNodes);
									2:(select L2fingerNodes);
									3:(select L3fingerNodes);
									4:(select L4fingerNodes);
									);--case end
									);--列
									2:(
										select L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
									);--親以外
									3:(
										select L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
									);--サイド全
									4:(
										select L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
										selectMore R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(select R0fingerNodes);
									1:(select R1fingerNodes);
									2:(select R2fingerNodes);
									3:(select R3fingerNodes);
									4:(select R4fingerNodes);
									);--case end
									);--列
									2:(
										select R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--親以外
									3:(
										select R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--サイド全
									4:(
										select L0fingerNodes;
										selectMore L1fingerNodes;
										selectMore L2fingerNodes;
										selectMore L3fingerNodes;
										selectMore L4fingerNodes;
										selectMore R0fingerNodes;
										selectMore R1fingerNodes;
										selectMore R2fingerNodes;
										selectMore R3fingerNodes;
										selectMore R4fingerNodes;
									);--全部
								);--選択タイプエンド
								);--2end
						);--case end左か右か
						
							);--手終わり
						------------------------------------------------
							
						------------------------------------------------
						--脚だったら
							2:(
						case side of (
							1:(
								case selType of (
									1:(
								case fingNum of (
									0:(select L0toeNodes);
									1:(select L1toeNodes);
									2:(select L2toeNodes);
									3:(select L3toeNodes);
									4:(select L4toeNodes);
									);--case end
									);--列
									2:(
										select L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
									);--親以外
									3:(
										select L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
									);--サイド全
									4:(
										select L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
										selectMore R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--全部
								);--選択タイプエンド
								);--leftend
							2:(
								case selType of (
									1:(
								case fingNum of (
									0:(select R0toeNodes);
									1:(select R1toeNodes);
									2:(select R2toeNodes);
									3:(select R3toeNodes);
									4:(select R4toeNodes);
									);--case end
									);--列
									2:(
										select R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--親以外
									3:(
										select R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--サイド全
									4:(
										select L0toeNodes;
										selectMore L1toeNodes;
										selectMore L2toeNodes;
										selectMore L3toeNodes;
										selectMore L4toeNodes;
										selectMore R0toeNodes;
										selectMore R1toeNodes;
										selectMore R2toeNodes;
										selectMore R3toeNodes;
										selectMore R4toeNodes;
									);--全部
								);--選択タイプエンド
							);--右終わり
						);--case end左か右か
						
							);--脚終わり
						------------------------------------------------
						);--手か脚か？end

					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
				
				);--2end
				);--case end
		);--アクターは有効か?end
		);--fn end

		--////////////////////////////////////////////////
		--逆を選択、指も含む
		--////////////////////////////////////////////////	
		fn flipFingerSelection_Fn =(
				case actorType of (
				--beyondなら
				1:(
				);
				2:(
					local tempArray = #();--逆側を確保
					for i = 1 to L0fingerNodes.count do (if L0fingerNodes[i].isSelected do append tempArray R0fingerNodes[i]);--for end
					for i = 1 to L1fingerNodes.count do (if L1fingerNodes[i].isSelected do append tempArray R1fingerNodes[i]);--for end
					for i = 1 to L2fingerNodes.count do (if L2fingerNodes[i].isSelected do append tempArray R2fingerNodes[i]);--for end
					for i = 1 to L3fingerNodes.count do (if L3fingerNodes[i].isSelected do append tempArray R3fingerNodes[i]);--for end
					for i = 1 to L4fingerNodes.count do (if L4fingerNodes[i].isSelected do append tempArray R4fingerNodes[i]);--for end
					for i = 1 to R0fingerNodes.count do (if R0fingerNodes[i].isSelected do append tempArray L0fingerNodes[i]);--for end
					for i = 1 to R1fingerNodes.count do (if R1fingerNodes[i].isSelected do append tempArray L1fingerNodes[i]);--for end
					for i = 1 to R2fingerNodes.count do (if R2fingerNodes[i].isSelected do append tempArray L2fingerNodes[i]);--for end
					for i = 1 to R3fingerNodes.count do (if R3fingerNodes[i].isSelected do append tempArray L3fingerNodes[i]);--for end
					for i = 1 to R4fingerNodes.count do (if R4fingerNodes[i].isSelected do append tempArray L4fingerNodes[i]);--for end
				--選択作業
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
						selectMore tempArray
						if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					--undo on ( deselect tempArray);--undo end
				)else	(
				--選択
					undo on (
					clearSelection();
					select tempArray;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
					tempArray = #();
				);
			);--case end
		
		);--fn end
		fn flipToeSelection_Fn =(
		--アクターは有効か?
		if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do(
				case actorType of (
				--beyondなら
				1:(
				);
				2:(
					local tempArray = #();--逆側を確保
					for i = 1 to L0toeNodes.count do (if L0toeNodes[i].isSelected do append tempArray R0toeNodes[i]);--for end
					for i = 1 to L1toeNodes.count do (if L1toeNodes[i].isSelected do append tempArray R1toeNodes[i]);--for end
					for i = 1 to L2toeNodes.count do (if L2toeNodes[i].isSelected do append tempArray R2toeNodes[i]);--for end
					for i = 1 to L3toeNodes.count do (if L3toeNodes[i].isSelected do append tempArray R3toeNodes[i]);--for end
					for i = 1 to L4toeNodes.count do (if L4toeNodes[i].isSelected do append tempArray R4toeNodes[i]);--for end
					for i = 1 to R0toeNodes.count do (if R0toeNodes[i].isSelected do append tempArray L0toeNodes[i]);--for end
					for i = 1 to R1toeNodes.count do (if R1toeNodes[i].isSelected do append tempArray L1toeNodes[i]);--for end
					for i = 1 to R2toeNodes.count do (if R2toeNodes[i].isSelected do append tempArray L2toeNodes[i]);--for end
					for i = 1 to R3toeNodes.count do (if R3toeNodes[i].isSelected do append tempArray L3toeNodes[i]);--for end
					for i = 1 to R4toeNodes.count do (if R4toeNodes[i].isSelected do append tempArray L4toeNodes[i]);--for end
				--選択作業
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
						selectMore tempArray
						if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					--undo on ( deselect tempArray);--undo end
				)else	(
				--選択
					undo on (
					clearSelection();
					select tempArray;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
					tempArray = #();
				);
			);--case end
		);--アクターは有効か?
		);--fn end
		
	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
	Local tempBm= (bitmap 1 1 color:(color 1 2 3));
		
	label Rlbl "R" pos:[168,4] width:8 height:20
	label Llbl "L" pos:[8,4] width:8 height:20

	button L4AllBt "小" pos:[4,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 83 125)), tempBm, 1, 1, 2, 2, 2)
	button L3AllBt "薬" pos:[20,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 105)), tempBm, 1, 1, 2, 2, 2)
	button L2AllBt "中" pos:[36,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 0)), tempBm, 1, 1, 2, 2, 2)
	button L1AllBt "人" pos:[52,160] width:16 height:16 images:#((bitmap 16 16 color:(color 69 83 0)), tempBm, 1, 1, 2, 2, 2)
	button L0AllBt "親" pos:[72,160] width:16 height:16 images:#((bitmap 16 16 color:(color 83 55 0)), tempBm, 1, 1, 2, 2, 2)
	button R4AllBt "小" pos:[164,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 83 125)), tempBm, 1, 1, 2, 2, 2)
	button R3AllBt "薬" pos:[148,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 105)), tempBm, 1, 1, 2, 2, 2)
	button R2AllBt "中" pos:[132,160] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 0)), tempBm, 1, 1, 2, 2, 2)
	button R1AllBt "人" pos:[116,160] width:16 height:16 images:#((bitmap 16 16 color:(color 69 83 0)), tempBm, 1, 1, 2, 2, 2)
	button R0AllBt "親" pos:[96,160] width:16 height:16 images:#((bitmap 16 16 color:(color 83 55 0)), tempBm, 1, 1, 2, 2, 2)
	button L1to4AllBt "親以外" pos:[4,180] width:44 height:16
	button R1to4AllBt "親以外" pos:[136,180] width:44 height:16
	button LFingAllSelBt "左全" pos:[52,180] width:36 height:16
	button RFingAllSelBt "右全" pos:[96,180] width:36 height:16
	button FingAllSelBt "全選択" pos:[4,200] width:84 height:20
	button SelFlipBt "逆を選択" pos:[96,200] width:84 height:20
 
	--Local tempBm= (bitmap 52 16 color:(color 6 134 6));--クリックしたとき	(color 134 6 6) (color 108 8 136) (color 224 198 87)

	button fLHandBt "" pos:[12,136] width:52 height:16 images:#((bitmap 52 16 color:(color 28 28 177)), tempBm, 1, 1, 2, 2, 2)
	button fRHandBt "" pos:[120,136] width:52 height:16 images:#((bitmap 52 16 color:(color 6 134 6)), tempBm, 1, 1, 2, 2, 2)
	
	button L01Bt "" pos:[72,124] width:12 height:28 images:#((bitmap 12 28 color:(color 134 6 6)), tempBm, 1, 1, 2, 2, 2)
	button L02Bt "" pos:[76,96] width:12 height:20 images:#((bitmap 12 20 color:(color 134 6 6)), tempBm, 1, 1, 2, 2, 2)
	button L03Bt "" pos:[76,68] width:12 height:20 images:#((bitmap 12 20 color:(color 134 6 6)), tempBm, 1, 1, 2, 2, 2)
	button L04Bt "" pos:[76,42] width:12 height:20 images:#((bitmap 12 20 color:(color 134 6 6)), tempBm, 1, 1, 2, 2, 2)
	
	button L10Bt "" pos:[56,108] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L11Bt "" pos:[56,80] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L12Bt "" pos:[56,52] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L13Bt "" pos:[56,24] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	
	button L20Bt "" pos:[40,108] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L21Bt "" pos:[40,72] width:12 height:28 images:#((bitmap 12 28 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L22Bt "" pos:[40,40] width:12 height:24 images:#((bitmap 12 24 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L23Bt "" pos:[40,12] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button L30Bt "" pos:[24,108] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L31Bt "" pos:[24,76] width:12 height:24 images:#((bitmap 12 24 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L32Bt "" pos:[24,44] width:12 height:24 images:#((bitmap 12 24 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L33Bt "" pos:[24,16] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button L40Bt "" pos:[8,108] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L41Bt "" pos:[8,80] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L42Bt "" pos:[8,52] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button L43Bt "" pos:[8,24] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button R01Bt "" pos:[100,124] width:12 height:28 images:#((bitmap 12 28 color:(color 224 198 87)), tempBm, 1, 1, 2, 2, 2)
	button R02Bt "" pos:[96,96] width:12 height:20 images:#((bitmap 12 20 color:(color 224 198 87)), tempBm, 1, 1, 2, 2, 2)
	button R03Bt "" pos:[96,68] width:12 height:20 images:#((bitmap 12 20 color:(color 224 198 87)), tempBm, 1, 1, 2, 2, 2)
	button R04Bt "" pos:[96,42] width:12 height:20 images:#((bitmap 12 20 color:(color 224 198 87)), tempBm, 1, 1, 2, 2, 2)
	
	button R10Bt "" pos:[116,108] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R11Bt "" pos:[116,80] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R12Bt "" pos:[116,52] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R13Bt "" pos:[116,24] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	
	button R20Bt "" pos:[132,108] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R21Bt "" pos:[132,72] width:12 height:28 images:#((bitmap 12 28 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R22Bt "" pos:[132,40] width:12 height:24 images:#((bitmap 12 24 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R23Bt "" pos:[132,12] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	
	button R30Bt "" pos:[148,108] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R31Bt "" pos:[148,76] width:12 height:24 images:#((bitmap 12 24 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R32Bt "" pos:[148,44] width:12 height:24 images:#((bitmap 12 24 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R33Bt "" pos:[148,16] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	
	button R40Bt "" pos:[164,108] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R41Bt "" pos:[164,80] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R42Bt "" pos:[164,52] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button R43Bt "" pos:[164,24] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)

	button fLFootBt "" pos:[16,330] width:72 height:20 images:#((bitmap 72 20 color:(color 28 28 177)), tempBm, 1, 1, 2, 2, 2)
	button fRFootBt "" pos:[96,330] width:72 height:20 images:#((bitmap 72 20 color:(color 6 134 6)), tempBm, 1, 1, 2, 2, 2)
	
	button fL01Bt "" pos:[74,296] width:14 height:28 images:#((bitmap 14 28 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL02Bt "" pos:[74,264] width:14 height:24 images:#((bitmap 14 24 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL03Bt "" pos:[74,236] width:14 height:20 images:#((bitmap 14 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button fL11Bt "" pos:[56,304] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL12Bt "" pos:[56,276] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL13Bt "" pos:[56,248] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button fL21Bt "" pos:[40,308] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL22Bt "" pos:[40,284] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL23Bt "" pos:[40,256] width:12 height:20 images:#((bitmap 12 20 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)

	button fL31Bt "" pos:[24,308] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL32Bt "" pos:[24,284] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL33Bt "" pos:[24,260] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
             
	button fL41Bt "" pos:[8,308] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL42Bt "" pos:[8,284] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
	button fL43Bt "" pos:[8,260] width:12 height:16 images:#((bitmap 12 16 color:(color 108 8 136)), tempBm, 1, 1, 2, 2, 2)
             
	button fR01Bt "" pos:[96,296] width:14 height:28 images:#((bitmap 12 28 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR02Bt "" pos:[96,264] width:14 height:24 images:#((bitmap 12 24 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR03Bt "" pos:[96,236] width:14 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
             
	button fR11Bt "" pos:[116,304] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR12Bt "" pos:[116,276] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR13Bt "" pos:[116,248] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
             
	button fR21Bt "" pos:[132,308] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR22Bt "" pos:[132,284] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR23Bt "" pos:[132,256] width:12 height:20 images:#((bitmap 12 20 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
             
	button fR31Bt "" pos:[148,308] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR32Bt "" pos:[148,284] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR33Bt "" pos:[148,260] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
             
	button fR41Bt "" pos:[164,308] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR42Bt "" pos:[164,284] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
	button fR43Bt "" pos:[164,260] width:12 height:16 images:#((bitmap 12 16 color:(color 113 134 6)), tempBm, 1, 1, 2, 2, 2)
             
	button fL4AllBt "小" pos:[4,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 83 125)), tempBm, 1, 1, 2, 2, 2)
	button fL3AllBt "薬" pos:[20,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 105)), tempBm, 1, 1, 2, 2, 2)
	button fL2AllBt "中" pos:[36,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 0)), tempBm, 1, 1, 2, 2, 2)
	button fL1AllBt "人" pos:[52,356] width:16 height:16 images:#((bitmap 16 16 color:(color 69 83 0)), tempBm, 1, 1, 2, 2, 2)
	button fL0AllBt "親" pos:[72,356] width:16 height:16 images:#((bitmap 16 16 color:(color 83 55 0)), tempBm, 1, 1, 2, 2, 2)
	button fR4AllBt "小" pos:[164,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 83 125)), tempBm, 1, 1, 2, 2, 2)
	button fR3AllBt "薬" pos:[148,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 105)), tempBm, 1, 1, 2, 2, 2)
	button fR2AllBt "中" pos:[132,356] width:16 height:16 images:#((bitmap 16 16 color:(color 0 125 0)), tempBm, 1, 1, 2, 2, 2)
	button fR1AllBt "人" pos:[116,356] width:16 height:16 images:#((bitmap 16 16 color:(color 69 83 0)), tempBm, 1, 1, 2, 2, 2)
	button fR0AllBt "親" pos:[96,356] width:16 height:16 images:#((bitmap 16 16 color:(color 83 55 0)), tempBm, 1, 1, 2, 2, 2)
	button fL1to4AllBt "親以外" pos:[4,376] width:44 height:16
	button fR1to4AllBt "親以外" pos:[136,376] width:44 height:16
	button fLFingAllSelBt "左全" pos:[52,376] width:36 height:16
	button fRFingAllSelBt "右全" pos:[96,376] width:36 height:16
	button fFingAllSelBt "全選択" pos:[4,396] width:84 height:20
	button fSelFlipBt "逆を選択" pos:[96,396] width:84 height:20
	
			--////////////////////////////////////////////////
			--アクション
			--////////////////////////////////////////////////	
			--手足
			on fLHandBt pressed do (if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 1 true 4);););
			on fRHandBt pressed do (if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 2 true 4);););
			on fLFootBt pressed do (
			if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
				case actorType of (1:();
				2:(
						--脚対策
						if (bipNode.legLinks > 3) then (sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 5 true 4)else(sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 5 true 3);--if end
				););););--end
			on fRFootBt pressed do (
			if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
				case actorType of (1:();
				2:(
						--脚対策
						if (bipNode.legLinks > 3) then (sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 6 true 4)else(sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.selControllers_Fn 6 true 3);--if end
				););););
			--選択反転、、
			on SelFlipBt pressed do if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do flipFingerSelection_Fn();
			on fSelFlipBt pressed do if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do flipToeSelection_Fn();
			--指
			--各部選択　引数は 手1か足2 左1か右2か　指の番号　関節番号
			on L01Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 0 1);););
			on L02Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 0 2);););
			on L03Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 0 3);););
			on L04Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 0 4);););
			on L10Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 1 1);););
			on L11Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 1 2);););
			on L12Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 1 3);););
			on L13Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 1 4);););
			on L20Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 2 1);););
			on L21Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 2 2);););
			on L22Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 2 3);););
			on L23Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 2 4);););
			on L30Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 3 1);););
			on L31Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 3 2);););
			on L32Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 3 3);););
			on L33Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 3 4);););
			on L40Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 4 1);););
			on L41Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 4 2);););
			on L42Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 4 3);););
			on L43Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 1 4 4);););
			on R01Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 0 1);););
			on R02Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 0 2);););
			on R03Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 0 3);););
			on R04Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 0 4);););
			on R10Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 1 1);););
			on R11Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 1 2);););
			on R12Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 1 3);););
			on R13Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 1 4);););
			on R20Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 2 1);););
			on R21Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 2 2);););
			on R22Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 2 3);););
			on R23Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 2 4);););
			on R30Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 3 1);););
			on R31Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 3 2);););
			on R32Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 3 3);););
			on R33Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 3 4);););
			on R40Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 4 1);););
			on R41Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 4 2);););
			on R42Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 4 3);););
			on R43Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 1 2 4 4);););
			
			--各部選択　引数は 手1か足2 左1か右2か　指の番号　関節番号
			on fL01Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 0 1);););
			on fL02Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 0 2);););
			on fL03Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 0 3);););
			on fL11Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 1 1);););
			on fL12Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 1 2);););
			on fL13Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 1 3);););
			on fL21Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 2 1);););
			on fL22Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 2 2);););
			on fL23Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 2 3);););
			on fL31Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 3 1);););
			on fL32Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 3 2);););
			on fL33Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 3 3);););
			on fL41Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 4 1);););
			on fL42Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 4 2);););
			on fL43Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 1 4 3);););
			
			on fR01Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 0 1);););
			on fR02Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 0 2);););
			on fR03Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 0 3);););
			on fR11Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 1 1);););
			on fR12Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 1 2);););
			on fR13Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 1 3);););
			on fR21Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 2 1);););
			on fR22Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 2 2);););
			on fR23Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 2 3);););
			on fR31Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 3 1);););
			on fR32Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 3 2);););
			on fR33Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 3 3);););
			on fR41Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 4 1);););
			on fR42Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 4 2);););
			on fR43Bt pressed do (case actorType of (1:();2:(selFingerControllers_Fn 2 2 4 3);););
			
			--列か全体選択　引数は手1か足2/ 左1か右2か/選択タイプは?(1列 2親以外 3サイド全 4全部)/指の番号0～4　or -1
			on L4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 1 4);););
			on L3AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 1 3);););
			on L2AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 1 2);););
			on L1AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 1 1);););
			on L0AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 1 0);););
			on R4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 1 4);););
			on R3AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 1 3);););
			on R2AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 1 2);););
			on R1AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 1 1);););
			on R0AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 1 0);););
			on fL4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 1 4);););
			on fL3AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 1 3);););
			on fL2AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 1 2);););
			on fL1AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 1 1);););
			on fL0AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 1 0);););
			on fR4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 1 4);););
			on fR3AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 1 3);););
			on fR2AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 1 2);););
			on fR1AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 1 1);););
			on fR0AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 1 0);););
			
			on L1to4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 2 -1);););
			on R1to4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 2 -1);););
			on LFingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 3 -1);););
			on RFingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 2 3 -1);););
			on FingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 1 1 4 -1);););
				
			on fL1to4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 2 -1);););
			on fR1to4AllBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 2 -1);););
			on fLFingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 3 -1);););
			on fRFingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 2 3 -1);););
			on fFingAllSelBt pressed do (case actorType of (1:();2:(selFingAllControllers_Fn 2 1 4 -1);););
			
			--////////////////////////////////////////////////
			--アクションロールアウト
			--////////////////////////////////////////////////		
			on sj_srFinger_rol open do --ロールアウトが開いたとき
			(
				uiFingerSet_Fn();
			)--open do end
			
			on sj_srFinger_rol rolledUp state do
			(
				--閉じた場合はfalse開いた場合はtrue
				if state then
				(
				--iniに情報を書き込む
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FingerRol" "false");
				)else
				(
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FingerRol" "true");
				);--if end
			);--end

	);

	rollout sj_srFfaceRigSel_rol "Face"
	(
	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
			/*顔用
	button eyeAllBt "EyeAll" pos:[73,33] width:36 height:20
	button LEyeBt "LE" pos:[55,33] width:18 height:16
	button REyeBt "RE" pos:[109,33] width:18 height:16
	button JawAll "Jaw" pos:[71,266] width:36 height:24
	button nAll "N" pos:[80,160] width:18 height:18
	button allSelBt "全選択" pos:[8,8] width:52 height:20
	button allMoveBt "逆を選択" pos:[124,8] width:52 height:20
	button CUm "M" pos:[80,184] width:18 height:18
	button LUm "M" pos:[62,190] width:14 height:14
	button RUm "M" pos:[102,190] width:14 height:14
	button Rm "M" pos:[120,198] width:18 height:18
	button Lm "M" pos:[40,198] width:18 height:18
	button LDm "M" pos:[62,216] width:14 height:14
	button RDm "M" pos:[102,216] width:14 height:14
	button CDm "M" pos:[80,216] width:18 height:18
	button RDn "N" pos:[102,150] width:14 height:14
	button LDn "N" pos:[62,150] width:14 height:14
	button MUn "N" pos:[83,118] width:12 height:12
	button LUn "N" pos:[65,130] width:12 height:12 enabled:true
	button RUn "N" pos:[101,130] width:12 height:12
	button Cj "J" pos:[80,244] width:18 height:18
	button Rj "J" pos:[118,240] width:14 height:14
	button Lj "J" pos:[46,240] width:14 height:14
	button LDc "C" pos:[10,206] width:18 height:18
	button Lc "C" pos:[30,174] width:18 height:18
	button Rc "C" pos:[132,174] width:18 height:18
	button RDc "C" pos:[150,206] width:18 height:18
	button LUcIn "C" pos:[34,152] width:14 height:14
	button LUcOut "C" pos:[6,146] width:14 height:14
	button LcOut "C" pos:[6,168] width:14 height:14
	button RUcIn "C" pos:[132,152] width:14 height:14
	button RcOut "C" pos:[160,168] width:14 height:14
	button RUcOut "C" pos:[160,146] width:14 height:14
	button LDeIn "E" pos:[52,118] width:12 height:12 enabled:true
	button LDeM "E" pos:[28,128] width:18 height:18
	button LDeOut "E" pos:[10,118] width:12 height:12 enabled:true
	button LeOut "E" pos:[14,100] width:12 height:12 enabled:true
	button LeM "E" pos:[28,96] width:18 height:18
	button LeIn "E" pos:[48,100] width:12 height:12 enabled:true
	button RDeOut "E" pos:[158,118] width:12 height:12 enabled:true
	button RDeM "E" pos:[134,128] width:18 height:18
	button RDeIn "E" pos:[116,118] width:12 height:12 enabled:true
	button ReIn "E" pos:[120,100] width:12 height:12 enabled:true
	button ReM "E" pos:[134,96] width:18 height:18
	button ReOut "E" pos:[154,100] width:12 height:12 enabled:true
	button LebIn "eb" pos:[60,72] width:18 height:18
	button RebIn "eb" pos:[102,72] width:18 height:18
	button LeAll "E" pos:[24,82] width:24 height:14
	button ReAll "E" pos:[130,82] width:24 height:14
	button LebM "eb" pos:[34,64] width:14 height:14
	button LebOut "eb" pos:[8,68] width:14 height:14
	button btn57 "eb" pos:[30,50] width:24 height:14
	button Lf "F" pos:[10,48] width:12 height:12 enabled:true
	button RebM "eb" pos:[131,62] width:14 height:14
	button RebOut "eb" pos:[156,66] width:14 height:14
	button RebAll "eb" pos:[126,48] width:24 height:14
	button Rf "F" pos:[156,46] width:12 height:12 enabled:true
	
	*/
	);
	
	rollout sj_srOthers_rol "Others"
	(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
		--////////////////////////////////////////////////
		--iniファイルを取得
		--////////////////////////////////////////////////		
		fn getIniOthers_Fn = (
			filterLastKeyWords = (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FilterLastKeyWords");
		);--fn end
		
		--////////////////////////////////////////////////
		--回収
		--////////////////////////////////////////////////
		fn getOthers_Fn = (
		--プログレスバー
		--sj_functions.sj_progressBar_Fn()
		suspendEditing();--サスペンドモード
		with redraw off
		(--再描画禁止
			
			case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
					local rol = sj_srOthers_rol;--ロールアウトを格納
					local numTails = 0, numPonyL = 0, numPonyR = 0, numProp = 0;
					local tempArray = #();
					otherName = #();
					allOthers = #();
				
					--コントローラーを代入
					bipNode = sj_selector_node.controller;
					--tempBipCnt = sj_selector_node.controller;
				
					numTails = bipNode.tailLinks;--しっぽを入れて
					--配列に確保
					for i =1 to numTails do (
						append allOthers (biped.getNode bipNode 10 link:i);
					);--for end
					
					numPonyL = bipNode.ponytail1Links;--左
					--配列に確保
					for i =1 to numPonyL do (
						append allOthers (biped.getNode bipNode 18 link:i);
					);--for end
					numPonyR = bipNode.ponytail2Links;--右
					--配列に確保
					for i =1 to numPonyR do (
						append allOthers (biped.getNode bipNode 19 link:i);
					);--for end
					
					--プロップはあるか
					if bipNode.prop1Exists do append allOthers (biped.getNode bipNode 20);
					if bipNode.prop2Exists do append allOthers (biped.getNode bipNode 21);
					if bipNode.prop3Exists do append allOthers (biped.getNode bipNode 22);
					
					
					--////////////////////////////////////////////////
					--bipコントローラー以外を回収
					--////////////////////////////////////////////////
	if (rol.nonBipChk.checked) do
	(
				--Local progCountAll = selObj.count;
				--Local progCount = 1;
	--変数を準備
	Local objectBranch = #(),--回収した子供
	checkObj = undefined;--チェックするオブジェクト
	checkChildren = #();--チェックするオブジェクトの配列
		
		--配列に格納
		--append allOthers sj_selector_node;
		--append objectBranch sj_selector_node;
		
		--子供の数を入れる
		numChild = sj_selector_node.children.count;
		--初期回収
		for i =1 to sj_selector_node.children.count do
		(
			--2つに回収
			append checkChildren sj_selector_node.children[i];
			
			--bipオブジェクトでなければ
			if ((classOf sj_selector_node.children[i]) != Biped_Object) and
			 ((classOf sj_selector_node.children[i]) != XrefObject) do --リファレンス対策リファレンスは回収しない
			(
				--print sj_selector_node.children[i];
				append objectBranch sj_selector_node.children[i];
			);--if end
			
			
			--リファレンスだがBipedではない
			try(
			if ((classOf (sj_selector_node.children[i].GetSourceObject true)) != Biped_Object) do--リファレンス対策
			(
				append objectBranch checkObj.children[i];
			);--if end
				)catch();--ひとまずこれでバグ回避
			
		);--for end
		
		--0になるまで繰り返す
		while numChild != 0 do
		(
			--deleteItem checkChildren 1;
			checkObj = checkChildren[numChild];
			
			--チェック用配列からのおしりから削除
			deleteItem checkChildren numChild;
			numChild -= 1;			
			
			--子はあるか？
			if (checkObj.children.count != 0) then
			(
				--print "有り";
				numChild += checkObj.children.count;--カウントアップ
				for i =1 to checkObj.children.count do
				(
					
					append checkChildren checkObj.children[i];
					
					--リファレンス外を回収
					if ((classOf checkObj.children[i]) != Biped_Object) and
						((classOf checkObj.children[i]) != XrefObject) do --リファレンス対策リファレンスは回収しない
					(
						append objectBranch checkObj.children[i];
					);--if end
					
					try(
					--リファレンスだがBipedではない
					if ((classOf (checkObj.children[i].GetSourceObject true)) != Biped_Object) do--リファレンス対策
					(
						append objectBranch checkObj.children[i];
					);--if end
					)catch();--ひとまずこれでバグ回避
					
				);--for end
			)else
			(
				--子が見つからなければ
				--print "無し"
			);--if end
			--checkObj += objRoot.children[numChild];
		);--while end
		--objectBranch
					--////////////////////////////////////////////////
					--名前で並び替え
					--////////////////////////////////////////////////
				Local myObj = #(), myObjAfter = #();
				Local selObjName = for i in objectBranch collect i.name;
				Local selObjIh = for i in objectBranch collect i.inode.handle;
				--ソート
				sort selObjName;
				for i in selObjName do
				(
					--その名前のオブジェクトを回収
					myObj = getNodeByName i all:true;
					--iハンドルで名前の重複を確認
					for k in myObj do
					(
					--見つかれば
					if (findItem selObjIh k.inode.handle) != 0 then append myObjAfter k;
					);--for end
				);--for end
				
				--ソート結果を入れる
				join allOthers myObjAfter;
		
		);--if end
	
					--名前を回収
					otherName = for i in allOthers collect i.name
					rol.otherLbx.items = otherName;
					
					tempArray = #();
					otherName = #();
					
				);--end
				
			);--case end
			
		);--with redraw end
		--try(destroydialog sj_progressBar_rol)catch();
		resumeEditing();--再びアクティブに
		
		);--fn end
		
		--////////////////////////////////////////////////
		--フィルタ
		--////////////////////////////////////////////////
		fn filterOthers_Fn filtTxt = (
			case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
					local rol = sj_srOthers_rol;--ロールアウトを格納
					local tempArray = #();
					otherName = #();
				
					--一端初期化
					filterOthers = #();
				
					if (filtTxt != "") then
					(
					for i in allOthers do
					(
						--検索結果が見つかれば
						if ((findString i.name filtTxt) != undefined) do append filterOthers i;
						--if (matchPattern i.name pattern:(filtTxt+"*")) do append filterOthers i;
					);--for end
					
					--名前を回収
					if (filterOthers.count == 0) then
					(
						--messageBox "対象がありません" title:"お知らせ"
						rol.otherLbx.items = #();
					)else(
						otherName = for i in filterOthers collect i.name
						rol.otherLbx.items = otherName;						
					);--end
					
					tempArray = #();
					otherName = #();
					
					)else(
					
					--空ならallを入れておく
					otherName = for i in allOthers collect i.name
					rol.otherLbx.items = otherName;
					
					--配列を入れておく
					filterOthers = allOthers;
					
					tempArray = #();
					otherName = #();
					
					);--if end
					
				);--end
			);--case end
		);--fn end
		
		--////////////////////////////////////////////////
		--レイアウト
		--////////////////////////////////////////////////
		checkbox filterChk "フィルタ" pos:[8,8] width:52 height:20
		edittext filterEdt "" pos:[60,8] width:88 height:16 enabled:false text:filterLastKeyWords;
		button filterBt "OK" pos:[152,6] width:20 height:20 enabled:false;
		checkbox nonBipChk "Biped以外も選択" pos:[8,30] width:120 height:20 checked:true;
		MultiListBox otherLbx "" pos:[8,50] width:164 height:18 --items:#("A","B","C","A","B","C","A","B","C","A","B","C","A","B","C","A","B","C","A","B","C")
		button otherAllSelBt "全選択" pos:[8,294] width:164 height:20;
		
		--////////////////////////////////////////////////
		--アクション
		--////////////////////////////////////////////////
		on otherAllSelBt pressed do
		(
			--アクターは有効か
			if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
			if filterChk.checked then
			(
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
					selectMore filterOthers;
					if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					undo on (
					deselect filterOthers;
					);--undo end
				)else	(
				--選択
					undo on (
					clearSelection()
					select filterOthers;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
			)else
			(
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
					selectMore allOthers;
					if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					undo on (
					deselect allOthers;
					);--undo end
				)else	(
				--選択
					undo on (
					clearSelection()
					select allOthers;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
			);--if end
			if (selFocus) do max zoomext sel;
			);--if end
		);--end
		
		on filterChk changed val do
		(
			--アクターは有効か
			if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
			local otherName = #();
			if val then (
				filterOthers_Fn filterEdt.text;
			)else(
				--空ならallを入れておく
				otherName = for i in allOthers collect i.name
				otherLbx.items = otherName;
			);
			filterEdt.enabled = val;
			filterBt.enabled = val;
			otherName = #();
		);--if end
		);--end
		
		on filterBt pressed do
		(
			if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do filterOthers_Fn filterEdt.text;
			
			--Iniファイルに書き込む
			(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "FilterLastKeyWords" filterEdt.text);
		);
			
		on nonBipChk changed val do
		(
		if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
			getOthers_Fn();
			--もしフィルタだったら
			local otherName = #();
			if filterChk.checked then (
				filterOthers_Fn filterEdt.text;
			)else(
				--空ならallを入れておく
				otherName = for i in allOthers collect i.name
				otherLbx.items = otherName;
			);
			otherName = #();
		);--if end
		);--end
		
		on otherLbx selectionEnd do
		(
		if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
			local tempArray = #();
			if filterChk.checked then
			(
				--フィルタなら
				tempArray = for i in otherLbx.selection collect filterOthers[i];
			)else
			(
				--フィルタでないなら
				tempArray = for i in otherLbx.selection collect allOthers[i];
			);--if end
			
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
						selectMore tempArray;
						if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除だけどマルチリストなので
					undo on (select tempArray);--undo end
				)else if keyboard.altPressed then(
				--ツリー選択
					undo on (selectMore (sj_functions.sj_selectBranch_Fn tempArray[1] 1));--undo end
				)else	(
				--選択
					undo on (
					clearSelection()
					select tempArray;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
				
			tempArray = #();
		);
		);--end
		
		--for i in sj_srOthers_rol.filterBipLbx.selection do print iで呼び出し
		--ウィンドウが開いたら
		on sj_srOthers_rol open do
		(
			getOthers_Fn();
			
			--フィルターに文字を入れておく
			getIniOthers_Fn();
			filterEdt.text = filterLastKeyWords;
			
		);--end
		
			on sj_srOthers_rol rolledUp state do
			(
				--閉じた場合はfalse開いた場合はtrue
				if state then
				(
				--iniに情報を書き込む
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "OtherRol" "false");
				)else
				(
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "OtherRol" "true");
				);--if end
			);--end

		
	);
	
	rollout sj_srKeying_rol "Keying" 
	(
	);
	
	rollout sj_bodyRigSel_rol "Body"
	(
-----------------------------------------------------------------------------------------------------------
-- ファンクションここまで
-----------------------------------------------------------------------------------------------------------
		--////////////////////////////////////////////////
		--UI設定
		--////////////////////////////////////////////////
		fn uiBodySet_Fn = (
			--local tempBipObj = undefined;
			local tempBipCnt = undefined;
			local tempNum = 0;
			local rol = sj_bodyRigSel_rol;--ロールアウトを格納
			local pBm = (bitmap 1 1 color:red);
			
			case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
					--////////////////////////////////////////////////
					--有効と無効
					--////////////////////////////////////////////////
					--位置が確定して
					--rol.allRootBt.enabled = false;
					--rol.allTMBt.enabled = false;
				
					--配列に背骨と首の骨を格納
					local spineBt = #(rol.spine01It,rol.spine02It,rol.spine03It,rol.spine04It,rol.spine05It,rol.spine06It,rol.spine07It,rol.spine08It,rol.spine09It,rol.spine10It);
					local neckBt = #(rol.neck01It,rol.neck02It,rol.neck03It,rol.neck04It,rol.neck05It,rol.neck06It,rol.neck07It,rol.neck08It,rol.neck09It,rol.neck10It,rol.neck11It,rol.neck12It,rol.neck13It,rol.neck14It,rol.neck15It,rol.neck16It,rol.neck17It,rol.neck18It,rol.neck19It,rol.neck20It,rol.neck21It,rol.neck22It,rol.neck23It,rol.neck24It,rol.neck25It);
					--local spineBm = #(rol.spine01Bm,rol.spine02Bm,rol.spine03Bm,rol.spine04Bm,rol.spine05Bm,rol.spine06Bm,rol.spine07Bm,rol.spine08Bm,rol.spine09Bm,rol.spine10Bm);
					--local neckBm = #(rol.neck01Bm,rol.neck02Bm,rol.neck03Bm,rol.neck04Bm,rol.neck05Bm,rol.neck06Bm,rol.neck07Bm,rol.neck08Bm,rol.neck09Bm,rol.neck10Bm,rol.neck11Bm,rol.neck12Bm,rol.neck13Bm,rol.neck14Bm,rol.neck15Bm,rol.neck16Bm,rol.neck17Bm,rol.neck18Bm,rol.neck19Bm,rol.neck20Bm,rol.neck21Bm,rol.neck22Bm,rol.neck23Bm,rol.neck24Bm,rol.neck25Bm);
					--////////////////////////////////////////////////
					--位置とサイズ
					--////////////////////////////////////////////////
				
					uiBtFlipPos = if uiBtFlip then (#(36,24,116,124,44,36,24,-100,8,116,124,128,-100,164))else(#(116,124,36,24,116,124,128,-100,164,44,36,24,-100,8));
				
					--位置を反転するか
					if uiBtFlip then
					(
						rol.LClavicleIt.pos = [uiBtFlipPos[1],48];
						rol.LUpperIt.pos = [uiBtFlipPos[1],76];
						rol.LFormIt.pos = [uiBtFlipPos[1],122];
						rol.LHandIt.pos = [uiBtFlipPos[2],168];
						rol.RClavicleIt.pos = [uiBtFlipPos[3],48];
						rol.RUpperIt.pos = [uiBtFlipPos[4],76];
						rol.RFormIt.pos = [uiBtFlipPos[4],122];
						rol.RHandIt.pos = [uiBtFlipPos[4],168];
						--#(36,24,116,124,44,36,24,-100,8,116,124,128,-100,164)
						rol.LThighIt.pos = [uiBtFlipPos[5],284];
						rol.LCalfIt.pos = [uiBtFlipPos[6],340];
						rol.LFootIt.pos = [uiBtFlipPos[7],404];
						rol.LHorseIt.pos = [uiBtFlipPos[8],-100];
						rol.LToeIt.pos = [uiBtFlipPos[9],410];
						
						rol.RThighIt.pos = [uiBtFlipPos[10],284];
						rol.RCalfIt.pos = [uiBtFlipPos[11],340];
						rol.RFootIt.pos = [uiBtFlipPos[12],404];
						rol.RHorseIt.pos = [uiBtFlipPos[13],-100];
						rol.RToeIt.pos = [uiBtFlipPos[14],410];
					)else
					(
						rol.LClavicleIt.pos = [uiBtFlipPos[1],48];
						rol.LUpperIt.pos = [uiBtFlipPos[2],76];
						rol.LFormIt.pos = [uiBtFlipPos[2],122];
						rol.LHandIt.pos = [uiBtFlipPos[2],168];
						rol.RClavicleIt.pos = [uiBtFlipPos[3],48];
						rol.RUpperIt.pos = [uiBtFlipPos[3],76];
						rol.RFormIt.pos = [uiBtFlipPos[3],122];
						rol.RHandIt.pos = [uiBtFlipPos[4],168];
						--#(36,24,116,124,44,36,24,-100,8,116,124,128,-100,164)
						rol.LThighIt.pos = [uiBtFlipPos[5],284];
						rol.LCalfIt.pos = [uiBtFlipPos[6],340];
						rol.LFootIt.pos = [uiBtFlipPos[7],404];
						rol.LHorseIt.pos = [uiBtFlipPos[8],-100];
						rol.LToeIt.pos = [uiBtFlipPos[9],410];
						
						rol.RThighIt.pos = [uiBtFlipPos[10],284];
						rol.RCalfIt.pos = [uiBtFlipPos[11],340];
						rol.RFootIt.pos = [uiBtFlipPos[12],404];
						rol.RHorseIt.pos = [uiBtFlipPos[13],-100];
						rol.RToeIt.pos = [uiBtFlipPos[14],410];
					);--end
					
					--まずは脚から
					--コントローラーを代入
					tempBipCnt = sj_selector_node.controller;
					--数を調べる
					if (tempBipCnt.legLinks > 3) then
					(
						--4本以上だったら
						--ボタンの高さ位置を変更
						rol.LThighIt.height = rol.RThighIt.height = rol.LCalfIt.height = rol.RCalfIt.height = 36;
						rol.LCalfIt.pos = (rol.LCalfIt.pos - [0,16]);
						rol.RCalfIt.pos = (rol.RCalfIt.pos - [0,16]);
						--位置を反転するか
						if uiBtFlip then
						(						
						rol.LHorseIt.pos = rol.LCalfIt.pos + [-4,40];
						rol.RHorseIt.pos = rol.RCalfIt.pos + [4,40];
						)else(
						rol.LHorseIt.pos = rol.LCalfIt.pos + [4,40];
						rol.RHorseIt.pos = rol.RCalfIt.pos + [-4,40];
						);--if end
						
					)else(
						--3本だったら
						
					);--if end
					
					--区画は48～250 202 -8 -4 =190 [70,250] [74,000]
					--最後-8
					--Space-4 spine10Itneck01It h=5:	4
					
					--背骨と首の合計数
					spineNum = tempBipCnt.spineLinks;
					neckNum = tempBipCnt.neckLinks;
					allNum = spineNum + neckNum;
					tempHS = (180 / allNum) ;--ボタンの高さを設定
					tempHN = (180 / allNum) - 2;--ボタンの高さを設定
					
					--背骨
					--print tempHS
					--print tempHN
					--配列おしりからボタンを画面外に排除
					i = 10;
					--背骨の数より小さくなるまで
					while i > spineNum do
					(
						--print spineBt[i].name;
						spineBt[i].pos = [-100,-100];
						i -= 1;
					);--while end

					--背骨の数だけ
					for i = 1 to spineNum do
					(
						spineBt[i].height = tempHS;
						spineBt[i].pos = [70,258-((tempHS+2)*i)];
					);--for end
					
					rol.spaceIt.pos = spineBt[spineNum].pos + [-6,-3]

					--配列おしりからボタンを画面外に排除
					i = 25;
					while i > neckNum do
					(
						--print neckBt[i].name;
						neckBt[i].pos = [-100,-100];
						i -= 1;
					);--while end
					
					--背骨の数だけ
					for i = 1 to neckNum do
					(
						neckBt[i].height = tempHS-1;
						neckBt[i].pos = spineBt[spineNum].pos + [4,-4-((tempHN+3)*i)];
					);--for end
					
					--32以内で頭ボタンの位置などを調整
					if ( tempHS < 32) then
					(
						rol.headIt.height = tempHS+16;
						rol.headIt.pos = neckBt[neckNum].pos + [-2,-(tempHS+16+4)];
					)else(
						rol.headIt.height = 32;
						rol.headIt.pos = neckBt[neckNum].pos + [-2,-(32+4)];
					);--if end
					
					--////////////////////////////////////////////////
					--色
					--////////////////////////////////////////////////
					rol.rootNodeIt.bitmap = rol.rootNodeBm = (bitmap 1 1 color:sj_selector_node.wirecolor);
					rol.hipIt.bitmap = rol.hipBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 12).wirecolor);
					rol.headIt.bitmap = rol.headBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 11).wirecolor);
					
					rol.LClavicleIt.bitmap = rol.LClavicleBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 1 link:1).wirecolor);
					rol.LUpperIt.bitmap = rol.LUpperBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 1 link:2).wirecolor);
					rol.LFormIt.bitmap = rol.LFormBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 1 link:3).wirecolor);
					rol.LHandIt.bitmap = rol.LHandBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 1 link:4).wirecolor);
					
					rol.RClavicleIt.bitmap = rol.RClavicleBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 2 link:1).wirecolor);
					rol.RUpperIt.bitmap = rol.RUpperBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 2 link:2).wirecolor);
					rol.RFormIt.bitmap = rol.RFormBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 2 link:3).wirecolor);
					rol.RHandIt.bitmap = rol.RHandBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 2 link:4).wirecolor);
					
					rol.LThighIt.bitmap = rol.LThighBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 5 link:1).wirecolor);
					rol.LCalfIt.bitmap = rol.LCalfBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 5 link:2).wirecolor);
					rol.RThighIt.bitmap = rol.RThighBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 6 link:1).wirecolor);
					rol.RCalfIt.bitmap = rol.RCalfBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 6 link:2).wirecolor);
					rol.LToeIt.bitmap = rol.LToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 7 link:1).wirecolor);
					rol.RToeIt.bitmap = rol.RToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 8 link:1).wirecolor);
					
					if (tempBipCnt.legLinks > 3) then
					(
						rol.LFootIt.bitmap = rol.LFootBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 5 link:4).wirecolor);
						rol.LHorseIt.bitmap = rol.LHorseBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 5 link:3).wirecolor);					
						rol.RFootIt.bitmap = rol.RFootBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 6 link:4).wirecolor);
						rol.RHorseIt.bitmap = rol.RHorseBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 6 link:3).wirecolor);
						rol.LToeIt.bitmap = rol.LToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 7 link:1).wirecolor);
						rol.RToeIt.bitmap = rol.RToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 8 link:1).wirecolor);
					)else
					(
						rol.LFootIt.bitmap = rol.LFootBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 5 link:3).wirecolor);
						rol.RFootIt.bitmap = rol.RFootBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 6 link:3).wirecolor);
						rol.LToeIt.bitmap = rol.LToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 7 link:1).wirecolor);
						rol.RToeIt.bitmap = rol.RToeBm = (bitmap 1 1 color:(biped.getNode tempBipCnt 8 link:1).wirecolor);
						/*
							Local RToeBm = (bitmap 1 1 color:(color 113 134 6))
	imgTag RToeIt "test" pos:[164,410] width:12 height:16 style:#bmp_tile bitmap:RToeBm;
						*/
					);--if end
					

					for i = 1 to spineNum do
					(
						spineBt[i].bitmap = (bitmap 1 1 color:(biped.getNode tempBipCnt 9 link:i).wirecolor);
						--spineBt[i].bitmap = spineBm[i] = (bitmap 1 1 color:(biped.getNode tempBipCnt 9 link:i).wirecolor);
					);--for end

					for i = 1 to neckNum do
					(
						neckBt[i].bitmap = (bitmap 1 1 color:(biped.getNode tempBipCnt 17 link:i).wirecolor);
						--neckBt[i].bitmap = neckBm[i] = (bitmap 1 1 color:(biped.getNode tempBipCnt 17 link:i).wirecolor);
					);--for end
					
					--ビットマップを設定しておく
	if (bipNode.spineLinks >= 1) do rol.spine01Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:1).wirecolor);
	if (bipNode.spineLinks >= 2) do rol.spine02Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:2).wirecolor);
	if (bipNode.spineLinks >= 3) do rol.spine03Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:3).wirecolor);
	if (bipNode.spineLinks >= 4) do rol.spine04Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:4).wirecolor);
	if (bipNode.spineLinks >= 5) do rol.spine05Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:5).wirecolor);
	if (bipNode.spineLinks >= 6) do rol.spine06Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:6).wirecolor);
	if (bipNode.spineLinks >= 7) do rol.spine07Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:7).wirecolor);
	if (bipNode.spineLinks >= 8) do rol.spine08Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:8).wirecolor);
	if (bipNode.spineLinks >= 9) do rol.spine09Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:9).wirecolor);
	if (bipNode.spineLinks >= 10) do rol.spine10Bm = (bitmap 1 1 color:(biped.getNode bipNode 9 link:10).wirecolor);
	if (bipNode.neckLinks >= 1) do neckBt[1].bitmap = rol.neck01Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:1).wirecolor);
	if (bipNode.neckLinks >= 2) do neckBt[2].bitmap = rol.neck02Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:2).wirecolor);
	if (bipNode.neckLinks >= 3) do neckBt[3].bitmap = rol.neck03Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:3).wirecolor);
	if (bipNode.neckLinks >= 4) do neckBt[4].bitmap = rol.neck04Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:4).wirecolor);
	if (bipNode.neckLinks >= 5) do neckBt[5].bitmap = rol.neck05Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:5).wirecolor);
	if (bipNode.neckLinks >= 6) do neckBt[6].bitmap = rol.neck06Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:6).wirecolor);
	if (bipNode.neckLinks >= 7) do neckBt[7].bitmap = rol.neck07Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:7).wirecolor);
	if (bipNode.neckLinks >= 8) do neckBt[8].bitmap = rol.neck08Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:8).wirecolor);
	if (bipNode.neckLinks >= 9) do neckBt[9].bitmap = rol.neck09Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:9).wirecolor);
	if (bipNode.neckLinks >= 10) do neckBt[10].bitmap = rol.neck10Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:10).wirecolor);
	if (bipNode.neckLinks >= 11) do neckBt[11].bitmap = rol.neck11Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:11).wirecolor);
	if (bipNode.neckLinks >= 12) do neckBt[12].bitmap = rol.neck12Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:12).wirecolor);
	if (bipNode.neckLinks >= 13) do neckBt[13].bitmap = rol.neck13Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:13).wirecolor);
	if (bipNode.neckLinks >= 14) do neckBt[14].bitmap = rol.neck14Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:14).wirecolor);
	if (bipNode.neckLinks >= 15) do neckBt[15].bitmap = rol.neck15Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:15).wirecolor);
	if (bipNode.neckLinks >= 16) do neckBt[16].bitmap = rol.neck16Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:16).wirecolor);
	if (bipNode.neckLinks >= 17) do neckBt[17].bitmap = rol.neck17Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:17).wirecolor);
	if (bipNode.neckLinks >= 18) do neckBt[18].bitmap = rol.neck18Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:18).wirecolor);
	if (bipNode.neckLinks >= 19) do neckBt[19].bitmap = rol.neck19Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:19).wirecolor);
	if (bipNode.neckLinks >= 20) do neckBt[20].bitmap = rol.neck20Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:20).wirecolor);
	if (bipNode.neckLinks >= 21) do neckBt[21].bitmap = rol.neck21Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:21).wirecolor);
	if (bipNode.neckLinks >= 22) do neckBt[22].bitmap = rol.neck22Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:22).wirecolor);
	if (bipNode.neckLinks >= 23) do neckBt[23].bitmap = rol.neck23Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:23).wirecolor);
	if (bipNode.neckLinks >= 24) do neckBt[24].bitmap = rol.neck24Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:24).wirecolor);
	if (bipNode.neckLinks >= 25) do neckBt[25].bitmap = rol.neck25Bm = (bitmap 1 1 color:(biped.getNode bipNode 17 link:25).wirecolor);
					--spineBt = #(); 
					--neckBt = #();
					--spineBm = #();
					--neckBm = #();
					gc();
		);         
	);--case end

		);--end fn
		--////////////////////////////////////////////////
		--全てのコントローラーを回収
		--////////////////////////////////////////////////
		fn getAllControllers_Fn = (
			--初期化
			allController = #();
			--bipNode = undefined;
			case actorType of (
			--beyondなら
			1:(

			);
			--bipedなら
			2:(
				bipNode = sj_selector_node.controller;
				--print bipNode.rootNode
				
				if (allController.count == 0) do
				(
				--ノード
					append allController bipNode.rootNode;
					append allController (biped.getNode bipNode 12);
					
					--背骨回収
					for i=1 to (bipNode.spineLinks) do
					(
					append allController (biped.getNode bipNode 9 link:i);
					);--for end
					--Nec
					for i=1 to (bipNode.neckLinks) do
					(
					append allController (biped.getNode bipNode 17 link:i);
					);--for end
					
					--頭
					append allController (biped.getNode bipNode 11);
					--腕回収
					for i=1 to 4 do
					(
					append allController (biped.getNode bipNode 1 link:i);
					);--for end
					for i=1 to 4 do
					(
					append allController (biped.getNode bipNode 2 link:i);
					);--for end
					--脚
					for i=1 to (bipNode.legLinks) do
					(
					append allController (biped.getNode bipNode 5 link:i);
					);--for end					
					for i=1 to (bipNode.legLinks) do
					(
					append allController (biped.getNode bipNode 6 link:i);
					);--for end
					
					--指
					join allController L0fingerNodes; join allController L1fingerNodes; 
					join allController L2fingerNodes; join allController L3fingerNodes; 
					join allController L4fingerNodes;
					join allController R0fingerNodes; join allController R1fingerNodes;
					join allController R2fingerNodes; join allController R3fingerNodes;
					join allController R4fingerNodes;
					
					join allController L0toeNodes; join allController L1toeNodes; 
					join allController L2toeNodes; join allController L3toeNodes; 
					join allController L4toeNodes;
					join allController R0toeNodes; join allController R1toeNodes;
					join allController R2toeNodes; join allController R3toeNodes;
					join allController R4toeNodes;
					
				);--if end
				);--2end
			);--case end
			
		);--end fn
		--////////////////////////////////////////////////
		--各部選択　引数は bipリム リンクがあるか? リンク
		--SJの場合は0を指定、リンクが無い場合も0を指定
		--////////////////////////////////////////////////		
		fn selControllers_Fn limNum flag linkNum = (
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
					if flag then selectMore (biped.getNode bipNode limNum link:linkNum) else selectMore (biped.getNode bipNode limNum);
					if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					undo on (
					if flag then deselect (biped.getNode bipNode limNum link:linkNum) else deselect (biped.getNode bipNode limNum);
					);--undo end
				)else if keyboard.altPressed then(
				--ツリー選択
					undo on (
						if flag then
						(
							selectMore (sj_functions.sj_selectBranch_Fn (biped.getNode bipNode limNum link:linkNum) 1);
						) else (
							selectMore (sj_functions.sj_selectBranch_Fn (biped.getNode bipNode limNum) 1);
						);--if end
					);
				)else	(
				--選択
					undo on (
					clearSelection()
					if flag then select (biped.getNode bipNode limNum link:linkNum) else  select (biped.getNode bipNode limNum);
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
				
				);--2end
				);--case end
		);--fn end
		--////////////////////////////////////////////////
		--セットキー
		--タイプは 1:通常 2:スライド 3:ペアレント4:フリーキー
		--////////////////////////////////////////////////				
		fn setKey_Fn type = (
		case actorType of (
		--beyondなら
		1:(
		);
		--bipedなら
		2:(
			case type of
			(
				--オブジェクトを確保する
				--local tempObj = undefined;
				
				1:(
					undo on (
					for i in selection do 
					(
						--リファレンスなのか？
						if ((classOf i) == XRefObject) then
						(
							if ((classOf (i.GetSourceObject true)) == Biped_Object) then--リファレンス対策
							(biped.setKey i true true true)else(
							--bip以外の場合
							max set key keys;
								--print "Biped以外"
							);--if end
								
						)else(
						--リファレンス以外であれば
							if ((classOf i) == Biped_Object) then
							(biped.setKey i true true true)else(
							--bip以外の場合
							max set key keys;
							);--if end
						);--if end
						
					);--for end
					);--undo end
				);
				2:(
				--スライド
					undo on (
					for i in selection do
					(
						--リファレンスなのか？
						if ((classOf i) == XRefObject) then
						(
							if ((classOf (i.GetSourceObject true)) == Biped_Object) then--リファレンス対策
							(biped.setSlidingKey i)else(
							--bip以外の場合
							max set key keys;
							);--if end
						)else(
						--リファレンス以外であれば
						
							if ((classOf i) == Biped_Object) then
							(biped.setSlidingKey i)else(
							--bip以外の場合
							max set key keys;
							);--if end
						);--if end

					);--for end
					);--undo end
				);
				3:(
				--ペアレント
					undo on (
					for i in selection do
					(
						--リファレンスなのか？
						if ((classOf i) == XRefObject) then
						(
							if ((classOf (i.GetSourceObject true)) == Biped_Object) then--リファレンス対策
							(biped.setPlantedKey i)else(
							--bip以外の場合
							max set key keys
							);--if end
								
						)else(
						--リファレンス以外であれば
							if ((classOf i) == Biped_Object) then
							(biped.setPlantedKey i)else(
							--bip以外の場合
							max set key keys
							);--if end
						);--if end
						
					);--for end
					);--undo end
				);
				4:(
				--フリー
					undo on (
					for i in selection do
					(
						--リファレンスなのか？
						if ((classOf i) == XRefObject) then
						(
							if ((classOf (i.GetSourceObject true)) == Biped_Object) then--リファレンス対策
							(biped.setFreeKey i)else(
							--bip以外の場合
							max set key keys
							);--if end
								
						)else(
						--リファレンス以外であれば
							if ((classOf i) == Biped_Object) then
							(biped.setFreeKey i)else(
							--bip以外の場合
							max set key keys
							);--if end
						);--if end
						
					);--for end
					);--undo end
				);
			);--case end
		);--2end
		);--case end
			--biped.setSlidingKey selection;
			--biped.setPlantedKey selection; 
			--biped.resetAllLimbKeys selection[1];
			--biped.collapseMoveAllMode selection[1];
			--print "a"
		);--fn end
		--////////////////////////////////////////////////
		--逆を選択、指も含む
		--
		--////////////////////////////////////////////////	
		fn flipSelection_Fn =(
				case actorType of (
				--beyondなら
				1:(
				);
				2:(
					local tempArray = #();--逆側を確保
					bipNode = sj_selector_node.controller;
					--左腕
					if (biped.getNode bipNode 1 link:1).isSelected do append tempArray (biped.getNode bipNode 2 link:1);
					if (biped.getNode bipNode 1 link:2).isSelected do append tempArray (biped.getNode bipNode 2 link:2);
					if (biped.getNode bipNode 1 link:3).isSelected do append tempArray (biped.getNode bipNode 2 link:3);
					if (biped.getNode bipNode 1 link:4).isSelected do append tempArray (biped.getNode bipNode 2 link:4);
					--右腕
					if (biped.getNode bipNode 2 link:1).isSelected do append tempArray (biped.getNode bipNode 1 link:1);
					if (biped.getNode bipNode 2 link:2).isSelected do append tempArray (biped.getNode bipNode 1 link:2);
					if (biped.getNode bipNode 2 link:3).isSelected do append tempArray (biped.getNode bipNode 1 link:3);
					if (biped.getNode bipNode 2 link:4).isSelected do append tempArray (biped.getNode bipNode 1 link:4);
					--左脚
					if (biped.getNode bipNode 5 link:1).isSelected do append tempArray (biped.getNode bipNode 6 link:1);
					if (biped.getNode bipNode 5 link:2).isSelected do append tempArray (biped.getNode bipNode 6 link:2);
					if (biped.getNode bipNode 5 link:3).isSelected do append tempArray (biped.getNode bipNode 6 link:3);
					--右脚
					if (biped.getNode bipNode 6 link:1).isSelected do append tempArray (biped.getNode bipNode 5 link:1);
					if (biped.getNode bipNode 6 link:2).isSelected do append tempArray (biped.getNode bipNode 5 link:2);
					if (biped.getNode bipNode 6 link:3).isSelected do append tempArray (biped.getNode bipNode 5 link:3);
						--脚対策
						if (bipNode.legLinks > 3) then
						(
							--4本以上だったら
							if (biped.getNode bipNode 5 link:4).isSelected do append tempArray (biped.getNode bipNode 6 link:4);
							if (biped.getNode bipNode 6 link:4).isSelected do append tempArray (biped.getNode bipNode 5 link:4);
						);--if end
					if (biped.getNode bipNode 1 link:1).isSelected do append tempArray (biped.getNode bipNode 2 link:1);
					if (biped.getNode bipNode 1 link:2).isSelected do append tempArray (biped.getNode bipNode 2 link:2);
					if (biped.getNode bipNode 1 link:3).isSelected do append tempArray (biped.getNode bipNode 2 link:3);
					if (biped.getNode bipNode 1 link:4).isSelected do append tempArray (biped.getNode bipNode 2 link:4);
					
					--指
					for i = 1 to L0fingerNodes.count do (if L0fingerNodes[i].isSelected do append tempArray R0fingerNodes[i]);--for end
					for i = 1 to L1fingerNodes.count do (if L1fingerNodes[i].isSelected do append tempArray R1fingerNodes[i]);--for end
					for i = 1 to L2fingerNodes.count do (if L2fingerNodes[i].isSelected do append tempArray R2fingerNodes[i]);--for end
					for i = 1 to L3fingerNodes.count do (if L3fingerNodes[i].isSelected do append tempArray R3fingerNodes[i]);--for end
					for i = 1 to L4fingerNodes.count do (if L4fingerNodes[i].isSelected do append tempArray R4fingerNodes[i]);--for end
					for i = 1 to R0fingerNodes.count do (if R0fingerNodes[i].isSelected do append tempArray L0fingerNodes[i]);--for end
					for i = 1 to R1fingerNodes.count do (if R1fingerNodes[i].isSelected do append tempArray L1fingerNodes[i]);--for end
					for i = 1 to R2fingerNodes.count do (if R2fingerNodes[i].isSelected do append tempArray L2fingerNodes[i]);--for end
					for i = 1 to R3fingerNodes.count do (if R3fingerNodes[i].isSelected do append tempArray L3fingerNodes[i]);--for end
					for i = 1 to R4fingerNodes.count do (if R4fingerNodes[i].isSelected do append tempArray L4fingerNodes[i]);--for end
					for i = 1 to L0toeNodes.count do (if L0toeNodes[i].isSelected do append tempArray R0toeNodes[i]);--for end
					for i = 1 to L1toeNodes.count do (if L1toeNodes[i].isSelected do append tempArray R1toeNodes[i]);--for end
					for i = 1 to L2toeNodes.count do (if L2toeNodes[i].isSelected do append tempArray R2toeNodes[i]);--for end
					for i = 1 to L3toeNodes.count do (if L3toeNodes[i].isSelected do append tempArray R3toeNodes[i]);--for end
					for i = 1 to L4toeNodes.count do (if L4toeNodes[i].isSelected do append tempArray R4toeNodes[i]);--for end
					for i = 1 to R0toeNodes.count do (if R0toeNodes[i].isSelected do append tempArray L0toeNodes[i]);--for end
					for i = 1 to R1toeNodes.count do (if R1toeNodes[i].isSelected do append tempArray L1toeNodes[i]);--for end
					for i = 1 to R2toeNodes.count do (if R2toeNodes[i].isSelected do append tempArray L2toeNodes[i]);--for end
					for i = 1 to R3toeNodes.count do (if R3toeNodes[i].isSelected do append tempArray L3toeNodes[i]);--for end
					for i = 1 to R4toeNodes.count do (if R4toeNodes[i].isSelected do append tempArray L4toeNodes[i]);--for end
				
				--選択作業
				if keyboard.shiftPressed then
				(
				--追加選択
					undo on (
						selectMore tempArray
						if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
				--選択解除
					--undo on ( deselect tempArray);--undo end
				)else	(
				--選択
					undo on (
					clearSelection();
					select tempArray;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
					tempArray = #();
				);
			);--case end
		
		);--fn end
-----------------------------------------------------------------------------------------------------------
-- ファンクションここまで
-----------------------------------------------------------------------------------------------------------
	
	--////////////////////////////////////////////////
	--レイアウト
	--////////////////////////////////////////////////
	--Local cBm= (bitmap 100 100 color:(color 101 101 101));--クリックしたとき
	Local cBm= (bitmap 100 100 color:red);--クリックしたとき
	--Local c2Bm= (bitmap 100 100 color:(color 0 0 0));--クリックしたとき
	Local defaultBm = (bitmap 1 1 color:(color 8 110 134));
	Local dBm= (bitmap 1 1 color:(color 125 125 125));--無効のとき
		
	--GroupBox selectorGrp "RigName" pos:[4,4] width:180 height:432

	--位置が確定しているもののボタン
	--button allSelBt "全選択" pos:[4,8] width:52 height:26 images:#(cBm,c2Bm, 1, 1, 2, 2, 2) enabled:true;
	button allSelBt "全選択" pos:[4,8] width:52 height:26 enabled:true;
	button allMoveBt "全動" pos:[128,8] width:52 height:26
	--button selReverseBt "選択反転" pos:[4,200] width:52 height:20
	button selFlipBt "逆選択" pos:[4,210] width:52 height:20
	--checkbox selFocusChk "フォーカス" pos:[124,200] width:84 height:20
	checkbox selFocusChk "ズーム" pos:[4,230] width:64 height:20
		
	button selNecAllBt "全首" pos:[128,210] width:52 height:20;
	button selSpineAllBt "全背骨" pos:[128,230] width:52 height:20;
		
	--button allRootBt "AllRoot" pos:[68,372] width:48 height:26
	--button allTMBt "AllTM" pos:[68,404] width:48 height:26
		
	imgTag keyingIt "" pos:[4,484] width:178 height:48 enabled:false style:#bmp_tile bitmap:(bitmap 1 1 color:(color ((GetUIColor 12)[1]*255+1) ((GetUIColor 12)[2]*255+1) ((GetUIColor 12)[3]*255+1)));--色はUIから取得
	--imgTag keyingIt "" pos:[4,484] width:178 height:48 enabled:false style:#bmp_tile bitmap:(bitmap 1 1 color:(color (GetUIColor 12)[1] (GetUIColor 12)[2] (GetUIColor 12)[3]));--色はUIから取得
	
	GroupBox keyGrp "" pos:[4,478] width:178 height:56;
	button keyaBt "aK" pos:[9,498] width:40 height:24 images:#("$Scripts/SJTools/Images//SJ_button_keys.png", "$Scripts/SJTools/Images//SJ_button_keys_a.png", 4, 1, 1, 1, 1) toolTip:"キーを設定";
	button keycBt "cK" pos:[52,498] width:40 height:24 images:#("$Scripts/SJTools/Images//SJ_button_keys.png", "$Scripts/SJTools/Images//SJ_button_keys_a.png", 4, 2, 2, 2, 2) toolTip:"接地キーを設定";
	button keybBt "bK" pos:[95,498] width:40 height:24 images:#("$Scripts/SJTools/Images//SJ_button_keys.png", "$Scripts/SJTools/Images//SJ_button_keys_a.png", 4, 3, 3, 3, 3) toolTip:"スライドキーを設定";
	button keydBt "dK" pos:[138,498] width:40 height:24 images:#("$Scripts/SJTools/Images//SJ_button_keys.png", "$Scripts/SJTools/Images//SJ_button_keys_a.png", 4, 4, 4, 4, 4) toolTip:"フリーキーを設定";
	checkbox uiBtFlipChk "ボタン配置を左右反転" pos:[29,432] width:176 height:16 enabled:true checked:uiBtFlip;
		--label hint1Lbl "shiftで追加選択 ctrlで選択解除" pos:[15,432] width:176 height:16;
	label hint1Lbl "Shift 追加選択    Ctrl 選択解除" pos:[16,452] width:176 height:14;
	label hint2Lbl "Alt ツリーを選択" pos:[16,468] width:176 height:14;
	--label hint3Lbl "Alt --- ツリーを選択" pos:[15,512] width:176 height:14;

	--ノードこしまわり
	Local rootNodeBm = (bitmap 1 1 color:(color 166 202 240))
	imgTag rootNodeIt "test" pos:[56,260] width:72 height:22 style:#bmp_tile bitmap:rootNodeBm;
	Local hipBm = (bitmap 1 1 color:(color 224 198 87))
	imgTag hipIt "test" pos:[72,284] width:40 height:24 style:#bmp_tile bitmap:hipBm;
		
	--頭
	Local headBm = (bitmap 1 1 color:(color 166 202 240))
	imgTag headIt "test" pos:[72,8] width:40 height:24 style:#bmp_tile bitmap:headBm;
	
	--左右の腕
	Local LClavicleBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LClavicleIt "test" pos:[36,48] width:32 height:24 style:#bmp_tile bitmap:LClavicleBm;
	Local LUpperBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LUpperIt "test" pos:[36,76] width:24 height:42 style:#bmp_tile bitmap:LUpperBm;
	Local LFormBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LFormIt "test" pos:[36,122] width:24 height:42 style:#bmp_tile bitmap:LFormBm;
	Local LHandBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LHandIt "test" pos:[24,168] width:36 height:24 style:#bmp_tile bitmap:LHandBm;
	--Local LElbowBm = (bitmap 1 1 color:(color 125 125 125))
	--imgTag LElbowIt "test" pos:[12,120] width:20 height:20 style:#bmp_tile bitmap:LElbowBm enabled:true;

	Local RClavicleBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RClavicleIt "test" pos:[116,48] width:32 height:24 style:#bmp_tile bitmap:RClavicleBm;
	Local RUpperBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RUpperIt "test" pos:[124,76] width:24 height:42 style:#bmp_tile bitmap:RUpperBm;
	Local RFormBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RFormIt "test" pos:[124,122] width:24 height:42 style:#bmp_tile bitmap:RFormBm;
	Local RHandBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RHandIt "test" pos:[124,168] width:36 height:24 style:#bmp_tile bitmap:RHandBm;
	--Local RElbowBm = (bitmap 1 1 color:(color 125 125 125))
	--imgTag RElbowIt "test" pos:[152,120] width:20 height:20 style:#bmp_tile bitmap:RElbowBm enabled:true;

	--左右の脚
	Local LThighBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LThighIt "test" pos:[44,284] width:24 height:52 style:#bmp_tile bitmap:undefined;
	Local LCalfBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LCalfIt "test" pos:[36,340] width:24 height:60 style:#bmp_tile bitmap:LCalfBm;
	Local LFootBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LFootIt "test" pos:[24,404] width:32 height:24 style:#bmp_tile bitmap:LFootBm;
	Local LHorseBm = (bitmap 1 1 color:(color 28 28 177))
	imgTag LHorseIt "test" pos:[-100,-100] width:24 height:36 style:#bmp_tile bitmap:LHorseBm;
	Local LToeBm = (bitmap 1 1 color:(color 108 8 136))
	imgTag LToeIt "test" pos:[8,410] width:12 height:16 style:#bmp_tile bitmap:LToeBm;
	--Local LKneeBm = (bitmap 1 1 color:(color 125 125 125))
	--imgTag LKneeIt "test" pos:[12,324] width:20 height:20 style:#bmp_tile bitmap:LKneeBm enabled:true;

	Local RThighBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RThighIt "test" pos:[116,284] width:24 height:52 style:#bmp_tile bitmap:RThighBm;
	Local RCalfBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RCalfIt "test" pos:[124,340] width:24 height:60 style:#bmp_tile bitmap:RCalfBm;
	Local RFootBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RFootIt "test" pos:[128,404] width:32 height:24 style:#bmp_tile bitmap:RFootBm;
	Local RHorseBm = (bitmap 1 1 color:(color 6 134 6))
	imgTag RHorseIt "test" pos:[-100,-100] width:24 height:36 style:#bmp_tile bitmap:RHorseBm;
	Local RToeBm = (bitmap 1 1 color:(color 113 134 6))
	imgTag RToeIt "test" pos:[164,410] width:12 height:16 style:#bmp_tile bitmap:RToeBm;
	--Local RKneeBm = (bitmap 1 1 color:(color 125 125 125))
	--imgTag RKneeIt "test" pos:[152,324] width:20 height:20 style:#bmp_tile bitmap:RKneeBm enabled:true;

	--ここから大量の背骨と首
	--区画は48～250
	Local spine01Bm = defaultBm
	imgTag spine01It "test" pos:[70,250] width:44 height:5 style:#bmp_tile bitmap:spine01Bm enabled:true;
	Local spine02Bm = defaultBm
	imgTag spine02It "test" pos:[70,244] width:44 height:5 style:#bmp_tile bitmap:spine02Bm enabled:true;
	Local spine03Bm = defaultBm
	imgTag spine03It "test" pos:[70,238] width:44 height:5 style:#bmp_tile bitmap:spine03Bm enabled:true;
	Local spine04Bm = defaultBm
	imgTag spine04It "test" pos:[70,232] width:44 height:5 style:#bmp_tile bitmap:spine04Bm enabled:true;
	Local spine05Bm = defaultBm
	imgTag spine05It "test" pos:[70,226] width:44 height:5 style:#bmp_tile bitmap:spine05Bm enabled:true;
	Local spine06Bm = defaultBm
	imgTag spine06It "test" pos:[70,220] width:44 height:5 style:#bmp_tile bitmap:spine06Bm enabled:true;
	Local spine07Bm = defaultBm
	imgTag spine07It "test" pos:[70,214] width:44 height:5 style:#bmp_tile bitmap:spine07Bm enabled:true;
	Local spine08Bm = defaultBm
	imgTag spine08It "test" pos:[70,208] width:44 height:5 style:#bmp_tile bitmap:spine08Bm enabled:true;
	Local spine09Bm = defaultBm
	imgTag spine09It "test" pos:[70,202] width:44 height:5 style:#bmp_tile bitmap:spine09Bm enabled:true;
	Local spine10Bm = defaultBm
	imgTag spine10It "test" pos:[70,196] width:44 height:5 style:#bmp_tile bitmap:spine10Bm enabled:true;

	--Space-4
	Local neck01Bm = defaultBm
	imgTag neck01It "test" pos:[74,178] width:36 height:4 style:#bmp_tile bitmap:neck01Bm enabled:true;
	Local neck02Bm = defaultBm
	imgTag neck02It "test" pos:[74,173] width:36 height:4 style:#bmp_tile bitmap:neck02Bm enabled:true;
	Local neck03Bm = defaultBm
	imgTag neck03It "test" pos:[74,168] width:36 height:4 style:#bmp_tile bitmap:neck03Bm enabled:true;
	Local neck04Bm = defaultBm
	imgTag neck04It "test" pos:[74,163] width:36 height:4 style:#bmp_tile bitmap:neck04Bm enabled:true;
	Local neck05Bm = defaultBm
	imgTag neck05It "test" pos:[74,158] width:36 height:4 style:#bmp_tile bitmap:neck05Bm enabled:true;
	Local neck06Bm = defaultBm
	imgTag neck06It "test" pos:[74,153] width:36 height:4 style:#bmp_tile bitmap:neck06Bm enabled:true;
	Local neck07Bm = defaultBm
	imgTag neck07It "test" pos:[74,148] width:36 height:4 style:#bmp_tile bitmap:neck07Bm enabled:true;
	Local neck08Bm = defaultBm
	imgTag neck08It "test" pos:[74,143] width:36 height:4 style:#bmp_tile bitmap:neck08Bm enabled:true;
	Local neck09Bm = defaultBm
	imgTag neck09It "test" pos:[74,138] width:36 height:4 style:#bmp_tile bitmap:neck09Bm enabled:true;
	Local neck10Bm = defaultBm
	imgTag neck10It "test" pos:[74,133] width:36 height:4 style:#bmp_tile bitmap:neck10Bm enabled:true;

		
	Local neck11Bm = defaultBm
	imgTag neck11It "test" pos:[74,123] width:36 height:4 style:#bmp_tile bitmap:neck11Bm enabled:true;
	Local neck12Bm = defaultBm
	imgTag neck12It "test" pos:[74,118] width:36 height:4 style:#bmp_tile bitmap:neck12Bm enabled:true;
	Local neck13Bm = defaultBm
	imgTag neck13It "test" pos:[74,113] width:36 height:4 style:#bmp_tile bitmap:neck13Bm enabled:true;
	Local neck14Bm = defaultBm
	imgTag neck14It "test" pos:[74,108] width:36 height:4 style:#bmp_tile bitmap:neck14Bm enabled:true;
	Local neck15Bm = defaultBm
	imgTag neck15It "test" pos:[74,103] width:36 height:4 style:#bmp_tile bitmap:neck15Bm enabled:true;
	Local neck16Bm = defaultBm
	imgTag neck16It "test" pos:[74,98] width:36 height:4 style:#bmp_tile bitmap:neck16Bm enabled:true;
	Local neck17Bm = defaultBm
	imgTag neck17It "test" pos:[74,93] width:36 height:4 style:#bmp_tile bitmap:neck17Bm enabled:true;
	Local neck18Bm = defaultBm
	imgTag neck18It "test" pos:[74,88] width:36 height:4 style:#bmp_tile bitmap:neck18Bm enabled:true;
	Local neck19Bm = defaultBm
	imgTag neck19It "test" pos:[74,83] width:36 height:4 style:#bmp_tile bitmap:neck19Bm enabled:true;
	Local neck20Bm = defaultBm
	imgTag neck20It "test" pos:[74,78] width:36 height:4 style:#bmp_tile bitmap:neck20Bm enabled:true;
		
	Local neck21Bm = defaultBm
	imgTag neck21It "test" pos:[74,68] width:36 height:4 style:#bmp_tile bitmap:neck21Bm enabled:true;
	Local neck22Bm = defaultBm
	imgTag neck22It "test" pos:[74,63] width:36 height:4 style:#bmp_tile bitmap:neck22Bm enabled:true;
	Local neck23Bm = defaultBm
	imgTag neck23It "test" pos:[74,58] width:36 height:4 style:#bmp_tile bitmap:neck23Bm enabled:true;
	Local neck24Bm = defaultBm
	imgTag neck24It "test" pos:[74,53] width:36 height:4 style:#bmp_tile bitmap:neck24Bm enabled:true;
	Local neck25Bm = defaultBm
	imgTag neck25It "test" pos:[74,48] width:36 height:4 style:#bmp_tile bitmap:neck25Bm enabled:true;
		
	--最後-7
	Local spaceBm = (bitmap 1 1 color:(color 125 125 125))
	imgTag spaceIt "test" pos:[62,189] width:56 height:1 style:#bmp_tile bitmap:spaceBm enabled:false;
		
		
			--////////////////////////////////////////////////
			--アクションボタン
			--ボタンによって選択するものはすでに決まっている
			--////////////////////////////////////////////////	
		
			-------------------------------------------------------
			--キーイング
			-------------------------------------------------------
			on keyaBt pressed do setKey_Fn 1;
			on keybBt pressed do setKey_Fn 2;
			on keycBt pressed do setKey_Fn 3;
			on keydBt pressed do setKey_Fn 4;
			-------------------------------------------------------
			--反対を選択
			-------------------------------------------------------
			on selFlipBt pressed do if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do flipSelection_Fn();
			-------------------------------------------------------
			--全選択
			-------------------------------------------------------
			on allSelBt pressed do
			(
				--アクターが削除されているか確認する
				if (sj_selectorRig_rol.InvalidCheck_Fn() == false) do return();
				
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				--全てのコントローラーを回収する
					getAllControllers_Fn();
				if keyboard.shiftPressed then
				(
					undo on (
					selectMore allController;
					if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
					undo on (
					deselect allController;
					);--undo end
				)else
				(
					undo on (
					clearSelection()
					select allController;
					if (selFocus) do max zoomext sel;
					);--undo end
				);--if end
				);
				);--case end
			);
			-------------------------------------------------------
			--全動
			-------------------------------------------------------
			on allMoveBt pressed do
			(
				--アクターが削除されているか確認する
				if (sj_selectorRig_rol.InvalidCheck_Fn() == false) do return();
				
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				--全てのコントローラーを回収する
				if keyboard.shiftPressed then
				(
					undo on (
					selectMore bipNode.rootNode;
					selectMore (biped.getNode bipNode 1 link:4);
					selectMore (biped.getNode bipNode 2 link:4);
						--脚対策
						if (bipNode.legLinks > 3) then
						(
							--4本以上だったら
							selectMore (biped.getNode bipNode 5 link:4);
							selectMore (biped.getNode bipNode 6 link:4);
						)else(
							--3本だったら
							selectMore (biped.getNode bipNode 5 link:3);
							selectMore (biped.getNode bipNode 6 link:3);							
						);--if end
					if (selFocus) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
					undo on (
					deselect bipNode.rootNode;
					deselect (biped.getNode bipNode 1 link:4);
					deselect (biped.getNode bipNode 2 link:4);
						--脚対策
						if (bipNode.legLinks > 3) then
						(
							--4本以上だったら
							deselect (biped.getNode bipNode 5 link:4);
							deselect (biped.getNode bipNode 6 link:4);
						)else(
							--3本だったら
							deselect (biped.getNode bipNode 5 link:3);
							deselect (biped.getNode bipNode 6 link:3);							
						);--if end
					);--undo end
				)else
				(
					undo on (
					clearSelection()
					select bipNode.rootNode;
					selectMore (biped.getNode bipNode 1 link:4);
					selectMore (biped.getNode bipNode 2 link:4);
						--脚対策
						if (bipNode.legLinks > 3) then
						(
							--4本以上だったら
							selectMore (biped.getNode bipNode 5 link:4);
							selectMore (biped.getNode bipNode 6 link:4);
						)else(
							--3本だったら
							selectMore (biped.getNode bipNode 5 link:3);
							selectMore (biped.getNode bipNode 6 link:3);							
						);--if end
					if (selFocus) do max zoomext sel;
					);--undo end
					
				);--if end
				
				);
				);--case end
			);

			-------------------------------------------------------
			--全首
			-------------------------------------------------------
			on selNecAllBt pressed do
			(
				--アクターが削除されているか確認する
				if (sj_selectorRig_rol.InvalidCheck_Fn() == false) do return();
				
				allController = #();
				
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				--全てのコントローラーを回収する
				if keyboard.shiftPressed then
				(
					undo on (
					--Nec
					for i=1 to (bipNode.neckLinks) do
					(
					append allController (biped.getNode bipNode 17 link:i);
					);--for end
					selectMore allController;
						
					if (selFocus) do max zoomext sel;
						
					);--undo end
				)else if keyboard.controlPressed then(
					undo on (
					--Nec
					for i=1 to (bipNode.neckLinks) do
					(
					append allController (biped.getNode bipNode 17 link:i);
					);--for end
					deselect allController;
						
					);--undo end
				)else
				(
					undo on (
					clearSelection()
					--Nec
					for i=1 to (bipNode.neckLinks) do
					(
					append allController (biped.getNode bipNode 17 link:i);
					);--for end
					select allController;
						
					if (selFocus) do max zoomext sel;
					);--undo end
					
				);--if end
				
				);
				);--case end
			);

			
			-------------------------------------------------------
			--全背骨
			-------------------------------------------------------
			on selSpineAllBt pressed do
			(
				--アクターが削除されているか確認する
				if (sj_selectorRig_rol.InvalidCheck_Fn() == false) do return();
				
				allController = #();
				
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				--全てのコントローラーを回収する
				if keyboard.shiftPressed then
				(
					undo on (
					--背骨回収
					for i=1 to (bipNode.spineLinks) do
					(
					append allController (biped.getNode bipNode 9 link:i);
					);--for end
					selectMore allController;
						
					if (selFocus) do max zoomext sel;
						
					);--undo end
				)else if keyboard.controlPressed then(
					undo on (
					--背骨回収
					for i=1 to (bipNode.spineLinks) do
					(
					append allController (biped.getNode bipNode 9 link:i);
					);--for end
					deselect allController;
						
					);--undo end
				)else
				(
					undo on (
					clearSelection()
					--背骨回収
					for i=1 to (bipNode.spineLinks) do
					(
					append allController (biped.getNode bipNode 9 link:i);
					);--for end
					select allController;
						
					if (selFocus) do max zoomext sel;
					);--undo end
					
				);--if end
				
				);
				);--case end
			);

			
			-------------------------------------------------------
			--ルート
			-------------------------------------------------------
			on rootNodeIt mousedown do rootNodeIt.bitmap = cBm;on rootNodeIt mouseup do rootNodeIt.bitmap = rootNodeBm;on rootNodeIt mouseout do rootNodeIt.bitmap = rootNodeBm;
			on rootNodeIt lbuttondown mPos flag do
			(
				--アクターが削除されているか確認する
				if (sj_selectorRig_rol.InvalidCheck_Fn() == false) do return();
				
				case actorType of (
				--beyondなら
				1:(
				);
				--bipedなら
				2:(
				if keyboard.shiftPressed then
				(
					undo on (
					selectMore bipNode.rootNode;
					if (sj_bodyRigSel_rol.selFocusChk.checked) do max zoomext sel;
					);--undo end
				)else if keyboard.controlPressed then(
					undo on (
					deselect bipNode.rootNode;
					);--undo end
				)else if keyboard.altPressed then(
					undo on (
					select (sj_functions.sj_selectBranch_Fn bipNode.rootNode 1);
					);--undo end
				)else
				(
					undo on (
					clearSelection()
					select bipNode.rootNode;
					if (sj_bodyRigSel_rol.selFocusChk.checked) do max zoomext sel;
					);--undo end
				);--if end
				);--2end
				);--case end
			);--end
			-------------------------------------------------------
			--腰
			on hipIt mousedown do hipIt.bitmap = cBm;on hipIt mouseup do hipIt.bitmap = hipBm;on hipIt mouseout do hipIt.bitmap = hipBm;
			on hipIt lbuttondown mPos flag do if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do selControllers_Fn 12 false 0;
			--頭
			on headIt mousedown do headIt.bitmap = cBm;on headIt mouseup do headIt.bitmap = headBm;on headIt mouseout do headIt.bitmap = headBm;
			on headIt lbuttondown mPos flag do if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do selControllers_Fn 11 false 0;
			--腕
			on LClavicleIt mousedown do LClavicleIt.bitmap = cBm;on LClavicleIt mouseup do LClavicleIt.bitmap = LClavicleBm;on LClavicleIt mouseout do LClavicleIt.bitmap = LClavicleBm;
			on LClavicleIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 1 true 1);););
			on LUpperIt mousedown do LUpperIt.bitmap = cBm;on LUpperIt mouseup do LUpperIt.bitmap = LUpperBm;on LUpperIt mouseout do LUpperIt.bitmap = LUpperBm;
			on LUpperIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 1 true 2);););
			on LFormIt mousedown do LFormIt.bitmap = cBm;on LFormIt mouseup do LFormIt.bitmap = LFormBm;on LFormIt mouseout do LFormIt.bitmap = LFormBm;
			on LFormIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 1 true 3);););
			on LHandIt mousedown do LHandIt.bitmap = cBm;on LHandIt mouseup do LHandIt.bitmap = LHandBm;on LHandIt mouseout do LHandIt.bitmap = LHandBm;
			on LHandIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 1 true 4);););
			on RClavicleIt mousedown do RClavicleIt.bitmap = cBm;on RClavicleIt mouseup do RClavicleIt.bitmap =RClavicleBm;on RClavicleIt mouseout do RClavicleIt.bitmap = RClavicleBm;
			on RClavicleIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 2 true 1);););
			on RUpperIt mousedown do RUpperIt.bitmap = cBm;on RUpperIt mouseup do RUpperIt.bitmap = RUpperBm;on RUpperIt mouseout do RUpperIt.bitmap = RUpperBm;
			on RUpperIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 2 true 2);););
			on RFormIt mousedown do RFormIt.bitmap = cBm;on RFormIt mouseup do RFormIt.bitmap = RFormBm;on RFormIt mouseout do RFormIt.bitmap = RFormBm;
			on RFormIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 2 true 3);););
			on RHandIt mousedown do RHandIt.bitmap = cBm;on RHandIt mouseup do RHandIt.bitmap = RHandBm;on RHandIt mouseout do RHandIt.bitmap = RHandBm;
			on RHandIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 2 true 4);););
			--脚
			on LThighIt mousedown do LThighIt.bitmap = cBm;on LThighIt mouseup do LThighIt.bitmap = LThighBm;on LThighIt mouseout do LThighIt.bitmap = LThighBm;
			on LThighIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 5 true 1);););
			on LCalfIt mousedown do LCalfIt.bitmap = cBm;on LCalfIt mouseup do LCalfIt.bitmap = LCalfBm;on LCalfIt mouseout do LCalfIt.bitmap = LCalfBm;
			on LCalfIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 5 true 2);););
			on LFootIt mousedown do LFootIt.bitmap = cBm;on LFootIt mouseup do LFootIt.bitmap = LFootBm;on LFootIt mouseout do LFootIt.bitmap = LFootBm;
			on LFootIt lbuttondown mPos flag do (
				if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
				case actorType of (1:();
				2:(
						--脚対策
						if (bipNode.legLinks > 3) then (selControllers_Fn 5 true 4)else(selControllers_Fn 5 true 3);--if end
				););););
			on LHorseIt mousedown do LHorseIt.bitmap = cBm;on LHorseIt mouseup do LHorseIt.bitmap = LHorseBm;on LHorseIt mouseout do LHorseIt.bitmap = LHorseBm;
			on LHorseIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 5 true 3);););
			on LToeIt mousedown do LToeIt.bitmap = cBm;on LToeIt mouseup do LToeIt.bitmap = LToeBm;on LToeIt mouseout do LToeIt.bitmap = LToeBm;
			on LToeIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 7 true 1 );););
			on RThighIt mousedown do RThighIt.bitmap = cBm;on RThighIt mouseup do RThighIt.bitmap =RThighBm;on RThighIt mouseout do RThighIt.bitmap = RThighBm;
			on RThighIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 6 true 1);););
			on RCalfIt mousedown do RCalfIt.bitmap = cBm;on RCalfIt mouseup do RCalfIt.bitmap = RCalfBm;on RCalfIt mouseout do RCalfIt.bitmap = RCalfBm;
			on RCalfIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 6 true 2);););
			on RFootIt mousedown do RFootIt.bitmap = cBm;on RFootIt mouseup do RFootIt.bitmap = RFootBm;on RFootIt mouseout do RFootIt.bitmap = RFootBm;
			on RFootIt lbuttondown mPos flag do (
				if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do (
				case actorType of (1:();
				2:(
						--脚対策
						if (bipNode.legLinks > 3) then (selControllers_Fn 6 true 4)else(selControllers_Fn 6 true 3);--if end
				););););
			on RHorseIt mousedown do RHorseIt.bitmap = cBm;on RHorseIt mouseup do RHorseIt.bitmap = RHorseBm;on RHorseIt mouseout do RHorseIt.bitmap = RHorseBm;
			on RHorseIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 6 true 3);););
			on RToeIt mousedown do RToeIt.bitmap = cBm;on RToeIt mouseup do RToeIt.bitmap = RToeBm;on RToeIt mouseout do RToeIt.bitmap = RToeBm;
			on RToeIt lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 8 true 1 );););
			
			--背骨
			on spine01It mousedown do spine01It.bitmap = cBm;on spine01It mouseup do spine01It.bitmap = spine01Bm;on spine01It mouseout do spine01It.bitmap = spine01Bm;
			on spine01It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 1);););
			on spine02It mousedown do spine02It.bitmap = cBm;on spine02It mouseup do spine02It.bitmap = spine02Bm;on spine02It mouseout do spine02It.bitmap = spine02Bm;
			on spine02It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 2);););
			on spine03It mousedown do spine03It.bitmap = cBm;on spine03It mouseup do spine03It.bitmap = spine03Bm;on spine03It mouseout do spine03It.bitmap = spine03Bm;
			on spine03It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 3);););
			on spine04It mousedown do spine04It.bitmap = cBm;on spine04It mouseup do spine04It.bitmap = spine04Bm;on spine04It mouseout do spine04It.bitmap = spine04Bm;
			on spine04It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 4);););
			on spine05It mousedown do spine05It.bitmap = cBm;on spine05It mouseup do spine05It.bitmap = spine05Bm;on spine05It mouseout do spine05It.bitmap = spine05Bm;
			on spine05It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 5);););
			on spine06It mousedown do spine06It.bitmap = cBm;on spine06It mouseup do spine06It.bitmap = spine06Bm;on spine06It mouseout do spine06It.bitmap = spine06Bm;
			on spine06It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 6);););
			on spine07It mousedown do spine07It.bitmap = cBm;on spine07It mouseup do spine07It.bitmap = spine07Bm;on spine07It mouseout do spine07It.bitmap = spine07Bm;
			on spine07It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 7);););
			on spine08It mousedown do spine08It.bitmap = cBm;on spine08It mouseup do spine08It.bitmap = spine08Bm;on spine08It mouseout do spine08It.bitmap = spine08Bm;
			on spine08It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 8);););
			on spine09It mousedown do spine09It.bitmap = cBm;on spine09It mouseup do spine09It.bitmap = spine09Bm;on spine09It mouseout do spine09It.bitmap = spine09Bm;
			on spine09It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 9);););
			on spine10It mousedown do spine10It.bitmap = cBm;on spine10It mouseup do spine10It.bitmap = spine10Bm;on spine10It mouseout do spine10It.bitmap = spine10Bm;
			on spine10It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 9 true 10);););
			
			on neck01It mousedown do neck01It.bitmap = cBm;on neck01It mouseup do neck01It.bitmap = neck01Bm;on neck01It mouseout do neck01It.bitmap = neck01Bm;
			on neck01It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 1);););
			on neck02It mousedown do neck02It.bitmap = cBm;on neck02It mouseup do neck02It.bitmap = neck02Bm;on neck02It mouseout do neck02It.bitmap = neck02Bm;
			on neck02It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 2);););
			on neck03It mousedown do neck03It.bitmap = cBm;on neck03It mouseup do neck03It.bitmap = neck03Bm;on neck03It mouseout do neck03It.bitmap = neck03Bm;
			on neck03It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 3);););
			on neck04It mousedown do neck04It.bitmap = cBm;on neck04It mouseup do neck04It.bitmap = neck04Bm;on neck04It mouseout do neck04It.bitmap = neck04Bm;
			on neck04It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 4);););
			on neck05It mousedown do neck05It.bitmap = cBm;on neck05It mouseup do neck05It.bitmap = neck05Bm;on neck05It mouseout do neck05It.bitmap = neck05Bm;
			on neck05It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 5);););
			on neck06It mousedown do neck06It.bitmap = cBm;on neck06It mouseup do neck06It.bitmap = neck06Bm;on neck06It mouseout do neck06It.bitmap = neck06Bm;
			on neck06It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 6);););
			on neck07It mousedown do neck07It.bitmap = cBm;on neck07It mouseup do neck07It.bitmap = neck07Bm;on neck07It mouseout do neck07It.bitmap = neck07Bm;
			on neck07It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 7);););
			on neck08It mousedown do neck08It.bitmap = cBm;on neck08It mouseup do neck08It.bitmap = neck08Bm;on neck08It mouseout do neck08It.bitmap = neck08Bm;
			on neck08It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 8);););
			on neck09It mousedown do neck09It.bitmap = cBm;on neck09It mouseup do neck09It.bitmap = neck09Bm;on neck09It mouseout do neck09It.bitmap = neck09Bm;
			on neck09It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 9);););
			on neck10It mousedown do neck10It.bitmap = cBm;on neck10It mouseup do neck10It.bitmap = neck10Bm;on neck10It mouseout do neck10It.bitmap = neck10Bm;
			on neck10It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 10);););
			on neck11It mousedown do neck11It.bitmap = cBm;on neck11It mouseup do neck11It.bitmap = neck11Bm;on neck11It mouseout do neck11It.bitmap = neck11Bm;
			on neck11It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 11);););
			on neck12It mousedown do neck12It.bitmap = cBm;on neck12It mouseup do neck12It.bitmap = neck12Bm;on neck12It mouseout do neck12It.bitmap = neck12Bm;
			on neck12It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 12);););
			on neck13It mousedown do neck13It.bitmap = cBm;on neck13It mouseup do neck13It.bitmap = neck13Bm;on neck13It mouseout do neck13It.bitmap = neck13Bm;
			on neck13It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 13);););
			on neck14It mousedown do neck14It.bitmap = cBm;on neck14It mouseup do neck14It.bitmap = neck14Bm;on neck14It mouseout do neck14It.bitmap = neck14Bm;
			on neck14It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 14);););
			on neck15It mousedown do neck15It.bitmap = cBm;on neck15It mouseup do neck15It.bitmap = neck15Bm;on neck15It mouseout do neck15It.bitmap = neck15Bm;
			on neck15It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 15);););
			on neck16It mousedown do neck16It.bitmap = cBm;on neck16It mouseup do neck16It.bitmap = neck16Bm;on neck16It mouseout do neck16It.bitmap = neck16Bm;
			on neck16It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 16);););
			on neck17It mousedown do neck17It.bitmap = cBm;on neck17It mouseup do neck17It.bitmap = neck17Bm;on neck17It mouseout do neck17It.bitmap = neck17Bm;
			on neck17It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 17);););
			on neck18It mousedown do neck18It.bitmap = cBm;on neck18It mouseup do neck18It.bitmap = neck18Bm;on neck18It mouseout do neck18It.bitmap = neck18Bm;
			on neck18It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 18);););
			on neck19It mousedown do neck19It.bitmap = cBm;on neck19It mouseup do neck19It.bitmap = neck19Bm;on neck19It mouseout do neck19It.bitmap = neck19Bm;
			on neck19It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 19);););
			on neck20It mousedown do neck20It.bitmap = cBm;on neck20It mouseup do neck20It.bitmap = neck20Bm;on neck20It mouseout do neck20It.bitmap = neck20Bm;
			on neck20It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 20);););
			on neck21It mousedown do neck21It.bitmap = cBm;on neck21It mouseup do neck21It.bitmap = neck21Bm;on neck21It mouseout do neck21It.bitmap = neck21Bm;
			on neck21It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 21);););
			on neck22It mousedown do neck22It.bitmap = cBm;on neck22It mouseup do neck22It.bitmap = neck22Bm;on neck22It mouseout do neck22It.bitmap = neck22Bm;
			on neck22It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 22);););
			on neck23It mousedown do neck23It.bitmap = cBm;on neck23It mouseup do neck23It.bitmap = neck23Bm;on neck23It mouseout do neck23It.bitmap = neck23Bm;
			on neck23It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 23);););
			on neck24It mousedown do neck24It.bitmap = cBm;on neck24It mouseup do neck24It.bitmap = neck24Bm;on neck24It mouseout do neck24It.bitmap = neck24Bm;
			on neck24It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 24);););
			on neck25It mousedown do neck25It.bitmap = cBm;on neck25It mouseup do neck25It.bitmap = neck25Bm;on neck25It mouseout do neck25It.bitmap = neck25Bm;
			on neck25It lbuttondown mPos flag do ( if (sj_selectorRig_rol.InvalidCheck_Fn() == true) do case actorType of (1:();2:(selControllers_Fn 17 true 25);););

			--////////////////////////////////////////////////
			--アクションロールアウト
			--////////////////////////////////////////////////		
			on sj_bodyRigSel_rol open do --ロールアウトが開いたとき
			(
				uiBodySet_Fn();
				selFocusChk.checked = serectorRigZoom;
			)--open do end
			
			on sj_bodyRigSel_rol rolledUp state do
			(
				--閉じた場合はfalse開いた場合はtrue
				if state then
				(
				--iniに情報を書き込む
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "BodyRol" "false");
				)else
				(
				(setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "BodyRol" "true");
				);--if end
			);--end
			
			--////////////////////////////////////////////////
			--フォーカス
			on selFocusChk changed val do
			(
				selFocus = val--end
				setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "SerectorRigZoom" (val as String);
			);--end
			
			on uiBtFlipChk changed val do
			(
				if sj_selectorRig_rol.InvalidCheck_Fn() then
				(
				uiBtFlip = val;
				setINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJSelectorRig" "UIButtonFlip" (val as String);
				
				uiBodySet_Fn();
				--	print uiBtFlipPos
				--sj_selectorRig_rol.sj_selectorRigArea.sj_bodyRigSel_rol.uiBtFlipChk.checked = true;
				);--if end
			);--end
				
			
	);--rollout


rollout sj_selectorRig_rol "RIG" width:200 height:860
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--アクターは無効のチェック
--////////////////////////////////////////////////
fn InvalidCheck_Fn = (
	
		--セレクターノードも見つかってもノードが有効でない
		if (sj_selector_node != undefined) and (isvalidnode sj_selector_node == false) then
		(
		messageBox("アクターが無効ですニャ。\n直接または、セレクターから\nBipedを選択してから実行してニャ。") title:"お知らせ";
			try(cui.FloatDialogBar sj_selectorRig_rol)catch();
			try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
			try(closeRolloutFloater sj_selectorRig_rol) catch();
			try(destroydialog sj_selectorRig_rol)catch();
			
			return false;ｆ
			
		);--if end
		/*
		--bipedノードが無効
		if (isvalidnode bipNode == false) then
		(
		messageBox("アクターが無効ですニャ。\n直接または、セレクターから\nBipedかSJヘルパーを選択してから実行してニャ。") title:"お知らせ";
			try(cui.FloatDialogBar sj_selectorRig_rol)catch();
			try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
			try(closeRolloutFloater sj_selectorRig_rol) catch();
			try(destroydialog sj_selectorRig_rol)catch();
		);--if end
		*/
		return true;
		
);--fn end

--////////////////////////////////////////////////
--アクターを設定
/*
ロールアウトは開いていてか？
ロールアウトが開いていて、Nodeは有効か？
ロールアウトが開いていなかったらNodeは有効か？
*/
--////////////////////////////////////////////////
fn actorCheck_Fn = (
	--セレクターのロールアウトは開いたか？
	if (sj_selector_isopened != undefined ) and (sj_selector_isopened == true) then
		(
			--オブジェクトは有効か?
		if (sj_selector_node != undefined) and (isvalidnode sj_selector_node == true) then
		(
			--種類を判定
			if (classOf sj_selector_node == SJ_Helper) then
			(
				actorType = 1;
				sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
				return true;
			)else if (classOf sj_selector_node == Biped_Object) or
						((classOf (sj_selector_node.GetSourceObject true)) == Biped_Object) then--リファレンス対策
			(
				actorType = 2;
				sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
				return true;
			)else(
				--ロールアウトを開いていたがnodeがなかった場合
				--選択物から回避策
				--ノードが無効ならば現在の選択物1から判定する
				if (classOf selection[1] == SJ_Helper) do
				(
					sj_selector_node = selection[1];
					actorType = 1;
					sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
					return true;
				);--if end
				
				--Bipedか？
				if (classOf selection[1] == Biped_Object) or
					((classOf (selection[1].GetSourceObject true)) == Biped_Object) do--リファレンス対策
				(
					--マズコントローラーを回収
					Local tempBip = selection[1].controller
						--ルートノードを回収
					sj_selector_node = tempBip.rootNode;
					actorType = 2;
					sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
					return true;
				);--if end
			
			--すべて失敗したら
			return false;
			);--if end
			
		);--if end
		
		)else if (sj_selector_isopened == undefined ) or (sj_selector_isopened == false) then
		(
			--選択物から回避策
			--ノードが無効ならば現在の選択物1から判定する
			if (classOf selection[1] == SJ_Helper) do
			(
				sj_selector_node = selection[1];
				actorType = 1;
				sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
				return true;
			);--if end
			
			
			--Bipedか？
			if (classOf selection[1] == Biped_Object) do--リファレンス対策
			(
				--マズコントローラーを回収
				Local tempBip = selection[1].controller
					--ルートノードを回収
				sj_selector_node = tempBip.rootNode;
				actorType = 2;
				sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
				return true;
			);--if end
			
			
			--リファレンスかつbipedか?
			if ((classOf selection[1]) == XrefObject) and ((classOf (selection[1].GetSourceObject true)) == Biped_Object) do
			(
				--マズコントローラーを回収
				Local tempBip = selection[1].controller
					--ルートノードを回収
				sj_selector_node = tempBip.rootNode;
				actorType = 2;
				sj_selectorRig_rol.title = sj_selector_node.name + "ニャ";--ロールアウト名を変更
				return true;
			);--if end
			
			
			--すべて失敗したら
			return false;
		);--if end
			return false;
	);--end fn

--////////////////////////////////////////////////
--自動アップデート
--////////////////////////////////////////////////	
fn sj_selectorRigRefresh_Fn = (
	
	--名前で拾えるか？
	try(
		sj_selector_node  = (getNodeByName sj_selector_nodeName);
		--print sj_selector_node
		
		--選択しないとアクターチェックが正常に機能しない
		select sj_selector_node;	
		if actorCheck_Fn() then
		(
			bipNode = sj_selector_node.controller;
			--UIを作り直す
			sj_bodyRigSel_rol.uiBodySet_Fn();
			sj_srFinger_rol.uiFingerSet_Fn();
			sj_srOthers_rol.getOthers_Fn();
			--フィルターに文字を入れておく
			sj_srOthers_rol.getIniOthers_Fn();
			sj_srOthers_rol.filterEdt.text = sj_srOthers_rol.filterLastKeyWords;

			--print (actorCheck_Fn())
			--print sj_selector_node
			clearSelection()	
		)else
		(
			try(cui.FloatDialogBar sj_selectorRig_rol)catch();
			try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
			try(closeRolloutFloater sj_selectorRig_rol) catch();
			try(destroydialog sj_selectorRig_rol)catch();
			print "アクターはBipedではない"
		);--if end		
	)catch(
			--messageBox("直接または、セレクターから\nBipedかSJヘルパーを選択してから実行してニャ。")title:"お知らせ";
			try(cui.FloatDialogBar sj_selectorRig_rol)catch();
			try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
			try(closeRolloutFloater sj_selectorRig_rol) catch();
			try(destroydialog sj_selectorRig_rol)catch();
		print "アクター無効"
	);--失敗したら
);--fn end

--////////////////////////////////////////////////
--load default
--////////////////////////////////////////////////
fn loadDefault_Fn =
(
--なんとなく暗号化
SelectorRigDefalutFile = openEncryptedFile "$Scripts/SJTools//LayerLayerDefalut.dat" fileLockID

	oldSelectorRigPos = readValue SelectorRigDefalutFile
	windowDock = readvalue SelectorRigDefalutFile
	close SelectorRigDefalutFile
	tempName = #();

)--fn end

--////////////////////////////////////////////////
--save default
--////////////////////////////////////////////////
fn saveDefault_Fn = 
(
selectorRigDefalutFile = createFile "$Scripts/SJTools//SelectorRigDefalut.tmp"
format "%\n" oldSelectorRigPos to:selectorRigDefalutFile
format "%\n" windowDock to:selectorRigDefalutFile
close selectorRigDefalutFile

encryptFile "$Scripts/SJTools//SelectorRigDefalut.tmp" "$Scripts/SJTools//SelectorRigDefalut.dat" fileLockID
--deleteFile "$Scripts/SJTools//SelectorRigDefalut.tmp"
)--fn end


--////////////////////////////////////////////////
--ファンクションここまで
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	--サブロールアウトのエリアを追加
	subrollout sj_selectorRigArea pos:[0,0] width:sj_selectorRig_rol.width height:sj_selectorRig_rol.height;
	local resizeBitMap = openBitmap "$Scripts/SJTools/Images/SJ_button_resize.png"
	ImgTag resizeImg "Bitmap" pos:[190,850] width:10 height:10 enabled:false bitmap:resizeBitMap transparent:(color 255 255 255);

	--////////////////////////////////////////////////
	--ロールアウトイベント
	--////////////////////////////////////////////////
	on sj_selectorRig_rol resized val do
	(
		width = 200;
		height = 860;
		
		if (sj_selectorRig_rol.height >= 860) then
		(
			
			--リサイズイメージの位置
			resizeImg.pos = [(val[1]-10),(val[2]-10)];
			sj_selectorRig_rol.width = 200;
			sj_selectorRigArea.height = sj_selectorRig_rol.height;
		)
		else
		(
		sj_selectorRig_rol.width = 200;
		--sj_selectorRig_rol.height = 860;
		);--if end
	)--end
	
	on sj_selectorRig_rol close do--閉じたとき
	(
		allController = #();
		
		--指用配列
		L0fingerNodes = #(); L1fingerNodes = #();L2fingerNodes = #();L3fingerNodes = #();L4fingerNodes = #();
		R0fingerNodes = #(); R1fingerNodes = #();R2fingerNodes = #();R3fingerNodes = #();R4fingerNodes = #();
		L0toeNodes = #(); L1toeNodes = #();L2toeNodes = #();L3toeNodes = #();L4toeNodes = #();
		R0toeNodes = #(); R1toeNodes = #();R2toeNodes = #();R3toeNodes = #();R4toeNodes = #();
		
		--名前を初期化
		sj_selector_nodeName = undefined;
		--コールバックを削除
		callbacks.removescripts id:#SJ_Selector_Rid_Refresh; ---コールバックが重複登録されないように、安全対策
		
		gc();
	);
	
	on sj_selectorRig_rol open do --ロールアウトが開いたとき
	(
		--loadDefault_Fn();
		
		if actorCheck_Fn() then
		(
				bipNode = sj_selector_node.controller;
				sj_selector_nodeName = sj_selector_node.name;
		)else
		(
			--messageBox("終了します")title:"お知らせ";
			messageBox("直接または、セレクターから\nBipedを選択してから実行してニャ。")title:"お知らせ";
			try(cui.FloatDialogBar sj_selectorRig_rol)catch();
			try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
			try(closeRolloutFloater sj_selectorRig_rol) catch();
			try(destroydialog sj_selectorRig_rol)catch();
			/*
			if (queryBox("セレクターを起動しますか?")) then
				(
					macros.run "SJTools" "SJ_Selector";
					try(cui.FloatDialogBar sj_selectorRig_rol)catch();
					try(cui.unRegisterDialogBar sj_selectorRig_rol)catch();
					try(closeRolloutFloater sj_selectorRig_rol) catch();
					try(destroydialog sj_selectorRig_rol)catch();
				)else(

				);--if end
			*/
		);--if end
		--sj_bodyRigSel_rol.selectorGrp.caption = sj_selector_node.name + "Controllers";
		--sj_bodyRigSel_rol.selectorGrp.caption
		--sj_selectorRig_rol.rigNameGrp.caption = actorArray[3].name;
		
		callbacks.removescripts id:#SJ_Selector_Rid_Refresh; ---コールバックが重複登録されないように、安全対策
		callbacks.addScript #filePostOpenProcess "sj_selectorRig_rol.sj_selectorRigRefresh_Fn()" id:#SJ_Selector_Rid_Refresh; --ロールアウト内のファンクションを直接登録
		
	)--open do end
	
	on sj_selectorRig_rol moved val do
	(
		if (sj_selector_rol != undefined ) then
		(
		sj_selector_rol.old_selectorRig_rol_pos[1] = val[1];
		sj_selector_rol.old_selectorRig_rol_pos[2] = val[2];
		);--if end
		--oldSelectorRigPos[1] = val[1];
		--oldSelectorRigPos[2] = val[2];
		--saveDefault_Fn();
	);--end
	
)--rollout sj_selectorRig_rol end

--////////////////////////////////////////////////
--ダイアログクリエート
--////////////////////////////////////////////////	
--一度でもロールアウトは開いたか？
local tempSelectorPos = #(0,0);
--if (sj_selector_rol != undefined ) and (windowDock) then
if (sj_selector_rol != undefined ) then
	(
		tempSelectorPos[1] = sj_selector_rol.old_selectorRig_rol_pos[1];
		tempSelectorPos[2] = sj_selector_rol.old_selectorRig_rol_pos[2]; 
		--tempSelectorPos[1] = sj_selector_rol_pos[1] + sj_selector_rol.width; 
		--tempSelectorPos[2] = sj_selector_rol_pos[2]; 
	)else(
		tempSelectorPos[1] = oldSelectorRigPos[1];
		tempSelectorPos[2] = oldSelectorRigPos[2];
	);--ifend
CreateDialog sj_selectorRig_rol menu:selectorRigMenuBar pos:[tempSelectorPos[1],tempSelectorPos[2]] style:#(#style_border, #style_toolwindow,/*#style_titlebar,*/ #style_sysmenu, #style_minimizebox, #style_resizing);
addsubRollout sj_selectorRig_rol.sj_selectorRigArea sj_bodyRigSel_rol rolledUp:bodyRol;
addsubRollout sj_selectorRig_rol.sj_selectorRigArea sj_srFinger_rol rolledUp:fingerRol;
--addsubRollout sj_selectorRig_rol.sj_selectorRigArea sj_srFfaceRigSel_rol rolledUp:true
addsubRollout sj_selectorRig_rol.sj_selectorRigArea sj_srOthers_rol rolledUp:otherRol;
--addsubRollout sj_selectorRig_rol.sj_selectorRigArea sj_srKeying_rol rolledUp:false	
		
);--all end
