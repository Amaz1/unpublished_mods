minetest.override_item("default:cloud", {
	tiles = {"default_cloud.png^[colorize:black:50"},
	light_source = 7,
	sunlight_propagates = true
})

local file = io.open(minetest.get_worldpath() .. "/storage_solutions.txt", "r")
if file then
	storage_realm = minetest.deserialize(file:read("*all"))
	file:close()
end

storage_realm = storage_realm or {}
storage_realm.last_pos = storage_realm.last_pos or {x = -200, y = 29999, z = -200}
storage_realm.iteration = storage_realm.iteration or 0
storage_realm.player_pos = storage_realm.player_pos or {}
storage_realm.player_old_pos = storage_realm.player_old_pos or {}

local function save_info()
	local file = io.open(minetest.get_worldpath().."/storage_solutions.txt", "w")
	if (file) then
		file:write(minetest.serialize({last_pos = storage_realm.last_pos,
			player_pos = storage_realm.player_pos,
			player_old_pos = storage_realm.player_old_pos,
			iteration = storage_realm.iteration}))
		file:close()
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 120 then
		save_info()
	end
end)

minetest.register_on_leaveplayer(function()
	save_info()
end)

minetest.register_on_shutdown(function()
	save_info()
end)

local function pm(n1, n2)
	if n1 and n2 then
		if math.random(1, 2) == 1 then
			return n1 + n2
		else
			return n1 - n2
		end
	elseif n1 then
		if math.random(1, 2) == 1 then
			return n1
		else
			return -n1
		end
	end
end

local function find_player_place(it, pos, name)
	if it % 2500 == 0 then
		pos.z = -200
		pos.x = -200
		pos.y = pos.y + 10
	elseif it % 50 == 0 then
		pos.z = -200
		pos.x = pos.x + 10
	end
	pos.z = pos.z + 10
	storage_realm.last_pos = pos
	storage_realm.iteration = it + 1
	storage_realm.player_pos[name] = {x = pos.x, y = pos.y + 2, z = pos.z}
	return pos
end

local function back_to_old_pos(player)
	local name = player:get_player_name()
	if storage_realm.player_old_pos[name] then
		player:setpos(storage_realm.player_old_pos[name])
	else
		player:setpos({x = 0, y = 20, z = 0})
	end
end

local function spin_player(player)
	local p = player:getpos()
	for i = 0, math.pi, 0.01 do
		minetest.after(i, function()
			player:set_look_horizontal(-(i*4))
			minetest.add_particle({
				velocity = {x = pm(math.random()), y = pm(math.random()),
					z = pm(math.random())},
				pos = {x = pm(p.x, math.random()), y = pm(p.y, math.random()),
					z = pm(p.z, math.random())},
				expirationtime = 4,
				texture = "storage_solutions_cloud_particle.png",
			})
		end)
	end
end

local function tp_player(player, pos)
	player:set_physics_override({speed = 0, jump = 0})
	spin_player(player)
	minetest.after(3.14, function()
		player:setpos({x = pos.x, y = pos.y + 2, z = pos.z})
		player:set_physics_override({speed = 1, jump = 1})
	end)
end

local function build_storage_place(player)
	local name = player:get_player_name()

	if storage_realm.player_pos[name] then
		storage_realm.player_old_pos[name] = player:getpos()
		tp_player(player, storage_realm.player_pos[name])
	else
		local pos = find_player_place(storage_realm.iteration, storage_realm.last_pos, name)
		storage_realm.player_old_pos[name] = player:getpos()
		player:setpos({x = pos.x, y = pos.y + 2, z = pos.z})
		minetest.after(2, function()
			for i = -5, 5 do
			for j = -5, 5 do
				minetest.set_node({x = pos.x + i, y = pos.y, z = pos.z + j},
					{name = "default:cloud"})
				minetest.set_node({x = pos.x + i, y = pos.y + 10, z = pos.z + j},
					{name = "default:cloud"})
			end
			end
			for i = 0, 10 do
			for j = -5, 5 do
				minetest.set_node({x = pos.x + 5, y = pos.y + i, z = pos.z + j},
					{name = "default:cloud"})
				minetest.set_node({x = pos.x - 5, y = pos.y + i, z = pos.z + j},
					{name = "default:cloud"})
				minetest.set_node({x = pos.x + j, y = pos.y + i, z = pos.z + 5},
					{name = "default:cloud"})
				minetest.set_node({x = pos.x + j, y = pos.y + i, z = pos.z - 5},
					{name = "default:cloud"})
			end
			end
			player:setpos({x = pos.x, y = pos.y + 2, z = pos.z})
		end)
	end
end

minetest.register_craftitem("storage_solutions:cloud_tp", {
	description = "Cloud Teleporter",
	inventory_image = "default_stick.png",
	on_use = function(itemstack, user)
		if user:getpos().y > 29990 then
			minetest.chat_send_player(user:get_player_name(),
				"You're already in the storage realm!!!")
			return
		end
		build_storage_place(user)
		itemstack:set_name("storage_solutions:cloud_return_tp")
		return itemstack
	end,
})

minetest.register_craftitem("storage_solutions:cloud_return_tp", {
	description = "Return Cloud Teleporter",
	inventory_image = "default_mese_crystal_fragment.png",
	on_use = function(itemstack, user)
		if user:getpos().y < 29990 then
			minetest.chat_send_player(user:get_player_name(),
				"You've left the storage realm!")
			return
		end
		spin_player(user)
		minetest.after(3.15, function()
			back_to_old_pos(user)
		end)
		itemstack:clear()
		return itemstack
	end,
	on_drop = function()
		return false
	end,
})
