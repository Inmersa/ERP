#!/bin/bash

CFGFILE='conf/configvars';
VERFILE='dbs/version';
VERSION=`cat $VERFILE`;
VERPATH="dbs/V$VERSION";
BKPDIR='dbs/backups';
AWK="$(which gawk|grep -v 'no gawk')";
if [ -z "$AWK" ]; then AWK="$(which awk|grep -v 'no gawk')"; fi;

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

if [ ! -d "$BKPDIR" ]; then
	echo "No se ha podido encontra el directorio de backups ($BKPDIR)";
	exit;
fi;

. $CFGFILE

if [ -z "$DBLOGIN" -o -z "$DBPW" -o -z "$MYSQL_HOST" -o -z "$DBNAME" ]; then
	echo $CFGFILE _incompleto_: vuelva a correro bin/configure.sh;
	exit;
fi;

if [ ! -z "$MYSQL_PORT" ]; then portinfo="-P $MYSQL_PORT"
else portinfo='';
fi;

echo "Listing backups for $DBNAME  ";

for d in `find $BKPDIR/* -type d | grep -v CVS | grep -v data `; do
	echo "--------------------------------------";
	echo "ID:     `echo $d | $AWK -F '/' '{{print $(NF)}}'` ";
	echo "Fecha:  `cat $d/fecha`";
	echo "Ver:    `cat $d/version` ";
done;

echo "-----------------------------------";

