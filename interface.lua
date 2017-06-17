--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Interface
  ]]

-- Coordenadas rapidas
terrenos.lugar1 = {}
terrenos.lugar2 = {}
terrenos.ultima_placa = {}

-- Formspecs
local formspec_style = default.gui_bg
	..default.gui_bg_img

-- Acessar uma placa
terrenos.acessar = function(player, pos)
	local meta = minetest.get_meta(pos)
	local name = player:get_player_name()
	terrenos.ultima_placa[name] = {x=pos.x, y=pos.y, z=pos.z}
	
	-- Terreno desconfigurado
	if meta:get_string("status") == "desconfigurado" then
	
		-- Administrador de terrenos
		if minetest.check_player_privs(name, {terrenos_admin=true}) then
			
			local pos1, pos2 = "", ""
			if terrenos.lugar1[name] then pos1 = "OK" else pos1 = "INDEFINIDO" end
			if terrenos.lugar2[name] then pos2 = "OK" else pos2 = "INDEFINIDO" end
			
			local formspec = "size[5,4]"
				..formspec_style
				.."label[0,0;Terreno desconfigurado]"
				.."field[0.5,1.25;2.2,1.5;altura;Altura;10]"
				.."field[3,1.25;2.2,1.5;custo;Custo;0]"
				.."label[0,2.3;Pos1 "..pos1.." \nPos2 "..pos2.."]"
				.."button_exit[1,3.3;3,1;configurar;Configurar]"
				
			minetest.show_formspec(name, "terrenos:desconfigurado", formspec)
		end
	
	-- Terreno livre
	elseif meta:get_string("status") == "livre" then
		
		-- Qualquer jogador
		local formspec = "size[5,4]"
			..formspec_style
			.."label[0,0;Terreno a venda]"
			.."label[0,1;Altura de "..meta:get_float("altura").." blocos]"
			.."label[0,1.5;Custo de "..meta:get_float("custo").."]"
			.."item_image_button[0,2;1,1;"..terrenos.var.pag..";item;]"
			.."button_exit[1,3.25;3,1;comprar;Comprar]"
				
		minetest.show_formspec(name, "terrenos:livre", formspec)
	
	-- Terreno ocupado
	elseif meta:get_string("status") == "ocupado" then
	
		-- Administrador de terrenos
		if minetest.check_player_privs(name, {terrenos_admin=true}) then
			
			local formspec = "size[6,4]"
				..formspec_style
				.."label[0,0;Terreno ocupado]"
				.."label[0,1;Dono "..meta:get_string("dono").."]"
				.."label[0,1.5;Custo "..meta:get_float("custo").."]"
				.."label[0,2;Aluguel pago "..terrenos.formspec_data_pag().." dias]"
				.."label[0,2.5;Faltam "..terrenos.formspec_data_rest(minetest.deserialize(meta:get_string("ultimo_pagamento"))).." dias]"
				.."button_exit[0,3.25;3,1;remover;Remover]"
				.."button_exit[3,3.25;3,1;podar;Podar]"
				
			minetest.show_formspec(name, "terrenos:ocupado", formspec)
			
		-- Dono do terreno
		elseif meta:get_string("dono") == name then
			
			local formspec = "size[6,4]"
				..formspec_style
				.."label[0,0;Terreno ocupado]"
				.."label[0,1;Dono "..meta:get_string("dono").."]"
				.."label[0,1.5;Custo "..meta:get_float("custo").."]"
				.."label[0,2;Aluguel pago "..terrenos.formspec_data_pag().." dias]"
				.."label[0,2.5;Faltam "..terrenos.formspec_data_rest(minetest.deserialize(meta:get_string("ultimo_pagamento"))).." dias]"
				.."button_exit[0,3.25;6,1;aluguel;Pagar Aluguel]"
				
			minetest.show_formspec(name, "terrenos:ocupado", formspec)
			
		end
	end
end


-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)

	-- Placa "desconfigurado"
	if formname == "terrenos:desconfigurado" then
		local name = player:get_player_name()
	
		if fields.configurar then
			
			-- Verificar dados
			if tonumber(fields.custo) == nil then
				return minetest.chat_send_player(name, "Custo invalido")
			elseif tonumber(fields.altura) == nil then
				return minetest.chat_send_player(name, "Altura invalida")
			elseif terrenos.lugar1[name] == nil then
				return minetest.chat_send_player(name, "Defina o primeiro ponto do terreno")
			elseif terrenos.lugar2[name] == nil then
				return minetest.chat_send_player(name, "Defina o segundo ponto do terreno")
			end
			
			local pos = terrenos.ultima_placa[name]
			
			-- Trocar placa
			terrenos.trocar_node(pos, "terrenos:livre")
			
			-- Configurar placa
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Terreno a Venda")
			meta:set_string("status", "livre")
			meta:set_float("custo", tonumber(fields.custo))
			meta:set_float("altura", tonumber(fields.altura))
			terrenos.lugar2[name].y = terrenos.lugar2[name].y + fields.altura -- Ajuste de altura
			local pos1, pos2 = terrenos.ajustar_pos(terrenos.lugar1[name], terrenos.lugar2[name])
			local ref1, ref2 = terrenos.gerar_ref(pos, pos1, pos2)
			meta:set_string("ref1", minetest.serialize(ref1))
			meta:set_string("ref2", minetest.serialize(ref2))
			
			-- Limpar terreno para estado inicial
			terrenos.limpar(pos1, pos2, minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name)
			
			-- Zerar coordenadas rapidas
			terrenos.lugar1[name] = nil
			terrenos.lugar2[name] = nil
		end
	
	-- Placa "livre"
	elseif formname == "terrenos:livre" then
		local name = player:get_player_name()
		
		if fields.comprar then
			
			local pos = terrenos.ultima_placa[name]
			local meta = minetest.get_meta(pos)
			
			-- Verificar se jogador consegue comprar
			if terrenos.cobrar(player, {name=terrenos.var.pag, count=meta:get_float("custo")}) == false then
				return minetest.chat_send_player(name, "Nao consegues pagar o terreno. Precisas de mais "..terrenos.var.pag_desc)
			end
			
			local pos1, pos2 = terrenos.pegar_pos(pos, minetest.deserialize(meta:get_string("ref1")), minetest.deserialize(meta:get_string("ref2")))
			
			-- Trocar placa
			terrenos.trocar_node(pos, "terrenos:ocupado")
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Terreno de "..name)
			meta:set_string("status", "ocupado")
			meta:set_string("dono", name)
			meta:set_string("ultimo_pagamento", minetest.serialize({terrenos.pegar_data_atual()}))
			meta:set_float("area_id", terrenos.proteger_area(name, "Terreno", pos1, pos2)) -- Protege area
			
		end
	
	-- Placa "ocupado"
	elseif formname == "terrenos:ocupado" then
		local name = player:get_player_name()
		
		if fields.remover then
			
			local pos = terrenos.ultima_placa[name]
			local meta = minetest.get_meta(pos)
			
			local pos1, pos2 = terrenos.pegar_pos(pos, minetest.deserialize(meta:get_string("ref1")), minetest.deserialize(meta:get_string("ref2")))
			
			terrenos.desproteger_area(meta:get_string("area_id"))
			
			terrenos.limpar(pos1, pos2, minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name)
			
			terrenos.desocupar_placa(pos)
			
		elseif fields.podar then
			
			local pos = terrenos.ultima_placa[name]
			local meta = minetest.get_meta(pos)
			
			local pos1, pos2 = terrenos.pegar_pos(pos, minetest.deserialize(meta:get_string("ref1")), minetest.deserialize(meta:get_string("ref2")))
			
			terrenos.podar(pos1, pos2)
			
		elseif fields.aluguel then
			
			local pos = terrenos.ultima_placa[name]
			local meta = minetest.get_meta(pos)
			
			-- Verificar se ja pagou hoje
			local data_pag = minetest.deserialize(meta:get_string("ultimo_pagamento"))
			if terrenos.comparar_data(data_pag[1], data_pag[2], data_pag[3], data_pag[4], data_pag[5]) < 1 then
				return minetest.chat_send_player(name, "Aluguei ja foi pago hoje")
			end
			
			-- Verificar se jogador consegue pagar aluguel
			if terrenos.cobrar(player, {name=terrenos.var.pag, count=meta:get_float("custo")}) == false then
				return minetest.chat_send_player(name, "Nao consegues pagar o aluguel. Precisas de mais "..terrenos.var.pag_desc)
			end
			
			-- Atualiza data de pagamento
			meta:set_string("ultimo_pagamento", minetest.serialize({terrenos.pegar_data_atual()}))
			
		end
	
	end
	
end)


