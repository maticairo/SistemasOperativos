<# Trabajo Práctico 1
Ejercicio 1
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 #>

<#
a) El objetivo de script es obtener el nombre y longitud de los archivos que
   se ubican en el Path en el que nos encontramos localizados. Al pasarlo por parámetro,
   se comprueba que éste exista, y si no existe, nos mostrará un mensaje.
b) Le agregaría la validación que exige al usuario ingresar obligatoriamente un parámetro.
#>

Param(
[Parameter(Mandatory = $true)]$pathsalida #Que sea obligatorio
)
$existe = Test-Path $pathsalida
if ($existe -eq $true)
{
    $lista = Get-ChildItem -File
    foreach($item in $lista)
    {
        Write-Host "$($item.Name) $($item.Length)"
    }
}
else
{
    Write-Error "El path no existe"
}

<#
c) Para mostrar una salida similar, podría utilizar el comando Get-ChildItem -File -Name
   Con la diferencia de que no me mostraría la longitud de cada uno de los archivos.
#>

