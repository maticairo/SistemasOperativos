#LEER BIEN EL ENUNCIADO PARA VER QUE FALTA!
#Hay que validar parametros y poner la ayuda para Get-Help - ver enunciado

Param([Parameter(Mandatory=$true)]
      [string] $pathLectura, 
      [Parameter(Mandatory=$true)]
      [string]$pathSalida, 
      $pathLog)
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