#Ejercicio 1
#Tp N°2
#Matias Ezequiel Cairo 39670522
#Thomas Ignacio Reynoso 39332450
#Pablo Avalo 39214569
#Luciano Gabriel Tonlorenzi Sebastía 39244171
#De Rito Micaela 39547209
#Primera Entrega

#!/bin/bash

if test $# -gt 2
then
	exit
fi

Z="."
if test -d "$1"
then
	Z=$1
fi

if test "$2" == "u"
then
	X="-r"
else
	X=""
fi

Y=`ls -lh $Z | grep -v '^total' | sort -k 6,6 $X | head | tr-s ' ' | cut -d' ' -f5,8`

clear

IFS=$'\n'
for i in $Y
do
	echo $i
done


#RESPUESTAS

#a. La primer línea indica que vamos a interpretar nuestro Script como uno de Bash.

#b. Para otorgarle permisos al Script, debo ejecutar el comando chmod 740. Con este le estoy dando permisos de lectura, escritura y ejecucion (r, w, x) al usuario propietario del Script, y le doy permiso de lectura al "grupo".

#c. Las variables $1 y $2 son los parámetros que le pasamos al script.En este caso, $1 representará un directorio donde se encontrará el archivo a analizar, y $2 si recibe el valor de "u", me generará un archivo con el resultado de las comparaciones invertidas, caso contrario, lo generará de la manera estándar.
#   Variables similares son "$#" que me devuelve la cantidad de parámetros que recibió el script, "$*" y "$@" me devuelven todos los parámetros, "$?" me dice si el comando se ejecutó correctamente, etc.

#d.  IFS es el separador de palabras, en este caso lo cambio a '\n' para que realice el salto de línea y coloque una palabra debajo de la otra.

#e.  El error que encuentro es al listar los archivos. Si envio por parametro un directorio con espacios, no lo reconoce. Para esto debo poner la variable $Z entre comillas. Solucion: 
# Y=`ls -lh "$Z" | grep -v '^total' | sort -k 6,6 $X | head | tr-s ' ' | cut -d' ' -f5,8`

#Para obtener una mejor visualizacion se podria agregar el nombre del archivo al listado, para esto deberia modificar la linea que lista los elementos de esta forma: 
# Y=`ls -lh $Z | grep -v '^total' | sort -k 6,6 $X | head | tr-s ' ' | cut -d' ' -f5,8,9`

#f.  El objetivo del script es listar el peso y la hora de modificacion del contenido de un directorio (que envio por parametro o en el que ejecuto el script). Lista los primeros 10 elementos, en el orden de modificacion por mes (del mas antiguo al mas nuevo o viceversa, dependiendo si envio o no un parametro)

#g.  En "if test $# -gt 2" Se evalúa si la cantidad de parámetros que le pasamos al script es mayor a 2.
#    En "if test -d "$1"" Se valida si el parámetro 1 es un directorio y existe.
#    En "if test "$2" == "u"" se valida si el contenido del parámetro 2 es "u"

#h.  ls: devuelve el contenido de un archivo, si no le paso ninguno, toma el directorio en el que nos encontramos ubicados.
#    grep: sirve para filtrar contenido de algun archivo.
#    sort: ordena el texto de un archivo.
#    tr: transforma o elimina caracteres.
#    head: muestra las primeras N lineas de un archivo (10 por default)
#    cut: divide un archivo en varias columnas.
