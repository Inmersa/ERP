

ALTER TABLE `Clientes_empresas` ADD `bic` VARCHAR( 12 ) AFTER `iban` , ADD `bban` VARCHAR( 26 ) AFTER `bic` ;
ALTER TABLE `Bancos` ADD `bic` VARCHAR( 12 ) AFTER `iban` , ADD `bban` VARCHAR( 26 ) AFTER `bic` ;
ALTER TABLE `Proveedores_empresas` ADD `bic` VARCHAR( 12 ) AFTER `iban` , ADD `bban` VARCHAR( 26 ) AFTER `bic` ;

ALTER TABLE `Proveedores_empresas` CHANGE `iban` `iban` VARCHAR( 4 ) DEFAULT NULL;
ALTER TABLE `Bancos` CHANGE `iban` `iban` VARCHAR( 4 ) DEFAULT NULL;

ALTER TABLE `Agentes` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Almacenes` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Bancos` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Clientes` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Direcciones_entrega` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Empresas` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Proveedores` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;
ALTER TABLE `Transportistas` CHANGE `cp` `cp` VARCHAR( 10 ) DEFAULT NULL ;

ALTER TABLE `Coordinadores` DROP PRIMARY KEY ;
ALTER TABLE `Coordinadores` ADD `id_coordinador` INT( 4 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
ALTER TABLE `Coordinadores` CHANGE `id_usr` `id_usr` INT( 5 ) ;

ALTER TABLE `Tarifas_transporte` ADD `costo_unidad` TINYINT( 1 ) DEFAULT '0' NOT NULL ;
ALTER TABLE `Albaranes` ADD `bultos` INT( 4 ) DEFAULT '0' NOT NULL ;
ALTER TABLE `Ayuda_epigrafes` CHANGE `id_imagen` `id_imagen` INT( 6 ) DEFAULT NULL ;

ALTER TABLE `Transportistas` ADD `apellidos` VARCHAR( 125 ) DEFAULT NULL AFTER `nombre` ;;
ALTER TABLE `Transportistas` ADD `cif` VARCHAR( 12 ) NOT NULL AFTER `razon_social` ;
ALTER TABLE `Transportistas` ADD `poblacion` VARCHAR( 200 ) AFTER `direccion` ;

ALTER TABLE `Clientes_empresas` CHANGE `fecha_alta` `fecha_alta` DATE DEFAULT NULL ;

ALTER TABLE `Clientes` CHANGE `telefono1` `telefono1` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Agentes` CHANGE `telefono1` `telefono1` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Almacenes` CHANGE `telefono` `telefono` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Direcciones_entrega` CHANGE `telefono1` `telefono1` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Empresas` CHANGE `telefono1` `telefono1` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Proveedores` CHANGE `telefono1` `telefono1` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `telefono2` `telefono2` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Transportistas` CHANGE `telefono` `telefono` VARCHAR( 15 ) DEFAULT NULL ,
CHANGE `fax` `fax` VARCHAR( 15 ) DEFAULT NULL ;

ALTER TABLE `Transportistas` ADD `telefono2` VARCHAR( 15 ) ,
ADD `iban` VARCHAR( 4 ) ,
ADD `bic` VARCHAR( 12 ) ,
ADD `bban` VARCHAR( 26 ) ,
ADD `entidad` INT( 4 ) UNSIGNED ZEROFILL,
ADD `dc_ccc` INT( 2 ) UNSIGNED ZEROFILL,
ADD `oficina` INT( 4 ) UNSIGNED ZEROFILL,
ADD `cuenta_bancaria` BIGINT( 10 ) UNSIGNED ZEROFILL;

ALTER TABLE `Gastos` ADD `descripcion` MEDIUMTEXT;
ALTER TABLE `Medios_contacto` ADD `descripcion` MEDIUMTEXT;

ALTER TABLE `Empresas_articulos` ADD `ultima_modificacion` TIMESTAMP( 14 ) NOT NULL AFTER `fecha_baja` ;
ALTER TABLE `Articulos` DROP `fecha_alta` ;

ALTER TABLE `Agentes` DROP `cuenta_bancaria` ;
ALTER TABLE `Agentes` 
ADD `iban` VARCHAR( 4 ) AFTER email,
ADD `bic` VARCHAR( 12 ) AFTER iban,
ADD `bban` VARCHAR( 26 ) AFTER bic,
ADD `entidad` INT( 4 ) UNSIGNED ZEROFILL AFTER bban,
ADD `dc_ccc` INT( 2 ) UNSIGNED ZEROFILL AFTER entidad,
ADD `oficina` INT( 4 ) UNSIGNED ZEROFILL AFTER dc_ccc,
ADD `cuenta_bancaria` BIGINT( 10 ) UNSIGNED ZEROFILL AFTER oficina;

ALTER TABLE `Localizacion_articulos` ADD INDEX `Caducidad` ( `lote` , `fecha_caducidad` ) ;
ALTER TABLE `Localizacion_articulos` ADD INDEX `Localizacion` ( `planta` , `pasillo`, `columna`, `fila` ) ;
ALTER TABLE `Localizacion_articulos` ADD INDEX `Referencia` ( `id_almacen_logico` , `id_articulo` ) ;

ALTER TABLE `Almacenes` ADD `nota_pie_albaran` MEDIUMTEXT;
ALTER TABLE `Localizacion_articulos` CHANGE `lote` `lote` VARCHAR( 8 ) NOT NULL ;
ALTER TABLE `Facturas_detalle` ADD `notas` MEDIUMTEXT;
alter table Lineas_detalle change cantidad_recibida cantidad_recibida decimal(7,2) NOT NULL DEFAULT 0;
