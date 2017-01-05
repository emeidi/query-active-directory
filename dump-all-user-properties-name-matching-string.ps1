# https://technet.microsoft.com/en-us/library/ff730967.aspx

$debug = $false
$debug = $true

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000

$objSearcher.SearchScope = "Subtree"

$names = Get-Content names.txt

foreach($name in $names) {
    if($debug -eq $true) {
        Write-Output "Querying AD for *$name* ..."
    }

    $strFilter = "(&(objectCategory=User)(cn=*$name*))"
    $objSearcher.Filter = $strFilter

    $colResults = $objSearcher.FindAll()

    $username = $name
    $out = ""
    foreach ($objResult in $colResults) {
        $objItem = $objResult.Properties

        $properties = $objItem.PropertyNames
        foreach($propertyName in $properties) {
            $propertyValue = $objItem.$propertyName

            $out = $out + "$propertyName;$propertyValue`r`n"

            if($propertyName -eq 'sAMAccountName') {
                $username = $propertyValue
            }
        }
    }

    $filename = "user-$username.txt"
    "$out" | Out-File -FilePath $filename

    if($debug -eq $true) {
		Write-Output "Query finished."
		Write-Output ""
	}
}
