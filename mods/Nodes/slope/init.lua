local slope_cbox = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
		{-0.5,     0,     0, 0.5,  0.25, 0.5},
		{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
	}
}

local slope_cbox_long = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -1.5,  0.5, -0.375, 0.5},  --  NodeBox1
		{-0.5, -0.375, -1.25, 0.5, -0.25,  0.5},  --  NodeBox2
		{-0.5, -0.25,  -1,    0.5, -0.125, 0.5},  --  NodeBox3
		{-0.5, -0.125, -0.75, 0.5,  0,     0.5},  --  NodeBox4
		{-0.5,  0,     -0.5,  0.5,  0.125, 0.5},  --  NodeBox5
		{-0.5,  0.125, -0.25, 0.5,  0.25,  0.5},  --  NodeBox6
		{-0.5,  0.25,   0,    0.5,  0.375, 0.5},  --  NodeBox7
		{-0.5,  0.375,  0.25, 0.5,  0.5,   0.5},  --  NodeBox8
	}
}

local icorner_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- NodeBox5
		{-0.5, -0.5, -0.25, 0.5, 0, 0.5}, -- NodeBox6
		{-0.5, -0.5, -0.5, 0.25, 0, 0.5}, -- NodeBox7
		{-0.5, 0, -0.5, 0, 0.25, 0.5}, -- NodeBox8
		{-0.5, 0, 0, 0.5, 0.25, 0.5}, -- NodeBox9
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}, -- NodeBox10
		{-0.5, 0.25, -0.5, -0.25, 0.5, 0.5}, -- NodeBox11
	}
}

local ocorner_cbox = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5,   0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25,  0.25,     0, 0.5},
		{-0.5,     0,     0,     0,  0.25, 0.5},
		{-0.5,  0.25,  0.25, -0.25,   0.5, 0.5}
	}
}

local short_pyr_cbox = {
	type = "fixed",
	fixed = {
		{ -0.5,   -0.5,   -0.5,   0.5,   -0.375, 0.5 },
		{ -0.375, -0.375, -0.375, 0.375, -0.25,  0.375},
		{ -0.25,  -0.25,  -0.25,  0.25,  -0.125, 0.25},
		{ -0.125, -0.125, -0.125, 0.125,  0,     0.125}
	}
}

local tall_pyr_cbox = {
	type = "fixed",
	fixed = {
		{ -0.5,   -0.5,  -0.5,   0.5,  -0.25, 0.5 },
		{ -0.375, -0.25, -0.375, 0.375, 0,    0.375},
		{ -0.25,   0,    -0.25,  0.25,  0.25, 0.25},
		{ -0.125,  0.25, -0.125, 0.125, 0.5,  0.125}
	}
}

local slope_fronthalf_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -0.5,  0.5, -0.375, 0.5},  --  NodeBox1
		{-0.5, -0.375, -0.25, 0.5, -0.25,  0.5},  --  NodeBox2
		{-0.5, -0.25,  0,    0.5, -0.125, 0.5},  --  NodeBox3
		{-0.5, -0.125, 0.25, 0.5,  0,     0.5},  --  NodeBox4
	}
}

local slope_backhalf_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -0.5,  0.5, 0.125, 0.5},  --  NodeBox1
		{-0.5, 0.125, -0.25, 0.5, 0.25,  0.5},  --  NodeBox2
		{-0.5, 0.25,  0,    0.5, 0.375, 0.5},  --  NodeBox3
		{-0.5, 0.375, 0.25, 0.5,  0.5,     0.5},  --  NodeBox4
	}
}


local source_list = {
	{"black", "Darkened", "292421", 40, 36, 33}, 
	{"blue", "Blue", "0000FF", 0, 0, 255},
	{"green", "Green", "00FF00", 0, 255, 0}, 
	{"white", "White", "F5F5F5", 245, 245, 245}, 
	{"orange", "Orange", "FF6103", 255, 97, 3}, 
	{"red", "Red", "FF0000", 255, 0, 0}, 
	{"yellow", "Yellow", "FFFF00", 255, 255, 0}, 
	{"pink", "pink", "FF69B4", 255, 105, 180}
}

for i in ipairs(source_list) do
	local name = source_list[i][1]
	local desc = source_list[i][2]
	local colour = source_list[i][3]
	local red = source_list[i][4]
	local green = source_list[i][5]
	local blue = source_list[i][6]	

 minetest.register_node("slope:edge_" .. name, {
 	description = desc .. "edge",
wield_image = "none.png",
inventory_image = "edge.png^[colorize:#"..colour..":70",
 	drawtype = "mesh",
 	mesh = "slope_test_quarter_round_onetexture.obj",
 	 tiles = {"color_"..name..".png"},
 	paramtype = "light",
 	paramtype2 = "facedir",
 	groups = {cracky=3, oddly_breakable_by_hand=2},
	sounds = default.node_sound_stone_defaults(),
 	on_place = minetest.rotate_node,
 })

minetest.register_node("slope:edgecorner_" .. name, {
 	description = desc .. "edge",
wield_image = "none.png",
inventory_image = "edgecorner.png^[colorize:#"..colour..":70",
 	drawtype = "mesh",
 	mesh = "slope_test_quarter_round_corner_onetexture.obj",
 	 tiles = {"color_"..name..".png"},
 	paramtype = "light",
 	paramtype2 = "facedir",
 	groups = {cracky=3, oddly_breakable_by_hand=2},
	sounds = default.node_sound_stone_defaults(),
 	on_place = minetest.rotate_node,
 })

minetest.register_node("slope:slope_"..name, {
        description = desc.. " slope",
wield_image = "none.png",
inventory_image = "triangle.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_slope.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        on_place = minetest.rotate_node,
        collision_box = slope_cbox,
        selection_box = slope_cbox,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

    minetest.register_node("slope:ocorner_"..name, {
        description = desc.." slope (outer corner)",
wield_image = "none.png",
inventory_image = "cornera.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_ocorner.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
        sounds = default.node_sound_wood_defaults(),
        on_place = minetest.rotate_node,
        collision_box = ocorner_cbox,
        selection_box = ocorner_cbox,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })
    minetest.register_node("slope:icorner_"..name, {
        description = desc.." slope (inner corner)",
wield_image = "none.png",
inventory_image = "cornerb.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_icorner.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        on_place = minetest.rotate_node,
        collision_box = ocorner_cbox,
        selection_box = ocorner_cbox,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

    minetest.register_node("slope:slopelong_"..name, {
        description = desc.." long slope",
wield_image = "none.png",
inventory_image = "long.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_slope_long.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        on_place = minetest.rotate_node,
        collision_box = slope_cbox_long,
        selection_box = slope_cbox_long,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

    minetest.register_node("slope:cylinder_"..name, {
        description = desc.." cylinder",
wield_image = "none.png",
inventory_image = "cylinder.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_cylinder.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        on_place = minetest.rotate_node,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

    minetest.register_node("slope:cone_"..name, {
        description = desc.." cone",
wield_image = "none.png",
inventory_image = "cone.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_cone_onetexture.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, cracky=3, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        on_place = minetest.rotate_node,
        selection_box = tall_pyr_cbox,
        collision_box = tall_pyr_cbox,
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

    minetest.register_node("slope:sphere_"..name, {
        description = desc.." sphere",
wield_image = "none.png",
inventory_image = "sphere.png^[colorize:#"..colour..":70",
        drawtype = "mesh",
        mesh = "slope_test_sphere_onetexture.obj",
        tiles = {"color_"..name..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy=2, cracky=3, oddly_breakable_by_hand=2},
        sounds = default.node_sound_defaults(),
        oddly_breakable_by_hand = 1,
        dig_immediate = 3,
    })

end
