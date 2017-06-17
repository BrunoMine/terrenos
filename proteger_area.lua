--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Proteger area
  ]]

-- Proteger area para o jogador
terrenos.proteger_area = function(ownername, areaname, pos1, pos2)

	if pos1 and pos2 then
		pos1, pos2 = areas:sortPos(pos1, pos2)
	else
		return false
	end

	if not areas:player_exists(ownername) then
		return false
	end

	minetest.log("action", "Area registrada por compra de terreno. Owner = "..ownername..
		" AreaName = "..areaname..
		" StartPos = "..minetest.pos_to_string(pos1)..
		" EndPos = "  ..minetest.pos_to_string(pos2))

	local id = areas:add(ownername, areaname, pos1, pos2, nil)
	areas:save()

	return id
end

-- Remover area protegida
terrenos.desproteger_area = function(id)
	local id = tonumber(id)

	areas:remove(id)
	areas:save()
	return true
end

