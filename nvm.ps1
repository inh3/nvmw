Set-StrictMode -Version 3

# create temp file to store batch local env
$tempFile = [IO.Path]::GetTempFileName()

Invoke-Command -ScriptBlock { cmd /c "nvmw.bat $args && set > `"$tempFile`"" } -ArgumentList $args -NoNewScope

# find path variable and set path
Get-Content $tempFile | Foreach-Object {
    If(($_ -match "^(PATH)=(.*)$") -or ($_ -match "^(NVMW_CURRENT)=(.*)$"))
    {
        Set-Content "env:\$($matches[1])" $matches[2]
    }
}

# remove the temp file
Remove-Item $tempFile
