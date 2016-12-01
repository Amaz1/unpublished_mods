local pinpad = "size[6,5]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	"button[1,1;1,1;1;1]" ..
	"button[2,1;1,1;2;2]" ..
	"button[3,1;1,1;3;3]" ..
	"button[1,2;1,1;4;4]" ..
	"button[2,2;1,1;5;5]" ..
	"button[3,2;1,1;6;6]" ..
	"button[1,3;1,1;7;7]" ..
	"button[2,3;1,1;8;8]" ..
	"button[3,3;1,1;9;9]" ..
	"button[2,4;1,1;0;0]"

local chest_formspec =
	"size[8,9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,4;]" ..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,4.85)

storage_solutions.pins = {}

local tmp
local file = io.open(minetest.get_worldpath().."/pins", "r")
if file then
	tmp = minetest.deserialize(file:read("*all"))
	file:close()
end

if tmp ~= nil then
	storage_solutions.pins = tmp[1]
end

local function save_pins()
	local file = io.open(minetest.get_worldpath().."/pins", "w")
	if (file) then
		file:write(minetest.serialize({storage_solutions.pins}))
		file:close()
	end
end

minetest.register_node("storage_solutions:pin_chest", {
	description = "PIN Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", pinpad)
		meta:set_string("pin", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name() ..
			" from chest at " .. minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local pin = meta:get_string("pin")
		if #pin < 4 then
			for i = 0, 9 do
				if fields[tostring(i)] then
					meta:set_string("pin", pin .. i)
				end
			end
			pin = meta:get_string("pin")
			if #pin == 4 then
				minetest.chat_send_player(sender:get_player_name(),
					"The pin for this chest is: " .. pin)
				storage_solutions.pins[pos.x .. pos.y .. pos.z] = pin
				meta:set_string("pin", "Configured")
				save_pins()
				minetest.show_formspec(sender:get_player_name(),
					"storage_solutions:pin_chest",
					chest_formspec)
			end
		else
			local tmp = meta:get_string("tmp_pin")
			for i = 0, 9 do
				if fields[tostring(i)] then
					meta:set_string("tmp_pin", tmp .. i)
				end
			end
			tmp = meta:get_string("tmp_pin")
			if #tmp == 4 then
				meta:set_string("tmp_pin", nil)
				local pin = meta:get_string("pin")
				if storage_solutions.pins[pos.x .. pos.y .. pos.z] == tmp then
					minetest.show_formspec(sender:get_player_name(),
						"storage_solutions:pin_chest",
						chest_formspec)
				else
					minetest.chat_send_player(sender:get_player_name(),
						"Try again!")
				end
			end
		end				 
	end,
})
