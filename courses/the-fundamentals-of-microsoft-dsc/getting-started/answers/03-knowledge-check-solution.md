# Solution: Knowledge Check

## Answers

### 1. What does DSC stand for, and what problem does it solve in configuration management?

**Answer:** DSC stands for **Desired State Configuration**.

It solves the problem of configuration drift and ensures systems remain in their intended state. DSC provides a declarative approach to configuration management where you specify *what* you want the system to look like, rather than *how* to make it that way. This eliminates the need for complex scripts that handle every possible system state and makes configurations more maintainable and predictable.

---

### 2. How does DSC differ from imperative configuration tools?

**Answer:** DSC is **declarative** while traditional tools are **imperative**.

- **Imperative approach**: You write step-by-step instructions (scripts) that tell the system exactly how to achieve a configuration. Example: "If registry key doesn't exist, create it. If value is wrong, change it."
  
- **Declarative approach (DSC)**: You describe the desired end state, and DSC figures out how to achieve it. Example: "This registry key should exist with these values."

The declarative approach is more resilient because DSC handles the logic of getting from the current state to the desired state, including dealing with edge cases you might not have considered.

---

### 3. What does it mean when we say DSC is idempotent?

**Answer:** **Idempotent** means that applying the same configuration multiple times produces the same result without side effects.

If you run a DSC configuration when the system is already in the desired state, nothing changes. If the system has drifted from the desired state, DSC makes only the necessary changes to restore it. You can safely apply a configuration repeatedly without worrying about duplicate actions or unintended changes.

Example: If a configuration says "ensure file X exists," running it 10 times won't create 10 files. It will ensure the file exists once.

---

### 4. What's the role of a DSC Resource?

**Answer:** A DSC Resource is an **abstraction** that represents a configurable component of a system and defines how to interact with it.

Resources:

- **Encapsulate** the logic for managing a specific system component (like files, registry keys, services, packages)
- **Provide operations** to `get`, `set`, `test`, `delete`, and `export` the state of the component
- **Abstract complexity** away from configuration authors
- **Enable reusability** across different configurations

Examples: `Microsoft.Windows/Registry`, `PSDscResources/File`, `Microsoft.WinGet.DSC/WinGetPackage`

---

### 5. How do DSC configuration documents describe the desired state of a system?

**Answer:** DSC configuration documents use a **structured, declarative format** (YAML, JSON, or Bicep) that specifies:

1. **Resources** to configure (what type of component)
2. **Properties** of each resource (desired values and settings)
3. **Dependencies** between resources (what order to apply)
4. **Parameters** for reusability (variables that can change per deployment)

Example structure:

```yaml
$schema: https://aka.ms/dsc/schemas/v3/config/document.json
resources:
  - name: MyResource
    type: Microsoft.Windows/Registry
    properties:
      keyPath: HKCU\Software\MyApp
      valueName: Setting
      valueData:
        String: "Value"
```

---

### 6. What are the main operations supported by DSC resources?

**Answer:** DSC resources support four main operations:

1. **Get** - Retrieve the current state of a resource
2. **Set** - Apply the desired state configuration
3. **Test** - Check if the current state matches the desired state (returns true/false)
4. **Export** - Generate a configuration document from the current state

Some resources may support additional operations like:

- **Validate** - Validate configuration document syntax
- **Delete** - Remove or ensure absence of a resource

---

### 7. How is DSC different from PowerShell DSC in terms of dependencies and architecture?

**Answer:** Key differences:

**PowerShell DSC (v2):**

- Requires Windows PowerShell 5.1 or PowerShell 7+
- Tied to the .NET ecosystem
- Windows-focused (though some cross-platform support exists)
- Includes Local Configuration Manager (LCM)
- Heavier runtime footprint

**Microsoft DSC (v3):**

- **Standalone executable** written in Rust
- No PowerShell dependency (though can use PowerShell resources via adapters)
- **Cross-platform** by design (Windows, Linux, macOS)
- No LCM - designed for integration with external orchestration tools
- **Lightweight** and fast
- **Schema-driven** with JSON Schema validation
- Supports multiple resource types through adapters (PowerShell, command-line tools, etc.)

---

### 8. What formats can DSC configuration documents be written in?

**Answer:** DSC configuration documents can be written in:

1. **YAML** (`.yaml` or `.yml`) - Human-readable, preferred for authoring
2. **JSON** (`.json`) - Machine-readable, used for APIs and tooling
3. **Bicep** (`.bicep`) - Infrastructure as Code language that can generate DSC configurations through an extension

All formats are equivalent and can be used to validated against the same JSON schema.
YAML is typically more user-friendly. The same as Bicep. Remember only this: **down the line**, JSON is used.

---

### 9. Why doesn't the new DSC include a Local Configuration Manager?

**Answer:** The new DSC was designed with a **different philosophy** and **use case** in mind:

**Reasons for removing LCM:**

1. **Separation of concerns** - DSC focuses on *what* to configure, not *when* or *how often*. Orchestration is left to external tools (Azure Machine Configuration, Ansible, Chef, custom schedulers).

2. **Simplified architecture** - Without LCM, DSC is lighter, easier to maintain, and more portable.

3. **Flexibility** - Users can choose their own scheduling, deployment, and monitoring tools rather than being locked into the LCM model.

4. **Stateless operation** - The new DSC can be run on-demand without maintaining persistent state or background services.
