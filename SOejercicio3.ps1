$dict = @{};
gci c:\prueba -Recurse  |where {$_.mode -notlike "d*"}| foreach {
  $key = $_.Name 
  $find = $dict[$key]
  if($find -ne $null) {
    #el actual es duplicado 
        write $_.Name  $_.CreationTime  $_.LastWriteTime $_.DirectoryName
  }
  $dict[$key] ++;
}

