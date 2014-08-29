ALTER TABLE `Pedidos` ADD `ratio_divisa` DECIMAL(10,4) DEFAULT '0.0' AFTER `preparado`;
ALTER TABLE `Clientes_empresas` DROP `id_divisa`;
ALTER TABLE `Clientes` ADD `id_divisa` INT(2) DEFAULT '0' NOT NULL AFTER `id_cliente`;
ALTER TABLE `Divisa` CHANGE `id_divisa` `id_divisa` INT(2) NOT NULL AUTO_INCREMENT;
ALTER TABLE `Empresas` CHANGE `id_divisa` `id_divisa` INT(2) DEFAULT '0';
ALTER TABLE `Proveedores` ADD `id_divisa` INT(2) DEFAULT '0' AFTER `id_proveedor`;
ALTER TABLE `Proveedores_empresas` DROP `riesgo`;
ALTER TABLE `Proveedores_empresas` ADD `mantener_ratio_divisa` INT(3);
ALTER TABLE `Divisa` CHANGE `ratio` `ratio` DECIMAL(8,6) DEFAULT '0.000000' NOT NULL;
ALTER TABLE `Series_facturacion` ADD `contabilizable` TINYINT(1) DEFAULT '1' NOT NULL;
ALTER TABLE `Empresas_articulos` ADD `dto_vol` DECIMAL(4,2) AFTER `precio_venta`, ADD `dto_vol_bultos` INT(3) NOT NULL AFTER `dto_vol`;
ALTER TABLE `Compra_articulos` ADD `dto_vol` DECIMAL(4,2) AFTER `descuento`, ADD `dto_vol_bultos` INT(3) AFTER `dto_vol`;
ALTER TABLE `Clientes_empresas` ADD `aplicar_dto_vol` TINYINT(1) DEFAULT '1' NOT NULL AFTER `mostrar_ofertas`;
ALTER TABLE `Proveedores_empresas` ADD `aplicar_retencion` TINYINT(1) DEFAULT '0' NOT NULL AFTER `descuento_financiero`;
ALTER TABLE `Proveedores_empresas` ADD `aplicar_iva` TINYINT(1) DEFAULT '1' NOT NULL AFTER `aplicar_retencion`, ADD `aplicar_recargo` TINYINT(1) DEFAULT '0' NOT NULL AFTER `aplicar_iva`;
ALTER TABLE `Pedidos` ADD `id_almacen` INT( 6 ) DEFAULT '0' NOT NULL AFTER `id_direccion` ;
ALTER TABLE `Proveedores` ADD `apellidos` VARCHAR( 150 ) AFTER `nombre` ;
ALTER TABLE `Empresas` ADD `apellidos` VARCHAR( 150 ) AFTER `nombre` ;
ALTER TABLE `Series_facturacion` ADD `id_empresa` INT( 4 ) DEFAULT '1' NOT NULL AFTER `id_serie` ;

ALTER TABLE `Empresas` ADD `dto_gnrl_vol` DECIMAL(4,2) AFTER `retencion`;
ALTER TABLE `Empresas` ADD `dto_gnrl_vol_bultos` INT(3) AFTER `dto_gnrl_vol`;
ALTER TABLE `Empresas` ADD `dto_gnrl_vol_capa` DECIMAL( 4, 2 ) AFTER `dto_gnrl_vol_bultos` ,
 ADD `dto_gnrl_vol_capa_uds` INT( 3 ) AFTER `dto_gnrl_vol_capa` ,
 ADD `dto_gnrl_vol_palet` DECIMAL( 4, 2 ) AFTER `dto_gnrl_vol_capa_uds` ,
 ADD `dto_gnrl_vol_palet_uds` INT( 3 ) AFTER `dto_gnrl_vol_palet` ;
ALTER TABLE `Empresas` CHANGE `dto_gnrl_vol` `dto_gnrl_vol_bulto` DECIMAL( 4, 2 ) DEFAULT NULL ,
 CHANGE `dto_gnrl_vol_bultos` `dto_gnrl_vol_bulto_uds` INT( 3 ) DEFAULT NULL ;

ALTER TABLE `Proveedores` ADD `dto_gnrl_vol` DECIMAL(4,2) AFTER `retencion`, ADD `dto_gnrl_vol_bultos` INT(3) AFTER `dto_gnrl_vol`;
ALTER TABLE `Proveedores` ADD `dto_gnrl_vol_capa` DECIMAL( 4, 2 ) AFTER `dto_gnrl_vol_bultos` ,
 ADD `dto_gnrl_vol_capa_uds` INT( 3 ) AFTER `dto_gnrl_vol_capa` ,
 ADD `dto_gnrl_vol_palet` DECIMAL( 4, 2 ) AFTER `dto_gnrl_vol_capa_uds` ,
 ADD `dto_gnrl_vol_palet_uds` INT( 3 ) AFTER `dto_gnrl_vol_palet` ;
ALTER TABLE `Proveedores` CHANGE `dto_gnrl_vol` `dto_gnrl_vol_bulto` DECIMAL( 4, 2 ) DEFAULT NULL ,
 CHANGE `dto_gnrl_vol_bultos` `dto_gnrl_vol_bulto_uds` INT( 3 ) DEFAULT NULL ;

ALTER TABLE `Compra_articulos` ADD `PV_oficial` DECIMAL( 10, 3 ) AFTER `precio` ,
 ADD `PVP_oficial` DECIMAL( 10, 3 ) AFTER `PV_oficial` ;
ALTER TABLE `Compra_articulos` ADD `preferente` TINYINT( 1 ) DEFAULT '0' NOT NULL ;
ALTER TABLE `Empresas_articulos` CHANGE `bultos_palet` `capas_palet` INT( 4 ) DEFAULT '0';

ALTER TABLE `Tipos_IVA` CHANGE `cc_imp_soportado` `cc_imp_soportado` BIGINT( 10 ) DEFAULT NULL ,
  CHANGE `cc_imp_repercutido` `cc_imp_repercutido` BIGINT( 10 ) DEFAULT NULL ,
  CHANGE `cc_re_soportado` `cc_re_soportado` BIGINT( 10 ) DEFAULT NULL ,
  CHANGE `cc_re_repercutido` `cc_re_repercutido` BIGINT( 10 ) DEFAULT NULL ;

ALTER TABLE Tpv ADD prefijo_ticket VARCHAR(4) AFTER nombre ,
ADD contador_ticket bigint(10) NOT NULL DEFAULT 0 after prefijo_ticket,
ADD digitos_ticket int(2) NOT NULL DEFAULT 0 after contador_ticket,
ADD sufijo_ticket varchar(4) after digitos_ticket;


ALTER TABLE Empresas ADD contador_ticket bigint(10) NOT NULL DEFAULT 0 after digitos_ped_compras,
ADD digitos_ticket int(2) NOT NULL DEFAULT 0 after contador_ticket;

ALTER TABLE Empresas_articulos ADD precio_4 DECIMAL(9,2) AFTER precio_venta,
		ADD precio_5 DECIMAL(9,2) AFTER precio_4,
		ADD precio_6 DECIMAL(9,2) AFTER precio_5;
ALTER TABLE `Tarifas` ADD `campo_recomendacion` VARCHAR( 20 ) NOT NULL ;

ALTER TABLE Tickets ADD referencia VARCHAR(25);

ALTER TABLE `Agentes_clientes` CHANGE `comision` `comision` DECIMAL( 4, 2 ) DEFAULT NULL,
	CHANGE `comision_repartida` `comision_repartida` DECIMAL( 4, 2 ) DEFAULT NULL;
ALTER TABLE `Agentes_clientes` ADD `fecha_fin` DATETIME DEFAULT NULL;

ALTER TABLE `Facturas` ADD `id_asiento` INT( 7 ) DEFAULT NULL ;

ALTER TABLE `Clientes_empresas` CHANGE `cc_banco` `cc_banco` double DEFAULT NULL ,
CHANGE `cc_cliente` `cc_cliente` double DEFAULT NULL ,
CHANGE `cc_ventas` `cc_ventas` double DEFAULT NULL ,
CHANGE `cc_descuentos` `cc_descuentos` double DEFAULT NULL ,
CHANGE `cc_gastos` `cc_gastos` double DEFAULT NULL ,
CHANGE `cc_retenciones` `cc_retenciones` double DEFAULT NULL ,
CHANGE `cc_efectos` `cc_efectos` double DEFAULT NULL ,
CHANGE `cc_iva` `cc_iva` double DEFAULT NULL ;

ALTER TABLE `Clientes_empresas` DROP `cc_iva` ;
ALTER TABLE `Clientes_empresas` ADD `cc_descuento_comercial` double AFTER `cc_descuentos` ;
ALTER TABLE `Clientes_empresas` CHANGE `cc_descuentos` `cc_descuento_financiero` double DEFAULT NULL ;

ALTER TABLE `Proveedores_empresas` DROP `cc_iva` ;
ALTER TABLE `Proveedores_empresas` CHANGE `cc_banco` `cc_banco` DOUBLE DEFAULT NULL ,
CHANGE `cc_gastos` `cc_gastos` DOUBLE DEFAULT NULL ,
CHANGE `cc_compras` `cc_compras` DOUBLE DEFAULT NULL ,
CHANGE `cc_descuentos` `cc_descuentos` DOUBLE DEFAULT NULL ,
CHANGE `cc_retenciones` `cc_retenciones` DOUBLE DEFAULT NULL ,
CHANGE `cc_efectos` `cc_efectos` DOUBLE DEFAULT NULL ;
ALTER TABLE `Proveedores_empresas` CHANGE `cc_descuentos` `cc_descuento_financiero` DOUBLE DEFAULT NULL ;
ALTER TABLE `Proveedores_empresas` ADD `cc_descuento_comercial` DOUBLE DEFAULT NULL AFTER `cc_descuento_financiero` ;
ALTER TABLE `Proveedores_empresas` ADD `cc_proveedor` DOUBLE DEFAULT NULL AFTER `cc_banco` ;

ALTER TABLE `Facturas` ADD `total_bruto` DECIMAL( 10, 2 ) DEFAULT '0' NOT NULL AFTER `monto_total` ;
ALTER TABLE `IVAs` ADD `bruto` DECIMAL( 10, 3 ) NOT NULL AFTER `id_pedido` ;

ALTER TABLE `Tipos_IVA` CHANGE `cc_imp_soportado` `cc_imp_soportado` DOUBLE DEFAULT NULL ,
CHANGE `cc_imp_repercutido` `cc_imp_repercutido` DOUBLE DEFAULT NULL ,
CHANGE `cc_re_soportado` `cc_re_soportado` DOUBLE DEFAULT NULL ,
CHANGE `cc_re_repercutido` `cc_re_repercutido` DOUBLE DEFAULT NULL ;

ALTER TABLE `Rappel` CHANGE `porcentaje` `porcentaje` DECIMAL( 4, 2 ) DEFAULT '0.0000' NOT NULL ;
ALTER TABLE `Rappel` CHANGE `monto_inicial` `monto_inicial` DOUBLE NOT NULL ,
CHANGE `monto_final` `monto_final` DOUBLE NOT NULL ;

ALTER TABLE `Proveedores` DROP `aplicar_iva` ,
DROP `aplicar_recargo` ;
ALTER TABLE `Proveedores` CHANGE `telefono1` `telefono1` VARCHAR( 13 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 13 ) DEFAULT NULL ;

ALTER TABLE `Efectos` ADD `id_asiento` INT( 7 ) DEFAULT NULL ;
ALTER TABLE `Efectos_parciales` ADD `id_asiento` INT( 7 ) DEFAULT NULL AFTER `medio_pago` ;

ALTER TABLE `Tpv` ADD `id_empresa` INT( 3 ) DEFAULT '0' NOT NULL AFTER `id_tpv` ;

ALTER TABLE `Tarifas` ADD `pto_recomendacion` DECIMAL( 4, 2 ) DEFAULT NULL AFTER `campo_recomendacion` ,
ADD `coniva_recomendacion` TINYINT( 1 ) DEFAULT '1' NOT NULL AFTER `pto_recomendacion` ;

ALTER TABLE `Clientes_empresas` ADD `dc_ccc` INT( 2 ) UNSIGNED ZEROFILL DEFAULT '00' NOT NULL AFTER `entidad` ;
ALTER TABLE `Clientes_empresas` CHANGE `entidad` `entidad` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `oficina` `oficina` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `cuenta_bancaria` `cuenta_bancaria` BIGINT(10) UNSIGNED ZEROFILL DEFAULT NULL ;

ALTER TABLE `Bancos` ADD `dc_ccc` INT( 2 ) UNSIGNED ZEROFILL DEFAULT '00' NOT NULL AFTER `entidad` ;
ALTER TABLE `Bancos` CHANGE `entidad` `entidad` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `oficina` `oficina` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `cuenta_bancaria` `cuenta_bancaria` BIGINT(10) UNSIGNED ZEROFILL DEFAULT NULL ;

ALTER TABLE `Proveedores_empresas` ADD `dc_ccc` INT( 2 ) UNSIGNED ZEROFILL DEFAULT '00' NOT NULL AFTER `entidad` ;
ALTER TABLE `Proveedores_empresas` CHANGE `entidad` `entidad` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `oficina` `oficina` INT( 4 ) UNSIGNED ZEROFILL DEFAULT '0',
	CHANGE `cuenta_bancaria` `cuenta_bancaria` BIGINT(10) UNSIGNED ZEROFILL DEFAULT NULL ;

