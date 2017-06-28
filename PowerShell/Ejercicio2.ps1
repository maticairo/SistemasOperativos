<#
	Trabajo Practico Nro: 1 - Entrega
Integrantes:
    Dezerio, Sandro Sebastian | 35946018
    Fernandez, Matias Gabriel | 38613699
    Quinteiro, Lucas Gabriel  | 39417369
    Ratibel, Pablo Martin     | 37792037
    Torres, Quimey Belen      | 38891324
.Synopsis
Descarga de URLs dentro de un archivo de texto hacia una carpeta especificada.

.Description
Este método recibe por parámetros un archivo con una lista de URLs a descargar, una dirección donde se almacenarán dichas descargas y opcionalmente se puede indicar también un archivo de log donde se obtendrá información sobre la duración y el tamaño de cada descarga.
Los primeros dos parámetros son obligatorios, mientras que el tercer parámetro es opcional. En caso de no indicarse el tercer parámetro, el archivo de log se creará por defecto en la carpeta donde se guardarán las descargas.

.Example
Ejemplo 1:
.\Ejercicio2.ps1 'C:\Users\Matierf\Desktop\descargas.txt' 'C:\Users\Matierf\Desktop\carpera_desc' 

Ejemplo 2:
.\Ejercicio2.ps1 'C:\Users\Matierf\Desktop\descargas.txt' 'C:\Users\Matierf\Desktop\carpera_desc' 'C:\Users\Matierf\Desktop\log_desc.txt'

#>

param(
	[parameter(mandatory = $true)][string] $file,
	[parameter(mandatory = $true)][string] $dir,
	[string] $log
     )
if($log.length -eq 0)
{
    $log = (-join($dir, "\log.txt"))
}    

$obj = New-Object System.Net.WebClient

$lineas = get-content $file
$nro = 0
foreach($linea in $lineas)
{
	$palabras = $linea.split(' ')
	foreach($pal in $palabras)
	{
	       	$nro++
        	try
	        {
        	    if($pal.Contains('zip'))
	            {
	                $start_time = get-date
	                $obj.DownloadFile($pal,(-join($dir,"\Descarga",$nro,".zip")))
	                Add-Content $log "`nDescarga $nro (Tiempo): $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
	            }
	            else
		        {
	                if($pal.Contains('pdf'))
	                {
	                    $start_time = get-date
	                    $obj.DownloadFile($pal,(-join($dir,"\Descarga",$nro,".pdf")))
	                    Add-Content $log "`nDescarga $nro (Tiempo): $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
	                }
	                else
	                {
	                    if($pal.Contains('jpg'))
	                    {
	                        $start_time = get-date
	                        $obj.DownloadFile($pal,(-join($dir,"\Descarga",$nro,".jpg")))
	                        Add-Content $log "`nDescarga $nro (Tiempo): $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
	                    }
			            else
			            {   
				            if($pal.Contains('docx'))
	                    	{
	                        	$start_time = get-date
	                        	$obj.DownloadFile($pal,(-join($dir,"\Descarga",$nro,".docx")))
	                        	Add-Content $log "`nDescarga $nro (Tiempo): $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
	                    	}
				            else
			    	        {
				                if($pal.Contains('xlsx'))
	                    	    {
	                            	$start_time = get-date
	                       	 	    $obj.DownloadFile($pal,(-join($dir,"\Descarga",$nro,".xlsx")))
	                       	 	    Add-Content $log "`nDescarga $nro (Tiempo): $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
	                       	    }
				            }	
			            }   
	                }
	            }
	        }
	        catch [System.Net.WebException]
	        {
	            Add-Content $log "`nDescarga $nro (Tiempo): ERROR AL INTENTAR DESCARGAR"
	        }

	}
}

$dwnld = Get-ChildItem $dir
foreach($d in $dwnld)
{
    if (-not $d.FullName.Contains('log.txt'))
    {
        [System.Int32]$tam = $d.Length/1KB
        Add-Content $log "`n$d (Tamaño): $tam KB" 
    }
}
