INSERT INTO `Relaciones` 
( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES 
(NULL , 'Unidades_medida', 'id_tipo_unidadmedida', 'Tipos_UnidadMedida', 'id_tipo_unidadmedida', 'N-1'),
(NULL , 'Tipos_UnidadMedida', 'id_tipo_unidadmedida', 'Unidades_medida', 'id_tipo_unidadmedida', '1-N');
UPDATE Unidades_medida set id_tipo_unidadmedida=1 WHERE id_tipo_unidadmedida=0;

INSERT INTO `Relaciones` 
( `id_relacion` , `tabla_origen` , `campo_origen` , `tabla_destino` , `campo_destino` , `tipo` )
VALUES 
(NULL , 'Unidades_medida', 'id_unidad_medida', 'UnidadesMedida_Escalas', 'id_unidad_medida', '1-N'),
(NULL , 'UnidadesMedida_Escalas', 'id_unidad_medida', 'Unidades_medida', 'id_unidad_medida', 'N-1');

