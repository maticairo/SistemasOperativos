<# Trabajo Práctico 1
Ejercicio 6
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 
#>

<#

.SYNOPSIS
Identifica procesos guardados en una lista negra que se ejecutan, avisa su uso y guarda en un log.

.DESCRIPTION
Este Script detecta procesos que se encuentran en una lista negra, guardados en un archivo, muestra un mensaje de que se esta ejecutando alguno y guarda la fecha y hora de cuándo se ejecutó en un archivo log. Si el archivo que proporciona la lista negra se encuentra vacia avisará que esta no poseé ningún elemento.

.PARAMETER pathLista
 Directorio del archivo con la Lista Negra.

.PARAMETER pathLog
Directorio de dónde guarda el archivo log.

.EXAMPLE
    .\Ejercicio_6.ps1 -pathLista "C:\Users\documents\listado.txt"
.EXAMPLE
    .\Ejercicio_6.ps1 -pathLista "C:\Users\documents\blacklist.txt" -pathLog "C:\Users\resultado\"

.NOTES

    La lista negra debe contener el nombre de los procesos de la siguiente manera:
    notepad - para el block de notas
    Calculator - para la calculadora

    El path de log NO debe incluír una "\" al final.

#>

Param([parameter(Mandatory=$true, Position=1)] $pathLista, 
      [parameter(Mandatory=$false, Position=2)] [validatenotnullorempty()] $pathLog)

#Valido la ruta del archivo blacklist, y que la ruta proporcionada sea efectivamente un archivo, no una carpeta
if(-not($pathLista) -or (Test-Path $pathLista -PathType Leaf) -eq $false )
{
    Write-Output "La ruta " $pathLista " no existe o no corresponde a un archivo."
    exit 1
}

#Si no se definió path del log uso el mismo que la lista negra
if(!$pathLog)
{
    $pathLog = $pathLista.Substring(0,$pathLista.LastIndexOf('\'))
}

#De estar vacio el contenido de la lista aviso de tal situación y salgo
If ((Get-Content $pathLista) -eq $Null) {
    Write-Output "El archivo ubicado en: " $pathLista " está vacío"
    exit 1
}
$pathLog += "\log.log"

#Levanto la lista negra del archivo
$procesos = Get-Content $pathLista
while ($true)# Para dejar de monitorear presionar ctrl + c        
{
    foreach($p in $procesos)
    {
        #Si el proceso no esta en ejecucion lanzaria una excepcion, asi que le digo que la ignore con "SilentlyContinue"
        $proceso = Get-Process -Name $p -ErrorAction SilentlyContinue
        #Si dejamos -ErrorAction SilentlyContinue en $proceso, entra al if y falla en la linea de detener proceso
        if($proceso) #Si el proceso se está ejecutando
        {
            write "Se ha detectado la ejecución del proceso " $p
            $proceso >> $pathLog
            #Matamos el proceso para que no lo ejecute.
            $proceso.Kill()
            Start-Sleep 5       
        }
    } 
}