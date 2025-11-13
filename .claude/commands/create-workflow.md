---
description: Create a new workflow template with phases, gates, and artifact generation.
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Given the workflow description provided, do this:

1. Parse the workflow description from $ARGUMENTS to extract:
   - Workflow name (kebab-case, e.g., "security-review")
   - Workflow purpose (what problem does this solve?)
   - Input requirements (what does the workflow need to start?)
   - Expected outputs/artifacts (what files/results does it produce?)
   - Workflow phases (sequential steps/stages)
   - Decision gates (quality checks, approval points)
   - Error conditions (when should workflow stop/warn?)

2. If workflow name is not clear from description, derive it from the purpose:
   - Example: "Review security compliance" → "security-review"
   - Example: "Deploy to production" → "production-deploy"

3. Generate the workflow template file at `.specify/templates/[workflow-name]-template.md`:
   - Load `.specify/templates/workflow-generator-template.md` as the structure
   - Fill in the Execution Flow with numbered steps based on phases
   - Add decision gates with ERROR/WARN conditions
   - Define input paths and output artifacts
   - Include constitution/compliance checks if relevant
   - Add Progress Tracking section
   - Specify clear STOP point or handoff to next command

4. Generate the corresponding slash command at `.claude/commands/[workflow-name].md`:
   - Set description to workflow purpose
   - Command should load and execute the template
   - Pass $ARGUMENTS as context to the template
   - Handle any required bash script integration
   - Report completion with generated artifacts

5. If the workflow needs supporting bash scripts:
   - Create script at `.specify/scripts/bash/[workflow-name]-setup.sh`
   - Include common.sh sourcing
   - Provide JSON output for paths/config
   - Follow existing script patterns

6. Report completion with:
   - Created file paths (template, command, scripts)
   - Example usage: `/[workflow-name] [example args]`
   - What artifacts the workflow will generate
   - Next steps for testing the workflow

**Important**: Follow established patterns from existing workflows:
- `/specify` creates specs from descriptions
- `/plan` generates implementation plans from specs
- `/tasks` creates task lists from plans
- Your new workflow should integrate seamlessly with this chain

**Workflow naming conventions**:
- Use kebab-case (lowercase with hyphens)
- Be specific and action-oriented
- Examples: `code-review`, `deployment-checklist`, `security-scan`

If the description is unclear or missing key information, ask clarifying questions before generating files.
