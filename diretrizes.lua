--
-- Mod placa_terreno
-- 
-- Diretrizes
--

terrenos.var = {}

-- Node usado como pagamento
terrenos.var.pag = minetest.setting_get("terrenos_item_pag") or "default:gold_ingot"
terrenos.var.pag_desc = minetest.registered_items[terrenos.var.pag].description

-- Quantidade de nodes pago como alugal
terrenos.var.qtd_pag_aluguel = tonumber(minetest.setting_get("terrenos_qtd_pag_aluguel") or 1)

-- Quantidade de dias para pagar aluguel
terrenos.var.max_dias = tonumber(minetest.setting_get("terrenos_meses_aluguel") or 3) * 30
