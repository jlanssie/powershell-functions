$i = 1
Get-ChildItem *.jpg | %{Rename-Item $_ -NewName ('{0:D4}.jpg' -f $i++)}
