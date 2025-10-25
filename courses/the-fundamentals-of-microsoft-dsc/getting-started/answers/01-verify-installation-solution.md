# Solution: Verify your Microsoft DSC installation

## Step 1: Check DSC Version

```bash
dsc --version
```

**Example Output:**

```plaintext
dsc 3.2.0-preview.6
```

Record the version number you see.

## Step 2: List Available DSC Commands

Run `dsc --help` to see all available commands:

```bash
dsc --help
```

**Available commands (excluding --version and --help):**

- `completer` - Generate a shell completion script
- `config` - Configuration document operations
- `extension` - Operations on DSC extensions
- `function` - Operations on DSC functions
- `mcp` - Use DSC as a MCP server
- `resource` - Invoke a specific DSC resource
- `schema` - Schema operations

### Subcommands for each

**config subcommands:**

```bash
dsc config --help
```

- `get` - Retrieve the current configuration
- `set` - Set the current configuration
- `test` - Test the current configuration
- `export` - Export the current configuration

**resource subcommands:**

```bash
dsc resource --help
```

- `list` - List or find resources
- `get` - Invoke the get operation to a resource
- `set` - Invoke the set operation to a resource
- `test` - Invoke the test operation to a resource
- `delete` - Invoke the delete operation to a resource
- `schema` - Get the JSON schema for a resource
- `export` - Retrieve all resource instances

## Step 3: List available DSC functions

To see available functions, you can check the documentation or use autocomplete:

```bash
dsc function list
```

Look for the "DSC Functions" section in the documentation. Common functions include:

- `base64()` - Base64 encoding/decoding
- `concat()` - Concatenate values
- `createArray()` - Create an array
- `envvar()` - Get environment variable
- `parameters()` - Reference configuration parameters
- `reference()` - Reference resource output
- `resourceId()` - Get resource identifier
- `uri()` - Combine base and relative URIs
- And more...

**Count:** There are approximately 60+ built-in DSC functions available.

To get the exact count, you can check the schema:

```powershell
(dsc function list | ConvertFrom-Json | Select-Object -ExpandProperty name | Measure-Object).Count
```

## Step 4: Document OS information using DSC resource

Use the `Microsoft/OSInfo` resource to get system information:

```bash
dsc resource get --resource Microsoft/OSInfo
```

**Example Output (Windows):**

```json
{
  "actualState": {
    "family": "Windows",
    "version": "10.0.22631",
    "edition": "Windows 11 Pro",
    "bitness": "64"
  }
}
```

**Example Output (Linux):**

```json
{
  "actualState": {
    "family": "Linux",
    "version": "6.5.0-35-generic",
    "edition": "Ubuntu 22.04.3 LTS",
    "bitness": "64"
  }
}
```

**Example Output (macOS):**

```json
{
  "actualState": {
    "family": "MacOS",
    "version": "14.1.2",
    "edition": "macOS Sonoma",
    "bitness": "64"
  }
}
```

## Summary

You've successfully:

- ✅ Verified your DSC installation and version
- ✅ Discovered available DSC commands and subcommands
- ✅ Listed DSC functions
- ✅ Retrieved system information using a DSC resource
