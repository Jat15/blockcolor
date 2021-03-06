multidimensions={

	start_y=4000
	,max_distance=50 --(50 is 800)
	,max_distance_chatt=800
	,limited_chat=false
	,limeted_nametag=true
	,teleports=true
	,craftable=true
	,remake_home=true
	,remake_bed=true

,dimensions={},user={},
levels={{4,994},{994,998},{998,1000}}}
--stone, dirt, grass

dofile(minetest.get_modpath("multidimensions") .. "/dimensions.lua")
dofile(minetest.get_modpath("multidimensions") .. "/tools.lua")

local level=multidimensions.start_y
local leveln=1
multidimensions.distance=function(p,o)
return math.sqrt((p.x-o.x)*(p.x-o.x) + (p.y-o.y)*(p.y-o.y)+(p.z-o.z)*(p.z-o.z))
end

for i, dim in pairs(multidimensions.dimensions) do
if dim.name then
	leveln=leveln+1
	multidimensions.dimensions[leveln].y=multidimensions.levels[3][2]+level+2
	for ii = 1, 3, 1 do
	minetest.register_ore({
		ore_type = "scatter",
		ore= dim[ii],
		wherein= "air",
		clust_scarcity = 1,
		clust_num_ores = 10,
		clust_size = 2,
		y_min= level+multidimensions.levels[ii][1],
		y_max= level+multidimensions.levels[ii][2],
	})
	end
	minetest.register_ore({
		ore_type = "scatter",
		ore="multidimensions:bedrock",
		wherein= "air",
		clust_scarcity = 1,
		clust_num_ores = 10,
		clust_size = 2,
		y_min= level,
		y_max= level+4,
	})
	if dim.ores then
		local ore_y=0
		local ore_scarcity=8
		for i, ore in pairs(dim.ores) do
			minetest.register_ore({
			ore_type = "scatter",
			ore= ore,
			wherein=dim[1],
			clust_scarcity = ore_scarcity*ore_scarcity*ore_scarcity,
			clust_num_ores = 5,
			clust_size = 3,
			y_min= level+multidimensions.levels[1][1],
			y_max= level+multidimensions.levels[1][2]+ore_y,
			})
			ore_scarcity=ore_scarcity+2
			ore_y=ore_y-50
		end
	end
	if dim.nature then
		for i, nat in pairs(dim.nature) do
			minetest.register_ore({
			ore_type = "scatter",
			ore = nat.node,
			wherein ="air",
			clust_scarcity = nat.scarcity*nat.scarcity*nat.scarcity,
			clust_num_ores = nat.num,
			clust_size = nat.size,
			y_min = level+multidimensions.levels[3][2]-3,
			y_max = level+multidimensions.levels[3][2]+1,
		})
		end
	end
	if dim.blob then
		for i, blob in pairs(dim.blob) do
		minetest.register_ore({
			ore_type= "blob",
			ore = blob.node,
			wherein = {blob.wherein},
			clust_scarcity= blob.clust_scarcity * blob.clust_scarcity * blob.clust_scarcity,
			clust_size= blob.clust_clust_size,
			y_min = level+blob.miny,
			y_max = level+blob.maxy,
			noise_threshold = 0.0,
			noise_params= {
				offset = 0.5,
				scale = 0.2,
				spread = {x = 5, y = 5, z = 5},
				octaves = 1,
				persist = 0.0
			},
		})
		end
	end

	if multidimensions.teleports and dim.color and dim.name then
		local y=multidimensions.dimensions[leveln].y
		minetest.register_node("multidimensions:teleporter" .. leveln, {
			description = "Teleport to dimension " .. dim.name,
			tiles = {"default_steel_block.png","default_steel_block.png","default_mese_block.png^[colorize:#" .. dim.color .."cc"},
			groups = {choppy=2,oddly_breakable_by_hand=1},
			is_ground_content = false,
			sounds = default.node_sound_wood_defaults(),
			after_place_node = function(pos, placer, itemstack)
				local meta=minetest.get_meta(pos)
				meta:set_string("owner",placer:get_player_name())
				meta:set_string("infotext","Teleport to dimension " .. dim.name)
				
			end,
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				local owner=minetest.get_meta(pos):get_string("owner")
				local pos2={x=pos.x,y=y,z=pos.z}
				if minetest.is_protected(pos2, owner)==false then
					multidimensions.move(player,pos2)
				end
			end,
			mesecons = {effector = {
				action_on = function (pos, node)
				local owner=minetest.get_meta(pos):get_string("owner")
				local pos2={x=pos.x,y=y,z=pos.z}
				if minetest.is_protected(pos2, owner)==false then	
				end
				for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
					multidimensions.move(ob,pos2)
				end
				return false
			end}},
		})

		if multidimensions.craftable and dim.craft then
			minetest.register_craft({
				output = "multidimensions:teleporter" .. leveln,
				recipe = {
					{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
					{dim.craft, "default:mese", dim.craft,},
					{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
				}
			})
		end
	end
level=level+2000
end
end

minetest.register_node("multidimensions:bedrock", {
	description = "Bedrock",
	tiles = {"default_stone.png","default_cloud.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png",},
	groups = {unbreakable=1,not_in_creative_inventory = 1},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	diggable = false,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("multidimensions:stone", {
	drawtype="airlike",
	groups = {multidimensions_hot=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:cactus", {
	drawtype="airlike",
	groups = {multidimensions_hot=1,not_in_creative_inventory=1},
})


minetest.register_abm({
	nodenames = {"group:multidimensions_hot"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "air"})
		local hot=""
		
if node.name=="multidimensions:stone" then hot= "/schematics/stone.mts" end
if node.name=="multidimensions:cactus" then hot= "/schematics/cactus.mts" end

		minetest.place_schematic({x=pos.x,y=pos.y,z=pos.z}, hot, "random", {}, true)
	end,
})

if multidimensions.limited_chat then
minetest.register_on_chat_message(function(name, message)
	local msger = minetest.get_player_by_name(name)
	local pos1 = msger:getpos()
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos2 = player:getpos()
		if player:get_player_name()~=name and multidimensions.distance(pos1,pos2)<multidimensions.max_distance_chatt then
			minetest.chat_send_player(player:get_player_name(), "<"..name.."> "..message)
		end
	end
	return true
end)
end


minetest.register_node("multidimensions:teleporter0", {
	description = "Teleport to dimension earth",
	tiles = {"default_steel_block.png","default_steel_block.png","default_mese_block.png^[colorize:#1e6600cc"},
	groups = {choppy=2,oddly_breakable_by_hand=1},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta=minetest.get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Teleport to dimension earth")
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		if minetest.is_protected(pos2, owner)==false then
			multidimensions.move(player,pos2)
		end
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		if minetest.is_protected(pos2, owner)==false then	
		end
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
			multidimensions.move(ob,pos2)
		end
		return false
	end}},
})
minetest.register_craft({
	output = "multidimensions:teleporter0",
	recipe = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:dirt", "default:mese","default:dirt",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})
if multidimensions.limeted_nametag==true and minetest.setting_getbool("unlimited_player_transfer_distance")~=false then
	minetest.setting_setbool("unlimited_player_transfer_distance",false)
	minetest.setting_set("player_transfer_distance",multidimensions.max_distance)
	minetest.setting_save()
elseif multidimensions.limeted_nametag==false and minetest.setting_getbool("unlimited_player_transfer_distance")==false then
	minetest.setting_setbool("unlimited_player_transfer_distance",true)
	minetest.setting_set("player_transfer_distance",0)
	minetest.setting_save()
end

local del_un=1 --remove unnecessary memory
for i, dim in pairs(multidimensions.dimensions) do
	multidimensions.dimensions[del_un].nature=nil
	multidimensions.dimensions[del_un].blob=nil
	multidimensions.dimensions[del_un].color=nil
	multidimensions.dimensions[del_un].ores=nil
	multidimensions.dimensions[del_un].craft=nil
	multidimensions.dimensions[del_un][1]=nil
	multidimensions.dimensions[del_un][2]=nil
	multidimensions.dimensions[del_un][3]=nil
	del_un=del_un+1
end
ores=nil
