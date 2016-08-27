--[[local portals = {
	{min_y = 9000, max_y = 9100, material = "default:brick", portal = "nether", desc = "Nether", pec = "800080"},
	{min_y = 11150, max_y = 11250, material = "default:stonebrick", portal = "floaty", desc = "Float", pec = "00b1b7"},
	{min_y = 9000, max_y = 9100, material = "default:stone", portal = "abc", desc = "Abc", pec = "800080"},
	{min_y = 9000, max_y = 9100, material = "default:stone", portal = "abc", desc = "Abc", pec = "800080"},
}]]--

local function get_nodedef_field(nodename, fieldname)
	if not minetest.registered_nodes[nodename] then
    	return nil
    end
    return minetest.registered_nodes[nodename][fieldname]
end

local radius = 100

function get_surface_pos(pos, min_y, max_y)
	local sminp = {x = pos.x - 10, y = min_y, z = pos.z - 10}
	local smaxp = {x = pos.x + 10, y = max_y, z = pos.z + 10}

	local minp = {
		x = pos.x - radius - 1,
		y = min_y,
		z = pos.z - radius - 1
	}
	local maxp = {
		x = pos.x + radius - 1,
		y = max_y,
		z = pos.z + radius - 1
	}

	local seen_air = false
	local ground_pos = {}

	--local nnu = minetest.get_node({x=pos.x,y=pos.y-2,z=pos.z}).name
	--local ngu = minetest.get_node_group(nnu, "water")
	--if ngu == 0 and nnu ~= "ignore" then
		for x = sminp.x, smaxp.x do
		for z = sminp.z, smaxp.z do
			for y = smaxp.y, sminp.y, -1 do
				local nodename = minetest.get_node({x=x,y=y,z=z}).name
				local goodnode = get_nodedef_field(nodename, "walkable")
				local nodenamea = minetest.get_node({x=x,y=y+1,z=z}).name
				if goodnode == true and nodename ~= "air" and nodenamea == "air" then
					ground_pos = {x = x, y = y + 1, z = z}
					seen_air = true
					break
				end
			end
		end
		end
	--end

	if seen_air then
		return ground_pos
	else
		for x = minp.x, maxp.x do
		for z = minp.z, maxp.z do
			for y = maxp.y, minp.y, -1 do
				local nodename = minetest.get_node({x=x,y=y,z=z}).name
				local goodnode = get_nodedef_field(nodename, "walkable")
				local nodenamea = minetest.get_node({x=x,y=y+1,z=z}).name
				if goodnode == true and nodename ~= "air" and nodenamea == "air" then
					ground_pos = {x = x, y = y + 1, z = z}
					seen_air = true
					break
				end
			end
		end
		end
		if seen_air then
			return ground_pos
		else
			return false
		end
	end
end

local function hex_rbg(code)
	if type(code) == 'number' then
		xcode= string.format('%x+', code):upper()
	end
	code = code:match'%x+':upper()
	return {
		a = 180;
		r = loadstring('return 0x' .. code:sub(1,2))();
		g = loadstring('return 0x' .. code:sub(3,4))();
		b = loadstring('return 0x' .. code:sub(5,6))();
	}
end

local function build_portal(pos, target, material, portal)
	local p = {x=pos.x-1, y=pos.y-1, z=pos.z}
	local p1 = {x=pos.x-1, y=pos.y-1, z=pos.z}
	local p2 = {x=p1.x+3, y=p1.y+4, z=p1.z}
	for i=1,4 do
		minetest.set_node(p, {name = material})
		p.y = p.y+1
	end
	for i=1,3 do
		minetest.set_node(p, {name = material})
		p.x = p.x+1
	end
	for i=1,4 do
		minetest.set_node(p, {name = material})
		p.y = p.y-1
	end
	for i=1,3 do
		minetest.set_node(p, {name = material})
		p.x = p.x-1
	end
	p.z = p.z + 1
	for i = 1, 4 do
		minetest.set_node(p, {name = "default:stone"})
		p.x = p.x + 1
	end
	for x=p1.x,p2.x do
	for y=p1.y,p2.y do
		p = {x=x, y=y, z=p1.z}
		if not (x == p1.x or x == p2.x or y==p1.y or y==p2.y) then
			minetest.set_node(p, {name="portals:" .. portal, param2=0})
		end
		local meta = minetest.get_meta(p)
		local opos = target
		meta:set_string("p1", minetest.pos_to_string(p1))
		meta:set_string("p2", minetest.pos_to_string(p2))
		meta:set_string("target", minetest.pos_to_string(target))

		if y ~= p1.y then
			for z=-2,2 do
				if z ~= 0 then
					p.z = p.z+z
					--if minetest.registered_nodes[minetest.get_node(p).name].is_ground_content then
						minetest.remove_node(p)
					--end
					p.z = p.z-z
				end
			end
		end

	end
	end
end

local function set_target(p1, p2, npos)
	for x=p1.x,p2.x do
	for y=p1.y,p2.y do
	for z=p1.z,p2.z do
		local meta = minetest.get_meta({x=x, y=y, z=z})
		meta:set_string("target", npos)
	end
	end
	end
end

local function move_check(p1, max, dir, material)
	local p = {x=p1.x, y=p1.y, z=p1.z}
	local d = math.abs(max-p1[dir]) / (max-p1[dir])
	while p[dir] ~= max do
		p[dir] = p[dir] + d
		if minetest.get_node(p).name ~= material then
			return false
		end
	end
	return true
end

local function check_portal(p1, p2, material)
	if p1.x ~= p2.x then
		if not move_check(p1, p2.x, "x", material) then
			return false
		end
		if not move_check(p2, p1.x, "x", material) then
			return false
		end
	elseif p1.z ~= p2.z then
		if not move_check(p1, p2.z, "z", material) then
			return false
		end
		if not move_check(p2, p1.z, "z", material) then
			return false
		end
	else
		return false
	end

	if not move_check(p1, p2.y, "y", material) then
		return false
	end
	if not move_check(p2, p1.y, "y", material) then
		return false
	end

	return true
end

local function is_portal(pos, material)
	for d=-3,3 do
		for y=-4,4 do
			local px = {x=pos.x+d, y=pos.y+y, z=pos.z}
			local pz = {x=pos.x, y=pos.y+y, z=pos.z+d}
			if check_portal(px, {x=px.x+3, y=px.y+4, z=px.z}, material) then
				return px, {x=px.x+3, y=px.y+4, z=px.z}
			end
			if check_portal(pz, {x=pz.x, y=pz.y+4, z=pz.z+3}, material) then
				return pz, {x=pz.x, y=pz.y+4, z=pz.z+3}
			end
		end
	end
end

function make_portal(pos, portal, material)
	print(portal)
	local p1, p2 = is_portal(pos, material)
	if not p1 or not p2 then
		return false
	end

	for d=1,2 do
	for y=p1.y+1,p2.y-1 do
		local p
		if p1.z == p2.z then
			p = {x=p1.x+d, y=y, z=p1.z}
		else
			p = {x=p1.x, y=y, z=p1.z+d}
		end
		if minetest.get_node(p).name ~= "air" then
			return false
		end
	end
	end

	local param2
	if p1.z == p2.z then param2 = 0 else param2 = 1 end

	for d=0,3 do
	for y=p1.y,p2.y do
		local p = {}
		if param2 == 0 then p = {x=p1.x+d, y=y, z=p1.z} else p = {x=p1.x, y=y, z=p1.z+d} end
		if minetest.get_node(p).name == "air" then
			minetest.set_node(p, {name="portals:" .. portal, param2=param2})
		end
		local meta = minetest.get_meta(p)
		meta:set_string("p1", minetest.pos_to_string(p1))
		meta:set_string("p2", minetest.pos_to_string(p2))
		meta:set_string("target", "first")
	end
	end
	return true
end

local function teleport_stuff(p1, p2, npos, opos, material, portal, obj, text, img)
	set_target(p1, p2, minetest.pos_to_string(npos))
	obj:moveto({x = npos.x + 1, y = npos.y, z = npos.z + 1}, false)
	minetest.after(2, function()
		build_portal(npos, opos, material, portal)
		obj:moveto({x = npos.x + 1, y = npos.y, z = npos.z + 1}, false)
	end)
	obj:set_physics_override(1, 1, 1)
	obj:hud_remove(text)
	obj:hud_remove(img)
end

local function destroy(pos, material, portal)
	local name = "portals:" .. portal
	local meta = minetest.get_meta(pos)
	local p1 = minetest.string_to_pos(meta:get_string("p1"))
	local p2 = minetest.string_to_pos(meta:get_string("p2"))
	local target = minetest.string_to_pos(meta:get_string("target"))
	if not p1 or not p2 then
		return
	end
	for x=p1.x,p2.x do
	for y=p1.y,p2.y do
	for z=p1.z,p2.z do
		local nn = minetest.get_node({x=x,y=y,z=z}).name
		if nn == material or nn == name then
			if nn == name then
				minetest.remove_node({x=x,y=y,z=z})
			end
			local m = minetest.get_meta({x=x,y=y,z=z})
			m:set_string("p1", "")
			m:set_string("p2", "")
			m:set_string("target", "")
		end
	end
	end
	end
end

function portal_stuff(min_y, max_y, material, portal, desc, pec)
	minetest.register_node("portals:" .. portal, {
		description = desc .. " Portal",
		tiles = {
			"blank.png",
			"blank.png",
			"blank.png",
			"blank.png",
			{
				name = portal .. "_portal.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
			{
				name = portal .. "_portal.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		use_texture_alpha = true,
		walkable = false,
		digable = false,
		pointable = false,
		buildable_to = false,
		drop = "",
		light_source = 5,
		post_effect_color = hex_rbg(pec),
		alpha = 192,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.1,  0.5, 0.5, 0.1},
			},
		},
		groups = {not_in_creative_inventory=1}
	})

	minetest.register_abm({
		nodenames = {"portals:" .. portal},
		interval = 2,
		chance = 2,
		action = function(pos, node)
			minetest.add_particlespawner(
				32, --amount
				4, --time
				{x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25}, --minpos
				{x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25}, --maxpos
				{x=-0.8, y=-0.8, z=-0.8}, --minvel
				{x=0.8, y=0.8, z=0.8}, --maxvel
				{x=0,y=0,z=0}, --minacc
				{x=0,y=0,z=0}, --maxacc
				0.5, --minexptime
				1, --maxexptime
				1, --minsize
				2, --maxsize
				false, --collisiondetection
				portal .. "_particle.png" --texture
			)
			for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
				if obj:is_player() then
					local meta = minetest.get_meta(pos)
					if meta then
						local target = meta:get_string("target")
						local to = minetest.string_to_pos(target)
						local p1 = minetest.string_to_pos(meta:get_string("p1"))
						local p2 = minetest.string_to_pos(meta:get_string("p2"))
						if target == "first" then
							local opos = obj:getpos()
							local dpos = {x = opos.x, y = min_y, z = opos.z}
							obj:set_physics_override(0, 0, 0)
							obj:moveto(dpos, false)
							local img = obj:hud_add({
								hud_elem_type = "image",
								position = {x=0.5, y=0.5},
								scale = {x=1, y=1},
								number = 0xFF0000,
								text = "portal_text.png",
								offset = {x=0, y=0},
							})
							local text = obj:hud_add({
								hud_elem_type = "text",
								position = {x=0.5, y=0.5},
								scale = {x=-100},
								number = 0xFF0000,
								text = "Terrain generating... Please wait!",
								offset = {x=0, y=0},
							})
							local npos = nil
							minetest.after(2, function()
								npos = get_surface_pos(dpos, min_y, max_y)
								if npos and npos ~= false then
									teleport_stuff(p1, p2, npos, opos, material, portal, obj,  text, img)
								elseif npos == false then
									obj:moveto({x = opos.x + 100, y = min_y, z = opos.z + 100})
									minetest.after(2, function()
										npos = get_surface_pos({x = opos.x + 100, y = min_y, z = opos.z + 100}, min_y, max_y)
										if npos and npos ~= false then
											teleport_stuff(p1, p2, npos, opos, material, portal, obj, text, img)
										else
											teleport_stuff(p1, p2, dpos, opos, material, portal, obj, text, img)
										end
									end)
								end
							end)
						elseif to then
							local objpos = obj:getpos()
							objpos.y = objpos.y+0.1 -- Fix some glitches at -8000
							if minetest.get_node(objpos).name ~= "portals:" .. portal then
								return
							end

							obj:setpos({x = to.x + 1, y = to.y, z = to.z + 1})
						end
					end
				end
			end
		end,
	})

	minetest.register_craftitem("portals:igniter_" .. portal, {
		description = desc .. " Portal Igniter",
		inventory_image = "default_mese_crystal_fragment.png^[colorize:#" .. pec .. "99",
		on_place = function(stack, placer, pt)
			local pos = placer:getpos()
			if pt.under and minetest.get_node(pt.under).name == material then
				if pos.y > min_y and pos.y < max_y then
					minetest.chat_send_player(placer:get_player_name(), "You are already in the same realm as this portal would lead to!")
					return
				end
				local done = make_portal(pt.under, portal, material)
				if done and not minetest.setting_getbool("creative_mode") then
					stack:take_item()
				end
				minetest.emerge_area({x = pos.x-100, y = min_y, z = pos.z-100}, {x = pos.x+100, y = max_y, z = pos.z+100})
			end
			return stack
		end,
	})
	minetest.override_item(material, {
		on_destruct = function(pos)
			destroy(pos, material, portal)
		end
	})
end

portal_stuff(9000, 9100, "floatindev:floc", "nether", "Nether", "800080")
portal_stuff(11125, 11275, "asteroid:meteorite_block", "floaty", "Float", "00b1b7")
portal_stuff(5100, 5300, "default:stone", "abc", "Abc", "800080")
portal_stuff(15000, 15200, "default:mese", "asteroid", "Asteroid", "eaec28")

--[[pos = {x=0, y=0, z=0}

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local space = 1000 --value for space, change the value to however you like.
		local pos = player:getpos()
		--The skybox for space, feel free to change it to however you like.
		local spaceskybox = {
			"sky_pos_y.png",
			"sky_neg_y.png",
			"sky_pos_z.png",
			"sky_neg_z.png",
			"sky_neg_x.png",
			"sky_pos_x.png",
		}

		--If the player has reached Space
		if minetest.get_player_by_name(name) and pos.y >= space then
			player:set_sky({}, "skybox", spaceskybox) -- Sets skybox
		elseif minetest.get_player_by_name(name) and pos.y < space then
			player:set_physics_override(1, 1, 1) -- speed, jump, gravity [default]
			player:set_sky({}, "regular", {}) -- Sets skybox, in this case it sets the skybox to it's default setting if and only if the player's Y value is less than the value of space.
		end
	end
end)


minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		player:set_sky({}, "regular", {})
	end
end)]]
