#!/bin/bash


function ayuda {
printf "

script para realizar distintas acciones sobre un archivo de texto
\e[1mUsoa\e[0m

         	./ej3tp2.sh -a [ archivo ] [ palabras ]
		./ej3tp2.sh -d [ archivo ] 
		./ej3tp2.sh -e [ archivo ] [ palabra ]
		./ej3tp2.sh -r [ archivo ] [ nuevo_nombre ]
 
\e[1mParametros\e[0m          
		1- opcion a ejecutar 
		2- archivo sobre el cual se van a ejecutar las distintas acciones
		3- [ solo si se ejecuta -a|-r|-e ] :
	         En opcion -a : String con las palabras que se quieran añadir separadas por coma
	         En opcion -e : String con la palabra a eliminar
		 En opcion -r : String con el nuevo nombre de archivo 
		

\e[1mOpciones\e[0m
                -a 	añade al final del archivo un conjunto de palabras, cada palabra separada por un espacio.
		-d	elimina archivo.
		-e 	elima todas las ocurrencias de la palabra en el archivo.
		-r	renombra el archivo.
		               
\e[1mEjemplo\e[0m
       
               bash ./ejercicio2.sh -a  ejemplo.txt hola,que,tal

"
}
if [ "$1" = "-h" -o "$1" = "-help" -o "$1" = "-?" ] ; then ayuda ; exit ; fi
if [ "$1" != "-a" -a "$1" != "-e" -a "$1" != "-d" -a "$1" != "-r" ]
then 
echo "opcion invalida"
echo "para ayuda ejecute ./ejercicio2.sh -help"
exit
fi

if [ "$#" != '3' -a "$#" != '2' ]
then 
echo "cantidad invalida de parametros"
echo "para ayuda ejecute ./ejercicio2.sh -help"
exit
fi

if [ -f $2 ]
then
attachmenttype=$(file "$2" | cut -d' ' -f2)
if [ $attachmenttype = "ASCII" ]
then

if [ "$#" == "3" ] 
then
case $1 in
'-r')
mv $2 $3;;
'-e')
sed -i "s/$3//g" $2;;
'-a')
echo $3 >> $2
sed -i "$tail s/,/ /g" $2;; 
*)
echo 'opcion invalida '
echo 'vea la ayuda ejecutando: ./ejercicio2.sh -h ';;
esac

elif [ "$#" == '2' ] && [ "$1" == '-d' ]
then
rm $2
else 
echo 'opcion invalida'
echo 'vea la ayuda ejecutando: ./ejercicio2.sh -h '
fi

else 
echo " $2 no es un archivo de texto "
fi
else
echo 'archivo no existe'
fi

