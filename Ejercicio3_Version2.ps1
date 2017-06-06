<#Trabajo PrÃ¡ctico 1
Ejercicio 3
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi SebastÃ­a 39244171
Micaela RocÃ­o De Rito 39547209 
#>

<#

.SYNOPSIS
    
    Elimina archivos duplicados
    
.DESCRIPTION
   
    Este script nos permite eliminar los archivos duplicados del directorio que le pasemos por parametro.
    Nos generara un informe en el que se especifican los directorios donde se encuentra dicho archivo duplicado, la fecha de creacion
    y la ultima modificacion de cada uno.
    Recibe por parametro el directorio a inspeccionar, y opcionalmente el directorio donde se guarda el informe. (Caso contrario se genera
    en el mismo directorio inspeccionado )

.EXAMPLE
   
    ./TP1EJ4.ps1 c:\Prueba

#>

Param(
       [Parameter(Mandatory=$true)]
       [string]$pathLectura,
       
       [string]$pathLog
     )
$existeIn = Test-Path -Path $pathLectura
$dict = @{}; 
if (  $existeIn -eq $false){
    write "No se ha encontrado el directorio" 
    return  
}
gci $pathLectura -Recurse  |where {$_.mode -notlike "d*"}| foreach {
  $key = $_.Name 
  $find = $dict[$key] 
  if($find -ne $null) {
    #el actual es duplicado 
       # write $_.Name  $_.CreationTime  $_.LastWriteTime $_.DirectoryName
       $salida = $_ | Format-Table -Property Name,CreationTime,LastWriteTime,DirectoryName 
       $salidaFinal += $salida
       
  }
  $dict[$key] ++;
}

$sal = $pathLectura
if (![string]::IsNullOrEmpty($pathLog))
{   
    $existeLog = Test-Path  -path $pathLog
    if ( $existeLog  -eq $true){ $sal = $pathLog}    
}
$salidaFinal | Out-File -FilePath "$($sal)\salida.log" 