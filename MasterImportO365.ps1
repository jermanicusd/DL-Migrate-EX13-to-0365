#connect to O365
$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session
#-----------------------------------------#

#File Paths
$strFileName1="c:\temp\DL\TestCSVs\MailUniversalSecurityGroup.csv"
$strFileName2="c:\temp\DL\TestCSVs\MailNonUniversalGroup.csv"
$strFileName3="c:\temp\DL\TestCSVs\MailUniversalDistributionGroup.csv"
$strFileName4="c:\temp\DL\TestCSVs\DLmembers.csv"
$strFileName5="c:\temp\DL\TestCSVs\AllDLGroupTypes.csv"

#Enable Security Groups - MailUniversalSecurityGroup
If (Test-Path $strFileName1){
Import-CSV $strFileName1 | ForEach-Object{Enable-distributiongroup -Identity $_.Identity -Alias $_.Alias -DisplayName $_.DisplayName -PrimarySmtpAddress $_.PrimarySMTPAddress -confirm:$False}
}Else{
  Write-Host "MailUniversalSecurityGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#Create Distribution Groups - MailNonUniversal
If (Test-Path $strFileName2){
Import-CSV $strFileName2 | ForEach-Object {New-DistributionGroup -Name $_.Name -Type Distribution -Managedby $_.managedby -OrganizationalUnit $_.OrganizationalUnit -PrimarySMTPaddress $_.PrimarySMTPaddress}
}Else{
  Write-Host "MailNonUniversalGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#Create Distribution Groups - MailUniversalDistributionGroup
If (Test-Path $strFileName3){
Import-CSV $strFileName3 | ForEach-Object {New-DistributionGroup -Name $_.Name -Type Distribution -Managedby $_.managedby -OrganizationalUnit $_.OrganizationalUnit -PrimarySMTPaddress $_.PrimarySMTPaddress}
}Else{
  Write-Host "MailUniversalDistributionGroup.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#Add members to Distribution Groups - DLmembers
If (Test-Path $strFileName4){
Import-Csv $strFileName4 | ForEach-Object{Add-DistributionGroupMember -Identity $_.DistributionGroup -Member $_.alias}
}Else{
  Write-Host "DLmembers.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#Edit Settings of Distribution Groups - AllDLGroupTypes
If (Test-Path $strFileName5){
Import-Csv $strFileName5 | ForEach-Object{
$hidden = $_.hiddenfromaddresslistsenabled -eq 'true'
$reqauth = $_.requiresenderauthenticationenabled -eq 'true'
Set-DistributionGroup -Identity $_.name -hiddenfromaddresslistsenabled $hidden -requiresenderauthenticationenabled $reqauth -EmailAddressPolicyEnabled:$true}
}Else{
  Write-Host "AllDLGroupTypes.csv does not exist" -foregroundcolor red -backgroundcolor white
}

#-----------------------------------------#
Remove-PSSession $Session
