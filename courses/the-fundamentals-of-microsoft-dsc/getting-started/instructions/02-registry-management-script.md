# Exercise 2: Create registry management script

**Difficulty:** Medium

## Description

Build a PowerShell script that manages registry keys using the `Microsoft.Windows/Registry` resource with full CRUD operations and driven behavior using parameters.

## Prerequisites

- PowerShell 7+ or Windows PowerShell 5.1
- Microsoft DSC installed
- Windows operating system
- Appropriate permissions for registry operations

## Your task

Create a PowerShell script that:

1. Accepts parameters for operation type (`get`, `set`, `test`, `delete`)
2. Creates a registry key with `_exist = $true` when using `set`
3. Implements `get` operation to retrieve current registry key state
4. Implements `test` operation to verify if key exists and matches desired state
5. Implements `delete` operation when `_exist = $false` is specified
6. Uses the `Microsoft.Windows/Registry` DSC resource
7. Includes error handling and validation
8. Provides clear output showing the operation result in PowerShell objects

## Script parameters

Your script should accept the following parameters:

- **Operation** (mandatory) - The operation to perform: `get`, `set`, `test`, or `delete`
- **KeyPath** (mandatory) - The registry key path (e.g., `HKCU\Software\MyApp`)
- **ValueName** (optional) - The name of the registry value
- **ValueData** (optional) - The data to set (required for `set` operation)
- **ValueType** (optional) - The type of data: `String`, `DWord`, `QWord`, `Binary`, etc.

## Hints

- Use a `[ValidateSet]` attribute for the operation parameter
- Build the JSON input dynamically based on the operation
- Use `ConvertFrom-Json` to parse DSC output for better handling
- Remember: `delete` requires setting `_exist` to false in the input
- Test your script with HKCU hive to avoid needing admin privileges

## Expected outcome

Your script should:

- Successfully perform all four CRUD operations
- Handle errors gracefully
- Provide clear, formatted output
- Be reusable and maintainable
- Follow PowerShell best practices

## Testing your script

Test your script with these example operations:

1. **Set** a registry value:

   ```powershell
   .\Manage-Registry.ps1 -Operation set -KeyPath "HKCU\Software\MyTestApp" -ValueName "TestValue" -ValueData "Hello" -ValueType String
   ```

2. **Get** the registry value:

   ```powershell
   .\Manage-Registry.ps1 -Operation get -KeyPath "HKCU\Software\MyTestApp" -ValueName "TestValue"
   ```

3. **Test** the registry state:

   ```powershell
   .\Manage-Registry.ps1 -Operation test -KeyPath "HKCU\Software\MyTestApp" -ValueName "TestValue"
   ```

4. **Delete** the registry value:

   ```powershell
   .\Manage-Registry.ps1 -Operation delete -KeyPath "HKCU\Software\MyTestApp" -ValueName "TestValue"
   ```

## Bonus challenges

- Add support for multiple registry value types (Binary, MultiString, ExpandString).
- Add verbose output for debugging.
- Create a function-based version instead of a script.
- Add parameter validation for registry paths.
