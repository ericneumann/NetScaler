<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Disconnect-NetScaler {
    <#
    .SYNOPSIS
        Disconnect session with NetScaler.

    .DESCRIPTION
        Disconnect session with NetScaler.

    .EXAMPLE
        Disconnet-NetScaler

    .EXAMPLE
        Disconnet-NetScaler -Session $session

    .PARAMETER Session
        The NetScaler session object
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session
    )

    _AssertSessionActive

    try {
        Write-Verbose -Message 'Logging out of NetScaler'
        $params = @{
            Uri =  "$($script:protocol)://$($Session.Endpoint)/nitro/v1/config/logout"
            Body = ConvertTo-Json -InputObject @{logout = @{}}
            Method = 'POST'
            ContentType = 'application/json'
            WebSession = $session.WebSession
        }
        $response = Invoke-RestMethod @params
        if ($response.errorcode -ne 0) { throw $response }
    } catch {
        throw $_
    }    
}