# Registry Management Script using Microsoft DSC
# This script provides CRUD operations for Windows Registry using DSC

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('get', 'set', 'test', 'delete')]
    [string]$Operation,

    [Parameter(Mandatory = $true)]
    [string]$KeyPath,

    [Parameter(Mandatory = $false)]
    [string]$ValueName,

    [Parameter(Mandatory = $false)]
    [string]$ValueData,

    [Parameter(Mandatory = $false)]
    [ValidateSet('String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'QWord')]
    [string]$ValueType = 'String'
)

# Function to build the DSC input JSON
function Build-DscInput {
    param(
        [string]$Operation,
        [string]$KeyPath,
        [string]$ValueName,
        [string]$ValueData,
        [string]$ValueType
    )

    $properties = @{
        keyPath = $KeyPath
    }

    if ($ValueName) {
        $properties.valueName = $ValueName
    }

    if ($Operation -eq 'set' -and $ValueData) {
        $valueDataObject = switch ($ValueType) {
            'String'       { @{ String = $ValueData } }
            'ExpandString' { @{ ExpandString = $ValueData } }
            'DWord'        { @{ DWord = [int]$ValueData } }
            'QWord'        { @{ QWord = [long]$ValueData } }
            'Binary'       { @{ Binary = [byte[]]($ValueData -split ',' | ForEach-Object { [byte]$_ }) } }
            'MultiString'  { @{ MultiString = $ValueData -split ',' } }
        }
        $properties.valueData = $valueDataObject
        $properties._exist = $true
    }

    if ($Operation -eq 'delete') {
        $properties._exist = $false
    }

    return $properties | ConvertTo-Json -Depth 10 -Compress
}

# Function to invoke DSC resource operation
function Invoke-DscResourceOperation {
    param(
        [string]$Operation,
        [string]$In
    )

    try {
        $result = dsc resource $Operation --resource Microsoft.Windows/Registry --input $In 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "DSC operation failed with exit code $LASTEXITCODE"
        }
        return $result | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to execute DSC operation: $_"
        return $null
    }
}


Write-Verbose "Building DSC input for operation: $Operation"
$dscInput = Build-DscInput -Operation $Operation -KeyPath $KeyPath -ValueName $ValueName -ValueData $ValueData -ValueType $ValueType
Write-Verbose "DSC Input: $dscInput"

Write-Host "Executing $Operation operation on $KeyPath..." -ForegroundColor Cyan

$result = Invoke-DscResourceOperation -Operation $Operation -In $dscInput

if ($null -eq $result -and $Operation -ne 'delete') {
    Write-Error "Operation failed"
    exit 1
}

switch ($Operation) {
    'get' {
        Write-Host "`nRegistry State:" -ForegroundColor Green
        if ($result.actualState) {
            $state = $result.actualState
            Write-Host "  Key Path:   $($state.keyPath)" -ForegroundColor White
            
            if ($state.valueName) {
                Write-Host "  Value Name: $($state.valueName)" -ForegroundColor White
                
                if ($state.valueData) {
                    $dataValue = if ($state.valueData.PSObject.Properties.Name) {
                        $state.valueData.PSObject.Properties.Value
                    } else {
                        'No data'
                    }
                    Write-Host "  Value Data: $dataValue" -ForegroundColor White
                }
            }
            
            if ($null -ne $state._exist) {
                $existStatus = if ($state._exist) { "Exists" } else { "Does not exist" }
                Write-Host "  Status:     $existStatus" -ForegroundColor $(if ($state._exist) { "Green" } else { "Yellow" })
            }
        }
    }
    'set' {
        Write-Host "`nRegistry value set successfully!" -ForegroundColor Green
        if ($result.afterState) {
            Write-Host "  Key Path:   $($result.afterState.keyPath)" -ForegroundColor White
            Write-Host "  Value Name: $($result.afterState.valueName)" -ForegroundColor White
        }
    }
    'test' {
        $inDesiredState = $result.PSObject.Properties.Name -contains '_inDesiredState' -and $result._inDesiredState
        
        Write-Host "`nTest Result:" -ForegroundColor Green
        if ($inDesiredState) {
            Write-Host "  ✓ System is in desired state" -ForegroundColor Green
        } else {
            Write-Host "  ✗ System is NOT in desired state" -ForegroundColor Yellow
        }
        
        if ($result.actualState) {
            Write-Host "`n  Current State:" -ForegroundColor Cyan
            Write-Host "    Key Path:   $($result.actualState.keyPath)" -ForegroundColor White
            if ($result.actualState.valueName) {
                Write-Host "    Value Name: $($result.actualState.valueName)" -ForegroundColor White
            }
        }
    }
    'delete' {
        Write-Host "`nRegistry value deleted successfully!" -ForegroundColor Green
        if ($result.afterState) {
            $existStatus = if ($result.afterState._exist -eq $false) { "Removed" } else { "Not found" }
            Write-Host "  Status: $existStatus" -ForegroundColor White
        }
    }
}

return $result
