# https://technet.microsoft.com/en-us/library/ff730967.aspx

$debug = $false
$debug = $true

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000

$objSearcher.SearchScope = "Subtree"

$usernames = Get-Content users.txt

foreach($username in $usernames) {
    if($debug -eq $true) {
        Write-Output "Querying AD for $username ..."
    }

    $strFilter = "(&(objectCategory=User)(sAMAccountName=$username))"
    $objSearcher.Filter = $strFilter

    $colResults = $objSearcher.FindAll()

    $out = ""
    foreach ($objResult in $colResults) {
        $objItem = $objResult.Properties

        $properties = $objItem.PropertyNames
        foreach($propertyName in $properties) {
            $propertyValue = $objItem.$propertyName

            $out = $out + "$propertyName;$propertyValue`r`n"
        }
    }

    $filename = "user-$username.txt"
    "$out" | Out-File -FilePath $filename

    if($debug -eq $true) {
		Write-Output "Query finished."
		Write-Output ""
	}
}
