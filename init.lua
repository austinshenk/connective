----------------------------------------
--Connective Textures
--Much like CTM in Minecraft
----------------------------------------
local nodeReg = minetest.register_node
local def = {}
--[[
		 ___  _____  
		|__ \|  __ \ 
		   ) | |  | |
		  / /| |  | |
		 / /_| |__| |
		|____|_____/ 
		
--]]
--+X,+Z,-X,-Z
local XZNeighbors = {{1,0},{0,1},{-1,0},{0,-1}}
local XZBits = {"1000","0100","0010","0001",
				"1100","1010","1001","0110","0101","0011",
				"1110","1101","1011","0111","1111"}
local function validXZNode(name, default, connected)
	if name == nil then return false end
	if name == "air" then return false end
	local str = string.sub(name, 1, connected:len())
	if name == default or str == connected then return true end
	return false
end
local function findXZNeighbors(pos, validator)
	local str = ""
	for _,n in pairs(XZNeighbors) do
		local node = minetest.env:get_node({x=pos.x+n[1],y=pos.y,z=pos.z+n[2]})
		if validator(node.name) then
			str = str.."1"
		else
			str = str.."0"
		end
	end
	return str
end
local function updateXZNode(pos, default, name, validator)
	local str = findXZNeighbors(pos, validator)
	local node = minetest.env:get_node(pos)
	if str == "0000" then
		if node.name ~= default then
			minetest.env:set_node(pos, {name=default})
		end
		return false 
	end
	if name..str == node.name then return false end
	minetest.env:set_node(pos, {name=name..str})
	return true
end
local function updateXZNeighbors(pos, default, name, validator)
	for _,n in pairs(XZNeighbors) do
		local other = {x=pos.x+n[1],y=pos.y,z=pos.z+n[2]}
		local node = minetest.env:get_node(other)
		if validator(node.name) then
			updateXZNode(other, default, name, validator)
		end
	end
end
local function checkXZNode(pos, default, name, validator)
	if updateXZNode(pos, default, name, validator)==true then
		updateXZNeighbors(pos, default, name, validator)
	end
end
local function registerXZAlias(name, default)
	local aliasReg = register_construct_alias
	for _,bit in ipairs(XZBits) do
		aliasReg(name..bit, default)
	end
end
local function registerXZNodes(node, name, def)
	local norm = name..".png"
	local left = name.."_left.png"
	local right = name.."_right.png"
	local mid = name.."_mid.png"
	--tiles = {top, bottom, right, left, rear, front}
		def.tiles = {left,left,norm,norm,right,left}
	nodeReg(node.."1000", def)
		def.tiles = {right,right,norm,norm,left,right}
	nodeReg(node.."0010", def)
		def.tiles = {norm,norm,left,right,norm,norm}
	nodeReg(node.."0100", def)
		def.tiles = {norm,norm,right,left,norm,norm}
	nodeReg(node.."0001", def)
		def.tiles = {left,left,mid,right,mid,left}
	nodeReg(node.."1100", def)
		def.tiles = {mid,mid,norm,norm,mid,mid}
	nodeReg(node.."1010", def)
		def.tiles = {left,left,mid,left,right,mid}
	nodeReg(node.."1001", def)
		def.tiles = {right,right,left,mid,mid,right}
	nodeReg(node.."0110", def)
		def.tiles = {norm,norm,mid,mid,mid,mid}
	nodeReg(node.."0101", def)
		def.tiles = {right,right,right,mid,left,mid}
	nodeReg(node.."0011", def)
		def.tiles = {right,right,mid,mid,mid,mid}
	nodeReg(node.."0111", def)
		def.tiles = {left,left,mid,mid,mid,mid}
	nodeReg(node.."1101", def)
		def.tiles = {mid,mid,mid,mid,mid,mid}
	nodeReg(node.."1110", def)
	nodeReg(node.."1011", def)
	nodeReg(node.."1111", def)
end
--[[
		 ____  _____  
		|___ \|  __ \ 
		  __) | |  | |
		 |__ <| |  | |
		 ___) | |__| |
		|____/|_____/ 
		
--]]
--+X,+Y,+Z,-X,-Y,-Z
local XYZNeighbors = {{1,0,0},{0,1,0},{0,0,1},{-1,0,0},{0,-1,0},{0,0,-1}}
local XYZBits = {"100000","010000","001000","000100","000010","000001",
				"110000","101000","100100","100010","100001","011000","010100","010010","010001","001100","001010","001001","000110","000101","000011",
				"111000","110100","110010","110001","101100","101010","101001","100110","100101","100011","011100","011010","011001","010110","010101","010011","001110","001101","001011","000111",
				"111100","111010","111001","110110","110101","110011","101110","101101","101011","100111","011110","011101","011011","010111","001111",
				"011111","101111","110111","111011","111101","111110",
				"111111"}
local function validXYZNode(name, default, connected)
	if name == nil then return false end
	if name == "air" then return false end
	local str = string.sub(name, 1, connected:len())
	if name == default or str == connected then return true end
	return false
end
local function getCornerID(one, two)
	if one==1 and two==2 then
		return 1
	else if one==1 and two==3 then
		return 2
	else if one==1 and two==5 then
		return 3
	else if one==1 and two==6 then
		return 4
	else if one==2 and two==3 then
		return 5
	else if one==2 and two==4 then
		return 6
	else if one==2 and two==6 then
		return 7
	else if one==3 and two==4 then
		return 8
	else if one==3 and two==5 then
		return 9
	else if one==4 and two==5 then
		return 10
	else if one==4 and two==6 then
		return 11
	else if one==5 and two==6 then
		return 12
	end end end end end end end end end end end end
end
local function searchXYZCorners(pos, indeces, validator)
	local id = ""
	local index, position, pos1, pos2
	for i=1,#indeces,1 do
	index = (indeces[i]+3)%6
	pos1 = XYZNeighbors[indeces[i]]
	for j=i+1,#indeces,1 do
		if index ~= indeces[j] then
			pos2 = XYZNeighbors[indeces[j]]
			position = {x=pos.x+pos1[1]+pos2[1], y=pos.y+pos1[2]+pos2[2], z=pos.z+pos1[3]+pos2[3]}
			if validator(minetest.env:get_node(position).name) then
				id = "X"..getCornerID(indeces[i], indeces[j])
			end
		end
	end
	end
	return id
end
local function findXYZNeighbors(pos, validator)
	local str = ""
	local neighborIndex = {}
	for i,n in ipairs(XYZNeighbors) do
		local node = minetest.env:get_node({x=pos.x+n[1],y=pos.y+n[2],z=pos.z+n[3]})
		if validator(node.name) then
			str = str.."1"
			neighborIndex[#neighborIndex+1] = i
		else
			str = str.."0"
		end
	end
	if #neighborIndex > 1 then
		str = str..searchXYZCorners(pos, neighborIndex, validator)
	end
	return str
end
local function updateXYZNode(pos, default, name, validator)
	local str = findXYZNeighbors(pos, validator)
	local node = minetest.env:get_node(pos)
	if str == "000000" then
		if node.name ~= default then
			minetest.env:set_node(pos, {name=default})
		end
		return false 
	end
	if name..str == node.name then return false end
	minetest.env:set_node(pos, {name=name..str})
	return true
end
local function updateXYZNeighbors(pos, default, name, validator)
	for _,n in ipairs(XYZNeighbors) do
		local other = {x=pos.x+n[1],y=pos.y+n[2],z=pos.z+n[3]}
		local node = minetest.env:get_node(other)
		if validator(node.name) then
			updateXYZNode(other, default, name, validator)
		end
	end
end
local function checkXYZNode(pos, default, name, validator)
	if updateXYZNode(pos, default, name, validator)==true then
		updateXYZNeighbors(pos, default, name, validator)
	end
end
local function registerXYZAlias(name, default)
	local aliasReg = register_construct_alias
	for _,bit in ipairs(XYZBits) do
		aliasReg(name..bit, default)
	end
end
local function registerXYZNodes(node, name, def)
	local norm = name..".png"
	local tl1 = name.."_topleft1.png"
	local tr1 = name.."_topright1.png"
	local bl1 = name.."_bottomleft1.png"
	local br1 = name.."_bottomright1.png"
	local left1 = name.."_left1.png"
	local right1 = name.."_right1.png"
	local top1 = name.."_top1.png"
	local bot1 = name.."_bottom1.png"
	local tl = name.."_topleft.png"
	local tr = name.."_topright.png"
	local bl = name.."_bottomleft.png"
	local br = name.."_bottomright.png"
	local left = name.."_left.png"
	local right = name.."_right.png"
	local top = name.."_top.png"
	local bot = name.."_bottom.png"
	local mid = name.."_mid.png"
	--tiles = {+Y, -Y, +X, -X, +Z, -Z}
	--+X,+Y,+Z,-X,-Y,-Z
	--+X+Y, +X+Z, +X-Y, +X-Z, +Y+Z, +Y-X, +Y-Z, +Z-X, +Z-Y, -X-Y, -X-Z, -Y-Z
	--[[
	"","","","","","",
				"","101000","100100","100010","100001","011000","010100","010010","010001","001100","001010","001001","000110","000101","000011",
				"111000","110100","110010","110001","101100","101010","101001","100110","100101","100011","011100","011010","011001","010110","010101","010011","001110","001101","001011","000111",
				"111100","111010","111001","110110","110101","110011","101110","101101","101011","100111","011110","011101","011011","010111","001111",
				"011111","101111","110111","111011","111101","111110",
				""
	--]]
		def.tiles = {left1,left1,mid,norm,right1,left1}
	nodeReg(node.."100000", def)
		def.tiles = {mid,norm,bot1,bot1,bot1,bot1}
	nodeReg(node.."010000", def)
		def.tiles = {bot1,bot1,left1,right1,mid,norm}
	nodeReg(node.."001000", def)
		def.tiles = {right1,right1,norm,mid,left1,right1}
	nodeReg(node.."000100", def)
		def.tiles = {norm,mid,top1,top1,top1,top1}
	nodeReg(node.."000010", def)
		def.tiles = {top1,top1,right1,left1,norm,mid}
	nodeReg(node.."000001", def)
		def.tiles = {mid,left1,mid,bot1,br1,bl1}
	nodeReg(node.."110000", def)
		def.tiles = {mid,left1,mid,bot1,br,bl}
	nodeReg(node.."110000X1", def)
		def.tiles = {mid,mid,mid,mid,mid,mid}
	nodeReg(node.."111111", def)
end
--[[
		__          ______   ____  _____  
		\ \        / / __ \ / __ \|  __ \ 
		 \ \  /\  / / |  | | |  | | |  | |
		  \ \/  \/ /| |  | | |  | | |  | |
		   \  /\  / | |__| | |__| | |__| |
		    \/  \/   \____/ \____/|_____/ 
                                  
--]]
nodeReg(":default:wood", {
	description = "Wooden Planks",
	tiles = {"connective_wood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		checkXZNode(pos, "default:wood", "connective:wood", (function(name) return validXZNode(name, "default:wood", "connective:wood") end))
	end,
})
def = {description = "Wooden Planks",
	tiles = {},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:wood",
	after_destruct = function(pos, oldnode)
		updateXZNeighbors(pos, "default:wood", "connective:wood", (function(name) return validXZNode(name, "default:wood", "connective:wood") end))
	end,
}
registerXZNodes("connective:wood", "connective_wood", def)

if minetest.get_modpath("construct") then
	registerXZAlias("connective:wood", "default:wood")
end

--[[
		  _____ _                _____ _____ 
		 / ____| |        /\    / ____/ ____|
		| |  __| |       /  \  | (___| (___  
		| | |_ | |      / /\ \  \___ \\___ \ 
		| |__| | |____ / ____ \ ____) |___) |
		 \_____|______/_/    \_\_____/_____/
		 
--]]

nodeReg(":default:glass", {
	description = "Glass",
	tiles = {"connective_glass_frame.png","connective_glass_streaks.png"},
	inventory_image = minetest.inventorycube("default_glass.png"),
	drawtype = "glasslike_framed",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

--[[
		  _____ _______ ______ ______ _        ____  _      ____   _____ _  __
		 / ____|__   __|  ____|  ____| |      |  _ \| |    / __ \ / ____| |/ /
		| (___    | |  | |__  | |__  | |      | |_) | |   | |  | | |    | ' / 
		 \___ \   | |  |  __| |  __| | |      |  _ <| |   | |  | | |    |  <  
		 ____) |  | |  | |____| |____| |____  | |_) | |___| |__| | |____| . \ 
		|_____/   |_|  |______|______|______| |____/|______\____/ \_____|_|\_\
		
--]]
--[[
nodeReg(":default:steelblock", {
	description = "Steel Block",
	tiles = {"connective_steelblock.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		checkXYZNode(pos, "default:steelblock", "connective:steelblock", (function(name) return validXYZNode(name, "default:steelblock", "connective:steelblock") end))
	end,
})
def = {description = "Steel Block",
	tiles = {"connective_steelblock.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2,not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	after_destruct = function(pos, oldnode)
		updateXYZNeighbors(pos, "default:steelblock", "connective:steelblock", (function(name) return validXYZNode(name, "default:steelblock", "connective:steelblock") end))
	end,
}
registerXYZNodes("connective:steelblock", "connective_steelblock", def)

if minetest.get_modpath("construct") then
	registerXYZAlias("connective:steelblock", "default:steelblock")	
end
--]]