character_creator = {}
character_creator.skins = dofile(minetest.get_modpath("character_creator") .. "/skins.lua")

local skinsdb
if minetest.get_modpath("skinsdb") and minetest.global_exists("skins") then
	skinsdb = skins
end

local skin_default = {
	gender     = "Male",
	height     = 2,
	width      = 2,
	skin       = "Panda Skin",
	tshirt     = "None T-Shirt",
	pants      = "None Shoes",
}

local skins = character_creator.skins
local skins_array = {}

minetest.after(0, function()
	local function associative_to_array(associative)
		local array = {}
		for key in pairs(associative) do
			table.insert(array, key)
		end
		return array
	end

	skins_array = {
		skin       = associative_to_array(skins.skin),
		tshirt     = associative_to_array(skins.tshirt),
		pants      = associative_to_array(skins.pants),
	}
end)

-- Saved skins_array indexes in this
local skin_indexes = {}

local function show_formspec(player)
	local indexes = skin_indexes[player] 

		 local formspec = "size[8,7.5]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. ""

      -- Skin
		.. "button[2.3,1;2,1;skin;" .. skins_array.skin[indexes.skin] .. "]"
		.. "button[0.0,1;2,1;skin_back;<<]"
		.. "button[4.6,1;2,1;skin_next;>>]"
		-- T-Shirt
		.. "button[2.3,3;2,1;tshirt;" .. skins_array.tshirt[indexes.tshirt] .. "]"
		.. "button[0.0,3;2,1;tshirt_back;<<]"
		.. "button[4.6,3;2,1;tshirt_next;>>]"
		-- Pants
		.. "button[2.3,5;2,1;pants;" .. skins_array.pants[indexes.pants] .. "]"
		.. "button[0.0,5;2,1;pants_back;<<]"
		.. "button[4.6,5;2,1;pants_next;>>]"
		-- Done
		.. "button_exit[0.0,7;2,1;main;Exit]"

	minetest.show_formspec(player:get_player_name(), "character_creator", formspec)
end

local function load_skin(player)
	skin_indexes[player] = {}

	if not player:get_attribute("character_creator:gender") then
		player:set_attribute("character_creator:gender", skin_default.gender)
	end

	if not player:get_attribute("character_creator:width") then
		player:set_attribute("character_creator:width", skin_default.width)
	end

	if not player:get_attribute("character_creator:height") then
		player:set_attribute("character_creator:height", skin_default.height)
	end

	local function load_data(data_name)
		local key   = player:get_attribute("character_creator:" .. data_name)
		local index = table.indexof(skins_array[data_name], key)
		if index == -1 then
			index = table.indexof(skins_array[data_name], skin_default[data_name])
		end

		local indexes = skin_indexes[player]
		indexes[data_name] = index
	end

	load_data("skin")
	load_data("tshirt")
	load_data("pants")
end

local function save_skin(player)
	local function save_data(data_name)
		local indexes = skin_indexes[player]
		local index   = indexes[data_name]
		local key     = skins_array[data_name][index]
		player:set_attribute("character_creator:" .. data_name, key)
	end

	save_data("skin")
	save_data("tshirt")
	save_data("pants")
end

local function get_texture(player)
	local indexes = skin_indexes[player]
	local texture = ""
	local gender = player:get_attribute("character_creator:gender")

	local skin_key = skins_array.skin[indexes.skin]
	local skin = skins.skin[skin_key]
	texture = texture .. skin

	local tshirt_key = skins_array.tshirt[indexes.tshirt]
	local tshirt = skins.tshirt[tshirt_key]
	texture = texture .. "^" .. tshirt

	local pants_key = skins_array.pants[indexes.pants]
	local pants = skins.pants[pants_key]
	texture = texture .. "^" .. pants

	return texture
end

local function change_skin(player)
	local texture = get_texture(player)

	local width  = tonumber(player:get_attribute("character_creator:width"))
	local height = tonumber(player:get_attribute("character_creator:height"))

	player:set_properties({
		visual_size = {
			x = width,
			y = height
		}
	})

	local name = player:get_player_name()

	if minetest.get_modpath("multiskin") then
		multiskin.layers[name].skin = texture
		armor:set_player_armor(player)
		multiskin:set_player_textures(player, {textures = {texture}})
	elseif minetest.get_modpath("3d_armor") then
		armor.textures[name].skin = texture
		armor:set_player_armor(player)
	else
		player:set_properties({textures = {texture}})
	end

	save_skin(player)
end

if skinsdb then
	--change skin redefinition for skinsdb
	function change_skin(player)
		local playername = player:get_player_name()
		local skinname = "character_creator:"..playername
		local skin_obj = skinsdb.get(skinname) or skinsdb.new(skinname)
		skin_obj:set_meta("format", "1.0")
		skin_obj:set_meta("visual_size_x", tonumber(player:get_attribute("character_creator:width")))
		skin_obj:set_meta("visual_size_y", tonumber(player:get_attribute("character_creator:height")))
		skin_obj:apply_skin_to_player(player)
		skinsdb.assign_player_skin(player, "character_creator:"..playername)
		save_skin(player)
	end
end

minetest.register_on_joinplayer(function(player)
	load_skin(player)
	if skinsdb then
		local playername = player:get_player_name()
		local skinname = "character_creator:"..playername
		local skin_obj = skinsdb.get(skinname) or skinsdb.new(skinname)
		-- redefinitions
		function skin_obj:set_skin(player)
			if not player or not skin_indexes[player] then
				return -- not loaded or disconnected
			end
			change_skin(player)
			show_formspec(player)
		end
		function skin_obj:get_texture()
			return get_texture(minetest.get_player_by_name(self:get_meta("playername")))
		end

		-- set data
		skin_obj:set_preview("inventory_plus_character_creator.png")
		skin_obj:set_meta("name","Character Creator")
		--skin_obj:set_meta("author", "???")
		skin_obj:set_meta("license", "MIT / CC-BY-SA 3.0 Unported")
		skin_obj:set_meta("playername",playername)
		--check if active and start the update (avoid race condition for both register_on_joinplayer)
		if skinsdb.get_player_skin(player):get_key() == skinname then
			minetest.after(0, change_skin, player)
		end
	else
		minetest.after(0, change_skin, player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	if skinsdb then
		local skinname = "character_creator:"..player:get_player_name()
		skinsdb.meta[skinname] = nil
	end
	skin_indexes[player] = nil
end)

local skin_temp = {}
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "character_creator" then
		return
	end

	local indexes = skin_indexes[player]
	if not skin_temp[player] then
		skin_temp[player] = {
			gender = player:get_attribute("character_creator:gender"),
			width = player:get_attribute("character_creator:width"),
			height = player:get_attribute("character_creator:height"),
			indexes = table.copy(indexes)
		}
	end

	-- Gender
	do
		if fields.male then
			player:set_attribute("character_creator:gender", "Male")
			player:set_attribute("character_creator:width", 1)
			player:set_attribute("character_creator:height", 1)
		end

		if fields.female then
			player:set_attribute("character_creator:gender", "Female")
			player:set_attribute("character_creator:width", 0.95)
			player:set_attribute("character_creator:height", 1)
		end
	end

	-- Height
	do
		local height = tonumber(player:get_attribute("character_creator:height"))

		if fields.taller and height < 1.25 then
			player:set_attribute("character_creator:height", height + 0.05)
		end

		if fields.shorter and height > 0.75 then
			player:set_attribute("character_creator:height", height - 0.05)
		end
	end

	-- Width
	do
		local width = tonumber(player:get_attribute("character_creator:width"))

		if fields.wider and width < 1.25 then
			player:set_attribute("character_creator:width", width + 0.05)
		end

		if fields.thinner and width > 0.75 then
			player:set_attribute("character_creator:width", width - 0.05)
		end
	end

	-- Switch skin
	do
		local function switch_skin(data_name, next_index)
			local index = indexes[data_name] + next_index
			local max = #skins_array[data_name]

			if index == 0 then
				index = max
			elseif index == (max + 1) then
				index = 1
			end

			indexes[data_name] = index
		end

		for field in pairs(fields) do
			if field:find("_back$") then
				local data_name = field:match("(.+)_back$")
				switch_skin(data_name, -1)
			elseif field:find("_next$") then
				local data_name = field:match("(.+)_next$")
				switch_skin(data_name, 1)
			end
		end
	end

	-- Close or update
	do
		local quit = false

		if fields.cancel then
			local temp = skin_temp[player]
			player:set_attribute("character_creator:gender", temp.gender)
			player:set_attribute("character_creator:width", temp.width)
			player:set_attribute("character_creator:height", temp.height)
			skin_indexes[player] = table.copy(temp.indexes)
			skin_temp[player] = nil
			quit = true
		elseif fields.quit then
			skin_temp[player] = nil
			quit = true
		end

		if not quit then
			show_formspec(player)
		end
	end
	change_skin(player)
end)

minetest.register_chatcommand("skin", {
	func = function(name)
		minetest.after(0.5, function()
			local player = minetest.get_player_by_name(name)
			if player then
				show_formspec(player)
			end
		end)
	end
})

if minetest.global_exists("unified_inventory") then
	unified_inventory.register_button("character_creator", {
		type   = "image",
		image  = "inventory_plus_character_creator.png",
		action = show_formspec
	})
elseif minetest.global_exists("inventory_plus") then
	minetest.register_on_joinplayer(function(player)
		inventory_plus.register_button(player, "character_creator", "Skin")
	end)
	minetest.register_on_player_receive_fields(function(player, _, fields)
		if fields.character_creator then
			show_formspec(player)
		end
	end)
end
