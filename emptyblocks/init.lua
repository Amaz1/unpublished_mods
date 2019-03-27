minetest.register_node("emptyblocks:emptyblock_node", {
	description = "You shouldn't have this!",
	drop = "",
	tiles = {"blank.png"},
	drawtype = "airlike",
	paramtype = "light",
	walkable = false,
	groups = {not_in_creative_inventory = 1},
	selection_box = {
		type = "fixed",
		box = {{-0.1,-0.1,-0.1,0.1,0.1,0.1}}
	},
})

minetest.register_craftitem("emptyblocks:emptyblock_spawner", {
	description = "Empty Block",
	inventory_image = minetest.inventorycube("unknown_node.png"),
	on_place = function(itemstack, _, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local name = minetest.get_node(pointed_thing.under).name
		local textures = minetest.registered_nodes[name].tiles
		if #textures < 6 then
			for i = #textures + 1, 6 do
				textures[i] = textures[#textures]
			end
		end
		for i = 1, 6 do
			if type(textures[i]) == "table" and textures[i].name ~= nil then
				textures[i] = textures[i].name
			end
		end
		minetest.set_node(pointed_thing.above, {name = "emptyblocks:emptyblock_node"})
		local meta = minetest.get_meta(pointed_thing.above)
		meta:set_string("eb", minetest.serialize(textures))
		local obj = minetest.add_entity(pointed_thing.above, "emptyblocks:emptyblock")
		if obj and textures then
			obj:get_luaentity():textures(textures)
			itemstack:take_item(1)
			return itemstack
		end
	end,
})

minetest.register_entity("emptyblocks:emptyblock", {
	initial_properties = {
		visual = "cube",
		weight = 0,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
		physical = true,
		collide_with_objects = false,
		visible = false,
		backface_culling = false,
	},
	on_activate = function(self, staticdata)
		self:textures(minetest.deserialize(staticdata))
		self.object:set_armor_groups({immortal = 1})
	end,
	textures = function(self, textures)
		local prop = {
			textures = textures,
			visible = true,
		}
		self.textures = textures
		self.object:set_properties(prop)
	end,
	get_staticdata = function(self)
		if self.textures ~= nil then
			return minetest.serialize(self.textures)
		end
	end,
	on_punch = function(self, puncher)
		minetest.remove_node(self.object:getpos())
		if puncher then
			local inv = puncher:get_inventory()
			inv:add_item("main", "emptyblocks:emptyblock_spawner")
		end
		self.object:remove()
	end,
})

minetest.register_abm({
	label = "Emptyblock update",
	interval = 10,
	chance = 1,
	nodenames = {"emptyblocks:emptyblock_node"},
	action = function(pos)
		local objs = minetest.get_objects_inside_radius(pos, 0.5)
		for i,v in pairs(objs) do 
			if v:get_entity_name() == "emptyblocks:emptyblock" then
				return
			end
		end
		local obj = minetest.add_entity(pos, "emptyblocks:emptyblock")
		local textures = minetest.deserialize(minetest.get_meta(pos):get_string("eb"))
		if obj and textures then
			obj:get_luaentity():textures(textures)
		end
	end
})

minetest.register_craft({
	output = "emptyblocks:emptyblock_spawner 2",
	recipe = {
		{"default:dirt", "default:sand"},
		{"default:sand", "default:dirt"}
	},
})

minetest.register_node("emptyblocks:emptychest_node", {
	description = "You shouldn't have this!",
	drop = "",
	tiles = {"blank.png"},
	drawtype = "airlike",
	paramtype = "light",
	walkable = false,
	on_construct = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		inv:set_size("main", 8*4)
	end,
	selection_box = {
		type = "fixed",
		box = {{-0.1,-0.1,-0.1,0.1,0.1,0.1}}
	},
})


minetest.register_craftitem("emptyblocks:emptychest_spawner", {
	description = "Empty Block Chest",
	inventory_image = minetest.inventorycube("unknown_item.png"),
	on_place = function(itemstack, _, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local name = minetest.get_node(pointed_thing.under).name
		local textures = minetest.registered_nodes[name].tiles
		if #textures < 6 then
			for i = #textures + 1, 6 do
				textures[i] = textures[#textures]
			end
		end
		for i = 1, 6 do
			if type(textures[i]) == "table" and textures[i].name ~= nil then
				textures[i] = textures[i].name
			end
		end
		minetest.set_node(pointed_thing.above, {name = "emptyblocks:emptychest_node"})
		local meta = minetest.get_meta(pointed_thing.above)
		meta:set_string("eb", minetest.serialize(textures))
		local obj = minetest.add_entity(pointed_thing.above, "emptyblocks:emptychest")
		if obj and textures then
			obj:get_luaentity():textures(textures, pointed_thing.above)
			itemstack:take_item(1)
			return itemstack
		end
	end,
})


minetest.register_entity("emptyblocks:emptychest", {
	initial_properties = {
		visual = "cube",
		weight = 0,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
		physical = true,
		collide_with_objects = true,
		visible = false,
		backface_culling = false,
	},
	on_activate = function(self, staticdata)
		self:textures(minetest.deserialize(staticdata))
		self.object:set_armor_groups({immortal = 1})
	end,
	textures = function(self, textures, pos)
		local prop = {
			textures = textures,
			visible = true,
		}
		self.textures = textures
		self.object:set_properties(prop)
	end,
	get_staticdata = function(self)
		if self.textures ~= nil then
			return minetest.serialize(self.textures)
		end
	end,
	on_rightclick = function(self, clicker)
		minetest.show_formspec(clicker:get_player_name(), "emptychest",
			default.get_chest_formspec(self.object:getpos(), "gui_chestbg.png"))
	end,
	on_punch = function(self, puncher)
		local inv = minetest.get_meta(self.object:getpos()):get_inventory()
		if inv:is_empty("main") == true then
			minetest.remove_node(self.object:getpos())
			if puncher then
				local pinv = puncher:get_inventory()
				pinv:add_item("main", "emptyblocks:emptychest_spawner")
			end
			self.object:remove()
		end
	end,
})

minetest.register_abm({
	label = "Emptychest update",
	interval = 10,
	chance = 1,
	nodenames = {"emptyblocks:emptychest_node"},
	action = function(pos)
		local objs = minetest.get_objects_inside_radius(pos, 0.5)
		for i,v in pairs(objs) do 
			if v:get_entity_name() == "emptyblocks:emptychest" then
				return
			end
		end
		local obj = minetest.add_entity(pos, "emptyblocks:emptychest")
		local textures = minetest.deserialize(minetest.get_meta(pos):get_string("eb"))
		if obj and textures then
			obj:get_luaentity():textures(textures)
		end
	end
})

