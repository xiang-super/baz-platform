# Workflow Template: Workflow Generator

**Purpose**: Generate reusable workflow templates with phases, gates, and artifacts from natural language descriptions
**Created**: 2025-11-13
**Input**: Natural language workflow description via $ARGUMENTS

## Execution Flow (main)

```
1. Parse workflow description from $ARGUMENTS
   → If empty: ERROR "No workflow description provided"
2. Extract workflow components:
   → Derive workflow-name (kebab-case) from description
   → Identify workflow purpose and problem statement
   → Extract input requirements
   → Identify expected outputs/artifacts
   → Map sequential phases/stages
   → Identify decision gates and checkpoints
   → Document error conditions
3. Validate workflow name
   → Check kebab-case format: ^[a-z][a-z0-9-]*$
   → If invalid: ERROR "Invalid workflow name format"
4. Run create-workflow.sh to get paths
   → Execute: `.specify/scripts/bash/create-workflow.sh --json {workflow-name}`
   → Parse JSON for: template_file, command_file, script_file, date
5. Check for file conflicts
   → If template_file exists: ERROR "Workflow template already exists"
   → If command_file exists: ERROR "Workflow command already exists"
   → Update Progress Tracking: Prerequisites validated
6. Execute Phase 0: Generate Template File
   → Load workflow-generator-template.md structure
   → Fill placeholders with extracted components:
     * [WORKFLOW_NAME] → workflow-name
     * [WORKFLOW_PURPOSE] → purpose statement
     * [INPUT_REQUIREMENTS] → input needs
     * [NUMBERED_STEPS_GO_HERE] → execution flow steps
     * [GATE_DEFINITIONS_GO_HERE] → decision gates
     * [OUTPUT_STRUCTURE_GO_HERE] → artifact structure
   → Write to template_file
   → Update Progress Tracking: Phase 0 complete
7. Execute Phase 1: Generate Slash Command
   → Create command file with:
     * description: workflow purpose
     * $ARGUMENTS handling
     * Script execution (if needed)
     * Template loading and execution
     * Result reporting
   → Write to command_file
   → Update Progress Tracking: Phase 1 complete
8. Execute Phase 2: Generate Supporting Script (optional)
   → If workflow needs setup/validation:
     * Source common.sh
     * Add path resolution
     * Include JSON output support
     * Add prerequisite checks
   → Write to script_file
   → Update Progress Tracking: Phase 2 complete
9. Final validation
   → Verify all required files created
   → Check files are valid markdown
   → Confirm no syntax errors
10. STOP - Report completion with usage instructions
```

**IMPORTANT**: This workflow STOPS at step 10. Next steps:
- Test the generated workflow with: `/[workflow-name] [test-args]`
- Customize template/command files as needed
- Add workflow to documentation

## Summary

This workflow transforms natural language workflow descriptions into executable workflow templates. It generates three artifacts: a structured template with phases and gates, a slash command wrapper, and optional supporting bash scripts.

## Technical Context

**Required Tools**: bash, create-workflow.sh script
**Dependencies**: workflow-generator-template.md meta-template, common.sh
**Environment**: Git repository with .claude/commands/ and .specify/ directories
**Constraints**: Must be run from repository root

## Constitution/Compliance Check

*GATE: Must pass before Phase 0.*

- [ ] Workflow name follows kebab-case convention
- [ ] Description includes clear purpose and phases
- [ ] Template follows established patterns (/specify, /plan, /tasks)
- [ ] Error handling is comprehensive
- [ ] Integration points are documented

## Workflow Phases

### Phase 0: Generate Template File

**Purpose**: Create structured workflow template with execution flow
**Input**: Parsed workflow components from description
**Output**: Workflow template markdown file

**Steps**:

1. Load workflow-generator-template.md as base structure
2. Replace [WORKFLOW_NAME] placeholder with kebab-case name
3. Fill [WORKFLOW_PURPOSE] with extracted purpose statement
4. Generate numbered execution flow steps from phases
5. Add decision gates with ERROR/WARN conditions
6. Document input requirements and output artifacts
7. Include progress tracking checklist
8. Add integration points (upstream/downstream workflows)
9. Write completed template to file

**Artifacts Generated**:

- `.specify/templates/[workflow-name]-template.md` - Executable workflow template

**Error Conditions**:

- ERROR if meta-template not found: "Missing workflow-generator-template.md"
- ERROR if write fails: "Cannot create template file at {path}"
- WARN if optional sections missing: "Consider adding {section}"

### Phase 1: Generate Slash Command

**Purpose**: Create slash command wrapper to invoke workflow
**Input**: Workflow name and purpose
**Output**: Slash command markdown file

**Steps**:

1. Create command file header with description
2. Add $ARGUMENTS handling block
3. Include script execution (if workflow has setup script)
4. Add template loading logic
5. Include argument passing to template
6. Add result reporting
7. Document example usage
8. Write command file

**Artifacts Generated**:

- `.claude/commands/[workflow-name].md` - Slash command definition

**Error Conditions**:

- ERROR if commands directory not writable: "Cannot create command file"
- WARN if no arguments handling: "Command may need argument validation"

### Phase 2: Generate Supporting Script (Optional)

**Purpose**: Create bash script for workflow setup/validation
**Input**: Workflow requirements
**Output**: Bash setup script

**Steps**:

1. Determine if workflow needs bash script support
2. Create script file with shebang
3. Source common.sh for shared functions
4. Add path resolution (get_repo_root, get_current_branch)
5. Include JSON output support (--json flag)
6. Add prerequisite checks (files, directories, tools)
7. Provide configuration/path discovery
8. Make script executable (chmod +x)

**Artifacts Generated**:

- `.specify/scripts/bash/[workflow-name]-setup.sh` - Setup/validation script

**Error Conditions**:

- ERROR if common.sh not found: "Missing common.sh dependency"
- ERROR if script not executable: "Failed to set executable permission"
- WARN if no prerequisites defined: "Consider adding validation"

## Decision Gates

### Gate: Name Validation

**Trigger**: After Phase 0 (before template generation)
**Purpose**: Ensure workflow name follows conventions

**Checks**:

- [ ] Name is lowercase
- [ ] Name starts with a letter
- [ ] Name contains only letters, numbers, hyphens
- [ ] Name is action-oriented and specific
- [ ] Name doesn't conflict with existing workflows

**Actions**:

- If all pass: Continue to Phase 1
- If any fail: ERROR "Fix workflow name: {details}"

### Gate: File Conflict Check

**Trigger**: Before Phase 0 (during prerequisites)
**Purpose**: Prevent overwriting existing workflows

**Checks**:

- [ ] Template file doesn't exist
- [ ] Command file doesn't exist
- [ ] Script file doesn't exist (or user confirmed overwrite)

**Actions**:

- If all pass: Continue to Phase 0
- If conflicts: ERROR "Workflow already exists at {path}"

### Gate: Completeness Check

**Trigger**: After Phase 2 (before reporting)
**Purpose**: Verify all artifacts generated successfully

**Checks**:

- [ ] Template file created and valid markdown
- [ ] Command file created and valid markdown
- [ ] Script file created (if needed) and executable
- [ ] All placeholders replaced
- [ ] No syntax errors in generated files

**Actions**:

- If all pass: Continue to final report
- If any fail: ERROR "Generation incomplete: {details}"

## Progress Tracking

Track completion of each phase:

- [ ] Prerequisites validated (name format, no conflicts)
- [ ] Gate: Name Validation passed
- [ ] Gate: File Conflict Check passed
- [ ] Phase 0: Template generated
- [ ] Phase 1: Slash command generated
- [ ] Phase 2: Supporting script generated (if needed)
- [ ] Gate: Completeness Check passed
- [ ] Final validation complete

## Output Artifacts

This workflow generates the following files:

```
.claude/commands/
└── [workflow-name].md           # Slash command (Phase 1)

.specify/
├── templates/
│   └── [workflow-name]-template.md   # Workflow template (Phase 0)
└── scripts/bash/
    └── [workflow-name]-setup.sh      # Setup script (Phase 2, optional)
```

## Error Handling

**Critical Errors (workflow stops)**:

- Missing workflow description in $ARGUMENTS
- Invalid workflow name format
- File conflicts (existing workflow with same name)
- Cannot write to templates/commands/scripts directories
- Missing meta-template or dependencies

**Warnings (workflow continues with caution)**:

- No supporting script needed (skip Phase 2)
- Optional sections not specified in description
- Minimal error handling in generated workflow

**Recovery Actions**:

- For "Missing description": Provide description as argument to /create-workflow
- For "Invalid name": Use kebab-case, lowercase, letter-first format
- For "File conflicts": Choose different workflow name or remove existing files
- For "Write permission": Check directory permissions and ownership

## Integration Points

**Upstream Dependencies**:

- This workflow requires `.specify/templates/workflow-generator-template.md` to exist
- Relies on `.specify/scripts/bash/common.sh` for shared functions
- Expects `.claude/commands/` and `.specify/` directory structure

**Downstream Workflows**:

- After this workflow, test generated workflow with: `/[workflow-name] [args]`
- Generated workflows integrate with existing workflow chain:
  - `/specify` → `/plan` → `/tasks` → custom workflows
- Custom workflows can invoke other workflows in their phases

## Usage Examples

### Example 1: Security Review Workflow

```bash
/create-workflow Create a security review workflow that scans code for vulnerabilities, validates dependencies against CVE databases, checks for hardcoded secrets, and generates a security compliance report with remediation steps
```

**Expected behavior**:

1. Extracts workflow-name: "security-review"
2. Identifies phases: scan code, validate dependencies, check secrets, generate report
3. Generates template with security-specific gates
4. Creates command: `/security-review [scope]`
5. Generates script for CVE database integration

**Artifacts**: `security-review-template.md`, `security-review.md`, `security-review-setup.sh`

### Example 2: Deployment Checklist

```bash
/create-workflow Create a deployment checklist workflow that validates environment configuration, runs pre-deployment tests, checks for breaking changes, verifies rollback plan, and creates deployment approval ticket
```

**Expected behavior**:

1. Extracts workflow-name: "deployment-checklist"
2. Identifies phases: validate config, run tests, check changes, verify rollback, create ticket
3. Generates template with deployment gates (tests pass, rollback ready)
4. Creates command: `/deployment-checklist [environment]`
5. Generates script for environment validation

**Artifacts**: `deployment-checklist-template.md`, `deployment-checklist.md`, `deployment-checklist-setup.sh`

### Example 3: Documentation Generator

```bash
/create-workflow Create a documentation workflow that extracts inline documentation from code, generates API reference from OpenAPI specs, creates usage examples, and builds a static documentation site
```

**Expected behavior**:

1. Extracts workflow-name: "documentation-generator"
2. Identifies phases: extract docs, generate API ref, create examples, build site
3. Generates template with documentation quality gates
4. Creates command: `/documentation-generator [module]`
5. Generates script for doc extraction tools setup

**Artifacts**: `documentation-generator-template.md`, `documentation-generator.md`, `documentation-generator-setup.sh`

## Notes

- **Meta-workflow**: This is a workflow that generates workflows (meta-template pattern)
- **Template-driven**: Uses `workflow-generator-template.md` as the structure
- **Flexible**: Generated workflows can be customized after creation
- **Convention-based**: Follows established patterns from `/specify`, `/plan`, `/tasks`
- **Extensible**: New phases/gates can be added to generated workflows
- **Composable**: Generated workflows integrate with existing workflow chains

**Limitations**:

- Requires clear workflow description (garbage in, garbage out)
- Cannot automatically detect all required bash script logic
- Manual customization usually needed after generation
- Generated templates need testing before production use

**Best Practices**:

- Provide detailed workflow descriptions with clear phases
- Test generated workflows immediately after creation
- Customize generated files for domain-specific needs
- Document integration points with other workflows
- Follow naming conventions (kebab-case, action-oriented)

---

**Template Version**: 2.0
**Last Updated**: 2025-11-13
**Maintained by**: Ambient Code Platform Team
