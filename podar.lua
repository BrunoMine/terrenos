--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Podar terreno : remover folhas e arvore das laterais e em cima
  ]]

-- Nodes podáveis
local podaveis = {
	"default:papyrus", 
	"default:tree", 
	"default:jungletree", 
	"default:pine_tree", 
	"default:acacia_tree",
	"default:apple",
	"default:cactus"
}

-- Nodes extras para os lados a serem podados
local largura_extra = 2
local altura_extra = 10

-- Podar terreno (remove partes de arvores de perto cima e lados do terreno)
terrenos.podar = function(pos1, pos2)
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
	-- Pega todos os nodes na area em volta do terreno
	local nodes = minetest.find_nodes_in_area(
		{x=pos1.x-largura_extra, y=pos1.y, z=pos1.z-largura_extra}, 
		{x=pos2.x+largura_extra, y=pos2.y+altura_extra, z=pos2.z+largura_extra}, 
		podaveis
	)
	
	-- Remove todos os nodes pegos
	for i, pos in ipairs(nodes) do
		minetest.remove_node(pos)
	end
end
