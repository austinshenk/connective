----------------------------------------
--Connective Textures
--Much like CTM in Minecraft
----------------------------------------
local nodeReg = minetest.register_node
local def = {}
--+X,+Z,-X,-Z
local XYNeighbors = {{1,0},{0,1},{-1,0},{0,-1}}
local XYBits = {"1000","0100","0010","0001",
				"1100","1010","1001","0110","0101","0011",
				"1110","1101","1011","0111","1111"}
local function validXYNode(name, default, connected)
	if name == nil then return false end
	if name == "air" then return false end
	for _,bit in ipairs(XYBits) do
		if name == default or name == connected..bit then return true end
	end
	return false
end
local function findXYNeighbors(pos, validator)
	local str = ""
	for _,n in pairs(XYNeighbors) do
		local node = minetest.env:get_node({x=pos.x+n[1],y=pos.y,z=pos.z+n[2]})
		if validator(node.name) then
			str = str.."1"
		else
			str = str.."0"
		end
	end
	return str
end
local function updateXYNode(pos, name, validator)
	local str = findXYNeighbors(pos, validator)
	local node = minetest.env:get_node(pos)
	if str == "0000" then
		if node.name ~= "default:wood" then
			minetest.env:set_node(pos, {name="default:wood"})
		end
		return false 
	end
	if name..str == node.name then return false end
	minetest.env:set_node(pos, {name=name..str})
	return true
end
local function updateXYNeighbors(pos, name, validator)
	for _,n in pairs(XYNeighbors) do
		local other = {x=pos.x+n[1],y=pos.y,z=pos.z+n[2]}
		local node = minetest.env:get_node(other)
		if validator(node.name) then
			updateXYNode(other, name, validator)
		end
	end
end
local function checkXYNode(pos, name, validator)
	if updateXYNode(pos, name, validator)==true then
		updateXYNeighbors(pos, name, validator)
	end
end
------------------------------------------------------------
--		__          ______   ____  _____  
--		\ \        / / __ \ / __ \|  __ \ 
--		 \ \  /\  / / |  | | |  | | |  | |
--		  \ \/  \/ /| |  | | |  | | |  | |
--		   \  /\  / | |__| | |__| | |__| |
--		    \/  \/   \____/ \____/|_____/ 
--                                  
------------------------------------------------------------
nodeReg(":default:wood", {
	description = "Wooden Planks",
	tiles = {"connective_wood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		checkXYNode(pos, "connective:wood", function(name) return validXYNode(name, "default:wood", "connective:wood") end)
	end,
})
def = {description = "Wooden Planks",
	tiles = {"connective_wood_left.png","connective_wood_left.png","connective_wood.png","connective_wood.png","connective_wood_right.png","connective_wood_left.png",},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:wood",
	paramtype2 = "facedir",
	after_destruct = function(pos, oldnode)
		updateXYNeighbors(pos, "connective:wood", function(name) return validXYNode(name, "default:wood", "connective:wood") end)
	end,
}
--tiles = {top, bottom, right, left, rear, front}
nodeReg("connective:wood1000", def)
	def.tiles = {"connective_wood_right.png","connective_wood_right.png","connective_wood.png","connective_wood.png","connective_wood_left.png","connective_wood_right.png",}
nodeReg("connective:wood0010", def)
	def.tiles = {"connective_wood.png","connective_wood.png","connective_wood_left.png","connective_wood_right.png","connective_wood.png","connective_wood.png",}
nodeReg("connective:wood0100", def)
	def.tiles = {"connective_wood.png","connective_wood.png","connective_wood_right.png","connective_wood_left.png","connective_wood.png","connective_wood.png",}
nodeReg("connective:wood0001", def)
	def.tiles = {"connective_wood_left.png","connective_wood_left.png","connective_wood_mid.png","connective_wood_right.png","connective_wood_mid.png","connective_wood_left.png",}
nodeReg("connective:wood1100", def)
	def.tiles = {"connective_wood_mid.png","connective_wood_mid.png","connective_wood.png","connective_wood.png","connective_wood_mid.png","connective_wood_mid.png",}
nodeReg("connective:wood1010", def)
	def.tiles = {"connective_wood_left.png","connective_wood_left.png","connective_wood_mid.png","connective_wood_left.png","connective_wood_right.png","connective_wood_mid.png",}
nodeReg("connective:wood1001", def)
	def.tiles = {"connective_wood_right.png","connective_wood_right.png","connective_wood_left.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_right.png",}
nodeReg("connective:wood0110", def)
	def.tiles = {"connective_wood.png","connective_wood.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png",}
nodeReg("connective:wood0101", def)
	def.tiles = {"connective_wood_right.png","connective_wood_right.png","connective_wood_right.png","connective_wood_mid.png","connective_wood_left.png","connective_wood_mid.png",}
nodeReg("connective:wood0011", def)
	def.tiles = {"connective_wood_right.png","connective_wood_right.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png",}
nodeReg("connective:wood0111", def)
	def.tiles = {"connective_wood_left.png","connective_wood_left.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png",}
nodeReg("connective:wood1101", def)
	def.tiles = {"connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png","connective_wood_mid.png",}
nodeReg("connective:wood1110", def)
nodeReg("connective:wood1011", def)
nodeReg("connective:wood1111", def)
if minetest.get_modpath("construct") then
	local aliasReg = register_construct_alias
	aliasReg("connective:wood1111", "default:wood")
	aliasReg("connective:wood1011", "default:wood")
	aliasReg("connective:wood1110", "default:wood")
	aliasReg("connective:wood1101", "default:wood")
	aliasReg("connective:wood0111", "default:wood")
	aliasReg("connective:wood0011", "default:wood")
	aliasReg("connective:wood0101", "default:wood")
	aliasReg("connective:wood0110", "default:wood")
	aliasReg("connective:wood1001", "default:wood")
	aliasReg("connective:wood1010", "default:wood")
	aliasReg("connective:wood1100", "default:wood")
	aliasReg("connective:wood0001", "default:wood")
	aliasReg("connective:wood0100", "default:wood")
	aliasReg("connective:wood1000", "default:wood")
end