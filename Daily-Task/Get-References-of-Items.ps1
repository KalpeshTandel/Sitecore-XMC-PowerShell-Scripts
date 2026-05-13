# This script retrieves all child items under a specified root folder and checks for any referring items. 
# If there are referring items, it lists them along with the original item.

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

$allItems = Get-ChildItem -Path $rootFolderPath -Language "en" -Recurse

foreach($item in $allItems){
   $referringItems = Get-ItemReferrer -Item $item

if($referringItems.Count -eq 0){
     Write-Host "Item: $($item.Paths.FullPath) No referring Items"
     continue
}

foreach ($refItem in $referringItems) {
    Write-Host "Item: $($item.Paths.FullPath) Referring Item: $($refItem.Paths.FullPath)"
    }
}


