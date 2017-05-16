#Ejercicio 6
#Tp N°2
#Matias Ezequiel Cairo 39670522
#Thomas Ignacio Reynoso 39332450
#Pablo Avalo 39214569
#Luciano Gabriel Tonlorenzi Sebastía 39244171
#De Rito Micaela 39547209
#Primera Entrega

#NAME

#	Ejercicio6.sh - Realiza un reporte de los procesos que consumen mayor tiempo de cpu.

#SYNOPSIS

#	./Ejercicio6.sh [CANT X PROC] [RUTA DE ARCHIVO] [NOMBRE USUARIO]

#DESCRIPTION

#	El siguiente script me permite realizar un reporte de X cantidad de procesos que consuman el mayor tiempo de cpu. La cant de procesos que quiero que me muestre se la paso por parámetro, así tambien como el directorio del archivo donde quiero guardar dicho reporte.
#	Opcionalmente puedo pasarle un nombre de usuario, y solo se mostraran los procesos de ese usuario.
#	Ignora la señal SIGINT, y maneja SIGUSR1 (escribir el archivo) y SIGUSR2
#	Para ejecutar el script en segundo plano escribo "&" al final de la llamada y el pasaje de parámetros.


#!/bin/bash

function escribir_proc()
{
	if [["$1"]]
	then 
		Y=`ps-$1 -l | head $2`
	else
		Y=`ps-axu -l | head $2`
	fi
clear

IFS=$'\n'
for i in $Y
do
	$i>>$3
done
DIA=`date +"%d/%m/%Y"`
HORA=`date +"%T"`
$DIA$HORA>>$3
}

function finalizar_ejec()
{
	exit
}


if test $# -gt 3 #Valido que sean 3 o menos parametros
then 
	exit
fi

if test $# -lt 2 #Valido que sean 2 o 3 parametros 
then
	exit
fi

if test -d "$1"
then
	D=$1 #Guardo el directorio donde esta el archivo
fi

if test "$2" == '^[0-9]+$' #Valido que sea un entero
then 
	X=$2 #Guardo el numero de procesos a mostrar
fi

if "$3" == "u"
then 
	U=$u #Guardo el nombre del usuario
else
	U="."
fi


trap '' SIGINT #La ignora
trap escribir_proc $U $X $D SIGUSR1
trap finalizar_ejec SIGUSR2




