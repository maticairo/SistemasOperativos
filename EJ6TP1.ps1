<#
Trabajo Práctico 1
Ejercicio 6
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 

.SYNOPSIS
    
    Identifica el inicio de procesos no deseados
    
.DESCRIPTION
   
    Este script nos permite monitorear una serie de procesos que se encontrarán en un archivo que le pasaremos por parámetro. 
    Generará un archivo de log con los procesos que hayan sido iniciados, y mostrará un mensaje de alerta.
    Si el archivo está vacío, mostrará un mensaje
#>

Param([Parameter(Mandatory=$true)]
      [string] $pathLectura,  
      $pathLog)

#Función que alerta si se inició un proceso no deseado y lo registra en el log con el path correspondiente
function AlertAndLog{
    
    Write-Output "Se inicio un proceso"
    if($pathLog -eq $null){
        $input | Out-File "$($pathLectura)salida.log" -Append
    }
    else{
        $input | Out-File "$($pathLog)salidaEj6.log" -Append
    }  
}

$procesos=Get-Content $pathLectura;
if($procesos.Length -eq 0)
{
    #Archivo vacío
    Write-Output "El archivo está vacio" 
}
else{

    #Por cada proceso me suscribo al evento
    foreach($proceso in $procesos){
    $query="Select * From __InstanceCreationEvent within 3 Where TargetInstance ISA 'Win32_Process' And TargetInstance.Name = $proceso"
    Register-WMIEvent -query $query -sourceIdentifier "NewProcess-$($proceso)" -action {Get-Process $proceso | AlertAndLog} 
   }
}

#Unregister-Event "NewProcess-notepad.exe"
#FIN
