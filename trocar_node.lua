--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Trocar node
  ]]

-- Trocar node
terrenos.trocar_node = function(pos, nodename)
	-- Pegar node
	local node = minetest.get_node(pos)
	-- Pegar metadados
	local metadados = minetest.get_meta(pos):to_table()
	-- Troca o nome
	node.name = nodename
	-- Coloca novo node
	minetest.set_node(pos, node)
	-- Coloca metadados no novo node
	minetest.get_meta(pos):from_table(metadados)
end

