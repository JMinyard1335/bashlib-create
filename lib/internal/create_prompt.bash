#!/usr/bin/env bash
# Used to take in user input and echo it back to be captured.
#
# Each of these looks for input and validates it.

## SOURCE GUARD installer_prompt.bash --------------------------------------------------
if [[ -v installer_prompt_sourced ]]; then
    return 0
fi
installer_prompt_sourced=1

installer_prompt_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$HOME"/.local/lib/style/bashlib_style.bash
## --------------------------------------------------------------------------------------

_prompt_validate_name() {
    local value="${1:-}"
    local label="${2:-value}"

    if [[ -z "$value" ]]; then
	print_error "$label cannot be empty"
	return 1
    fi

    if [[ ! "$value" =~ ^[A-Za-z0-9._-]+$ ]]; then
	print_error "$label may only contain letters, numbers, dots, underscores, and dashes"
	return 1
    fi

    return 0
}

_prompt_validate_author() {
    local value="${1:-}"

    if [[ -z "$value" ]]; then
	print_error "Author cannot be empty"
	return 1
    fi

    return 0
}

_prompt_validate_repo() {
    local value="${1:-}"

    # Repo can be blank, but when provided should resemble a common git URL.
    if [[ -z "$value" ]]; then
	return 0
    fi

    if [[ "$value" =~ ^https?://.+$ || "$value" =~ ^git@[^:]+:.+$ ]]; then
	return 0
    fi

    print_error "Repo must be empty or a valid URL (https://... or git@...:...)"
    return 1
}

_prompt_validate_file() {
    local value="${1:-}"
    local label="${2:-File name}"

    if [[ -z "$value" ]]; then
	print_error "$label cannot be empty"
	return 1
    fi

    if [[ "$value" == "." || "$value" == ".." ]]; then
	print_error "$label cannot be '.' or '..'"
	return 1
    fi

    if [[ "$value" == */* ]]; then
	print_error "$label must be a file name only, not a path"
	return 1
    fi

    if [[ ! "$value" =~ ^[A-Za-z0-9._-]+$ ]]; then
	print_error "$label may only contain letters, numbers, dots, underscores, and dashes"
	return 1
    fi

    return 0
}

_prompt_validate_dir() {
    local value="${1:-}"

    if [[ -z "$value" ]]; then
	print_error "Directory cannot be empty"
	return 1
    fi

    if [[ ! -d "$value" ]]; then
	print_error "Directory does not exist: $value"
	return 1
    fi

    return 0
}

_prompt_validate_path() {
    local value="${1:-}"

    if [[ -z "$value" ]]; then
	print_error "Path cannot be empty"
	return 1
    fi

    return 0
}

_prompt_validate_null() {
    return 0
}

_prompt_loop() {
    local label="$1"
    local default_value="${2:-}"
    local validator_name="$3"
    local response=""
    local value=""

    while true; do
	if [[ -n "$default_value" ]]; then
	    read -r -p "$label [$default_value]: " response
	    value="${response:-$default_value}"
	else
	    read -r -p "$label: " response
	    value="$response"
	fi

	if "$validator_name" "$value" "$label"; then
	    printf '%s\n' "$value"
	    return 0
	fi
    done
}

# Ask the user for the projects name,
# this is different than the tool name.
prompt_project() {
    local default_value="${1:-new-project}"
    _prompt_loop "Project name" "$default_value" _prompt_validate_name
}

# Ask the user for the Author of the project
# Used in the tool.toml
prompt_author() {
    local default_value="${1:-unknown}"
    _prompt_loop "Author" "$default_value" _prompt_validate_author
}

# Ask the user for the tools name,
# this is different than the project name.
# This is the name of the script entry point.
prompt_tool() {
    local default_value="${1:-tool}"
    _prompt_loop "Tool name" "$default_value" _prompt_validate_name
}

# Ask the user for the git repo of the project,
# this is used in the tool.toml and can be left blank.
prompt_repo() {
    local default_value="${1:-}"
    _prompt_loop "Repo" "$default_value" _prompt_validate_repo
}

# Prompt the user for just a file name, not the full path.
prompt_file() {
    local default_value="${1:-}"
    _prompt_loop "File name" "$default_value" _prompt_validate_file
}

# Prompt the user for a directory, this is used for the install and remove commands.
prompt_dir() {
    local default_value="${1:-$PWD}"
    _prompt_loop "Directory" "$default_value" _prompt_validate_dir
}

prompt_path() {
    local default_value="${1:-$PWD/file.txt}"
    _prompt_loop "Path" "$default_value" _prompt_validate_path
}

prompt_description() {
    local default_value="${1:-A brief description of the project.}"
    _prompt_loop "Project description" "$default_value" _prompt_validate_null
}
