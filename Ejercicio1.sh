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

#b. Para otorgarle permisos a mi Script, primero debo ser super usuario. Para poder hacerlo, en la terminal ejecuto el comando "sudo su" e ingreso mi contraseña. Una vez hecho esto, ejecuto el comando "chmod 740 nombredelarchivo.sh". (Siempre que mi script se encuentre en mi carpeta personal).
#   De esta manera le hemos otorgado a nuestro script para los "usuarios" todos los permisos(r,w,x) , para los "grupos" solo lectura, y para "otros" ningun permiso.

#c. Las variables $1 y $2 son los parámetros que le pasamos al script.En este caso, $1 representará un directorio donde se encontrará el archivo a analizar, y $2 si recibe el valor de "u", me generará un archivo con el resultado de las comparaciones invertidas, caso contrario, lo generará de la manera estándar.
#   Variables similares son "$#" que me devuelve la cantidad de parámetros que recibió el script, "$*" y "$@" me devuelven todos los parámetros, "$?" me dice si el comando se ejecutó correctamente, etc.

#d.  IFS es el separador de palabras, en este caso lo cambio a '\n' para que realice el salto de línea y coloque una palabra debajo de la otra.

#e.  No encuentro ningun error en cuanto a sintaxis, por lo que yo interprete que hace el script, no considero que haya ningun error.

#f.  El objetivo del script es filtrar un archivo que le paso por parámetro, y mostrar en forma de lista, uno abajo del otro las diez primeras filas con los pesos de los archivos ordenados.

#g.  En "if test $# -gt 2" Se evalúa si la cantidad de parámetros que le pasamos al script es mayor a 2.
#    En "if test -d "$1"" Se valida si el parámetro 1 es un directorio y existe.
#    En "if test "$2" == "u"" se valida si el contenido del parámetro 2 es "u"

#h.  ls: devuelve el contenido de un archivo, si no le paso ninguno, toma el directorio en el que nos encontramos ubicados.
#    grep: sirve para filtrar contenido de algun archivo.
#    sort: ordena el texto de un archivo.
#    tr: transforma o elimina caracteres.
#    head: muestra las primeras 10 filas de un archivo.
#    cut: divide un archivo en varias columnas.
