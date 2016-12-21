$group = "ActiveDirectoryGroup"

# https://technet.microsoft.com/en-us/library/ff730967.aspx
$strFilter = "(&(objectCategory=Group)(name=$group))"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"

$colProplist = "name","member"
foreach($i in $colPropList) {
    $objSearcher.PropertiesToLoad.Add($i)
}

$colResults = $objSearcher.FindAll()

foreach($objResult in $colResults) {
    $objItem = $objResult.Properties

    $members = $objItem.member
    Write-Output $members
}

$membersReadable = $members | Out-String

$filename = "$group.txt"
"$group" | Out-File -FilePath $filename
"$membersReadable" | Out-File -FilePath $filename -append
