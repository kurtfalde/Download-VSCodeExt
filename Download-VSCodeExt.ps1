<#
Download-VSCodeExt
Written by Kurt Falde and Dan Cuomo
Allows downloading Visual Studio Code / VSCode Extensions more easily for keeping on a local file share
Takes an input of the landing page url(s) for a VSCode extension and then parses it determining the current version and download link
before downloading and renaming to an appropriately named .vsix file

#>

$extensionURIs = @(
    "https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby"
    "https://marketplace.visualstudio.com/items?itemName=bung87.rails"
    "https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets"
    "https://marketplace.visualstudio.com/items?itemName=eg2.vscode-npm-script"
    "https://marketplace.visualstudio.com/items?itemName=donjayamanne.python"
    "https://marketplace.visualstudio.com/items?itemName=georgewfraser.vscode-javac"
    "https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp"
    "https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools"
    "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell"
)
 
Function Download-VSCodeExt {
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $extensionURI,
 
        [Parameter(Mandatory=$false)]
        [string] $outputPath = '.'
    )
 
    New-Item -Path $outputPath -ItemType Directory -Force
 
    Foreach($extension in $extensionURI){
        $webpage = (Invoke-WebRequest -Uri $extension -UseBasicParsing).Content
        $match1 = '<script class="vss-extension" defer="defer" type="application/json">'
 
        $indexCut1 = [regex]::match($webpage, $match1).index + [regex]::match($webpage, $match1).length
        $webpagecut1 = $webpage.Substring($indexCut1)
 
        $match2 = '</script>'
        $indexCut2 = [regex]::match($webpagecut1, $match2).index
        $webpagecut2 = $webpagecut1.Substring(0,$indexCut2)
 
        $webjson = $webpagecut2 | ConvertFrom-Json
        $DownloadURI = ($webjson.versions.files | where assettype -EQ 'Microsoft.VisualStudio.Services.VSIXPackage').source
        
        Invoke-WebRequest -URI $DownloadURI -OutFile "$outputPath\$($webJson.extensionName)-$($webJson.publisher.publishername)-$($webjson.versions.version).vsix"
    }
}
 
Download-VSCodeExt -extensionURI $extensionURIs -outputPath c:\temp\vsCodeExt
