function all_crafts(material, i)
	crafts(material, "pick", i)
	crafts(material, "axe", i)
	crafts(material, "shovel", i)
end
function crafts(material, tool, i)
	if i == 1 then
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_quick_1",
			{[1] = "default:obsidian_shard", [2] = "default:obsidian_shard",
			[3] = "default:obsidian_shard", [4] = "default:obsidian_shard",
			[5] = "default:" .. tool .. "_" .. material, [6] = "default:obsidian_shard",
			[7] = "default:obsidian_shard", [8] = "default:obsidian_shard",
			[9] = "default:obsidian_shard", ["time"] = 3, ["texture"] = "default_obsidian_shard.png"}
		)
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_durable_1",
			{[1] = "default:mese_crystal_fragment", [2] = "default:mese_crystal_fragment",
			[3] = "default:mese_crystal_fragment", [4] = "default:mese_crystal_fragment",
			[5] = "default:" .. tool .. "_" .. material, [6] = "default:mese_crystal_fragment",
			[7] = "default:mese_crystal_fragment", [8] = "default:mese_crystal_fragment",
			[9] = "default:mese_crystal_fragment", ["time"] = 3, ["texture"] = "default_mese_crystal_fragment.png"}
		)
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_lucky_1",
			{[1] = "default:diamond", [2] = "default:diamond",
			[3] = "default:diamond", [4] = "default:diamond",
			[5] = "default:" .. tool .. "_" .. material, [6] = "default:diamond",
			[7] = "default:diamond", [8] = "default:diamond",
			[9] = "default:diamond", ["time"] = 3, ["texture"] = "default_diamond.png"}
		)
	else
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_quick_" .. i,
			{[1] = "default:obsidian_shard", [2] = "default:obsidian_shard",
			[3] = "default:obsidian_shard", [4] = "default:obsidian_shard",
			[5] = "enhancing:" .. tool .. "_" .. material .. "_quick_" .. (i-1), [6] = "default:obsidian_shard",
			[7] = "default:obsidian_shard", [8] = "default:obsidian_shard",
			[9] = "default:obsidian_shard", ["time"] = 3*i, ["texture"] = "default_obsidian_shard.png"}
		)
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_durable_" .. i,
			{[1] = "default:mese_crystal_fragment", [2] = "default:mese_crystal_fragment",
			[3] = "default:mese_crystal_fragment", [4] = "default:mese_crystal_fragment",
			[5] = "enhancing:" .. tool .. "_" .. material .. "_durable_" .. (i-1), [6] = "default:mese_crystal_fragment",
			[7] = "default:mese_crystal_fragment", [8] = "default:mese_crystal_fragment",
			[9] = "default:mese_crystal_fragment", ["time"] = 3*i, ["texture"] = "default_mese_crystal_fragment.png"}
		)
		enhancing.add_craft("enhancing:" .. tool .. "_" .. material .. "_lucky_" .. i,
			{[1] = "default:diamond", [2] = "default:diamond",
			[3] = "default:diamond", [4] = "default:diamond",
			[5] = "enhancing:" .. tool .. "_" .. material .. "_lucky_" .. (i-1), [6] = "default:diamond",
			[7] = "default:diamond", [8] = "default:diamond",
			[9] = "default:diamond", ["time"] = 3*i, ["texture"] = "default_diamond.png"}
		)
	end
end

for i = 1, 5 do
	--Wood stuff
	minetest.register_tool("enhancing:pick_wood_quick_" .. i, {
		description = "Wooden Pickaxe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_woodpick.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[3]=1.60-(i*0.2)}, uses=10, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:pick_wood_durable_" .. i, {
		description = "Wooden Pickaxe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_woodpick.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[3]=1.60}, uses=10+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:pick_wood_lucky_" .. i, {
		description = "Wooden Pickaxe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_woodpick.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[3]=1.60}, uses=10, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})

	minetest.register_tool("enhancing:axe_wood_fast_" .. i, {
		description = "Wooden Axe\n" .. minetest.colorize("purple", "Durable: Level " .. i),
		inventory_image = "default_tool_woodaxe.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=0,
			groupcaps={
				choppy = {times={[2]=3.00-(i*0.3), [3]=1.60-(i*0.13)}, uses=10, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:axe_wood_durable_" .. i, {
		description = "Wooden Axe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_woodaxe.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=0,
			groupcaps={
				choppy = {times={[2]=3.00, [3]=1.60}, uses=10+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:axe_wood_lucky_" .. i, {
		description = "Wooden Axe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_woodaxe.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=0,
			groupcaps={
				choppy = {times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})

	minetest.register_tool("enhancing:shovel_wood_quick_" .. i, {
		description = "Wooden Shovel\n" .. minetest.colorize("purple", "Durable: Level " .. i),
		inventory_image = "default_tool_woodshovel.png^[colorize:purple:" .. (40+(i*15)),
		wield_image = "default_tool_woodshovel.png^[transformR90^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				crumbly = {times={[1]=3.00-(i*0.315), [2]=1.60-(i*0.16), [3]=0.60-(i*0.03)}, uses=10, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:shovel_wood_durable_" .. i, {
		description = "Wooden Shovel\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_woodshovel.png^[colorize:yellow:" .. (40+(i*15)),
		wield_image = "default_tool_woodshovel.png^[transformR90^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				crumbly = {times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	--Stone stuff
	minetest.register_tool("enhancing:pick_stone_quick_" .. i, {
		description = "Stone Pickaxe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_stonepick.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.3,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[2]=2.0-(i*0.2), [3]=1.00-(i*0.15)}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})
	minetest.register_tool("enhancing:pick_stone_durable_" .. i, {
		description = "Stone Pickaxe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_stonepick.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.3,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[2]=2.0, [3]=1.00}, uses=20+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})
	minetest.register_tool("enhancing:pick_stone_lucky_" .. i, {
		description = "Stone Pickaxe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_stonepick.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.3,
			max_drop_level=0,
			groupcaps={
				cracky = {times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})

	minetest.register_tool("enhancing:axe_stone_quick_" .. i, {
		description = "Stone Axe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_stoneaxe.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				choppy={times={[1]=3.00-(i*0.4), [2]=2.00-(i*0.29), [3]=1.30-(i*0.18)}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})
	minetest.register_tool("enhancing:axe_stone_durable_" .. i, {
		description = "Stone Axe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_stoneaxe.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				choppy={times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})
	minetest.register_tool("enhancing:axe_stone_lucky_" .. i, {
		description = "Stone Axe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_stoneaxe.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				choppy={times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
	})

	minetest.register_tool("enhancing:shovel_stone_quick_" .. i, {
		description = "Stone Shovel\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_stoneshovel.png^[colorize:purple:" .. (40+(i*15)),
		wield_image = "default_tool_stoneshovel.png^[transformR90^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.4,
			max_drop_level=0,
			groupcaps={
				crumbly = {times={[1]=1.80-(i*0.23), [2]=1.20-(i*0.15), [3]=0.50-(i*0.07)}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	minetest.register_tool("enhancing:shovel_stone_durable_" .. i, {
		description = "Stone Shovel\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_stoneshovel.png^[colorize:yellow:" .. (40+(i*15)),
		wield_image = "default_tool_stoneshovel.png^[transformR90^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.4,
			max_drop_level=0,
			groupcaps={
				crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20+(i*4), maxlevel=1},
			},
			damage_groups = {fleshy=2},
		},
	})
	--Steel stuff
	minetest.register_tool("enhancing:pick_steel_quick_" .. i, {
		description = "Steel Pickaxe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_steelpick.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				cracky = {times={[1]=4-(i*0.37), [2]=1.60-(i*0.2), [3]=0.60-(i*0.065)}, uses=20, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})
	minetest.register_tool("enhancing:pick_steel_durable_" .. i, {
		description = "Steel Pickaxe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_steelpick.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				cracky = {times={[1]=4, [2]=1.60, [3]=0.60}, uses=20+(i*4), maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})
	minetest.register_tool("enhancing:pick_steel_lucky_" .. i, {
		description = "Steel Pickaxe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_steelpick.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				cracky = {times={[1]=4, [2]=1.60, [3]=0.60}, uses=20, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})

	minetest.register_tool("enhancing:axe_steel_quick_" .. i, {
		description = "Steel Axe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_steelaxe.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.50-(i*0.25), [2]=1.40-(i*0.17), [3]=1.00-(i*0.15)}, uses=20, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})
	minetest.register_tool("enhancing:axe_steel_durable_" .. i, {
		description = "Steel Axe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_steelaxe.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=20+(i*4), maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})
	minetest.register_tool("enhancing:axe_steel_lucky_" .. i, {
		description = "Steel Axe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_steelaxe.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=20, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
	})

	minetest.register_tool("enhancing:shovel_steel_quick_" .. i, {
		description = "Steel Shovel\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_steelshovel.png^[colorize:purple:" .. (40+(i*15)),
		wield_image = "default_tool_steelshovel.png^[transformR90^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.1,
			max_drop_level=1,
			groupcaps={
				crumbly = {times={[1]=1.50-(i*0.2), [2]=0.90-(i*0.1), [3]=0.40-(i*0.04)}, uses=30, maxlevel=2},
			},
			damage_groups = {fleshy=3},
		},
	})
	minetest.register_tool("enhancing:shovel_steel_durable_" .. i, {
		description = "Steel Shovel\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_steelshovel.png^[colorize:yellow:" .. (40+(i*15)),
		wield_image = "default_tool_steelshovel.png^[transformR90^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.1,
			max_drop_level=1,
			groupcaps={
				crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30+(i*4), maxlevel=2},
			},
			damage_groups = {fleshy=3},
		},
	})
	--Mese stuff
	minetest.register_tool("enhancing:pick_mese_quick_" .. i, {
		description = "Mese Pickaxe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_mesepick.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=3,
			groupcaps={
				cracky = {times={[1]=2.4-(i*0.3), [2]=1.2-(i*0.12), [3]=0.60-(i*0.075)}, uses=20, maxlevel=3},
			},
			damage_groups = {fleshy=5},
		},
	})
	minetest.register_tool("enhancing:pick_mese_durable_" .. i, {
		description = "Mese Pickaxe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_mesepick.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=3,
			groupcaps={
				cracky = {times={[1]=2.4, [2]=1.2, [3]=0.01}, uses=20+(i*4), maxlevel=3},
			},
			damage_groups = {fleshy=5},
		},
	})
	minetest.register_tool("enhancing:pick_mese_lucky_" .. i, {
		description = "Mese Pickaxe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_mesepick.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=3,
			groupcaps={
				cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20, maxlevel=3},
			},
			damage_groups = {fleshy=5},
		},
	})

	minetest.register_tool("enhancing:axe_mese_quick_" .. i, {
		description = "Mese Axe\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_meseaxe.png^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.20-(i*0.25), [2]=1.00-(i*0.12), [3]=0.60-(i*0.05)}, uses=20, maxlevel=3},
			},
			damage_groups = {fleshy=6},
		},
	})
	minetest.register_tool("enhancing:axe_mese_durable_" .. i, {
		description = "Mese Axe\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_meseaxe.png^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20+(i*4), maxlevel=3},
			},
			damage_groups = {fleshy=6},
		},
	})
	minetest.register_tool("enhancing:axe_mese_lucky_" .. i, {
		description = "Mese Axe\n" .. minetest.colorize("cyan", "Lucky: Level " .. i),
		inventory_image = "default_tool_meseaxe.png^[colorize:cyan:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20, maxlevel=3},
			},
			damage_groups = {fleshy=6},
		},
	})

	minetest.register_tool("enhancing:shovel_mese_quick_" .. i, {
		description = "Mese Shovel\n" .. minetest.colorize("purple", "Fast: Level " .. i),
		inventory_image = "default_tool_meseshovel.png^[colorize:purple:" .. (40+(i*15)),
		wield_image = "default_tool_meseshovel.png^[transformR90^[colorize:purple:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=3,
			groupcaps={
				crumbly = {times={[1]=1.20-(i*0.17), [2]=0.60-(i*0.07), [3]=0.30-(i*0.05)}, uses=20, maxlevel=3},
			},
			damage_groups = {fleshy=4},
		},
	})
	minetest.register_tool("enhancing:shovel_mese_durable_" .. i, {
		description = "Mese Shovel\n" .. minetest.colorize("yellow", "Durable: Level " .. i),
		inventory_image = "default_tool_meseshovel.png^[colorize:yellow:" .. (40+(i*15)),
		wield_image = "default_tool_meseshovel.png^[transformR90^[colorize:yellow:" .. (40+(i*15)),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=3,
			groupcaps={
				crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=20+(i*4), maxlevel=3},
			},
			damage_groups = {fleshy=4},
		},
	})
	all_crafts("wood", i)
	all_crafts("stone", i)
	all_crafts("steel", i)
	all_crafts("mese", i)
end
