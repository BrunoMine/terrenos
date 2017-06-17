--
-- Mod placa_terreno
-- 
-- Diretrizes
--

terrenos.var = {}

-- Node usado como pagamento
terrenos.var.pag = "default:apple"
terrenos.var.pag_desc = minetest.registered_items[terrenos.var.pag].description

-- Quantidade de nodes pago como alugal
terrenos.var.qtd_pag_aluguel = 1

-- Quantidade de dias para pagar aluguel
terrenos.var.max_dias = 3 * 30
