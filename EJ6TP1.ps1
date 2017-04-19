#LEER BIEN EL ENUNCIADO PARA VER QUE FALTA!
#Hay que validar parametros y poner la ayuda para Get-Help - ver enunciado

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