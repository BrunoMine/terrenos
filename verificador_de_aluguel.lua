--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Verificador de aluguel
  ]]

-- Abm's que atualizam as placas
minetest.register_abm({
	label =  "verificar terreno",
	nodenames = {"terrenos:ocupado"},
	interval = 3600,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		
		if meta:get_string("status") == "ocupado" then
			
			local data_ant = minetest.deserialize(meta:get_string("ultimo_pagamento"))
			local dif = terrenos.comparar_data(data_ant[1], data_ant[2], data_ant[3], data_ant[4], data_ant[5])
			
			if dif > terrenos.var.max_dias then
				local pos1, pos2 = terrenos.pegar_pos(pos, minetest.deserialize(meta:get_string("ref1")), minetest.deserialize(meta:get_string("ref2")))
			
				terrenos.desproteger_area(meta:get_string("area_id"))
			
				terrenos.limpar(pos1, pos2, minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name)
			
				terrenos.desocupar_placa(pos)
			end
			
		end
	end
})
