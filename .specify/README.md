# Workflow Generation System

This directory contains the infrastructure for creating and managing workflow templates in the Ambient Code Platform.

## Overview

The workflow generation system enables you to create standardized, reusable workflow templates that follow consistent patterns across your development process. Each workflow consists of:

1. **Template** (`.specify/templates/[name]-template.md`) - Executable workflow logic with phases and gates
2. **Slash Command** (`.claude/commands/[name].md`) - User-facing command to invoke the workflow
3. **Supporting Scripts** (`.specify/scripts/bash/[name]-setup.sh`) - Optional bash scripts for setup/validation

## Quick Start

### Creating a New Workflow

```bash
/create-workflow <workflow-description>
```

**Example**:
```bash
/create-workflow Create a security review workflow that checks code for vulnerabilities, validates dependencies, and generates a compliance report
```

This will generate:
- A workflow template with phases, gates, and artifacts
- A slash command to execute the workflow
- Supporting scripts if needed

### Using Generated Workflows

Once created, invoke your workflow with:

```bash
/[workflow-name] [arguments]
```

**Example**:
```bash
/security-review --scope backend
```

## Directory Structure

```
.specify/
├── README.md                    # This file
├── memory/                      # Workflow state and history
│   └── constitution.md          # Project constitution/principles
├── scripts/                     # Supporting automation
│   └── bash/
│       ├── common.sh           # Shared bash functions
│       ├── create-workflow.sh  # Workflow creation helper
│       ├── create-new-feature.sh
│       ├── setup-plan.sh
│       └── check-prerequisites.sh
└── templates/                   # Workflow templates
    ├── workflow-generator-template.md  # Meta-template for creating workflows
    ├── spec-template.md                # Feature specification template
    ├── plan-template.md                # Implementation planning template
    ├── tasks-template.md               # Task generation template
    └── agent-file-template.md          # Agent configuration template
```

## Workflow Anatomy

### Template Structure

Every workflow template follows this pattern:

```markdown
# Workflow Template: [NAME]

## Execution Flow (main)
- Numbered steps with gates
- ERROR conditions (workflow stops)
- WARN conditions (workflow continues with caution)
- STOP points (handoff to next workflow)

## Technical Context
- Required tools and dependencies
- Environment requirements
- Constraints

## Constitution/Compliance Check
- Quality gates
- Standards validation

## Workflow Phases
### Phase 0: [Name]
- Purpose, inputs, outputs
- Steps to execute
- Artifacts generated
- Error conditions

### Phase N: [Name]
- (Repeat for each phase)

## Decision Gates
- Validation points
- Pass/fail criteria
- Remediation actions

## Progress Tracking
- Checklist of completed phases
- Artifact generation status

## Output Artifacts
- Directory structure
- Generated files

## Integration Points
- Upstream dependencies
- Downstream workflows
```

### Slash Command Structure

Commands are simple wrappers that invoke templates:

```markdown
---
description: [What the workflow does]
---

User input: $ARGUMENTS

1. Run setup script (if needed)
2. Load and execute template
3. Pass arguments as context
4. Report results
```

## Existing Workflows

### Feature Development Workflow

1. **`/specify`** - Create feature specification
   - Input: Natural language feature description
   - Output: `specs/[feature]/spec.md`
   - Next: `/plan`

2. **`/plan`** - Generate implementation plan
   - Input: Feature specification
   - Output: `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`
   - Next: `/tasks`

3. **`/tasks`** - Create task breakdown
   - Input: Implementation plan
   - Output: `tasks.md` with dependency-ordered tasks
   - Next: Execute tasks

4. **`/clarify`** - Identify underspecified areas
   - Input: Feature specification
   - Output: Updated spec with clarifications
   - Usage: Run before `/plan` to reduce rework

5. **`/analyze`** - Validate artifact consistency
   - Input: Generated design artifacts
   - Output: Quality analysis report
   - Usage: Run after `/tasks` for validation

## Creating Custom Workflows

### Step 1: Define Your Workflow

Answer these questions:

- **What problem does this solve?** (Purpose)
- **What inputs does it need?** (Prerequisites)
- **What outputs does it create?** (Artifacts)
- **What are the phases?** (Sequential steps)
- **What can go wrong?** (Error conditions)
- **What quality checks are needed?** (Gates)

### Step 2: Generate the Workflow

```bash
/create-workflow [description]
```

The system will:
1. Parse your description
2. Extract phases, gates, inputs, outputs
3. Generate template and command files
4. Create supporting scripts if needed

### Step 3: Customize Generated Files

Review and edit:

1. **Template file** - Refine execution flow, add domain-specific logic
2. **Command file** - Adjust argument handling
3. **Script file** - Add setup/validation logic

### Step 4: Test Your Workflow

```bash
/[your-workflow-name] [test-arguments]
```

Verify:
- All phases execute correctly
- Gates catch errors appropriately
- Artifacts are generated
- Error handling works

## Workflow Patterns

### Pattern 1: Linear Pipeline

Each phase depends on the previous:

```
Input → Phase 0 → Gate → Phase 1 → Gate → Phase 2 → Output
```

**Example**: `/specify` → `/plan` → `/tasks`

### Pattern 2: Validation Workflow

Focuses on checking existing artifacts:

```
Input → Analyze → Gate → Report/Fix → Validate → Output
```

**Example**: `/analyze` validates spec/plan/tasks consistency

### Pattern 3: Interactive Workflow

Requires user input during execution:

```
Input → Phase 0 → User Choice → Branch A/B → Phase N → Output
```

**Example**: `/clarify` asks questions, updates spec based on answers

### Pattern 4: Parallel Execution

Multiple independent phases:

```
Input → Phase 0 (splits) → [Phase 1A, Phase 1B, Phase 1C] → Merge → Output
```

**Usage**: When phases don't depend on each other

## Best Practices

### Workflow Design

1. **Single Responsibility** - Each workflow should do one thing well
2. **Clear Handoffs** - Define explicit STOP points and next steps
3. **Fail Fast** - Use ERROR gates early to catch problems
4. **Idempotent** - Running twice should be safe
5. **Composable** - Workflows should chain together naturally

### Template Quality

1. **Explicit Execution Flow** - Number every step
2. **Document Gates** - Every ERROR/WARN condition should be clear
3. **Track Progress** - Include checklist of phases
4. **Show Examples** - Include usage examples in template

### Error Handling

1. **ERROR** - Critical failures (missing inputs, invalid data)
2. **WARN** - Non-critical issues (incomplete optional sections)
3. **INFO** - Helpful context (suggestions, next steps)

### Integration

1. **Use Common Scripts** - Source `common.sh` for shared functions
2. **JSON Output** - Scripts should support `--json` flag
3. **Absolute Paths** - Always use absolute paths from repo root
4. **Environment Variables** - Support env var overrides

## Advanced Features

### Constitution Checks

Add project-specific quality gates:

```markdown
## Constitution Check

- [ ] Follows coding standards
- [ ] Includes security review
- [ ] Has test coverage
- [ ] Documentation complete
```

Reference `.specify/memory/constitution.md` for project principles.

### Multi-Phase Workflows

Break complex workflows into phases:

```markdown
## Execution Flow
1. Phase 0: Research
2. Gate: Validate research
3. Phase 1: Design
4. Gate: Architecture review
5. Phase 2: Implementation plan
6. STOP - Ready for /tasks
```

### Workflow Composition

Chain workflows together:

```markdown
**Upstream**: This workflow requires /specify to complete first
**Downstream**: After this workflow, run /tasks
```

### Dynamic Artifact Generation

Use templates to generate multiple artifacts:

```markdown
## Phase 1: Generate Contracts
- For each API endpoint → create contract file
- For each entity → create data model
- For each service → create interface
```

## Troubleshooting

### Common Issues

**Issue**: Workflow not found
- **Cause**: Command file not created or not in `.claude/commands/`
- **Fix**: Check file exists and has `.md` extension

**Issue**: Template execution fails
- **Cause**: Missing required input files
- **Fix**: Verify prerequisites in Execution Flow step 1

**Issue**: Gates not working
- **Cause**: Conditions not properly defined
- **Fix**: Review ERROR/WARN conditions in template

**Issue**: Artifacts not generated
- **Cause**: Incorrect paths or missing directories
- **Fix**: Use absolute paths from repo root

### Debugging

1. **Enable verbose output**: Add `set -x` to bash scripts
2. **Check JSON output**: Use `--json` flag to see structured data
3. **Validate paths**: Ensure all paths are absolute
4. **Review logs**: Check workflow execution output for errors

## Examples

### Example 1: Code Review Workflow

```bash
/create-workflow Create a code review workflow that analyzes code quality, checks for security issues, validates tests, and generates a review report
```

**Generated workflow**:
- Phase 0: Static analysis
- Phase 1: Security scan
- Phase 2: Test validation
- Phase 3: Generate report

### Example 2: Deployment Checklist

```bash
/create-workflow Create a deployment checklist that validates configuration, runs smoke tests, checks dependencies, and creates deployment plan
```

**Generated workflow**:
- Phase 0: Environment validation
- Phase 1: Configuration check
- Phase 2: Pre-deployment tests
- Phase 3: Deployment plan

### Example 3: Documentation Generation

```bash
/create-workflow Create a documentation workflow that extracts code comments, generates API docs, creates user guides, and builds static site
```

**Generated workflow**:
- Phase 0: Extract documentation
- Phase 1: Generate API reference
- Phase 2: Create user guides
- Phase 3: Build and publish

## Contributing

### Adding New Templates

1. Follow `workflow-generator-template.md` structure
2. Include all mandatory sections
3. Test thoroughly before committing
4. Document in this README

### Improving Existing Workflows

1. Update template file
2. Update command file if needed
3. Test with existing projects
4. Document breaking changes

### Best Practices for Contributors

1. **Keep it simple** - Don't over-engineer
2. **Document thoroughly** - Future you will thank you
3. **Test edge cases** - What happens when inputs are invalid?
4. **Follow conventions** - Use kebab-case, match existing patterns
5. **Update docs** - Keep this README current

## Resources

- **Template Reference**: See `.specify/templates/` for examples
- **Command Reference**: See `.claude/commands/` for patterns
- **Script Reference**: See `.specify/scripts/bash/` for helpers
- **Project Constitution**: See `.specify/memory/constitution.md`

## Support

For questions or issues:
1. Check this README
2. Review existing workflow templates
3. Examine similar workflows for patterns
4. Test with `/create-workflow` examples

---

**Version**: 1.0
**Last Updated**: 2025-11-13
**Maintained by**: Ambient Code Platform Team
