<#

.SYNOPSIS
    
    Este es un script que monitorea archivos de un determinado directorio

.DESCRIPTION
   
    Con este script podremos saber si los archivos de un directorio (ingresado por el usuario) son creados, 
modificados, eliminados o renombrados. 
    Para saber de TODOS los archivos hay que ingresar *.*, para saber de alguna extension se especifica, por ejemplo,
    un txt: *.txt*
    Mostrara por consola con VERDE cuando es CREADO,
    AMARILLO cuando es MODIFICADO,
    ROJO cuando es ELIMINADO,
    GRIS cuando es RENOMBRADO.

.EXAMPLE
    ./TP1EJ4.ps1


#>


Param([Parameter(Mandatory=$true)]
      [string] $pathLectura, #c:\users\thomas\desktop\test
      [Parameter(Mandatory=$true)]
      [string] $fileType ) # siempre ingresar la extension entre "* *" por ej: *.*, *.txt*, *.ps1*, *.xslx*, *.doc*

Function Register-Watcher {
    param ($folder)
    
    #se guarda la extension del archivo
    $filter = $fileType

    #se crea el objeto que monitorea
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    #este codigo se ejecutara cuando se modifique algun archivo
    $changeAction = [scriptblock]::Create('
        
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
       
        Write-Host "El archivo $name fue $changeType el $timeStamp" -fore yellow
    ')

    #este codigo se ejecutara cuando se cree un archivo 
    $createAction = [scriptblock]::Create('
        
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
       
        Write-Host "El archivo $name fue $changeType el $timeStamp" -fore green
    
    ')

    #este codigo se ejecutara cuando se elimine un archivo
    $deleteAction = [scriptblock]::Create('
       
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
        
        Write-Host "El archivo $name fue $changeType el $timeStamp" -fore red
    ')

    #este codigo se ejecutara cuando se renombre un archivo
    $renameAction =  [scriptblock]::Create('
        
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $oldName = $Event.SourceEventArgs.oldName
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
       
        Write-Host "El archivo $oldName fue $changeType a $name el $timeStamp" -fore darkgray

    ')


    #SE LANZA ESTE EVENTO CUANDO EL SISTEMA RECONOCE QUE UN ARCHIVO FUE CREADO
    Register-ObjectEvent $watcher "Created" -Action $createAction

    #SE LANZA ESTE EVENTO CUANDO EL SISTEMA RECONOCE QUE UN ARCHIVO FUE MODIFICADO
    Register-ObjectEvent $Watcher "Changed" -Action $changeAction

    #SE LANZA ESTE EVENTO CUANDO EL SISTEMA RECONOCE QUE UN ARCHIVO FUE ELIMINADO
    Register-ObjectEvent $watcher "Deleted" -Action $deleteAction

    #SE LANZA ESTE EVENTO CUANDO EL SISTEMA RECONOCE QUE UN ARCHIVO FUE RENOMBRADO
    Register-ObjectEvent $watcher "Renamed" -Action $renameAction
}


#SE EJECUTA LA FUNCION, LE MANDO EL PATH A MONITOREAR
 Register-Watcher "$pathLectura"
 
