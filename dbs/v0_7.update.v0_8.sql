
ALTER TABLE `Clientes_empresas` CHANGE `aplicar_dto_vol` `aplicar_dto_vol` TINYINT( 1 ) DEFAULT '0' NOT NULL ;
ALTER TABLE `Clientes` DROP `fecha_alta` ;
ALTER TABLE `Clientes_empresas` ADD `ultima_modificacion` TIMESTAMP NOT NULL AFTER `fecha_alta` ;

ALTER TABLE `Empresas_articulos` ADD `servicios_duracion_precio` INT( 4 ) DEFAULT NULL AFTER `precio_6` ;

ALTER TABLE `Compra_articulos` ADD `servicios_duracion_precio` INT( 4 ) DEFAULT NULL AFTER `dto_vol_bultos` ,
	ADD `cuota_alta` DECIMAL( 10, 3 ) DEFAULT NULL AFTER `servicios_duracion_precio` ,
	ADD `id_servicio` INT( 4 ) DEFAULT NULL AFTER `cuota_alta` ;
ALTER TABLE `Compra_articulos` ADD `servicios_poradelantado` TINYINT( 1 ) DEFAULT '0' NOT NULL AFTER `cuota_alta` ;

ALTER TABLE `Empresas_servicios` ADD `servicios_poradelantado` TINYINT( 1 ) DEFAULT '0' NOT NULL AFTER `cuota_alta` ;

ALTER TABLE `Servicios` CHANGE `id_servicio` `id_servicio` INT( 4 ) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `Facturas` CHANGE `id_serie` `id_serie` INT( 6 ) DEFAULT NULL ;

