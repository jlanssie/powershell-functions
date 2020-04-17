param (
    [string]$FindS = "^u8232", #captures unicode character L SEP (line-separator)
    [string]$ReplaceS = "" #replaces hits with empty string
)

$folderPath = "C:\Users\jeremylanssiers\Downloads\" #supports multi-folders: "C:\fso1*", "C:\fso2*"
$fileType = "*.docx"

$word = New-Object -ComObject Word.Application
$word.Visible = $false

Function findAndReplace($Text, $Find, $ReplaceWith) {
    $matchCase = $true
    $matchWholeWord = $true
    $matchWildcards = $false
    $matchSoundsLike = $false
    $matchAllWordForms = $false
    $forward = $true
    $replace = [Microsoft.Office.Interop.Word.WdReplace]::wdReplaceAll
    $format = $false
    $findWrap = [Microsoft.Office.Interop.Word.WdFindWrap]::wdFindContinue

    $Text.Execute($Find, $matchCase, $matchWholeWord, $matchWildCards, ` 
                  $matchSoundsLike, $matchAllWordForms, $forward, $findWrap, `  
                  $format, $ReplaceWith, $replace) > $null
}

Function findAndReplaceWholeDoc($Document, $Find, $ReplaceWith) {
    $findReplace = $Document.ActiveWindow.Selection.Find
    findAndReplace -Text $findReplace -Find $Find -ReplaceWith $ReplaceWith
    ForEach ($section in $Document.Sections) {
        ForEach ($header in $section.Headers) {
            $findReplace = $header.Range.Find
            findAndReplace -Text $findReplace -Find $Find -ReplaceWith $ReplaceWith
            $header.Shapes | ForEach-Object {
                if ($_.Type -eq [Microsoft.Office.Core.msoShapeType]::msoTextBox) {
                    $findReplace = $_.TextFrame.TextRange.Find
                    findAndReplace -Text $findReplace -Find $Find -ReplaceWith $ReplaceWith
                }
            }
        }
        ForEach ($footer in $section.Footers) {
            $findReplace = $footer.Range.Find
            findAndReplace -Text $findReplace -Find $Find -ReplaceWith $ReplaceWith
        }
    }
}

Function processDoc {
    $doc = $word.Documents.Open($_.FullName)
    findAndReplaceWholeDoc -Document $doc -Find $FindS -ReplaceWith $ReplaceS
    $doc.Close([ref]$true)
}

$sw = [Diagnostics.Stopwatch]::StartNew()
$count = 0
Get-ChildItem -Path $folderPath -Recurse -Filter $fileType | ForEach-Object { 
  Write-Host "Processing: $($_.Name)..."
  processDoc
  $count++
}
$sw.Stop()
$elapsed = $sw.Elapsed.toString()
Write-Host "`n$count files processed in $elapsed" 

$word.Quit()
$word = $null
[gc]::collect() 
[gc]::WaitForPendingFinalizers()
