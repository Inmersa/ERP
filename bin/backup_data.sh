#!/bin/bash

CFGFILE='conf/configvars';
VERFILE='dbs/version';
BKPDIR='dbs/backups';

VERSION=`cat $VERFILE`;
VERPATH="dbs/V$VERSION";
BKPTS=`date +"%Y%m%d%H%M%S"`;
BKPDATE=`date -u`;
arch="$(which arch|grep -v 'no arch')";
MDUMP=`which mysqldump|grep -v 'no mysqldump'`;
AWK=$(which gawk|grep -v 'no gawk');
if [ -z "$AWK" ]; then AWK=$(which awk|grep -v 'no awk'); fi;

MDUMP_OPT="--compatible=mysql323,no_table_options --skip-opt"

# En realidad es dependiente de version mysql. la 3.23.32 no lo trae
if [ "`$arch`" == "sun4" ]; then MDUMP_OPT=''; fi;

mdumpver=`$MDUMP --version | $AWK '{{print $3}}'|$AWK -F '.' '{{print $1}}' `;
if [ "$mdumpver" -lt "10" ]; then
	MDUMP_OPT='';
fi;

ENTIDADES='entidades.list';
MAESTROS='maestros.list';
AWK="$(which gawk|grep -v 'no gawk')";
if [ -z "$AWK" ]; then AWK="$(which awk|grep -v 'no awk')"; fi;

# Valores por defecto:
QUIET=0;

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

if [ ! -f "$VERFILE" ]; then
	echo "No se ha encontrado la version actual de la bdd ($VERFILE)";
	exit;
fi;

if [ ! -d "$VERPATH" ]; then
	echo "No se ha encontrado el directorio de la version actual de la bdd ($VERPATH)";
	exit;
fi;

if [ ! -f "$VERPATH/$ENTIDADES" ]; then
	echo "No hay tablas para hacer backup ($VERPATH/$ENTIDADES)"
	exit;
fi;

if [ ! -f "$VERPATH/$MAESTROS" ]; then
	MAESTROS='';
fi;

if [ ! -d "$BKPDIR" ]; then
	mkdir $BKPDIR;
fi;

if [ ! -d "$BKPDIR" ]; then
	echo "No se ha podido crear el directorio de backups ($BKPDIR)";
	exit;
fi;

if [ ! -x "$MDUMP" ]; then
	echo "Error: mysqdump no se encuentra en el PATH, o no es un ejecutable";
	exit;
fi;

. $CFGFILE

if [ -z "$DBLOGIN" -o -z "$DBPW" -o -z "$MYSQL_HOST" -o -z "$DBNAME" ]; then
	echo $CFGFILE _incompleto_: vuelva a correr bin/configure.sh;
	exit;
fi;

if [ ! -z "$MYSQL_PORT" ]; then portinfo="-P $MYSQL_PORT"
else portinfo='';
fi;

BKPDIRTS="$BKPDIR/$BKPTS/";
if [ ! `mkdir $BKPDIRTS && echo 1` ]; then 
	echo No se ha podido crear $BKPDIRTS; 
	exit 1;
fi;
if [ ! `mkdir $BKPDIRTS/data && echo 2` ]; then
	echo No se ha podido crear $BKPDIRTS/data ; 
	exit 1;
fi;
cp $VERFILE $BKPDIRTS;
echo $BKPDATE > $BKPDIRTS/fecha; 
if [ $QUIET -ne 1 ]; then echo "Creating backup for $DBNAME on `cat $BKPDIRTS/fecha`"; fi;

if [ ! -z "$ENTIDADES" ]; then
	for t in `cat $VERPATH/$ENTIDADES`; do
		if [ $QUIET -ne 1 ]; then echo -n "Entidad: $t ... "; fi;
		if [ ! -f $BKPDIRTS/data/$t.sql ]; then
			echo "DELETE FROM $t;" > $BKPDIRTS/data/$t.sql;
		fi;
		$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t -c $DBNAME $t >> $BKPDIRTS/data/$t.sql ;
		if [ $QUIET -ne 1 ]; then echo "ok"; fi;
	done;
fi;

if [ ! -z "$MAESTROS" ]; then
	for t in `cat $VERPATH/$MAESTROS`; do
		if [ $QUIET -ne 1 ]; then echo -n "Maestro: $t ... "; fi;
		clave=`$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -d $DBNAME $t | grep 'PRIMARY KEY' | $AWK -F '(' '{{print $2}}' | $AWK -F ')' '{{print $1}}' | $AWK -F ' ' '{{print $1}}'`;
		echo "DELETE FROM $t;" > $BKPDIRTS/data/$t.sql;
		$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t -c --where="$clave=0" $DBNAME $t >> $BKPDIRTS/data/$t.sql ;
		echo "UPDATE $t SET $clave = 0 WHERE $clave = LAST_INSERT_ID();" >> $BKPDIRTS/data/$t.sql ;
		$MDUMP $MDUMP_OPT -u $DBLOGIN --password=$DBPW -h $MYSQL_HOST $portinfo -t -c --where="$clave!=0" $DBNAME $t >> $BKPDIRTS/data/$t.sql ;
		if [ $QUIET -ne 1 ]; then echo "ok"; fi;
	done;
fi;

if [ -x "`which bzip2|grep -v 'no bzip2'`" ]; then
	taropts='-cjf';
	tarext='tbz2';
else
	if [ -x "`which gzip|grep -v 'no gzip'`" ]; then 
		taropts='-czf';
		tarext='tgz';
	else 
		taropts='-cf';
		tarext='tar';
	fi;
fi;

if [ $QUIET -ne 1 ]; then echo -n "Comprimiendo datos ... "; fi;
#tar -C $BKPDIRTS $taropts $BKPDIRTS/$BKPTS.$tarext data/
if [ $QUIET -ne 1 ]; then echo " ok"; fi;

if [ $QUIET -ne 1 ]; then echo "Done. " ; fi;

if [ $QUIET -eq 1 ]; then echo $BKPTS; fi;
