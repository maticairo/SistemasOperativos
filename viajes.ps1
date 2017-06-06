<#
Trabajo Práctico 1
Ejercicio 5
Matias Ezequiel Cairo 39670522
Thomas Ignacio Reynoso 39332450
Pablo Avalo 39214569
Luciano Gabriel Tonlorenzi Sebastía 39244171
Micaela Rocío De Rito 39547209 
#>

<#
.SYNOPSIS
    
    Muestra un listado de pasajes disponibles
    
.DESCRIPTION
   
    Este script nos permite realizar una búsqueda de pasajes (a partir de un archivo csv que se recibe por parametro) según el lugar de origen y destino que le ingresaremos por parámetros.
    Según lo que el usuario elija, se actualizará el archivo csv.
#>
 
Param([Parameter(Mandatory=$true)]
       [string]$csv,
       [Parameter(Mandatory=$true)]
       [string]$ciudadOrigen,
       [Parameter(Mandatory=$true)]
       [string]$ciudadDestino,
       [int]$cambio)


$testcsv = Test-Path $csv
if ( $testcsv -ne $false)
{
$bdd = Import-Csv -Path  $csv
}
else 
{
 echo " no se recibio csv valido "
 return   
}
if ($bdd -ne $null){
    $filtro =$bdd | where{(($_.origen).ToUpper()).StartsWith($ciudadOrigen.ToUpper()) -and (($_.destino).ToUpper()).StartsWith($ciudadDestino.ToUpper()) -and $_.disponible -gt 0 -and (get-date $_.'Fecha Hora Desde') -gt (get-date)}

    if ($filtro -ne $null){
        if ( $cambio -ne $null -and $cambio -gt 0 ){
            foreach ( $item in $filtro ) {
                
                $b = $item.precio/$cambio
                $aux = $item.PsObject.Copy()
                $aux.precio = $b 
                $aux | Format-Table
                
            }
            
        }
        
        else{
        $filtro |Format-Table 
        }
        do{
            $nroDeViaje = Read-Host "ingrese el Codigo de pasaje "
            $CantDePasajes =Read-Host "ingrese la cantidad de pasajes"
            $viaje = $filtro | where {$_.Codigo -eq $nroDeViaje}
        }
        while(!$viaje -or ($viaje.disponible - $CantDePasajes) -lt 0 )
        $viaje.Disponible -= $CantDePasajes
        $bdd|Export-Csv -path $csv
    }
    else {
        write-host  "No encontramos viajes para el destino especificado" 
    }

} else{Write-host "sin viajes"}
