--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Limpar terreno
  ]]

-- Limpa o terreno
terrenos.limpar = function(pos1, pos2, nodename)

	if pos1.x > pos2.x then -- Mantendo pos1 com o menor x
		local aux = pos1.x
		pos1.x = pos2.x
		pos2.x = aux
	end
	if pos1.z > pos2.z then -- Mantendo pos1 com o menor z
		local aux = pos1.z
		pos1.z = pos2.z
		pos2.z = aux
	end
	if pos1.y > pos2.y then -- Mantendo pos1 com o menor z
		local aux = pos1.y
		pos1.y = pos2.y
		pos2.y = aux
	end
	
	local pos = {x=pos1.x,y=pos1.y,z=pos1.z}
	while pos.y <= pos2.y do
		pos.x = pos1.x
		while pos.x <= pos2.x do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				minetest.set_node(pos, {name=nodename})
				pos.z = pos.z + 1
			end

			pos.x = pos.x + 1
		end

		nodename = "air"

		pos.y = pos.y + 1
	end
	
	-- Colocar 4 estacas nos limites
	minetest.set_node({x=pos1.x,y=pos1.y+1,z=pos1.z}, {name="default:fence_wood"})
	minetest.set_node({x=pos2.x,y=pos1.y+1,z=pos1.z}, {name="default:fence_wood"})
	minetest.set_node({x=pos1.x,y=pos1.y+1,z=pos2.z}, {name="default:fence_wood"})
	minetest.set_node({x=pos2.x,y=pos1.y+1,z=pos2.z}, {name="default:fence_wood"})
end

