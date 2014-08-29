DROP TABLE IF EXISTS `Maestro_bajas_almacen` ;
ALTER TABLE Promociones_articulos CHANGE cantidad cantidad decimal(20,8) not null default 0;

# El albaran ya tiene info de Origen y Destino
UPDATE Albaranes JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) SET Albaranes.id_direccion=Pedidos.id_direccion, Albaranes.id_proveedor=Pedidos.id_proveedor;

