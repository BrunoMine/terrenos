--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Desocupar placa
  ]]

-- Desocupar placa
terrenos.desocupar_placa = function(pos)
	
	local meta = minetest.get_meta(pos)
			
	local pos1, pos2 = terrenos.pegar_pos(pos, minetest.deserialize(meta:get_string("ref1")), minetest.deserialize(meta:get_string("ref2")))
	
	-- Trocar placa
	terrenos.trocar_node(pos, "terrenos:livre")
	
	-- Configurar placa
	local meta = minetest.get_meta(pos)
	meta:set_string("status", "livre")
	meta:set_string("infotext", "Terreno a Venda")
	meta:set_string("dono", nil)
	meta:set_string("ultimo_pagamento", nil)
	meta:set_float("area_id", nil)
	
end
