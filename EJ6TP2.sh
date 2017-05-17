#Ejercicio 5
#Tp N°2
#Matias Ezequiel Cairo 39670522
#Thomas Ignacio Reynoso 39332450
#Pablo Avalo 39214569
#Luciano Gabriel Tonlorenzi Sebastía 39244171
#De Rito Micaela 39547209
#Primera Entrega

#!/bin/bash

HELP="--h"
help2="--help"
help3="-?"
if [ $# -lt 2 ]
then
	if [ $# -eq 1 ]
	then
		if ([ $1 == "--h" ] || [ $1 == "--help" ] || [ $1 == "-?" ]);
		then
			echo  "Ayuda"
			exit
		else
			echo "Argumento no válido"
			exit	
		fi
	fi

	if [ $# -eq 0 ];then
		echo "Debe especificar 2 archivos como parámetro"
		exit;
	fi
fi

if test -f "$1"
then
	if test -f "$2"
	then
		sdiff $1 $2
	else
		echo "el archivo 2 no existe o no se puede leer"	
	fi
else
	echo "el archivo 1 no existe o no se puede leer"
fi






