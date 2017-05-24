
------------------------------------------------------------------------------------------------------------------------
--ここからファクション
------------------------------------------------------------------------------------------------------------------------
	/*
	# Function     : validate_skin_fn
	# Description  : Does some basic checks to see if we have a skin modifier and such
	# 内容	:スキンモディファイアがあるか確認するための基本的なチェックを行います
	# Parameters : 
	# Returns     : true, if everything is ok, false if it's not.
	*/
	fn validate_skin_fn subcheck:true quite:false =
		(
		local validated = false
		if selection.count > 0 then
			(
			if (selection[1].modifiers["Skin"]) != undefined then
				(
				if getcommandpaneltaskmode() != #modify then
					(
					max modify mode
					)
	
				skin_dex = (modPanel.getModifierIndex selection[1] selection[1].modifiers["Skin"])
				if skin_dex != (modPanel.getModifierIndex selection[1] (modPanel.getCurrentObject())) then
					(
					modPanel.setCurrentObject selection[1].modifiers[skin_dex]
					)
	
				if subcheck == true and subobjectlevel != 1 then
					(
					subobjectlevel = 1
					)
				validated = true
				)
			)
		else
			(
			if quite == false then
				(
				messagebox "Please make sure you are in the modify panel with Skin selected"
				)
			)

		return validated
		)

	/*
	# Function     : function_shell_fn
	# Description  : Runs functions with proper defaults
	# Parameters : func:(which function to run)
	# Returns     : 
	*/
	fn function_shell_fn func parms:false scheck:true garbage:true =
		(
		with redraw off
			(
			with undo off
				(
				with animate off
					(
					if (validate_skin_fn subcheck:scheck) == true then
						(
						if parms == true then
							(
							func
							)
						else
							(
							func()
							)
						)--end if
					)--animate
				)--undo
			)--redraw
		if garbage == true then ()--gc light:true)
		)

	/*
	# Function     : tact_format_fn
	# Description  : Works around the 20 item limit when formatting arrays to disk
	# 記述	:配列をフォーマットするときに限界を20にする作業？？
	# Parameters : my_array:(array of items) output:(output file to format to)
	# Returns     : 
	*/
	fn tact_format_fn my_array output sep:true=
		(
		if classof my_array == Array or classof my_array == ArrayParameter then
			(
			format "%" "#(" to:output
			for i=1 to my_array.count do
				(
				if i != my_array.count then 
					(
					tact_format_fn my_array[i] output
					if classof my_array[i] == Array or classof my_array[i] == ArrayParameter then (format "%" ", " to:output)
					)
				else (tact_format_fn my_array[i] output sep:false)
				)
			format "%" ")" to:output
			)
		else
			(
			if classof my_array != string then
				format "%" my_array to:output
			else
				format "\"%\"" my_array to:output
			if sep == true then (format "%" "," to:output)
			)
		)


/*
ロールアウトリフレッシュ　旧機能のためコメントアウト
*/
	/*
	# Function     : refreshmyrollouts
	# Description  : Resizes and Repositions subrollouts
	# Parameters : 
	# Returns     : 
	*/
/*	fn refreshmyrollouts =
		(
		try(
		local modrol = 0
		local envrol = 0
		local verrol = 0
		local setrol = 0
		if sj_bio_skin_plus_rol.skinmodifier.skinmodifier_rol.open == true then modrol += 200
		if sj_bio_skin_plus_rol.skinenvelope.skinenvelope_rol.open == true then envrol += 195
		if sj_bio_skin_plus_rol.skinvertices.skinvertices_rol.open == true then verrol += 235
		if sj_bio_skin_plus_rol.open == true then setrol += 110

		sj_bio_skin_plus_rol.skinenvelope.pos = [1,(78 + modrol)]
		sj_bio_skin_plus_rol.skinvertices.pos = [1,(107 + modrol + envrol)]
		sj_bio_skin_plus_rol.skinsettings.pos = [1,(136 + modrol + envrol + verrol)]
		)catch()
		)
*/

	/*スキン追加ファンクション*/
	/*
	# Function     : apply_default_skin_fn
	# Description  : Applies a skin modifier and sets a few defaults
	# Parameters : addbones:(wether to add a collection of bones or not)
	# Returns     : 
	*/
	fn apply_default_skin_fn addbones:true defs:biodef =
		(
		addmodifier selection[1] (Skin())

		if defs == true then
			(
			selection[1].modifiers[#Skin].initialInnerEnvelopePercent = 0.95 * ((sj_bio_skin_plus_rol.char_fat.value / 100.00)*0.8)
			selection[1].modifiers[#Skin].initialOuterEnvelopePercent = 2.1 * ((sj_bio_skin_plus_rol.char_fat.value / 100.00)*0.8)
			selection[1].modifiers[#Skin].bone_Limit = 3
			selection[1].modifiers[#Skin].shortenBoneNames = true
			selection[1].modifiers[#Skin].initialStaticEnvelope = false
			)--end atbioware
		)

	/*
	# Function     : fix_not_weighted_verts_fn
	# Description  : Attaches all vertices that are not weighted to a bone to the closest bone it finds to that vertex.
	# Parameters : allverts:(wheter to use all vertices, or only the once that are selected)
	# Returns     : 
	*/
	-- There is a small difference in the way adapt selected and fix selected work.
	-- Fix selected will not weight vertices to the closest bone, if they are already weighted.
	-- Adapt selected WILL re-weight the selected vertex, even if it was already weighted.
	-- This was done on purpose, as this behaviour made more sense to me...
	fn fix_not_weighted_verts_fn allverts:true =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		if (validate_skin_fn subcheck:false) == true then
			(
			local manual_vertices = #()
			for i=1 to (skinOps.GetNumberVertices selection[1].modifiers["Skin"]) do
				(
				if (skinOps.GetVertexWeightCount selection[1].modifiers["Skin"] i) == 0 then -- Vertex is not assigned to any bones
					(
					if ((skinOps.IsVertexSelected selection[1].modifiers["Skin"] i) == 1) or (allverts == true) then
						(
						local closestbone = 9999999
						local bone_index = 0
						append manual_vertices i
						
						animationrange = (interval 0 animationrange.end)
						curSLTime = currenttime
						slidertime = 0
						
						for t=1 to (skinOps.GetNumberBones selection[1].modifiers["Skin"]) do
							(
							local c = execute("$'" + (skinOps.GetBoneName selection[1].modifiers["Skin"] t 0) + "'")
							local a = length ((at time 0 selection[1].verts[i].pos) - (at time 0 c.center)) -- Compair vert position to bones center
							if a < closestbone then
								(
								closestbone = a
								bone_index = t
								)--end if
							)--end for t
						slidertime = curSLTime
						skinOps.setvertexweights selection[1].modifiers["Skin"] i bone_index 1.0
						)--end if vertsel
					)--end if
				
				--プログレス処理
				sj_progressBar_rol.progbar.value = ((100.00/(skinOps.GetNumberVertices selection[1].modifiers["Skin"])) * i);
				
				)--end for i
			skinOps.SelectVertices selection[1].modifiers["Skin"] manual_vertices
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = 0
			local the_string = (manual_vertices.count as string + " vertices where manually adjusted. They are currently selected in skin.\n")
			the_string += "It is recommended that you make a selection set out of these vertices, so you can tweak them later\n"
			print the_string
			)
		else --  no selection
			(
			messagebox "No objects are selection."
			)
			
		--プログレス
		try(destroydialog sj_progressBar_rol)catch();
		);--end fn
		

	/*
	# Function     : adapt_verts_fn
	# Description  : Adapts all (not weighted) or selected vertices to their closest vertex
	# Parameters : allverts:(wheter to use all vertices, or only the once that are selected)
	# Returns     : 
	*/
	fn adapt_verts_fn allverts:true =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		if (validate_skin_fn subcheck:false) == true then
			(
			local manual_vertices = #()

			vert_pos_array = #()
		
			for i=1 to selection[1].verts.count do
				(
				p = (at time 0 selection[1].verts[i].pos)
				append vert_pos_array p
				)

			vert_count = selection[1].verts.count
			print "Adapted the following vertices:"
			for i=1 to vert_count do
				(
				-- when you pick adapt selected, all vertices will be overwritten, wheter they already had weights or not...
				if /* ((skinOps.GetVertexWeightCount selection[1].modifiers["Skin"] i) == 0) and */ ((skinOps.IsVertexSelected selection[1].modifiers["Skin"] i) == 1) or (allverts == true) and ((skinOps.GetVertexWeightCount selection[1].modifiers["Skin"] i) == 0) then
					(
					print i
					local c = 999999
					local v	= 0				

					for a=1 to vert_pos_array.count do
						(
						-- find closest vertex
						b = distance (at time 0 selection[1].verts[i].pos) vert_pos_array[a]
						if b < c and a != i then -- a != i to make sure we don't grab the same vertex
							(
							if ((skinOps.GetVertexWeightCount selection[1].modifiers["Skin"] a) != 0) then
								(
								c = b
								v = a
								)
							)
						)


					--set weights on selection[1].verts[a] equal to c

					the_weights = #()
					the_bones = #()
					
					for u=1 to (skinops.getvertexweightcount selection[1].modifiers["Skin"] v) do -- find all bones that influence the src_vert.
						(
						src_bone_index = (skinops.getvertexweightboneID selection[1].modifiers["Skin"] v u)
						w = (skinops.getVertexWeight selection[1].modifiers["Skin"] v u)
						append the_weights w
						append the_bones src_bone_index
						)--end for u
		
					skinops.replaceVertexWeights selection[1].modifiers["Skin"] i the_bones the_weights

				
					)--end if
				
				--プログレス処理
				sj_progressBar_rol.progbar.value = ((100.00/vert_count) * i)
				)--end for
			)--end if
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)
	/*
	# Function     : tact_skinselectedverts
	# Description  : Finds all selected vertices in the skin modifier
	# Parameters : 
	# Returns     : 
	*/
	fn tact_skinselectedverts oSkin =
		(
		k = skinops.getnumbervertices oSkin
		selectedverts = #()
		for d = 1 to k do
			(
			if (skinops.isvertexselected oSkin d) == 1 then
				(
				append selectedverts d
				)	
			)
		return selectedverts
		)
	/*
	# Function     : tact_boneindex
	# Description  : Finds the index of a bone
	# Parameters : sBone(Bone name)
	# Returns     : index
	*/		
	fn tact_boneindex sBone oSkin = 
		(
		index = 0
		for k = 1 to (skinops.getnumberbones oSkin) do
			(
			name = skinops.getbonename oSkin k 1
			if name == sBone then
				(
				index = k	
				)	
			)
		return index
		)
	/*
	# Function     : update_radius_spinners_fn
	# Description  : Updates the spinner with the proper values
	# Parameters : radiusnum:(which radius to grab the falloff from)
	# Returns     : 
	*/
	fn update_radius_spinners_fn radiusnum =
		(
		if selection.count > 0 then
			(
			if (selection[1].modifiers["Skin"]) != undefined and getcommandpaneltaskmode() == #modify then
				(
				skin_dex = (modPanel.getModifierIndex selection[1] selection[1].modifiers["Skin"])
				if skin_dex == (modPanel.getModifierIndex selection[1] (modPanel.getCurrentObject())) and subobjectlevel == 1 then
					(
					oSkin = selection[1].modifiers["Skin"]
					wb = skinops.getselectedbone oSkin	
					sj_bio_skin_plus_rol.in_radius_start.value = skinops.getinnerradius oSkin wb (skinOps.getNumberCrossSections oSkin wb)
					sj_bio_skin_plus_rol.in_radius_end.value = skinops.getinnerradius oSkin wb 1
					sj_bio_skin_plus_rol.spn_gap.value = (skinops.getouterradius oSkin wb radiusnum) - (skinops.getinnerradius oSkin wb radiusnum)
					)
				)--end if
			)
		)--end fn
	/*
	# Function     : update_radius_spinners_fn
	# Description  : Updates the spinner with the proper values
	# Parameters : radiusnum:(which radius to use)
	# Returns     : 
	*/
	fn update_radiuses_fn radiusnum val =
		(
		if selection.count > 0 then
			(
			if (selection[1].modifiers["Skin"]) != undefined and getcommandpaneltaskmode() == #modify then
				(
				skin_dex = (modPanel.getModifierIndex selection[1] selection[1].modifiers["Skin"])
				if skin_dex == (modPanel.getModifierIndex selection[1] (modPanel.getCurrentObject())) and subobjectlevel == 1 then
					(
					oSkin = selection[1].modifiers["Skin"]
					wb = skinops.getselectedbone oSkin	
					if sj_bio_skin_plus_rol.lock_radiuses.checked == false then
						(
						skinops.setinnerradius oSkin wb radiusnum val
						skinops.setouterradius oSkin wb radiusnum (val + sj_bio_skin_plus_rol.spn_gap.value)
						)
					else
						(
							for i=1 to (skinOps.getNumberCrossSections oSkin wb) do
								(
								skinops.setinnerradius oSkin wb i val
								skinops.setouterradius oSkin wb i (val + sj_bio_skin_plus_rol.spn_gap.value)
								)
						)
					)--end if
				)
			)
		)--end fn
	/*
	# Function     : number_of_cross_fn
	# Description  : Finds the numbers of crossSections in a enveloppe
	# Parameters : 
	# Returns     : 
	*/
	fn number_of_cross_fn =
		(
		if selection.count > 0 then
			(
			if (selection[1].modifiers["Skin"]) != undefined and getcommandpaneltaskmode() == #modify then
				(
				skin_dex = (modPanel.getModifierIndex selection[1] selection[1].modifiers["Skin"])
				if skin_dex == (modPanel.getModifierIndex selection[1] (modPanel.getCurrentObject())) and subobjectlevel == 1 then
					(
					oSkin = selection[1].modifiers["Skin"]
					wb = skinops.getselectedbone oSkin	
					return (skinOps.getNumberCrossSections oSkin wb)		
					)
				)
			)
		)--end fn
	/*
	# Function     : bones_in_skin_fn
	# Description  : Finds all bones in the skin modifier
	# Parameters : iSkin:(which skin modifier to look in)
	# Returns     : 
	*/
	fn bones_in_skin_fn iSkin:undefined =
		(
		if iSkin == undefined then iSkin = selection[1].modifiers["Skin"]

		if ((validate_skin_fn subcheck:false) == true) then
			(
			local bones_in_skin = #()
			for i=1 to (SkinOps.GetNumberBones iSkin) do
				(
				local bone_name = (skinOps.getBoneName iSkin i 0)
				append bones_in_skin (execute ("$'" + bone_name + "'"))
				)
			return bones_in_skin
			)
		)
	/*
	# Function     : get_exluded_verts_fn
	# Description  : Finds all excluded verts for a bone
	# Parameters : bone_index:(what bone), oSkin:(which skin mod.)
	# Returns     : an array #( #(array of verts_indexes), #(array of vertex world postions), #(vert relative pos) )
	*/
	fn get_exluded_verts_fn bone_index oSkin =
		(
		ex_vert_data = #()
		subobjectlevel = 1
		skinOps.selectBone oSkin bone_index
		skinOps.selectVertices oSkin #()
		skinOps.buttonSelectExcluded oSkin
		excluded_verts = (tact_skinselectedverts oSkin)

		p = #() -- gathers world pos
		for i=1 to excluded_verts.count do
			(
			append p (at time 0 selection[1].verts[excluded_verts[i]].pos)
			)

		b = #() -- gather positions relative to first bone
		src_bone_name = (skinops.getboneName oSkin bone_index 0) -- bone name array
		tnode = (execute("$'" + src_bone_name + "'"))

		if classof tnode == Biped_Object then
			(
			for i=1 to excluded_verts.count do
				(
				append b (at time 0 selection[1].verts[excluded_verts[i]].pos - (at time 0 (biped.gettransform tnode #pos)) ) -- Store position relative to first bone.
				)
			)
		else
			(
			for i=1 to excluded_verts.count do
				(
				append b (at time 0 selection[1].verts[excluded_verts[i]].pos - (at time 0 tnode.pos) ) -- Store position relative to first bone.
				)
			)

		append ex_vert_data excluded_verts
		append ex_vert_data p -- world pos
		append ex_vert_data b -- relative position to the bone

		return ex_vert_data
		)
	/*
	# Function     : set_exluded_verts_fn
	# Description  : sets excluded verts for a bone
	# Parameters : bone_index:(what bone), oSkin:(which skin mod.) vert_array:(array of vertices to exclude)
	# Returns     : 
	*/
	fn set_exluded_verts_fn bone_index oSkin vert_array =
		(
		subobjectlevel = 1
		skinOps.selectBone oSkin bone_index
		skinOps.selectVertices oSkin  #()


		if sj_load_mapping_rol != undefined then
			(
			method = sj_load_mapping_rol.exclude_vert_met.state
			)
		else
			(
			if sj_bio_skin_plus_rol.mirror_excl.checked == true then
				(
				method = 3
				)
			else
				(
				method = 1
				)
			)

		if method == 2 then
			(
			skinOps.selectVertices oSkin vert_array[1] -- vert_array[1] holds indices
			skinOps.buttonExclude oSkin
			)

		if method == 3 then -- world pos
			(
			-- find vertex index by looking at world position stored in vert_array[2]

			vert_pos_array = #()
			for i=1 to selection[1].verts.count do
				(
				p = (at time 0 selection[1].verts[i].pos)
				append vert_pos_array p
				)

			vert_count = vert_array[2].count --vert_array[2] holds world pos of each vertex
			new_vert_array = #()
			for i=1 to vert_count do
				(
				local c = 999999 					
				local v	= undefined

				for a=1 to vert_pos_array.count do
					(
					-- find closest vertex
					b = distance vert_array[2][i] vert_pos_array[a]
					if b < c then
						(
						c = b
						if c < sj_bio_skin_plus_rol.thres.value then
							(
							v = a
							)
						else
							(
							v = undefined -- no vertex found within threshold
							)
						)
					)
				if v != undefined then (append new_vert_array v)
				)--end for i

			skinOps.selectVertices oSkin new_vert_array
			skinOps.buttonExclude oSkin
			)


		if method == 4 then -- relative to bone pos
			(
			-- find vertex index by looking at world position stored in vert_array[2]

			vert_pos_array = #()
			for i=1 to selection[1].verts.count do
				(
				p = (at time 0 selection[1].verts[i].pos)
				append vert_pos_array p
				)

			vert_count = vert_array[3].count --vert_array[1] holds world pos of each vertex
			new_vert_array = #()
			the_bone = execute("$'" + (skinOps.getBoneName oSkin bone_index 0) + "'")

			for i=1 to vert_count do
				(
				local c = 999999 					
				local v	= undefined

				for a=1 to vert_pos_array.count do
					(
					-- find closest vertex
					if classof the_bone == Biped_Object then
						b = distance (vert_array[3][i] + (at time 0 (biped.gettransform tnode #pos))) vert_pos_array[a]
					else
						b = distance (vert_array[3][i] + (at time 0 the_bone.pos)) vert_pos_array[a]

					if b < c then
						(
						c = b
						if c < sj_bio_skin_plus_rol.thres.value then
							(
							v = a
							)
						else
							(
							v = undefined -- no vertex found within threshold
							)
						)
					)
				if v != undefined then (append new_vert_array v)
				)--end for i

			skinOps.selectVertices oSkin new_vert_array
			skinOps.buttonExclude oSkin
			)
		)
	/*
	# Function     : gather_enveloppe_data_fn
	# Description  : Finds all relevant data in the selected enveloppe
	# Parameters : bone_index:(what bone), oSkin:(which skin mod.), exclude:(whter to include excluded verts or not)
	# Returns     : an array #( #(startpos, endpos), #( #(cross1-in, cross1-out, cross.pos), #(cross2-in, cross2-out, cross.pos), etc), #(excluded verts array) )
	*/
	fn gather_enveloppe_data_fn bone_index oSkin exclude:false=
		(
		local envelope_data = #()
		local cross = #()
		local env_pos = #()
		local excluded_verts = #()

		for i=1 to (skinOps.GetNumberCrossSections oSkin bone_index) do
			(
			local radius = #()
			append radius (skinOps.GetOuterRadius oSkin bone_index i) -- Grab all radiuses for all crossSections
			append radius (skinOps.GetInnerRadius oSkin bone_index i)
			append radius (skinOps.getCrossSectionU selection[1].modifiers["Skin"] bone_index i) -- position of crosssection
			append cross radius
			)
		append env_pos (skinOps.getStartPoint oSkin bone_index) -- grab enveloppe pos relative to bone
		append env_pos (skinOps.getEndPoint oSkin bone_index)
	
		append envelope_data env_pos
		append envelope_data cross

		if exclude == true then
			(
			excluded_verts = (get_exluded_verts_fn bone_index oSkin)
			append envelope_data excluded_verts
			)
		else
			(
			append envelope_data (#())
			)
	
		return envelope_data
		)
	/*
	# Function     : verts_in_mirrored_bounding_box_fn
	# Description  : Finds all vertices in the mirrored bounding box of the current selected vertices
	# Parameters : vert_sel:(the selection of vertices we use to find the bounding box of) tar_mesh:(target mesh)
	# Returns     : array of vertices
	*/
	fn verts_in_mirrored_bounding_box_fn vert_sel tar_mesh:undefined mirror:true return_boundingbox:false =
		(

		if tar_mesh == undefined then tar_mesh = selection[1]
		
		local minx = 99999
		local miny = 99999
		local minz = 99999
		local maxx = -99999
		local maxy = -99999
		local maxz = -99999
		local vert_array = #()

		for all in vert_sel do
			(
			if (at time 0 selection[1].verts[all].pos.x) < minx then minx = (at time 0 selection[1].verts[all].pos.x)
			if (at time 0 selection[1].verts[all].pos.y) < miny then miny = (at time 0 selection[1].verts[all].pos.y)
			if (at time 0 selection[1].verts[all].pos.z) < minz then minz = (at time 0 selection[1].verts[all].pos.z)

			if (at time 0 selection[1].verts[all].pos.x) > maxx then maxx = (at time 0 selection[1].verts[all].pos.x)
			if (at time 0 selection[1].verts[all].pos.y) > maxy then maxy = (at time 0 selection[1].verts[all].pos.y)
			if (at time 0 selection[1].verts[all].pos.z) > maxz then maxz = (at time 0 selection[1].verts[all].pos.z)
			)
			
 		for i=1 to tar_mesh.verts.count do
			(
			if mirror == true then
				(
				if (at time 0 tar_mesh.verts[i].pos.x) <= -(minx - sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value) and (at time 0 tar_mesh.verts[i].pos.y) >= (miny - sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.z) >= (minz - sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.x) >= -(maxx + sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value) and (at time 0 tar_mesh.verts[i].pos.y) <= (maxy + sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.z) <= (maxz + sj_bio_skin_plus_rol.thres.value) then
					(
					append vert_array i
					)
				)
			else
				(
				if (at time 0 tar_mesh.verts[i].pos.x) >= (minx - sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value) and (at time 0 tar_mesh.verts[i].pos.y) >= (miny - sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.z) >= (minz - sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.x) <= (maxx + sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value) and (at time 0 tar_mesh.verts[i].pos.y) <= (maxy + sj_bio_skin_plus_rol.thres.value) and (at time 0 tar_mesh.verts[i].pos.z) <= (maxz + sj_bio_skin_plus_rol.thres.value) then
					(
					append vert_array i
					)
				)
			)

		if return_boundingbox == true then
			(
			return #(vert_array, #([minx,miny,minz], [maxx,maxy,maxz]))
			)
		else
			(
			return vert_array
			)
		)

	/*
	# Function     : set_envelope_data_fn
	# Description  : Sets enveloppe data
	# Parameters : envelope_data:(see gather_enveloppe_data_fn) trg_index:(target bone), src_target:(source bone), oSkin:(which skin mod.) tskin:(target skin, if not the same as oSkin) mirror:(wether to mirror the envelope or not))
	# Returns     : 
	*/
	-- NOTE: currently does not remove crossSections if there are to many in the target bone.
	fn set_envelope_data_fn envelope_data src_index trg_index oSkin tSkin:undefined mirror:true =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		if ((validate_skin_fn subcheck:false) == true) then
			(

			if tSkin == undefined then tSkin = oSkin	

			if mirror == true then
				(
				tnode = execute ("$'" + (skinops.getbonename tSkin trg_index 0) + "'")
				snode = execute ("$'" + (skinops.getbonename oSkin src_index 0) + "'")
	
				sourceTM = at time 0 snode.transform
				targetTM = at time 0 tnode.transform

				ps = envelope_data[1][1]

				if classof tnode == Biped_Object then
					(
					v = matrix3 1
					sourceTM = v * (scaleMatrix (at time 0 biped.gettransform snode #scale)) * (at time 0 (biped.gettransform snode #rotation) as matrix3)
					v.row4 = at time 0 (biped.gettransform snode #pos)
					)

				if classof snode == Biped_Object then
					(
					v = matrix3 1
					targetTM = v * (scaleMatrix (at time 0 biped.gettransform tnode #scale)) * (at time 0 (biped.gettransform tnode #rotation) as matrix3)
					v.row4 = at time 0 (biped.gettransform tnode #pos)
					)

				v = ps * (sourceTM) * (scaleMatrix [-1,1,1]) * (inverse targetTM) -- Point(local) * source.transform * mirror_matrix * inverse Target.transform)

				)
			else
				(
				v = envelope_data[1][1]
				)
			skinOps.setStartPoint tSkin trg_index v -- sets the start and end points relative to bone
	
			if mirror == true then
				(
				pe = envelope_data[1][2]
				v = pe * (sourceTM) * (scaleMatrix [-1,1,1]) * (at time 0 inverse targetTM) -- Point(local) * source.transform * mirror_matrix * inverse Target.transform)
				)
			else
				(
				v = envelope_data[1][2]
				)
			skinOps.setEndPoint tSkin trg_index v -- sets the start and end points relative to bone
	
	
			if (skinOps.GetNumberCrossSections tSkin trg_index) != envelope_data[2].count then -- this will add crossSection if they do not exist
				(
				for i=1 to (envelope_data[2].count - (skinOps.GetNumberCrossSections tSkin trg_index)) do
					(
					skinOps.addCrossSection tSkin trg_index envelope_data[2][i+1][3] 1 1
					)
				)
	

			if mirror == true then
				(
				for i=1 to (skinOps.GetNumberCrossSections tSkin trg_index) do
					(
					skinOps.SetOuterRadius tSkin trg_index i (envelope_data[2][i][1])
					skinOps.SetInnerRadius tSkin trg_index i (envelope_data[2][i][2])
					)
				)
			else
				(
				for i=1 to (skinOps.GetNumberCrossSections tSkin trg_index) do
					(
					skinOps.SetOuterRadius tSkin trg_index i (envelope_data[2][i][1] * (sj_bio_skin_plus_rol.char_fat.value / 100.00))
					skinOps.SetInnerRadius tSkin trg_index i (envelope_data[2][i][2] * (sj_bio_skin_plus_rol.char_fat.value / 100.00))
					)
				)


			if sj_load_mapping_rol != undefined then
				(
				method = sj_load_mapping_rol.exclude_vert_met.state
				)
			else
				(
				if sj_bio_skin_plus_rol.mirror_excl.checked == true then
					(
					method = 3
					)
				else
					(
					method = 1
					)
				)


			if target_skin == undefined then
				(
				targ_mesh = selection[1]
				)
			else
				(
				targ_mesh = selection[1]
				)

			if method != 1 and envelope_data[3].count != 0 then
				(
				if mirror == true then
					(--find mirrored verts
					vert_array = envelope_data[3][1]

					vert_pos_array = #()
					for i=1 to targ_mesh.verts.count do
						(
						p = (at time 0 targ_mesh.verts[i].pos)
						append vert_pos_array p
						)

					real_verts = #()

					for t=1 to vert_array.count do
						(
						max_pos = ((at time 0 targ_mesh.verts[vert_array[t]].pos) + [(sj_bio_skin_plus_rol.thres.value/1000) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/1000),(sj_bio_skin_plus_rol.thres.value/1000)]) -- make and compair to threshold.
						min_pos = ((at time 0 targ_mesh.verts[vert_array[t]].pos) - [(sj_bio_skin_plus_rol.thres.value/1000) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/1000),(sj_bio_skin_plus_rol.thres.value/1000)]) --  
			
						local c = 999999 					
						local v	= 1

						for i=1 to vert_pos_array.count do -- build array of the vertices on the oppesite side
							(
							all = targ_mesh.verts[i]
			
							if (at time 0 all.pos.x) >= -max_pos.x and (at time 0 all.pos.x) <= -min_pos.x and (at time 0 all.pos.y) <= max_pos.y and (at time 0 all.pos.y) >= min_pos.y and (at time 0 all.pos.z) <= max_pos.z and (at time 0 all.pos.z) >= min_pos.z then
								(
								b = distance (at time 0 all.pos) (at time 0 targ_mesh.verts[v].pos)
								if b < c then
									(
									c = b
									v = i
									)
								-- exit -- this means that the first vertex we find that matches, we use and we don't look any further. That turned out not to be good
								)--end if
							)--end for i
						append real_verts v
						
						--プログレス処理
						sj_progressBar_rol.progbar.value = ((100.00/vert_array.count) * t);
						)--end for t

					vp = #()
					for i=1 to real_verts.count do
						(
						append vp (at time 0 targ_mesh.verts[real_verts[i]].pos)
						)
					envelope_data[3][1] = vert_data
					envelope_data[3][2] = vp
					set_exluded_verts_fn trg_index tSkin envelope_data[3]
					)
				else
					(
					set_exluded_verts_fn trg_index tSkin envelope_data[3]
					)

				)--end if				
			)--end validate
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)--end fn
	/*
	# Function     : gather_gizmo_data_fn
	# Description  : Collects data dat belongs to a gizmo
	# Parameters : outfile:(which file to save to)
	# Returns     : #(gizmo data)
	*/
	fn gather_gizmo_data_fn gizmo_index oSkin =
		(
		gizmo_array = #() -- new empty array
		giz_class = (classof (oSkin.gizmos)[gizmo_index])
		append gizmo_array ("\"" + giz_class as string + "\"")-- class

	--------------------------------------------------------------------
		if giz_class == Morph_Angle_Deformer then
	--------------------------------------------------------------------
			(
			-- MorphGizmo:
			append gizmo_array ("\"" + (oSkin.gizmos)[gizmo_index].name as string + "\"")
			append gizmo_array ((oSkin.gizmos)[gizmo_index].parent + 1)--(this array start counting at 0)
			-- find parent name:
				ind = ((oSkin.gizmos)[gizmo_index].parent + 1) --(this array start counting at 0)
				if ind != 0 then append gizmo_array ("\"" + (skinOps.getBoneName oSkin ind 0) as string + "\"")
				else append gizmo_array "undefined"
			append gizmo_array ((oSkin.gizmos)[gizmo_index].child + 1)--(this array start counting at 0)
			-- find child name:
				ind = ((oSkin.gizmos)[gizmo_index].child + 1)--(this array start counting at 0)
				if ind != 0 then append gizmo_array ("\"" + (skinOps.getBoneName oSkin ind 0) as string + "\"")
				else append gizmo_array "undefined"
			append gizmo_array ((oSkin.gizmos)[gizmo_index].initial_angle)
			append gizmo_array ("\"" + ((oSkin.gizmos)[gizmo_index].enable) as string + "\"")
			append gizmo_array ("\"" + ((oSkin.gizmos)[gizmo_index].currentJointName) as string + "\"")
			append gizmo_array ((oSkin.gizmos)[gizmo_index].angles)
			append gizmo_array ((oSkin.gizmos)[gizmo_index].count)
			append gizmo_array ((oSkin.gizmos)[gizmo_index].morphPoints)
			append gizmo_array (((oSkin.gizmos)[gizmo_index].nodes) as string)
			append gizmo_array (((oSkin.gizmos)[gizmo_index].names) as string)
			append gizmo_array ((oSkin.gizmos)[gizmo_index].mapTable)
			-- Output world position of vertices:
				giz_vert_array = #()
				for v=1 to ((oSkin.gizmos)[gizmo_index].mapTable).count do
					(
					append giz_vert_array (selection[1].verts[((oSkin.gizmos)[gizmo_index].mapTable)[v]]).pos
					)
			-- Output boundingbox:
				bb = (verts_in_mirrored_bounding_box_fn ((oSkin.gizmos)[gizmo_index].mapTable) mirror:false return_boundingbox:true)
				append gizmo_array bb
			append gizmo_array ((oSkin.gizmos)[gizmo_index].vecs)
			append gizmo_array ((oSkin.gizmos)[gizmo_index].ease)
			)
		return gizmo_array
		)--end fn
	/*
	# Function     : save_list_fn 	
	# Description  : Save mapping list to disk
	# Parameters : lst:(which itemlist to save)
	# Returns     : 
	*/
	fn save_list_fn lst =
		(
		outfile = (getSaveFileName types:"BSkin_List(*.blt)|*.blt")
		if outfile != undefined then
			(
			ostream = (createFile outfile)
			tact_format_fn lst ostream
			--rmat "%\n" lst to:ostream
			close ostream
			)
		)
	/*
	# Function     : save_list_fn 	
	# Description  : Save mapping list to disk
	# Parameters :  lst:(which itemlist to save)
	# Returns     : 
	*/
	fn load_list_fn lst =
		(
		local lst = #()
		infile = (getOpenFileName types:"BSkin_List(*.blt)|*.blt")
		if infile != undefined then
			(
			istream = (openFile infile)
			newlst = (execute(readline istream))
			close istream
			return newlst
			)
		else return lst
		)
/*エンベロープを保存*/
	/*
	# Function     : save_env_data_fn
	# Description  : Save Enveloppe data to disk
	# Parameters : outfile:(which file to save to)
	# Returns     : 
	*/
	fn save_env_data_fn outfile =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		x = subobjectlevel
		ostream = (createFile outfile)
		local bones = bones_in_skin_fn() -- finds the nodes that are in the skin modifier

		bones_sorted = #()
		for i=1 to bones.count do -- we are storing the bones alphabetically, which helps when loading envelopes onto another character.
			(
			append bones_sorted bones[i].name	
			)
		bones_sorted = (sort bones_sorted)
		for i=1 to bones_sorted.count do
			(
			bone_index = (tact_boneindex bones_sorted[i] selection[1].modifiers["Skin"])
			format "%\n" bones_sorted[i] to:ostream
			data = (gather_enveloppe_data_fn bone_index selection[1].modifiers["Skin"] exclude:true)
			tact_format_fn data ostream
			format "\n" to:ostream
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = ((100.00/bones_sorted.count) * i);
			)
		format "\n" to:ostream
		format  "\r" to:ostream
		close ostream
		subobjectlevel = x
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)
	/*
 	# Function     : set_gizmo_data_fn
	# Description  : Sets gizmo data
	# Parameters : gizmo_data:(array of gizmo data) oSkin:(target skin) parent_index:(gizmo.parent, bone_index) child_index:(gizmo.child) mirror:(find mirror bones and vertices and apply gizmo to them instead)
	# Returns     : 
	*/
	fn set_gizmo_data_fn gizmo_data oSkin mirror:false method:2 =
		(
		if method != 1 then
			(
		--------------------------------------------------------------------
			if gizmo_data[1] == "Morph_Angle_Deformer" then
		--------------------------------------------------------------------
				(

				-- Grab right Bones (mirror if needed):
				new_parent_index = gizmo_data[3]
				new_child_index = gizmo_data[5]



				-- find new bones according to mapping info.
				bis = (finditem sj_load_mapping_rol.source_list.items gizmo_data[4])
				if bis != 0 then
					(
					new_parent_index = (tact_boneindex sj_load_mapping_rol.target_list.items[bis] selection[1].modifiers["Skin"])
					)
				bis = (finditem sj_load_mapping_rol.source_list.items gizmo_data[6])
				if bis != 0 then
					(
					new_child_index = (tact_boneindex sj_load_mapping_rol.target_list.items[bis] selection[1].modifiers["Skin"])
					)
					if mirror == true then
					(
					new_parent_index = (find_mirror_bone_fn new_parent_index (bones_in_skin_fn iSkin:target_skin))
					new_child_index = (find_mirror_bone_fn new_parent_index (bones_in_skin_fn iSkin:target_skin))
					)
			-- Grab vertex selection (mirror if needed):
	
				---------------------------------------
				-- vertices by index
				---------------------------------------
	
				if method == 2 then
					(
					if mirror == false then
						(
						giz_verts = gizmo_data[15]
						)
					else
						(
						giz_verts = #()
						)
					)
				---------------------------------------
				-- find vertices by world pos
				---------------------------------------
	
				if method == 3 then
					(
					if mirror == false then
						(
						pos_array = gizmo_data[16]
						giz_verts = #()
						)
					else
						(
						giz_verts = #()
						)
					)
				---------------------------------------
				-- find vertices within boundingbox
				---------------------------------------
				if method == 4 then
					(
					if mirror == false then
						(
						boundbox = gizmo_data[17]
						giz_verts = #()
						)
					else
						(
						giz_verts = #()
						)
					)
				-- select envelope
				print new_child_index
				skinOps.selectBone oSkin new_child_index
				-- select vertices
				skinOps.selectvertices oSkin giz_verts
				-- Add Gizmo:
				skinOps.selectGizmoType oSkin 3
				at time 0 (skinOps.buttonAddGizmo oSkin)

				gizmo_index = (oSkin.gizmos).count -- last one added
	
				-- Load gizmo_array settings onto this gizmo:
				-- Mirror settings if needed
				-- Some Settings are not set, because they are automatically created when adding the gizmo
				(oSkin.gizmos)[gizmo_index].name = gizmo_data[2]
				(oSkin.gizmos)[gizmo_index].enable = execute (gizmo_data[8])
				(oSkin.gizmos)[gizmo_index].angles = gizmo_data[10]
				(oSkin.gizmos)[gizmo_index].morphPoints = gizmo_data[12]
				-- rebuild name array:
				-- This CRASHES max, so to bad, can't add it.
				-- (oSkin.gizmos)[gizmo_index].names = gizmo_data[14]
				(oSkin.gizmos)[gizmo_index].vecs = gizmo_data[17]
				(oSkin.gizmos)[gizmo_index].ease = gizmo_data[18]

				)
	
	
		--------------------------------------------------------------------
			if gizmo_data[1] == "Joint_Angle_Deformer" then
		--------------------------------------------------------------------
				(
				print "Joint Angle Gizmo not copied - no script access"
				)
		--------------------------------------------------------------------
			if gizmo_data[1] == "Bulge_Angle_Deformer" then
		--------------------------------------------------------------------
				(
				print "Buldge Angle Gizmo not copied - no script access"
				)
			)--end method 1
		)--end fn
	/*
	# Function     : load_env_data_fn
	# Description  : load Enveloppe data from disk
	# Parameters : infile(file to read)
	# Returns     : #( #(array of nodes), #(array of envelope data) (#array of gizmo data) )
	*/
	fn load_env_data_fn infile =
		(
		node_list = #()
		env_array = #()
		gizmo_array = #()

		istream = (openFile infile)

		try(
		while not eof istream do
			(
			append node_list (readline istream)
			append env_array (readline istream)
			)
		)catch()

		close istream
		
		if node_list.count != env_array.count then -- this way we stay compatible with older files that didn't save gizmos
			(
			gizmo_array = node_list[node_list.count]
			deleteitem node_list node_list.count
			)
		
		return #(node_list, env_array, gizmo_array)
		)
	/*
	# Function     : find_mirror_bone_fn
	# Description  : Finds the mirrored bone of the current selected bone
	# Parameters : bone_index:(bone index of you wish to find it's mirrored counterpart of) all_bones:(all bones in modifier) iSkin:(target skin)
	# Returns     : (index of the mirrored bone)
	*/
	fn find_mirror_bone_fn bone_index all_bones iSkin:undefined moveSlider:true = 
		(
		if iSkin == undefined then iSkin = selection[1].modifiers["Skin"]

		src_bone = skinOps.getBoneName selection[1].modifiers["Skin"] bone_index 0
		src_bone = execute ("$'" + src_bone + "'")

		if moveSlider == true then
			(
			animationrange = (interval 0 animationrange.end)
			curSLTime = currenttime
			slidertime = 0
			)

		max_pos = ((at time 0 src_bone.center) + [sj_bio_skin_plus_rol.thres.value + 10.0 + sj_bio_skin_plus_rol.x_offset.value,sj_bio_skin_plus_rol.thres.value + 10.0 ,sj_bio_skin_plus_rol.thres.value + 10.0]) -- make and compair to threshold.
		min_pos = ((at time 0 src_bone.center) - [sj_bio_skin_plus_rol.thres.value + 10.0 + sj_bio_skin_plus_rol.x_offset.value,sj_bio_skin_plus_rol.thres.value + 10.0 ,sj_bio_skin_plus_rol.thres.value + 10.0]) --  We use center instead of pos, because of bones that lay on top of each other

		ClosestBone = undefined
		for all in all_bones do 
			(
			if (at time 0 all.center.x) >= -max_pos.x and (at time 0 all.center.x) <= -min_pos.x and (at time 0 all.center.y) <= max_pos.y and (at time 0 all.center.y) >= min_pos.y and (at time 0 all.center.z) <= max_pos.z and (at time 0 all.center.z) >= min_pos.z then
				(
				if ClosestBone == undefined then
					(
					ClosestBone = all
					)
				else
					(
					if (distance all.center [-src_bone.center.x, src_bone.center.y, src_bone.center.z]) < (distance ClosestBone.center [-src_bone.center.x, src_bone.center.y, src_bone.center.z]) then
						(
						ClosestBone = all
						)
					)
				)--end if
			)--end c

		if moveSlider == true then
			(
			slidertime = curSLTime
			)

		if ClosestBone != undefined then
			(
			if src_bone.name.count != ClosestBone.name.count then
				(
				print ("Name MisMatch, but found boundingbox match for: " + src_bone.name + " --> " + ClosestBone.name)
				)
			return (tact_boneindex ClosestBone.name iSkin)
			)
		else 
			(
			print ("Could not find a match for the following bone: " + src_bone.name)
			return undefined
			)
		)
	/*
	# Function     : verts_in_other_mesh_fn
	# Description  : Finds the same vertices in different mesh
	# Parameters : vert_sel:(which vertices to try and find)
	# Returns     : (array of vertices)
	*/
	-- It will always pick a verts, thus this only works well if all verts exist in both meshes.
	fn verts_in_other_mesh_fn vert_sel tar_mesh mirror:false =
		(
		new_verts = #()
		local s,d,x,w

		for q=1 to vert_sel.count do
			(
			x = 99999
			for w=1 to tar_mesh.verts.count do
				(
				tar_dist = (at time 0 selection[1].verts[vert_sel[q]].pos)
				
				if mirror == true then
					(
					tar_dist = [-tar_dist.x,tar_dist.y,tar_dist.z]
					)

				d = distance tar_dist (at time 0 tar_mesh.verts[w].pos)

				if d < x then
					(
					x = d
					s = w
					)
				)--end for w
			append new_verts s
			)--end for q

		return new_verts
		)
	/*
	# Function     : mirror_sel_verts_fn
	# Description  : Mirrors selected vertices
	# Parameters : mod_only:(wheter to mirror only vertices that are fixed, meaning weighted by hand, or not.) oSkin:(target skin) mirror:(wheter to mirror or not, same function used by paste vertices)
	# Returns     : 
	*/
	--
	fn mirror_sel_verts_fn mod_only:false oSkin:undefined mirror:true =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		if (validate_skin_fn() == true) then
			(

			if mirror != true and target_skin == undefined then
				(
				messagebox "Target Skin undefined!"
				)
			else
				(
				if oSkin == undefined then oSkin = selection[1].modifiers["Skin"]
	
				vert_sel = (tact_skinselectedverts selection[1].modifiers["Skin"]) -- finds all selected vertices in skin mod.
	
				if mod_only == true then -- if we only want to copy modified vertices
					(
					mod_verts = #()
					for i=1 to vert_sel.count do
						(
						if (skinOps.IsVertexModified selection[1].modifiers["Skin"] vert_sel[i] ) == 1 then
							(
							append mod_verts vert_sel[i]
							)
						)--end for
						vert_sel = mod_verts
					)--end if mod
	
	
				if mirror == true or target_skin == undefined then
					(
					vert_array = (verts_in_mirrored_bounding_box_fn vert_sel tar_mesh:target_skin mirror:mirror) -- creates a selection of all vertices on the oppesite side.
					)
				else
					(
					vert_array = (verts_in_other_mesh_fn vert_sel target_skin) -- creates a selection of all vertices on the oppesite side.
					)
	
	
				-- we move the timeslider here, because when we find the mirrored bone, it needs to be at 0 ($.center bug)
				-- and we only want it to move onces, for all vertices.
				animationrange = (interval 0 animationrange.end)
				curSLTime = currenttime
				slidertime = 0

	
				all_vals = #()
				for t=1 to vert_sel.count do
					(
		
					max_pos = ((at time 0 selection[1].verts[vert_sel[t]].pos) + [(sj_bio_skin_plus_rol.thres.value/100) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/100),(sj_bio_skin_plus_rol.thres.value/100)]) -- make and compair to threshold.
					min_pos = ((at time 0 selection[1].verts[vert_sel[t]].pos) - [(sj_bio_skin_plus_rol.thres.value/100) + sj_bio_skin_plus_rol.x_offset.value,(sj_bio_skin_plus_rol.thres.value/100),(sj_bio_skin_plus_rol.thres.value/100)]) --  
		
					local trg_vert = undefined
		
					local c = 999999 					
					local v	= undefined
	

					for a=1 to vert_array.count do
						(
						-- find closest vertex
						if mirror == true then
							(
							p = (at time 0 selection[1].verts[vert_array[a]].pos)
							tar_dist = [-p.x, p.y, p.z]
							)
						else 
							(
							p = (at time 0 target_skin.verts[vert_array[a]].pos)
							tar_dist = [p.x, p.y, p.z]
							)
	
						if target_skin == undefined then
							(
							b = distance tar_dist (at time 0 selection[1].verts[vert_sel[t]].pos)
							)
						else
							(
							-- find vert_sel[t] in target_skin:
							varray = #()
							append varray vert_sel[t]
							tskin_index = (verts_in_other_mesh_fn varray target_skin mirror:mirror)
							b = distance tar_dist (at time 0 target_skin.verts[tskin_index[1]].pos)
							)
			
	
						if b < c then
							(
							c = b
							v = a
							)
						)--end for
	
	
					if target_skin == undefined then
						(
						all = selection[1].verts[vert_array[v]]
						)
					else 
						(
						all = target_skin.verts[vert_array[v]]
						)
	
	
					local the_weights = #()
					local the_bones = #()
					local h = #()
	

					for u=1 to (skinops.getvertexweightcount selection[1].modifiers["Skin"] vert_sel[t]) do -- find all bones that influence the src_vert.
						(
						src_bone_index = (skinops.getvertexweightboneID selection[1].modifiers["Skin"] vert_sel[t] u)
						
						if target_skin != undefined and mirror == true then
							(
							trg_bone_index = ( find_mirror_bone_fn src_bone_index (bones_in_skin_fn iSkin:target_skin.modifiers["Skin"]) iSkin:target_skin.modifiers["Skin"] moveSlider:false) -- find their mirrored bone
							)
						else if target_skin == undefined and mirror == true then
							(
							trg_bone_index = ( find_mirror_bone_fn src_bone_index (bones_in_skin_fn()) moveSlider:false) -- find their mirrored bone
							)
						else
							(
							trg_bone = (skinOps.getBoneName selection[1].modifiers["Skin"] src_bone_index 0)
							trg_bone_index = (tact_boneindex trg_bone oSkin) -- finds the index of the target bone
							)
	
						if trg_bone_index != 0 and trg_bone_index != undefined then
							(
							w = (skinops.getVertexWeight selection[1].modifiers["Skin"] vert_sel[t] u)
							append the_weights w
							append the_bones trg_bone_index
							-- skinops.setVertexWeights selection[1].modifiers["Skin"] vert_array[i] trg_bone_index w -- we use replaceweights instead of set weights, because otherwise the original envelope weight would remain.
							)
						else
							(
							if mirror != true then
								(
								messagebox "One of the bones was not found in the Target mesh\n Some of the selected vertices probably have bones weighted to them that do no exist in target_mesh."
								)
							)
						)--end for u
	
					append h all.index
					append h the_bones
					append h the_weights
					append all_vals h
	
					--プログレス処理
					sj_progressBar_rol.progbar.value = ((100.00/vert_sel.count) * t)
					)--end for t
	
				slidertime = curSLTime

		
				if target_skin != undefined then 
					(
					x = selection[1]
					select target_skin
					)
					
	
				validate_skin_fn() -- make sure skin modifier is selected
				for i=1 to all_vals.count do
					(
					skinops.replaceVertexWeights oSkin all_vals[i][1] all_vals[i][2] all_vals[i][3]
					)
	
				if target_skin != undefined or target_skin == selection[1] then 
					(
					select x
					subobjectlevel = 1
					)
				
				--プログレス処理
				try(destroydialog sj_progressBar_rol)catch();
				)
			)--target_skin undefined and mirror not true
		)
/*頂点のウェイト情報を保存*/
	/*
	# Function     : save_vert_data_fn
	# Description  : Save Vertex data to disk
	# Parameters : outfile:(which file to save to)
	# Returns     : array:  #( #(vertex_index, vertex.pos, vertex.pos relative to first bone, modified, #(src_bone_index1, src_bone_index2,etc), #(src_bone_name1, src_bone_name2,etc), #(weight1, weight2,etc)), #(etc.) )
	*/
	fn save_vert_data_fn outfile =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		ostream = (createFile outfile)
		vert_count = selection[1].verts.count

		for i=1 to vert_count do --頂点の数だけ
			(
			vertex_data = #()
			local w = #() --weight array
			local src_bone_index = #() -- bone index array
			local src_bone_name = #() -- bone name array
			
			for u=1 to (skinops.getvertexweightcount selection[1].modifiers["Skin"] i) do --i番目の頂点のウェイトがかかる骨の数だけ
				(
				append src_bone_index (skinops.getvertexweightboneID selection[1].modifiers["Skin"] i u) -- bone index array
				append src_bone_name (skinops.getboneName selection[1].modifiers["Skin"] src_bone_index[u] 0) -- bone name array
				append w (skinops.getVertexWeight selection[1].modifiers["Skin"] i u) -- vertex weights array
				)
			m = (skinOps.IsVertexModified selection[1].modifiers["Skin"] i ) -- wheter bone is modified or not

			if (skinOps.getVertexWeightCount selection[1].modifiers["Skin"] i) != 0 then
				(
				append vertex_data i
				append vertex_data (at time 0 selection[1].verts[i].pos) -- store world pos.
				tnode = (execute("$'" + src_bone_name[1] + "'"))
				if classof tnode != Biped_Object then
					append vertex_data (at time 0 selection[1].verts[i].pos - (at time 0 tnode.pos) ) -- Store position relative to first bone.
				else
					append vertex_data (at time 0 selection[1].verts[i].pos - (at time 0 (biped.gettransform tnode #pos)) ) -- Store position relative to first bone.
				append vertex_data m
				append vertex_data src_bone_index
				append vertex_data src_bone_name
				append vertex_data w
	
				format "%\n" vertex_data to:ostream
				)
			else
				(
				print ("Vertex index " + i as string + " was not saved since it was not weighted to any bones")
				)
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = ((100.00/vert_count) * i);
			)

		format  "\r" to:ostream
	
		close ostream
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)
	/*
	# Function     : load_vert_data_fn
	# Description  : Load Vertex data from disk
	# Parameters : infile:(which file to load from)
	# Returns     : array with all vertex info, see save_vert_data_fn
	*/
	fn load_vert_data_fn infile =
		(
		vert_array = #()

		istream = (openFile infile)

		while not eof istream do
			(
			append vert_array (execute(readline istream))
			)

		close istream
		
		return vert_array
		)
	/*
	# Function     : set_vertex_data_fn
	# Description  : Sets vertex weighting to a vertex
	# Parameters : vert_index:(vertex index) vert_data: #( #(boneindex, weight), #(boneindex, weight))
	# Returns     : array with all vertex info, see save_vert_data_fn
	*/
	fn set_vertex_data_fn vert_index vert_data =
		(
		the_bones = #()
		the_weights = #()
		
		for u=1 to vert_data.count do 
			(
			append the_bones (vert_data[u][1])
			append the_weights (vert_data[u][2])
			)--end for u

		skinops.replaceVertexWeights selection[1].modifiers["Skin"] vert_index the_bones the_weights
		)
	/*
	# Function     : mirror_env_fn
	# Description  : Mirrors an envelope
	# Parameters : mirror:(wheter to mirror or not, we use the same function for paste envelope)
	# Returns     : 
	*/
	fn mirror_env_fn iSkin:undefined oSkin:undefined mirror:true = 
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		--プログレス処理
		sj_progressBar_rol.progbar.value = 100;
		
		if iSkin == undefined then iSkin = selection[1].modifiers["Skin"]
		if oSkin == undefined then oSkin = iSkin


		local bone_index = skinOps.GetSelectedBone iSkin -- Find which bone is selected
		src_bone = skinOps.getBoneName iSkin bone_index 0
		src_bone = execute ("$'" + src_bone + "'")
	
		local trg_bone = undefined
		local valid_bone = true

		local c = (bones_in_skin_fn iSkin:oSkin)-- finds all bones in the skin modifier

		animationrange = (interval 0 animationrange.end)
		curSLTime = currenttime
		slidertime = 0

		for all in c do 
			(
			max_pos = ((at time 0 src_bone.center) + [sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value,sj_bio_skin_plus_rol.thres.value,sj_bio_skin_plus_rol.thres.value]) -- make and compair to threshold.
			min_pos = ((at time 0 src_bone.center) - [sj_bio_skin_plus_rol.thres.value + sj_bio_skin_plus_rol.x_offset.value,sj_bio_skin_plus_rol.thres.value,sj_bio_skin_plus_rol.thres.value]) --  We use center instead of pos, because of bones that lay on top of each other

			if mirror == true then
				(
				if (at time 0 all.center.x) >= -max_pos.x and (at time 0 all.center.x) <= -min_pos.x and (at time 0 all.center.y) <= max_pos.y and (at time 0 all.center.y) >= min_pos.y and (at time 0 all.center.z) <= max_pos.z and (at time 0 all.center.z) >= min_pos.z then
					(
					if trg_bone == undefined then
						(
						trg_bone = all
						)
					else
						(
						valid_bone = false
						the_string = "I Found more then 1 bone that is within the threshold. Try lowering the threshold\n"
						the_string += " If you have two bones laying on top of each other, it will only work if their boundingbox centers do not line up exactly.\n"
						messagebox the_string
						)
					)--end if
				)
			else
				(
				trg_bone = src_bone
				)

			)--end for
		slidertime = curSLTime


		if valid_bone == true and trg_bone != undefined then
			(
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = 100
			
			
			trg_index = (tact_boneindex trg_bone.name oSkin) -- finds the index of the target bone
			local envelope_data = (gather_enveloppe_data_fn bone_index iSkin exclude:(sj_bio_skin_plus_rol.mirror_excl.checked)) -- loads all enveloppe data from source
			(set_envelope_data_fn envelope_data bone_index trg_index iSkin tSkin:oSkin) -- sets the envelope data
			)--end if
		else if trg_bone == undefined then
			(
			the_string = "No Bones found. Try increasing the threshold.\n"
			messagebox the_string
			)
		subobjectlevel = 1
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)--fn end
	/*
	# Function     : reset_bio_skin_fn
	# Description  : Resets Bio Skin Floater to start values
	# Parameters : 
	# Returns     : 
	*/
	fn reset_bio_skin_fn =
		(
		last_spin 	 	= "start" -- used to identify the last spinner used (radius spinner)
		target_skin  	= undefined -- used when mirroring to a different skin then selected.
		silent			= false -- used to do hold and fetches of data
		feed_file		= undefined -- used to feed a file when using fetch
		sj_bio_skin_plus_rol.tar_skin.text 	= "No target skin loaded"
		)
	/*
	# Function     : select_affected_verts_fn
	# Description  : Selects all affected vertices of the current selected enveloppe
	# Parameters : 
	# Returns     : 
	*/
	fn select_affected_verts_fn =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		oSkin = selection[1].modifiers["Skin"]
		sname = skinOps.getBoneName oSkin (skinOps.GetSelectedBone oSkin) 1
		averts = #()
		
		for i=1 to selection[1].verts.count do
			(
			bc = skinOps.GetVertexWeightCount oSkin i
			for b=1 to bc do
				(
				bi = skinOps.GetVertexWeightBoneID oSkin i b
				bname = (skinOps.getBoneName oSkin bi 1)
				if bname == sname then
					(
					append averts i
					)
				)
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = ((100.00/selection[1].verts.count) * i);
			)
		skinOps.selectVertices oSkin averts
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)

/*影響ボーン名とウェイトを表示*/
	/*
	# Function     : bones_affecting_vert_fn
	# Description  : Prints all bones that are effecting the current vertex
	# Parameters : 
	# Returns     : 
	*/
	fn bones_affecting_vert_fn =
		(
		oSkin = selection[1].modifiers["Skin"]
		verts = tact_skinselectedverts oSkin

		if verts.count > 0 then
			(
			nb = skinOps.getVertexWeightCount oSkin verts[verts.count]
			for i=1 to nb do
				(
				bi = skinOps.getVertexWeightBoneID oSkin verts[verts.count] i
				print ( (skinOps.getBoneName oSkin bi 1) + "   weight: " + (skinOps.getVertexWeight oSkin verts[verts.count] i) as string )
				messageBox ( (skinOps.getBoneName oSkin bi 1) + "\nweight: " + (skinOps.getVertexWeight oSkin verts[verts.count] i) as string ) --メッセージボックスで知らせる
				)
			)
		)


	/*
	# Function     : expand_element_fn
	# Description  : Selects all vertices of an element
	# Parameters : 
	# Returns     : 
	*/
	fn expand_element_fn =
		(
		selverts = tact_skinselectedverts selection[1].modifiers["Skin"]
		
		if selverts.count != 0 then
			(
			try( --立体ポリゴンでエラーがでたので回避策として
			z = (meshop.getfacesusingvert $ selverts[1])
			s = meshop.getelementsusingface $ z
			skinops.selectvertices selection[1].modifiers["Skin"] (meshop.getvertsusingface $ s)
			)catch(messagebox "ポリゴンが少ないため実行できません")
			)
		else
			(
			messagebox "頂点を選択してから実行してください"
			)
		)
	/*
	# Function     : clean_verts_fn
	# Description  : Removes all bones from verts that influence it by 0.
	# Parameters : 
	# Returns     : 
	*/

	--Chuggnut

	fn clean_verts_fn =
		(
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
		
		sknobj = selection[1].modifiers["Skin"]
		clearcount = 0
		for i = 1 to selection[1].numverts do
			(
			bones = skinops.getvertexweightcount sknobj i
			id = #()
			weight = #()
			idcount = 0
			norm = 0

			for n = 1 to bones do
				(
				if (w = skinops.getvertexweight sknobj i n) > 0.0001 do
					(
					boneindex = skinops.getvertexweightboneid sknobj i n
					id[idcount += 1] = boneindex
					weight[idcount] = w
					norm += w
					)
				)
			
			for n = 1 to idcount do
				(
				weight[n] /= norm
				)
			clearcount += (bones - idcount)
			
			skinops.replacevertexweights sknobj i id weight
			
			--プログレス処理
			sj_progressBar_rol.progbar.value = ((100.00/selection[1].verts.count) * i);
			)
		
		--プログレス処理
		try(destroydialog sj_progressBar_rol)catch();
		)
		
------------------------------------------------------------------------------------------------------------------------
--ファクション終わり
------------------------------------------------------------------------------------------------------------------------
