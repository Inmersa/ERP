# MySQL dump 7.1
#
# Host: intranet    Database: gestion_defecto
#--------------------------------------------------------
# Server version	3.23.32-log

#
# Dumping data for table 'Agentes'
#

INSERT INTO Agentes (id_agente, id_empresa, id_tipo_agente, id_usr, nombre, comision_base ) VALUES (0,1,0,0,'Agente Base',0);
UPDATE Agentes set id_agente=0 WHERE id_agente=LAST_INSERT_ID();

#
# Dumping data for table 'Almacenes'
#

INSERT INTO Almacenes (id_empresa, id_provincia, nombre ) VALUES (1,1,'Almacen Principal');
UPDATE Almacenes set id_almacen=0 WHERE id_almacen=LAST_INSERT_ID();

#
# Dumping data for table 'Almacenes_logicos'
#

INSERT INTO Almacenes_logicos (id_almacen, nombre, n_planta, n_pasillo, n_fila, n_columna) VALUES (0,'Todo el Almacen Principal',4,10,40,40);
UPDATE Almacenes_logicos set id_almacen_logico=0 WHERE id_almacen_logico=LAST_INSERT_ID();

#
# Dumping data for table 'Catalogo_imagenes'
#

INSERT INTO Catalogo_imagenes (id_imagen, nombre, descripcion, autor, copyright, fecha_toma, lugar_toma, palabras_clave, ruta, en_portada) VALUES (0,'logo.gif','Logo por defecto','',NULL,'2002-01-08',NULL,NULL,NULL,NULL);
UPDATE Catalogo_imagenes set id_imagen=0 WHERE id_imagen=LAST_INSERT_ID();

#
# Dumping data for table 'Certificados'
#

INSERT INTO Certificados (nombre) VALUES ('CCPAE');
UPDATE Certificados set id_certificado=0 WHERE id_certificado=LAST_INSERT_ID();

#
# Dumping data for table 'Divisa'
#

INSERT INTO Divisa (nombre, leyenda, ratio) VALUES ('Euro','&euro;',1.000000);
UPDATE Divisa SET id_divisa=0 where id_divisa=LAST_INSERT_ID();

INSERT INTO Familia_articulos (id_grupo_familia, nombre, stock, materia_prima) VALUES (0,'Familia por defecto',0,0);
UPDATE Familia_articulos SET id_familia=0 where id_familia=LAST_INSERT_ID();

#
# Dumping data for table 'Forma_pago'
#

INSERT INTO Forma_pago (nombre, num_efectos, dias_efectos) VALUES ('Contado',1,1);
UPDATE Forma_pago SET id_forma_pago=0 where id_forma_pago=LAST_INSERT_ID();

#
# Dumping data for table 'Forma_pago_TPV'
#

INSERT INTO Forma_pago_TPV (id_forma_pago_tpv, nombre, cobro_aplazado) VALUES (1,'Forma de pago 1',0);
UPDATE Forma_pago_TPV SET id_forma_pago_tpv=0 where id_forma_pago_tpv=LAST_INSERT_ID();

#
# Dumping data for table 'Grupo_empresas'
#

INSERT INTO Grupo_empresas (nombre) VALUES ('Grupo por defecto');
UPDATE Grupo_empresas SET id_grupo_empresa=0 where id_grupo_empresa=LAST_INSERT_ID();

#
# Dumping data for table 'Grupo_familias'
#

INSERT INTO Grupo_familias (nombre, descripcion) VALUES ('BIO','Productos Biológicos');
UPDATE Grupo_familias SET id_grupo_familia=0 where id_grupo_familia=LAST_INSERT_ID();

#
# Dumping data for table 'Marcas'
#

INSERT INTO Marcas (nombre) VALUES ('Sin marca');
UPDATE Marcas SET id_marca=0 where id_marca=LAST_INSERT_ID();

#
# Dumping data for table 'Paises'
#

INSERT INTO Paises (nombre, codigo, continente, prefijo_tlf, prefijo_cif) VALUES ('España',34,'Europa',34,'ES');
UPDATE Paises SET id_pais=0 where id_pais=LAST_INSERT_ID();

#
# Dumping data for table 'Provincias'
#

INSERT INTO Provincias (nombre, id_pais) VALUES ('Desconocida',0);
UPDATE Provincias SET id_provincia=0 where id_provincia=LAST_INSERT_ID();

#
# Dumping data for table 'Series_facturacion'
#

INSERT INTO Series_facturacion (nombre, descripcion, contador) VALUES ('A','Serie por defecto',0);
UPDATE Series_facturacion SET id_serie=0 where id_serie=LAST_INSERT_ID();

#
# Dumping data for table 'Servicios'
#

#INSERT INTO Servicios (id_servicio, nombre, duracion, plazo_factura) VALUES (0,'Sin Contrato',0,0);
#UPDATE Servicios SET id_servicio=0 where id_servicio=LAST_INSERT_ID();

#
# Dumping data for table 'Tarifas'
#

INSERT INTO Tarifas (nombre, campo_accion) VALUES ('Tarifa por defecto (precio standard)','precio_standard');
UPDATE Tarifas SET id_tarifa=0 where id_tarifa=LAST_INSERT_ID();

#
# Dumping data for table 'Tipo_agente'
#

INSERT INTO Tipo_agente (nombre) VALUES ('Comercial');
UPDATE Tipo_agente SET id_tipo_agente=0 where id_tipo_agente=LAST_INSERT_ID();

#
# Dumping data for table 'Tipo_cliente'
#

INSERT INTO Tipo_cliente (nombre, descripcion, aplicar_recargo, aplicar_iva) VALUES ('Sociedad Mercantil','Tipo por defecto',0,1);
UPDATE Tipo_cliente SET id_tipo_cliente=0 where id_tipo_cliente=LAST_INSERT_ID();

#
# Dumping data for table 'Tipos_IVA'
#

INSERT INTO Tipos_IVA (nombre, porcentaje, recargo_equivalente, cc_imp_soportado, cc_imp_repercutido, cc_re_soportado, cc_re_repercutido) VALUES ('7% (por defecto)',7.00,0.00,NULL,NULL,NULL,NULL);
UPDATE Tipos_IVA SET id_iva=0 where id_iva=LAST_INSERT_ID();

#
# Dumping data for table 'Transportistas'
#

INSERT INTO Transportistas (id_provincia, nombre) VALUES (0,'Por cuenta del Cliente');
UPDATE Transportistas SET id_transportista=0 where id_transportista=LAST_INSERT_ID();


/*!40000 ALTER TABLE Tipos_UnidadMedida DISABLE KEYS */;
LOCK TABLES Tipos_UnidadMedida WRITE;
INSERT INTO Tipos_UnidadMedida (id_tipo_unidadmedida, nombre, otro_peso_cubicaje, user_defined) VALUES (1,'Sin Definir',0,1),(2,'Peso',1,1),(3,'Volumen',2,1),(4,'Tiempo',0,1),(5,'Datos',0,1),(8,'Transferencia',0,1),(9,'Longitud',0,1);
UNLOCK TABLES;
/*!40000 ALTER TABLE Tipos_UnidadMedida ENABLE KEYS */;

/*!40000 ALTER TABLE Unidades_medida DISABLE KEYS */;
LOCK TABLES Unidades_medida WRITE;
INSERT INTO Unidades_medida (id_unidad_medida, id_tipo_unidadmedida, nombre, leyenda, user_defined, conversion_descompuesta, num_decimales) VALUES (17,1,'Sin ud. de medida','S/Ud.',1,0,0),(1,3,'Litros','Lt',1,0,3),(2,2,'Kilogramos','Gr',1,0,3),(3,4,'Minutos','m',1,1,0),(4,5,'Megabytes','M',1,0,3),(5,5,'Kilobits','Kb',1,0,0),(6,0,'Manojo','Mj',1,0,0),(7,0,'Unidad','Und',1,0,0),(8,0,'Bandeja','bdj',1,0,0),(9,9,'Metros','M',1,0,0),(10,0,'Centímetros Cúbicos','c.c.',1,0,0),(11,0,'Par (de zapatos)','Par',1,0,0),(12,0,'Bolsita (infusiones)','bl',1,0,0);
UNLOCK TABLES;
/*!40000 ALTER TABLE Unidades_medida ENABLE KEYS */;

/*!40000 ALTER TABLE UnidadesMedida_Escalas DISABLE KEYS */;
LOCK TABLES UnidadesMedida_Escalas WRITE;
INSERT INTO UnidadesMedida_Escalas (id_escala_medida, id_unidad_medida, nombre, leyenda, alias_list, factor_conversion) VALUES (2,2,'Gramo','Gr','G g Gr gr grs',1.00000000),(6,1,'mililitro','ml','',0.00100000),(7,1,'decilitro','dl','',0.10000000),(8,1,'litro','Lt','l L litro li',1.00000000),(9,1,'DecaLitro','','',10.00000000),(10,1,'HectoLitro','','',100.00000000),(11,1,'KiloLitro','','',1000.00000000),(12,1,'centilitro','cl','',0.01000000),(13,2,'Kilogramo','Kg','Kgr kg K',1000.00000000),(14,3,'segundo','s','seg sec s',0.00001667),(15,2,'Miligramo','mg','Mg mg Mgr mgr',0.00100000),(16,3,'minuto','m','mn Mn m M Min m',1.00000000),(17,3,'hora','h','h H Hrs hrs',60.00000000),(18,4,'Megas','M','MG Mg Megas meg Meg',1.00000000),(19,4,'Kilobytes','KB','Kb Kbytes Kilobytes',0.00097656),(20,4,'Bytes','B','bytes B Bytes',0.00000095),(21,5,'Kbits','Kb','Kbits Kb kb kbits',1.00000000),(22,5,'Bit','b','Bits B b bits',0.00097656),(23,5,'Megabits','Mb','Mbits mb',1024.00000000),(24,9,'metro','M','M m',1.00000000),(25,9,'Km','Km','KM K km',1000.00000000),(26,9,'cm','cm','cm',0.01000000),(27,9,'pulgada','Pul','pulgada',0.02540000),(28,9,'pie','Pie','Pie Foot',0.30480000),(29,9,'mm','mm','mm Mm Mi',0.00100000),(30,9,'yarda','Yd','Yd yd yardas yards',0.91440000),(36,5,'Gigabit','Gb','Gbits Gigabit gbits gbit',1048576.00000000),(35,4,'GigaByte','G','Gig g GB Gb',1024.00000000),(37,3,'dia','d','dia Dia dias Dias',1440.00000000),(38,3,'semana','sem','Sem semana Semana',10080.00000000);
UNLOCK TABLES;
/*!40000 ALTER TABLE UnidadesMedida_Escalas ENABLE KEYS */;


