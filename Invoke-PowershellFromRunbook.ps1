<#

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=0)]
    [String]$ContainerName = "blobcontainer", #replace with your container name
    [Parameter(Mandatory=$False,Position=1)]
    [String]$FileName = "script.ps1",         #replace with you script name file uploaded to the blob
    [Parameter(Mandatory=$False,Position=2)]
    [ValidateSet("eastus","eastus2")]         
    [String]$AZRegion = "eastus",             #add regions to the array if you plan on building outside of East US 1 & 2
    [Parameter(Mandatory=$False,Position=3)]
    [String]$Name = "unique",                 #replace with a unique name, this will be the extension name on the instance  
    [Parameter(Mandatory=$False,Position=4)]
    [String]$RGName = "resourcegroupname",    #replace with your resource group name
    [Parameter(Mandatory=$False,Position=5)]
    [String]$StorageAccountName = "storage",  #replace with your storage account name
    [Parameter(Mandatory=$False,Position=6)]
    [String]$StorageKey = "keyasstring",      #replace the string with you storage key, 
    [Parameter(Mandatory=$False,Position=7)]
    [String]$VMName = "instanceA"             #replace with the instance you want to run the script 
)
        

Write-Output "Logging in to Azure..."
    $connectionName = "AzureRunAsConnection"
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName 
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
    | Out-Null

Write-Output "Running Script $FileName on $VMName..."
$Return = Set-AzureRmVMCustomScriptExtension `
    -ContainerName $ContainerName `
    -FileName $FileName `
    -Location $AZRegion `
    -Name $Name `
    -ResourceGroupName $RGName `
    -StorageAccountName $StorageAccountName `
    -StorageAccountKey  $StorageKey `
    -VMName $VMName

If($($Return.IsSuccessStatusCode) -eq $True)
{
    Write-Output "Script $Filename ran successfully on $VMName"
}
Else
{
    Write-Output "Deployment $Failname failed on $VMName"
}