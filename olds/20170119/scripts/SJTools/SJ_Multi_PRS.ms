/*******************************************************
System J Tools 
********************************************************
Name:SJ_MultiPRS
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

(

-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
global sj_multi_rps_rol--ロールアウト用
	
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

-----------------------------------------------------------------------------------------------------------
-- ロールアウト周り
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_multi_rps_rol)catch()	--ダイアログのフロート化を試みます
try(cui.unRegisterDialogBar sj_multi_rps_rol)catch()		--ドッキング可能な MAXScript ウィンドウを未登録にします
try(closeRolloutFloater sj_multi_rps_rol) catch()	--ロールアウトフローターが開いていたら一端閉じる
try(destroydialog sj_multi_rps_rol)catch()		--ダイアログが既に開いていた場合は一度閉じるを試みます

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--アップデート
--////////////////////////////////////////////////
fn selCountCheck_Fn =
(
	local checkTemp = true
	
	if selection.count != 0 then
	(
	
		if (selection[1].position.controller as String) != "Controller:Position_XYZ" then
		(
		sj_multi_rps_rol.infoLbl.caption = "特殊なコントローラーが\n含まれています"
		)
		else
		(
		sj_multi_rps_rol.infoLbl.caption = ""
		)--if end

		if (selection[1].rotation.controller as String) != "Controller:Euler_XYZ" then
		(
		sj_multi_rps_rol.infoLbl.caption = "特殊なコントローラーが\n含まれています"
		)
		else
		(
		sj_multi_rps_rol.infoLbl.caption = ""
		)--if end
	
		checkTemp = true
	)
	else
	(
		CheckTemp = false
		--pos
		sj_multi_rps_rol.posXSp.value = 0.0
		sj_multi_rps_rol.posYSp.value = 0.0
		sj_multi_rps_rol.posZSp.value = 0.0
		--rot
		sj_multi_rps_rol.rotXSp.value = 0.0
		sj_multi_rps_rol.rotYSp.value = 0.0
		sj_multi_rps_rol.rotZSp.value = 0.0
		--sca
		sj_multi_rps_rol.scaXSp.value = 0.0
		sj_multi_rps_rol.scaYSp.value = 0.0
		sj_multi_rps_rol.scaZSp.value = 0.0
	)--if end
	sj_multi_rps_rol.posXSp.enabled = checkTemp
	sj_multi_rps_rol.posYSp.enabled = checkTemp
	sj_multi_rps_rol.posZSp.enabled = checkTemp
	sj_multi_rps_rol.rotXSp.enabled = checkTemp
	sj_multi_rps_rol.rotYSp.enabled = checkTemp
	sj_multi_rps_rol.rotZSp.enabled = checkTemp
	sj_multi_rps_rol.scaXSp.enabled = checkTemp
	sj_multi_rps_rol.scaYSp.enabled = checkTemp
	sj_multi_rps_rol.scaZSp.enabled = checkTemp
)--fn end

fn multi_rps_update_Fn =
(
	try(
	selCountCheck_Fn()
	if selection.count != 0 do --オブジェクトは選択されているか？
	(
		--if selection.count > 1 do sj_multi_rps_rol.infoLbl.caption = "複数選択の場合は\n最初に選択した対象の数値が\n反映されます"

		case sj_multi_rps_rol.typeRb.state of
		(
		1:(
			--pos
			sj_multi_rps_rol.posXSp.value = (in coordsys world selection[1].pos.x)
			sj_multi_rps_rol.posYSp.value = (in coordsys world selection[1].pos.y)
			sj_multi_rps_rol.posZSp.value = (in coordsys world selection[1].pos.z)
			--rot
			sj_multi_rps_rol.rotXSp.value = (in coordsys world selection[1].rotation.X_rotation)
			sj_multi_rps_rol.rotYSp.value = (in coordsys world selection[1].rotation.Y_rotation)
			sj_multi_rps_rol.rotZSp.value = (in coordsys world selection[1].rotation.Z_rotation)
			--sca
			sj_multi_rps_rol.scaXSp.value = ((in coordsys world selection[1].scale.x) * 100.0)
			sj_multi_rps_rol.scaYSp.value = ((in coordsys world selection[1].scale.y) * 100.0)
			sj_multi_rps_rol.scaZSp.value = ((in coordsys world selection[1].scale.z) * 100.0)
		)--case 1 end
		
		2:(
			--pos
			sj_multi_rps_rol.posXSp.value = (in coordsys parent selection[1].pos.x)
			sj_multi_rps_rol.posYSp.value = (in coordsys parent selection[1].pos.y)
			sj_multi_rps_rol.posZSp.value = (in coordsys parent selection[1].pos.z)
			--rot
			sj_multi_rps_rol.rotXSp.value = (in coordsys parent selection[1].rotation.X_rotation)
			sj_multi_rps_rol.rotYSp.value = (in coordsys parent selection[1].rotation.Y_rotation)
			sj_multi_rps_rol.rotZSp.value = (in coordsys parent selection[1].rotation.Z_rotation)
			--sca
			sj_multi_rps_rol.scaXSp.value = ((in coordsys parent selection[1].scale.x) * 100.0)
			sj_multi_rps_rol.scaYSp.value = ((in coordsys parent selection[1].scale.y) * 100.0)
			sj_multi_rps_rol.scaZSp.value = ((in coordsys parent selection[1].scale.z) * 100.0)
		)--case 2 end
		
		3:(
			--pos
			sj_multi_rps_rol.posXSp.value = 0.0
			sj_multi_rps_rol.posYSp.value = 0.0
			sj_multi_rps_rol.posZSp.value = 0.0
			--rot
			sj_multi_rps_rol.rotXSp.value = 0.0
			sj_multi_rps_rol.rotYSp.value = 0.0
			sj_multi_rps_rol.rotZSp.value = 0.0
			--sca
			sj_multi_rps_rol.scaXSp.value = 0.0
			sj_multi_rps_rol.scaYSp.value = 0.0
			sj_multi_rps_rol.scaZSp.value = 0.0
		)--case 3 end
		
		)--case end
	)--if end
	
	)catch(sj_multi_rps_rol.infoLbl.caption = "変換出来ませんでした\n注：Bipedは非対応です")
)

--////////////////////////////////////////////////
--代入
--////////////////////////////////////////////////
--位置
fn changePosValue_Fn axis value =
(
	case axis of
	(
		1:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].pos.x += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].pos.x = value
					) --for end					
				) --default end
			) --case end
		)--case 1 end

		2:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].pos.y += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].pos.y = value
					) --for end					
				) --default end
			) --case end
		) --case 2 end

		3:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].pos.z += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].pos.z = value
					) --for end					
				) --default end
			) --case end
		) --case 3 end
	) --case axis end
) --Fn end

--回転
fn changeRotValue_Fn axis valueX valueY valueZ =
Local valueTemp = ((EulerAngles valueX valueY valueZ) as quat)
print valueTemp
(
	case axis of
	(
		1:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].rotation += valueTemp
						--selection[i].rotation.X_rotation += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].rotation = valueTemp
						--selection[i].rotation.X_rotation = valueTemp
					) --for end					
				) --default end
			) --case end
		)--case 1 end

		2:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].rotation.Y_rotation += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].rotation.Y_rotation = value
					) --for end					
				) --default end
			) --case end
		) --case 2 end

		3:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].rotation.Z_rotation += value
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].rotation.Z_rotation = value
					) --for end					
				) --default end
			) --case end
		) --case 3 end
	) --case axis end
) --Fn end

--スケール
fn changeScaValue_Fn axis value =
(
	local valueTemp = value / 100
	case axis of
	(
		1:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].scale.x += valueTemp
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].scale.x = (in coordsys parent valueTemp)
					) --for end					
				) --default end
			) --case end
		)--case 1 end

		2:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].scale.y += valueTemp
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].scale.y = (in coordsys parent valueTemp)
					) --for end					
				) --default end
			) --case end
		) --case 2 end

		3:(
			case sj_multi_rps_rol.typeRb.state of
			(
				3:(
					for i=1 to selection.count do
					(
						selection[i].scale.z += valueTemp
					) --for end
				) --case 3 end
				default:(
					for i=1 to selection.count do
					(
						selection[i].scale.z = (in coordsys parent valueTemp)
					) --for end					
				) --default end
			) --case end
		) --case 3 end
	) --case axis end
) --Fn end


-----------------------------------------------------------------------------------------------------------
-- メイン Rollout
-----------------------------------------------------------------------------------------------------------
rollout sj_multi_rps_rol "ニャー v0.1Beta" width:160 height:464
(
--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	local minRange = -10000000, maxRange = 10000000
	groupBox typeGb "セッティング" pos:[8,8] width:144 height:68
	radioButtons typeRb "" pos:[16,24] width:79 height:48 labels:#("ワールド", "親", "オフセット") columns:1

	groupBox posGb "位置" pos:[8,80] width:144 height:88	
	spinner posXSp "X : " pos:[10,96] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false
	spinner posYSp "Y : " pos:[10,120] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false
	spinner posZSp "Z : " pos:[10,144] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false
	
	groupBox rotGb "回転" pos:[8,176] width:144 height:88
	spinner rotXSp "X : " pos:[10,192] width:132 height:16 range:[minRange,maxRange,0] scale:0.1 enabled:false
	spinner rotYSp "Y : " pos:[10,216] width:132 height:16 range:[minRange,maxRange,0] scale:0.1 enabled:false
	spinner rotZSp "Z : " pos:[10,240] width:132 height:16 range:[minRange,maxRange,0] scale:0.1 enabled:false
	
	groupBox scaleGb "スケール" pos:[8,272] width:144 height:88
	spinner scaXSp "X : " pos:[10,288] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false
	spinner scaYSp "Y : " pos:[10,312] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false
	spinner scaZSp "Z : " pos:[10,336] width:132 height:16 range:[minRange,maxRange,0] scale:0.01 enabled:false

	groupBox infoGb "Info" pos:[8,368] width:144 height:88
	label infoLbl "" pos:[16,384] width:128 height:48
	--label lbl8 "0個選択" pos:[16,402] width:128 height:16

--////////////////////////////////////////////////
--アップデート
--////////////////////////////////////////////////
	on typeRb changed state do multi_rps_update_Fn()

	on posXSp changed state do with redraw off(changePosValue_Fn 1 state)
	on posYSp changed state do changePosValue_Fn 2 state
	on posZSp changed state do changePosValue_Fn 3 state
	
	on rotXSp changed state do with redraw off(changeRotValue_Fn 1 state rotYSp.value rotZSp.value)
	on rotYSp changed state do changeRotValue_Fn 2 state
	on rotZSp changed state do changeRotValue_Fn 3 state

	on scaXSp changed state do changeScaValue_Fn 1 state
	on scaYSp changed state do changeScaValue_Fn 2 state
	on scaZSp changed state do changeScaValue_Fn 3 state
	
	--Open,Close
	on sj_multi_rps_rol open do
	(
	/*
		messageBox("
現在Beta版のために幾つか不具合があります\n
・回転値が上手く変換されない時があります
・TCBコントローラーなどには対応していません
・アンドゥで作業を戻すことはできません\n
・複数選択の場合は、最初に選択したオブジェクトの数値を表します
・複数選択での回転は各オブジェクト毎に回転します\n
・Bipedは非対応です、Bipedに対して使用しないでください
バグります\n
改良中ですだ
") title:"注意"
*/
		registerRedrawViewsCallback multi_rps_update_Fn --コールバックに登録します　コールバックは削除されない限り動作しつづけます
		multi_rps_update_Fn() --ひとまず実行
	)

	on sj_multi_rps_rol close do unregisterRedrawViewsCallback multi_rps_update_Fn --コールバックを削除します

)--rol end

-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_multi_rps_rol

)--end macroscript
