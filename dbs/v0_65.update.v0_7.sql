
ALTER TABLE `Empresas` CHANGE `id_provincia` `id_provincia` INT( 6 ) DEFAULT '0' NOT NULL ;

ALTER TABLE `Localizacion_articulos` CHANGE `fecha_caducidad` `fecha_caducidad` DATETIME DEFAULT '0000-00-00' NOT NULL ;

ALTER TABLE `Localizacion_articulos` CHANGE `fecha_caducidad` `fecha_caducidad` DATE DEFAULT '0000-00-00 00:00:00' NOT NULL ;

ALTER TABLE `Detalles_albaran` CHANGE `fecha_caducidad` `fecha_caducidad` DATE DEFAULT '0000-00-00 00:00:00' NOT NULL ;
ALTER TABLE `Detalles_albaran` ADD `planta` INT( 4 ) DEFAULT '0' NOT NULL AFTER `id_almacen_logico` ,
	ADD `pasillo` INT( 4 ) DEFAULT '0' NOT NULL AFTER `planta` ,
	ADD `fila` INT( 4 ) DEFAULT '0' NOT NULL AFTER `pasillo` ,
	ADD `columna` INT( 4 ) DEFAULT '0' NOT NULL AFTER `fila` ;
ALTER TABLE `Detalles_albaran` ADD `fecha_devolucion` DATETIME DEFAULT NULL AFTER `cantidad` ;
ALTER TABLE `Detalles_albaran` ADD `observaciones` LONGTEXT DEFAULT NULL ;

ALTER TABLE `Bajas_localizacion` ADD `planta` INT( 4 ) DEFAULT '0' NOT NULL AFTER `id_almacen_logico` ,
	ADD `pasillo` INT( 4 ) DEFAULT '0' NOT NULL AFTER `planta` ,
	ADD `fila` INT( 4 ) DEFAULT '0' NOT NULL AFTER `pasillo` ,
	ADD `columna` INT( 4 ) DEFAULT '0' NOT NULL AFTER `fila` ,
	ADD `fecha_caducidad` DATE DEFAULT '0' NOT NULL AFTER `columna` ,
	ADD `id_albaran` INT( 6 ) DEFAULT NULL AFTER `fecha_caducidad` ;

ALTER TABLE `Localizacion_articulos` DROP PRIMARY KEY ,
 ADD PRIMARY KEY ( `id_articulo` , `id_almacen_logico` , `fecha_caducidad` , `lote`, `planta` , `pasillo` , `fila` , `columna` ) ;

ALTER TABLE `Bajas_localizacion` DROP PRIMARY KEY ;
ALTER TABLE `Bajas_localizacion` ADD `id_baja_localizacion` INT( 6 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
ALTER TABLE `Bajas_localizacion` ADD `id_detalle` INT( 7 ) DEFAULT NULL AFTER `id_albaran` ;

ALTER TABLE `Detalles_albaran` DROP PRIMARY KEY ,
	ADD PRIMARY KEY ( `id_detalle` , `id_albaran` , `id_almacen_logico` , `planta` , `pasillo` , `fila` , `columna`, `fecha_caducidad`, `lote` ) ;
ALTER TABLE `Detalles_albaran` ADD INDEX `RELACINES` ( `id_albaran` , `id_detalle` ) ;
ALTER TABLE `Detalles_albaran` ADD INDEX `LOCALIZACION` ( `id_almacen_logico` , `planta` , `pasillo` , `fila` , `columna` ) 

