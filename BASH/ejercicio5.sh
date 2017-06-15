#!/bin/bash


function ayuda {
printf "
Script para comparar dos archivos de texto. En la ejecución por defecto (sin parámetros adicionales más que los dos archivos de texto a analizar) muestra:

	-Por cada archivo: 
		-Cantidad de líneas.
		-Cantidad de palabras.
		-Cantidad de espacios.
		-La palabra con mayor ocurrencia.

	-Entre ambos archivos:
		-Si son iguales o si hay diferencias.
\e[1mUso\e[0m
         	./ejercicio5.sh [ archivo1 ] [ archivo2 ]
		./ejercicio5.sh [ archivo1 ] [ archivo2 ] -L 
		./ejercicio5.sh [ archivo1 ] [ archivo2 ] -P [ Palabra 1] ... [ Palabra N ]
		./ejercicio5.sh [ archivo1 ] [ archivo2 ] -L -P [ Palabra 1] ... [ Palabra N ]
 
\e[1mParametros\e[0m          
		1- Primer archivo a analizar 
		2- Segundo archivo a analizar
		3- [ si se ejecuta -L | -P ] :
	         En opcion -L : 
	         En opcion -P : String con las palabras a buscar en los dos archivos
		
\e[1mOpciones\e[0m
                -L 	Indica cantidad de lineas iguales entre los dos archivos.
		-P	Indica cuáles de las palabras seguidas por el parámetro -P se encuentran en los dos archivos.
		-h 	Muestra la ayuda
		               
\e[1mEjemplo\e[0m
       
               bash ./ejercicio5.sh archivo1.txt archivo2.txt -L -P hola que tal
"
}
#si la cantidad de parámetros es menor a 2 valido que tenga que mostrar la ayuda
if [ $# -lt 2 ]
then
	if [ $# -eq 1 ]
		then
			if [ "$1" = "-h" -o "$1" = "-help" -o "$1" = "-?" ] ; then ayuda ; exit ;
			else
				echo "Argumento inválido"
				echo "Para ver la ayuda ejecute ./ejercicio5.sh -help"
				exit
			fi
	fi
	if [ $# -eq 0 ]
	then
		echo "Debe especificar 2 archivos como parámetro"
		echo "Para ver la ayuda ejecute ./ejercicio5.sh -help"
		exit
	fi
fi

#aca valido que los archivos se puedan leer
if [ -r "$1" ] && [ -r "$2" ]
then
	filename1=$(basename "$1")
	extension1=$(echo $filename1 |awk -F . '{if (NF > 1) {print $NF}}')
	filename2=$(basename "$2")
	extension2=$(echo $filename2 |awk -F . '{if (NF > 1) {print $NF}}')
	#valido que los archivos sean .txt
	if [ "$extension1" == "txt" ] && [ "$extension2" == "txt" ]
	then
		#por cada archivo muestro: cantidad de lineas, de palabras, de espacios, palabra de mayor ocurrencia	
		echo "$filename1"	
		echo -e "\e[34mCantidad de líneas: $(wc -l $1 | cut -d' ' -f1)\e[0m"	#wc -l $1 me devuelve la cantidad de lineas del arch 1 así "N archivo1.txt", para dejar N corto en el espacio el campo 1 (cut -d' ' -f1) y lo muestro con color azul
		echo -e "\e[34mCantidad de palabras: $(wc -w $1 | cut -d' ' -f1)\e[0m"
		echo -e "\e[34mEspacios en blanco: $(cat $1 | grep -o " " | wc -l)\e[0m"
		printf '%s : %s\n' "$(grep -Eo '[[:alnum:]]+' "$1" | sort | uniq -c | sort -rn | head -n1)" "$file" #palabra más usada REVISAR


		echo "$filename2"	
		echo -e "\e[34mCantidad de líneas: $(wc -l $2 | cut -d' ' -f1)\e[0m"
		echo -e "\e[34mCantidad de palabras: $(wc -w $2 | cut -d' ' -f1)\e[0m"
		echo -e "\e[34mEspacios en blanco: $(cat $2 | grep -o " " | wc -l)\e[0m"
		printf '%s : %s\n' "$(grep -Eo '[[:alnum:]]+' "$2" | sort | uniq -c | sort -rn | head -n1)" "$file" #palabra más usada REVISAR


		#muestro las diferencias

		iguales=$(sdiff -s $1 $2)
		if [ "$iguales" == "" ]
		then
			echo -e "\e[32mLos archivos son iguales\e[0m" #imprimo en verde
		else
			echo -e "\e[31mLos archivos son diferentes: \e[0m" #imprimo en rojo
			echo "$filename1							$filename2"
			sdiff $1 $2
			fi
		if [ $# -gt  2 ]
		then
			case $3 in
			'-L')
				#Muestro la cantidad de lineas IGUALES entre ambos archivos
				cant_lineas_ig=$(awk 'a[$0]++' $1 $2 | wc -l)
				echo "Cantidad de líneas iguales: $cant_lineas_ig";;
			'-P')
				#indico cuantas palabras despues de -P aparecen en ambos archivos NO FUNCIONA
				echo "caso -P";;
			*)
				echo 'Argumento inválido '
				echo 'vea la ayuda ejecutando: ./ejercicio5.sh -h ';;
			esac
			if [ $# -gt  3 ]
			then
				if [ "$3" == '-L' ] && [ "$4" == '-P' ]
				then
					echo "Caso -P"
				else
					echo "Parámetro 4 no válido"
					echo "Para ver la ayuda ejecute ./ejercicio5.sh -help"
					exit
				fi
			fi
		fi
	else
		echo "Uno de los archivos especificados no es de texto"
		echo "Para ver la ayuda ejecute ./ejercicio5.sh -help"
		exit
	fi

else
	echo "Uno de los archivos especificados no se puede leer"
	echo "Para ver la ayuda ejecute ./ejercicio5.sh -help"
fi
