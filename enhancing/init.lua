enhancing = {}
enhancing.crafts = {}
--
-- Formspecs
--
local formspec = "size[8,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_player;main;0,3.75;8,1;]"..
	"list[current_player;main;0,5;8,3;8]"..
	"list[context;enhance;2,0.25;3,3;]"..
	"list[context;fuel;5,2.25;1,1;]"..
	"image[5,0.25;1,1;gui_furnace_arrow_bg.png^[lowpart:0"..
	":gui_furnace_arrow_fg.png]"..
	"image[5,1.25;1,1;default_furnace_fire_bg.png^[lowpart:"..
	"0:default_furnace_fire_fg.png]"

local function tablematch(t1, t2)
	for i=1,9 do
		if t1[i] ~= t2[i] then return false end
	end
	return true
end

local function check_craft(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local x = {}
	local wear = 0
	for i,v in pairs(inv:get_list("enhance")) do
		local w = v:get_name()
		if w ~= "" then
			x[i] = w
			if i == 5 then
				wear = v:get_wear()
			end
		end
	end
	for i,v in pairs(enhancing.crafts) do
		if tablematch(x, v) then			
			return true, i, v.time, v.texture, wear
		end
	end
	return false
end

local function crafted(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for i = 1,9 do
		local c = inv:get_stack("enhance", i):get_count() - 1
		local n = inv:get_stack("enhance", i):get_name()
		inv:set_stack("enhance", i, n .. " " .. c)
	end
end

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("enhance") and inv:is_empty("fuel")
end

function enhancing.add_craft(output, recipe)
	local output_name = string.gsub(output, ":", "_", 1)
	enhancing.crafts[output_name] = recipe
end

local function furnace_node_timer(pos, elapsed)
	--
	-- Inizialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local enhance = inv:get_list("enhance")
	local fuel = inv:get_list("fuel")

	--
	-- Cooking
	--

	-- Check if we have cookable content
	local cookable, output, time, material, wear = check_craft(pos)
	-- Check if we have enough fuel to burn
	if fuel_time < fuel_totaltime then
		-- The furnace is currently active and has enough fuel
		fuel_time = fuel_time + 1

		-- If there is a cookable item then check if it is ready yet
		if cookable then
			src_time = src_time + 1
			if src_time >= time then
				-- Place result in dst list if possible
				local item = minetest.add_item({x=pos.x, y=pos.y+1, z=pos.z}, 
					string.gsub(output, "_", ":", 1) .. " 1 " .. wear)
				item:setvelocity({x=0, y=10, z=0})
				minetest.add_particlespawner({
					amount = 30,
					time = 1,
					minpos = {x=pos.x, y=pos.y+1, z=pos.z},
					maxpos = {x=pos.x, y=pos.y+1, z=pos.z},
					minvel = {x=-2, y=3, z=-2},
					maxvel = {x=2, y=6, z=2},
					minacc = {x=-1, y=2, z=-1},
					maxacc = {x=1, y=4, z=1},
					minexptime = 1,
					maxexptime = 2,
					minsize = 1,
					maxsize = 2,
					texture = material,
				})
				src_time = 0
				crafted(pos)
			end
		end
	else
		-- Furnace ran out of fuel
		if cookable then
			-- We need to get new fuel
			local fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuel})

			if fuel.time == 0 then
				-- No valid fuel in fuel list
				fuel_totaltime = 0
				fuel_time = 0
				src_time = 0
			else
				-- Take fuel from fuel list
				inv:set_stack("fuel", 1, afterfuel.items[1])

				fuel_totaltime = fuel.time
				fuel_time = 0
			end
		else
			-- We don't need to get new fuel since there is no cookable item
			fuel_totaltime = 0
			fuel_time = 0
			src_time = 0
		end
	end

	--
	-- Update formspec, infotext and node
	--

	local item_state = ""

	local fuel_state = "Empty"
	local active = "inactive "
	local result = false
	local item_percent = 0
	local new_formspec = formspec
	if time then
		item_percent = math.floor(src_time / time * 100)
	end
	if fuel_time <= fuel_totaltime and fuel_totaltime ~= 0 then
		result = true
		local fuel_percent = math.floor(fuel_time / fuel_totaltime * 100)
		new_formspec = new_formspec .. 
			"image[5,0.25;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
			(item_percent)..":gui_furnace_arrow_fg.png]"..
			"image[5,1.25;1,1;default_furnace_fire_bg.png^[lowpart:"..
			(100-fuel_percent)..":default_furnace_fire_fg.png]"
	else
		local timer = minetest.get_node_timer(pos)
		timer:stop()
	end

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_string("formspec", new_formspec)
	--print(time, item_percent, src_time)

	return result
end

--
-- Node definitions
--

minetest.register_node("enhancing:workshop", {
	description = "Enhancment Workshop",
	tiles = {
		"enhancing_table_top.png",
		"enhancing_table_bottom.png",
		"enhancing_table_side.png",
		"enhancing_table_side.png",
		"enhancing_table_side.png",
		"enhancing_table_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, -0.375, 0.5, 0.5}, -- NodeBox1
			{0.375, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, -0.375, 0.5, -0.375}, -- NodeBox3
			{0.375, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox4
			{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, -- NodeBox5
			{-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}, -- NodeBox6
		}
	},
	can_dig = can_dig,

	on_timer = furnace_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("enhance", 9)
		inv:set_size("fuel", 1)
		meta:set_string("infotext", "Enhancment Workshop")
		meta:set_string("formspec", formspec)
	end,

	on_metadata_inventory_move = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
				return stack:get_count()
			else
				return 0
			end
		else
			return stack:get_count()
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel", width=1,
				items={inv:get_stack(from_list, from_index)}}).time ~= 0 then
				return count
			else
				return 0
			end
		else
			return count
		end
	end,
})

dofile(minetest.get_modpath("enhancing") .. "/defs.lua")
dofile(minetest.get_modpath("enhancing") .. "/overides.lua")

