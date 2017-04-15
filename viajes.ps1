Param($ciudadOrigen,$ciudadDestino,$cambio)
$directorio = "C:\SO\reservas.csv"


$bdd = Import-Csv -Path  $directorio
if ($bdd -ne $null){
    $filtro =$bdd | where{(($_.origen).ToUpper()).StartsWith($ciudadOrigen.ToUpper()) -and (($_.destino).ToUpper()).StartsWith($ciudadDestino.ToUpper()) -and $_.disponible -gt 0 -and (get-date $_.'Fecha Hora Desde') -gt (get-date)}

    if ($filtro -ne $null){
        if ( $cambio -ne $null){
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
        $bdd|Export-Csv -path $directorio
    }
    else {
        write-host  "No encontramos viajes para el destino especificado" 
    }

} else{Write-host "sin viajes"}