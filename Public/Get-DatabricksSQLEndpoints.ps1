<#
.SYNOPSIS
Get a list of SQL Endpoints

.DESCRIPTION
Get a list of SQL Endpoints

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Datatbricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER SQLEndpointId
Optional. Returns just a single endpoint.

.EXAMPLE
PS C:\> Get-DatabricksClusters -BearerToken $BearerToken -Region $Region

Returns all clusters

.NOTES
Author: Simon D'Morias / Data Thirst Ltd

#>

Function Get-DatabricksClusters 
{ 
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true, ParameterSetName='Bearer')]
        [string]$BearerToken, 

        [parameter(Mandatory = $false, ParameterSetName='Bearer')]
        [parameter(Mandatory = $false, ParameterSetName='AAD')]
        [string]$Region,
        
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$EndpointId
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Headers = GetHeaders $PSBoundParameters

    Try {
        $Endpoints = Invoke-RestMethod -Method Get -Uri "$global:DatabricksURI/api/2.0/sql/endpoints/" -Headers $Headers
    }
    Catch {
        Write-Error "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Error "StatusDescription:" $_.Exception.Response.StatusDescription
        Write-Error $_.ErrorDetails.Message
    }

    if ($PSBoundParameters.ContainsKey('EndpointId')){
        $Result = $Endpoints.endpoints | Where-Object {$_.id -eq $EndpointId}
        Return $Result
    }
    else {
        Return $Endpoints.endpoints
    }

}
    