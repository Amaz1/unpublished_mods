local function msu_formspec(meta)
	local node = minetest.registered_items[meta:get_string("name")]
	if not node then
		node = "Empty"
	else
		node = node.description
	end
	meta:set_string("formspec", "size[8,6.5]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_name;input;1,0.5;1,1;]" ..
		"list[current_name;output;6,0.5;1,1;]" ..
		"label[2,0.5;" .. node	.. "]" ..
		"label[2,1;" .. meta:get_int("count") .. " items]" ..
		"label[2,1.5;" .. math.floor(meta:get_int("count") / 99)
		.. " stacks]" ..
		"list[current_player;main;0,2.25;8,1;]" ..
		"list[current_player;main;0,3.5;8,3;8]" ..
		"listring[current_player;main]" ..
		"listring[context;input]" ..
		"listring[context;output]" ..
		"listring[current_player;main]"
	)
	
end

minetest.register_node("storage_solutions:mass_storage_unit", {
	description = "Mass Storage Unit",
	tiles = {"storage_solutions_msu.png", "storage_solutions_msu_detail.png"},
	drawtype = "glasslike_framed",
	paramtype = "light",
	visual_scale = 0.5,
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("name", "Empty")
		meta:set_int("count", 0)
		msu_formspec(meta)
		meta:set_string("infotext", "Empty Mass Storage Unit")
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("output", 1)
	end,
	can_dig = function(pos,player)
		local count = minetest.get_meta(pos):get_int("count")
		if count == 0 then
			return true
		else
			return false
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local node = meta:get_string("name")
		if listname == "input" and minetest.registered_items[stack:get_name()]
		and minetest.registered_items[stack:get_name()].stack_max >= 99 then
			if stack:get_name() == node or node == "Empty" then
				return stack:get_count()
			end
		end
		return 0
	end,
	allow_metadata_inventory_move = function()
		return 0
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		meta:set_string("name", stack:get_name())
		meta:set_int("count", meta:get_int("count") + stack:get_count())
		msu_formspec(meta)
		local name = minetest.registered_items[meta:get_string("name")].description
		meta:set_string("infotext", "Mass Storage Unit containing: " .. name)
		local inv = meta:get_inventory()
		inv:set_stack("input", 1, "")
		if meta:get_int("count") > 99 then
			inv:set_stack("output", 1, meta:get_string("name") .. " " .. 99)
		else
			inv:set_stack("output", 1, 
				meta:get_string("name") .. " " .. meta:get_int("count"))
		end
		minetest.show_formspec(player:get_player_name(),
			"msu", meta:get_string("formspec"))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		meta:set_int("count", meta:get_int("count") - stack:get_count())
		local inv = meta:get_inventory()
		inv:set_stack("input", 1, "")
		if meta:get_int("count") > 99 then
			inv:set_stack("output", 1, meta:get_string("name") .. " " .. 99)
		elseif meta:get_int("count") == 0 then
			meta:set_string("name", "Empty")
			meta:set_string("infotext", "Empty Mass Storage Unit")
		else
			inv:set_stack("output", 1, 
				meta:get_string("name") .. " " .. meta:get_int("count"))
		end
		msu_formspec(meta)
		minetest.show_formspec(player:get_player_name(),
			"msu", meta:get_string("formspec"))
	end,
})
