ALTER TABLE Clientes_empresas drop fecha_inicio_facturacion;
ALTER TABLE Clientes_empresas drop periodo_facturacion;
ALTER table Efectos change monto_pagado monto_pagado decimal(10,2) NOT NULL DEFAULT '0';

ALTER TABLE Empresas 
	add prefijo_fact_ventas VARCHAR(4), 
	add sufijo_fact_ventas VARCHAR(4),
	add digitos_fact_ventas INT(3),
	add prefijo_ped_ventas VARCHAR(4), 
	add sufijo_ped_ventas VARCHAR(4),
	add contador_ped_ventas INT(10),
	add digitos_ped_ventas INT(3),
	add prefijo_alb_ventas VARCHAR(4), 
	add sufijo_alb_ventas VARCHAR(4),
	add contador_alb_ventas INT(10),
	add digitos_alb_ventas INT(3),
	add prefijo_pre_ventas VARCHAR(4), 
	add sufijo_pre_ventas VARCHAR(4),
	add contador_pre_ventas INT(10),
	add digitos_pre_ventas INT(3);

UPDATE Empresas set
	prefijo_fact_ventas = prefijo_fact,
	sufijo_fact_ventas = sufijo_fact,
	digitos_fact_ventas = digitos_fact,
	prefijo_ped_ventas = prefijo_ped,
	sufijo_ped_ventas = sufijo_ped,
	contador_ped_ventas = contador_ped,
	digitos_ped_ventas = digitos_ped,
	prefijo_alb_ventas = prefijo_alb,
	sufijo_alb_ventas = sufijo_alb,
	contador_alb_ventas = contador_alb,
	digitos_alb_ventas = digitos_alb,
	prefijo_pre_ventas = prefijo_pre,
	sufijo_pre_ventas = sufijo_pre,
	contador_pre_ventas = contador_pre,
	digitos_pre_ventas = digitos_pre;

ALTER TABLe Empresas 
	DROP prefijo_fact,
	DROP sufijo_fact,
	DROP contador_fact,
	DROP digitos_fact,
	DROP prefijo_ped,
	DROP sufijo_ped,
	DROP contador_ped,
	DROP digitos_ped,
	DROP prefijo_alb,
	DROP sufijo_alb,
	DROP contador_alb,
	DROP digitos_alb,
	DROP prefijo_pre,
	DROP sufijo_pre,
	DROP contador_pre,
	DROP digitos_pre;

ALTER TABLE Empresas_articulos DROP peso_unidad;

ALTER TABLE Proveedores_empresas drop fecha_inicio_facturacion;
ALTER TABLE Proveedores_empresas drop periodo_facturacion;

ALTER TABLE Tipo_agente DROP campo_accion;