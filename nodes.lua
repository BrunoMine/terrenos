--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Nodes
  ]]

-- Placa de Terreno
minetest.register_node("terrenos:ocupado", {
	description = "Placa de Terreno",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	drop = "",
	tiles = {
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png^terrenos_ocupado.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0.125, 0.375, -0.4375, 0.4375}, -- Base
			{-0.3125, -0.5, 0.25, 0.3125, -0.0625, 0.3125}, -- Placa
		}
	},
	groups = {choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Placa de Terreno (desconfigurado)")
		meta:set_string("status", "desconfigurado")
	end,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing then
			local name = user:get_player_name()
			if terrenos.lugar1[name] == nil then 
				terrenos.lugar1[name] = pointed_thing.under
				minetest.chat_send_player(name, "Lugar 1 definido")
			elseif terrenos.lugar2[name] == nil then 
				terrenos.lugar2[name] = pointed_thing.under
				minetest.chat_send_player(name, "Lugar 2 definido")
			else
				terrenos.lugar1[name] = nil
				terrenos.lugar2[name] = nil
				minetest.chat_send_player(name, "Lugar 1 e 2 zerados")
			end
		end
	end,
	on_rightclick = function(pos, node, clicker)
		terrenos.acessar(clicker, pos)
	end,
})

-- Placa de Terreno (Livre)
minetest.register_node("terrenos:livre", {
	description = "Placa de Terreno",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	drop = "",
	tiles = {
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png",
		"default_pine_wood.png^terrenos_livre.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, 0.0625, 0.3125, -0.4375, 0.4375}, -- Base
			{-0.0625, -0.5, 0.1875, 0.0625, -0.125, 0.3125}, -- Haste
			{-0.4375, -0.125, 0.1875, 0.4375, 0.5, 0.3125} -- Placa
		}
	},
	groups = {choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function (pos, node, clicker)
		terrenos.acessar(clicker, pos)
	end,
})
