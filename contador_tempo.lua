--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Contador de tempo
  ]]

-- Quantos dias tem cada mes
local dias_meses = {
	31, -- Janeiro
	28, -- Fevereiro (29 em ano bissexto)
	31, -- Março
	30, -- Abril
	31, -- Maio
	30, -- Junho
	31, -- Julho
	31, -- Agosto
	30, -- Setembro
	31, -- Outubro
	30, -- Novembro
	31 -- Dezembro
}

-- Pegar dias do mes naquele ano
local pegar_dias_mes = function(mes, ano)
	
	-- converter para valor numerico
	mes = tonumber(mes)
	ano = tonumber(ano)
	
	-- ajustando para numero entre 1 e 12
	if mes > 12 then mes = mes - (math.floor(mes/12)*12) end
	
	-- caso o mes de zero
	if mes == 0 then mes = 12 end
	
	-- adiciona um dia em Fevereiro caso seja ano bissexto
	if mes == 2 and math.fmod(ano, 4) == 0 then
		return dias_meses[mes] + 1
	else
		return dias_meses[mes]
	end
end

-- Pegar numero maior
local pegar_maior = function(n1, n2)
	if tonumber(n1) > tonumber(n2) then
		return n1
	else
		return n2
	end
end

-- Pegar numero menor
local pegar_menor = function(n1, n2)
	if n1 < n2 then
		return n1
	else
		return n2
	end
end

-- Pegar data atual
--[[
	Esse metodo retorna os valores referentes à data atual
	Retorno:
		<ano atual>
		<mes atual>
		<dia do mes atual>
		<hora do dia atual>
		<minutos da hora do dia atual>
  ]]
terrenos.pegar_data_atual = function()
	-- Pegando data atual
	local ano = tonumber(os.date("%Y"))
	local mes = tonumber(os.date("%m"))
	local dia = tonumber(os.date("%d"))
	local hora = tonumber(os.date("%H"))
	local minuto = tonumber(os.date("%M"))
	return ano, mes, dia, hora, minuto
end

-- Comparar data
--[[
	Esse metodo recebe uma data como argumento e retorna
	as quantidades de dias, horas e minutos em relação à 
	data atual
	Retorno:
		<diferença de dias>
		<diferença de horas>
		<diferença de minutos>
	Argumentos:
		<ano da data>
		<mes da data>
		<dia do mes da data>
		<hora do dia da data>
		<minutos da hora do dia da data>
  ]]
terrenos.comparar_data = function(ano, mes, dia, hora, minuto)
	if not ano or not tonumber(ano) then
		minetest.log("error", "[Terrenos] Ano invalido em especificado (em terrenos.comparar_data)")
		return false
	end
	if not mes or not tonumber(mes) then
		minetest.log("error", "[Terrenos] Mes invalido em especificado (em terrenos.comparar_data)")
		return false
	end
	if not dia or not tonumber(dia) then
		minetest.log("error", "[Terrenos] Dia invalido em especificado (em terrenos.comparar_data)")
		return false
	end
	if not hora or not tonumber(hora) then
		minetest.log("error", "[Terrenos] Hora invalido em especificado (em terrenos.comparar_data)")
		return false
	end
	if not minuto or not tonumber(minuto) then
		minetest.log("error", "[Terrenos] Minuto invalido em especificado (em terrenos.comparar_data)")
		return false
	end
	
	-- Conversoes
	ano = tonumber(ano)
	mes = tonumber(mes)
	dia = tonumber(dia)
	hora = tonumber(hora)
	minuto = tonumber(minuto)
	
	-- Pegando data atual
	local ano_atual, mes_atual, dia_atual, hora_atual, minuto_atual = terrenos.pegar_data_atual()
	
	-- Pegar diferença de ano
	local dif_ano = ano - ano_atual
	
	-- Pegar diferença de meses
	local dif_meses = mes - (mes_atual - (dif_ano*12)) -- (considerando os meses de um ano para outro)
	
	-- Pegar a diferença de dias
	local dif_dias = 0
	-- Pegar dias dos meses que passaram
	if dif_meses > 0 then -- do mes atual ate o mes futuro (apenas os meses inteiros, logo o ultimo nao conta, por isso o menos 1)
		local a = ano_atual -- ano do mes contado
		local n = mes_atual -- qual mes do ano contado
		for m=mes_atual, mes_atual+dif_meses-1 do
			if n > 12 then
				n = n - 12
				a = a + 1 
			end
			dif_dias = dif_dias + pegar_dias_mes(m, a)
			n = n + 1
		end
	elseif dif_meses < 0 then -- do mes passado do passado ate o mes atual
		local a = ano -- ano do mes contado
		local n = mes -- qual mes do ano contado
		for m=mes, mes+math.abs(dif_meses)-1 do
			if n > 12 then
				n = n - 12
				a = a + 1 
			end
			dif_dias = dif_dias + pegar_dias_mes(m, a)
			n = n + 1
		end
		dif_dias = dif_dias * (-1) -- mantem valor negativo por estar no passado
	end
	-- Adiciona a diferença de dias conforme os dias do mes de cada data
	dif_dias = dif_dias + (dia - dia_atual)
	
	-- Pegar diferença de horas
	local dif_horas = 0
	if dif_dias > 0 then
		if hora >= hora_atual then
			dif_horas = hora - hora_atual
		else
			dif_dias = dif_dias - 1
			dif_horas = (hora + 24) - hora_atual
		end
	elseif dif_dias < 0 then
		dif_dias = dif_dias + 1 -- (1 dia é tirado para ser fracionado em horas pois 1 desses dias não foi inteiro)
		dif_horas = (24-hora) + hora_atual -- (desconta as horas de 24 horas de um dia que foi descontado)
		if dif_horas >= 24 then
			dif_dias = dif_dias - 1
			dif_horas = dif_horas - 24
		end
		dif_horas = dif_horas * (-1) -- mantem valor negativo por estar no passado
	else -- A data é do mesmo dia
		dif_horas = hora - hora_atual
	end
	
	-- Pegar diferença de minutos
	local dif_minutos = 0
	if dif_horas > 0 then
		if minuto >= minuto_atual then
			dif_minutos = minuto - minuto_atual
		else
			dif_horas = dif_horas - 1
			dif_minutos = (minuto + 60) - minuto_atual
		end
	elseif dif_horas < 0 then
		dif_horas = dif_horas + 1 -- (1 dia é tirado para ser fracionado em horas pois 1 desses dias não foi inteiro)
		dif_minutos = (60-minuto) + minuto_atual -- (desconta as horas de 24 horas de um dia que foi descontado)
		if dif_minutos >= 60 then
			dif_horas = dif_horas - 1
			dif_minutos = dif_minutos - 60
		end
		dif_minutos = dif_minutos * (-1) -- mantem valor negativo por estar no passado
	else -- A data é da mesma hora
		dif_minutos = minuto - minuto_atual
	end
	
	-- Reajuste de valores (caso o saldo de horas esteja incompativel com saldo de dias)
	if dif_horas > 1 and dif_dias < 1 then
		dif_dias = dif_dias + 1
		dif_horas = dif_horas - 24
	end
	if dif_horas < 1 and dif_dias > 1 then
		dif_dias = dif_dias - 1
		dif_horas = dif_horas + 24
	end
	
	return dif_dias, dif_horas, dif_minutos
	
end
