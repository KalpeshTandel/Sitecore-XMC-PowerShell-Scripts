# Change the template of multiple items under the specified path.

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

$items = Get-ChildItem -Path $targetPath -Language * -Recurse

$rootItem = Get-Item -Path $targetPath
$items = $items + $rootItem

# Provide the Template ID of the items which you want to filter.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$oldTemplateID = "[TemplateID]"

# Provide the new Template ID which you want to set for the items.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$newTemplateID = "[TemplateID]"

function Changetemplate {
    foreach($item in $items)
    {
		#Matching old Template
        if ($item.TemplateId -eq $oldTemplateID)	
        {	
            $item.Editing.BeginEdit();
			#Replacing Template to different Template
            $item.TemplateId = $newTemplateID
            $item.Editing.EndEdit();  
			Write-Host "Template changed successfully for item: " $item.Paths.FullPath"
        }
    }
}

$items = Changetemplate     