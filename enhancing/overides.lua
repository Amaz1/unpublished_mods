local old_handle_node_drops = minetest.handle_node_drops

function minetest.handle_node_drops(pos, drops, digger)
	local item = digger:get_wielded_item():get_name()
	-- are we holding Lava Pick?
	if (item:sub(1, 13) .. item:sub(-8, -2)) ~= "enhancing:axe_lucky_" then
		print(":")
		return old_handle_node_drops(pos, drops, digger)
	end

	-- reset new smelted drops
	local new_drops = {}

	-- loop through current node drops
	for _, drop in pairs(drops) do

		-- get cooked output of current drops
		local stack = ItemStack(drop)
		if stack:get_name():find("tree") then
			local output = minetest.get_craft_result({
				method = "normal",
				width = 3,
				items = {drop}
			})

			-- if we have cooked result then add to new list
			if output
			and output.item
			and not output.item:is_empty() then
				table.insert(new_drops,
					ItemStack({
						name = output.item:get_name(),
						count = output.item:to_table().count + math.random(0, math.ceil(tonumber(item:sub(-1)*1.5))),
					})
				)
			else -- if not then return normal drops
				table.insert(hot_drops, stack)
			end
		else
			print(":(")
		end
	end

	return old_handle_node_drops(pos, new_drops, digger)
end

local pick_drops = {
	"default:stone_with_gold",
	"default:stone_with_coal",
	"default:stone_with_iron",
	"default:stone_with_mese",
	"default:stone_with_diamond",
}

for _, v in pairs(pick_drops) do
	minetest.override_item(v, {
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local pick = digger:get_wielded_item():get_name()
			local inv = digger:get_inventory()
			if (pick:sub(1, 14) .. pick:sub(-8, -2)) ~= "enhancing:pick_lucky_" then
				print(":(")
				return
			end
			local drops = minetest.get_node_drops(v, digger:get_wielded_item())
			if inv:room_for_item("main", drops[1]) then
				inv:add_item("main", drops[1] .. " " .. math.random(0, tonumber(pick:sub(-1))))
			end
		end	
	})
end
