function javacbin {
    javac -d bin $(Get-ChildItem . -Name *.java -Recurse)
}

function javaclocal {
   javac $(Get-ChildItem . -Name *.java -Recurse) 
}
