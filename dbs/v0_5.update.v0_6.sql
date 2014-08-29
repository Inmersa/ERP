
ALTER TABLE `Agentes_facturas` DROP `comision` ;
ALTER TABLE `Facturas` ADD `factura_proforma` TINYINT( 1 ) DEFAULT '0' NOT NULL AFTER `factura_abono` ;

ALTER TABLE `Clientes` CHANGE `telefono1` `telefono1` VARCHAR( 13 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 13 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 13 ) DEFAULT NULL ;

ALTER TABLE `Direcciones_entrega` CHANGE `telefono1` `telefono1` VARCHAR( 13 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 13 ) DEFAULT NULL ;

ALTER TABLE `Efectos` CHANGE `fecha_vencimiento` `fecha_vencimiento` DATE DEFAULT NULL ,
CHANGE `fecha_abono` `fecha_abono` DATE DEFAULT NULL ,
CHANGE `fecha_devolucion` `fecha_devolucion` DATE DEFAULT NULL ;

