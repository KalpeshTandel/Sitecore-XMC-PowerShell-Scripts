# This script is used to update the item name by replacing spaces with hyphens for items under the specified path and template ID.

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the Template ID of the items which you want to filter.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$templateID = [Sitecore.Data.ID]::Parse("[TemplateID]")


$allItems = Get-ChildItem -Path $rootFolderPath -Recurse | Where-Object { $_.TemplateID -eq $templateID }

foreach ($item in $allItems) {
    if($item.Name -like '* *'){
        $itemName = $item.Name
            
        $newItemName = $itemName -replace " ", "-"

        # Rename the item
        $item.Editing.BeginEdit()
        $item.Name = $newItemName
        $item.Editing.EndEdit()

        write-host "Renamed the item Successfully for $($item.Paths.FullPath)"                 
    }
}