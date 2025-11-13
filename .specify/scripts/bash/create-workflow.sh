#!/usr/bin/env bash
# Create a new workflow template and slash command

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

REPO_ROOT=$(get_repo_root)
WORKFLOW_NAME=""
OUTPUT_JSON=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        *)
            if [[ -z "$WORKFLOW_NAME" ]]; then
                WORKFLOW_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Validate workflow name
if [[ -z "$WORKFLOW_NAME" ]]; then
    echo "ERROR: Workflow name required" >&2
    echo "Usage: $0 [--json] <workflow-name>" >&2
    exit 1
fi

# Convert to kebab-case if needed
WORKFLOW_NAME=$(echo "$WORKFLOW_NAME" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')

# Validate workflow name format
if [[ ! "$WORKFLOW_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "ERROR: Invalid workflow name: $WORKFLOW_NAME" >&2
    echo "Name must be lowercase, start with a letter, and contain only letters, numbers, and hyphens" >&2
    exit 1
fi

# Define paths
TEMPLATES_DIR="$REPO_ROOT/.specify/templates"
COMMANDS_DIR="$REPO_ROOT/.claude/commands"
SCRIPTS_DIR="$REPO_ROOT/.specify/scripts/bash"

TEMPLATE_FILE="$TEMPLATES_DIR/${WORKFLOW_NAME}-template.md"
COMMAND_FILE="$COMMANDS_DIR/${WORKFLOW_NAME}.md"
SCRIPT_FILE="$SCRIPTS_DIR/${WORKFLOW_NAME}-setup.sh"

# Check if workflow already exists
if [[ -f "$TEMPLATE_FILE" ]]; then
    echo "ERROR: Workflow template already exists: $TEMPLATE_FILE" >&2
    exit 1
fi

if [[ -f "$COMMAND_FILE" ]]; then
    echo "ERROR: Workflow command already exists: $COMMAND_FILE" >&2
    exit 1
fi

# Create directories if needed
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$SCRIPTS_DIR"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Output results
if [[ "$OUTPUT_JSON" == "true" ]]; then
    cat <<EOF
{
  "workflow_name": "$WORKFLOW_NAME",
  "template_file": "$TEMPLATE_FILE",
  "command_file": "$COMMAND_FILE",
  "script_file": "$SCRIPT_FILE",
  "templates_dir": "$TEMPLATES_DIR",
  "commands_dir": "$COMMANDS_DIR",
  "scripts_dir": "$SCRIPTS_DIR",
  "date": "$CURRENT_DATE",
  "repo_root": "$REPO_ROOT"
}
EOF
else
    echo "Workflow setup complete:"
    echo "  Workflow name: $WORKFLOW_NAME"
    echo "  Template file: $TEMPLATE_FILE"
    echo "  Command file: $COMMAND_FILE"
    echo "  Script file: $SCRIPT_FILE (optional)"
    echo ""
    echo "Next steps:"
    echo "  1. Create template at: $TEMPLATE_FILE"
    echo "  2. Create command at: $COMMAND_FILE"
    echo "  3. (Optional) Create script at: $SCRIPT_FILE"
fi
