-- Nodes

minetest.register_node("asteroid:stone", {
	description = "Asteroid Stone",
	tiles = {"asteroid_stone.png"},
	groups = {cracky=3},
	drop = "asteroid:cobble",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:cobble", {
	description = "Asteroid Cobble",
	tiles = {"asteroid_cobble.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:gravel", {
	description = "Asteroid Gravel",
	tiles = {"default_gravel.png"},
	groups = {crumbly=2, not_in_creative_inventory=1},
	drop = "default:gravel",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.2},
	}),
})

minetest.register_node("asteroid:dust", {
	description = "Asteroid Dust",
	tiles = {"asteroid_dust.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.1},
	}),
})

minetest.register_node("asteroid:ironore", {
	description = "Asteroid Iron Ore",
	tiles = {"asteroid_stone.png^default_mineral_iron.png"},
	groups = {cracky=2, not_in_creative_inventory=1},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:copperore", {
	description = "Asteroid Copper Ore",
	tiles = {"asteroid_stone.png^default_mineral_copper.png"},
	groups = {cracky=2, not_in_creative_inventory=1},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:atmos", {
	description = "Asteroid Atmosphere",
	drawtype = "glasslike",
	tiles = {"asteroid_atmos.png"},
	alpha = 0, -- disable this line for opaque atmosphere and higher FPS
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	post_effect_color = {a=23, r=241, g=248, b=255},
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("asteroid:stonebrick", {
	description = "Asteriod Stone Brick",
	tiles = {"asteroid_stonebricktop.png", "asteroid_stonebrickbot.png", "asteroid_stonebrick.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:meteorite_chunks_ore", {
	description = "Meteorite Chunks (Ore)",
	tiles = {"asteroid_stone.png^asteroid_meteorite_chunks.png"},
	groups = {cracky=3},
	drop = "asteroid:meteorite_chunk",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:meteorite_chunk", {
	description = "Meteorite Chunk",
	tiles = {"asteroid_stone.png^asteroid_meteorite_chunks.png"},
	groups = {cracky=3},
	drop = "asteroid:meteorite_chunk",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:meteorite_block", {
	description = "Meteorite Block",
	tiles = {"asteroid_meteorite_block.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

stairs.register_stair_and_slab("asteroid_stone", "asteroid:stone",
	{cracky=3},
	{"asteroid_stone.png"},
	"Asteroid Stone Stair",
	"Asteroid Stone Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab("asteroid_stonebrick", "asteroid:stonebrick",
	{cracky=3},
	{"asteroid_stonebricktop.png", "asteroid_stonebrickbot.png", "asteroid_stonebrick.png"},
	"Asteroid Stone Brick Stair",
	"Asteroid Stone Brick Slab",
	default.node_sound_stone_defaults()
)

-- Crafting

minetest.register_craft({
	type = "cooking",
	output = "asteroid:stone",
	recipe = "asteroid:cobble",
})

minetest.register_craft({
	output = "asteroid:stonebrick 4",
	recipe = {
		{"asteroid:stone", "asteroid:stone"},
		{"asteroid:stone", "asteroid:stone"},
	}
})
