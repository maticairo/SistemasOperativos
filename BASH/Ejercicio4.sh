#!/bin/bash
# -*- ENCODING: UTF-8 -*-

function ayuda {
printf "
Para invocar este script se debe escribir en consola el nombre del script y el directorio donde va a trabajar. Ejemplo: 
./Ejercicio4.sh ./Directorio
Se puede enviar como parametro -r, indicando que se ejecutara el script en las subcarpetas del directorio tambien. Ejemplo
./Ejercicio4.sh ./Directorio -r
Ademas se puede enviar -I, indicando que se guardara la informacion obtenida en un archivo. Ejemplo
./Ejercicio4.sh ./Directorio -I
Se pueden dar ambas condiciones tambien. Ejemplo: 
./Ejercicio4.sh ./Directorio -I -r
"
}

if [ $# -eq 1 ];then
	if [ "$1" == "-help" -o "$1" == "-h" -o "$1" == "-?" ]; then 
		ayuda;
		exit;
	fi
fi


var2="-r"
var3="-I"
var6="echo"
var7="-maxdepth 1"

if [ $# -eq 0 ];then
echo "Debe enviar el directorio"
exit;
fi

if [ $# -eq 3 ];then
	if ([ $2 != $var2 ] && [ $2 != $var3 ]) || ([ $3 != $var2 ] && [ $3 != $var3 ]);then
		echo "parametros invaldos"
		exit;
	fi
	var6="arch"
	var7=""
fi

if [ $# -eq 2 ];then
	if [ $2 != $var2 ] && [ $2 != $var3 ];then
		echo "Parametro 2 invalido"
		exit;
	fi
	if [ $2 == $var3 ];then
		var6="arch"
	else
		var7=""
	fi
fi

vec=( 'txt' 'exe' 'zip' 'png' )

if test -d "$1"
then
	for tipo in "${vec[@]}";
	do
		var4=$(find "$1" $var7 -type f -name "*.$tipo" | wc -l)
		var5=$(find "$1" $var7 -type f -name "*.$tipo" -exec du -chk {} + | grep total$ | cut -f 1)
			if [ $var4 -gt 0 ]; then
				if [ $var6 == "arch" ];then
					echo -e "$tipo\t$var4\t$var5 kB" >> "$1".log
				else
					echo -e "$tipo\t$var4\t$var5 kB"
				fi
			fi
	done
else
	echo "Directorio invalido"
fi
