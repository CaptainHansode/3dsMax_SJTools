/*******************************************************
System J Tools 
********************************************************
Name:SJ_Bio_Skin_Plus
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
--グローバル変数宣言周り
global sj_bio_skin_plus_rol, sj_load_mapping_rol, sj_sj_load_verts_rol
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
include "$scripts/SJTools/SJ_CommonLangSet.ms"

--Version etc 名前自体はSJTools.iniから
Local nameAndVersion = (getINISetting("$scripts/SJTools/SJTools.ini") "SJToolsToolName" "SJBioSkinPlusToolName");

-----------------------------------------------------------------------------------------------------------
local last_spin 	 	= "start" -- used to identify the last spinner used (radius spinner)
local target_skin  	= undefined -- used when mirroring to a different skin then selected.
local silent			= false -- used to do hold and fetches of data
local feed_file		= undefined -- used to feed a file when using fetch
local tagged_nodes	= #()
local env_buffer		= #() -- used to store copied envelope data
local biodef			= false
local bonesinskin 	= #() -- ボーンリストのホールド、ペーストに使用

-----------------------------------------------------------------------------------------------------------
-- ロールアウトアクション
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_bio_skin_plus_rol)catch()
try(cui.unRegisterDialogBar sj_bio_skin_plus_rol)catch()
try (destroydialog sj_bio_skin_plus_rol) catch() --ドッキングを解除します
-----------------------------------------------------------------------------------------------------------
--メニュー
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
rcMenu bio_skin_plusMenuBar
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
on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5905" ""
on aboutMi picked do sj_functions.sjtools_about_Fn();
on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
on poserMenuBar update do
(
)
)--rcMenu end
-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
rollout sj_bio_skin_plus_rol nameAndVersion width:634 height:372
(

-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
include "$scripts/SJTools/SJScripts/SJ_Bio_Skin_Plus_Functions.ms"

/*######################################################################*/
-----------------------------------------------------------------------------------------------
--ボタンレイアウト周り
-----------------------------------------------------------------------------------------------
/*######################################################################*/
-----------------------------------------
--スキンモディファイア
-----------------------------------------
	GroupBox skingB1 "スキンモディファイア" pos:[8,8] width:200 height:224
	
	--Character size
	label char_fatlbl "キャラクターサイズ %:" pos:[16,24] width:104 height:16
	spinner char_fat "" pos:[128,24] width:72 height:16 range:[0,100,100]
 
	--Apply Skin
	button apply_skin_mod "スキン追加" pos:[16,48] width:184 height:24 toolTip:"標準のスキンモディファイアを追加します"
	button hold_bonelist "リストコピー" pos:[16,80] width:88 height:24 toolTip:"ボーンリストをコピーします"
	button paste_bonelist "リストペースト" pos:[112,80] width:88 height:24 toolTip:"ボーンリストをペーストします"
	 --Hold
	button hold_all "全て切り取り" pos:[16,112] width:88 height:24 toolTip:"スキンモディファイアの内容を全て切り取ります"
	--Fetch
	button fetch_all "全てペースト" pos:[112,112] width:88 height:24 toolTip:"切り取った内容を全てペーストします"
	--プラスオリジナル
	button del_non_used_boneBt "未使用ボーンをリストから削除" pos:[16,144] width:184 height:24 toolTip:"どの頂点からもウェイトの影響が無いボーンをリストから削除します"
	
	--プラスオリジナル
	GroupBox skingB2 "Save / Load BoneList" pos:[16,176] width:184 height:48

	--プラスオリジナル
	button save_boneListBt "リスト保存" pos:[24,192] width:80 height:24 toolTip:"ボーンリストをファイルに保存します"
	--プラスオリジナル
	button load_boneListBt "リスト開く" pos:[112,192] width:80 height:24 toolTip:"ボーンリストをファイルから読み込みます"

-----------------------------------------
--設定
-----------------------------------------
	GroupBox settinggB1 "設定" pos:[8,236] width:200 height:128
	--Show Mirror Plane
	checkbutton show_plane "ミラー平面を表示" pos:[16,252] width:184 height:24 toolTip:"ミラー平面の表示/非表示"
	--Mirror Plane offset:
	label x_offsetLbl "ミラー平面オフセット" pos:[16,284] width:112 height:16
	spinner x_offset "" pos:[128,284] width:72 height:16 enabled:true range:[-9999,9999,0] type:#float
	--Search Threshold:
	label thresLbl "スレッショルド検索" pos:[16,308] width:112 height:16
	spinner thres "" pos:[128,308] width:72 height:16 range:[0,9999,1] type:#float
	 --tar_skin
	pickbutton tar_skin "ターゲットスキンを読み込まない" pos:[16,332] width:184 height:24 toolTip:"別のメッシュを使いミラーを行う場合"

-----------------------------------------
--頂点
-----------------------------------------
	Local empty_bitmap = (bitmap 1 1 color:(color 180 180 180));
	
	GroupBox vertexGB1 "頂点" pos:[216,8] width:200 height:356

	--Fix All 0-Weigth
	button fix_vert_weights "全てフィックス" pos:[224,24] width:184 height:24 toolTip:"全ての頂点の中に0ウェイトが合った場合、最も近くのボーンに100%ウェイトを加えます" across:2
	--Fix Sel Only
	button fix_selvert_weights "選択フィックス" pos:[224,56] width:184 height:24 toolTip:"選択した頂点の中に0ウェイトが合った場合、最も近くのボーンに100%ウェイトを加えます"
	--Adapt All
	button adapt_all "全て適合" pos:[224,88] width:88 height:24 toolTip:"頂点のウェイト値をもっとも近くの骨に100%のウェイトを与え、手動修正に設定します" across:2
	--Adapt Sel
	button adapt_sel "選択適合" pos:[320,88] width:88 height:24 toolTip:"選択頂点のウェイト値をもっとも近くの骨に100%のウェイトを与え、手動修正に設定します"

	--Is Vertex Modified?
	label is_vert_mod "頂点は手動修正か?" pos:[232,120] width:112 height:32 toolTip:"自動設定か手動修正かを判定します"
	--したの部分が狂うempty_bitmap
	ImgTag is_mod_tag "" pos:[344,120] width:64 height:32 bitmap:empty_bitmap

	--Mirror Sel
	button mirror_sel_verts "選択ミラー" pos:[224,160] width:88 height:24 toolTip:"選択頂点の設定を鏡面コピーします" across:2
	--Mirror Mod
	button mirror_mod_verts "全てミラー" pos:[320,160] width:88 height:24 toolTip:"全ての頂点の設定を鏡面コピーします"
	--Paste Verts
	button paste_verts "ペースト" pos:[224,192] width:88 height:24 toolTip:"ウェイト値をペーストします" across:2
	--Clean Verts
	button clean_verts "クリーン" pos:[320,192] width:88 height:24 toolTip:"ボーンに対してウェイト値が0の場合、ボーンに対する影響を削除します"

	--Sel Af.Verts
	button select_af_verts "影響選択" pos:[224,224] width:88 height:24 toolTip:"選択したボーンに影響する頂点を選択します" across:2
	--Prnt Af.Bones
	button print_af_bones "影響ボーン" pos:[320,224] width:88 height:24 toolTip:"選択頂点が影響するボーン名をリスナーに表示します"
	--Expand Sel. to Element
	button expand_element "要素全て選択" pos:[224,256] width:184 height:24 toolTip:"全ての頂点を選択します"


	GroupBox vertexgB2 "Save / Load Verts" pos:[224,288] width:184 height:48
	button save_verts "頂点保存" pos:[232,304] width:80 height:24 toolTip:"頂点情報をファイルに保存します"
	button load_verts "頂点開く" pos:[320,304] width:80 height:24 toolTip:"頂点情報をファイルから読み込みます"


-----------------------------------------
--エンベロープ
-----------------------------------------
	GroupBox envelopegB1 "エンベロープ" pos:[424,8] width:200 height:356

	--Falloff:
	label spn_gapLbl "フォールオフ:" pos:[432,24] width:120 height:16
	spinner spn_gap "" pos:[552,24] width:64 height:16 range:[0.001,99,4] type:#float

	--Start Envelope
	label in_radius_startLbl "スタートエンベロープ:" pos:[432,48] width:120 height:16
	spinner in_radius_start "" pos:[552,48] width:64 height:16 range:[0,99,4] type:#float ticks:2 across:2

	--End Envelope
	label in_radius_endLbl "エンドエンベロープ:" pos:[432,72] width:120 height:16
	spinner in_radius_end "" pos:[552,72] width:64 height:16 range:[0,99,4] type:#float ticks:2 across:2

	/*************************************************/
	--ビジュアルエディタで編集するとしたの部分が狂うbitmap:empty_bitmap
	--
	/*************************************************/
	ImgTag in_radius_stag "Bitmap" pos:[440,96] width:32 height:32 bitmap:empty_bitmap toolTip:"半径設定を読み込み1"
	ImgTag in_radius_etag "Bitmap" pos:[480,96] width:32 height:32 bitmap:empty_bitmap toolTip:"半径設定を読み込み2"
	checkbutton lock_radiuses "ロック" pos:[528,100] width:88 height:28 toolTip:"スタートエンドエンベロープ、の半径をロックします"

	button copy_env "コピー" pos:[432,136] width:88 height:24 toolTip:"エンベロープをコピーします" across:2
	button paste_env "ペースト" pos:[528,136] width:88 height:24 toolTip:"エンベロープをペーストします"
	button tpaste_env "ターゲットペースト" pos:[432,168] width:88 height:24 toolTip:"エンベロープ設定を切り取り、鏡面側にペーストします" across:2
	button mirror_env "選択をミラー" pos:[528,168] width:88 height:24 toolTip:"選択したエンベロープを鏡面コピーします"

	checkbox mirror_excl "Excl. verts" pos:[440,200] width:80 height:16 checked:false across:2
	checkbox mirror_gizmo "Gizmo's" pos:[536,200] width:80 height:16 enabled:false checked:false

	GroupBox envelopegB2 "Save / Load Envelope" pos:[432,224] width:184 height:48
	button save_env "Env保存" pos:[440,240] width:80 height:24 toolTip:"エンベロープ設定をファイルに保存します"
	button load_env "Env開く" pos:[528,240] width:80 height:24 toolTip:"エンベロープ設定をファイルから読み込みます"




/*######################################################################*/
-----------------------------------------
--スキンモディファイア
-----------------------------------------
/*######################################################################*/
/*スキン追加*/
	on apply_skin_mod pressed do
		(
		sj_bio_skin_plus_rol.apply_default_skin_fn()
		)

/*コピーボーンリスト*/
	on hold_bonelist pressed do
		(
		if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
			(
			bonesinskin = #()
			for i=1 to (skinops.getnumberBones selection[1].modifiers["Skin"]) do
				(
				append bonesinskin (skinOps.getbonename selection[1].modifiers["Skin"] i 0)
				)
			)
		)

/*ペーストボーンリスト*/
	on paste_bonelist pressed do
		(
		if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
			(
			for i=1 to bonesinskin.count do
				(
				bNode = (execute("$'" + bonesinskin[i] + "'"))
				if (isvalidnode bNode) == true then
					(
					skinOps.addbone selection[1].modifiers["Skin"] bNode 0
					)
				else
					(
					print (bonesinskin[i] + " not found!")
					)
				)
			)
		)

/*ボタンHold*/
	on hold_all pressed do
		(
		max modify mode
		for all in $* do
			(
			c = all.modifiers.count
			for i=1 to c do
				(
				if (classof all.modifiers[i]) == Skin then
					(
					bone_array = #()
					
					select all
					my_env_file = ((getdir #import) + "\\" + all.name) + ".tev"
					sj_bio_skin_plus_rol.save_env_data_fn my_env_file 

					my_vert_file = ((getdir #import) + "\\" + all.name) + ".tvw"
					sj_bio_skin_plus_rol.save_vert_data_fn my_vert_file
					
					bone_array = (sj_bio_skin_plus_rol.bones_in_skin_fn())
					insertItem all bone_array 1

 					append tagged_nodes bone_array

					deleteModifier all all.modifiers["Skin"]
					)
				)--end for i
			)--end for all 			gc light:true
		)

/*fetch_allアクション*/
	on fetch_all pressed do
		(
		undo "Fetch" on
			(
			silent = true -- makes sure the user doesn't need to pick a envelope file.
			for i=1 to tagged_nodes.count do
				(
				select tagged_nodes[i][1]
				sj_bio_skin_plus_rol.apply_default_skin_fn addbones:false
				feed_file = ((getdir #import) + "\\" + tagged_nodes[i][1].name) + ".tev"
				for t=1 to (tagged_nodes[i].count - 1) do
					(
					skinOps.addbone selection[1].modifiers["Skin"] tagged_nodes[i][t+1] 0
					)
				sj_bio_skin_plus_rol.load_env.pressed()
				sj_load_mapping_rol.exclude_vert_met.state = 2 -- restore excluded verts by index
				sj_load_mapping_rol.transfer_env.pressed()
	
				feed_file = ((getdir #import) + "\\" + tagged_nodes[i][1].name) + ".tvw"
				sj_bio_skin_plus_rol.load_verts.pressed()
				sj_load_verts_rol.bone_ident.checked = true
				sj_load_verts_rol.vert_met.state = 1 -- restore vertex weights by index
				sj_load_verts_rol.set_weights.pressed()
				) 	
			try (destroydialog sj_load_mapping_rol) catch()
			try (destroydialog sj_load_verts_rol) catch() 	
			silent = false		
			--gc light:true
			)--end undo
		)

/*******************************************************
未使用ボーンを削除
********************************************************/
	on del_non_used_boneBt pressed do
	(
	--プログレス処理
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
	
	--ボーン格納用やカウント用
	local use_w = #(),use_bone_index = #(), boneCountA = 0, boneCountB = 0;
	local non_used = #(), del_bone_num = 0, myObj = selection[1];
	
	if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then --モヂファイア判定
	(
		--ボーンはあるか?
		if skinOps.GetNumberBones myObj.skin != 0 then
		(
		vert_count = myObj.verts.count;	
		--頂点毎、ウェイと状態を調査
			for i=1 to vert_count do
			(
				--選択された頂点に影響する（手動修正で0でも）ボーン数だけ繰り返す
		 		for u = 1 to (skinops.GetVertexWeightCount myObj.skin i) do
				(
					--現在の頂点に影響するボーンのウェイト値が0より大きかった場合
					if skinops.getVertexWeight myObj.skin i u > 0 do
					(
						--ボーンインデックスを配列に追加　iは現在の頂点、uは影響ボーン数
						append use_bone_index (skinops.getvertexweightboneID myObj.skin i u);
					);--if end
				);--for end
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = ((100.00/vert_count) * i);
			
			)--for end
			
		--ここから削除作業
			boneCountA = skinOps.GetNumberBones myObj.skin	--使用しているボーン数
			boneCountB = skinOps.GetNumberBones myObj.skin	--カウント用
			
			--終わりからなのでBoneIDが変更されても問題はない
			while boneCountA > 0 do
			(
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = (( 100.0/boneCountB ) * (boneCountB - boneCountA));
			
				if findItem use_bone_index (boneCountA) == 0 do	--配列からboneIDが見つからなかった場合
				(
					append non_used (skinOps.getBoneName myObj.skin boneCountA 0)
					skinOps.removebone myObj.skin boneCountA	--削除
					del_bone_num += 1
				)--if end
			
			boneCountA -= 1
	
			)--while end
			
			if non_used.count == 0 then
			(
			messageBox ("未使用のボーンはありませんでした") title:"結果"
			)else
			(
			messageBox ("未使用のボーン" + (del_bone_num as string) + "\n\n" + (non_used as string) + "\n\n" + "を削除しました") title:"結果";
			);--if end
		)else(messageBox ("ボーンがありません") title:"結果");--if end
		
	)else()--モディファイア判定if end
	
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();

	);--all end

/*******************************************************
ボーンリストを保存する
********************************************************/
	on save_boneListBt pressed do
	(
		local save_bone_name
		--ファイルフォーマット
		local save_file = getSaveFileName caption:"ボーンを保存" types:"Bone List File(*.blf)|*.blf|Text(*.txt)|*.txt";
		
		if save_file != undefined do
		(
		print save_file
		out_bonelist = createfile save_file --ファイルを作成
		print out_bonelist
			for i=1 to (skinops.getnumberBones selection[1].modifiers["Skin"]) do --スキンモディファイア内に含まれるボーンの数
				(
				save_bone_name = (skinOps.getbonename selection[1].modifiers["Skin"] i 0) --スキンモディファイアに含まれるボーン名を代入（iは配列数）
				--append skinskin (skinOps.getbonename selection[1].modifiers["Skin"] i 0)
				format "%\n" save_bone_name to:out_bonelist
				--print Bname
				);--for end
		);--if end
	);--all end

/*******************************************************
ボーンリストを読み込む
********************************************************/
	on load_boneListBt pressed do
	(
		local load_bone_name
		 --ファイルフォーマット ファイルを読み取る
		local load_file = getOpenFileName caption:"ボーンを読み込み" types:"Bone List File(*.blf)|*.blf|Text(*.txt)|*.txt";
		
		if load_file != undefined do
		(
		in_bonelist = openFile load_file --ファイルの内容を流し込む
			while not eof in_bonelist do --文字列がファイルに残っている場合はtrueを返します　eofはファイルにデータが残っていない場合は true、データが残っている場合は false を返します。
				(
				load_bone_name =  (execute("$'" + readLine in_bonelist + "'")) --一行ずつ変数に代入
				print load_bone_name --load_bone_nameの内容をリスナーに表示
				skinOps.addbone selection[1].modifiers["Skin"] load_bone_name 0 --変数内の文字列をボーンリストに追加
				--append numLine (execute("$'" + readLine in_bone + "'")) --配列に追加
				);
		);--if end
	)--all end

/*######################################################################*/
-----------------------------------------
--設定
-----------------------------------------
/*######################################################################*/
/*show_planeアクション*/
	on show_plane changed state do
		(
		if show_plane.checked == true then
			(
			if $'mirror_vert_plane' != undefined then
				(
				delete $'mirror_vert_plane'
				)
			p = plane()
			p.name = "mirror_vert_plane"
			p.wirecolor = (color 255 122 0)
			p.boxmode = true
			p.rotation = (eulerangles 0 90 0)
			p.position = [sj_bio_skin_plus_rol.x_offset.value,0,100]
			p.width = 100
			p.length = 100
			p.lengthsegs = 1
			p.widthsegs = 1
			)
		else
			(
			if $'mirror_vert_plane' != undefined then
				(
				delete $'mirror_vert_plane'
				)
			)
		
		)

/*x_offsetアクション*/
	on x_offset changed val do
		(
		if $'mirror_vert_plane' != undefined then
			(
			$'mirror_vert_plane'.pos.x = sj_bio_skin_plus_rol.x_offset.value
			)
		)

/*tar_skinアクション*/
	on tar_skin picked obj do
		(
		target_skin = obj
		tar_skin.text = obj.name
		)

/*######################################################################*/
-----------------------------------------
--頂点
-----------------------------------------
/*######################################################################*/
/*fix_vert_weightsアクション*/
	on fix_vert_weights pressed do
		(
		undo "fix weights" on
			(
			sj_bio_skin_plus_rol.function_shell_fn sj_bio_skin_plus_rol.fix_not_weighted_verts_fn scheck:false
			)
		)

/*fix_selvert_weightsアクション*/
	on fix_selvert_weights pressed do
		(
		undo "fix sel weights" on
			(
			sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.fix_not_weighted_verts_fn allverts:false) parms:true
			)
		)

/*adapt_allアクション*/
 	on adapt_all pressed do
		(
		undo "adapt all" on
			(
			sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.adapt_verts_fn allverts:true) parms:true
			)
		)

/*adapt_selアクション*/
	on adapt_sel pressed do
		(
		undo "adapt selection" on
			(
			sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.adapt_verts_fn allverts:false) parms:true
			)
		)

/*is_mod_tagアクション*/
	on is_mod_tag mouseover do
		(
		if selection.count > 0 then
			(
			if (selection[1].modifiers["Skin"]) != undefined and getcommandpaneltaskmode() == #modify then
				(
				skin_dex = (modPanel.getModifierIndex selection[1] selection[1].modifiers["Skin"])
				if skin_dex == (modPanel.getModifierIndex selection[1] (modPanel.getCurrentObject())) and subobjectlevel == 1 then
					(
					local sel_verts = (sj_bio_skin_plus_rol.tact_skinselectedverts selection[1].modifiers["Skin"])
					local vert_mode = undefined
			
					for i=1 to sel_verts.count do
						(
						if (skinOps.IsVertexModified selection[1].modifiers["Skin"] sel_verts[i]) == 1 then
							(
							if vert_mode == false then
								(
								is_vert_mod.text = "頂点は手動修正か?  混合しています"
								)
							if vert_mode == true or vert_mode == undefined then
								(	
								vert_mod = true
								is_vert_mod.text = "頂点は手動修正か?  はい"
								)
							)--end if
						else
							(
 							if vert_mode == false  or vert_mode == undefined then
								(
								vert_mode = false
								is_vert_mod.text = "頂点は手動修正か?  いいえ"
								)
							else
								(
								is_vert_mod.text = "頂点は手動修正か?  混合しています"
								)
							)
						)--end for i
					)
				)
			)--end if
		)

/*mirror_sel_vertsアクション*/
	on mirror_sel_verts pressed do
		( 		
		undo "mirror sel verts" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				if target_skin != undefined then
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn oSkin:target_skin.modifiers["Skin"]) parms:true
					)
				else
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn oSkin:undefined) parms:true
					)
				)		
			)--end undo
		)

/*mirror_mod_vertsアクション*/
	on mirror_mod_verts pressed do
		(
		undo "mirror modified verts" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				if target_skin != undefined then
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn mod_only:true oSkin:target_skin.modifiers["Skin"]) parms:true
					)
				else
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn mod_only:true oSkin:undefined) parms:true
					)
				)		
			)--end undo
		)

/*paste_vertsアクション*/
	on paste_verts pressed do
		(
		undo "paste verts" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				if target_skin != undefined then
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn mod_only:false oSkin:target_skin.modifiers["Skin"] mirror:false) parms:true
					)
				else
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_sel_verts_fn mod_only:false oSkin:undefined mirror:false) parms:true
					)
				)		
			)--end undo
		)

/*clean_vertsアクション*/
	on clean_verts pressed do
		(
		sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.clean_verts_fn) parms:false scheck:false
		)

/*select_af_vertsアクション*/
	on select_af_verts pressed do
		(
		sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.select_affected_verts_fn) parms:false
		)

/*print_af_bonesアクション*/
	on print_af_bones pressed do
		(
		sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.bones_affecting_vert_fn) parms:false
		)

/*expand_elementアクション*/
	on expand_element pressed do
		(
		sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.expand_element_fn) parms:false
		)

	------------------------------------------------------------
	-- SAVE LOAD verts
	------------------------------------------------------------
/*save_vertsアクション*/
	on save_verts pressed do
		(
		if (sj_bio_skin_plus_rol.validate_skin_fn subcheck:false) == true then
			(
			local my_file = getSaveFileName types:"Tact_VertexWeights(*.tvw)|*.tvw"
			)

		if my_file != undefined then
			(
			sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.save_vert_data_fn my_file) parms:true
			)
		)


/*load_vertsアクション*/
	on load_verts pressed do
		(
		local vert_array = #()

		if silent == false then
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn subcheck:false) == true then
				(
				local my_file = getOpenFileName types:"Tact_VertexWeights(*.tvw)|*.tvw"
				)
			)
		else
			(
			my_file = feed_file
			)


		if my_file != undefined then 			
			(
			vert_array = sj_bio_skin_plus_rol.load_vert_data_fn my_file

 
			global sj_load_verts_rol
			try (destroydialog sj_load_verts_rol) catch()
			
			/*######################################################################*/
			------------------------------------------------------------
			-- Rollout /*頂点情報読み込み時のマッピングロールアウト*/
			------------------------------------------------------------
			/*######################################################################*/
			rollout sj_load_verts_rol "Load Vertices"
				(

				local vert_array
				local src_width=230

				button del_from "Del ->" pos:[5,20] width:44

				button save_fromlist "Save" pos:[5,50] width:44
				button load_fromlist "Load" pos:[5,74] width:44

				listbox source_list "FROM" pos:[55, 5] width:src_width height:24 -- source objects listview listbox target_list "TO" pos:[src_width+5+55, 5] width:src_width height:24 -- current objects listview		  			
				listbox target_list "TO" pos:[src_width+5+55, 5] width:src_width height:24 -- current objects listview		  			

				label source_num "(0 Bones)" pos:[55+150,5]
				label target_num "(0 Bones)" pos:[src_width+5+55+150, 5]
				
				radiobuttons vert_met "適応方法:" labels:#("頂点インデックス","ワールドポジション","ボーンからの相対距離") columns:4 default:1 align:#left pos:[55, 344] width:465 
				label vert_count "0 頂点読み込み済み" across:3
				checkbox mod_only "バーテックスの情報のみ" checked:true
				checkbox bone_ident "ボーンインデックス含む" checked:false

				button set_weights "セットウェイト！" pos:[55, 404] width:465

				button del_to "<- Del" pos:[475+50,20] width:44

				button move_up "UP" pos:[475+50,64] width:44
				button move_down "DOWN" pos:[475+50,86] width:44
				button move_up10 "UP 10" pos:[475+50,128] width:44
				button move_down10 "DWN10" pos:[475+50,150] width:44
				
				button save_tolist "Save" pos:[475+50,180] width:44
				button load_tolist "Load"pos:[475+50,204] width:44

				------------------------------------------------------------
				-- Interface Events
				------------------------------------------------------------


				on sj_load_verts_rol open do
					(
					local the_array = #()
					for each in sj_bio_skin_plus_rol.bones_in_skin_fn() do
						(
						append the_array each.name
						)
					the_array = sort the_array
					target_list.items = the_array
 					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)



				on sj_load_verts_rol close do
					(
					sj_load_verts_rol = undefined
					)


				on save_tolist pressed do
					(
					sj_bio_skin_plus_rol.save_list_fn target_list.items
					)

				on load_tolist pressed do
					(
					target_list.items = (sj_bio_skin_plus_rol.load_list_fn target_list.items)
					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)


				on save_fromlist pressed do
					(
					sj_bio_skin_plus_rol.save_list_fn source_list.items
					)

				on load_fromlist pressed do
					(
					source_list.items = (sj_bio_skin_plus_rol.load_list_fn source_list.items)
					source_num.text = ("(" + source_list.items.count as string + " bones)")
					)


				on del_from pressed do
					(
					deleteitem source_list.items source_list.selection
					source_list.items = source_list.items
					source_num.text = ("(" + source_list.items.count as string + " bones)")
					)


				on del_to pressed do
					(
					deleteitem target_list.items target_list.selection
					target_list.items = target_list.items
					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)



				on move_down pressed do
					(
					if target_list.selection < target_list.items.count then
						(
						next = target_list.items[target_list.selection+1]
						target_list.items[target_list.selection+1] = target_list.selected
						target_list.items[target_list.selection] = next
						target_list.items = target_list.items
						target_list.selection += 1
						source_list.selection = target_list.selection
						)
					)



				on move_up pressed do
					(
					if target_list.selection > 1 then
						(
						next = target_list.items[target_list.selection-1]
						target_list.items[target_list.selection-1] = target_list.selected
						target_list.items[target_list.selection] = next
						target_list.items = target_list.items
						target_list.selection -= 1
						source_list.selection = target_list.selection
						)
					)



				on move_down10 pressed do
					(
					if target_list.selection < (target_list.items.count - 10) then
						(
						next = target_list.items[target_list.selection+10]
						insertItem target_list.selected target_list.items (target_list.selection+10)
						deleteItem target_list.items target_list.selection
						target_list.items = target_list.items
						target_list.selection += 9
						source_list.selection = target_list.selection
						)
					)



				on move_up10 pressed do
					(
					if target_list.selection > (1 + 10) then
						(
						next = target_list.items[target_list.selection-10]
						insertItem target_list.selected target_list.items (target_list.selection-10)
						deleteItem target_list.items (target_list.selection+1)
						target_list.items = target_list.items
						target_list.selection -= 9
						source_list.selection = target_list.selection
						)
					)




				on set_weights pressed do
					(
					--プログレス処理
					sj_functions.sj_progressBar_Fn();					
					sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
					
					vert_pos_array = #()
				
					for c=1 to selection[1].verts.count do
						(
						p = (at time 0 selection[1].verts[c].pos)
						append vert_pos_array p
						)


					for i=1 to vert_array.count do
						(
						local bn
						if vert_array[i][4] == 1 or mod_only.checked == false then
							( 							local first_bone
							local vert_data = #()
							for b=1 to vert_array[i][5].count do -- need to find the new bone name.
								( 								local new_bone_name
								new_bone_name = vert_array[i][6][b]
								
								-- We check wheter bone exists in list. If not, then we don't set the weights for that bone.
								-- If a vertex is weighted to two or more bones, and one is missing from the list,
								-- funny things might happen with the weights of that vertex though.
								bn = finditem source_list.items new_bone_name
								if bn != 0 then
									(
									new_bone_name = target_list.items[bn]
									
										
									if b==1 then (first_bone = new_bone_name) -- used for relative to bone vertex searching
	
									if bone_ident.checked == false then -- find bone by name
										(
										bone_index = sj_bio_skin_plus_rol.tact_boneindex new_bone_name selection[1].modifiers["Skin"]
										)
									else
										(
										bone_index = vert_array[i][5][b] -- grab the bone index from the file.
										)
	
									local w = #()
									if bone_index != 0 then
										(
										append w bone_index
										append w vert_array[i][7][b]
										)
									append vert_data w
									)--end if bn
								)--end b
								
							if bn != 0 then
								(
 								case vert_met.state of
									(
									-- Find verts by index
									1:(
										sj_bio_skin_plus_rol.set_vertex_data_fn vert_array[i][1] vert_data
										)
	
									-- Find closest vert by world pos
									2:(
 										y = 99999
										local c_index = 0
										local t = distance [0,0,0] [(sj_bio_skin_plus_rol.thres.value/100) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/100),(sj_bio_skin_plus_rol.thres.value/100)]
	
										for d=1 to vert_pos_array.count do
											(
											g = distance vert_array[i][2] vert_pos_array[d]
											if g < t then
												(
												if g < y then
													(
													y = g
													c_index = d
													)
												)
											)
	
										if c_index != 0 then
											(
											sj_bio_skin_plus_rol.set_vertex_data_fn c_index vert_data
											)
									
										)--end 2 										
									-- Find verts relative to bone pos.
									
									3:(
									
										y = 99999
										local c_index = 0
										local t = distance [0,0,0] [(sj_bio_skin_plus_rol.thres.value/100) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/100),(sj_bio_skin_plus_rol.thres.value/100)]
	
										m = execute("$'" + first_bone + "'")
										for d=1 to vert_pos_array.count do
											(
											if classof m != Biped_Object then
												g = distance (vert_array[i][3] + (at time 0 m.pos)) vert_pos_array[d]
											else
												g = distance (vert_array[i][3] + (at time 0 (biped.gettransform m #pos)) ) vert_pos_array[d]
											if g < t then
												(
												if g < y then
													(
													y = g
													c_index = d
													)
												)
											)
	
										if c_index != 0 then
											(
											sj_bio_skin_plus_rol.set_vertex_data_fn c_index vert_data
											)
									
										)--end 3
										
									)--end case of
								)--end bn
							)--end if
						
						--プログレス処理
						sj_progressBar_rol.progbar.value = ((100.00/vert_array.count) * i)
						)--end i
					try (destroydialog sj_load_verts_rol) catch()
					--gc light:true
					--プログレス処理
					try(destroydialog sj_progressBar_rol)catch();
					)


			------------------------------------------------------------
			-- Create Dialog
			------------------------------------------------------------
				)--end rollout
			CreateDialog sj_load_verts_rol width:574 height:430 pos:[250,50] \
			style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox)

			sj_load_verts_rol.vert_array = vert_array
			sj_load_verts_rol.vert_count.text = (vert_array.count as string + " Vertices Loaded")
	
			bone_array = #()
			for i=1 to vert_array.count do
				(
				b = for each in vert_array[i][6] collect each
				for each in b do 
					(
					if (finditem bone_array each) == 0 then append bone_array each
					)
				)
			sort bone_array
	
			sj_load_verts_rol.source_list.items = (for each in bone_array collect each)
			sj_load_verts_rol.source_num.text = ("(" + sj_load_verts_rol.source_list.items.count as string + " bones)")			
	
			--gc light:true
			)--end my_file undefined

		)--end button

/*######################################################################*/
-----------------------------------------
--エンベロープ
-----------------------------------------
/*######################################################################*/
/*in_radius_stagアクション*/
	on in_radius_stag mouseover do
		(
		sj_bio_skin_plus_rol.update_radius_spinners_fn (sj_bio_skin_plus_rol.number_of_cross_fn())
		)

/*in_radius_stagアクション*/
	on in_radius_etag mouseover do
		(
		sj_bio_skin_plus_rol.update_radius_spinners_fn 1
		)

/*in_radius_startアクション*/
	on in_radius_start changed val do
		(
		last_spin = "start"
		sj_bio_skin_plus_rol.update_radiuses_fn (sj_bio_skin_plus_rol.number_of_cross_fn()) val
		)

/*in_radius_endアクション*/
	on in_radius_end changed val do
		(
		last_spin = "end"
		sj_bio_skin_plus_rol.update_radiuses_fn 1 val
		)

/*spn_gapアクション*/
	on spn_gap changed val do
		(
		if last_spin == "end" then
			(
			sj_bio_skin_plus_rol.update_radiuses_fn 1 sj_bio_skin_plus_rol.in_radius_end.value
			)
		else
			(
			sj_bio_skin_plus_rol.update_radiuses_fn (sj_bio_skin_plus_rol.number_of_cross_fn()) sj_bio_skin_plus_rol.in_radius_start.value
			)
		)

/*copy_envアクション*/
	on copy_env pressed do
		(
		if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
			(
			bdex = (skinOps.getSelectedBone selection[1].modifiers["Skin"])
			env_buffer = #(bdex, (sj_bio_skin_plus_rol.gather_enveloppe_data_fn bdex selection[1].modifiers["Skin"] exclude:false))
			)
		)

/*paste_envアクション*/
	on paste_env pressed do
		(
		undo "paste envelope" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				sj_bio_skin_plus_rol.set_envelope_data_fn env_buffer[2] env_buffer[1] (skinOps.getSelectedBone selection[1].modifiers["Skin"]) selection[1].modifiers["Skin"] mirror:false
				)
			)--end undo
		)

/*tpaste_envアクション*/
	on tpaste_env pressed do
		(
		undo "paste envelope" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				if target_skin == undefined then
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_env_fn mirror:false) parms:true garbage:false
					)
				else
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_env_fn oSkin:target_skin.modifiers["Skin"] mirror:false) parms:true garbage:false
					)
				)
			)--end undo
		)

/*mirror_envアクション*/
	on mirror_env pressed do
		(
		undo "mirror envelope" on
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn() == true) then
				(
				if target_skin == undefined then
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_env_fn) parms:false garbage:false
					)
				else
					(
					sj_bio_skin_plus_rol.function_shell_fn (sj_bio_skin_plus_rol.mirror_env_fn oSkin:target_skin.modifiers["Skin"]) parms:true garbage:false
					)
				)
			)--end undo
		)

/*エンベロープ保存、読み込み時のロールアウト*/
	------------------------------------------------------------
	-- SAVE LOAD Envelopes
	------------------------------------------------------------
/*save_envアクション*/
	on save_env pressed do
		(
		if (sj_bio_skin_plus_rol.validate_skin_fn subcheck:false) == true then
			(
			local my_file = getSaveFileName types:"Tact_Envelope(*.tev)|*.tev"
 			if my_file != undefined then
				(
				sj_bio_skin_plus_rol.save_env_data_fn my_file
				--gc light:true
				)--if my file end
			)--if end
		)--Pressed end

/*load_envアクション*/
	on load_env pressed do
		(
		if silent == false then
			(
			if (sj_bio_skin_plus_rol.validate_skin_fn subcheck:false) == true then
				(

 				local my_file = getOpenFileName types:"Tact_Envelope(*.tev)|*.tev"
				)
			else
				(
				messagebox "Pick Skin first"
				my_file = undefined
				)--if sj_bio_skin_plus_rol.... end
			)
		else 
			( 
			my_file = feed_file
			)--if silent end

		if my_file != undefined then
			(

			global sj_load_mapping_rol
			try (destroydialog sj_load_mapping_rol) catch()
			
			/*######################################################################*/
			------------------------------------------------------------
			-- Rollout
			------------------------------------------------------------
			/*######################################################################*/
			rollout sj_load_mapping_rol "Load Envelopes"
				(

				local src_width=230
				local my_env_data = #()

				button del_from "Del ->" pos:[5,20] width:44

				button save_fromlist "Save" pos:[5,50] width:44
				button load_fromlist "Load" pos:[5,74] width:44

				listbox source_list "FROM" pos:[55, 5] width:src_width height:24 -- source objects listview
 				listbox target_list "TO" pos:[src_width+5+55, 5] width:src_width height:24 -- current objects listview		  			

				label source_num "(0 Bones)" pos:[55+150,5]
				label target_num "(0 Bones)" pos:[src_width+5+55+150, 5]
				
				radiobuttons exclude_vert_met "頂点の適応方法" labels:#("適応しない","頂点インデックス","ワールドポジション","ボーンからの相対距離") columns:4 default:1 align:#left 	pos:[55, 344] width:465

				radiobuttons load_gizmo_met "頂点ギズモ" labels:#("適応しない","頂点インデックス","ワールドポジション","バウンディングボックス") columns:4 default:1 align:#left 	pos:[55, 384] width:465 enabled:false

				button transfer_env "エンベロープ適応" pos:[55, 424] width:465

				button del_to "<- Del" pos:[475+50,20] width:44

				button move_up "UP" pos:[475+50,64] width:44
				button move_down "DOWN" pos:[475+50,86] width:44
				button move_up10 "UP 10" pos:[475+50,128] width:44
				button move_down10 "DWN10" pos:[475+50,150] width:44

				button save_tolist "Save"pos:[475+50,180] width:44
				button load_tolist "Load"pos:[475+50,204] width:44


				------------------------------------------------------------
				-- Interface Events
				------------------------------------------------------------


				on sj_load_mapping_rol open do
					( 
					local the_array = #()
					for each in sj_bio_skin_plus_rol.bones_in_skin_fn() do
						(
						append the_array each.name
						)
					the_array = sort the_array
					target_list.items = the_array
					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)



				on sj_load_mapping_rol close do
					(
					sj_load_mapping_rol = undefined
					)


				on save_tolist pressed do
					(
					sj_bio_skin_plus_rol.save_list_fn target_list.items
					)

				on load_tolist pressed do
					(
					target_list.items = (sj_bio_skin_plus_rol.load_list_fn target_list.items)
					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)


				on save_fromlist pressed do
					(
					sj_bio_skin_plus_rol.save_list_fn source_list.items
					)

				on load_fromlist pressed do
					(
					source_list.items = (sj_bio_skin_plus_rol.load_list_fn source_list.items)
					source_num.text = ("(" + source_list.items.count as string + " bones)")
					)


				on del_from pressed do
					(
					deleteitem source_list.items source_list.selection
					source_list.items = source_list.items

 					source_num.text = ("(" + source_list.items.count as string + " bones)")
					)

 
				on del_to pressed do
					(
					deleteitem target_list.items target_list.selection
					target_list.items = target_list.items
					target_num.text = ("(" + target_list.items.count as string + " bones)")
					)


				on move_down pressed do
					(
					if target_list.selection < target_list.items.count then
						(
						next = target_list.items[target_list.selection+1]
						target_list.items[target_list.selection+1] = target_list.selected
						target_list.items[target_list.selection] = next
						target_list.items = target_list.items
						target_list.selection += 1
						source_list.selection = target_list.selection
						)
					)



				on move_up pressed do
					(
					if target_list.selection > 1 then
						(
						next = target_list.items[target_list.selection-1]
						target_list.items[target_list.selection-1] = target_list.selected
						target_list.items[target_list.selection] = next
						target_list.items = target_list.items
						target_list.selection -= 1
						source_list.selection = target_list.selection
						)
					)
				


				on move_down10 pressed do
					(
					if target_list.selection < (target_list.items.count - 10) then
						(
						next = target_list.items[target_list.selection+10]
						insertItem target_list.selected target_list.items (target_list.selection+10)
						deleteItem target_list.items target_list.selection
						target_list.items = target_list.items
						target_list.selection += 9
						source_list.selection = target_list.selection
						)
					)



				on move_up10 pressed do
					(
					if target_list.selection > (1 + 10) then
						(
						next = target_list.items[target_list.selection-10]
						insertItem target_list.selected target_list.items (target_list.selection-10)
						deleteItem target_list.items (target_list.selection+1)
						target_list.items = target_list.items
						target_list.selection -= 10
						source_list.selection = target_list.selection
						)
					)


 				on transfer_env pressed do
					(
					--プログレス					
					sj_functions.sj_progressBar_Fn();
					sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
					--transfer envelope data from my_env_data to the envelopes in the target list.
					-- Make sure to transfer the data in the right order.
					x = subobjectlevel
					for i=1 to my_env_data[1].count do --source_list.items.count do
						(
						bis = (finditem source_list.items my_env_data[1][i])
						--check wheter bone exists in from_list or not
						if bis != 0 then
							(
							tar_bone = (sj_bio_skin_plus_rol.tact_boneindex target_list.items[bis] selection[1].modifiers["Skin"])
							if tar_bone != 0 then
								(
								sj_bio_skin_plus_rol.set_envelope_data_fn (execute(my_env_data[2][i])) tar_bone tar_bone selection[1].modifiers["Skin"] mirror:false -- src_bone = trg_bone in this case
								)--end if
							)
						
						--プログレス処理
						sj_progressBar_rol.progbar.value = ((100.00/source_list.items.count) * i)
						)--end for
						
					if load_gizmo_met.state != 1 then
						(
						 -- transfer gizmos:
						giz_dat = execute(my_env_data[3])
						
						--プログレス処理
						sj_progressBar_rol.progbar.value = 0;

						for g=1 to 1 do -- giz_dat.count do
							(
							sj_bio_skin_plus_rol.set_gizmo_data_fn giz_dat[g] selection[1].modifiers["Skin"] method:load_gizmo_met.state;
							
							--プログレス処理
							sj_progressBar_rol.progbar.value = ((100.00/giz_dat.count) * g);
							)
						skinOps.Invalidate selection[1].modifiers["Skin"] 1
						)
					
					--プログレス処理					
					sj_progressBar_rol.progbar.value = 0;
					try(destroydialog sj_load_mapping_rol)catch();
					try(destroydialog sj_progressBar_rol)catch();
					subobjectlevel = x
					)


			------------------------------------------------------------
			-- Create Dialog
			------------------------------------------------------------
				)--end rollout
			CreateDialog sj_load_mapping_rol width:574 height:450 pos:[50,50] \ 
			style:#(#style_border, #style_titlebar, #style_sysmenu, #style_minimizebox)

			local my_env_data = (sj_bio_skin_plus_rol.load_env_data_fn my_file)
			sj_load_mapping_rol.my_env_data = my_env_data
			sj_load_mapping_rol.source_list.items = (for each in my_env_data[1] collect each) -- be sure to re-create the array, or it will be a instance of the array, which will screw things up when you delete nodes from the list.
			sj_load_mapping_rol.source_num.text = ("(" + sj_load_mapping_rol.source_list.items.count as string + " bones)")			
			
			)--end if my_file undefined
			
		)--load_env end button


)--end bio_ski_Plus_Rol (Main) rollout
CreateDialog sj_bio_skin_plus_rol menu:bio_skin_plusMenuBar pos:[50,50] style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox) menu:CanvasMenu


)--end macroscript
