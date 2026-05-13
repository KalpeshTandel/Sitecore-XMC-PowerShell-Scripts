#Publish the filtered items/pages to XM Cloud Edge

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the Template ID of the items which you want to publish.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$templateID = [Sitecore.Data.ID]::Parse("[TemplateID]")

$allItems = Get-ChildItem -Path $rootFolderPath -Recurse | Where-Object { $_.TemplateID -eq $templateID }

$targetDatabases = @("experienceedge")

foreach ($item in $allItems) {

$output = Publish-Item -Item $item -Target $targetDatabases -Language * -PublishMode Smart

Write-host $output

}
