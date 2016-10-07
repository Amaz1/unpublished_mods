local file = io.open(minetest.get_worldpath().."/stats", "r")
if file then
	stats = minetest.deserialize(file:read("*all"))
	file:close()
end

stats = stats or {}
stats.deaths = stats.deaths or {}
stats.kills = stats.kills or {}
stats.placed = stats.placed or {}
stats.dug = stats.dug or {}
stats.distance = stats.distance or {}
stats.time_on = stats.time_on or {}

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	if stats.deaths[name] == nil then
		stats.deaths[name] = 0
	end
	local number = stats.deaths[name]
	stats.deaths[name] = number+1
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch,
		tool_capabilities, dir, damage)
	if player:get_hp() > 0 and
	player:get_hp() - damage <= 0 then
		local name = hitter:get_player_name()
		if stats.kills[name] == nil then
			stats.kills[name] = 0
		end
		local number = stats.kills[name]
		stats.kills[name] = number + 1
	end
end)

minetest.register_on_placenode(function(pos, oldnode, player)
	local name = player:get_player_name()
	if stats.placed[name] == nil then
		stats.placed[name] = 0
	end
	local number = stats.placed[name]
	stats.placed[name] = number+1
end)

minetest.register_on_dignode(function(pos, oldnode, player)
	local name = player:get_player_name()
	if stats.dug[name] == nil then
		stats.dug[name] = 0
	end
	local number = stats.dug[name]
	stats.dug[name] = number+1
end)

local function save_stats()
	local file = io.open(minetest.get_worldpath().."/stats", "w")
	if (file) then
		file:write(minetest.serialize({deaths = stats.deaths, 
			kills = stats.kills, placed = stats.placed, dug = stats.dug,
			distance = stats.distance, time_on = stats.time_on}))
		file:close()
	end
end

local function sort(t)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	local function c(t,a,b) return t[b] < t[a] end
	table.sort(keys, function(a,b) return c(t, a, b) end)
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function breakdowntime(t)
	local eng = {"Secs","Mins","Hours","Days","Weeks","Months","Years"}
	local inc = {60,60,24,7,4,12,1}	
	for k,v in ipairs(inc) do
		if ( t > v ) then
			t = math.floor( (t / v) )
		else
			return tostring(t).." "..eng[k]
		end	
	end
end

local formspec = "size[16,8]" ..
	"label[0.2,0.5;" .. minetest.colorize("red", "Deaths:") .. "]" ..
	"label[2.6,0.5;" .. minetest.colorize("purple", "Kills:") .. "]" ..
	"label[4.6,0.5;" .. minetest.colorize("green", "Nodes Placed:") .. "]" ..
	"label[7.2,0.5;" .. minetest.colorize("blue", "Nodes Dug:") .. "]" ..
	"label[13,0.5;" .. minetest.colorize("yellow", "Time played:") .. "]" ..
	"label[10,0.5;" .. minetest.colorize("orange", "Distance walked:") .. "]"

local n_formspec = formspec

local function order()
	local n = 1
	n_formspec = formspec
	for i,v in sort(stats.deaths) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[0.2," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	n = 1
	for i,v in sort(stats.kills) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[2.6," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	n = 1
	for i,v in sort(stats.placed) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[4.6," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	n = 1
	for i,v in sort(stats.dug) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[7.2," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	n = 1
	for i,v in sort(stats.distance) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[10," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	n = 1
	for i,v in sort(stats.time_on) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[13," .. n .. ";" .. i .. ": "
				.. breakdowntime(v) .. "]"
			n = n + 0.35
		else
			break
		end
	end
end

minetest.after(2, function()
	order()
end)

local timer = 0
local timer2 = 0
local oldpos = {}
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	timer2 = timer2 + dtime
	if (timer >= 15) then
		local players = minetest.get_connected_players()
		-- Go through all players on the server.
		for _,player in ipairs(players) do
			local name = player:get_player_name()
			if (oldpos[name] ~= nil) then
				local pos = player:getpos()
				if stats.distance[name] == nil then
					stats.distance[name] = 0
				end
				stats.distance[name] = stats.distance[name]
					+ math.floor(math.sqrt(math.pow(oldpos[name].x - pos.x, 2)
					+ math.pow(oldpos[name].y - pos.y, 2)
					+ math.pow(oldpos[name].z - pos.z,2))) 
			end
			oldpos[name] = player:getpos()
			if stats.time_on[name] == nil then
				stats.time_on[name] = 0
			end
			stats.time_on[name] = stats.time_on[name] + math.floor(timer)
		end
		timer = 0
	end
	if timer2 >= 60 then
		order()
		save_stats()
		timer2 = 0
	end
end)

minetest.register_on_shutdown(function()
	order()
	save_stats()
end)

minetest.register_chatcommand("stats", {
	params = "<name>",
	description = "print out privileges of player",
	func = function(name, param)
		if param ~= "" then
			local string = "Stats of " .. param .. ": "
			for i, v in pairs(stats) do
				if v[param] ~= nil then
					string = string .. i .. ": " .. v[param] .. "   "
				end
			end
			if string ~= "Stats of " .. param .. ": " then
				minetest.chat_send_player(name, string)
			else
				minetest.chat_send_player(name, "Could not find stats for " .. param .. "!")
			end
		else
			if minetest.is_singleplayer() then
				order()
			end
			minetest.show_formspec(name, "stats:stats", n_formspec)
		end
	end,
})
