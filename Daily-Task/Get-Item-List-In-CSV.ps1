#Provide all the items/pages list with their full path for the given template ID in CSV format.

# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the Template ID of the items which you want to filter.# Ex:{38191062-18AE-46DE-A2D2-4F604E2E86BE}
$templateID = [Sitecore.Data.ID]::Parse("[TemplateID]")

$languages = @("en", "fr", "pt", "it", "de", "es")


function Export-csvDownload {param ([Parameter(Mandatory=$true)][Object[]]$InputObject,[string]$FileName = "data.csv")
    $csvText = $InputObject | ConvertTo-Csv -NoTypeInformation | Out-String
    [byte[]]$outobject = [System.Text.Encoding]::Default.GetBytes($csvText)
    Out-Download -Name $FileName -InputObject $outobject
}

$pageItem = Get-Item -Path $pagePath
if (-not $pageItem) {
    Write-Host "Item not found: $pagePath"
    exit
}


$allItems = Get-ChildItem -Path $rootFolderPath -Recurse | Where-Object { $_.TemplateID -eq $templateID }

if($pageItem.TemplateID -eq $templateID ){
  $allItems = @($pageItem) + $allItems  
}


$fieldNames = @()
foreach ($item in $allItems) {
    if ($item -and $item.Versions.Count -gt 0) {
            $latestVersion = $item.Versions.GetLatestVersion()
            if ($latestVersion) {
                $latestVersion.Fields.ReadAll()
                $fieldNames += $latestVersion.Fields | ForEach-Object { $_.Name }
            }
        }
}
$fieldNames = $fieldNames | Where-Object { -not ($_.StartsWith("__")) } | Select-Object -Unique

$output = @()
foreach ($item in $allItems) {
    write-host "started for $($item.Paths.FullPath)"
    foreach ($lang in $languages) {
        $verItem = Get-Item -Path $item.Paths.FullPath -Language $lang
        if ($verItem -and $verItem.Versions.Count -gt 0) {
            $latestVersion = $verItem.Versions.GetLatestVersion()
            if ($latestVersion) {
                $row = [ordered]@{
                    "ItemID"   = $latestVersion.ID.ToString()
                    "Path"      = $latestVersion.Paths.FullPath
                    "ItemName" = $latestVersion.Name
                    "TemplateId"  = $latestVersion.Template.ID
                    "Language"  = $lang
                    "Version"   = $latestVersion.Version.Number
                }
                foreach ($fieldName in $fieldNames) {
                       $row[$fieldName] = $latestVersion.Fields[$fieldName].Value 
                }
                $output += New-Object PSObject -Property $row
            }
        }
    }
}

Export-csvDownload -InputObject $output -FileName "Item-List.csv"