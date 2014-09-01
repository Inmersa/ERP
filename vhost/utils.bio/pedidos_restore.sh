#!/bin/bash

CFGFILE='../conf/configvars';
DBNAME_ORIG='betatest_gestion';
DBNAME_DEST='biomundo_gestion';

arch="$(which arch|grep -v 'no arch')";
MDUMP=`which mysqldump|grep -v 'no mysqldump'`;
MCLIENT=`which mysql|grep -v 'no mysql'`;
AWK=$(which gawk|grep -v 'no gawk');
if [ -z "$AWK" ]; then AWK=$(which awk|grep -v 'no awk'); fi;

MDUMP_OPT="--compatible=mysql323,no_table_options --skip-opt"

# En realidad es dependiente de version mysql. la 3.23.32 no lo trae
if [ "`$arch`" == "sun4" ]; then MDUMP_OPT=''; fi;

mdumpver=`$MDUMP --version | $AWK '{{print $3}}'|$AWK -F '.' '{{print $1}}' `;
if [ "$mdumpver" -lt "10" ]; then
	MDUMP_OPT='';
fi;

parse_arguments() {
	for arg do
		case "$arg" in
			-q|--quiet=*)
				QUIET=1;
			;;
		esac
	done;
#ULTIMO parametro ${@:${#@}} donde ${#@} es el numero de parametros.
}

parse_arguments "$@"

if [ ! -f "$CFGFILE" ]; then
	echo "Error: Fichero de configuracion ($CFGFILE) Not Found ";
	exit;
fi;
. $CFGFILE
if [ -z "$DBLOGIN" -o -z "$DBPW" -o -z "$MYSQL_HOST" -o -z "$DBNAME" ]; then
	echo $CFGFILE _incompleto_: vuelva a correr esto.sh;
	exit;
fi;


if [ ! -z "$MYSQL_PORT" ]; then portinfo="-P $MYSQL_PORT"
else portinfo=''; fi;

#$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t -c $DBNAME $t >> $BKPDIRTS/data/$t.sql ;
#cat $BKPDIRTS/data/$f | $MCLIENT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo $DBNAME 
ID=113636
OUTFILE=pedidos.sql

for id in `echo "SELECT id_pedido FROM Pedidos WHERE id_pedido >= $ID " | $MCLIENT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo $DBNAME_ORIG | grep -v id_pedido`; do 
	echo $id;
	$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t --where="id_pedido=$id" -c $DBNAME_ORIG Pedidos | grep INSERT | sed -e "s/($id,/(NULL,/" >> $OUTFILE
	echo "SELECT @id:=LAST_INSERT_ID(); " >> $OUTFILE;
	$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t --where="id_pedido=$id" -c $DBNAME_ORIG IVAs | grep INSERT | sed -e "s/,$id,/,@id,/" >> $OUTFILE
	regex='';
	for idDesc in `echo "SELECT id_descuento FROM Descuentos WHERE id_pedido = $id "|$MCLIENT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo $DBNAME_ORIG | grep -v id_descuento`; do
		echo "id-Desto : $idDesc ";
		$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t --where="id_descuento=$idDesc" -c $DBNAME_ORIG Descuentos | grep INSERT | sed -e "s/,$id,/,@id,/" | sed -e "s/($idDesc,/(NULL,/" >> $OUTFILE
	done;
	for idDet in `echo "SELECT id_detalle FROM Lineas_detalle WHERE id_pedido = $id "|$MCLIENT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo $DBNAME_ORIG | grep -v id_detalle`; do
		echo "idDet : $idDet ";
		#$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t --where="id_detalle=$idDet" -c $DBNAME_ORIG Lineas_detalle | grep INSERT | sed -e "s/($id,/(@id,/" | sed -e "s/,$idDet,/,NULL,/" ;
		$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t --where="id_detalle=$idDet" -c $DBNAME_ORIG Lineas_detalle | grep INSERT | sed -e "s/($id,/(@id,/" | sed -e "s/,$idDet,/,NULL,/" >> $OUTFILE;
	done;
	echo "-- " >> $OUTFILE
done;


