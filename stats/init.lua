-- Load the file from the worldpath.
local file = io.open(minetest.get_worldpath().."/stats", "r")
if file then
	stats = minetest.deserialize(file:read("*all"))
	file:close()
end

-- Set the variables to the values gained from the file, or to empty tables if the file does not exist.
stats = stats or {}
stats.deaths = stats.deaths or {}
stats.kills = stats.kills or {}
stats.placed = stats.placed or {}
stats.dug = stats.dug or {}
stats.distance = stats.distance or {}
stats.time_on = stats.time_on or {}

-- Each time a player dies, increase the counter for the number of deaths
minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	-- If the player doesn't have a value in the table, set it to 0
	-- (It will be increased to one at the end of the function.)
	if stats.deaths[name] == nil then
		stats.deaths[name] = 0
	end
	local number = stats.deaths[name]
	stats.deaths[name] = number+1
end)

-- Each time a player kills another player, increase the kill counter.
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch,
		tool_capabilities, dir, damage)
	-- Only increase the kill stat if the player's health starts off as above 0
	-- and the damge reduces health to bellow 0.
	-- This is necerserry incase a player punches an already dead player.
	if player:get_hp() > 0 and
	player:get_hp() - damage <= 0 then
		local name = hitter:get_player_name()
		-- Same as in the die player code, and so for all the functions.
		if stats.kills[name] == nil then
			stats.kills[name] = 0
		end
		local number = stats.kills[name]
		stats.kills[name] = number + 1
	end
end)

-- Nodes placed counter...
minetest.register_on_placenode(function(pos, oldnode, player)
	local name = player:get_player_name()
	if stats.placed[name] == nil then
		stats.placed[name] = 0
	end
	local number = stats.placed[name]
	stats.placed[name] = number+1
end)

-- Nodes dug counter...
minetest.register_on_dignode(function(pos, oldnode, player)
	local name = player:get_player_name()
	if stats.dug[name] == nil then
		stats.dug[name] = 0
	end
	local number = stats.dug[name]
	stats.dug[name] = number+1
end)

-- The function to save the stats to the file.
local function save_stats()
	local file = io.open(minetest.get_worldpath().."/stats", "w")
	-- Only continue if the file exists or can be created.
	if (file) then
		file:write(minetest.serialize({deaths = stats.deaths, 
			kills = stats.kills, placed = stats.placed, dug = stats.dug,
			distance = stats.distance, time_on = stats.time_on}))
		file:close()
	end
end

-- A bit of magic to get the highest stats!
-- I don't really know how it works, I'll comment it more tomorrow!
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

-- A function to change seconds into more readable times!
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

-- I'm not explaining formspecs, look in the modding bock!!
local formspec = "size[16,8]" ..
	"label[0.2,0.5;" .. minetest.colorize("red", "Deaths:") .. "]" ..
	"label[2.6,0.5;" .. minetest.colorize("purple", "Kills:") .. "]" ..
	"label[4.6,0.5;" .. minetest.colorize("green", "Nodes Placed:") .. "]" ..
	"label[7.2,0.5;" .. minetest.colorize("blue", "Nodes Dug:") .. "]" ..
	"label[13,0.5;" .. minetest.colorize("yellow", "Time played:") .. "]" ..
	"label[10,0.5;" .. minetest.colorize("orange", "Distance walked:") .. "]"

-- Make a copy of the formspec.
local n_formspec = formspec

-- A function to order the stats!
local function order()
	local n = 1
	-- Reset n_formspec
	n_formspec = formspec
	-- Sort the deaths highest first, and add this to the formspec
	-- and carry on with this for the 10 highest stats.
	for i,v in sort(stats.deaths) do
		if n < 4.5 then
			n_formspec = n_formspec .. "label[0.2," .. n .. ";" .. i .. ": " .. v .. "]"
			n = n + 0.35
		else
			break
		end
	end
	-- And so on for all 6 stats...
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

-- 2 seconds after starting, order the stats.
-- (The slight delay is to make sure everything is loaded.)
minetest.after(2, function()
	order()
end)

-- Set the timers for the globalstep to 0.
local timer = 0
local timer2 = 0
local oldpos = {}
minetest.register_globalstep(function(dtime)
	-- Increase both timers on globalstep.
	timer = timer + dtime
	timer2 = timer2 + dtime
	-- Every 15 seconds check the distance the player has walked.
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
				-- Maths to change three coords into one number!
				stats.distance[name] = stats.distance[name]
					+ math.floor(math.sqrt(math.pow(oldpos[name].x - pos.x, 2)
					+ math.pow(oldpos[name].y - pos.y, 2)
					+ math.pow(oldpos[name].z - pos.z,2))) 
			end
			oldpos[name] = player:getpos()
			if stats.time_on[name] == nil then
				stats.time_on[name] = 0
			end
			-- Increase the time the player has played for.
			stats.time_on[name] = stats.time_on[name] + math.floor(timer)
		end
		-- Set the timer back to 0, so that the function waits another 15 seconds before running.
		timer = 0
	end
	-- Every minute order the stats and save them to the file.
	if timer2 >= 60 then
		order()
		save_stats()
		timer2 = 0
	end
end)

-- Order and save the stats when minetest closes.
minetest.register_on_shutdown(function()
	order()
	save_stats()
end)

-- Register a chat command for viewing stats!
minetest.register_chatcommand("stats", {
	params = "<name>",
	description = "print out privileges of player",
	func = function(name, param)
		if minetest.is_singleplayer() then
			-- If it's singleplayer, update the stats straight away, as it will be v. quick.
			order()
		end
		minetest.show_formspec(name, "stats:stats", n_formspec)
	end,
})
