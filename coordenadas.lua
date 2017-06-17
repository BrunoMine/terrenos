--[[
	Mod Terrenos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Manipular coordenada de posição
  ]]

-- Pegar coordenadas de referencias
--[[
	Esse metodo retorna as coordenadas `pos1` e `pos2` 
	localizadas com base nas referencias `ref1` e `ref2`
	respectivamente.
	Argumentos:
		<pos> coordenada de onde `ref1` e `ref2` se referenciam
		<ref1> referencia 1
		<ref2> referencia 2
	Retornos
		<pos1> coordenada da referencia 1
		<pos2> coordenada da referencia 2
  ]]
terrenos.pegar_pos = function(pos, ref1, ref2)
	local pos1 = {x=pos.x+ref1.x, y=pos.y+ref1.y, z=pos.z+ref1.z}
	local pos2 = {x=pos.x+ref2.x, y=pos.y+ref2.y, z=pos.z+ref2.z}
	return pos1, pos2
end


-- Gerar referencias de cordenadas
--[[
	Esse metodo gera duas referencias
  ]]
terrenos.gerar_ref = function(pos, pos1, pos2)
	local ref1 = {x=pos1.x-pos.x, y=pos1.y-pos.y, z=pos1.z-pos.z}
	local ref2 = {x=pos2.x-pos.x, y=pos2.y-pos.y, z=pos2.z-pos.z}
	return ref1, ref2
end


-- Ajustar coordenadas do menor ao maior
--[[
	Esse metodo retorna as duas coordenadas informadas porem 
	uma delas tera os menores valores para cada eixo e a outra 
	tera os maiores
	Retornos:
		<minp>
		<maxp>
  ]]
terrenos.ajustar_pos = function(pos1, pos2)
	local p1 = minetest.deserialize(minetest.serialize(pos1))
	local p2 = minetest.deserialize(minetest.serialize(pos2))
	
	if p1.x > p2.x then 
		p2.x = pos1.x
		p1.x = pos2.x
	end
	
	if p1.y > p2.y then 
		p2.y = pos1.y
		p1.y = pos2.y
	end
	
	if p1.z > p2.z then 
		p2.z = pos1.z
		p1.z = pos2.z
	end
	
	return p1, p2
end


