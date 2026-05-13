#Read the Link field and provide the Output in CSV format with absolute URL for both internal and external links 


# Provide the root folder path from where you want to read the child items
$rootFolderPath = "/sitecore/content/MySites/BlackBox/Home/Company" 

# Provide the home node path of your site to replace with the absolute URL for internal links
$homeNodePath = "/sitecore/content/MySites/BlackBox/Home"

 # Provide your site domain to replace with the absolute URL for internal links
$yourSitesDomain = "https://www.yoursite.com"


$allItems = Get-ChildItem -Path $rootFolderPath -Recurse

foreach ($item in $allItems) {
  
      # "Destination Url" is the name of the Link field which I want to read and get the absolute URL. 
      ## Please change it as per your requirement.
      $destinationUrlField = [Sitecore.Data.Fields.LinkField]$item.Fields["Destination Url"]

      $targetUrl = ""

        if ($destinationUrlField.LinkType -eq "external") {
               $targetUrl =  $destinationUrlField.Url
        }
        elseif($destinationUrlField.LinkType -eq "internal"){
            $targetItem = $destinationUrlField.TargetItem
            $queryString = $destinationUrlField.QueryString
                if ($targetItem) {
                $targetUrl = $targetItem.Paths.FullPath
                $targetUrl = $targetUrl.Replace($homeNodePath,$yourSitesDomain)
                $targetUrl = $targetUrl +"?"+"$queryString"
            }
        }
        
     write-host "Item Path is :- $($item.Paths.FullPath) is Redirecting to :- $targetUrl"
     write-host ""
}