$input_path = 'C:\Users\...'
$output_file = 'C:\Users\...\output.txt'
$regex = '\b[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b'

Get-ChildItem $input_path -Recurse | Select-String -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_file
