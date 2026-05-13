#Provide all the items/pages list with their full path for the given template ID

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the Template ID of the items which you want to filter.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$templateID = [Sitecore.Data.ID]::Parse("[TemplateID]")

$allItems = Get-ChildItem -Path $rootFolderPath -Recurse | Where-Object { $_.TemplateID -eq $templateID }

foreach ($item in $allItems) {
     write-host "$($item.Paths.FullPath)"
}