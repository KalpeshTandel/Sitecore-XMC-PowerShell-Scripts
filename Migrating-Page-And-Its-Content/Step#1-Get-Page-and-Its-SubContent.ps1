#This is Step #1 script which is used to export the Page and its subcontent items with all the fields for every languages in CSV format.

# Provide the root folder path from where you want to read the child items
$pagePath = "/sitecore/content/MySites/BlackBox/Home/Company" 


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

$subContentPath = $pagePath + "/Data"

$allItems = Get-ChildItem -Path $subContentPath -Recurse
$allItems = @($pageItem) + $allItems

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
    foreach ($lang in $item.Languages) {
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

Export-csvDownload -InputObject $output -FileName "Page_And_SubContent.csv"