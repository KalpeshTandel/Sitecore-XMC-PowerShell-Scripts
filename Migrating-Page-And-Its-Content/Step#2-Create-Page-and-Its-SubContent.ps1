# This is Step #2 script which is used to create the Page and its subcontent items in XMC using the data exported in Step #1. 
# It reads the data from CSV file and then create items in XMC based on the field and template mappings provided in another CSV file.

# Get the items list from csv file in media library which we exported in Step #1.
$pagesAndsubContentItems_CSVPath = "master:/sitecore/media library/Files/PowershellScriptsFiles/Page_And_SubContent"

# Get field and template mappings from csv file in media library. 
# The csv file should have the following columns: OldTemplateID, NewTemplateId, OldFieldName, NewFieldName, DirectValue (yes/no).
# Update the csv file with the appropriate values for your migration and upload it to media library in Sitecore.
# Please find the sample csv file in same repository.
$fieldTemplateMappings_CSVPath = "master:/sitecore/media library/Files/PowershellScriptsFiles/Field-And-Template-Mappings"

# Provide the parent path where you want to create the page in XMC.
$parentPath = "master:/sitecore/content/MySites/BlackBox/Home" 


function Get-SitecoreMediaCsv {param ([Parameter(Mandatory=$true)][string]$mediaItemPath)
    #get csv file item from media library 
    $media = Get-Item -Path $mediaItemPath 
    #get stream and save content to variable $content 
    [System.IO.Stream]$body = $media.Fields["Blob"].GetBlobStream() 
    try 
     { 
        $contents = New-Object byte[] $body.Length 
        $body.Read($contents, 0, $body.Length) | Out-Null 
     } 
    finally 
     { 
        $body.Close() 
     } 
       
    #convert to dynamic object 
    $csv = [System.Text.Encoding]::Default.GetString($contents) | ConvertFrom-Csv -Delimiter ","
    return $csv
}

function Ensure-XmcLocalDatasource {param([Parameter(Mandatory=$true)][string]$PagePath)
    
    $DataFolderName = "Data"
    $pageItem = Get-Item -Path $dataSourcePath
    $dataFolder = $pageItem.Children | Where-Object { $_.Name -eq $DataFolderName }
    if (-not $dataFolder) {
        $dataFolder = New-Item -Name $DataFolderName -Parent $pageItem -ItemType "{1C82E550-EBCD-4E5D-8ABD-D50D0809541E}"
    }

    return $dataFolder
}

$items = Get-SitecoreMediaCsv -mediaItemPath $pagesAndsubContentItems_CSVPath

$fieldMappings = Get-SitecoreMediaCsv -mediaItemPath $fieldTemplateMappings_CSVPath

$name = $items[0].ItemName

$count=1
foreach ($row in $items) {

    $templateId =$row.TemplateId
    $path = $row.Path -split ("Data")
    $ItemPath = $parentPath
    
    if($path[1])
    {
        $dataSourcePath = "$parentPath/$name" 
        Ensure-XmcLocalDatasource -PagePath $dataSourcePath
        $replacePath = $row.ItemName
        $relativePath = $path[1].Replace("/$replacePath","")
        $ItemPath = "$parentPath/$name/Data$relativePath" 
    }
    
    $filteredfieldMappings = @($fieldMappings | Where-Object { $_.OldTemplateID -eq $templateId })

    if($filteredfieldMappings.Count -ge 1)
    {
        $newTemplateId = $filteredfieldMappings[0].NewTemplateId
        $itemId = $row.ItemID
        $language = $row.Language
        $itemExists = Get-Item -Path $ItemPath -ID $itemId -ErrorAction SilentlyContinue
        $itemVersionExists = Get-Item -Path $ItemPath -ID $itemId -Language $language -ErrorAction SilentlyContinue
        
        if(-not $itemExists)
        {
            $itemForEditing = New-Item -Path $ItemPath -Name $row.ItemName -ItemType $newTemplateId -ForceId $itemId -Language $language
            Write-Host "Added $language version." $itemExists.ID 
        }
        elseif(-not $itemVersionExists)
        {
            $itemForEditing = Add-ItemLanguage -Item $itemExists -Language "en" -TargetLanguage $language -DoNotCopyFields
            Write-Host "Added $language version." $itemExists.ID 
        }
        else
        {
            $itemForEditing = $itemVersionExists
        }
        
        if($itemForEditing)
        {
            $itemForEditing.Editing.BeginEdit()
            foreach($fieldMapping in $filteredfieldMappings)
            {
                        if($fieldMapping.DirectValue -eq "yes"){
                            $itemForEditing[$fieldMapping.NewFieldName] = $fieldMapping.OldFieldName
                        }
                        else{
                             $itemForEditing[$fieldMapping.NewFieldName] = $row."$($fieldMapping.OldFieldName)" 
                        }
            }
                       
            $itemForEditing.Editing.EndEdit()
        }
    }
   $count++     
}


   