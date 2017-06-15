<# Trabajo Práctico 1
Ejercicio 2
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 

.SYNOPSIS
    
    Lee URL's de un archivo y realiza las descargas.
    
.DESCRIPTION
   
    Este script nos permite realizar descargas a través del archivo con el listado de URL's que le pasaremos por parámetro.
    Al realizarlas se generará un archivo de log donde se indicará la hora de inicio, el tiempo insumido, y el tamaño de cada archivo.
    Por parámetros le debemos pasar el Path del archivo de descargas, el Path del directorio donde se guardarán las descargas, y opcionalmente,
    el Path donde se guardará el archivo de log (De otra manera se generará en el directorio del archivo de descargas).
    
.NOTES

    Cada una de las URL's del archivo de lectura deberán finalizar con "/".
#>


Param(
      [Parameter(Mandatory=$true)]
      [string] $pathLectura, 
      
      [Parameter(Mandatory=$true)]
      [string]$pathSalida, 
      
      [string]$pathLog
     )
#Leo las Urls
$lineas=Get-Content $pathLectura;
#Instancio el WebClient
$obj=New-Object System.Net.WebClient;
foreach($linea in $lineas)
{
    #Obtengo el nombre del archivo a descargar
    $ultimaBarra=$linea.LastIndexOf('/')
    $ultimaBarra++
    $arch=$linea.substring($ultimaBarra)
    #Concateno el directorio de salida con el nombre de archivo correspondiente
    $pathSalidaFinal="$($pathSalida)$($arch)"
    #tomo la hora de inicio
    $horaInicio=Get-Date
    #descargo la url en el directorio con el nombre correspondiente
    $obj.DownloadFile($linea, $pathSalidaFinal)
    #Tomo la hora de fin
    $horaFin=Get-Date
    #calculo el tiempo restando hora de fin con hora de inicio
    $tiempoTotal=$horaFin.Subtract($horaInicio)
    #obtengo el archivo para consultar su tamaño a la hora de imprimir
    $archivo=Get-Item $pathSalidaFinal
    #Armo la linea a imprimir en el log
    $imprimir="$($horaInicio) | $($horaFin) | $($tiempoTotal) | $($archivo.Length) Bytes"
    #imprimo el log efectivamente
    if($pathLog -eq $null)
    {
        $imprimir | Out-File "$($pathSalida)salida.log" -Append
    }
    else{
        
        $imprimir | Out-File "$($pathLog)salida.log" -Append
    }
    
}

#FIN
