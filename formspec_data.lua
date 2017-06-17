--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Formspec de datas
  ]]
local sigla_mes = {
	"Jan",
	"Fev",
	"Mar",
	"Abr",
	"Mai",
	"Jun",
	"Jul",
	"Ago",
	"Set",
	"Out",
	"Nov",
	"Dez",
}


-- Retorna formspec da data atual cor
terrenos.formspec_data_rest = function(data_ant)
	
	local data_atual = {terrenos.pegar_data_atual()}
	
	-- Dias de diferença
	local max_dif = 3 * 30
	local dif = terrenos.comparar_data(data_ant[1], data_ant[2], data_ant[3], data_ant[4], data_ant[5])
	
	local dias_rest = max_dif - dif
	
	local st = tostring(dif)
	
	-- Pagou a menos de 1 mes
	if dif < 30 then
		st = core.colorize("#00FF00", st)
		
	-- Falta menos de 1 mes para expirar o terreno
	elseif dias_rest < 30 then
		st = core.colorize("#FF0000", st)
	
	-- Faltam menos de 2 meses para expirar o terreno	
	elseif dias_rest < 60 then
		st = core.colorize("#FFA500", st)
		
	-- Faltam menos de 3 meses para expirar o terreno	
	elseif dias_rest < 90 then
		st = core.colorize("#1E90FF", st)
		
	end
	
	return st
	
end

-- Retorna formspec da data atual cor
terrenos.formspec_data_pag = function()
	
	local data_atual = {terrenos.pegar_data_atual()}
	
	local st = data_atual[3].."/"..sigla_mes[data_atual[2]].."/"..data_atual[1]
	
	return st
	
end
