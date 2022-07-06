#Check if exchange snap in is loaded and if not then load#
$snapinAdded = Get-PSSnapin | Select-String Microsoft.Exchange.Management.PowerShell.Admin
if (!$snapinAdded)
{
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
}

#File Paths - Local
$WorkingDir = Read-Host "Enter Working Directory Containing CSVs"
$strFileName1 = $WorkingDir + "\DLmembers.csv"
$strFileName2 = $WorkingDir + "\AllDLGroupTypes.csv"
$strFileName3 = $WorkingDir + "\MailUniversalDistributionGroup.csv”
$strFileName4 = $WorkingDir + "\MailUniversalSecurityGroup.csv"
$strFileName5 = $WorkingDir + "\MailNonUniversalGroup.csv"

#Export Members to csv#
$dist = ForEach ($group in (Get-DistributionGroup -Filter {name -like "*"})) {  
            Get-DistributionGroupMember $group | Select-Object @{Label="DistributionGroup";Expression={$Group.Name}},@{Label="User";Expression={$_.Name}},SamAccountName, Alias 
        }
$dist | Sort-Object DistributionGroup,User | Export-CSV $strFileName1 -NoTypeInformation

#Export distribution groups by type.
Get-DistributionGroup -resultsize unlimited | Export-csv -Path $strFileName2 -NoTypeInformation

Get-DistributionGroup -RecipientTypeDetails MailUniversalDistributionGroup -resultsize unlimited | Export-csv -Path $strFileName3 -NoTypeInformation

Get-DistributionGroup -RecipientTypeDetails MailUniversalSecurityGroup -resultsize unlimited | Export-csv -Path $strFileName4 -NoTypeInformation

Get-DistributionGroup -RecipientTypeDetails MailNonUniversalGroup -resultsize unlimited | Export-csv -Path $strFileName5 -NoTypeInformation

#Copy csv to server
$ServerDir = Read-Host "Enter Server Directory to copy CSVs to"
Copy-Item -Path $strFileName1 -Destination $ServerDir + "\DLmembers.csv";
Copy-Item -Path $strFileName2 -Destination $ServerDir + "\AllDLGroupTypes.csv";
Copy-Item -Path $strFileName3 -Destination $ServerDir + "\MailUniversalDistributionGroup.csv";
Copy-Item -Path $strFileName4 -Destination $ServerDir + "\MailUniversalSecurityGroup.csv";
Copy-Item -Path $strFileName5 -Destination $ServerDir + "\MailNonUniversalGroup.csv";
