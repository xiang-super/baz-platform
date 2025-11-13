---
description: Generate reusable workflow templates with phases, gates, and artifacts from natural language descriptions
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Given the workflow description provided, execute the workflow generation template:

1. Run `.specify/scripts/bash/create-workflow.sh --json` to extract workflow name from description and get file paths
   - Parse JSON output for: workflow_name, template_file, command_file, script_file, date
   - All file paths must be absolute

2. Load and execute the workflow template:
   - Read `.specify/templates/workflow-generator-v2-template.md`
   - Follow the Execution Flow (main) steps 1-10
   - The template is self-contained and executable

3. Parse workflow description ($ARGUMENTS) to extract:
   - Workflow name (kebab-case derived from purpose)
   - Workflow purpose statement
   - Input requirements
   - Expected output artifacts
   - Sequential phases/stages
   - Decision gates and quality checks
   - Error conditions

4. Execute template phases:
   - Phase 0: Generate workflow template file
     * Load workflow-generator-template.md
     * Replace placeholders with extracted components
     * Write to template_file path
   - Phase 1: Generate slash command file
     * Create command wrapper with description
     * Add $ARGUMENTS handling
     * Include template execution logic
     * Write to command_file path
   - Phase 2: Generate supporting bash script (if needed)
     * Create setup/validation script
     * Source common.sh
     * Add JSON output support
     * Make executable
     * Write to script_file path (optional)

5. Validate generated artifacts:
   - Check all required files created
   - Verify markdown syntax validity
   - Confirm execution flow is complete
   - Ensure no placeholders remain

6. Report completion:
   - List created file paths (template, command, script)
   - Provide example usage: `/[workflow-name] [example args]`
   - Describe artifacts the workflow will generate
   - Suggest next steps for testing

**Important**: The generated workflow should integrate seamlessly with existing workflows (/specify, /plan, /tasks) and follow established patterns.

Use absolute paths with the repository root for all file operations.
