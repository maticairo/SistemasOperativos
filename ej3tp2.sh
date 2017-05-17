#Ejercicio 3
#Tp N°2
#Matias Ezequiel Cairo 39670522
#Thomas Ignacio Reynoso 39332450
#Pablo Avalo 39214569
#Luciano Gabriel Tonlorenzi Sebastía 39244171
#De Rito Micaela 39547209
#Primera Entrega

#!/bin/bash

### Ayuda


function ayuda {
printf "
\e[1mUso\e[0m

         	./ej3tp2.sh [fecha_mínima] [fecha_máxima] [nom_comprimido] [directorio_destino] [directorio_origen]
 
\e[1mParametros\e[0m          
		2 fechas (rango para buscar archivos), 
		1 un string con el nombre del directorio donde se comprimiran el/los archivos,
		1 directorio donde se alojaran el/los archivos archivos_a_comprimir
		[Opcional] 1 directorio donde se buscaran los archivos a comprimir

\e[1mDescripción\e[0m
                Lee los archivos que cumplen con un formato especificado (En este caso son .txt) que se encuentren en un rango de fechas, luego mueve dichos archivos a un directorio, el cual luego es comprimido y movido al [directorio_destino] pasado por parametro. Tambien se crea un archivo.log con los archivos archivos_a_comprimir
               
\e[1mEjemplo\e[0m
       
               bash ./ej3tp2.sh 10/05/2017 12/05/2017 compri /Escritorio

\e[1mNOTA\e[0m
	
		La fecha del find esta hardcodeada ya que no encuentro la manera de que el newermt me lea la fecha pasada por parametro, todas las soluciones que encontre, no pude implementarlas! \n\n"

}


if [ "$1" = "-h" -o "$1" = "-help" -o "$1" = "-?" ] ; then ayuda ; exit ; fi

### pregunto si algunos de los argumentos estan vacios y muestro el mensaje correspondiente

if [ -z $1 ];then
  echo "No se ingreso la fecha minima."
  exit 0
fi

if [ -z $2 ];then
  echo "No se ingreso la fecha maxima."
  exit 0
fi

if [ -z $3 ];then
  echo "No se ingreso el nombre del archivo comprimido."
  exit 0
fi

if [ -z $4 ];then
  echo "No se ingreso el directorio destino."
  exit 0
fi

#Parametro opcional 

if [ -z $5 ];then
  directorio_origen=./
else
  directorio_origen=$5
fi

#***Intentos de transformar la fecha para que el find las pueda leer ***

#fecha_minima=$(echo $1 | awk '{split($1,a,"-");$1=a[3]"/"a[2]"/"a[1]}1')
#fecha_maxima=$(echo $2 | awk '{split($2,a,"-");$2=a[3]"/"a[2]"/"a[1]}1')

#fecha_minima= $(date -d "$1" +"%F")
#fecha_maxima= $(date -d "$2" +"%F")


nombre_comprimido=$3
directorio_destino=$4

#se crea el directorio donde se moveran los archivos a comprimir 
mkdir a_comprimir
touch $nombre_comprimido.log
for i in ` find $directorio_origen/*.txt -type f -newermt "2017-05-10" ! -newermt "2017-05-20" `; do
  mv $i ./a_comprimir
  nombre=$(basename "$i")
  echo  $nombre >> $nombre_comprimido.log
done

tar -czf $nombre_comprimido.tar.gz ./a_comprimir
rm -r a_comprimir
mv $nombre_comprimido.tar.gz $directorio_destino
mv $nombre_comprimido.log $directorio_destino
