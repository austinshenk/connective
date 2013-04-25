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
	for _,bit in ipairs(XZBits) do
		if name == default or name == connected..bit then return true end
	end
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
	for _,bit in ipairs(XYZBits) do
		if name == default or name == connected..bit then return true end
	end
	return false
end
local function findXYZNeighbors(pos, validator)
	local str = ""
	for _,n in pairs(XYZNeighbors) do
		local node = minetest.env:get_node({x=pos.x+n[1],y=pos.y+n[2],z=pos.z+n[3]})
		if validator(node.name) then
			str = str.."1"
		else
			str = str.."0"
		end
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
	for _,n in pairs(XYZNeighbors) do
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

if minetest.get_modpath("construct") then
	registerXYZAlias("connective:glass", "default:glass")	
end