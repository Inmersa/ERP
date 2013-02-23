
REPLACE INTO Sub_Secc (id_sub_secc,nombre,tb_base,script,busc_defecto,nombre_visual,backoffice,module_mask) VALUES ('344','bo_efectos_proveedor','Efectos','efectos.php','132','','1','1')
Update Sec_Subsecc SET av_group = 0 WHERE id_sub_secc=344 AND id_seccion = 5;
Update Sec_Subsecc SET av_group = av_group | 4  WHERE id_sub_secc=344 AND id_seccion=5;
Update Sec_Subsecc SET av_group = av_group | 8  WHERE id_sub_secc=344 AND id_seccion=5;
Update Sec_Subsecc SET av_group = av_group | 32  WHERE id_sub_secc=344 AND id_seccion=5;


