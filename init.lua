--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Inicializador de scripts
  ]]

-- Variavel global
terrenos = {}

-- Privilegio
minetest.register_privilege("terrenos_admin", "Administrar terrenos")

-- Notificador de Inicializador
local notificar = function(msg)
	if minetest.setting_get("log_mods") then
		minetest.debug("[TERRENOS]"..msg)
	end
end

local modpath = minetest.get_modpath("terrenos")

-- Carregar scripts
notificar("Carregando...")
dofile(modpath.."/diretrizes.lua")
dofile(modpath.."/contador_tempo.lua")
dofile(modpath.."/coordenadas.lua")
dofile(modpath.."/formspec_data.lua")
dofile(modpath.."/limpar.lua")
dofile(modpath.."/cobrar.lua")
dofile(modpath.."/podar.lua")
dofile(modpath.."/trocar_node.lua")
dofile(modpath.."/proteger_area.lua")
dofile(modpath.."/desocupar_placa.lua")
dofile(modpath.."/interface.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/verificador_de_aluguel.lua")
notificar("OK")



