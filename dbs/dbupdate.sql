
CREATE TABLE `Dias` (
`id_dia` INT( 4 ) NOT NULL ,
`id_mes` INT( 3 ) NOT NULL ,
`id_semana` INT( 3 ) NOT NULL ,
`fecha` DATE NOT NULL ,
`nombre` VARCHAR( 75 )
) CHARACTER SET = latin1 COMMENT = 'Registro de dias para periodificacion';

ALTER TABLE `Dias` ADD PRIMARY KEY ( `id_dia` ) ;
ALTER TABLE `Dias` ADD `num_dia` INT( 1 ) DEFAULT '1' NOT NULL AFTER `fecha` ;
ALTER TABLE `Dias` CHANGE `id_dia` `id_dia` INT( 4 ) NOT NULL AUTO_INCREMENT ;
ALTER TABLE `Dias` CHANGE `num_dia` `num_dia_semana` INT( 1 ) DEFAULT '1' NOT NULL ;

CREATE TABLE `Meses` (
`id_mes` INT( 3 ) NOT NULL ,
`id_anyo` INT( 2 ) NOT NULL ,
`num` INT( 2 ) NOT NULL ,
`nombre` VARCHAR( 125 ) NOT NULL ,
`f_ini` DATE NOT NULL ,
`f_fin` DATE NOT NULL ,
`n_dias` INT( 2 ) NOT NULL ,
PRIMARY KEY ( `id_mes` )
) CHARACTER SET = latin1 COMMENT = 'Agrupacion mensual para periodificacion contable';
ALTER TABLE `Meses` CHANGE `id_mes` `id_mes` INT( 3 ) NOT NULL AUTO_INCREMENT ;

CREATE TABLE `Semanas` (
`id_semana` INT( 3 ) NOT NULL ,
`id_trimestre` INT( 2 ) NOT NULL ,
`numero` INT( 2 ) NOT NULL ,
`nombre` VARCHAR( 125 ) ,
`f_ini` DATE NOT NULL ,
`f_fin` DATE NOT NULL ,
`n_dias` INT( 2 ) NOT NULL ,
PRIMARY KEY ( `id_semana` )
) CHARACTER SET = latin1 COMMENT = 'Agrupaciones semanales para Periodificacion';
ALTER TABLE `Semanas` CHANGE `id_semana` `id_semana` INT( 3 ) NOT NULL AUTO_INCREMENT ;

CREATE TABLE `Trimestres` (
`id_trimestre` INT( 2 ) NOT NULL ,
`id_anyo` INT( 2 ) NOT NULL ,
`nombre` VARCHAR( 125 ) ,
`f_ini` DATE NOT NULL ,
`f_fin` DATE NOT NULL ,
`n_semanas` INT( 2 ) NOT NULL ,
PRIMARY KEY ( `id_trimestre` )
) CHARACTER SET = latin1 COMMENT = 'Periodos de agrupacion';
ALTER TABLE `Trimestres` CHANGE `id_trimestre` `id_trimestre` INT( 2 ) NOT NULL AUTO_INCREMENT ;

CREATE TABLE `Anyos` (
`id_anyo` INT( 2 ) NOT NULL ,
`numero` INT( 4 ) NOT NULL ,
`nombre` VARCHAR( 125 ) ,
`f_ini` DATE NOT NULL ,
`f_fin` DATE NOT NULL ,
`n_trimestres` INT( 2 ) NOT NULL ,
PRIMARY KEY ( `id_anyo` )
) CHARACTER SET = latin1 COMMENT = 'Anyos Periodificados';
ALTER TABLE `Anyos` CHANGE `id_anyo` `id_anyo` INT( 2 ) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `Albaranes` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Albaranes` ADD `id_dia_envio` INT( 4 ) NOT NULL AFTER `fecha_envio` ;
ALTER TABLE `Albaranes` ADD `id_dia_recepcion` INT( 4 ) NOT NULL AFTER `fecha_recepcion` ;
ALTER TABLE `Bajas_localizacion` ADD `id_dia_baja` INT( 4 ) NOT NULL AFTER `fecha_baja` ;
ALTER TABLE `Clientes_empresas` ADD `id_dia_alta` INT( 4 ) NOT NULL AFTER `fecha_alta` ;
ALTER TABLE `Clientes_empresas` ADD `id_dia_baja` INT( 4 ) NOT NULL AFTER `fecha_baja` ;
ALTER TABLE `Efectos` ADD `id_dia_vencimiento` INT( 4 ) NOT NULL AFTER `fecha_vencimiento` ;
ALTER TABLE `Efectos` ADD `id_dia_abono` INT( 4 ) NOT NULL AFTER `fecha_abono` ;
ALTER TABLE `Efectos` ADD `id_dia_devolucion` INT( 4 ) NOT NULL AFTER `fecha_devolucion` ;
ALTER TABLE `Efectos_parciales` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Empresas_articulos` ADD `id_dia_alta` INT( 4 ) NOT NULL AFTER `fecha_alta` ;
ALTER TABLE `Empresas_articulos` ADD `id_dia_baja` INT( 4 ) NOT NULL AFTER `fecha_baja` ;
ALTER TABLE `Facturas` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Pedidos` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Presupuestos` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Promociones` ADD `id_dia_inicio` INT( 4 ) NOT NULL AFTER `fecha_inicio` ;
ALTER TABLE `Promociones` ADD `id_dia_fin` INT( 4 ) NOT NULL AFTER `fecha_fin` ;
ALTER TABLE `Proveedores_empresas` ADD `id_dia_alta` INT( 4 ) NOT NULL AFTER `fecha_alta` ;
ALTER TABLE `Proveedores_empresas` ADD `id_dia_baja` INT( 4 ) NOT NULL AFTER `fecha_baja` ;
ALTER TABLE `Recorridos` ADD `id_dia` INT( 4 ) NOT NULL AFTER `fecha` ;
ALTER TABLE `Facturas` ADD `fecha_emision` DATE AFTER `id_dia` ,
ADD `id_dia_emision` INT( 4 ) AFTER `fecha_emision` ;

ALTER TABLE `Facturas` ADD INDEX `DiaFra` ( `id_dia` ) ;
ALTER TABLE `Facturas` ADD INDEX `DiaEmision` ( `id_dia_emision` ) ;

ALTER TABLE `Albaranes` ADD INDEX `DiaAlb` ( `id_dia` ) ;
ALTER TABLE `Albaranes` ADD INDEX `DiaEnvio` ( `id_dia_envio` ) ;
ALTER TABLE `Albaranes` ADD INDEX `DiaRecepcion` ( `id_dia_recepcion` ) ;
ALTER TABLE `Bajas_localizacion` ADD INDEX `DiaBaja` ( `id_dia_baja` ) ;
ALTER TABLE `Clientes_empresas` ADD INDEX `DiaAlta` ( `id_dia_alta` ) ;
ALTER TABLE `Clientes_empresas` ADD INDEX `DiaBaja` ( `id_dia_baja` ) ;
ALTER TABLE `Efectos` ADD INDEX `DiaVto` ( `id_dia_vencimiento` ) ;
ALTER TABLE `Efectos` ADD INDEX `DiaAbono` ( `id_dia_abono` ) ;
ALTER TABLE `Efectos` ADD INDEX `DiaDevol` ( `id_dia_devolucion` ) ;
ALTER TABLE `Efectos_parciales` ADD INDEX `DiaEff` ( `id_dia` ) ;
ALTER TABLE `Empresas_articulos` ADD INDEX `DiaAlta` ( `id_dia_alta` ) ;
ALTER TABLE `Empresas_articulos` ADD INDEX `DiaBaja` ( `id_dia_baja` ) ;
ALTER TABLE `Pedidos` ADD INDEX `DiaPed` ( `id_dia` ) ;
ALTER TABLE `Presupuestos` ADD INDEX `DiaPre` ( `id_dia` ) ;
ALTER TABLE `Promociones` ADD INDEX `DiaIni` ( `id_dia_inicio` ) ;
ALTER TABLE `Promociones` ADD INDEX `DiaFin` ( `id_dia_fin` ) ;
ALTER TABLE `Proveedores_empresas` ADD INDEX `DiaAlta` ( `id_dia_alta` ) ;
ALTER TABLE `Proveedores_empresas` ADD INDEX `DiaBaja` ( `id_dia_baja` ) ;
ALTER TABLE `Recorridos` ADD INDEX `DiaRec` ( `id_dia` ) ;

ALTER TABLE `Semanas` ADD `num_semana_trimestre` INT( 2 ) NOT NULL AFTER `n_dias` ;
ALTER TABLE `Trimestres` ADD `num_trimestre_anyo` INT( 2 ) NOT NULL AFTER `n_semanas` ;

ALTER TABLE `Empresas_articulos` ADD `wwwhome` TINYINT( 1 ) DEFAULT '0' NOT NULL ,
ADD `wwwportada` TINYINT( 1 ) DEFAULT '0' NOT NULL ,
ADD `wwwdestacado` TINYINT( 1 ) DEFAULT '0' NOT NULL ;

ALTER TABLE `Empresas_articulos` ADD `wwwactivo` TINYINT( 1 ) DEFAULT '0' NOT NULL AFTER `frecuente` ;
ALTER TABLE `Promociones` CHANGE `cantidad` `cantidad` DECIMAL( 10, 3 ) DEFAULT '0' NOT NULL ;

ALTER TABLE `Lineas_detalle` ADD INDEX `Presupuesto` ( `id_presupuesto` ) ;
ALTER TABLE `Lineas_detalle` CHANGE `id_articulo` `id_articulo` INT( 6 ) DEFAULT '0' NOT NULL ;

ALTER TABLE Pedidos add index DEntrega (id_direccion);
ALTER TABLE `Pedidos` ADD INDEX `Proveedor` ( `id_proveedor` ) ;
ALTER TABLE `Pedidos` ADD INDEX `EmpresaPedido` ( `id_empresa` , `id_pedido` ) ;
ALTER TABLE Facturas_detalle add index LDetalle (id_detalle);
ALTER TABLE Detalles_albaran add index LDetalle (id_detalle);
ALTER TABLE IVAs add index Pedido (id_pedido);

ALTER TABLE `Detalles_albaran` DROP INDEX `RELACINES` ,
ADD INDEX `RELACIONES` ( `id_albaran` , `id_detalle` ) 

ALTER TABLE `Albaranes` ADD INDEX `Ref` ( `referencia` ) ;
ALTER TABLE `Albaranes` ADD INDEX `RefExt` ( `referencia_externa` ) ;
ALTER TABLE `Pedidos` ADD INDEX `Ref` ( `referencia` ) ;
ALTER TABLE `Pedidos` ADD INDEX `RefExt` ( `referencia_externa` ) ;
ALTER TABLE `Detalles_albaran` ADD `estado` TINYINT( 2 ) DEFAULT '0' NOT NULL ;
ALTER TABLE `Detalles_albaran` ADD `stock_previsto` DECIMAL( 8, 3 ) DEFAULT '0' AFTER `cantidad` ;

alter table Bajas_localizacion change descripcion descripcion mediumtext;

ALTER TABLE `Articulos` ADD `codigo_barras_bulto` DECIMAL( 13 ) AFTER `codigo_barras` ,
ADD `codigo_barras_palet` DECIMAL( 13 ) AFTER `codigo_barras_bulto` ;

ALTER TABLE `Articulos` ADD `dias_vida` BIGINT( 6 ) AFTER `codigo_barras_palet` ;

ALTER TABLE `Empresas_articulos` ADD `pto_vida_venta` DECIMAL( 5, 2 ) AFTER `bultos_capa_palet` ,
ADD `pto_vida_compra` DECIMAL( 5, 2 ) AFTER `pto_vida_venta` ;

CREATE TABLE `Notificaciones` (
`id_notificacion` INT( 5 ) NOT NULL AUTO_INCREMENT ,
`de` VARCHAR( 125 ) NOT NULL ,
`para` VARCHAR( 125 ) NOT NULL ,
`tema` VARCHAR( 255 ) ,
`tipo_mime` VARCHAR( 125 ) NOT NULL ,
`body` LONGBLOB,
PRIMARY KEY ( `id_notificacion` )
) CHARACTER SET = latin1 COMMENT = 'Mensajes, Notificaciones y Alertas';
ALTER TABLE `Notificaciones` ADD `fecha` DATETIME NOT NULL AFTER `tema` ;
ALTER TABLE `Notificaciones` ADD `estado` INT( 2 ) DEFAULT '0' NOT NULL AFTER `body` ;

CREATE TABLE `biomundo_gestion`.`Empresarios` (
`id_empresario` int( 6 ) NOT NULL AUTO_INCREMENT ,
`id_empresa` int( 6 ) NOT NULL default '0',
`id_usr` int( 6 ) default NULL ,
`crm_id_empleado` int( 5 ) default NULL ,
`cif` varchar( 12 ) default NULL ,
`nombre` varchar( 75 ) NOT NULL default '',
`apellidos` varchar( 200 ) NOT NULL default '',
`direccion` varchar( 200 ) default NULL ,
`cp` varchar( 10 ) default NULL ,
`poblacion` varchar( 200 ) default NULL ,
`id_provincia` int( 6 ) NOT NULL default '0',
`telefono1` varchar( 15 ) default NULL ,
`telefono2` varchar( 15 ) default NULL ,
`email` varchar( 75 ) default NULL ,
`iban` varchar( 4 ) default NULL ,
`bic` varchar( 12 ) default NULL ,
`bban` varchar( 26 ) default NULL ,
`entidad` int( 4 ) unsigned zerofill default NULL ,
`dc_ccc` int( 2 ) unsigned zerofill default NULL ,
`oficina` int( 4 ) unsigned zerofill default NULL ,
`cuenta_bancaria` bigint( 10 ) unsigned zerofill default NULL ,
`observaciones` mediumtext,
PRIMARY KEY ( `id_empresario` ) ,
UNIQUE KEY `id_empresario` ( `id_empresario` )
) TYPE = MYISAM DEFAULT CHARSET = latin1;

CREATE TABLE `biomundo_gestion`.`MozosAlmacen` (
`id_mozo` int( 6 ) NOT NULL AUTO_INCREMENT ,
`id_empresa` int( 6 ) NOT NULL default '0',
`id_almacen` int( 6 ) NOT NULL default '0',
`id_usr` int( 6 ) default NULL ,
`crm_id_empleado` int( 5 ) default NULL ,
`cif` varchar( 12 ) default NULL ,
`nombre` varchar( 75 ) NOT NULL default '',
`apellidos` varchar( 200 ) NOT NULL default '',
`direccion` varchar( 200 ) default NULL ,
`cp` varchar( 10 ) default NULL ,
`poblacion` varchar( 200 ) default NULL ,
`id_provincia` int( 6 ) NOT NULL default '0',
`telefono1` varchar( 15 ) default NULL ,
`telefono2` varchar( 15 ) default NULL ,
`email` varchar( 75 ) default NULL ,
`iban` varchar( 4 ) default NULL ,
`bic` varchar( 12 ) default NULL ,
`bban` varchar( 26 ) default NULL ,
`entidad` int( 4 ) unsigned zerofill default NULL ,
`dc_ccc` int( 2 ) unsigned zerofill default NULL ,
`oficina` int( 4 ) unsigned zerofill default NULL ,
`cuenta_bancaria` bigint( 10 ) unsigned zerofill default NULL ,
`observaciones` mediumtext,
PRIMARY KEY ( `id_mozo` ) ,
UNIQUE KEY `id_mozo` ( `id_mozo` )
) TYPE = MYISAM DEFAULT CHARSET = latin1;
ALTER TABLE `MozosAlmacen` RENAME `Mozos_almacen` ;

ALTER TABLE `Albaranes` ADD `id_preparado_por` INT(4) AFTER `preparado`, ADD `id_empaquetado_por` INT(4) AFTER `id_preparado_por`, ADD `id_rev
isado_por` INT(4) AFTER `id_empaquetado_por`;
ALTER TABLE `Albaranes` ADD `recogida` INT( 1 ) DEFAULT '0' NOT NULL AFTER `id_almacen` ;

CREATE TABLE `biomundo_gestion`.`Altas_stock` (
`id_alta_stock` int( 6 ) NOT NULL AUTO_INCREMENT ,
`id_tipo_alta` int( 5 ) NOT NULL default '0',
`lote` varchar( 50 ) NOT NULL default '',
`id_articulo` int( 6 ) NOT NULL default '0',
`id_almacen_logico` int( 4 ) NOT NULL default '0',
`planta` int( 4 ) NOT NULL default '0',
`pasillo` int( 4 ) NOT NULL default '0',
`fila` int( 4 ) NOT NULL default '0',
`columna` int( 4 ) NOT NULL default '0',
`fecha_caducidad` date NOT NULL default '0000-00-00',
`id_albaran` int( 6 ) default NULL ,
`id_detalle` int( 7 ) default NULL ,
`cantidad` decimal( 8, 3 ) default NULL ,
`descripcion` mediumtext,
`fecha_alta` datetime NOT NULL default '0000-00-00 00:00:00',
`id_dia_alta` int( 4 ) NOT NULL default '0',
PRIMARY KEY ( `id_alta_stock` ) ,
KEY `DiaBaja` ( `id_dia_alta` )
) TYPE = MYISAM DEFAULT CHARSET = latin1;

CREATE TABLE Tipos_Alta_stock (
  id_tipo_alta int(6) NOT NULL auto_increment,
  nombre varchar(75) NOT NULL default '',
  descripcion varchar(255) default NULL,
  PRIMARY KEY  (id_tipo_alta)
) TYPE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `biomundo_gestion`.`Cuarentenas` (
`id_cuarentena` int( 6 ) NOT NULL AUTO_INCREMENT ,
`id_tipo_cuarentena` int( 5 ) NOT NULL default '0',
`crm_id_incidencia` int( 6 ) ,
`lote` varchar( 50 ) NOT NULL default '',
`id_articulo` int( 6 ) NOT NULL default '0',
`id_almacen_logico` int( 4 ) NOT NULL default '0',
`planta` int( 4 ) NOT NULL default '0',
`pasillo` int( 4 ) NOT NULL default '0',
`fila` int( 4 ) NOT NULL default '0',
`columna` int( 4 ) NOT NULL default '0',
`fecha_caducidad` date NOT NULL default '0000-00-00',
`id_albaran` int( 6 ) default NULL ,
`id_detalle` int( 7 ) default NULL ,
`cantidad` decimal( 8, 3 ) default NULL ,
`descripcion_apertura` mediumtext,
`descripcion_cierre` mediumtext,
`fecha_apertura` datetime NOT NULL default '0000-00-00 00:00:00',
`id_dia_apertura` int( 4 ) NOT NULL default '0',
`fecha_cierre` datetime NOT NULL default '0000-00-00 00:00:00',
`id_dia_cierre` int( 4 ) NOT NULL default '0',
PRIMARY KEY ( `id_cuarentena` ) ,
KEY `DiaApertura` ( `id_dia_apertura` ),
KEY `DiaCierre` ( `id_dia_cierre` )
) TYPE = MYISAM DEFAULT CHARSET = latin1;

CREATE TABLE Tipos_Cuarentena (
  id_tipo_cuarentena int(6) NOT NULL auto_increment,
  nombre varchar(75) NOT NULL default '',
  descripcion varchar(255) default NULL,
  PRIMARY KEY  (id_tipo_cuarentena)
) TYPE=MyISAM DEFAULT CHARSET=latin1;

ALTER TABLE `Cuarentenas` ADD `cantidad_alta` DECIMAL( 8, 3 ) AFTER `cantidad` ,
ADD `cantidad_baja` DECIMAL( 8, 3 ) AFTER `cantidad_alta` ;

REPLACE INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (123,'Bajas_localizacion','id_baja_almacen','Bajas_almacen','id_baja_almacen','N-1');
REPLACE INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (27037,'Almacenes_logicos','id_almacen_logico','Bajas_localizacion','id_almacen_logico','1-N');
REPLACE INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (27038,'Bajas_localizacion','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');

INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Tipos_Alta_stock','id_tipo_alta','Altas_stock','id_tipo_alta','1-N');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Altas_stock','id_tipo_alta','Tipos_Alta_stock','id_tipo_alta','N-1');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Altas_stock','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Almacenes_logicos','id_almacen_logico','Altas_stock','id_almacen_logico','1-N');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Altas_stock','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');

INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Tipos_Cuarentena','id_tipo_cuarentena','Cuarentenas','id_tipo_cuarentena','1-N');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Cuarentenas','id_tipo_cuarentena','Tipos_Cuarentena','id_tipo_cuarentena','N-1');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Cuarentenas','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Almacenes_logicos','id_almacen_logico','Cuarentenas','id_almacen_logico','1-N');
INSERT INTO `Relaciones` (`id_relacion`, `tabla_origen`, `campo_origen`, `tabla_destino`, `campo_destino`, `tipo`) VALUES (NULL,'Cuarentenas','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');

ALTER TABLE `Compra_articulos` ADD `pto_vida_compra` DECIMAL( 4, 2 ) AFTER `dto_vol_bultos` ;

INSERT INTO `Relaciones` ( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES ( '', 'Mozos_almacen', 'id_empresa', 'Empresas', 'id_empresa', 'N-1');

INSERT INTO `Relaciones` ( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES ( '', 'Mozos_almacen', 'id_almacen', 'Almacenes', 'id_almacen', 'N-1');

INSERT INTO `Relaciones` ( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES ( '', 'Almacenes', 'id_almacen', 'Mozos_almacen', 'id_almacen', '1-N');
update biomundo_gestion_inmersa.Sub_Plts set allow_mask = NULL, deny_mask = NULL where nombre = 'incidencias';


INSERT INTO `Relaciones` ( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES ( NULL, 'Empresarios', 'id_empresa', 'Empresas', 'id_empresa', 'N-1');
INSERT INTO `Relaciones` ( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES ( NULL, 'Empresas', 'id_empresa', 'Empresarios', 'id_empresa', '1-N');

ALTER TABLE `Direcciones_entrega` ADD `id_transportista` INT( 4 ) AFTER `id_cliente` ;

ALTER TABLE `Albaranes` ADD `fecha_preparado` DATETIME AFTER `id_dia` ,
ADD `id_dia_preparado` INT( 7 ) AFTER `fecha_preparado` ;

ALTER TABLE `Mozos_almacen` ADD `notificar_stock` TINYINT( 1 ) DEFAULT '0' NOT NULL AFTER `crm_id_empleado` ;
ALTER TABLE `Albaranes` ADD `id_proveedor` INT( 6 ) AFTER `id_almacen` ;

ALTER TABLE `biomundo_gestion_inmersa.Acciones` ADD `sel_sub_sec` VARCHAR( 256 ) DEFAULT NULL AFTER `del_sub_sec` ;

ALTER TABLE `Articulos` ADD `wwwsinopsis` MEDIUMTEXT, ADD `wwwdescripcion` MEDIUMTEXT;

