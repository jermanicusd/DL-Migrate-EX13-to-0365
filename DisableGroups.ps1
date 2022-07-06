#Check if exchange snap in is loaded and if not then load.
$snapinAdded = Get-PSSnapin | Select-String Microsoft.Exchange.Management.PowerShell.Admin
if (!$snapinAdded)
{
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
}

#File Paths
$strFileName1="c:\temp\DL\TestCSVs\MailUniversalSecurityGroup.csv"
$strFileName2="c:\temp\DL\TestCSVs\MailNonUniversalGroup.csv"
$strFileName3="c:\temp\DL\TestCSVs\MailUniversalDistributionGroup.csv"

#Removes Mail Enable from all Security Groups
If (Test-Path $strFileName1){
Import-Csv $strFileName1 | ForEach-Object{Disable-distributiongroup -Identity $_.Identity -confirm:$False}
}Else{
  Write-Host "MailUniversalSecurityGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#Deletes all distribution groups
If (Test-Path $strFileName2){
Import-CSV $strFileName2 | ForEach-Object {Remove-DistributionGroup -Identity $_.Alias -Confirm:$false}
}Else{
  Write-Host "MailNonUniversalGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}

If (Test-Path $strFileName3){
Import-CSV $strFileName3 | ForEach-Object {Remove-DistributionGroup -Identity $_.Alias -Confirm:$false}
}Else{
  Write-Host "MailUniversalDistributionGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}
