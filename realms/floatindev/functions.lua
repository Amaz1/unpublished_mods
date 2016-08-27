function glowtest_crystals(data, colour, vi)
	local c_crystal_1 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_1")
	local c_crystal_2 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_2")
	local c_crystal_3 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_3")
	local c_crystal_4 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_4")
	local c_crystal_5 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_5")
    local c_crystal_6 = minetest.get_content_id("glowtest:" .. colour .. "_crystal_6")
	local rand = math.random(6)
	if rand == 1 then
		data[vi] = c_crystal_1
	elseif rand == 2 then
		data[vi] = c_crystal_2
	elseif rand == 3 then
		data[vi] = c_crystal_3
	elseif rand == 4 then
		data[vi] = c_crystal_4
	elseif rand == 5 then
		data[vi] = c_crystal_5
    else
        data[vi] = c_crystal_6
	end
end

function add_leaf(x, y, z, area, data, colour)
    local c_tree = minetest.get_content_id("glowtest:tree")
	local c_leaves = minetest.get_content_id("glowtest:" .. colour .. "leaf")
	for i = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
		for k = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
		    local vit = area:index(x,y,z)
		        data[vit] = c_tree
		    local vil = area:index(x+i, y, z+k)
			data[vil] = c_leaves
			local chance = math.abs(i+k)
			if (chance < 1) then
				local vila = area:index(x+i, y+1, z+k)
				data[vila] = c_leaves
			end
		end
	end
end

function glowtest_bigtree(x, y, z, area, data, colour)
    local height = 15
	local root_height = 3
	local c_tree = minetest.get_content_id("glowtest:tree")
	local c_leaves = minetest.get_content_id("glowtest:" .. colour .. "leaf")
	add_leaf(x, y+height, z+3, area, data, colour)
	add_leaf(x+3, y+height, z+1, area, data, colour)
	add_leaf(x+1, y+height, z-2, area, data, colour)
	add_leaf(x-2, y+height, z, area, data, colour)

	add_leaf(x, y+height, z+2, area, data, colour)
	add_leaf(x+2, y+height, z+1, area, data, colour)
	add_leaf(x+1, y+height, z-1, area, data, colour)
	add_leaf(x-1, y+height, z, area, data, colour)

	add_leaf(x, y+height-5, z, area, data, colour)
	for j = -1, height do
		local vit = area:index(x , y + j, z)
		data[vit] = c_tree
		local vit = area:index(x+1 , y + j, z)
		data[vit] = c_tree
		local vit = area:index(x , y + j, z+1)
		data[vit] = c_tree
		local vit = area:index(x+1 , y + j, z+1)
		data[vit] = c_tree
		local vit = area:index(x, y+height, z+3)
		data[vit] = c_tree
	    local vit = area:index(x+3, y+height, z+1)
		data[vit] = c_tree
	    local vit = area:index(x+1, y+height, z-2)
		data[vit] = c_tree
	    local vit = area:index(x-2, y+height, z)
		data[vit] = c_tree
	    local vit = area:index(x, y+height, z+2)
		data[vit] = c_tree
	    local vit = area:index(x+2, y+height, z+1)
		data[vit] = c_tree
	    local vit = area:index(x+1, y+height, z-1)
		data[vit] = c_tree
	    local vit = area:index(x-1, y+height, z)
		data[vit] = c_tree
	end
	for j = -1, root_height do
		local vit = area:index(x , y + j , z+2)
		data[vit] = c_tree
		local vit = area:index(x+2 , y + j , z+1)
		data[vit] = c_tree
		local vit = area:index(x+1 , y + j , z-1)
		data[vit] = c_tree
		local vit = area:index(x-1 , y + j , z)
		data[vit] = c_tree
	end
end
