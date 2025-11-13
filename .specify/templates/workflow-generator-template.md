
# Workflow Template: [WORKFLOW_NAME]

**Purpose**: [WORKFLOW_PURPOSE]
**Created**: [DATE]
**Input**: [INPUT_REQUIREMENTS]

## Execution Flow (main)
```
[NUMBERED_STEPS_GO_HERE]
Example structure:
1. Load input from [source]
   → If not found: ERROR "Missing required input"
2. Validate prerequisites
   → Check for [required files/config]
   → If invalid: ERROR "Prerequisites not met"
3. Execute Phase 0: [Phase Name]
   → Generate [artifact1.md]
   → Update Progress Tracking
4. Evaluate [Gate Name]
   → If [condition]: ERROR "Gate failed"
   → If [warning condition]: WARN "Review required"
5. Execute Phase 1: [Phase Name]
   → Generate [artifact2.md]
   → Update Progress Tracking
6. Execute Phase 2: [Phase Name]
   → Generate [artifact3.md]
   → Update Progress Tracking
7. Final validation
   → Check all required outputs exist
   → Verify no ERROR states
8. STOP - [Next action or handoff]
```

**IMPORTANT**: This workflow STOPS at step [N]. Next steps:
- [Next command/action]: [Description]
- [Alternative path]: [Description]

## Summary
[Brief description of what this workflow accomplishes]

## Technical Context *(if applicable)*
**Required Tools**: [e.g., bash scripts, external APIs]
**Dependencies**: [e.g., other workflows that must run first]
**Environment**: [e.g., git repository required, specific file structure]
**Constraints**: [e.g., must be run from repo root]

## Constitution/Compliance Check *(if applicable)*
*GATE: Must pass before Phase 0. Re-check after Phase [N].*

[GATE_DEFINITIONS_GO_HERE]
Example:
- [ ] Follows project coding standards
- [ ] Includes required security checks
- [ ] Documentation complete
- [ ] Test coverage adequate

## Workflow Phases

### Phase 0: [Phase Name]
**Purpose**: [What this phase accomplishes]
**Input**: [What this phase needs]
**Output**: [What this phase generates]

**Steps**:
1. [Step description]
2. [Step description]
3. [Step description]

**Artifacts Generated**:
- `[path/to/artifact1.md]` - [Description]

**Error Conditions**:
- ERROR if [condition]: [Error message]
- WARN if [condition]: [Warning message]

### Phase 1: [Phase Name]
**Purpose**: [What this phase accomplishes]
**Input**: [What this phase needs]
**Output**: [What this phase generates]

**Steps**:
1. [Step description]
2. [Step description]
3. [Step description]

**Artifacts Generated**:
- `[path/to/artifact2.md]` - [Description]
- `[path/to/artifact3.md]` - [Description]

**Error Conditions**:
- ERROR if [condition]: [Error message]
- WARN if [condition]: [Warning message]

### Phase 2: [Phase Name]
**Purpose**: [What this phase accomplishes]
**Input**: [What this phase needs]
**Output**: [What this phase generates]

**Steps**:
1. [Step description]
2. [Step description]
3. [Step description]

**Artifacts Generated**:
- `[path/to/artifact4.md]` - [Description]

**Error Conditions**:
- ERROR if [condition]: [Error message]
- WARN if [condition]: [Warning message]

## Decision Gates

### Gate: [Gate Name]
**Trigger**: After Phase [N]
**Purpose**: [What this gate validates]

**Checks**:
- [ ] [Check 1]: [Description]
- [ ] [Check 2]: [Description]
- [ ] [Check 3]: [Description]

**Actions**:
- If all pass: Continue to next phase
- If any fail: [Remediation action]
- If warnings: [Review action]

### Gate: [Gate Name]
**Trigger**: After Phase [N]
**Purpose**: [What this gate validates]

**Checks**:
- [ ] [Check 1]: [Description]
- [ ] [Check 2]: [Description]

**Actions**:
- If all pass: Continue to next phase
- If any fail: [Remediation action]

## Progress Tracking

Track completion of each phase:

- [ ] Prerequisites validated
- [ ] Phase 0: [Phase Name] - [Artifact]
- [ ] Gate: [Gate Name] passed
- [ ] Phase 1: [Phase Name] - [Artifacts]
- [ ] Gate: [Gate Name] passed
- [ ] Phase 2: [Phase Name] - [Artifacts]
- [ ] Final validation complete

## Output Artifacts

This workflow generates the following files:

```
[OUTPUT_STRUCTURE_GO_HERE]
Example:
specs/[feature-name]/
├── [artifact1.md]         # Phase 0 output
├── [artifact2.md]         # Phase 1 output
├── [artifact3.md]         # Phase 1 output
└── [artifact4.md]         # Phase 2 output
```

## Error Handling

**Critical Errors (workflow stops)**:
- Missing required input files
- Gate validation failures
- [Other critical conditions]

**Warnings (workflow continues with caution)**:
- Incomplete optional sections
- [Other warning conditions]

**Recovery Actions**:
- For [error type]: [Recovery steps]
- For [error type]: [Recovery steps]

## Integration Points

**Upstream Dependencies**:
- This workflow requires [previous workflow/command] to complete first
- Input comes from [source]

**Downstream Workflows**:
- After this workflow, run [next workflow/command]
- Outputs feed into [downstream process]

## Usage Examples

### Example 1: [Use case]
```bash
/[workflow-name] [example arguments]
```

**Expected behavior**:
1. [Step 1]
2. [Step 2]
3. Generates [artifacts]

### Example 2: [Use case]
```bash
/[workflow-name] [different arguments]
```

**Expected behavior**:
1. [Step 1]
2. [Step 2]
3. Generates [artifacts]

## Notes

- [Important note about workflow behavior]
- [Limitation or constraint]
- [Tips for successful execution]

---

**Template Version**: 1.0
**Last Updated**: [DATE]
**Maintained by**: [Team/Person]
