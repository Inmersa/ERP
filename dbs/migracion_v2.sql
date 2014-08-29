
ALTER TABLE `Series_facturacion` ADD `id_serie_abonar` INT( 6 ) NULL DEFAULT NULL AFTER `id_empresa` ;

# La db de configuracion del crm ya no se llama crmauth, sino crmcfg
update _main set nombre = CONCAT('db_crmcfg_',substring(nombre,12)) WHERE nombre like 'db_crmau%';

# Estos 2 para borrar
#update _main set nombre='cfg_iconta_dbname' where nombre = 'cfg_iconta_dbconname';
#update _main set nombre='cfg_iconta_dbcfgname' where nombre = 'cfg_iconta_dbcfgconname';

update _main set nombre='cfg_app_iconta_dbname' where nombre = 'cfg_app_iconta_dbconname';
update _main set nombre='cfg_app_iconta_dbcfgname' where nombre = 'cfg_app_iconta_dbcfgconname';

INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_cliente', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_ventas', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_banco', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_descuento_financiero', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_descuento_comercial', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_gastos', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_retenciones', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Clientes_empresas.cc_efectos', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_proveedor', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_compras', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_banco', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_descuento_financiero', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_descuento_comercial', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_gastos', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_retenciones', 'fmtCC', NULL , NULL , NULL , NULL , NULL );
INSERT INTO Entity_format_style 
(id_entity_field, nombre, format_method, format_params, parser_method, parser_params, data_css, label_css)
VALUES ( NULL , 'Proveedores_empresas.cc_efectos', 'fmtCC', NULL , NULL , NULL , NULL , NULL );

REPLACE INTO Sub_Secc (id_sub_secc,nombre,tb_base,script,busc_defecto,nombre_visual,backoffice,module_mask) VALUES ('353','modif_efectos_proveedor','Efectos','efectos.php','0','','1','1')
Update Sec_Subsecc SET av_group = 0 WHERE id_sub_secc=353 AND id_seccion = 5
Update Sec_Subsecc SET av_group = av_group | 4  WHERE id_sub_secc=353 AND id_seccion=5
Update Sec_Subsecc SET av_group = av_group | 8  WHERE id_sub_secc=353 AND id_seccion=5
Update Sec_Subsecc SET av_group = av_group | 32  WHERE id_sub_secc=353 AND id_seccion=5


