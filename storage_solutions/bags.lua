local function form(name, inv, i)
	local hy = i + 5
	minetest.show_formspec(name, "test",
		"size[8," .. hy .. "]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_player;" .. inv .. ";0,0.3;8, " .. i ..";]" ..
		"list[current_player;main;0," .. hy - 3.95 .. ";8,1;]" ..
		"list[current_player;main;0," .. hy - 2.78 .. ";8,3;8]" ..
		"listring[current_name;main]" ..
		"listring[current_player;main]")
end

local function xxl_form(name, inv)
	minetest.show_formspec(name, "test",
		"size[16,9]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_player;" .. inv .. ";0,0.3;16,4;]" ..
		"list[current_player;main;4,4.85;8,1;]" ..
		"list[current_player;main;4,6.08;8,3;8]" ..
		"listring[current_name;main]" ..
		"listring[current_player;main]")
end

minetest.register_craftitem("storage_solutions:small_bag", {
	description = "Small Bag",
	inventory_image = "wool_brown.png",
	stack_max = 1,
	on_use = function(itemstack, user)
		local name = user:get_player_name()
		if itemstack:get_metadata() == "" then
			itemstack:set_metadata(math.random(50)^2 .. math.random(1, 1000)
				.. name .. "ssb" .. math.random())
		end
		local meta = itemstack:get_metadata()
		local inv = minetest.get_inventory({type = "player", name = name})
		inv:set_size(meta, 8)
		form(name, meta, 1)
		return itemstack
	end,
})

minetest.register_craftitem("storage_solutions:medium_bag", {
	description = "Medium Bag",
	inventory_image = "wool_brown.png",
	stack_max = 1,
	on_use = function(itemstack, user)
		local name = user:get_player_name()
		if itemstack:get_metadata() == "" then
			itemstack:set_metadata(math.random(50)^2 .. math.random(1, 1000)
				.. name .. "smb" .. math.random())
		end
		local meta = itemstack:get_metadata()
		local inv = minetest.get_inventory({type = "player", name = name})
		inv:set_size(meta, 16)
		form(name, meta, 2)
		return itemstack
	end,
})

minetest.register_craftitem("storage_solutions:large_bag", {
	description = "Large Bag",
	inventory_image = "wool_brown.png",
	stack_max = 1,
	on_use = function(itemstack, user)
		local name = user:get_player_name()
		if itemstack:get_metadata() == "" then
			itemstack:set_metadata(math.random(50)^2 .. math.random(1, 1000)
				.. name .. "slb" .. math.random())
		end
		local meta = itemstack:get_metadata()
		local inv = minetest.get_inventory({type = "player", name = name})
		inv:set_size(meta, 24)
		form(name, meta, 3)
		return itemstack
	end,
})

minetest.register_craftitem("storage_solutions:mad_mese_bag", {
	description = "Mad Mese Bag",
	inventory_image = "wool_brown.png",
	stack_max = 1,
	on_use = function(itemstack, user)
		local name = user:get_player_name()
		if itemstack:get_metadata() == "" then
			itemstack:set_metadata(math.random(50)^2 .. math.random(1, 1000)
				.. name .. math.random())
		end
		local meta = itemstack:get_metadata()
		local inv = minetest.get_inventory({type = "player", name = name})
		inv:set_size(meta, 64)
		xxl_form(name, meta)
		return itemstack
	end,
})

minetest.register_craft({
	output = "storage_solutions:small_bag",
	recipe = {
		{"wool:brown", "wool:brown", "wool:brown"},
		{"wool:brown", "", "wool:brown"},
		{"wool:brown", "wool:brown", "wool:brown"},
	}
})

minetest.register_craft({
	output = "storage_solutions:medium_bag",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"default:steelblock", "storage_solutions:small_bag", "default:steelblock"},
		{"default:steelblock", "default:steelblock", "default:steelblock"},
	}
})

minetest.register_craft({
	output = "storage_solutions:large_bag",
	recipe = {
		{"default:diamondblock", "default:diamondblock", "default:diamondblock"},
		{"default:diamondblock", "storage_solutions:medium_bag", "default:diamondblock"},
		{"default:diamondblock", "default:diamondblock", "default:diamondblock"},
	}
})

minetest.register_craft({
	output = "storage_solutions:mad_mese_bag",
	recipe = {
		{"default:mese", "default:mese", "default:mese"},
		{"default:mese", "storage_solutions:large_bag", "default:mese"},
		{"default:mese", "default:mese", "default:mese"},
	}
})

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	local name = itemstack:get_name()
	if name:find("storage_solutions:") and name:find("_bag") then
		local stack = old_craft_grid[5]
		local meta = stack:get_metadata()
		if meta ~= "" then
			itemstack:set_metadata(meta)
		end
	end
end)
