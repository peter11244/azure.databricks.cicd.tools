<#
.SYNOPSIS
List all permissions assigned to a Secret Scope

.DESCRIPTION
List all permissions assigned to a secret scope

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Datatbricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER ScopeName
The scope to return the permissions for


.EXAMPLE
PS C:\> Get-DatabricksSecretScopePermissions -BearerToken $BearerToken -Region $Region -ScopeName "MyScope"

.NOTES
Author: Simon D'Morias / Data Thirst Ltd 

#>  

Function Get-DatabricksSecretScopePermissions
{ 
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false)][string]$BearerToken, 
        [parameter(Mandatory = $false)][string]$Region,
        [parameter(Mandatory = $true)][string]$ScopeName
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Headers = GetHeaders $PSBoundParameters
    
    
    Try {
        $scope_permissions = Invoke-RestMethod -Method Get -Uri "$global:DatabricksURI/api/2.0/secrets/acls/list" -Headers $Headers
    }
    Catch {
        Write-Output "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Output "StatusDescription:" $_.Exception.Response.StatusDescription
        Write-Error $_.ErrorDetails.Message
    }

    return $scope_permissions.items
    }
    