#!/bin/bash

#	Ejercicio 5 - Trabajo Practico 2
#	Integrantes:
#		Matias Ezequiel Cairo 39670522
#		Thomas Ignacio Reynoso 39332450
#		Pablo Avalo 39214569
#		Luciano Gabriel Tonlorenzi Sebastía 39244171
#		Micaela Rocío De Rito 39547209 


function ayuda {
echo "La sintaxis para ejecutar el script es la siguiente: "
echo "\"./Ejercicio5.sh\" \"archivoA\" \"archivoB\" [L|P] [string]"
exit 1
}

if test $1 = "-h"; then #Si el primer parametro  es -h entonces ayuda
	ayuda
fi

if test $1 = "-?"; then
	ayuda
fi

if test $1 = "-help"; then
	ayuda
fi

if [[ ! -f $1 ]]; then
   echo "ERROR: El parametro 1 no es un archivo"
   ayuda
elif [[ ! -f $2 ]]; then
   echo "ERROR: El parametro 2 no es un archivo"
   ayuda
fi

var=$#  #Guardo cantidad de parametros ingresados
var1=2 #Sumo los tres parametros obligatorios


diff --brief <(sort $1) <(sort $2) >/dev/null  #El comando diff compara las entradas y guarda el resultado en comparacion
comparacion=$? 
if [ $comparacion -eq 1 ]; then 
echo "son diferentes"
else 
echo "son iguales"
fi

#Para el primer archivo

CantidadPalabras=$(wc -w $1 | awk 'BEGIN{
				FS= " "   #File separator espacio en blanco
				}
			END{
				print $1				
				}')
			 #cuento cantidad de palabras
echo "El archivo $1 contiene:"
echo " "
echo "$CantidadPalabras palabras"
Clineas=$(cat $1 |awk 'END{print NR}') #Cantidad de lineas
echo "$Clineas lineas"
CantidadBlancos=$(grep -o ' ' $1| wc -l) #Cantidad de espacios
echo "$CantidadBlancos blancos"
#Cuento cantidad de ocurrencia de una palabra

echo "La palabra con mas apariciones del archivo $1 es: "
cat $1 | awk 'BEGIN {
			FS=" ";
			}
			{
				for (i=1;i<=NF;i++){  #Recorre hasta el fin de cada linea leida
				palabra[$i]++
				}	
				pmax=$1;
				cmax=palabra[$1];	
			}
		END{	
			for( p in palabra){
				if( palabra[p]>cmax){
					pmax=p;
					cmax=palabra[p];
				}
			}
			printf ("%s %d veces\n",pmax,cmax);
			
			}'
#Para el segundo archivo
CantidadPalabras=$(wc -w $2 | awk 'BEGIN{
				FS= " "
				}
			END{
				print $1				
				}')
			 #cuento cantidad de palabras
echo " "
echo "El archivo $2 contiene:"
echo " " 
echo "$CantidadPalabras palabras"
Clineas2=$(cat $2 | awk 'END{print NR}')   
echo "$Clineas2 lineas"
CantidadBlancos2=$(grep -o ' ' $2| wc -l) #Aca guardo la cantidad de espacios
echo "$CantidadBlancos2 blancos"
echo "La palabra mas recurrente del archivo $2 es: "
cat $2 | awk 'BEGIN {
			FS=" ";
			}
			{
				for (i=1;i<=NF;i++){
				palabra[$i]++
				}	
				pmax=$1;
				cmax=palabra[$1];	
			}
		END{	
			for( p in palabra){
				if( palabra[p]>cmax){
					pmax=p;
					cmax=palabra[p];
				}
			}
			printf ("%s %d veces\n",pmax,cmax);
			
			}'

	if [ "$3" == '-L' ] || [ "$4" == '-L' ]; then
		var1=$((var1+1))
		# Compara los archivos y muestra las lineas  que se repiten  
		echo " "
		echo "Lineas que se repiten en ambos archivos:"
		echo " "		
		awk 'NR==FNR{a[$0];next} $0 in a' $1 $2
	fi
	if [ "$3" == '-P' ] || [ "$4" == '-P' ]; 
	then
 		var1=$((var1+1))
				if [ "$var" -gt "$var1" ];  
				then
				a=$( awk 'NR==FNR{a[$0];next} $0 in a' $1 $2 )
				var1=$((var1+1))
				echo " "
				echo "Palabras que se repiten en ambos archivos:"				
				echo " "
				for i in ${@:var1}
					do
					flag=`echo $a | grep -c "$i" `;

					if [ $flag -gt 0 ];then

    						echo "$i";

					fi
					done	
		    		elif [ "$var" -eq "$var1" ]; 
				then
		    			echo "No se ingresaron palabras a buscar"
		     		fi      																			
fi

