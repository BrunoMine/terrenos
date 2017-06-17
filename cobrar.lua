--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Cobrar itens do jogador
  ]]

-- Cobrar item do jogador
terrenos.cobrar = function(player, itemstack)
	local inv = player:get_inventory()
	
	-- Verificar se o jogador consegue pagar
	if not inv:contains_item("main", itemstack) then return false end
	
	
	-- Retira itens do jogador
	local i = itemstack.name
	local n = itemstack.count
	i = i[1]
	for r=1, tonumber(n) do -- 1 eh o tanto que quero tirar
		inv:remove_item("main", i) -- tira 1 por vez
	end
	
	return true
end
