<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.                        **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y         **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre         **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo         **
**    hiciese.                                                       **
**                                                                **
** Para mas informacion referente a la licencia de esta         **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On         **
**    Line Studios S.L. para recibir una copia del mismo        **
**                                                                **
** Informacion de Contacto                                        **
**    Josafat Moragrega Fernandez                                **
**    Engineering                                                **
**    Director Tecnico                                                 **
**    tite@wolstudios.com                                        **
**    C/Alcala 18 3º Izda, 28014 Madrid, España                        **
**                                                                **
**                                 (c) Web On Line Studios S.L.         **
**                                                              **
******************************************************************
*****************************************************************/


/* Esta funcion recibe el formulario de una imagen
 * y trata sus valores
 */
function pre_catalogo(&$Sesion){

  global $estado;
  global $registro;
  global $foto;
  global $apoyo; /* Guarda el nombre de la foto */

  $oDb = $Sesion->get_db("db_catalogo");
  if (!is_object($oDb)) {
		$oDb = $Sesion->get_db('data');
		$Sesion->set_db("db_catalogo",$oDb,1);
  } 

  switch($estado){
		case 1:
			/* Si no se ha metido nada en el campo de input type=file, tomara como valor el hidden
				 $apoyo que conserva el valor anterior */
			$foto_name = $_FILES['foto']['name'];
			$db_cfg = $Sesion->get_db('conf');
			if (!empty($foto)) {
				$ext= split('[.]',$_FILES['foto']['name']);
				$tiempo=time(); /* Asi le ponemos un nombre unico a cada foto en el destino*/
				$dest = $db_cfg->read_main_value('doc_root').$Sesion->get_img_path().$tiempo.".".$ext[1];
				debug("Subiendo a $dest");
				if (strcmp($foto,"none") && !empty($foto) && !upload($foto,$dest)) {
						salida("Error al subir la foto");
						return;
				}
			}
			// med: 90 x 50
			// peq: 45 x 25
			// norm: 360 x 200
			// debug("nuevo o modificar no? ($foto)");
			if(strcmp($foto,"none") AND !empty($foto)){
								$registro["nombre"] = $tiempo.".".$ext[1];
								//REDIMENSIONADO DE IMAGENES 
								$es_imagen = 0;
								//creacion de imagenes
								$size = GetImageSize($dest);
								$ext = end(explode(".",$registro['nombre']));
								if ($size[0] > $size[1]) { //Apaisado
									$pqw = 64;
									$mdw = 80;
									$lgw = 160;
								} else {
									$pqw = 48;
									$mdw = 60;
									$lgw = 120;
								}
								$pqh = round($size[1] / ($size[0] / $pqw));
								$mdh = round($size[1] / ($size[0] / $mdw));
								$lgh = round($size[1] / ($size[0] / $lgw));
								// debug("REDIMENSIONANDO (".$size[0]."x".$size[1].")");
								// debug("Peq : $pqw x $pqh");
								// debug("Med : $mdw x $mdh");
								// debug("Longa : $lgw x $lgh");

								if( ($ext == "png" or $ext == "PNG") AND function_exists('ImageCreateFromPNG') ){
										 $es_imagen = 1;
										 $im_in = ImageCreateFromPNG("../catalogo/$registro[nombre]");
										 $im_out_med = ImageCreate($mdw,$mdh);
										 $im_out_peq = ImageCreate($pqw,$pqh);
										 $im_out_lng = ImageCreate($lgw,$lgh);
										 ImageCopyResized($im_out_med , $im_in, 0,0,0,0, $mdw,$mdh,$size[0],$size[1]);
										 ImageCopyResized($im_out_peq , $im_in, 0,0,0,0, $pqw,$pqh,$size[0],$size[1]);
										 ImageCopyResized($im_out_lng , $im_in, 0,0,0,0, $lgw,$lgh,$size[0],$size[1]);
										 ImagePNG($im_out_med,"../catalogo/med_$registro[nombre]");
										 ImagePNG($im_out_peq,"../catalogo/peq_$registro[nombre]");
										 ImagePNG($im_out_lng,"../catalogo/lng_$registro[nombre]");

										 ImageDestroy($im_in);
										 ImageDestroy($im_out_med);
										 ImageDestroy($im_out_peq);
										 ImageDestroy($im_out_lng);

										 exec("chmod 777 "."../catalogo/med_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/peq_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/lng_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/$registro[nombre]");

								} else if( ($ext == "jpeg" or $ext == "JPEG" or $ext == "jpg" or $ext == "JPG") AND function_exists('ImageCreateFromJPEG') ){
						   // debug("metiendo jpegs_pekeñas");
										 $es_imagen = 1;
										 $im_in = ImageCreateFromJPEG ("../catalogo/$registro[nombre]"); /* Attempt to open */
										 $im_out_peq = ImageCreate($pqw,$pqh);
										 $im_out_med = ImageCreate($mdw,$mdh);
										 $im_out_lng = ImageCreate($lgw,$lgh);
										 ImageCopyResized($im_out_peq , $im_in, 0,0,0,0, $pqw,$pqh,$size[0],$size[1]);
										 ImageCopyResized($im_out_med , $im_in, 0,0,0,0, $mdw,$mdh,$size[0],$size[1]);
										 ImageCopyResized($im_out_lng , $im_in, 0,0,0,0, $lgw,$lgh,$size[0],$size[1]);
										 ImageJPEG($im_out_peq,"../catalogo/peq_$registro[nombre]");
										 ImageJPEG($im_out_med,"../catalogo/med_$registro[nombre]");
										 ImageJPEG($im_out_lng,"../catalogo/lng_$registro[nombre]");

										 ImageDestroy($im_in);
										 ImageDestroy($im_out_med);
										 ImageDestroy($im_out_peq);
										 ImageDestroy($im_out_lng);

										 exec("chmod 777 "."../catalogo/lng_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/med_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/peq_$registro[nombre]");
										 exec("chmod 777 "."../catalogo/$registro[nombre]");
								}

				// a ver ke se hace con los flash
	/*      else{
					aviso("Formato no reconocido , debe ser jpeg o png");
					return;
				}
	*/
				// FIN REDIMENSIONADO DE IMAGENES
								/* Al reemplazar se elimina la de antes */
								// debug("apoyo = $apoyo");
								if(isset($apoyo) && !empty($apoyo)) {
										if (!@unlink("../".$Sesion->get_img_path().$apoyo)) 
												salida("No se pudo borrar imagen anterior<br/>\n");
										if (!@unlink("../".$Sesion->get_img_path()."peq_".$apoyo)) 
												salida("No se pudo borrar imagen anterior peq<br/>\n");
										if (!@unlink("../".$Sesion->get_img_path()."med_".$apoyo)) 
												salida("No se pudo borrar imagen anterior mediana<br/>\n");
								} elseif (!empty($apoyo)) {
										$registro["nombre"] = $apoyo;
								}
			} elseif (isset($apoyo) && !empty($apoyo)) $registro['nombre'] = $apoyo;
			if(isset($registro["fecha_toma"]) AND !empty($registro["fecha_toma"])){
						$fecha_inicio=addslashes($registro["fecha_toma"]);
						$fecha_inicio=trim($registro["fecha_toma"]);
						if(strcmp($registro["fecha_toma"],"dd-mm-aaaa")){
										$anyo=substr($registro["fecha_toma"],6,4);
										$mes=substr($registro["fecha_toma"],3,2);
										$dia=substr($registro["fecha_toma"],0,2);
										$registro["fecha_toma"]=$anyo."-".$mes."-".$dia;
						}
						else $registro["fecha_toma"]="";
			} else $registro["fecha_toma"]="";
			if (!$oDb->tb_replace("Catalogo_imagenes",$registro)) {
						echo "<H3>Error Interno, contacto con <A HREF=\"mailto:$ADMIN";
						echo "\">$ADMIN</A> informandole del problema.";
			}
			if(!$registro["id_imagen"]){
										$registro["id_imagen"]=$oDb->last_insert_id();
			}
			if($Sesion->get_var("con_categoria")){
								$consulta="delete from Catalogo_categorias where id_imagen=".$registro["id_imagen"];
								$oDb->query($consulta);
								if($elegir_sub=$Sesion->get_var("elegir_sub")){;
													for($i=0;$i<sizeof($elegir_sub);$i++){
														 $consulta="insert into Catalogo_categorias values(".$registro["id_imagen"].
																				",".$elegir_sub[$i].")";
														 $oDb->query($consulta);
													}
								}
			}
			$Sesion->set_var("con_categoria",NULL);
			$Sesion->set_var("elegir_sub",NULL);
			break;

		case 2:
			global $id_imagen;
			global $nombre_foto;
			/* Borrado de la tabla de Catalogo_imagenes */
			$consulta="delete from Catalogo_imagenes where id_imagen=$id_imagen";
			if(!$oDb->query($consulta)){
				 echo "Ha fallado la consulta ".$consulta;
				 exit;
			}
			/* Borrado FISICO del directorio de fotos del catalogo */
			$tmp="../".$Sesion->get_img_path().$nombre_foto;
			if(!@unlink($tmp)){
				salida("No sea ha podido eliminar la foto :".$tmp);
				//exit;
			}
			break;

		default:
			 break;
  }
}

/* Esta funcion crea un contador para poner un TR por cada 3 TD */
function contador(){
 global $cont_fotos;
 if(!isset($cont_fotos)) $cont_fotos=0;
 if( $cont_fotos%3==0 ){
   $cont_fotos++;
   return 1;
 }
 else{
   $cont_fotos++;
   return 0;
 }
}

/* Esta funcion reemplaza una foto. Se utiliza en tablas que cambian una sola imagen */
function pre_check(&$oSesion){
	global $aFotos;
	global $aFotos_old;
	global $arreguarda;
	global $id_sub;
	global $id_imagen;
	global $tabla;
	global $campo_destino;
	global $nuevo_radio; /* Para meter un nuevo registro de un catalogo radio */
	global $alter_db;
	global $reserva;
	global $eliminados;
	global $form_sent;

	/* Primero guardamos en la sesion los valores que llegan
				  para no perderlos en la botonera */
	if(isset($arreguarda)){
		$oSesion->set_var("id_sub",$id_sub,SUBSECCION);
		$oSesion->set_var("id_imagen",$id_imagen,SUBSECCION);
		$oSesion->set_var("tabla",$tabla,SUBSECCION);
		$oSesion->set_var("campo_destino",$campo_destino,SUBSECCION);
		if(isset($nuevo_radio)) $oSesion->set_var("nuevo_radio_sess",1,SUBSECCION);
		if (!isset($alter_db) OR empty($alter_db)) $alter_db = $oSesion->read_main_value("db_catalogo_update_name");
		if (!empty($alter_db)) $oSesion->set_var("alter_db",$alter_db,"SUBSECCION");

		$alter_db = $oSesion->get_var("alter_db");
		if (!isset($alter_db) OR empty($alter_db) OR !is_object($oSesion->get_db($alter_db)))
						$oDb = $oSesion->get_db_conn();
		else $oDb = $oSesion->get_db($alter_db);

		if (!empty($tabla)) {
						// Guardamos en la sesion las imagenesa actualmente asociadas al registro actual
						$cons_check="select id_imagen from ".$tabla." where $campo_destino = ".(int)$id_sub;
						$rs=$oDb->query($cons_check);
						while($row=$oDb->fetch_array($rs)){
								$aExisten[]=$row["id_imagen"]; /* Aqui tenemos los asociados anteriormente */
						}
						$oSesion->set_var("identificador_imagen_nueva",$aExisten);
						$oDb->libera($rs);
		}
	}

	if($aFotos OR $form_sent){
	//debug("aqui se asigna... aqui");
				$id_sub=$oSesion->get_var("id_sub");
				$id_imagen=$oSesion->get_var("id_imagen");
				$tabla=$oSesion->get_var("tabla");
				$campo_destino=$oSesion->get_var("campo_destino");
				//$las_fotos = (int)$las_fotos; 
				$las_fotos = $oSesion->get_var("identificador_imagen_nueva");
				if (is_array($las_fotos)) {
								if (is_array($aFotos_old)) 
												foreach($aFotos_old as $idx => $valor)
															if (!strcasecmp($valor,"CHECKED") AND 
																							( (is_array($aFotos) AND !in_array($idx,$aFotos)) 
																							OR !is_array($aFotos)) ) {
																	if (in_array($idx,$las_fotos))
																					$las_fotos = array_diff($las_fotos,array($idx));
															}
																	
				}
				if (is_array($aFotos))
								foreach ($aFotos as $idx => $valor)
										if ( (is_array($las_fotos) AND !in_array($valor,$las_fotos)) OR !is_array($las_fotos))
												$las_fotos[] = $valor;
//debug("asignamos el nuevo id_imagen en la sesion($las_fotos)");

				$alter_db = $oSesion->get_var("alter_db");
				if (!isset($alter_db) OR empty($alter_db) OR !is_object($oSesion->get_db($alter_db)))
						$oDb = $oSesion->get_db_conn();
				else $oDb = $oSesion->get_db($alter_db);

						
					/* Primero se borran todas las fotos vinculadas a esa noticia y luego las metemos */
					$consulta="delete from $tabla where $campo_destino =".$id_sub;
					$oDb->query($consulta);


						/* Este for se encarga de vincular las fotos del catalogo a una noticia */
						if (is_array($las_fotos) AND $form_sent){
									$i = 0;
									foreach($las_fotos as $valor) {
												$cons="insert into $tabla ($campo_destino,id_imagen,orden) ".
															"values($id_sub,$valor,".$i++.")";
												$oDb->query($cons);
									}
									$oSesion->unset_var("identificador_imagen_nueva");
						}

					//debug("<b>bo_recarga_ventana!</b>");
					return "bo_recarga_ventana.plt";
     		}
				$las_fotos = $oSesion->get_var("identificador_imagen_nueva");
				if (is_array($las_fotos)) {
								if (is_array($eliminados)) 
												foreach($las_fotos as $idx => $valor)
															if (in_array($valor,$eliminados))
																	unset($las_fotos[$idx]);
																	
				}
				if (is_array($las_fotos)) $las_fotos = array_values($las_fotos);
				if (is_array($reserva)) 
								foreach($reserva as $valor)
												if (is_array($las_fotos) && !in_array($valor,$las_fotos))
																$las_fotos[] = $valor;
				$oSesion->set_var("identificador_imagen_nueva",$las_fotos,SUBSECCION);
}

/* Esta funcion comprueba si una foto ya esta asociada a una
 * noticia y, en ese caso, saca un checked en el checkbox
 */
function chequear($dato,&$oSesion){
  global $id_noticia;
  global $reserva;
  global $eliminados;
  global $pasado;
  global $tabla_ant; /* Para saber en que tabla busca los antiguos */
  global $campo_id; /* Para saber el registro donde mirar los antiguos */
  global $url_destino; /* Para ver donde mandamos el formulario del catalogo */

  /* Aqui se compara y si return 1 el checkbox sale marcado */
	$aTmp = $oSesion->get_var("identificador_imagen_nueva");
	if (is_array($aTmp) && in_array($dato,$aTmp)) return "CHECKED";
	else return NULL;




  $total_fotos=$Sesion->get_var("total_fotos");
  $consultado=$Sesion->get_var("consultado");
  if(!$id_noticia){ /* INSERCION */
    if(!$consultado){
      $Sesion->set_var("url_destino",$url_destino);
      $Sesion->set_var("consultado",1);
      $total_fotos=$Sesion->get_var("nuevo_fotos");
      $Sesion->set_var("nuevo_fotos","");
    }
  } else { /* MODIFICACION */
                /* Los antiguos los sacamos solamente una vez en todo el catalogo */
    if(!$consultado){
			$alter_db = $Sesion->get_var("alter_db");
			if (!isset($alter_db) OR empty($alter_db) OR !is_object($Sesion->get_db($alter_db)))
					$oDb = $Sesion->get_db_conn();
			else $oDb = $Sesion->get_db($alter_db);

      $cons_check="select id_imagen from ".$tabla_ant." where $campo_id = ".$id_noticia;
      $rs=$oDb->query($cons_check);
      while($row=$oDb->fetch_array($rs)){
        $aExisten[]=$row["id_imagen"]; /* Aqui tenemos los asociados anteriormente */
      }
			$oDb->libera($rs);
			$Sesion->set_var("url_destino",$url_destino);
      $Sesion->set_var("consultado",1);
      $Sesion->set_var("total_fotos",$aExisten);
      $total_fotos=$aExisten;
    }
  }
  if(!isset($pasado)){  /* Los siguientes pasos los tiene que hacer una vez por pagina, y no por registro */
     /* Ahora quito los eliminados */
     for($i=0;$i<sizeof($eliminados);$i++){
       for($j=0;$j<sizeof($total_fotos);$j++){
         if($total_fotos[$j]==$eliminados[$i]){
           $total_fotos[$j]="";
         }
       }
     }
     /* Y ahora meto los de la reserva */
     for($i=0;$i<sizeof($reserva);$i++){
         $total_fotos[]=$reserva[$i];
     }
     /* Y con un par todo para la sesion */
                 sizeof($total_fotos);
     $Sesion->set_var("total_fotos",$total_fotos);
     $pasado=1;
  }
  /* Aqui se compara y si return 1 el checkbox sale marcado */
  for($i=0;$i<sizeof($total_fotos);$i++){
    if($total_fotos[$i]==$aDatos["Catalogo_imagenes.id_imagen"]) return 1;
  }
  return 0;
}

/* Esta funcion reemplaza una foto. Se utiliza en tablas que cambian una sola imagen */
function pre_radio(&$oSesion){
	global $las_fotos;
	global $arreguarda;
	global $id_sub;
	global $id_imagen;
	global $tabla;
	global $campo_destino;
	global $nuevo_radio; /* Para meter un nuevo registro de un catalogo radio */
	global $alter_db;

	// debug("pre_radio");

	/* Primero guardamos en la sesion los valores que llegan
                 para no perderlos en la botonera */
	// debug('guarda: '.$arreguarda);
	if(isset($arreguarda)){
		$oSesion->set_var("id_sub",$id_sub);
		$oSesion->set_var("id_imagen",$id_imagen);
		$oSesion->set_var("tabla",$tabla);
		$oSesion->set_var("campo_destino",$campo_destino);
		if(isset($nuevo_radio)) $oSesion->set_var("nuevo_radio_sess",1);
		if (!isset($alter_db) OR empty($alter_db)) $alter_db = $oSesion->read_main_value("db_catalogo_update_name");
		if (!empty($alter_db)) $oSesion->set_var("alter_db",$alter_db,"SUBSECCION");
	}
	// debug("alter_db = $alter_db");

	if(is_numeric($las_fotos)){
		// debug("aqui se asigna... aqui");
		if($oSesion->get_var("nuevo_radio_sess")){
        	$oSesion->set_var("identificador_imagen_nueva",$las_fotos);
         $oSesion->set_var("nuevo_radio_sess",$las_fotos);
		} else {
        $id_sub=$oSesion->get_var("id_sub");
        $id_imagen=$oSesion->get_var("id_imagen");
        $tabla=$oSesion->get_var("tabla");
        $campo_destino=$oSesion->get_var("campo_destino");
        $las_fotos = (int)$las_fotos; 
        $oSesion->set_var("identificador_imagen_nueva",$las_fotos);

				$alter_db = $oSesion->get_var("alter_db");
				if (!isset($alter_db) OR empty($alter_db) OR !is_object($oSesion->get_db($alter_db)))
						$oDb = $oSesion->get_db_conn();
				else $oDb = $oSesion->get_db($alter_db);

        $consulta="update $tabla set id_imagen=$las_fotos where $campo_destino=$id_sub";
        // if(is_numeric($id_imagen)) $consulta.=" and id_imagen=$id_imagen";
		  $oDb->query($consulta);
      }
		return "bo_recarga_ventana.plt";
     }
}

/* Mediante esta funcion mandamos el formulario del catalogo
         a la seccion de nuevo o de modificar */
function modif_o_nuevo(&$Sesion,&$aDatos){
                global $id_noticia;
                if($id_noticia==-1)
                                return 0;
                else
                                return 1;
}


function barras_fecha($valor){
   $valor=split('[/-]',$valor);
   $fecha=$valor[2]."/".$valor[1]."/".$valor[0];
   return $fecha;
}


function pre_subcategorias(&$Sess) {
    global $estado;
    global $registro;
    global $id_cat_cat;

	$oDb = $Sesion->get_db("db_catalogo");
	if (!is_object($oDb)) {
				$db_user = $Sesion->read_main_value("db_catalogo_login");
				$db_pass = $Sesion->read_main_value("db_catalogo_passwd");
				$db_host = $Sesion->read_main_value("db_catalogo_server");
				$db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
				if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase)) {
								$Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
								$oDb = $Sesion->get_db("db_catalogo");
				} else {
								$oDb = $Sesion->get_db('data');
								$Sesion->set_db("db_catalogo",$oDb,1);
				}
	} 

    /** a ver si hay k hacer algo con la db */
    if (!isset($estado)) $estado=5;
    else $estado = (int) $estado;
//salida("estado estarr ($estado)....");

    switch ($estado) {
            case 1: /* Modificacion en Listado */

              break;

            case 2: /** Modificacion **/

            case 5: /** Comrobacion en los checkbox **/
                    if($id_cat_cat){
                        $Sess->set_var("subcategoria_sec",$id_cat_cat);
                        $cons="select id_sub_cat from Categorias_subcategorias where id_cat_cat=".$Sess->get_var("subcategoria_sec");
                        $rs=$oDb->query($cons);
                        while($row=$oDb->fetch_row($rs)){
                          $total_subcategorias[]=$row[0];
                        }
                        $Sess->set_var("total_subcategorias",$total_subcategorias);
                    }
                    break;

            case 3: /** Borrar **/
                  global $id;
                  if (!isset($id) OR empty($id)){}
                  else $id=(int)$id;

                  $cons = "DELETE FROM Subcategorias where id_sub_cat=$id";
                  $oDb->query($cons);

                  break;
            case 4: /** Alta **/
                    if (!tb_replace_act($oDb,"Subcategorias",$registro))
                            return 0;

                    break;

            default:
    }
}

function pre_subcategorias2(&$Sess) {
    global $estado;
    global $registro;
    global $id_cat_cat;

	$oDb = $Sesion->get_db("db_catalogo");
	if (!is_object($oDb)) {
				$db_user = $Sesion->read_main_value("db_catalogo_login");
				$db_pass = $Sesion->read_main_value("db_catalogo_passwd");
				$db_host = $Sesion->read_main_value("db_catalogo_server");
				$db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
				if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase)) {
								$Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
								$oDb = $Sesion->get_db("db_catalogo");
				} else {
								$oDb = $Sesion->get_db('data');
								$Sesion->set_db("db_catalogo",$oDb,1);
				}
	} 

    /** a ver si hay k hacer algo con la db */
    if (!isset($estado)) $estado=5;
    else $estado = (int) $estado;
//salida("estado estarr ($estado)....");

    switch ($estado) {
            case 1: /* Modificacion en Listado */

              break;

            case 2: /** Modificacion **/

            global $subcategorias;

            $consulta="delete from Categorias_subcategorias where id_cat_cat=".$id_cat_cat;
            $oDb->query($consulta);

            for($i=0;$i<sizeof($subcategorias);$i++){
              $cons="insert into Categorias_subcategorias values(".$subcategorias[$i].",".$id_cat_cat.")";
              $oDb->query($cons);
            }
            $Sess->set_var("total_subcategorias","");


            case 5: /** Comrobacion en los checkbox **/
                    if($id_cat_cat){
                        $Sess->set_var("subcategoria_sec",$id_cat_cat);
                        $cons="select id_sub_cat from Categorias_subcategorias where id_cat_cat=".$Sess->get_var("subcategoria_sec");
                        $rs=$oDb->query($cons);
                        while($row=$oDb->fetch_row($rs)){
                          $total_subcategorias[]=$row[0];
                        }
                        $Sess->set_var("total_subcategorias",$total_subcategorias);
                    }
                    break;

            case 3: /** Borrar **/
                  global $id;
                  if (!isset($id) OR empty($id)){}
                  else $id=(int)$id;

                  $cons = "DELETE FROM Subcategorias where id_sub_cat=$id";
                  $oDb->query($cons);
                  $consulta= "delete from Categorias_subcategorias where id_sub_cat=$id";
                  $oDb->query($consulta);

                  break;
            case 4: /** Alta **/
                    if (!tb_replace_act($oDb,"Subcategorias",$registro))
                            return 0;

                    break;

            default:
    }
}


function pre_categorias(&$Sess) {
    global $estado;
    global $registro;
    global $id_cat_cat;

	$oDb = $Sesion->get_db("db_catalogo");
	if (!is_object($oDb)) {
				$db_user = $Sesion->read_main_value("db_catalogo_login");
				$db_pass = $Sesion->read_main_value("db_catalogo_passwd");
				$db_host = $Sesion->read_main_value("db_catalogo_server");
				$db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
				if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase)) {
								$Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
								$oDb = $Sesion->get_db("db_catalogo");
				} else {
								$oDb = $Sesion->get_db('data');
								$Sesion->set_db("db_catalogo",$oDb,1);
				}
	} 

    /** a ver si hay k hacer algo con la db */
    if (!isset($estado)) $estado=5;
    else $estado = (int) $estado;
//salida("estado estarr ($estado)....");

    switch ($estado) {

            case 3: /** Borrar **/
                  global $id;
                  if (!isset($id) OR empty($id)){}
                  else $id=(int)$id;

                  $cons = "DELETE FROM Categorias where id_cat_cat=$id";
                  $oDb->query($cons);

                  break;
            case 4: /** Alta **/
                    if (!tb_replace_act($oDb,"Categorias",$registro))
                            return 0;

                    break;

            default:
    }
}


function pre_elegir(&$Sesion) {
    global $estado;
    global $registro;

	$oDb = $Sesion->get_db("db_catalogo");
	if (!is_object($oDb)) {
				$db_user = $Sesion->read_main_value("db_catalogo_login");
				$db_pass = $Sesion->read_main_value("db_catalogo_passwd");
				$db_host = $Sesion->read_main_value("db_catalogo_server");
				$db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
				if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase)) {
								$Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
								$oDb = $Sesion->get_db("db_catalogo");
				} else {
								$oDb = $Sesion->get_db('data');
								$Sesion->set_db("db_catalogo",$oDb,1);
				}
	} 

    $estado = (int) $estado;

    switch ($estado) {

            case 1: /** Subcategorias **/
                  global $elegir_sub;
                  $Sesion->set_var("con_categoria",1);
                  if($elegir_sub){
                    $Sesion->set_var("elegir_sub",$elegir_sub);
                  }
                  break;

            default:
    }
}


function elegir_sub(&$Sesion,&$aDatos){
  global $elegir_cat;
  static $rs;
  global $tengo_sub;
	$oDb = $Sesion->get_db("db_catalogo");

        if($elegir_cat){
          if(!$rs){
      $consulta="select id_sub_cat from Categorias_subcategorias where id_cat_cat=$elegir_cat[0]";
      for($i=1;$i<sizeof($elegir_cat);$i++)
              $consulta.=" or id_cat_cat=$elegir_cat[$i]";
            $rs=$oDb->query($consulta);
             while($row=$oDb->fetch_row($rs)){
              $tengo_sub[]=$row[0];
            }
          }
        }
        if($tengo_sub){
          for($i=0;$i<sizeof($tengo_sub);$i++){
                  if($tengo_sub[$i]==$aDatos["Subcategorias.id_sub_cat"]){
                          return 1;
                        }
                }
        }
        return 0;
}

function chequear_categorias(&$Sesion,&$aDatos){
  global $id_imagen;
  static $rs;
  global $tengo_cat;
	$oDb = $Sesion->get_db("db_catalogo");
  if($id_imagen){
    if(!$rs){
      $consulta="select t1.id_cat_cat from Categorias_subcategorias t1, Catalogo_categorias t2 where ";
      $consulta.="t1.id_sub_cat=t2.id_sub_cat and t2.id_imagen=$id_imagen";
      $rs=$oDb->query($consulta);
      while($row=$oDb->fetch_row($rs)){
        $tengo_cat[]=$row[0];
      }
    }
  }
  for($i=0;$i<sizeof($tengo_cat);$i++){
    if($tengo_cat[$i]==$aDatos["Categorias.id_cat_cat"]){
      return "checked";
    }
  }
}

function chequear_subcategorias(&$Sesion,&$aDatos){
  global $id_imagen;
  static $rs;
  static $tengo_subcat;
	$oDb = $Sesion->get_db("db_catalogo");
  if($id_imagen){
    if(!$rs){
      $consulta.="select id_sub_cat from Catalogo_categorias where id_imagen=$id_imagen";
      $rs=$oDb->query($consulta);
      while($row=$oDb->fetch_row($rs)){
        $tengo_subcat[]=$row[0];
      }
    }
  }
  for($i=0;$i<sizeof($tengo_subcat);$i++){
    if($tengo_subcat[$i]==$aDatos["Subcategorias.id_sub_cat"]){
      return "checked";
    }
  }
}






function chequear_checkbox(&$Sesion,&$aDatos){
     $total_subcategorias=$Sesion->get_var("total_subcategorias");
     for($i=0;$i<sizeof($total_subcategorias);$i++){
             if($total_subcategorias[$i]==$aDatos["Subcategorias.id_sub_cat"])
                                                   return checked;
                 }
}

function seleccionar_categorias(&$Sesion,&$aDatos){
      global $id_cat_cat;
      if($id_cat_cat==$aDatos["Categorias.id_cat_cat"]) return "SELECTED";

}

function subcategorias_concretas(&$Sesion,&$aDatos){
      global $id_cat_cat;
      if($id_cat_cat) return 1;

}

/* La funcion transformna el formato dd-mm-aaaa en aaaa-mm-dd */
function colocator($valor){
  $elementos=split('[-/]',$valor);
  $valor=$elementos[2]."-".$elementos[1]."-".$elementos[0];
  return $valor;
}

/* Funcion que decide en la plt de elegir subcategorias si vamos a nuevo o a modificar */
function decidir_destino(&$Sesion){
  global $id_imagen;
  if($id_imagen)
                return "bo_modif_catalogo&amp;id_imagen=$id_imagen";
        else
          return "bo_nuevo_catalogo";
}


function tipo_agrupacion(&$Sesion,&$aDatos){
  global $id_sub_cat;
  global $elegir_cat;
  static $rs;
  global $tengo_imagenes;
	$oDb = $Sesion->get_db("db_catalogo");
  if($id_sub_cat){
    if(!$rs){
      $consulta="select id_imagen from Catalogo_categorias where id_sub_cat=$id_sub_cat";
      $rs=$oDb->query($consulta);
      while($row=$oDb->fetch_row($rs)){
        $tengo_imagenes[]=$row[0];
      }
    }
  }
  if(!$id_sub_cat && $elegir_cat){
    if(!$rs){
      $consulta="select id_sub_cat from Categorias_subcategorias where id_cat_cat=$elegir_cat";
      $rs=$oDb->query($consulta);
      while($row=$oDb->fetch_row($rs)){
        $sub_cat[]=$row[0];
      }
      $consulta="select id_imagen from Catalogo_categorias  where id_sub_cat=".$sub_cat[0];
      for($i=1;$i<sizeof($sub_cat);$i++)
        $consulta.=" or id_sub_cat=$sub_cat[$i]";
      $rs=$oDb->query($consulta);
      while($row=$oDb->fetch_row($rs)){
        $tengo_imagenes[]=$row[0];
      }
    }
  }
  if($tengo_imagenes){
    for($i=0;$i<sizeof($tengo_imagenes);$i++){
                  if($id_sub_cat){
        if($tengo_imagenes[$i]==$aDatos["Catalogo_imagenes.id_imagen"])
          return 1;
                  }else{
        if($tengo_imagenes[$i]==$aDatos["Catalogo_imagenes.id_imagen"]
          && $aDatos["Catalogo_imagenes.en_portada"]==1){
          return 1;
        }
                        }
    }
  }
  return 0;
}


function chequear_portada(&$Sesion,&$aDatos){
  if($aDatos["Catalogo_imagenes.en_portada"]==1) return "checked";
}

function img_dir(&$Sesion){
  return $Sesion->get_img_path();
}

?>
