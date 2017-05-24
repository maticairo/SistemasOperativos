<#
Trabajo Práctico 1
Ejercicio 3
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 

.SYNOPSIS
    
    Elimina archivos duplicados
    
.DESCRIPTION
   
    Este script nos permite eliminar los archivos duplicados del directorio que le pasemos por parámetro.
    Nos generará un informe en el que se especificarán los directorios donde se encuentra dicho archivo, la fecha de creación
    y la última modificación de cada uno.
    Recibirá por parámetro el directorio a inspeccionar, y opcionalmente el directorio donde se guardará el informe. (Caso contrario será
    en el )

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
       $sal = $pathLectura
       if ( $pathLog -ne $null)
        {   
            $existeLog = Test-Path  -path $pathLog
            if ( $existeLog  -eq $true){ $sal = $pathLog}
            
        }
         $salida | Out-File -FilePath "$($sal)salida.log" -Append
  }
  $dict[$key] ++;
}



