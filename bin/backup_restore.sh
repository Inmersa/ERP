#!/bin/bash

CFGFILE='conf/configvars';
VERFILE='dbs/version';
VERSION=`cat $VERFILE`;
VERPATH="dbs/V$VERSION";
BKPDIR='dbs/backups';
MDUMP=`which mysqldump|grep -v 'no mysqldump'`;
MCLIENT=`which mysql|grep -v 'no mysql'`;
AWK="$(which gawk|grep -v 'no gawk')";
if [ -z "$AWK" ]; then AWK="$(which awk|grep -v 'no awk')"; fi;

QUIET=0;

parse_arguments() {
	for arg do
		case "$arg" in
			-q|--quiet=*)
				QUIET=1;
				shift;
			;;
		esac
	done;
	id=${@:${#@}}
#ULTIMO parametro ${@:${#@}} donde ${#@} es el numero de parametros.
}

parse_arguments "$@"

if [ -z "$id" ]; then
	echo "Usage: $0 <ID backup>";
	exit;
fi;

if [ ! -x "$MCLIENT" ]; then
	echo "Error: mysqldump no se encuentra en el PATH, o no es un ejecutable";
	exit;
fi;

if [ ! -f "$CFGFILE" ]; then
	echo "Error: Fichero de configuracion ($CFGFILE) Not Found ";
	exit;
fi;

if [ ! -f "$VERFILE" ]; then
	echo "No se ha encontrado la version actual de la bdd ($VERFILE)";
	exit;
fi;

if [ ! -d "$VERPATH" ]; then
	echo "No se ha encontrado el directorio de la version actual de la bdd ($VERPATH)";
	exit;
fi;

if [ ! -d "$BKPDIR/$id" ]; then
	echo "No se ha podido crear el ID backup ($id)";
	exit 1;
fi;

. $CFGFILE

if [ -z "$DBLOGIN" -o -z "$DBPW" -o -z "$MYSQL_HOST" -o -z "$DBNAME" ]; then
	echo $CFGFILE _incompleto_: vuelva a correro bin/configure.sh;
	exit;
fi;

if [ ! -z "$MYSQL_PORT" ]; then portinfo="-P $MYSQL_PORT"
else portinfo='';
fi;

BKPDIRTS="$BKPDIR/$id/";

if [ ! -d "$BKPDIRTS/data" ]; then
#echo "ls $BKPDIRTS/$id.* | $AWK -F '/' '{{print ($NF)}}'";
	for f in `ls $BKPDIRTS/$id.* | $AWK -F '/' '{{print ($NF)}}'`; do
		ext=`echo $f|$AWK -F '.' '{{print ($NF)}}'`;
		if [ "$ext" == "tbz2" ]; then
			taropts='-xjf';
		else
			if [ "$ext" == "tgz" ]; then
				taropts='-xzf';
			else
				taropts='-xf';
			fi;
		fi;
		if [ ! -z "$taropts" ]; then
			tar -C $BKPDIRTS $taropts $BKPDIRTS/$f
		fi;
	done;
fi;

if [ ! -d "$BKPDIRTS/data" ]; then
	echo "No se ha podido regenerar la estructura en $BKPDIRTS/data/ ";
	exit;
fi;

if [ $QUIET -eq 0 ]; then 
	echo "------- Restoring Backup --------";
	echo "ID:     $id ";
	echo "Fecha:  `cat $BKPDIRTS/fecha`";
	echo "Ver:    `cat $BKPDIRTS/version` ";
	echo "---------------------------------";
fi; 

for f in `ls $BKPDIRTS/data/ `; do
	if [ $QUIET -eq 0 ]; then echo -n "Restoring $f ... "; fi;
	cat $BKPDIRTS/data/$f | $MCLIENT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo $DBNAME 
	if [ $QUIET -eq 0 ]; then echo " ok"; fi;
done;


if [ $QUIET -eq 0 ]; then echo "Done. "; fi;

