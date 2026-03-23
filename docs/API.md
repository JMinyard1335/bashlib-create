# bashlib-create API

This document describes the public API surface of `bashlib-create`:

- CLI commands (`create`, `create project`, `create script`, `create file`)
- Sourceable Bash functions in `lib/` and `lib/internal/`

Version referenced here: `0.1.0`.

## CLI API

### `create`

Top-level command dispatcher.

```bash
create [global-option] <command> [command-options]
```

Global options:

- `-h`, `--help`: Print help.
- `-v`, `--version`: Print version.

Commands:

- `project`: Project scaffolding.
- `script`: Script template generation.
- `file`: Common file template generation.

Examples:

```bash
create --help
create --version
create project --create
create script --tool
create file --readme
```

Exit behavior:

- Returns non-zero for unknown flags/options.
- Returns non-zero when called without arguments.

### `create project`

Creates a full Bash project scaffold.

```bash
create project [options]
```

Options:

- `-h`, `--help`: Print help.
- `-v`, `--version`: Print version.
- `-c`, `--create`: Interactive project creation.
- `-n`, `--name <project>`: Project name (required for non-interactive mode).
- `-t`, `--tool <tool>`: Main executable/tool name (required for non-interactive mode).
- `-a`, `--author <author>`: Author name.
- `-r`, `--repo <url>`: Repository URL.
- `-d`, `-desc <text>`: Project description.

Notes:

- In flag-driven mode, both `--name` and `--tool` are required.
- In current implementation, the long form for description is `-desc` (single dash), not `--desc`.

Examples:

```bash
create project --create
create project --name my-project --tool mytool
create project -n my-project -t mytool -a "Jane Dev" -r "https://github.com/me/repo" -d "My tool"
```

Generated structure (minimum):

- `<project>/lib/internal/`
- `<project>/libexec/`
- `<project>/man/`
- `<project>/tool.toml`
- `<project>/README.md`
- `<project>/.gitignore`
- `<project>/<tool>` (chmod +x)
- `<project>/lib/<tool>.bash`

### `create script`

Creates a single script template interactively.

```bash
create script [options]
```

Options:

- `-h`, `--help`: Print help.
- `-v`, `--version`: Print version.
- `-t`, `--tool`: Create a top-level tool script template.
- `-l`, `--lib`: Create a sourceable library script template (`*.bash`).
- `-e`, `--exec`: Create a `libexec`-style executable script template.

Examples:

```bash
create script --tool
create script --lib
create script --exec
```

Behavior:

- Prompts for a path.
- Writes the selected template.
- Sets executable bit for `--tool` and `--exec` templates.

### `create file`

Creates common project file templates interactively.

```bash
create file [options]
```

Options:

- `-h`, `--help`: Print help.
- `-v`, `--version`: Print version.
- `-r`, `--readme`: Create `README.md`.
- `-t`, `--toml`: Create `tool.toml`.
- `-i`, `--ignore`: Create `.gitignore`.
- `-c`, `--contrib`: Create `CONTRIBUTING.md`.

Examples:

```bash
create file --readme
create file --toml
create file --ignore
create file --contrib
```

Behavior:

- Uses interactive prompts to gather path and (for contributing file) repo/tool/project metadata.

## Sourceable API

Primary source entry:

- `lib/bashlib-create.bash`

This file sources internal implementation from:

- `lib/internal/bashlib_create.bash`

### High-level creation functions

Defined in `lib/internal/bashlib_create.bash`.

- `create_project`
	- Interactive project creation.
	- Prompts for project/tool/author/repo/description.
	- Calls `create_mkdirs` and `create_touch_files`.

- `create_tool_script`
	- Interactive creation of a top-level tool script.
	- Prompts for output path; calls `write_tool_file`.

- `create_lib_script`
	- Interactive creation of a `lib/*.bash` template.
	- Prompts for output path; calls `write_lib_file`.

- `create_exec_script`
	- Interactive creation of a `libexec/*` template.
	- Prompts for output path; calls `write_exec_file`.

- `create_readme`
	- Interactive creation of `README.md`; calls `write_readme`.

- `create_tool_toml`
	- Interactive creation of `tool.toml`; calls `write_tool_toml`.

- `create_gitignore`
	- Interactive creation of `.gitignore`; calls `write_gitignore`.

- `create_contributing`
	- Interactive creation of `CONTRIBUTING.md`; calls `write_contributing_md`.

### Project scaffolding helpers

- `create_mkdirs <project_dir>`
	- Creates scaffold directories.
	- Returns non-zero when path is empty, already exists, or argument count is invalid.

- `create_touch_files <project_dir> <tool_name> <author> <repo> [description]`
	- Writes project files into an existing project directory.
	- Returns non-zero on validation failure or write error.

### Prompt functions

Defined in `lib/internal/create_prompt.bash`.

- `prompt_project [default]`
- `prompt_author [default]`
- `prompt_tool [default]`
- `prompt_repo [default]`
- `prompt_file [default]`
- `prompt_dir [default]`
- `prompt_path [default]`
- `prompt_description [default]`

Validation behavior:

- Name/file prompts accept `[A-Za-z0-9._-]+`.
- Repo may be empty; if provided, it must match `https://...` or `git@...:...`.
- `prompt_dir` requires an existing directory.

### Template writers

Defined in `lib/internal/create_templates.bash`.

- `write_tool_file <path> <tool_name>`
- `write_exec_file <path> <file_name>`
- `write_lib_file <path> <file_name>`
- `write_readme <path> <tool_name> <repo>`
- `write_gitignore <path>`
- `write_tool_toml <path> <project_name> <tool_name> <author> <repo> <description>`
- `write_contributing_md <path> <repo> <project_name> <tool_name>`

Helper:

- `_create_tool_identifier <tool_name>`
	- Converts arbitrary tool names into valid Bash identifier fragments.
	- Replaces non `[A-Za-z0-9_]` chars with `_`.
	- Prefixes leading digits with `_`.

## Exit Codes and Error Handling

General behavior:

- Most CLI parsers return exit code `1` for unknown options or invalid usage.
- Template and scaffolding functions return non-zero on validation failures or I/O errors.

Common failure cases:

- Missing required positional flag values.
- Missing required flags (`project`: `--name`, `--tool` in non-interactive mode).
- Target directories/files not writable.

## Stability Notes

- Public CLI options listed above should be treated as the user-facing API.
- Internal helper functions prefixed with `_` are implementation details and may change.
