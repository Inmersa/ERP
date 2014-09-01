<?php
function pre_presupuestos_cliente(&$Sesion) {
global $id_cliente;
$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");

//debug("glob  $id_cliente");
//debug("ses $id_cliente_sesion");

if(isset($id_cliente) AND $id_cliente_sesion != id_cliente)
        $Sesion->set_var("id_cliente_promocion",$id_cliente);
else    {$id_cliente = $Sesion->get_var("id_cliente_promocion");
        if(!isset($id_cliente)){
//               debug("no hay cliente");
                 return;
                }
        }

}//fin del precode

function calcular_monto_presupuesto(&$Sesion,&$aDatos){
$id_presupuesto = $aDatos["Presupuestos.id_presupuesto"];
$consulta = "select sum(monto_total + (monto_total * porcentaje / 100)) from Lineas_detalle , Articulos , Tipos_IVA
             where Lineas_detalle.id_presupuesto = $id_presupuesto and
             Lineas_detalle.id_articulo = Articulos.id_articulo and
             Articulos.id_iva = Tipos_IVA.id_iva";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return round($row[0],3);
}

function pre_presupuesto_cliente(&$Sesion) {
global $id_presupuesto;
if(isset($id_presupuesto))
    $Sesion->set_var("id_presupuesto",$id_presupuesto,"SUBSECCION");
else
    $id_presupuesto =  $Sesion->get_var("id_presupuesto");

$consulta = "select id_cliente from Presupuestos where id_presupuesto = $id_presupuesto";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
$Sesion->set_var("id_cliente_promocion",$row[0],"SUBSECCION");

$usuario = identifica_usuarios($Sesion);
$Sesion->set_var("id_empresa",$usuario[id],"SUBSECCION");

$Sesion->set_var("es_pedido",1);
$Sesion->set_var("el_pedido_presupuesto", $id_presupuesto );


}

function pre_imprimir($Sesion){
global $imprimir;
if($imprimir==1){
     return "bo_presupuesto_cliente2.plt";
     }
}

function detalle_cliente($Sesion){
global $resul;
if(!isset($resul)){
        $id_presupuesto = $Sesion->get_var("id_presupuesto");
        $usuario = identifica_usuarios($Sesion);
        $consulta = "select * from Clientes , Clientes_empresas , Presupuestos
                     where Presupuestos.id_presupuesto = $id_presupuesto and
                           Presupuestos.id_cliente = Clientes.id_cliente and
                           Clientes_empresas.id_cliente = Clientes.id_cliente and
                           Clientes_empresas.id_empresa = $usuario[id]";
        //depurar_array($row);
        $resul=$Sesion->query($consulta);
        $row=$Sesion->fetch_array($resul);
        $consulta = "select Provincias.nombre as provincia from Clientes , Clientes_empresas , Presupuestos , Provincias
                     where Presupuestos.id_presupuesto = $id_presupuesto and
                           Presupuestos.id_cliente = Clientes.id_cliente and
                           Clientes_empresas.id_cliente = Clientes.id_cliente and
                           Clientes_empresas.id_empresa = $usuario[id] and
                           Clientes.id_provincia = Provincias.id_provincia";
        //depurar_array($row);
        $resul2=$Sesion->query($consulta);
        $row2=$Sesion->fetch_array($resul2);
        $row[provincia] = $row2[provincia];
        return $row;
        }
else return NULL;
}

function detalle_empresa($Sesion){
global $result;
if(!isset($result)){
        $usuario = identifica_usuarios($Sesion);
        $consulta = "select * from Empresas
                     where Empresas.id_empresa = $usuario[id]";
        //depurar_array($row);
        $result=$Sesion->query($consulta);
        $row=$Sesion->fetch_array($result);
        $consulta = "select Provincias.nombre as provincia from Empresas ,Provincias
                     where Empresas.id_empresa = $usuario[id] and
                           Provincias.id_provincia = Empresas.id_provincia";
        //depurar_array($row);
        $result2=$Sesion->query($consulta);
        $row2=$Sesion->fetch_array($result2);
        $row[provincia] = $row2[provincia];
        return $row;
        }
else return NULL;
}

function obtener_agente(&$Sesion,&$aDatos){
//depurar_array($aDatos);
$Sesion->set_var("Agente",$aDatos["Pedidos.id_agente"],"EXPIRE");
}
function chequear_agente(&$Sesion,&$aDatos){
global $registro;
if($Sesion->get_var("Agente")==$aDatos["Agentes.id_agente"])
return selected;
}

function nombre_articulo(&$Sesion,&$aDatos){
$id_articulo = $aDatos["Lineas_detalle.id_articulo"];
$consulta = "select Articulos.nombre  from Articulos where Articulos.id_articulo = $id_articulo";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function porcentaje_iva(&$Sesion,&$aDatos){
$id_art = $aDatos["Lineas_detalle.id_articulo"];
$consulta = "Select porcentaje from  Articulos , Tipos_IVA where Articulos.id_articulo = $id_art and Articulos.id_iva = Tipos_IVA.id_iva";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}

function descripcion_descuento(&$Sesion,&$aDatos){

$id_art = $aDatos["Lineas_detalle.id_articulo"];
$usuario = identifica_usuarios($Sesion);
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select * from Clientes , Clientes_empresas , Presupuestos
                where Presupuestos.id_presupuesto = $id_presupuesto and
                        Presupuestos.id_cliente = Clientes.id_cliente and
                        Clientes_empresas.id_cliente = Clientes.id_cliente and
                        Clientes_empresas.id_empresa = $usuario[id]";
        //depurar_array($row);
$resul=$Sesion->query($consulta);
$row=$Sesion->fetch_array($resul);
$id_cliente = $row[id_cliente];
//descuento por familia de articulos y cliente
$consulta = "Select descuento from Cliente_familia_articulos , Articulos
             where Articulos.id_articulo = $id_art and Cliente_familia_articulos.id_empresa = $usuario[id]
             and Cliente_familia_articulos.id_cliente = $id_cliente
             and Cliente_familia_articulos.id_familia = Articulos.id_familia";
$resul2 = $Sesion->query($consulta);
$row2 = $Sesion->fetch_array($resul2);
if($row2[descuento] > 0){
    return $row2[descuento] . " %";
    }

//descuento por cliente y articulo
$consulta = "Select descuento , monto  from Cliente_articulos  where id_articulo = $id_art and id_empresa = $usuario[id] and id_cliente = $id_cliente";
$resul4 = $Sesion->query($consulta);
$row4 = $Sesion->fetch_array($resul2);
if($row4[descuento] > 0 )
        return          $row4[descuento] .  " %";
elseif($row4[monto] > 0)
        return $row4[monto] .  " &euro;";

//Promociones u ofertas
$consulta = "Select descuento , monto , oferta , nombre from Promociones where id_articulo = $id_art and id_empresa = $usuario[id]";
$resul3 = $Sesion->query($consulta);
$row3 = $Sesion->fetch_array($resul3);
//ofertas
if($row3[oferta] == 1){
        if($row3[descuento] > 0)
                return  $row3[descuento] . " %";
        elseif($row3[monto] > 0)
                return  $row3[monto] .  " &euro;";
        }
//Promociones
else
        return  $row3[nombre];

//descuento por familia de articulos
$consulta = "Select descuento from Cliente_familia_articulos , Articulos
                        where Articulos.id_articulo = $id_art and Cliente_familia_articulos.id_empresa = $usuario[id]
                        and Cliente_familia_articulos.id_cliente = $id_cliente
                        and Cliente_familia_articulos.id_familia = Articulos.id_familia";
$resul2 = $Sesion->query($consulta);
$row2 = $Sesion->fetch_array($resul2);
if($row2[descuento] > 0)
        return $row2[descuento] . " %";
}

function calcular_total_del_todo(&$Sesion,&$aDatos){
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select sum(monto_total + (monto_total * porcentaje / 100)) from Lineas_detalle , Articulos , Tipos_IVA
             where Lineas_detalle.id_presupuesto = $id_presupuesto and
             Lineas_detalle.id_articulo = Articulos.id_articulo and
             Articulos.id_iva = Tipos_IVA.id_iva";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return round($row[0],3);
}
function calcular_en_pesetas(&$Sesion,&$aDatos){
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select sum(monto_total + (monto_total * porcentaje / 100)) from Lineas_detalle , Articulos , Tipos_IVA
             where Lineas_detalle.id_presupuesto = $id_presupuesto and
             Lineas_detalle.id_articulo = Articulos.id_articulo and
             Articulos.id_iva = Tipos_IVA.id_iva";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return (int)($row[0]  * 166.38);
}
function nombre_agente2(&$Sesion,&$aDatos){
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select Agentes.nombre from Agentes , Presupuestos
                     where Presupuestos.id_presupuesto = $id_presupuesto and
                           Presupuestos.id_agente = Agentes.id_agente";
$resul=$Sesion->query($consulta);
if($row=$Sesion->fetch_array($resul))
    return $row[0];
else return "Sin agente";
}
function tiene_pedido(&$Sesion,&$aDatos){
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select distinct all Lineas_detalle.id_pedido from Lineas_detalle  , Presupuestos
                     where Presupuestos.id_presupuesto = $id_presupuesto and
                           Presupuestos.id_presupuesto = Lineas_detalle.id_presupuesto";
$resul=$Sesion->query($consulta);
if($row=$Sesion->fetch_array($resul)){
    if($row[0] != 0)
        return 1;
    else return 0;
     }
}
function dame_id_pedido(&$Sesion,&$aDatos){
$id_presupuesto = $Sesion->get_var("id_presupuesto");
$consulta = "select distinct all Lineas_detalle.id_pedido from Lineas_detalle  , Presupuestos
                     where Presupuestos.id_presupuesto = $id_presupuesto and
                           Presupuestos.id_presupuesto = Lineas_detalle.id_presupuesto";
$resul=$Sesion->query($consulta);
if($row=$Sesion->fetch_array($resul))
    if($row[0] != 0)
        return $row[0];
}
function tarifa_defecto_cliente(&$Sesion,&$aDatos){
$usuario = identifica_usuarios($Sesion);
$consulta = "select id_tarifa from Clientes_empresas
                     where id_cliente =".$aDatos["Presupuestos.id_cliente"]." and
                           id_empresa =" .$usuario[id];
$resul=$Sesion->query($consulta);
if($row=$Sesion->fetch_array($resul))
    if($row[0] != 0)
        return $row[0];
}


?>
