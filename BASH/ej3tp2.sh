#Ejercicio 3
#Tp N°2
#Matias Ezequiel Cairo 39670522
#Thomas Ignacio Reynoso 39332450
#Pablo Avalo 39214569
#Luciano Gabriel Tonlorenzi Sebastía 39244171
#De Rito Micaela 39547209
#Segunda Entrega

#!/bin/bash

### Ayuda

script_name=$(basename "$0")

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
       
               bash ./ej3tp2.sh 10-05-2017 12-05-2017 compri /home/su_usuario/Escritorio
\e[1mNOTA\e[0m"
		"su_usuario es el nombre que posee su maquina" 
}


function dateIsValid(){
	if [[ $1 =~ ^[0-9]{4}[0-9]{2}[0-9]{2}$ ]] && date -d "$1" >/dev/null; then
	      return 0
	fi
	return 1
}



# Validaciones de parametros

if [ "$1" = "-h" -o "$1" = "-help" -o "$1" = "-?" ] ; then ayuda ; exit ; fi

if [[ $# -lt 4 ]] || [[ $# -gt 5 ]]; then
	echo "Cantidad ingresada de parametros errónea. Por favor ingrese entre 4 y 5. Ejecute el comando -h para mas ayuda!"
fi

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

# Convierto las fechas a formato YYYYMMDD

fecha_desde=`echo $1 | awk -F - '{print $3$2$1}'`
fecha_hasta=`echo $2 | awk -F - '{print $3$2$1}'`

#Valido que las fechas ingresadas sean correctas

if ! dateIsValid $fecha_desde; then
	echo "La fecha mínima es incorrecta"
	exit 0
fi
	
if ! dateIsValid $fecha_hasta; then
	echo "La fecha máxima es incorrecta"
	exit 0
fi

if [[ $fecha_desde > $fecha_hasta ]]; then
	echo "La fecha mínima debe ser menor a la fecha máxima"
	exit 0
fi


nombre_comprimido=$3
directorio_destino=$4

log_file="$directorio_destino/$nombre_comprimido.log"
zip_file="$directorio_destino/$nombre_comprimido.tar.gz"

#Busco los archivos en el rango de fechas dado

find $directorio_origen -type f -newermt $fecha_desde ! -newermt $fecha_hasta -printf "%P\n" > $log_file


#Verifico si el directorio donde se encuentran los archivos a comprimir, esta vacio o no

if [ "$(ls -A $directorio_origen)" ]; then
	
	# Comprimo y elimino usando el archivo log generado anteriormente
	
	if [[ -s "$log_file" ]]; then
		tar czf "$zip_file" -C "$directorio_origen" -T "$log_file" --exclude $script_name --remove-files
	else
		rm "$log_file"
	fi
else 

	echo "El directorio a comprimir esta vacio"

fi

exit 0
