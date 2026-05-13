#Update Content from one field to another field of same item for all or specific languages

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the Template ID of the items which you want to filter.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$templateID = [Sitecore.Data.ID]::Parse("[TemplateID]")

$languages = @("en", "fr", "pt", "it", "de", "es")

$allItems = Get-ChildItem -Path $rootFolderPath -Recurse | Where-Object { $_.TemplateID -eq $templateID }

foreach ($item in $allItems) {
    
    foreach ($lang in $languages) {

        $verItem = Get-Item -Path $item.Paths.FullPath -Language $lang
        
        if ($verItem -and $verItem.Versions.Count -gt 0) {
            $latestVersion = $verItem.Versions.GetLatestVersion()
            
            if ($latestVersion) {
                write-host "started for $($item.Paths.FullPath) for Language - $lang"
                
                $itemForEditing = $latestVersion
                
                $oldFieldContent = $itemForEditing.Fields["Old Field"].Value
                $newFieldContent = $itemForEditing.Fields["New Field"].Value
                
                if([string]::IsNullOrWhiteSpace($newFieldContent))
                {                     
                    $itemForEditing.Editing.BeginEdit()
                    $itemForEditing.Fields["New Field"].Value = $oldFieldContent
                    $itemForEditing.Editing.EndEdit()

                    write-host "Content Swapped Successfully for $($item.Paths.FullPath) for Language - $lang"                 
                }
            }
        }
    }
}
