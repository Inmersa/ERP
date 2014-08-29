-- MySQL dump 10.11
--
-- Host: bbdd4.biomundo    Database: biomundo_gestion
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Agentes`
--

DROP TABLE IF EXISTS Agentes;
CREATE TABLE Agentes (
  id_agente int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_tipo_agente int(6) NOT NULL default '1',
  id_usr int(6) default NULL,
  crm_id_empleado int(5) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(200) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  id_provincia int(6) NOT NULL default '0',
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  email varchar(75) character set latin1 default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default NULL,
  dc_ccc int(2) unsigned zerofill default NULL,
  oficina int(4) unsigned zerofill default NULL,
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  comision_base decimal(4,2) NOT NULL default '0.00',
  comision_repartida decimal(4,2) NOT NULL default '0.00',
  cif varchar(12) character set latin1 default NULL,
  observaciones mediumtext character set latin1,
  PRIMARY KEY  (id_agente),
  UNIQUE KEY id_agente (id_agente)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Agentes_clientes`
--

DROP TABLE IF EXISTS Agentes_clientes;
CREATE TABLE Agentes_clientes (
  id_cliente int(6) NOT NULL default '0',
  id_agente int(6) NOT NULL default '0',
  comision decimal(4,2) default NULL,
  comision_repartida decimal(4,2) default NULL,
  fecha_captacion datetime default NULL,
  fecha_fin datetime default NULL,
  PRIMARY KEY  (id_cliente,id_agente)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Agentes_facturas`
--

DROP TABLE IF EXISTS Agentes_facturas;
CREATE TABLE Agentes_facturas (
  id_factura int(6) NOT NULL default '0',
  id_agente int(6) NOT NULL default '0',
  monto decimal(20,10) NOT NULL default '0.0000000000',
  monto_liquidado decimal(20,10) NOT NULL default '0.0000000000',
  PRIMARY KEY  (id_agente,id_factura)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Albaranes`
--

DROP TABLE IF EXISTS Albaranes;
CREATE TABLE Albaranes (
  id_albaran int(6) NOT NULL auto_increment,
  id_transportista int(6) NOT NULL default '0',
  id_pedido int(6) NOT NULL default '0',
  id_direccion int(6) default '0',
  id_almacen int(6) NOT NULL default '0',
  id_proveedor int(6) default NULL,
  recogida int(1) NOT NULL default '0',
  observaciones mediumtext character set latin1,
  fecha datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia int(4) NOT NULL default '0',
  fecha_preparado datetime default NULL,
  id_dia_preparado int(7) default NULL,
  fecha_envio datetime default NULL,
  id_dia_envio int(4) NOT NULL default '0',
  fecha_recepcion datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_recepcion int(4) NOT NULL default '0',
  preparado tinyint(1) NOT NULL default '0',
  id_preparado_por int(4) default NULL,
  id_empaquetado_por int(4) default NULL,
  id_revisado_por int(4) default NULL,
  enviado tinyint(1) NOT NULL default '0',
  confirmacion tinyint(1) NOT NULL default '0',
  devolucion tinyint(1) NOT NULL default '0',
  referencia varchar(50) character set latin1 default NULL,
  referencia_externa varchar(50) character set latin1 default NULL,
  bultos int(4) NOT NULL default '0',
  PRIMARY KEY  (id_albaran),
  KEY Ref (referencia),
  KEY RefExt (referencia_externa),
  KEY DiaAlb (id_dia),
  KEY DiaEnvio (id_dia_envio),
  KEY DiaRecepcion (id_dia_recepcion)
) ENGINE=InnoDB AUTO_INCREMENT=197259 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Albaranes_Incidencias_CRM`
--

DROP TABLE IF EXISTS Albaranes_Incidencias_CRM;
CREATE TABLE Albaranes_Incidencias_CRM (
  id_albaran int(6) NOT NULL default '0',
  id_incidencia int(11) NOT NULL default '0',
  PRIMARY KEY  (id_albaran,id_incidencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Almacenes`
--

DROP TABLE IF EXISTS Almacenes;
CREATE TABLE Almacenes (
  id_almacen int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_provincia int(6) NOT NULL default '1',
  mask int(10) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  telefono varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  cargo_persona_contacto varchar(100) character set latin1 default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  nota_pie_albaran mediumtext character set latin1,
  PRIMARY KEY  (id_almacen)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Almacenes_logicos`
--

DROP TABLE IF EXISTS Almacenes_logicos;
CREATE TABLE Almacenes_logicos (
  id_almacen_logico int(6) NOT NULL auto_increment,
  id_almacen int(6) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  n_planta int(11) NOT NULL default '10',
  n_pasillo int(11) NOT NULL default '10',
  n_fila int(11) NOT NULL default '10',
  n_columna int(11) NOT NULL default '10',
  PRIMARY KEY  (id_almacen_logico)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Altas_stock`
--

DROP TABLE IF EXISTS Altas_stock;
CREATE TABLE Altas_stock (
  id_alta_stock int(6) NOT NULL auto_increment,
  id_tipo_alta int(5) NOT NULL default '0',
  lote varchar(50) character set latin1 NOT NULL default '',
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(4) NOT NULL default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  fecha_caducidad date NOT NULL default '0000-00-00',
  cantidad decimal(8,3) default NULL,
  descripcion mediumtext character set latin1,
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_alta int(4) NOT NULL default '0',
  PRIMARY KEY  (id_alta_stock),
  KEY DiaBaja (id_dia_alta)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Anyos`
--

DROP TABLE IF EXISTS Anyos;
CREATE TABLE Anyos (
  id_anyo int(2) NOT NULL auto_increment,
  numero int(4) NOT NULL default '0',
  nombre varchar(125) character set latin1 default NULL,
  f_ini date NOT NULL default '0000-00-00',
  f_fin date NOT NULL default '0000-00-00',
  n_trimestres int(2) NOT NULL default '0',
  PRIMARY KEY  (id_anyo)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos`
--

DROP TABLE IF EXISTS Articulos;
CREATE TABLE Articulos (
  id_articulo int(6) NOT NULL auto_increment,
  id_marca int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  id_subfamilia int(4) NOT NULL default '0',
  id_unidad_medida int(4) NOT NULL default '0',
  id_certificado int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  mascara_modulo bigint(14) default NULL,
  nombre varchar(75) collate latin1_spanish_ci NOT NULL,
  descripcion varchar(255) collate latin1_spanish_ci default NULL,
  observaciones varchar(255) collate latin1_spanish_ci default NULL,
  codigo_barras decimal(13,0) NOT NULL default '0',
  codigo_barras_bulto decimal(13,0) default NULL,
  codigo_barras_palet decimal(13,0) default NULL,
  dias_vida bigint(6) default NULL,
  garantia int(2) default NULL,
  cantidad_medida decimal(7,3) default NULL,
  peso_unidad decimal(7,3) default NULL,
  referencia varchar(15) collate latin1_spanish_ci default NULL,
  wwwsinopsis mediumtext collate latin1_spanish_ci,
  wwwdescripcion mediumtext collate latin1_spanish_ci,
  PRIMARY KEY  (id_articulo)
) ENGINE=InnoDB AUTO_INCREMENT=8041 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_20120617`
--

DROP TABLE IF EXISTS Articulos_20120617;
CREATE TABLE Articulos_20120617 (
  id_articulo int(6) NOT NULL auto_increment,
  id_marca int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  id_unidad_medida int(4) NOT NULL default '0',
  id_certificado int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  mascara_modulo bigint(14) default NULL,
  nombre varchar(75) collate latin1_spanish_ci NOT NULL,
  descripcion varchar(255) collate latin1_spanish_ci default NULL,
  observaciones varchar(255) collate latin1_spanish_ci default NULL,
  codigo_barras decimal(13,0) NOT NULL default '0',
  codigo_barras_bulto decimal(13,0) default NULL,
  codigo_barras_palet decimal(13,0) default NULL,
  dias_vida bigint(6) default NULL,
  garantia int(2) default NULL,
  cantidad_medida decimal(7,3) default NULL,
  peso_unidad decimal(7,3) default NULL,
  referencia varchar(15) collate latin1_spanish_ci default NULL,
  wwwsinopsis mediumtext collate latin1_spanish_ci,
  wwwdescripcion mediumtext collate latin1_spanish_ci,
  PRIMARY KEY  (id_articulo)
) ENGINE=InnoDB AUTO_INCREMENT=7661 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_20120625`
--

DROP TABLE IF EXISTS Articulos_20120625;
CREATE TABLE Articulos_20120625 (
  id_articulo int(6) NOT NULL auto_increment,
  id_marca int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  id_unidad_medida int(4) NOT NULL default '0',
  id_certificado int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  mascara_modulo bigint(14) default NULL,
  nombre varchar(75) collate latin1_spanish_ci NOT NULL,
  descripcion varchar(255) collate latin1_spanish_ci default NULL,
  observaciones varchar(255) collate latin1_spanish_ci default NULL,
  codigo_barras decimal(13,0) NOT NULL default '0',
  codigo_barras_bulto decimal(13,0) default NULL,
  codigo_barras_palet decimal(13,0) default NULL,
  dias_vida bigint(6) default NULL,
  garantia int(2) default NULL,
  cantidad_medida decimal(7,3) default NULL,
  peso_unidad decimal(7,3) default NULL,
  referencia varchar(15) collate latin1_spanish_ci default NULL,
  wwwsinopsis mediumtext collate latin1_spanish_ci,
  wwwdescripcion mediumtext collate latin1_spanish_ci,
  PRIMARY KEY  (id_articulo)
) ENGINE=InnoDB AUTO_INCREMENT=7684 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_20130312`
--

DROP TABLE IF EXISTS Articulos_20130312;
CREATE TABLE Articulos_20130312 (
  id_articulo int(6) NOT NULL auto_increment,
  id_marca int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  id_unidad_medida int(4) NOT NULL default '0',
  id_certificado int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  mascara_modulo bigint(14) default NULL,
  nombre varchar(75) collate latin1_spanish_ci NOT NULL,
  descripcion varchar(255) collate latin1_spanish_ci default NULL,
  observaciones varchar(255) collate latin1_spanish_ci default NULL,
  codigo_barras decimal(13,0) NOT NULL default '0',
  codigo_barras_bulto decimal(13,0) default NULL,
  codigo_barras_palet decimal(13,0) default NULL,
  dias_vida bigint(6) default NULL,
  garantia int(2) default NULL,
  cantidad_medida decimal(7,3) default NULL,
  peso_unidad decimal(7,3) default NULL,
  referencia varchar(15) collate latin1_spanish_ci default NULL,
  wwwsinopsis mediumtext collate latin1_spanish_ci,
  wwwdescripcion mediumtext collate latin1_spanish_ci,
  PRIMARY KEY  (id_articulo)
) ENGINE=InnoDB AUTO_INCREMENT=7854 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_articulos`
--

DROP TABLE IF EXISTS Articulos_articulos;
CREATE TABLE Articulos_articulos (
  id_articulo int(6) NOT NULL default '0',
  id_materia_prima int(6) NOT NULL default '0',
  unidades decimal(20,8) default NULL,
  PRIMARY KEY  (id_materia_prima,id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_competencia`
--

DROP TABLE IF EXISTS Articulos_competencia;
CREATE TABLE Articulos_competencia (
  id_articulo int(6) NOT NULL default '0',
  id_competencia int(6) NOT NULL default '0',
  precio decimal(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (id_competencia,id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_descatalogar`
--

DROP TABLE IF EXISTS Articulos_descatalogar;
CREATE TABLE Articulos_descatalogar (
  id_articulo int(6) NOT NULL auto_increment,
  id_marca int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  id_unidad_medida int(4) NOT NULL default '0',
  id_certificado int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  mascara_modulo bigint(14) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  observaciones varchar(255) character set latin1 default NULL,
  codigo_barras decimal(13,0) NOT NULL default '0',
  codigo_barras_bulto decimal(13,0) default NULL,
  codigo_barras_palet decimal(13,0) default NULL,
  dias_vida bigint(6) default NULL,
  garantia int(2) default NULL,
  cantidad_medida decimal(7,3) default NULL,
  peso_unidad decimal(7,3) default NULL,
  referencia varchar(15) character set latin1 default NULL,
  wwwsinopsis mediumtext character set latin1,
  wwwdescripcion mediumtext character set latin1,
  PRIMARY KEY  (id_articulo)
) ENGINE=InnoDB AUTO_INCREMENT=6682 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_ranking`
--

DROP TABLE IF EXISTS Articulos_ranking;
CREATE TABLE Articulos_ranking (
  id_articulo int(6) NOT NULL default '0',
  id_anyo int(6) NOT NULL default '0',
  unidades decimal(10,2) default NULL,
  importe decimal(20,2) default NULL,
  ranking_euros decimal(4,0) default NULL,
  ranking_uds decimal(4,0) NOT NULL,
  PRIMARY KEY  (id_anyo,id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Articulos_recursos`
--

DROP TABLE IF EXISTS Articulos_recursos;
CREATE TABLE Articulos_recursos (
  id_articulo int(6) NOT NULL default '0',
  id_recurso int(4) NOT NULL default '0',
  id_empresa int(2) NOT NULL default '0',
  descripcion mediumtext character set latin1,
  PRIMARY KEY  (id_articulo,id_recurso,id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Ayuda`
--

DROP TABLE IF EXISTS Ayuda;
CREATE TABLE Ayuda (
  id_sub int(4) NOT NULL default '0',
  antetitulo varchar(100) character set latin1 NOT NULL default '',
  titulo varchar(125) character set latin1 default NULL,
  nombre varchar(200) character set latin1 default NULL,
  cuerpo mediumtext character set latin1,
  activo tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_sub)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Ayuda_epigrafes`
--

DROP TABLE IF EXISTS Ayuda_epigrafes;
CREATE TABLE Ayuda_epigrafes (
  id_epigrafe int(6) NOT NULL auto_increment,
  id_sub int(4) NOT NULL default '0',
  id_imagen int(6) default NULL,
  titulo varchar(125) character set latin1 default NULL,
  cuerpo mediumtext character set latin1,
  activo tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_epigrafe)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Bajas_almacen`
--

DROP TABLE IF EXISTS Bajas_almacen;
CREATE TABLE Bajas_almacen (
  id_baja_almacen int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_baja_almacen)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Bajas_localizacion`
--

DROP TABLE IF EXISTS Bajas_localizacion;
CREATE TABLE Bajas_localizacion (
  id_baja_localizacion int(6) NOT NULL auto_increment,
  id_baja_almacen int(5) NOT NULL default '0',
  lote varchar(50) character set latin1 NOT NULL default '',
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(4) NOT NULL default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  fecha_caducidad date NOT NULL default '0000-00-00',
  id_albaran int(6) default NULL,
  id_detalle int(7) default NULL,
  cantidad decimal(8,3) default NULL,
  descripcion mediumtext character set latin1,
  fecha_baja datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_baja int(4) NOT NULL default '0',
  PRIMARY KEY  (id_baja_localizacion),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB AUTO_INCREMENT=93699 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Bancos`
--

DROP TABLE IF EXISTS Bancos;
CREATE TABLE Bancos (
  id_banco int(3) NOT NULL auto_increment,
  id_empresa int(3) NOT NULL default '1',
  nombre varchar(200) character set latin1 NOT NULL default '',
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default '0000',
  dc_ccc int(2) unsigned zerofill NOT NULL default '00',
  oficina int(4) unsigned zerofill default '0000',
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  cargo_contacto varchar(100) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  telefono varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  direccion varchar(255) character set latin1 default NULL,
  poblacion varchar(125) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  cuenta_contable double default NULL,
  PRIMARY KEY  (id_banco)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Bancos_devoluciones`
--

DROP TABLE IF EXISTS Bancos_devoluciones;
CREATE TABLE Bancos_devoluciones (
  id_devolucion int(4) NOT NULL auto_increment,
  id_banco int(3) NOT NULL default '0',
  monto_inicial decimal(10,3) NOT NULL default '0.000',
  monto_final decimal(10,3) default NULL,
  comision decimal(5,3) NOT NULL default '0.000',
  importe decimal(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (id_devolucion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Catalogo_imagenes`
--

DROP TABLE IF EXISTS Catalogo_imagenes;
CREATE TABLE Catalogo_imagenes (
  id_imagen int(4) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(150) character set latin1 default NULL,
  autor varchar(75) character set latin1 default NULL,
  copyright varchar(75) character set latin1 default NULL,
  fecha_toma date default NULL,
  lugar_toma varchar(50) character set latin1 default NULL,
  palabras_clave varchar(200) character set latin1 default NULL,
  ruta varchar(50) character set latin1 default NULL,
  en_portada tinyint(4) default NULL,
  PRIMARY KEY  (id_imagen)
) ENGINE=InnoDB AUTO_INCREMENT=623 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Certificados`
--

DROP TABLE IF EXISTS Certificados;
CREATE TABLE Certificados (
  id_certificado int(4) NOT NULL auto_increment,
  nombre varchar(255) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  responsable varchar(150) character set latin1 default NULL,
  PRIMARY KEY  (id_certificado)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cierres_caja`
--

DROP TABLE IF EXISTS Cierres_caja;
CREATE TABLE Cierres_caja (
  id_tpv int(5) NOT NULL default '0',
  id_cierre int(11) NOT NULL auto_increment,
  fecha_inicial datetime default NULL,
  fecha_fin datetime default NULL,
  monto_caja decimal(10,3) NOT NULL default '0.000',
  monto_apertura decimal(10,2) NOT NULL default '0.00',
  descuadre decimal(10,3) NOT NULL default '0.000',
  id_usr int(4) NOT NULL default '0',
  id_gestor int(4) NOT NULL default '0',
  PRIMARY KEY  (id_cierre)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cierres_forma_pago_TPV`
--

DROP TABLE IF EXISTS Cierres_forma_pago_TPV;
CREATE TABLE Cierres_forma_pago_TPV (
  id_cierre int(11) NOT NULL default '0',
  id_forma_pago_tpv int(11) NOT NULL default '0',
  monto_caja decimal(10,3) NOT NULL default '0.000',
  monto_estimado decimal(10,3) NOT NULL default '0.000',
  monto_descuadre decimal(10,3) NOT NULL default '0.000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Citas`
--

DROP TABLE IF EXISTS Citas;
CREATE TABLE Citas (
  id_cita int(7) NOT NULL auto_increment,
  id_recorrido int(5) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_medio_cto int(2) NOT NULL default '0',
  id_pedido int(6) default NULL,
  h_inicio time default NULL,
  h_fin_sys time default NULL,
  h_fin_ag time default NULL,
  visitado tinyint(1) NOT NULL default '0',
  observaciones mediumtext character set latin1,
  prox_fecha date default NULL,
  prox_id_medio_cto int(2) default NULL,
  prox_comentario mediumtext character set latin1,
  PRIMARY KEY  (id_cita)
) ENGINE=InnoDB AUTO_INCREMENT=1140267 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Citas_Incidencias_CRM`
--

DROP TABLE IF EXISTS Citas_Incidencias_CRM;
CREATE TABLE Citas_Incidencias_CRM (
  id_cita int(6) NOT NULL default '0',
  id_incidencia int(11) NOT NULL default '0',
  PRIMARY KEY  (id_cita,id_incidencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cliente_articulos`
--

DROP TABLE IF EXISTS Cliente_articulos;
CREATE TABLE Cliente_articulos (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  descuento decimal(4,2) default NULL,
  monto decimal(10,3) default NULL,
  PRIMARY KEY  (id_articulo,id_cliente,id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cliente_contactos`
--

DROP TABLE IF EXISTS Cliente_contactos;
CREATE TABLE Cliente_contactos (
  id_contacto int(7) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(2) NOT NULL default '1',
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(175) character set latin1 default NULL,
  cargo varchar(100) character set latin1 default NULL,
  email varchar(175) character set latin1 default NULL,
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  observaciones mediumtext character set latin1,
  PRIMARY KEY  (id_contacto)
) ENGINE=InnoDB AUTO_INCREMENT=597 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cliente_enlaces`
--

DROP TABLE IF EXISTS Cliente_enlaces;
CREATE TABLE Cliente_enlaces (
  id_enlace int(7) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(2) NOT NULL default '0',
  nombre varchar(125) character set latin1 NOT NULL default '',
  url varchar(200) character set latin1 default NULL,
  descripcion mediumtext character set latin1,
  PRIMARY KEY  (id_enlace)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cliente_familia_articulos`
--

DROP TABLE IF EXISTS Cliente_familia_articulos;
CREATE TABLE Cliente_familia_articulos (
  id_empresa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_familia int(6) NOT NULL default '0',
  descuento decimal(4,2) default NULL,
  PRIMARY KEY  (id_cliente,id_empresa,id_familia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cliente_notas`
--

DROP TABLE IF EXISTS Cliente_notas;
CREATE TABLE Cliente_notas (
  id_nota_cliente int(7) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(2) NOT NULL default '0',
  id_tipo_anotacion int(2) NOT NULL default '0',
  nombre varchar(125) character set latin1 NOT NULL default '',
  fecha timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  nota mediumtext character set latin1,
  id_coordinador int(4) default NULL,
  id_operador int(4) default NULL,
  id_agente int(4) default NULL,
  PRIMARY KEY  (id_nota_cliente)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS Clientes;
CREATE TABLE Clientes (
  id_cliente int(6) NOT NULL auto_increment,
  id_divisa int(2) NOT NULL default '0',
  id_provincia int(6) NOT NULL default '0',
  poblacion varchar(200) character set latin1 default NULL,
  cif varchar(12) character set latin1 NOT NULL default '',
  prefijo_cif char(3) character set latin1 default NULL,
  direccion_facturacion varchar(255) character set latin1 NOT NULL default '',
  cp varchar(10) character set latin1 default NULL,
  razon_social varchar(255) character set latin1 NOT NULL default '',
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(200) character set latin1 NOT NULL default '',
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  web varchar(255) character set latin1 default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  cargo_persona_contacto varchar(100) character set latin1 default NULL,
  PRIMARY KEY  (id_cliente)
) ENGINE=InnoDB AUTO_INCREMENT=2376 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Clientes_empresas`
--

DROP TABLE IF EXISTS Clientes_empresas;
CREATE TABLE Clientes_empresas (
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  id_usr int(11) default NULL,
  crm_id_usuario int(4) default NULL,
  id_tarifa int(6) NOT NULL default '0',
  id_forma_pago int(6) NOT NULL default '0',
  id_tipo_cliente int(6) NOT NULL default '0',
  id_recomendador int(6) default '0',
  id_importancia int(3) default NULL,
  cargo_persona_contacto varchar(100) character set latin1 default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default '0000',
  dc_ccc int(2) unsigned zerofill NOT NULL default '00',
  oficina int(4) unsigned zerofill default '0000',
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  riesgo decimal(10,2) default NULL,
  cc_banco double default NULL,
  cc_cliente double default NULL,
  cc_ventas double default NULL,
  cc_descuento_financiero double default NULL,
  cc_descuento_comercial double default NULL,
  cc_gastos double default NULL,
  cc_retenciones double default NULL,
  cc_efectos double default NULL,
  fecha_alta date default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  fecha_baja date default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  observaciones varchar(255) character set latin1 default NULL,
  mostrar_ofertas tinyint(1) default '0',
  aplicar_dto_vol tinyint(1) NOT NULL default '0',
  dto_directo decimal(4,2) default NULL,
  dto_pronto_pago decimal(4,2) default NULL,
  activo tinyint(1) NOT NULL default '0',
  referencias_propias tinyint(1) NOT NULL default '0',
  aplicar_retencion tinyint(1) NOT NULL default '0',
  plazo_demora int(3) default '1',
  dia_facturacion_1 int(2) default '0',
  dia_facturacion_2 int(2) default '0',
  dia_facturacion_3 int(2) default NULL,
  monto_cuenta decimal(9,2) NOT NULL default '0.00',
  monto_cuenta_efectos decimal(9,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_cliente,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Clientes_ranking`
--

DROP TABLE IF EXISTS Clientes_ranking;
CREATE TABLE Clientes_ranking (
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  ventas2011 decimal(8,2) NOT NULL,
  clase2011 varchar(1) character set utf8 collate utf8_spanish_ci NOT NULL,
  ventas2012 decimal(8,2) NOT NULL,
  clase2012 varchar(1) character set utf8 collate utf8_spanish_ci NOT NULL,
  ventas2013 decimal(8,2) NOT NULL,
  clase2013 varchar(1) character set utf8 collate utf8_spanish_ci NOT NULL,
  potencial_ventas varchar(1) character set utf8 collate utf8_spanish_ci NOT NULL,
  tipo_cliente varchar(22) character set utf8 collate utf8_spanish_ci NOT NULL,
  categoria_clase varchar(20) character set utf8 collate utf8_spanish_ci NOT NULL,
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id_cliente,id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Clientes_recursos`
--

DROP TABLE IF EXISTS Clientes_recursos;
CREATE TABLE Clientes_recursos (
  id_cliente_recurso int(7) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(2) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  id_recurso int(4) NOT NULL default '0',
  id_pedido int(6) NOT NULL default '0',
  id_estado_servicio int(2) NOT NULL default '0',
  notas mediumtext character set latin1,
  fecha_inicio date NOT NULL default '0000-00-00',
  fecha_fin date default NULL,
  PRIMARY KEY  (id_cliente_recurso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Competencia`
--

DROP TABLE IF EXISTS Competencia;
CREATE TABLE Competencia (
  id_competencia int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  razon_social varchar(255) character set latin1 NOT NULL default '',
  observaciones varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_competencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos`
--

DROP TABLE IF EXISTS Compra_articulos;
CREATE TABLE Compra_articulos (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos20110628`
--

DROP TABLE IF EXISTS Compra_articulos20110628;
CREATE TABLE Compra_articulos20110628 (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos_20120617`
--

DROP TABLE IF EXISTS Compra_articulos_20120617;
CREATE TABLE Compra_articulos_20120617 (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos_20130312`
--

DROP TABLE IF EXISTS Compra_articulos_20130312;
CREATE TABLE Compra_articulos_20130312 (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos_20130314`
--

DROP TABLE IF EXISTS Compra_articulos_20130314;
CREATE TABLE Compra_articulos_20130314 (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos_bkp`
--

DROP TABLE IF EXISTS Compra_articulos_bkp;
CREATE TABLE Compra_articulos_bkp (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Compra_articulos_prov9`
--

DROP TABLE IF EXISTS Compra_articulos_prov9;
CREATE TABLE Compra_articulos_prov9 (
  id_articulo int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  precio decimal(20,10) default '0.0000000000',
  PV_oficial decimal(20,10) default NULL,
  PVP_oficial decimal(20,10) default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  descuento decimal(4,2) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) default NULL,
  pto_vida_compra decimal(4,2) default NULL,
  servicios_duracion_precio int(4) default NULL,
  cuota_alta decimal(10,3) default NULL,
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  id_servicio int(4) default NULL,
  fabricante tinyint(1) default '0',
  preferente tinyint(1) NOT NULL default '0',
  fecha_baja datetime default NULL,
  PRIMARY KEY  (id_articulo,id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Coordinadores`
--

DROP TABLE IF EXISTS Coordinadores;
CREATE TABLE Coordinadores (
  id_coordinador int(4) NOT NULL auto_increment,
  id_usr int(5) default NULL,
  crm_id_empleado int(5) default NULL,
  id_empresa int(11) NOT NULL default '0',
  nombre varchar(100) character set latin1 default NULL,
  apellidos varchar(255) character set latin1 default NULL,
  dni varchar(20) character set latin1 default NULL,
  email varchar(255) character set latin1 default NULL,
  direccion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_coordinador)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Cuarentenas`
--

DROP TABLE IF EXISTS Cuarentenas;
CREATE TABLE Cuarentenas (
  id_cuarentena int(6) NOT NULL auto_increment,
  id_tipo_cuarentena int(5) NOT NULL default '0',
  crm_id_incidencia int(6) default NULL,
  lote varchar(50) character set latin1 NOT NULL default '',
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(4) NOT NULL default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  fecha_caducidad date NOT NULL default '0000-00-00',
  id_albaran int(6) default NULL,
  id_detalle int(7) default NULL,
  cantidad decimal(8,3) default NULL,
  cantidad_alta decimal(8,3) default NULL,
  cantidad_baja decimal(8,3) default NULL,
  descripcion_apertura mediumtext character set latin1,
  descripcion_cierre mediumtext character set latin1,
  fecha_apertura datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_apertura int(4) NOT NULL default '0',
  fecha_cierre datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_cierre int(4) NOT NULL default '0',
  PRIMARY KEY  (id_cuarentena),
  KEY DiaApertura (id_dia_apertura),
  KEY DiaCierre (id_dia_cierre)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Descuento_familia`
--

DROP TABLE IF EXISTS Descuento_familia;
CREATE TABLE Descuento_familia (
  id_familia int(4) NOT NULL default '0',
  id_empresa int(4) NOT NULL default '0',
  descuento decimal(4,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_familia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Descuentos`
--

DROP TABLE IF EXISTS Descuentos;
CREATE TABLE Descuentos (
  id_descuento int(7) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_pedido int(5) NOT NULL default '0',
  id_presupuesto int(6) default NULL,
  monto_base decimal(20,10) NOT NULL default '0.0000000000',
  nombre varchar(5) character set latin1 NOT NULL default '',
  financiero int(1) NOT NULL default '0',
  porcentaje decimal(4,2) NOT NULL default '0.00',
  monto_final decimal(20,10) NOT NULL default '0.0000000000',
  orden int(2) NOT NULL default '0',
  PRIMARY KEY  (id_descuento)
) ENGINE=InnoDB AUTO_INCREMENT=350387 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Detalles_albaran`
--

DROP TABLE IF EXISTS Detalles_albaran;
CREATE TABLE Detalles_albaran (
  id_detalle int(6) NOT NULL default '0',
  id_albaran int(6) NOT NULL default '0',
  lote varchar(75) character set latin1 NOT NULL default '',
  id_almacen_logico int(6) NOT NULL default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  fecha_caducidad date NOT NULL default '0000-00-00',
  cantidad decimal(8,3) NOT NULL default '0.000',
  stock_previsto decimal(8,3) default '0.000',
  fecha_devolucion datetime default NULL,
  cantidad_devuelta decimal(8,3) NOT NULL default '0.000',
  observaciones longtext character set latin1,
  estado tinyint(2) NOT NULL default '0',
  PRIMARY KEY  (id_detalle,id_albaran,fecha_caducidad,id_almacen_logico,planta,pasillo,fila,columna,lote),
  KEY LOCALIZACION (id_almacen_logico,planta,pasillo,fila,columna),
  KEY RELACIONES (id_albaran,id_detalle),
  KEY LDetalle (id_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Dias`
--

DROP TABLE IF EXISTS Dias;
CREATE TABLE Dias (
  id_dia int(4) NOT NULL auto_increment,
  id_mes int(3) NOT NULL default '0',
  id_semana int(3) NOT NULL default '0',
  fecha date NOT NULL default '0000-00-00',
  num_dia_semana int(1) NOT NULL default '1',
  nombre varchar(75) character set latin1 default NULL,
  PRIMARY KEY  (id_dia)
) ENGINE=InnoDB AUTO_INCREMENT=4727 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Direcciones_entrega`
--

DROP TABLE IF EXISTS Direcciones_entrega;
CREATE TABLE Direcciones_entrega (
  id_direccion int(6) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  id_transportista int(4) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  id_provincia int(6) NOT NULL default '0',
  email varchar(100) character set latin1 default NULL,
  telefono1 varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  cargo_persona_contacto varchar(100) character set latin1 default NULL,
  observaciones varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_direccion)
) ENGINE=InnoDB AUTO_INCREMENT=2080 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Divisa`
--

DROP TABLE IF EXISTS Divisa;
CREATE TABLE Divisa (
  id_divisa int(2) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  leyenda varchar(25) character set latin1 NOT NULL default '',
  ratio decimal(8,6) NOT NULL default '0.000000',
  PRIMARY KEY  (id_divisa)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos`
--

DROP TABLE IF EXISTS Efectos;
CREATE TABLE Efectos (
  id_efecto int(6) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  concepto varchar(125) character set latin1 NOT NULL default '',
  fecha_vencimiento date default NULL,
  id_dia_vencimiento int(4) NOT NULL default '0',
  fecha_abono date default NULL,
  id_dia_abono int(4) NOT NULL default '0',
  fecha_devolucion date default NULL,
  id_dia_devolucion int(4) NOT NULL default '0',
  monto decimal(10,2) NOT NULL default '0.00',
  pago_cobro tinyint(1) NOT NULL default '0',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  emitido tinyint(1) NOT NULL default '0',
  devuelto tinyint(1) NOT NULL default '0',
  pagado tinyint(1) NOT NULL default '0',
  monto_pagado decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto),
  KEY DiaVto (id_dia_vencimiento),
  KEY DiaAbono (id_dia_abono),
  KEY DiaDevol (id_dia_devolucion)
) ENGINE=InnoDB AUTO_INCREMENT=180134 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos20120110_cierre`
--

DROP TABLE IF EXISTS Efectos20120110_cierre;
CREATE TABLE Efectos20120110_cierre (
  id_efecto int(6) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  concepto varchar(125) character set latin1 NOT NULL default '',
  fecha_vencimiento date default NULL,
  id_dia_vencimiento int(4) NOT NULL default '0',
  fecha_abono date default NULL,
  id_dia_abono int(4) NOT NULL default '0',
  fecha_devolucion date default NULL,
  id_dia_devolucion int(4) NOT NULL default '0',
  monto decimal(10,2) NOT NULL default '0.00',
  pago_cobro tinyint(1) NOT NULL default '0',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  emitido tinyint(1) NOT NULL default '0',
  devuelto tinyint(1) NOT NULL default '0',
  pagado tinyint(1) NOT NULL default '0',
  monto_pagado decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto),
  KEY DiaVto (id_dia_vencimiento),
  KEY DiaAbono (id_dia_abono),
  KEY DiaDevol (id_dia_devolucion)
) ENGINE=InnoDB AUTO_INCREMENT=140546 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos20120130_cierre`
--

DROP TABLE IF EXISTS Efectos20120130_cierre;
CREATE TABLE Efectos20120130_cierre (
  id_efecto int(6) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  concepto varchar(125) character set latin1 NOT NULL default '',
  fecha_vencimiento date default NULL,
  id_dia_vencimiento int(4) NOT NULL default '0',
  fecha_abono date default NULL,
  id_dia_abono int(4) NOT NULL default '0',
  fecha_devolucion date default NULL,
  id_dia_devolucion int(4) NOT NULL default '0',
  monto decimal(10,2) NOT NULL default '0.00',
  pago_cobro tinyint(1) NOT NULL default '0',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  emitido tinyint(1) NOT NULL default '0',
  devuelto tinyint(1) NOT NULL default '0',
  pagado tinyint(1) NOT NULL default '0',
  monto_pagado decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto),
  KEY DiaVto (id_dia_vencimiento),
  KEY DiaAbono (id_dia_abono),
  KEY DiaDevol (id_dia_devolucion)
) ENGINE=InnoDB AUTO_INCREMENT=141912 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos_20121231`
--

DROP TABLE IF EXISTS Efectos_20121231;
CREATE TABLE Efectos_20121231 (
  id_efecto int(6) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  concepto varchar(125) character set latin1 NOT NULL default '',
  fecha_vencimiento date default NULL,
  id_dia_vencimiento int(4) NOT NULL default '0',
  fecha_abono date default NULL,
  id_dia_abono int(4) NOT NULL default '0',
  fecha_devolucion date default NULL,
  id_dia_devolucion int(4) NOT NULL default '0',
  monto decimal(10,2) NOT NULL default '0.00',
  pago_cobro tinyint(1) NOT NULL default '0',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  emitido tinyint(1) NOT NULL default '0',
  devuelto tinyint(1) NOT NULL default '0',
  pagado tinyint(1) NOT NULL default '0',
  monto_pagado decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto),
  KEY DiaVto (id_dia_vencimiento),
  KEY DiaAbono (id_dia_abono),
  KEY DiaDevol (id_dia_devolucion)
) ENGINE=InnoDB AUTO_INCREMENT=161096 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos_asientos`
--

DROP TABLE IF EXISTS Efectos_asientos;
CREATE TABLE Efectos_asientos (
  id_efecto int(6) NOT NULL default '0',
  id_asiento int(7) NOT NULL default '0',
  fecha date NOT NULL default '0000-00-00',
  operacion enum('reconocimiento','cargo','eliminacion') character set latin1 NOT NULL default 'reconocimiento',
  importe decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto,id_asiento)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos_parciales`
--

DROP TABLE IF EXISTS Efectos_parciales;
CREATE TABLE Efectos_parciales (
  id_efecto_parcial int(7) NOT NULL auto_increment,
  id_efecto int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  id_cita int(5) default NULL,
  id_factura_abono int(6) default NULL,
  fecha date NOT NULL default '0000-00-00',
  id_dia int(4) NOT NULL default '0',
  monto_satisfecho decimal(10,2) NOT NULL default '0.00',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  notas mediumtext character set latin1 NOT NULL,
  PRIMARY KEY  (id_efecto_parcial),
  KEY DiaEff (id_dia)
) ENGINE=InnoDB AUTO_INCREMENT=4626 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Efectos_prevision`
--

DROP TABLE IF EXISTS Efectos_prevision;
CREATE TABLE Efectos_prevision (
  id_efecto int(6) NOT NULL auto_increment,
  id_factura int(6) NOT NULL default '0',
  id_banco int(3) NOT NULL default '0',
  concepto varchar(125) character set latin1 NOT NULL default '',
  fecha_vencimiento date default NULL,
  id_dia_vencimiento int(4) NOT NULL default '0',
  fecha_abono date default NULL,
  id_dia_abono int(4) NOT NULL default '0',
  fecha_devolucion date default NULL,
  id_dia_devolucion int(4) NOT NULL default '0',
  monto decimal(10,2) NOT NULL default '0.00',
  pago_cobro tinyint(1) NOT NULL default '0',
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  emitido tinyint(1) NOT NULL default '0',
  devuelto tinyint(1) NOT NULL default '0',
  pagado tinyint(1) NOT NULL default '0',
  monto_pagado decimal(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (id_efecto),
  KEY DiaVto (id_dia_vencimiento),
  KEY DiaAbono (id_dia_abono),
  KEY DiaDevol (id_dia_devolucion)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresarios`
--

DROP TABLE IF EXISTS Empresarios;
CREATE TABLE Empresarios (
  id_empresario int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_usr int(6) default NULL,
  crm_id_empleado int(5) default NULL,
  cif varchar(12) character set latin1 default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(200) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  id_provincia int(6) NOT NULL default '0',
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  email varchar(75) character set latin1 default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default NULL,
  dc_ccc int(2) unsigned zerofill default NULL,
  oficina int(4) unsigned zerofill default NULL,
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  observaciones mediumtext character set latin1,
  PRIMARY KEY  (id_empresario),
  UNIQUE KEY id_empresario (id_empresario)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas`
--

DROP TABLE IF EXISTS Empresas;
CREATE TABLE Empresas (
  id_empresa int(6) NOT NULL auto_increment,
  id_grupo_empresa int(3) NOT NULL default '0',
  id_provincia int(6) NOT NULL default '0',
  id_divisa int(2) default '0',
  mask int(10) NOT NULL default '4',
  cif varchar(10) character set latin1 NOT NULL default '',
  prefijo_cif char(1) character set latin1 NOT NULL default '',
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(150) character set latin1 default NULL,
  razon_social varchar(255) character set latin1 NOT NULL default '',
  capital_social bigint(9) NOT NULL default '0',
  inscripcion_registro varchar(255) character set latin1 NOT NULL default '',
  direccion_facturacion varchar(255) character set latin1 NOT NULL default '',
  cp varchar(10) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  web varchar(255) character set latin1 default NULL,
  poblacion varchar(100) character set latin1 default NULL,
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  retencion decimal(4,2) default '0.00',
  dto_gnrl_vol_bulto decimal(4,2) default NULL,
  dto_gnrl_vol_bulto_uds int(3) default NULL,
  dto_gnrl_vol_capa decimal(4,2) default NULL,
  dto_gnrl_vol_capa_uds int(3) default NULL,
  dto_gnrl_vol_palet decimal(4,2) default NULL,
  dto_gnrl_vol_palet_uds int(3) default NULL,
  prefijo_fact_compras varchar(11) character set latin1 default 'FC-',
  sufijo_fact_compras varchar(11) character set latin1 default NULL,
  digitos_fact_compras int(3) NOT NULL default '5',
  prefijo_fact_ventas varchar(11) character set latin1 default 'F',
  sufijo_fact_ventas varchar(11) character set latin1 default NULL,
  digitos_fact_ventas int(3) NOT NULL default '5',
  prefijo_ped_ventas varchar(11) character set latin1 default 'P',
  sufijo_ped_ventas varchar(11) character set latin1 default NULL,
  contador_ped_ventas bigint(10) NOT NULL default '0',
  digitos_ped_ventas int(3) NOT NULL default '5',
  prefijo_alb_ventas varchar(11) character set latin1 default 'A',
  sufijo_alb_ventas varchar(11) character set latin1 default NULL,
  contador_alb_ventas bigint(10) NOT NULL default '0',
  digitos_alb_ventas int(3) NOT NULL default '5',
  prefijo_pre_ventas varchar(11) character set latin1 default 'Ps',
  sufijo_pre_ventas varchar(11) character set latin1 default NULL,
  contador_pre_ventas bigint(10) NOT NULL default '0',
  digitos_pre_ventas int(3) NOT NULL default '5',
  prefijo_pre_compras varchar(11) character set latin1 NOT NULL default 'PrC',
  sufijo_pre_compras varchar(11) character set latin1 default NULL,
  contador_pre_compras bigint(10) NOT NULL default '0',
  digitos_pre_compras int(2) NOT NULL default '4',
  prefijo_alb_compras varchar(11) character set latin1 NOT NULL default 'AC',
  sufijo_alb_compras varchar(11) character set latin1 default NULL,
  contador_alb_compras bigint(10) NOT NULL default '0',
  digitos_alb_compras int(2) NOT NULL default '4',
  prefijo_ped_compras varchar(11) character set latin1 NOT NULL default 'PC',
  sufijo_ped_compras varchar(11) character set latin1 default NULL,
  contador_ped_compras bigint(10) NOT NULL default '0',
  digitos_ped_compras int(2) NOT NULL default '4',
  prefijo_pro_ventas varchar(11) character set latin1 default 'FPV',
  sufijo_pro_ventas varchar(11) character set latin1 default NULL,
  digitos_pro_ventas int(2) NOT NULL default '5',
  contador_pro_ventas bigint(10) NOT NULL default '0',
  prefijo_pro_compras varchar(11) character set latin1 default 'FPC',
  sufijo_pro_compras varchar(11) character set latin1 default NULL,
  digitos_pro_compras int(2) NOT NULL default '4',
  contador_pro_compras bigint(10) NOT NULL default '0',
  contador_ticket bigint(10) default NULL,
  digitos_ticket int(2) default NULL,
  id_imagen int(6) default NULL,
  stock_negativo tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_empresa)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos`
--

DROP TABLE IF EXISTS Empresas_articulos;
CREATE TABLE Empresas_articulos (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos_20120617`
--

DROP TABLE IF EXISTS Empresas_articulos_20120617;
CREATE TABLE Empresas_articulos_20120617 (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos_20120625`
--

DROP TABLE IF EXISTS Empresas_articulos_20120625;
CREATE TABLE Empresas_articulos_20120625 (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos_20130312`
--

DROP TABLE IF EXISTS Empresas_articulos_20130312;
CREATE TABLE Empresas_articulos_20130312 (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos_20130314`
--

DROP TABLE IF EXISTS Empresas_articulos_20130314;
CREATE TABLE Empresas_articulos_20130314 (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_articulos_20130317`
--

DROP TABLE IF EXISTS Empresas_articulos_20130317;
CREATE TABLE Empresas_articulos_20130317 (
  id_articulo int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  referencia varchar(50) collate latin1_spanish_ci NOT NULL,
  stock tinyint(1) NOT NULL default '0',
  stock_ficticio double default NULL,
  stock_minimo int(9) default NULL,
  stock_maximo int(9) default NULL,
  precio_costo decimal(20,10) default '0.0000000000',
  precio_standard decimal(20,10) default '0.0000000000',
  precio_venta decimal(20,10) default NULL,
  precio_4 decimal(20,10) default NULL,
  precio_5 decimal(20,10) default NULL,
  precio_6 decimal(20,10) default NULL,
  precio_20110227 decimal(4,2) NOT NULL,
  servicios_duracion_precio int(4) default NULL,
  dto_vol decimal(4,2) default NULL,
  dto_vol_bultos int(3) NOT NULL default '0',
  descripcion longtext collate latin1_spanish_ci,
  fecha_alta datetime default NULL,
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  ultima_modificacion timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  unidades_bulto decimal(8,3) NOT NULL default '1.000',
  capas_palet int(4) default '0',
  bultos_capa_palet int(4) default '0',
  pto_vida_venta decimal(5,2) default NULL,
  pto_vida_compra decimal(5,2) default NULL,
  fabricacion_propia tinyint(1) NOT NULL default '0',
  frecuente tinyint(1) NOT NULL default '0',
  wwwactivo tinyint(1) NOT NULL default '0',
  wwwhome tinyint(1) NOT NULL default '0',
  wwwportada tinyint(1) NOT NULL default '0',
  wwwdestacado tinyint(1) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '2',
  planta int(4) NOT NULL,
  pasillo int(4) NOT NULL,
  fila int(4) NOT NULL,
  columna int(4) NOT NULL,
  PRIMARY KEY  (id_articulo,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Empresas_servicios`
--

DROP TABLE IF EXISTS Empresas_servicios;
CREATE TABLE Empresas_servicios (
  id_empresa int(11) NOT NULL default '0',
  id_articulo int(11) NOT NULL default '0',
  id_servicio int(11) NOT NULL default '0',
  cuota_alta decimal(10,3) NOT NULL default '0.000',
  servicios_poradelantado tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_empresa,id_articulo,id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Estados_servicio`
--

DROP TABLE IF EXISTS Estados_servicio;
CREATE TABLE Estados_servicio (
  id_estado_servicio int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  PRIMARY KEY  (id_estado_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas`
--

DROP TABLE IF EXISTS Facturas;
CREATE TABLE Facturas (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=190097 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347`
--

DROP TABLE IF EXISTS Facturas_347;
CREATE TABLE Facturas_347 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=176277 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20120401`
--

DROP TABLE IF EXISTS Facturas_347_20120401;
CREATE TABLE Facturas_347_20120401 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=160744 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20120927`
--

DROP TABLE IF EXISTS Facturas_347_20120927;
CREATE TABLE Facturas_347_20120927 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=165616 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20120928`
--

DROP TABLE IF EXISTS Facturas_347_20120928;
CREATE TABLE Facturas_347_20120928 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=165742 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20121012`
--

DROP TABLE IF EXISTS Facturas_347_20121012;
CREATE TABLE Facturas_347_20121012 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=166672 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20121013`
--

DROP TABLE IF EXISTS Facturas_347_20121013;
CREATE TABLE Facturas_347_20121013 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=166689 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20121231`
--

DROP TABLE IF EXISTS Facturas_347_20121231;
CREATE TABLE Facturas_347_20121231 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=170921 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_20130125`
--

DROP TABLE IF EXISTS Facturas_347_20130125;
CREATE TABLE Facturas_347_20130125 (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=172349 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_347_old`
--

DROP TABLE IF EXISTS Facturas_347_old;
CREATE TABLE Facturas_347_old (
  id_factura int(6) NOT NULL auto_increment,
  id_forma_pago int(6) NOT NULL default '0',
  id_tarifa int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_serie int(6) default NULL,
  id_divisa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_agente int(4) NOT NULL default '0',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_prepago decimal(10,2) NOT NULL default '0.00',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  descuento decimal(10,2) NOT NULL default '0.00',
  base_imponible decimal(10,2) NOT NULL default '0.00',
  total_impuestos decimal(10,2) NOT NULL default '0.00',
  retenido decimal(10,2) NOT NULL default '0.00',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  total_bruto decimal(20,10) NOT NULL default '0.0000000000',
  notas varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  fecha_emision datetime default NULL,
  id_dia_emision datetime default NULL,
  estado tinyint(2) NOT NULL default '0',
  factura_abono tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) NOT NULL default '0.0000',
  contabilizado tinyint(1) NOT NULL default '0',
  id_asiento int(7) default NULL,
  PRIMARY KEY  (id_factura),
  KEY DiaFra (id_dia),
  KEY DiaEmision (id_dia_emision)
) ENGINE=InnoDB AUTO_INCREMENT=155168 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_Incidencias_CRM`
--

DROP TABLE IF EXISTS Facturas_Incidencias_CRM;
CREATE TABLE Facturas_Incidencias_CRM (
  id_factura int(6) NOT NULL default '0',
  id_incidencia int(11) NOT NULL default '0',
  PRIMARY KEY  (id_factura,id_incidencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_abonos`
--

DROP TABLE IF EXISTS Facturas_abonos;
CREATE TABLE Facturas_abonos (
  id_factura int(6) NOT NULL default '0',
  id_factura_abono int(6) NOT NULL default '0',
  PRIMARY KEY  (id_factura,id_factura_abono)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Facturas_detalle`
--

DROP TABLE IF EXISTS Facturas_detalle;
CREATE TABLE Facturas_detalle (
  id_factura int(11) NOT NULL default '0',
  id_detalle int(11) NOT NULL default '0',
  cantidad decimal(20,10) NOT NULL default '0.0000000000',
  importe decimal(20,10) NOT NULL default '0.0000000000',
  notas mediumtext character set latin1,
  iextra1 varchar(200) character set latin1 default NULL,
  iextra2 varchar(200) character set latin1 default NULL,
  iextra3 varchar(200) character set latin1 default NULL,
  iextra4 varchar(200) character set latin1 default NULL,
  PRIMARY KEY  (id_factura,id_detalle),
  KEY LDetalle (id_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Familia_articulos`
--

DROP TABLE IF EXISTS Familia_articulos;
CREATE TABLE Familia_articulos (
  id_familia int(6) NOT NULL auto_increment,
  id_grupo_familia int(4) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  stock tinyint(1) NOT NULL default '1',
  materia_prima tinyint(1) default '0',
  PRIMARY KEY  (id_familia)
) ENGINE=InnoDB AUTO_INCREMENT=403 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Familia_subfamilias`
--

DROP TABLE IF EXISTS Familia_subfamilias;
CREATE TABLE Familia_subfamilias (
  id_subfamilia int(6) NOT NULL auto_increment,
  id_familia int(4) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  stock tinyint(1) NOT NULL default '1',
  materia_prima tinyint(1) default '0',
  PRIMARY KEY  (id_subfamilia)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Forma_pago`
--

DROP TABLE IF EXISTS Forma_pago;
CREATE TABLE Forma_pago (
  id_forma_pago int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  num_efectos int(2) default NULL,
  dias_efectos int(4) default NULL,
  medio_pago enum('efectivo','cheque','transferencia','pagare','recibo','visa') character set latin1 NOT NULL default 'efectivo',
  PRIMARY KEY  (id_forma_pago)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Forma_pago_TPV`
--

DROP TABLE IF EXISTS Forma_pago_TPV;
CREATE TABLE Forma_pago_TPV (
  id_forma_pago_tpv int(11) NOT NULL auto_increment,
  nombre varchar(15) character set latin1 NOT NULL default '',
  cobro_aplazado tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_forma_pago_tpv)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Forma_pago_TPV_tickets`
--

DROP TABLE IF EXISTS Forma_pago_TPV_tickets;
CREATE TABLE Forma_pago_TPV_tickets (
  id_forma_pago int(11) NOT NULL default '0',
  id_ticket int(11) NOT NULL default '0',
  monto decimal(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (id_forma_pago,id_ticket)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Gastos`
--

DROP TABLE IF EXISTS Gastos;
CREATE TABLE Gastos (
  id_gasto int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1,
  PRIMARY KEY  (id_gasto)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Grupo_empresas`
--

DROP TABLE IF EXISTS Grupo_empresas;
CREATE TABLE Grupo_empresas (
  id_grupo_empresa int(3) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  id_usr int(4) NOT NULL default '0',
  PRIMARY KEY  (id_grupo_empresa)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Grupo_familias`
--

DROP TABLE IF EXISTS Grupo_familias;
CREATE TABLE Grupo_familias (
  id_grupo_familia int(4) NOT NULL auto_increment,
  nombre varchar(100) character set latin1 default NULL,
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_grupo_familia)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Grupo_rutas`
--

DROP TABLE IF EXISTS Grupo_rutas;
CREATE TABLE Grupo_rutas (
  id_grupo_ruta int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_grupo_ruta)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `IVAs`
--

DROP TABLE IF EXISTS IVAs;
CREATE TABLE IVAs (
  id_factura int(6) NOT NULL default '0',
  id_iva int(6) NOT NULL default '0',
  id_pedido int(5) NOT NULL default '0',
  id_presupuesto int(6) NOT NULL default '0',
  bruto decimal(20,10) NOT NULL default '0.0000000000',
  monto decimal(20,10) NOT NULL default '0.0000000000',
  recargo_iva decimal(20,10) NOT NULL default '0.0000000000',
  recargo_equivalente decimal(20,10) default NULL,
  PRIMARY KEY  (id_iva,id_factura,id_pedido,id_presupuesto),
  KEY Pedido (id_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Importancias`
--

DROP TABLE IF EXISTS Importancias;
CREATE TABLE Importancias (
  id_importancia int(3) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1,
  nivel int(2) NOT NULL default '0',
  PRIMARY KEY  (id_importancia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Inventario_stock`
--

DROP TABLE IF EXISTS Inventario_stock;
CREATE TABLE Inventario_stock (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Inventario_stock_20071231`
--

DROP TABLE IF EXISTS Inventario_stock_20071231;
CREATE TABLE Inventario_stock_20071231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Cierre_2007';

--
-- Table structure for table `Inventario_stock_20081231`
--

DROP TABLE IF EXISTS Inventario_stock_20081231;
CREATE TABLE Inventario_stock_20081231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Inventario_stock_20091231`
--

DROP TABLE IF EXISTS Inventario_stock_20091231;
CREATE TABLE Inventario_stock_20091231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Lineas_detalle`
--

DROP TABLE IF EXISTS Lineas_detalle;
CREATE TABLE Lineas_detalle (
  id_pedido int(6) NOT NULL default '0',
  id_albaran int(6) default '-1',
  id_detalle int(10) NOT NULL auto_increment,
  id_articulo int(6) NOT NULL default '0',
  id_servicio int(11) NOT NULL default '0',
  id_presupuesto int(6) default NULL,
  cantidad decimal(20,10) NOT NULL default '0.0000000000',
  precio_articulo decimal(20,10) NOT NULL default '0.0000000000',
  monto_total decimal(20,10) NOT NULL default '0.0000000000',
  descuento decimal(4,2) NOT NULL default '0.00',
  monto decimal(20,10) default '0.0000000000',
  observaciones varchar(255) character set latin1 default NULL,
  cantidad_recibida decimal(7,2) NOT NULL default '0.00',
  id_movimiento decimal(10,0) default NULL,
  oextra1 varchar(200) character set latin1 default NULL,
  oextra2 varchar(200) character set latin1 default NULL,
  oextra3 varchar(200) character set latin1 default NULL,
  oextra4 varchar(200) character set latin1 default NULL,
  PRIMARY KEY  (id_detalle),
  KEY Pedido (id_pedido),
  KEY Producto (id_articulo),
  KEY PedidoProducto (id_pedido,id_articulo),
  KEY Presupuesto (id_presupuesto)
) ENGINE=InnoDB AUTO_INCREMENT=4157124 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos`
--

DROP TABLE IF EXISTS Localizacion_articulos;
CREATE TABLE Localizacion_articulos (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20080304`
--

DROP TABLE IF EXISTS Localizacion_articulos_20080304;
CREATE TABLE Localizacion_articulos_20080304 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20081231`
--

DROP TABLE IF EXISTS Localizacion_articulos_20081231;
CREATE TABLE Localizacion_articulos_20081231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='cierre_2008';

--
-- Table structure for table `Localizacion_articulos_20091231`
--

DROP TABLE IF EXISTS Localizacion_articulos_20091231;
CREATE TABLE Localizacion_articulos_20091231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20100404`
--

DROP TABLE IF EXISTS Localizacion_articulos_20100404;
CREATE TABLE Localizacion_articulos_20100404 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20101231`
--

DROP TABLE IF EXISTS Localizacion_articulos_20101231;
CREATE TABLE Localizacion_articulos_20101231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20110731`
--

DROP TABLE IF EXISTS Localizacion_articulos_20110731;
CREATE TABLE Localizacion_articulos_20110731 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20121231`
--

DROP TABLE IF EXISTS Localizacion_articulos_20121231;
CREATE TABLE Localizacion_articulos_20121231 (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_20130102_okCierre`
--

DROP TABLE IF EXISTS Localizacion_articulos_20130102_okCierre;
CREATE TABLE Localizacion_articulos_20130102_okCierre (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_sc_alb`
--

DROP TABLE IF EXISTS Localizacion_articulos_sc_alb;
CREATE TABLE Localizacion_articulos_sc_alb (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_sc_fat`
--

DROP TABLE IF EXISTS Localizacion_articulos_sc_fat;
CREATE TABLE Localizacion_articulos_sc_fat (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Localizacion_articulos_sc_light`
--

DROP TABLE IF EXISTS Localizacion_articulos_sc_light;
CREATE TABLE Localizacion_articulos_sc_light (
  id_almacen_logico int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  lote_propio tinyint(1) default '0',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  fecha_baja datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Marcas`
--

DROP TABLE IF EXISTS Marcas;
CREATE TABLE Marcas (
  id_marca int(6) NOT NULL auto_increment,
  id_imagen int(6) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  observaciones varchar(255) character set latin1 default NULL,
  wwwactivo tinyint(1) NOT NULL default '0',
  novender tinyint(1) NOT NULL default '0',
  nacional tinyint(1) NOT NULL default '0',
  compra_directa tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_marca)
) ENGINE=InnoDB AUTO_INCREMENT=330 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Medios_contacto`
--

DROP TABLE IF EXISTS Medios_contacto;
CREATE TABLE Medios_contacto (
  id_medio_cto int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1,
  PRIMARY KEY  (id_medio_cto)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Meses`
--

DROP TABLE IF EXISTS Meses;
CREATE TABLE Meses (
  id_mes int(3) NOT NULL auto_increment,
  id_anyo int(2) NOT NULL default '0',
  num int(2) NOT NULL default '0',
  nombre varchar(125) character set latin1 NOT NULL default '',
  f_ini date NOT NULL default '0000-00-00',
  f_fin date NOT NULL default '0000-00-00',
  n_dias int(2) NOT NULL default '0',
  PRIMARY KEY  (id_mes)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Mozos_almacen`
--

DROP TABLE IF EXISTS Mozos_almacen;
CREATE TABLE Mozos_almacen (
  id_mozo int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_almacen int(6) NOT NULL default '0',
  id_usr int(6) default NULL,
  crm_id_empleado int(5) default NULL,
  notificar_stock tinyint(1) NOT NULL default '0',
  cif varchar(12) character set latin1 default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(200) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  id_provincia int(6) NOT NULL default '0',
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  email varchar(75) character set latin1 default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default NULL,
  dc_ccc int(2) unsigned zerofill default NULL,
  oficina int(4) unsigned zerofill default NULL,
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  observaciones mediumtext character set latin1,
  PRIMARY KEY  (id_mozo),
  UNIQUE KEY id_mozo (id_mozo)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Notificaciones`
--

DROP TABLE IF EXISTS Notificaciones;
CREATE TABLE Notificaciones (
  id_notificacion int(5) NOT NULL auto_increment,
  de varchar(125) character set latin1 NOT NULL default '',
  para varchar(125) character set latin1 NOT NULL default '',
  tema varchar(255) character set latin1 default NULL,
  fecha datetime NOT NULL default '0000-00-00 00:00:00',
  tipo_mime varchar(125) character set latin1 NOT NULL default '',
  body longblob,
  estado int(2) NOT NULL default '0',
  PRIMARY KEY  (id_notificacion)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Operadores`
--

DROP TABLE IF EXISTS Operadores;
CREATE TABLE Operadores (
  id_operador int(4) NOT NULL auto_increment,
  id_usr int(5) default NULL,
  crm_id_empleado int(5) default NULL,
  id_empresa int(2) NOT NULL default '0',
  nombre varchar(100) character set latin1 default NULL,
  apellidos varchar(255) character set latin1 default NULL,
  dni varchar(20) character set latin1 default NULL,
  email varchar(255) character set latin1 default NULL,
  direccion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_operador)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Ordenes_fabricacion`
--

DROP TABLE IF EXISTS Ordenes_fabricacion;
CREATE TABLE Ordenes_fabricacion (
  lote varchar(8) character set latin1 NOT NULL default '',
  id_proveedor int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  fecha_caducidad datetime default NULL,
  estado tinyint(1) default '0',
  observaciones varchar(255) character set latin1 default NULL,
  incidencias varchar(255) character set latin1 default NULL,
  fecha datetime default '0000-00-00 00:00:00',
  estimacion_dias int(4) default NULL,
  cantidad decimal(8,3) default NULL,
  PRIMARY KEY  (lote)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Paises`
--

DROP TABLE IF EXISTS Paises;
CREATE TABLE Paises (
  id_pais int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  codigo int(11) NOT NULL default '0',
  continente varchar(100) character set latin1 default NULL,
  prefijo_tlf int(3) default NULL,
  prefijo_cif char(3) character set latin1 default NULL,
  PRIMARY KEY  (id_pais)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Pedidos`
--

DROP TABLE IF EXISTS Pedidos;
CREATE TABLE Pedidos (
  id_pedido int(8) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '1',
  id_agente int(6) NOT NULL default '0',
  id_direccion int(6) NOT NULL default '0',
  id_almacen int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  id_presupuesto int(6) default NULL,
  id_tarifa int(4) NOT NULL default '0',
  id_divisa int(4) NOT NULL default '0',
  id_forma_pago int(4) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  monto_cuenta decimal(10,2) NOT NULL default '0.00',
  observaciones varchar(255) character set latin1 default NULL,
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  preparado tinyint(1) NOT NULL default '0',
  ratio_divisa decimal(10,4) default '0.0000',
  id_pedido_incompleto int(11) default NULL,
  residual tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_pedido),
  KEY DEntrega (id_direccion),
  KEY Proveedor (id_proveedor),
  KEY EmpresaPedido (id_empresa,id_pedido),
  KEY Ref (referencia),
  KEY RefExt (referencia_externa),
  KEY DiaPed (id_dia)
) ENGINE=InnoDB AUTO_INCREMENT=322816 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Pedidos_Incidencias_CRM`
--

DROP TABLE IF EXISTS Pedidos_Incidencias_CRM;
CREATE TABLE Pedidos_Incidencias_CRM (
  id_pedido int(6) NOT NULL default '0',
  id_incidencia int(11) NOT NULL default '0',
  PRIMARY KEY  (id_pedido,id_incidencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Pedidos_facturas`
--

DROP TABLE IF EXISTS Pedidos_facturas;
CREATE TABLE Pedidos_facturas (
  id_pedido int(11) NOT NULL default '0',
  id_factura int(11) NOT NULL default '0',
  PRIMARY KEY  (id_pedido,id_factura)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Pedidos_tipo_cliente`
--

DROP TABLE IF EXISTS Pedidos_tipo_cliente;
CREATE TABLE Pedidos_tipo_cliente (
  id_pedido int(6) NOT NULL default '1',
  id_empresa int(6) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  PRIMARY KEY  (id_pedido,id_cliente,id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Pedidos_tipo_proveedor`
--

DROP TABLE IF EXISTS Pedidos_tipo_proveedor;
CREATE TABLE Pedidos_tipo_proveedor (
  id_empresa int(6) NOT NULL default '1',
  id_pedido int(6) NOT NULL default '0',
  id_proveedor int(6) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  PRIMARY KEY  (id_proveedor,id_pedido,id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Presupuestos`
--

DROP TABLE IF EXISTS Presupuestos;
CREATE TABLE Presupuestos (
  id_presupuesto int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_cliente int(6) default '0',
  id_divisa int(2) default NULL,
  id_agente int(4) default '0',
  id_proveedor int(4) default '0',
  id_rfq int(6) default NULL,
  id_tarifa int(4) default NULL,
  id_forma_pago int(6) NOT NULL default '0',
  nombre varchar(75) character set latin1 default NULL,
  referencia varchar(50) character set latin1 NOT NULL default '',
  referencia_externa varchar(50) character set latin1 NOT NULL default '',
  fecha datetime default NULL,
  id_dia int(4) NOT NULL default '0',
  bruto decimal(20,10) default NULL,
  descuentos decimal(20,10) default NULL,
  base_imponible decimal(20,10) default NULL,
  impuestos decimal(20,10) default NULL,
  retenciones decimal(20,10) default NULL,
  importe decimal(20,10) default NULL,
  observaciones varchar(255) character set latin1 default NULL,
  estado tinyint(1) NOT NULL default '0',
  factura_proforma tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_presupuesto),
  KEY DiaPre (id_dia)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Presupuestos_Documentos_CRM`
--

DROP TABLE IF EXISTS Presupuestos_Documentos_CRM;
CREATE TABLE Presupuestos_Documentos_CRM (
  id_presupuesto int(6) NOT NULL default '0',
  id_documento int(4) NOT NULL default '0',
  nota mediumtext character set latin1,
  PRIMARY KEY  (id_presupuesto,id_documento)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Promociones`
--

DROP TABLE IF EXISTS Promociones;
CREATE TABLE Promociones (
  id_promocion int(6) NOT NULL auto_increment,
  id_empresa int(6) NOT NULL default '0',
  id_articulo int(6) NOT NULL default '0',
  nombre varchar(75) character set latin1 NOT NULL default '',
  fecha_inicio datetime default NULL,
  id_dia_inicio int(4) NOT NULL default '0',
  fecha_fin datetime default NULL,
  id_dia_fin int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  monto decimal(10,2) NOT NULL default '0.00',
  descuento decimal(4,2) default NULL,
  oferta tinyint(1) default '0',
  wwwactivo tinyint(4) default '0',
  wwwportada tinyint(4) default '0',
  PRIMARY KEY  (id_promocion),
  KEY DiaIni (id_dia_inicio),
  KEY DiaFin (id_dia_fin)
) ENGINE=InnoDB AUTO_INCREMENT=3698 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Promociones_articulos`
--

DROP TABLE IF EXISTS Promociones_articulos;
CREATE TABLE Promociones_articulos (
  id_articulo int(6) NOT NULL default '0',
  id_promocion int(6) NOT NULL default '0',
  cantidad decimal(20,8) NOT NULL default '0.00000000',
  PRIMARY KEY  (id_articulo,id_promocion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Proveedores`
--

DROP TABLE IF EXISTS Proveedores;
CREATE TABLE Proveedores (
  id_proveedor int(6) NOT NULL auto_increment,
  id_divisa int(2) default '0',
  id_provincia int(6) NOT NULL default '1',
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(150) character set latin1 default NULL,
  razon_social varchar(255) character set latin1 NOT NULL default '',
  prefijo_cif char(2) character set latin1 NOT NULL default '',
  cif varchar(12) character set latin1 NOT NULL default '',
  domicilio varchar(200) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  web varchar(255) character set latin1 default NULL,
  persona_contacto varchar(255) character set latin1 default NULL,
  cargo_persona_contacto varchar(100) character set latin1 default NULL,
  telefono1 varchar(15) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  fecha_alta datetime default NULL,
  retencion decimal(4,2) default NULL,
  dto_gnrl_vol_bulto decimal(4,2) default NULL,
  dto_gnrl_vol_bulto_uds int(3) default NULL,
  dto_gnrl_vol_capa decimal(4,2) default NULL,
  dto_gnrl_vol_capa_uds int(3) default NULL,
  dto_gnrl_vol_palet decimal(4,2) default NULL,
  dto_gnrl_vol_palet_uds int(3) default NULL,
  PRIMARY KEY  (id_proveedor)
) ENGINE=InnoDB AUTO_INCREMENT=547 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Proveedores_empresas`
--

DROP TABLE IF EXISTS Proveedores_empresas;
CREATE TABLE Proveedores_empresas (
  id_proveedor int(6) NOT NULL default '0',
  id_empresa int(6) NOT NULL default '1',
  id_usr int(11) default NULL,
  crm_id_usuario int(4) default NULL,
  id_forma_pago int(6) NOT NULL default '0',
  id_divisa int(6) NOT NULL default '0',
  cc_banco double default NULL,
  cc_proveedor double default NULL,
  cc_gastos double default NULL,
  cc_compras double default NULL,
  cc_descuento_financiero double default NULL,
  cc_descuento_comercial double default NULL,
  cc_retenciones double default NULL,
  cc_efectos double default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default '0000',
  dc_ccc int(2) unsigned zerofill NOT NULL default '00',
  oficina int(4) unsigned zerofill default '0000',
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  observaciones varchar(255) character set latin1 default NULL,
  descuento decimal(4,2) default NULL,
  descuento_financiero decimal(4,2) default '0.00',
  aplicar_retencion tinyint(1) NOT NULL default '0',
  comunitario tinyint(1) NOT NULL default '0',
  aplicar_iva tinyint(1) NOT NULL default '1',
  aplicar_recargo tinyint(1) NOT NULL default '0',
  plazo_demora int(3) NOT NULL default '0',
  dia_facturacion_1 int(2) default NULL,
  dia_facturacion_2 int(2) default NULL,
  dia_facturacion_3 int(2) default NULL,
  monto_cuenta decimal(9,2) NOT NULL default '0.00',
  monto_cuenta_efectos decimal(9,2) NOT NULL default '0.00',
  activo tinyint(1) NOT NULL default '0',
  fecha_alta datetime NOT NULL default '0000-00-00 00:00:00',
  id_dia_alta int(4) NOT NULL default '0',
  fecha_baja datetime default NULL,
  id_dia_baja int(4) NOT NULL default '0',
  mantener_ratio_divisa int(3) default NULL,
  PRIMARY KEY  (id_proveedor,id_empresa),
  KEY DiaAlta (id_dia_alta),
  KEY DiaBaja (id_dia_baja)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Provincias`
--

DROP TABLE IF EXISTS Provincias;
CREATE TABLE Provincias (
  id_provincia int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  id_pais int(6) NOT NULL default '1',
  codigo varchar(10) character set latin1 default NULL,
  prefijo_tlf int(3) default NULL,
  PRIMARY KEY  (id_provincia)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Rappel`
--

DROP TABLE IF EXISTS Rappel;
CREATE TABLE Rappel (
  id_empresa int(6) NOT NULL default '0',
  id_rappel int(6) NOT NULL auto_increment,
  id_cliente int(6) NOT NULL default '0',
  monto_inicial double NOT NULL default '0',
  monto_final double NOT NULL default '0',
  porcentaje decimal(4,2) NOT NULL default '0.00',
  periodo int(5) default NULL,
  rapp tinyint(1) NOT NULL default '0',
  fecha_inicial date default NULL,
  monto_acumulado decimal(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (id_rappel)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Recorridos`
--

DROP TABLE IF EXISTS Recorridos;
CREATE TABLE Recorridos (
  id_recorrido int(5) NOT NULL auto_increment,
  id_ruta int(3) NOT NULL default '0',
  id_agente int(6) NOT NULL default '0',
  id_medio_cto int(2) NOT NULL default '0',
  fecha date NOT NULL default '0000-00-00',
  id_dia int(4) NOT NULL default '0',
  h_inicio time default NULL,
  h_fin time default NULL,
  observaciones mediumtext character set latin1 NOT NULL,
  prox_fecha date default NULL,
  PRIMARY KEY  (id_recorrido),
  KEY DiaRec (id_dia)
) ENGINE=InnoDB AUTO_INCREMENT=16627 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Recorridos_gastos`
--

DROP TABLE IF EXISTS Recorridos_gastos;
CREATE TABLE Recorridos_gastos (
  id_recorrido int(5) NOT NULL default '0',
  id_gasto int(2) NOT NULL default '0',
  importe float(10,2) NOT NULL default '0.00',
  comentario mediumtext character set latin1,
  PRIMARY KEY  (id_recorrido,id_gasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Recursos`
--

DROP TABLE IF EXISTS Recursos;
CREATE TABLE Recursos (
  id_recurso int(4) NOT NULL auto_increment,
  id_tipo_recurso int(2) NOT NULL default '0',
  nombre varchar(175) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1,
  extra mediumtext character set latin1,
  PRIMARY KEY  (id_recurso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Relaciones`
--

DROP TABLE IF EXISTS Relaciones;
CREATE TABLE Relaciones (
  id_relacion int(5) NOT NULL auto_increment,
  tabla_origen varchar(50) character set latin1 default NULL,
  campo_origen varchar(50) character set latin1 default NULL,
  tabla_destino varchar(50) character set latin1 default NULL,
  campo_destino varchar(50) character set latin1 default NULL,
  tipo char(3) character set latin1 default NULL,
  PRIMARY KEY  (id_relacion)
) ENGINE=InnoDB AUTO_INCREMENT=27227 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Rutas`
--

DROP TABLE IF EXISTS Rutas;
CREATE TABLE Rutas (
  id_ruta int(3) NOT NULL auto_increment,
  id_grupo_ruta int(2) NOT NULL default '0',
  id_agente int(6) NOT NULL default '0',
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1,
  h_duracion int(2) NOT NULL default '0',
  m_visita int(2) NOT NULL default '0',
  m_traslado int(2) NOT NULL default '0',
  d_frecuencia int(2) NOT NULL default '0',
  PRIMARY KEY  (id_ruta)
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Rutas_clientes`
--

DROP TABLE IF EXISTS Rutas_clientes;
CREATE TABLE Rutas_clientes (
  id_ruta int(3) NOT NULL default '0',
  id_cliente int(6) NOT NULL default '0',
  id_medio_cto int(2) NOT NULL default '0',
  orden int(2) NOT NULL default '0',
  PRIMARY KEY  (id_ruta,id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Semanas`
--

DROP TABLE IF EXISTS Semanas;
CREATE TABLE Semanas (
  id_semana int(3) NOT NULL auto_increment,
  id_trimestre int(2) NOT NULL default '0',
  numero int(2) NOT NULL default '0',
  nombre varchar(125) character set latin1 default NULL,
  f_ini date NOT NULL default '0000-00-00',
  f_fin date NOT NULL default '0000-00-00',
  n_dias int(2) NOT NULL default '0',
  num_semana_trimestre int(2) NOT NULL default '0',
  PRIMARY KEY  (id_semana)
) ENGINE=InnoDB AUTO_INCREMENT=679 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Series_facturacion`
--

DROP TABLE IF EXISTS Series_facturacion;
CREATE TABLE Series_facturacion (
  id_serie int(6) NOT NULL auto_increment,
  id_empresa int(4) NOT NULL default '1',
  id_serie_abonar int(6) default NULL,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  contador int(11) NOT NULL default '0',
  ventas tinyint(1) NOT NULL default '1',
  contabilizable tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (id_serie)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Servicios`
--

DROP TABLE IF EXISTS Servicios;
CREATE TABLE Servicios (
  id_servicio int(4) NOT NULL auto_increment,
  nombre varchar(255) character set latin1 NOT NULL default '',
  duracion int(11) NOT NULL default '1',
  plazo_factura int(6) NOT NULL default '1',
  PRIMARY KEY  (id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tarifas`
--

DROP TABLE IF EXISTS Tarifas;
CREATE TABLE Tarifas (
  id_tarifa int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  pto_primero decimal(6,4) NOT NULL default '0.0000',
  pto_segundo decimal(6,4) NOT NULL default '0.0000',
  monto int(10) NOT NULL default '0',
  campo_accion varchar(50) character set latin1 NOT NULL default '',
  campo_recomendacion varchar(20) character set latin1 NOT NULL default '',
  pto_recomendacion decimal(4,2) default NULL,
  coniva_recomendacion tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_tarifa)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tarifas_transporte`
--

DROP TABLE IF EXISTS Tarifas_transporte;
CREATE TABLE Tarifas_transporte (
  id_tarifa_transporte int(4) NOT NULL auto_increment,
  id_transportista int(4) default NULL,
  nombre varchar(100) character set latin1 default NULL,
  peso_inicial decimal(8,3) default NULL,
  peso_final decimal(8,3) default NULL,
  costo decimal(10,3) default NULL,
  costo_unidad tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_tarifa_transporte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS Tickets;
CREATE TABLE Tickets (
  id_ticket int(11) NOT NULL auto_increment,
  id_usr int(11) NOT NULL default '0',
  fecha datetime default NULL,
  id_cliente int(11) NOT NULL default '0',
  total decimal(10,3) NOT NULL default '0.000',
  total_impuestos decimal(10,3) NOT NULL default '0.000',
  total_gastos float(10,3) NOT NULL default '0.000',
  total_descuentos decimal(10,3) NOT NULL default '0.000',
  base_imponible decimal(10,3) NOT NULL default '0.000',
  id_factura int(11) NOT NULL default '0',
  id_empresa int(11) NOT NULL default '0',
  referencia varchar(25) character set latin1 default NULL,
  PRIMARY KEY  (id_ticket)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tickets_detalle`
--

DROP TABLE IF EXISTS Tickets_detalle;
CREATE TABLE Tickets_detalle (
  id_detalle int(10) NOT NULL default '0',
  id_ticket int(10) NOT NULL default '0',
  PRIMARY KEY  (id_detalle,id_ticket)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipo_agente`
--

DROP TABLE IF EXISTS Tipo_agente;
CREATE TABLE Tipo_agente (
  id_tipo_agente int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_tipo_agente)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipo_cliente`
--

DROP TABLE IF EXISTS Tipo_cliente;
CREATE TABLE Tipo_cliente (
  id_tipo_cliente int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  aplicar_recargo tinyint(1) NOT NULL default '0',
  aplicar_iva tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id_tipo_cliente)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_Alta_stock`
--

DROP TABLE IF EXISTS Tipos_Alta_stock;
CREATE TABLE Tipos_Alta_stock (
  id_tipo_alta int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_tipo_alta)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_Cuarentena`
--

DROP TABLE IF EXISTS Tipos_Cuarentena;
CREATE TABLE Tipos_Cuarentena (
  id_tipo_cuarentena int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  descripcion varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_tipo_cuarentena)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_IVA`
--

DROP TABLE IF EXISTS Tipos_IVA;
CREATE TABLE Tipos_IVA (
  id_iva int(6) NOT NULL auto_increment,
  nombre varchar(75) character set latin1 NOT NULL default '',
  porcentaje decimal(4,2) NOT NULL default '0.00',
  recargo_equivalente decimal(9,2) NOT NULL default '0.00',
  cc_imp_soportado double default NULL,
  cc_imp_repercutido double default NULL,
  cc_re_soportado double default NULL,
  cc_re_repercutido double default NULL,
  cc_ce_repercutido double default NULL,
  cc_ce_soportado double default NULL,
  PRIMARY KEY  (id_iva)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_UnidadMedida`
--

DROP TABLE IF EXISTS Tipos_UnidadMedida;
CREATE TABLE Tipos_UnidadMedida (
  id_tipo_unidadmedida int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  otro_peso_cubicaje tinyint(1) NOT NULL default '0',
  user_defined tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (id_tipo_unidadmedida)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_anotacion`
--

DROP TABLE IF EXISTS Tipos_anotacion;
CREATE TABLE Tipos_anotacion (
  id_tipo_anotacion int(2) NOT NULL auto_increment,
  nombre varchar(175) character set latin1 NOT NULL default '',
  PRIMARY KEY  (id_tipo_anotacion)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tipos_recurso`
--

DROP TABLE IF EXISTS Tipos_recurso;
CREATE TABLE Tipos_recurso (
  id_tipo_recurso int(2) NOT NULL auto_increment,
  nombre varchar(125) character set latin1 NOT NULL default '',
  descripcion mediumtext character set latin1 NOT NULL,
  PRIMARY KEY  (id_tipo_recurso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Tpv`
--

DROP TABLE IF EXISTS Tpv;
CREATE TABLE Tpv (
  id_tpv int(3) NOT NULL auto_increment,
  id_empresa int(3) NOT NULL default '0',
  nombre varchar(25) character set latin1 default NULL,
  prefijo_ticket varchar(4) character set latin1 default NULL,
  contador_ticket bigint(10) default NULL,
  sufijo_ticket varchar(4) character set latin1 default NULL,
  users_mask int(10) NOT NULL default '0',
  encargados_mask int(10) NOT NULL default '0',
  PRIMARY KEY  (id_tpv)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Transportistas`
--

DROP TABLE IF EXISTS Transportistas;
CREATE TABLE Transportistas (
  id_transportista int(6) NOT NULL auto_increment,
  id_provincia int(6) NOT NULL default '1',
  nombre varchar(75) character set latin1 NOT NULL default '',
  apellidos varchar(125) character set latin1 default NULL,
  razon_social varchar(255) character set latin1 NOT NULL default '',
  cif varchar(12) character set latin1 NOT NULL default '',
  direccion varchar(200) character set latin1 default NULL,
  poblacion varchar(200) character set latin1 default NULL,
  cp varchar(10) character set latin1 default NULL,
  telefono varchar(15) character set latin1 default NULL,
  fax varchar(15) character set latin1 default NULL,
  email varchar(100) character set latin1 default NULL,
  telefono2 varchar(15) character set latin1 default NULL,
  iban varchar(4) character set latin1 default NULL,
  bic varchar(12) character set latin1 default NULL,
  bban varchar(26) character set latin1 default NULL,
  entidad int(4) unsigned zerofill default NULL,
  dc_ccc int(2) unsigned zerofill default NULL,
  oficina int(4) unsigned zerofill default NULL,
  cuenta_bancaria bigint(10) unsigned zerofill default NULL,
  PRIMARY KEY  (id_transportista)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Traspasos_almacen`
--

DROP TABLE IF EXISTS Traspasos_almacen;
CREATE TABLE Traspasos_almacen (
  id_transportista int(6) NOT NULL default '0',
  id_traspaso int(6) NOT NULL auto_increment,
  id_almacen_envio int(6) NOT NULL default '0',
  id_almacen_recepcion int(6) NOT NULL default '0',
  fecha datetime default NULL,
  observaciones varchar(255) character set latin1 default NULL,
  PRIMARY KEY  (id_traspaso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Traspasos_detalle`
--

DROP TABLE IF EXISTS Traspasos_detalle;
CREATE TABLE Traspasos_detalle (
  id_traspaso int(6) NOT NULL default '0',
  id_detalle int(6) NOT NULL default '0',
  PRIMARY KEY  (id_detalle,id_traspaso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Trimestres`
--

DROP TABLE IF EXISTS Trimestres;
CREATE TABLE Trimestres (
  id_trimestre int(2) NOT NULL auto_increment,
  id_anyo int(2) NOT NULL default '0',
  nombre varchar(125) character set latin1 default NULL,
  f_ini date NOT NULL default '0000-00-00',
  f_fin date NOT NULL default '0000-00-00',
  n_semanas int(2) NOT NULL default '0',
  num_trimestre_anyo int(2) NOT NULL default '0',
  PRIMARY KEY  (id_trimestre)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `UnidadesMedida_Escalas`
--

DROP TABLE IF EXISTS UnidadesMedida_Escalas;
CREATE TABLE UnidadesMedida_Escalas (
  id_escala_medida int(5) NOT NULL auto_increment,
  id_unidad_medida int(4) NOT NULL default '0',
  nombre varchar(125) character set latin1 NOT NULL default '',
  leyenda varchar(6) character set latin1 NOT NULL default '',
  alias_list varchar(70) character set latin1 default NULL,
  factor_conversion decimal(20,8) NOT NULL default '1.00000000',
  PRIMARY KEY  (id_escala_medida)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `Unidades_medida`
--

DROP TABLE IF EXISTS Unidades_medida;
CREATE TABLE Unidades_medida (
  id_unidad_medida int(4) NOT NULL auto_increment,
  id_tipo_unidadmedida int(2) NOT NULL default '0',
  nombre varchar(100) character set latin1 NOT NULL default '',
  leyenda varchar(10) character set latin1 default NULL,
  user_defined tinyint(1) NOT NULL default '1',
  conversion_descompuesta tinyint(1) NOT NULL default '0',
  num_decimales tinyint(2) NOT NULL default '0',
  PRIMARY KEY  (id_unidad_medida)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `loc_Comprado`
--

DROP TABLE IF EXISTS loc_Comprado;
CREATE TABLE loc_Comprado (
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `loc_Perdido`
--

DROP TABLE IF EXISTS loc_Perdido;
CREATE TABLE loc_Perdido (
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Table structure for table `loc_Vendido`
--

DROP TABLE IF EXISTS loc_Vendido;
CREATE TABLE loc_Vendido (
  id_articulo int(6) NOT NULL default '0',
  id_almacen_logico int(6) NOT NULL default '0',
  lote varchar(8) character set latin1 NOT NULL default '',
  planta int(4) NOT NULL default '0',
  pasillo int(4) NOT NULL default '0',
  fila int(4) NOT NULL default '0',
  columna int(4) NOT NULL default '0',
  cantidad decimal(10,3) NOT NULL default '0.000',
  fecha_caducidad date NOT NULL default '0000-00-00',
  PRIMARY KEY  (id_articulo,id_almacen_logico,fecha_caducidad,lote,planta,pasillo,fila,columna),
  KEY Localizacion (planta,pasillo,columna,fila),
  KEY Caducidad (lote,fecha_caducidad),
  KEY Referencia (id_almacen_logico,id_articulo),
  KEY id_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-09 11:13:42
-- MySQL dump 10.11
--
-- Host: bbdd4.biomundo    Database: biomundo_gestion
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `Ayuda`
--

LOCK TABLES Ayuda WRITE;
/*!40000 ALTER TABLE Ayuda DISABLE KEYS */;
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (2,'Datos Generales de Inmersa Technologies.','Información General de producto.','About us','Referencia de Producto: SFEMGE2002-1000-2000-34<p>\r\n\r\nInmersa Empresa V.2.0.0 es un producto de Inmersa Technologies.\r\nEl servicio de atención al cliente:<p>\r\n<a href=\\\"mailto:mantenimiento@inmersa.com\\\">mantenimiento@inmersa.com</a><p>\r\n\r\nEl servicio comercial:<p>\r\n<a href=\\\"mailto:comercial@inmersa.com\\\">comercial@inmersa.com</a><p>\r\n\r\nInformación General:<p>\r\n<a href=\\\"mailto:info@inmersa.com\\\">info@inmersa.com</a><p>\r\n\r\n©Copyright 2002. Inmersa Technologies. Todos los derechos reservados.\r\n\r\n',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (98,'','Listado de agentes','Listado de Agentes','Listado general de todos los agentes de la empresa activa. Se puede en este listado importar agentes o crear un nuevo agente, así como borrar agentes.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (99,'','Modificar los datos de un agente','Modificar agente','En la ficha de cada agente están los datos principales en los que se elige el tipo de agente al que pertenece dicho agente y se les asignan las caves y las contraseñas adecuadas para que entren en su ROL de usuario específico. Cada agente verá los aspectos relacionados consigo mismo sin tener acceso a otros datos del sistema o de otros agentes.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (101,'','Navegación','Listado de proveedores','-Todas las secciones son “web screens” y se trabaja en ellas como si fuese una sección de una web..<p>\r\n-Los enlaces están marcados en azul y enlazan documentos de negocio<p>\r\n-Las acciones sobre listados requieren de marcar “check box” simple o múltiples y realizar la acción (borrar, enviar, imprimir, Importar,...)\r\n-Toda acción sobre formularios requiere pulsar luego el enlace de acción, situado generalmente al final de cada página. Las acciones se pueden denominar: guardar, modificar, modificar seleccionados, enviar,...<p>\r\n-Todo proceso puede ser rehecho con facilidad por lo que no tenga reservas en hacer pruebas. Simplemente vuelva atrás y cambie lo que desee.<p>\r\n-La tecnología que está usando maneja una ingeniería de negocio potente por lo que los efectos generales de las acciones debe consultarlos en el manual del módulo que esté manejando.<p>\r\n',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (102,'','Modificar configuración de un proveedor','Modificar datos proveedor','Modificación de datos generales presentados en la ficha y desactivar un proveedor como activo. Esto es relevante porque los productos están relacionados con un proveedor para listar precios por artículo y poder elegir la mejor opción. En espacial estos datos afectan a la gestión de la cadena de suministro que toma este datos y loas condiciones de pago y entrega para organizar las compras.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (103,'','Creación de ficha y accesos','Alta de proveedores','En esta sección creamos una nueva ficha de proveedor y le damos las prioridades y los accesos para negocio B2B y acceso a todos sus históricos y datos de la relación e-business.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (104,'','Rapidez de acceso a datos de proveedores','Importar Proveedores','Esta feature es muy relevante cuando se manejan diferentes empresas con proveedores que se desean compartir. Cuando se importan importamos con ellos todas sus características, productos y precios.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (106,'','Listado de datos esenciales de productos de proveedor','Tabla de precios de proveedores','En la tabla de precios de un proveedor veremos sus productos con los datos que son necesarios para conocer el producto: Nuestra referencia, la referencia del proveedor, el nombre, el descuento que nos aplica, el EAN, el precio y si el proveedor es fabricante de dicho producto.\r\nPodemos importar artículos que tengamos de otros proveedores y que el activo os sirva ahora o activar algún artículo que habíamos dado de baja en nuestra para nuestra labor comercial.\r\n',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (107,'','','Clientes de un agente','Un listado de clientes de un agente y los datos de comisiones y totales que cada agente maneja con cada cliente. Desde esta sección tenemos una idea de como un agente está trabajando con un cliente.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (108,'Importar productos inactivos o de otros proveedores','','Importar artículos a proveedor','Permite acceder a nuestra base datos para con una simple selección de artículos vía check box luego pueda insertarse en los registros de cada cliente. Esto permite recuperar productos de la base de datos que habían sido marcados como inactivos o importar productos que nos sirven otros proveedores.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (109,'','Listado de pedidos tipo','Pedidos Tipo de Proveedores','En esta sección podemos guardar pedidos como pedidos tipo o habituales de tal forma que para realizarlos sólo debemos recuperarlos y añadir pequeñas variaciones: Esto facilita mucho el trabajo cuando los pedidos son constantes.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (111,'Histórico de pedidos','Listado de Pedidos de proveedor','Histórico de pedidos de proveedor','Histórico de pedidos con su estado correspondiente, fecha de realización y direcciones de recogida y monto total.  Esta sección vale tanto para los Roles de usuario de la empresa en la que se ve en el listado lo comprado sino para el Proveedor accediendo con su ROL específico que ve la evolución de la relación comercial y puede desde esta plataforma aportar su input. La sección tiene un buscador específico.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (112,'Importar recomendador','Asignar contacto y forma de compensación','Ayuda general-Importar recomendador','Recomendador: esta feature permite crear un sistema par bonificar partner, subcontratistas, avisadores de negocio o terceras partes que nos faciliten facturar cualquier producto o servicio. La acción asignar permite crear el perfil del recomendador. Esto permite tener agentes externos que actúan como avisadores de nuestros servicios o productos y asignarles comisiones o cualquier otro tipo de beneficio teniendo controlado que volumen de negocio nos está produciendo.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (113,'Histórico de facturas de Proveedores','Listado de facturas de proveedores','Ayuda general-Histórico de facturas de Proveedores','Listado de facturas  de compra dentro del cual podremos buscar por estado, nombre de proveedor, referencia y entre fechas. El filtrado de las búsquedas nos permitirá ver como evolucionan las compras a un determinado proveedor.\r\n\r\n',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (114,'Histórico de facturas de Proveedor','Listado de facturas','Ayuda general- Histórico de facturas','El histórico de facturas nos lista todas las facturas con su estado. Desde este listado podemos ver cada una de ellas, el monto y la fecha. Además de ello el buscador permite búsquedas discriminadas por estado de factura (emitida, sin emitir o futuras). El campo referencia externa muestra la referencia del pedido que se hace que es un dato imprescindible en la facturación de las empresas con calidad ISO 9001.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (115,'Lista los almacenes físicos y lógicos','Organización de almacenes','Ayuda general-Listado de almacenes','Los almaenes pueden ser los que se deseen organizados por almacenes físicos y dentro de estos subdivisiones de alamcenes lógicos. ',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (116,'Modificar almacenes','Datos generales de un almacén físico','Ayuda general','En este apartado se pueden modificar todas las características de un almacén físico: datos generales, dar de alta y ver nuevos almacenes lógicos. ver el inventario y el histórico de albaranes de ese almacén.',1);
INSERT INTO Ayuda (id_sub, antetitulo, titulo, nombre, cuerpo, activo) VALUES (117,'Dar de alta un almacén físico','Gestión de almacenes','Ayuda general','Inmersa distingue entre almacenes físicos y almacenes lógicos. Dentro de un almacén físico se pueden tener 1 o más almacenes lógicos. Estos almacenes lógicos son los contenedores de las mercancías y sobre ellos realizamos los inventarios.',1);
/*!40000 ALTER TABLE Ayuda ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-09 11:13:42
-- MySQL dump 10.11
--
-- Host: bbdd4.biomundo    Database: biomundo_gestion
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `Ayuda_epigrafes`
--

LOCK TABLES Ayuda_epigrafes WRITE;
/*!40000 ALTER TABLE Ayuda_epigrafes DISABLE KEYS */;
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (8,117,0,'Control de almacén y ubicación','Cada almacén en inmersa tiene la capacidad de organizar físicamente la mercancia en una estructura matricial (pasillos, pisos, filas y columnas). De esta manera los pedidos de almacén son más fáciles de realizar al señalarnos los pedidos la localización por almacén y producto de cada item del pedido.',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (9,117,0,'Control de Stocks','Dentro de los almacenes lógicos realizamos el control de stock de forma exhaustiva. Los informes que puedes imprmir desde esta sección te dirán en las localizaciones, cantidades y lotes de producto que estás revisando. El control es rápido y exhaustivo.',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (10,115,0,'Inventarios y localizaciones de producto','Dentro de los almacenes físicos y lógicos se puede hacer inventario de almacén y dentro de cada almacén lógico podremos realizar los cambios de localización en nuestro almacén. Necesitaremos dar una organización física a nuestro almacén si queremos hacer uso de esta feature.',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (11,101,0,'Datos generales','Modificación de datos generales presentados en la ficha y desactivar un proveedor como activo. Esto es relevante porque los productos están relacionados con un proveedor para listar precios por artículo y poder elegir la mejor opción. En espacial estos datos afectan a la gestión de la cadena de suministro que toma este datos y loas condiciones de pago y entrega para organizar las compras',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (12,101,0,'Tabla de precios','En la tabla de precios de un proveedor veremos sus productos con los datos que son necesarios para conocer el producto: Nuestra referencia, la referencia del proveedor, el nombre, el descuento que nos aplica, el EAN, el precio y si el proveedor es fabricante de dicho producto.\r\nPodemos importar artículos que tengamos de otros proveedores y que el activo os sirva ahora o activar algún artículo que habíamos dado de baja en nuestra para nuestra labor comercial.\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (13,101,0,'Informe de facturas','El informe de facturas es uno de los informes más útiles para analizar como trabaja un proveedor y hacer un seguimiento de las ventas y de la eficacia de nuestros pedidos.\r\n\r\nEn este informe presentamos por cada artículo la cantidad que hemos pedido en un intervalo de tiempo a un proveedor, la cantidad entregada por este, la cantidad pedida por los clientes y la que se ha entregado a los mismos. Este informe pone de manifiesto de un vistazo como se comportan los proveedores, si fallan en las entregas, o falla la empresa en la previsión de los pedidos.\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (14,101,0,'Pedidos Tipo','En esta sección podemos guardar pedidos como pedidos tipo o habituales de tal forma que para realizarlos sólo debemos recuperarlos y añadir pequeñas variaciones: Esto facilita mucho el trabajo cuando los pedidos son constantes.',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (15,101,0,'Histórico de pedidos','Histórico de pedidos con su estado correspondiente, fecha de realización y direcciones de recogida y monto total. ',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (16,101,0,'Histórico de facturas','El histórico de facturas nos lista todas las facturas con su estado. Desde este listado podemos ver cada una de ellas, el monto y la fecha. Además de ello el buscador permite búsquedas discriminadas por estado de factura (emitida, sin emitir o futuras). El campo referencia externa muestra la referencia del pedido que se hace que es un dato imprescindible en la facturación de las empresas con calidad ISO 9001.\r\n\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (17,102,0,'Tabla de precios','En la tabla de precios de un proveedor veremos sus productos con los datos que son necesarios para conocer el producto: Nuestra referencia, la referencia del proveedor, el nombre, el descuento que nos aplica, el EAN, el precio y si el proveedor es fabricante de dicho producto.\r\nPodemos importar artículos que tengamos de otros proveedores y que el activo os sirva ahora o activar algún artículo que habíamos dado de baja en nuestra para nuestra labor comercial.\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (18,102,0,'Informe de facturas','El informe de facturas es uno de los informes más útiles para analizar como trabaja un proveedor y hacer un seguimiento de las ventas y de la eficacia de nuestros pedidos.\r\n\r\nEn este informe presentamos por cada artículo la cantidad que hemos pedido en un intervalo de tiempo a un proveedor, la cantidad entregada por este, la cantidad pedida por los clientes y la que se ha entregado a los mismos. Este informe pone de manifiesto de un vistazo como se comportan los proveedores, si fallan en las entregas, o falla la empresa en la previsión de los pedidos.\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (19,102,0,'Pedidos tipo','En esta sección podemos guardar pedidos como pedidos tipo o habituales de tal forma que para realizarlos sólo debemos recuperarlos y añadir pequeñas variaciones: Esto facilita mucho el trabajo cuando los pedidos son constantes.',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (20,102,0,'Histórico de pedidos','Histórico de pedidos con su estado correspondiente, fecha de realización y direcciones de recogida y monto total. ',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (21,102,0,'Histórico de facturas','\r\nEl histórico de facturas nos lista todas las facturas con su estado. Desde este listado podemos ver cada una de ellas, el monto y la fecha. Además de ello el buscador permite búsquedas discriminadas por estado de factura (emitida, sin emitir o futuras). El campo referencia externa muestra la referencia del pedido que se hace que es un dato imprescindible en la facturación de las empresas con calidad ISO 9001.\r\n',1);
INSERT INTO Ayuda_epigrafes (id_epigrafe, id_sub, id_imagen, titulo, cuerpo, activo) VALUES (22,99,0,'','',0);
/*!40000 ALTER TABLE Ayuda_epigrafes ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-09 11:13:42
-- MySQL dump 10.11
--
-- Host: bbdd4.biomundo    Database: biomundo_gestion
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `Relaciones`
--

LOCK TABLES Relaciones WRITE;
/*!40000 ALTER TABLE Relaciones DISABLE KEYS */;
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (1,'Agentes','id_tipo_agente','Tipo_agente','id_tipo_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (2,'Agentes','id_agente','Agentes_clientes','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (3,'Agentes','id_agente','Agentes_facturas','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (4,'Agentes','id_agente','Pedidos','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (5,'Agentes','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (6,'Agentes','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (7,'Agentes_clientes','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (8,'Agentes_clientes','id_agente','Agentes','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (9,'Agentes_facturas','id_agente','Agentes','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (10,'Agentes_facturas','id_factura','Facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (11,'Albaranes','id_pedido','Pedidos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (12,'Albaranes','id_almacen','Almacenes','id_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (13,'Albaranes','id_transportista','Transportistas','id_transportista','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (14,'Almacenes','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (15,'Almacenes','id_almacen','Almacenes_logicos','id_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (16,'Almacenes','id_almacen','Albaranes','id_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (17,'Almacenes','id_almacen','Traspasos_almacen','id_almacen_envio','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (18,'Almacenes','id_almacen','Traspasos_almacen','id_almacen_recepcion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (19,'Almacenes','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (20,'Almacenes_logicos','id_almacen','Almacenes','id_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (21,'Almacenes_logicos','id_almacen_logico','Localizacion_articulos','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (22,'Articulos','id_articulo','Compra_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (23,'Articulos','id_articulo','Ordenes_fabricacion','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (24,'Articulos','id_articulo','Localizacion_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (25,'Articulos','id_familia','Familia_articulos','id_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (26,'Articulos','id_articulo','Cliente_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27,'Articulos','id_articulo','Articulos_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (29,'Articulos','id_iva','Tipos_IVA','id_iva','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (30,'Articulos','id_marca','Marcas','id_marca','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (32,'Articulos','id_articulo','Promociones_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (33,'Articulos','id_articulo','Promociones','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (34,'Articulos','id_articulo','Articulos_competencia','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (35,'Articulos','id_color','Color','id_color','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (36,'Articulos','id_articulo','Empresas_articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (38,'Articulos','id_articulo','Lineas_detalle','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (39,'Articulos_articulos','id_materia_prima','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (41,'Articulos_competencia','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (42,'Articulos_competencia','id_competecia','Competencia','id_competencia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (43,'Bajas_almacen','id_baja_almacen','Bajas_localizacion','id_baja_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (44,'Cliente_articulos','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (45,'Cliente_articulos','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (46,'Cliente_articulos','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (47,'Cliente_familia_articulos','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (48,'Cliente_familia_articulos','id_familia','Familia_articulos','id_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (49,'Cliente_familia_articulos','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (51,'Clientes','id_cliente','Direcciones_entrega','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (52,'Clientes','id_cliente','Clientes_empresas','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (53,'Clientes','id_cliente','Presupuestos','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (54,'Clientes','id_cliente','Facturas','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (55,'Clientes','id_cliente','Pedidos_tipo_cliente','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (56,'Clientes','id_cliente','Rappel','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (57,'Clientes','id_cliente','Cliente_articulos','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (58,'Clientes','id_cliente','Cliente_familia_articulos','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (59,'Clientesout','id_cliente','Clientes_empresas','id_recomendador','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (60,'Clientes','id_cliente','Agentes_clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (61,'Clientes_empresas','id_tipo_cliente','Tipo_cliente','id_tipo_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (62,'Clientes_empresas','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (63,'Clientes_empresas','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (64,'Clientes_empresas','id_divisa','Divisa','id_divisa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (65,'Clientes_empresas','id_forma_pago','Forma_pago','id_forma_pago','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (66,'Clientes_empresas','id_tarifa','Tarifas','id_tarifa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (67,'Clientes_empresasout','id_recomendador','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (69,'Competencia','id_competencia','Articulos_competencia','id_competencia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (70,'Compra_articulos','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (71,'Compra_articulos','id_proveedor','Proveedores','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (72,'Descuentos','id_factura','Facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (73,'Direcciones_entrega','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (74,'Direcciones_entrega','id_direccion','Pedidos','id_direccion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (75,'Direcciones_entrega','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (78,'Divisa','id_divisa','Facturas','id_divisa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (79,'Efectos','id_factura','Facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (80,'Empresas','id_empresa','Almacenes','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (81,'Empresas','id_empresa','Clientes_empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (82,'Empresas','id_empresa','Facturas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (83,'Empresas','id_empresa','Cliente_familia_articulos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (84,'Empresas','id_empresa','Cliente_articulos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (86,'Empresas','id_grupo_empresa','Grupo_empresas','id_grupo_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (87,'Empresas','id_empresa','Empresas_articulos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (88,'Empresas','id_empresa','Rappel','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (89,'Empresas','id_empresa','Agentes','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (90,'Empresas','id_empresa','Pedidos_tipo_cliente','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (91,'Empresas','id_empresa','Pedidos_tipo_proveedor','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (92,'Empresas','id_empresa','Proveedores_empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (94,'Empresas','id_empresa','Presupuestos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (95,'Empresas','id_empresa','Pedidos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (96,'Empresas','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (97,'Empresas_articulos','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (98,'Empresas_articulos','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (100,'Facturas','id_factura','Descuentos','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (101,'Facturas','id_factura','IVAs','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (102,'Facturas','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (103,'Facturas','id_proveedor','Proveedores','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (104,'Facturas','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (105,'Facturas','id_divisa','Divisa','id_divisa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (106,'Facturas','id_serie','Series_facturacion','id_serie','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (107,'Facturas','id_tarifa','Tarifas','id_tarifa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (108,'Facturas','id_factura','Efectos','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (109,'Facturas','id_forma_pago','Forma_pago','id_forma_pago','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (110,'Facturas','id_factura','Agentes_facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (111,'Familia_articulos','id_familia','Cliente_familia_articulos','id_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (112,'Familia_articulos','id_familia','Articulos','id_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (113,'Forma_pago','id_forma_pago','Clientes_empresas','id_forma_pago','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (114,'Forma_pago','id_forma_pago','Proveedores_empresas','id_forma_pago','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (115,'Forma_pago','id_forma_pago','Facturas','id_forma_pago','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (116,'Grupo_empresas','id_grupo_empresa','Empresas','id_grupo_empresas','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (117,'IVAs','id_iva','Tipos_IVA','id_iva','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (118,'IVAs','id_factura','Facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (119,'Lineas_detalle','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (120,'Lineas_detalle','id_presupuesto','Presupuestos','id_presupuesto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (121,'Lineas_detalle','id_pedido','Pedidos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (122,'Lineas_detalle','id_detalle','Traspasos_detalle','id_detalle','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (123,'Bajas_localizacion','id_baja_almacen','Bajas_almacen','id_baja_almacen','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (124,'Localizacion_articulos','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (125,'Localizacion_articulos','lote','Ordenes_fabricacion','lote','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (126,'Localizacion_articulos','id_almacen_logico','Almacenes_logicos','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (127,'Marcas','id_marca','Articulos','id_marca','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (128,'Ordenes_fabricacion','lote','Localizacion_articulos','lote','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (129,'Ordenes_fabricacion','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (130,'Paises','id_pais','Provincias','id_pais','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (131,'Pedidos','id_pedido','Pedidos_tipo_cliente','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (132,'Pedidos','id_direccion','Direcciones_entrega','id_direccion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (134,'Pedidos','id_proveedor','Proveedores','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (135,'Pedidos','id_agente','Agentes','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (136,'Pedidos','id_pedido','Albaranes','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (137,'Pedidos','id_pedido','Pedidos_tipo_proveedor','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (138,'Pedidos','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (139,'Pedidos','id_pedido','Lineas_detalle','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (140,'Pedidos_tipo_cliente','id_pedido','Pedidos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (141,'Pedidos_tipo_cliente','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (142,'Pedidos_tipo_cliente','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (143,'Pedidos_tipo_proveedor','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (144,'Pedidos_tipo_proveedor','id_pedido','Pedidos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (145,'Pedidos_tipo_proveedor','id_proveedor','Proveedores','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (146,'Presupuestos','id_presupuesto','Lineas_detalle','id_presupuesto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (147,'Presupuestos','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (148,'Presupuestos','id_empresa','Empresa','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (149,'Promociones','id_promocion','Promociones_articulos','id_promocion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (150,'Promociones','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (151,'Promociones_articulos','id_articulo','Articulos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (152,'Promociones_articulos','id_promocion','Promociones','id_promocion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (153,'Proveedores','id_proveedor','Proveedores_empresas','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (154,'Proveedores','id_proveedor','Facturas','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (155,'Proveedores','id_proveedor','Compra_articulos','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (156,'Proveedores','id_proveedor','Pedidos','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (157,'Proveedores','id_proveedor','Pedidos_tipo_proveedor','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (158,'Proveedores','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (159,'Proveedores_empresas','id_proveedor','Proveedores','id_proveedor','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (160,'Proveedores_empresas','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (161,'Proveedores_empresas','id_divisa','Divisa','id_divisa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (162,'Provincias','id_pais','Paises','id_pais','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (170,'Rappel','id_cliente','Clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (171,'Rappel','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (172,'Series_facturacion','id_serie','Facturas','id_serie','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (174,'Tarifas','id_tarifa','Clientes_empresas','id_tarifa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (175,'Tarifas','id_tarifa','Facturas','id_tarifa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (176,'Tipo_agente','id_tipo_agente','Agentes','id_tipo_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (177,'Tipo_cliente','id_tipo_cliente','Clientes_empresas','id_tipo_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (178,'Tipos_IVA','id_iva','IVAs','id_iva','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (179,'Tipos_IVA','id_iva','Articulos','id_iva','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (180,'Transportistas','id_transportista','Albaranes','id_transportista','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (181,'Transportistas','id_transportista','Traspasos_almacen','id_transportista','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (182,'Transportistas','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (183,'Traspasos_almacen','id_transportista','Transportistas','id_transportista','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (185,'Traspasos_almacen','id_almacen_recepcion','Almacenes_logicos','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (186,'Traspasos_almacen','id_traspaso','Traspasos_detalle','id_traspaso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (187,'Traspasos_detalle','id_traspaso','Traspasos_almacen','id_traspaso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (188,'Traspasos_detalle','id_detalle','Lineas_detalle','id_detalle','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (5000,'Clientes','id_provincia','Provincias','id_provincia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (5001,'Almacenes_logicos','id_almacen_logico','Traspasos_almacen','id_almacen_envio','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27001,'Articulos','id_unidad_medida','Unidades_medida','id_unidad_medida','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27002,'Unidades_medida','id_unidad_medida','Articulos','id_unidad_medida','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27003,'Empresas','id_imagen','Catalogo_imagenes','id_imagen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27004,'Catalogo_imagenes','id_imagen','Empresas','id_imagen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27005,'Ordenes_fabricacion','id_proveedor','Proveedores','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27006,'Ordenes_fabricacion','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27007,'Empresas','id_empresa','Ordenes_fabricacion','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27008,'Proveedores','id_proveedor','Ordenes_fabricacion','id_proveedor','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27009,'Familia_articulos','id_grupo_familia','Grupo_familias','id_grupo_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27010,'Grupo_familias','id_grupo_familia','Familia_articulos','id_grupo_familia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27011,'Transportistas','id_transportista','Tarifas_transporte','id_transportista','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27012,'Tarifas_transporte','id_transportista','Transportistas','id_transportista','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27013,'Certificados','id_certificado','Articulos','id_certificado','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27014,'Articulos','id_certificado','Certificados','id_certificado','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27015,'Descuento_familia','id_familia','Familia_articulos','id_familia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27016,'Descuento_familia','id_empresa','Empresas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27017,'Empresas','id_empresa','Descuento_familia','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27018,'Familia_articulos','id_familia','Descuento_familia','id_familia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27019,'Pedidos','id_tarifa','Tarifas','id_tarifa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27020,'Tarifas','id_tarifa','Pedidos','id_tarifa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27021,'Pedidos','id_pedido','Descuentos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27022,'Pedidos','id_pedido','IVAs','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27023,'IVAs','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27024,'Descuentos','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27025,'Presupuestos','id_agente','Agentes','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27026,'Agentes','id_agente','Presupuestos','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27027,'Detalles_albaran','id_detalle','Lineas_detalle','id_detalle','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27028,'Lineas_detalle','id_detalle','Detalles_albaran','id_detalle','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27029,'Detalles_albaran','id_albaran','Albaranes','id_albaran','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27030,'Albaranes','id_albaran','Detalles_albaran','id_albaran','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27031,'Pedidos','id_divisa','Divisa','id_divisa','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27032,'Catalogo_imagenes','id_imagen','Articulos','id_imagen','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27033,'Articulos','id_imagen','Catalogo_imagenes','id_imagen','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27034,'Compra_articulos','id_articulo','Lineas_detalle','id_articulo','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27035,'Empresas','id_divisa','Divisa','id_divisa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27037,'Almacenes_logicos','id_almacen_logico','Bajas_localizacion','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27038,'Bajas_localizacion','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27039,'Pedidos','id_forma_pago','Forma_pago','id_forma_pago','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27040,'Forma_pago','id_forma_pago','Pedidos','id_forma_pago','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27041,'Empresas','id_divisa','Divisa','id_divisa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27042,'Pedidos','id_pedido','Pedidos_facturas','id_pedido','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27043,'Pedidos_facturas','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27044,'Facturas','id_factura','Pedidos_facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27045,'Pedidos_facturas','id_factura','Facturas','id_factura','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27048,'Empresas_servicios','id_servicio','Servicios','id_servicio','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27049,'Servicios','id_servicio','Empresas_servicios','id_servicio','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27050,'Facturas','id_factura','Facturas_detalle','id_factura',NULL);
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27051,'Facturas_detalle','id_factura','Facturas','id_factura',NULL);
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27052,'Lineas_detalle','id_detalle','Facturas_detalle','id_detalle','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27053,'Facturas_detalle','id_detalle','Lineas_detalle','id_detalle','');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27054,'Lineas_detalle','id_servicio','Servicios','id_servicio','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27055,'Efectos','id_efecto','Efectos_parciales','id_efecto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27056,'Marcas','id_imagen','Catalogo_imagenes','id_imagen','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27057,'Catalogo_imagenes','id_imagen','Marcas','id_imagen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27058,'Ayuda','id_sub','Ayuda_epigrafes','id_sub','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27059,'Ayuda_epigrafes','id_imagen','Catalogo_imagenes','id_imagen','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27060,'Ayuda','id_sub','biomundo_gestion_inmersa.Sub_Secc','id_sub_secc','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27061,'Pedidos_Incidencias_CRM','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27062,'Pedidos','id_pedido','Pedidos_Incidencias_CRM','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27063,'Albaranes_Incidencias_CRM','id_albaran','Albaranes','id_albaran','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27064,'Albaranes','id_albaran','Albaranes_Incidencias_CRM','id_albaran','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27065,'Facturas_Incidencias_CRM','id_factura','Facturas','id_factura','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27066,'Facturas','id_factura','Facturas_Incidencias_CRM','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27067,'Bancos','id_banco','Efectos','id_banco','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27068,'Efectos','id_banco','Bancos','id_banco','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27069,'Bancos','id_banco','Efectos_parciales','id_banco','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27070,'Efectos_parciales','id_banco','Bancos','id_banco','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27072,'Proveedores_empresas','id_forma_pago','Forma_pago','id_forma_pago','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27073,'Bancos','id_banco','Bancos_devoluciones','id_banco','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27074,'Grupo_rutas','id_grupo_ruta','Rutas','id_grupo_ruta','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27075,'Rutas','id_grupo_ruta','Grupo_rutas','id_grupo_ruta','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27076,'Rutas','id_agente','Agentes','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27077,'Agentes','id_agente','Rutas','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27078,'Rutas','id_ruta','Rutas_clientes','id_ruta','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27079,'Rutas_clientes','id_ruta','Rutas','id_ruta','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27080,'Rutas','id_ruta','Recorridos','id_ruta','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27081,'Recorridos','id_ruta','Rutas','id_ruta','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27082,'Rutas_clientes','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27083,'Clientes','id_cliente','Rutas_clientes','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27084,'Rutas_clientes','id_medio_cto','Medios_contacto','id_medio_cto','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27085,'Medios_contacto','id_medio_cto','Rutas_clientes','id_medio_cto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27086,'Recorridos','id_agente','Agentes','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27087,'Agentes','id_agente','Recorridos','id_agente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27088,'Recorridos','id_recorrido','Citas','id_recorrido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27089,'Citas','id_recorrido','Recorridos','id_recorrido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27090,'Recorridos','id_recorrido','Recorridos_gastos','id_recorrido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27091,'Recorridos_gastos','id_recorrido','Recorridos','id_recorrido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27092,'Recorridos_gastos','id_gasto','Gastos','id_gasto','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27093,'Gastos','id_gasto','Recorridos_gastos','id_gasto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27094,'Citas','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27095,'Clientes','id_cliente','Citas','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27096,'Citas','id_medio_cto','Medios_contacto','id_medio_cto','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27097,'Medios_contacto','id_medio_cto','Citas','id_medio_cto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27098,'Citas','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27099,'Detalles_albaran','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27100,'Bajas_localizacion','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27102,'Coordinadores','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27103,'Empresas','id_empresa','Coordinadores','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27104,'Tipos_recurso','id_tipo_recurso','Recursos','id_tipo_recurso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27105,'Recursos','id_tipo_recurso','Tipos_recurso','id_tipo_recurso','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27106,'Recursos','id_recurso','Clientes_recursos','id_recurso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27107,'Clientes_recursos','id_recurso','Recursos','id_recurso','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27108,'Tipos_anotacion','id_tipo_anotacion','Cliente_notas','id_tipo_anotacion','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27109,'Cliente_notas','id_tipo_anotacion','Tipos_anotacion','id_tipo_anotacion','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27110,'Recursos','id_recurso','Articulos_recursos','id_recurso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27111,'Articulos_recursos','id_recurso','Recursos','id_recurso','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27112,'Estados_servicio','id_estado_servicio','Clientes_recursos','id_estado_servicio','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27113,'Clientes_recursos','id_estado_servicio','Estados_servicio','id_estado_servicio','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27114,'Importancias','id_importancia','Clientes_empresas','id_importancia','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27115,'Clientes_empresas','id_importancia','Importancias','id_importancia','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27116,'Articulos_recursos','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27117,'Articulos','id_articulo','Articulos_recursos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27118,'Empresas','id_empres','Articulos_recursos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27119,'Articulos_recursos','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27120,'Cliente_contactos','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27121,'Clientes','id_cliente','Cliente_contactos','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27122,'Cliente_contactos','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27123,'Empresas','id_empresa','Clientes_contactos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27124,'Cliente_enlaces','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27125,'Clientes','id_cliente','Cliente_enlaces','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27126,'Cliente_enlaces','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27127,'Empresas','id_empresa','Cliente_enlaces','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27128,'Cliente_notas','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27129,'Clientes','id_cliente','Cliente_notas','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27130,'Cliente_notas','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27131,'Empresas','id_empresa','Cliente_notas','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27132,'Clientes_recursos','id_cliente','Clientes','id_cliente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27133,'Clientes','id_cliente','Clientes_recursos','id_cliente','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27134,'Clientes_recursos','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27135,'Empresas','id_empresa','Clientes_recursos','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27136,'Clientes_recursos','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27137,'Articulos','id_articulo','Clientes_recursos','id_articulo','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27138,'Cliente_recursos','id_pedido','Pedidos','id_pedido','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27139,'Pedidos','id_pedido','Cliente_recursos','id_pedido','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27140,'Cliente_notas','id_agente','Agentes','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27141,'Agentes','id_agente','Cliente_notas','id_agente','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27142,'Cliente_notas','id_coordinador','Coordinadores','id_coordinador','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27143,'Coordinadores','id_coordinador','Cliente_notas','id_coordinador','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27144,'Operadores','id_operador','Cliente_notas','id_operador','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27145,'Cliente_notas','id_operador','Operadores','id_operador','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27146,'Operadores','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27147,'Empresas','id_empresa','Operadores','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27148,'Compra_articulos','id_servicio','Servicios','id_servicio','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27149,'Servicios','id_servicio','Compra_articulos','id_servicio','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27150,'Recorridos','id_medio_cto','Medios_contacto','id_medio_cto','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27151,'Citas','id_cita','Citas_Incidencias_CRM','id_cita','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27152,'Citas_Incidencias_CRM','id_cita','Citas','id_cita','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27153,'Citas','id_cita','Efectos_parciales','id_cita','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27154,'Efectos_parciales','id_cita','Citas','id_cita','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27155,'Efectos_parciales','id_efecto','Efectos','id_efecto','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27158,'Facturas','id_factura','Facturas_abonos','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27159,'Facturas_abonos','id_factura','Facturas','id_factura','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27160,'Efectos','id_efecto','Efectos_asientos','id_efecto','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27161,'Efectos_parciales','id_factura_abono','Facturas','id_factura','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27162,'Bajas_localizacion','id_albaran','Albaranes','id_albaran','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27206,'Tipos_Alta_stock','id_tipo_alta','Altas_stock','id_tipo_alta','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27207,'Altas_stock','id_tipo_alta','Tipos_Alta_stock','id_tipo_alta','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27208,'Altas_stock','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27209,'Almacenes_logicos','id_almacen_logico','Altas_stock','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27210,'Altas_stock','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27211,'Tipos_Cuarentena','id_tipo_cuarentena','Cuarentenas','id_tipo_cuarentena','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27212,'Cuarentenas','id_tipo_cuarentena','Tipos_Cuarentena','id_tipo_cuarentena','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27213,'Cuarentenas','id_articulo','Articulos','id_articulo','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27214,'Almacenes_logicos','id_almacen_logico','Cuarentenas','id_almacen_logico','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27215,'Cuarentenas','id_almacen_logico','Almacenes_logicos','id_almacen_logico','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27216,'OFF_Mozos_almacen','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27217,'Mozos_almacen','id_almacen','Almacenes','id_almacen','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27218,'Almacenes','id_almacen','Mozos_almacen','id_almacen','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27219,'Empresarios','id_empresa','Empresas','id_empresa','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27220,'Empresas','id_empresa','Empresarios','id_empresa','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27221,'Albaranes','id_direccion','Direcciones_entrega','id_direccion','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27222,'Albaranes','id_proveedor','Proveedores','id_proveedor','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27223,'Unidades_medida','id_tipo_unidadmedida','Tipos_UnidadMedida','id_tipo_unidadmedida','N-1');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27224,'Tipos_UnidadMedida','id_tipo_unidadmedida','Unidades_medida','id_tipo_unidadmedida','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27225,'Unidades_medida','id_unidad_medida','UnidadesMedida_Escalas','id_unidad_medida','1-N');
INSERT INTO Relaciones (id_relacion, tabla_origen, campo_origen, tabla_destino, campo_destino, tipo) VALUES (27226,'UnidadesMedida_Escalas','id_unidad_medida','Unidades_medida','id_unidad_medida','N-1');
/*!40000 ALTER TABLE Relaciones ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-09 11:13:42
