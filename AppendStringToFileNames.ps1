Get-ChildItem *.jpg | Rename-Item -NewName { $_.Name + "-test.jpg" }
