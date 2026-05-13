#Publish the items/pages to XM Cloud Edge

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

$allItems = Get-ChildItem -Path $rootFolderPath -Recurse

$targetDatabases = @("experienceedge")

foreach ($item in $allItems) {

$output = Publish-Item -Item $item -Target $targetDatabases -Language * -PublishMode Smart

Write-host $output

}
