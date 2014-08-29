
ALTER TABLE `Articulos` DROP `fecha_baja` ;
ALTER TABLE `Empresas_articulos` CHANGE `stock_ficticio` `stock_ficticio` DOUBLE DEFAULT NULL ;

