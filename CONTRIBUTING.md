# Contributing to bashlib-installer

Thanks for your interest in improving `bashlib-create`.

## Ways To Contribute

- Report bugs and unexpected behavior.
- Suggest or implement install/remove/update/create workflow improvements.
- Improve docs and usage examples.
- Add tests and edge-case coverage.

## Development Setup

```bash
git clone "https://github.com/JMinyard1335/bashlib-create.git"
cd bashlib-create
chmod +x ./create
./create help
./test/test_all.bash
```

## Project Layout

- `create`: top-level command dispatcher.
- `lib/`: sourceable library files.
- `lib/internal/`: install/remove/update/create internals and shared helpers.
- `libexec/`: subcommand executables (`# list of sub commands here`).
- `test/`: fail-first test suite and test helpers.

## Coding Guidelines

- Keep scripts Bash-focused and portable.
- Preserve existing naming patterns ( `# list of naming patterns here`).
- Keep scripts you execute extensionless; scripts you source should be `*.bash`.
- Prefer small, clear functions.
- Quote variables unless word splitting is explicitly needed.
- Keep CLI help text and docs in sync with behavior.

## Testing Checklist

Before opening a pull request, run:

```bash
./create help
./test/test_all.bash
```

If your change affects parsing or error handling, test at least one invalid input path.

## Pull Request Notes

- Keep PRs focused (one feature/fix per PR when possible).
- Explain why the change is needed.
- List behavior changes and any CLI output changes.
- Update `README.md`, `INSTALL.md`, and command help text when behavior or setup changes.
- For Major Changes and New Features add a Section to the [change log](docs/CHANGELOG.md).

## Commit Message Suggestions

Use short, imperative commit messages, for example:

- `fix install arg parsing`
- `add install guide`
- `improve update error output`

## AI-Assisted Contributions

AI tools are welcome for drafting code, docs, tests, and refactors.
Contributors remain fully responsible for all submitted changes.

### Requirements

- Verify behavior manually before opening a PR.
- Run the project checklist:
	- `./create help`
	- `./test/test_all.bash`
- Ensure generated code matches project conventions (`bashlib_*`, `create_*`, extensionless executables, `*.bash` source files).
- Do not include secrets, tokens, private keys, or private/internal code in prompts.
- Do not copy copyrighted or proprietary code verbatim from external sources.
- Keep PRs understandable: explain what changed and why, not just "AI generated this."
- Update `README.md` and `INSTALL.md` when behavior or setup changes.
- If AI was used significantly, briefly disclose it in the PR description (for example: "AI-assisted drafting, manually reviewed and tested").

### Not Acceptable

- Submitting unreviewed AI output.
- Large AI-generated changes without tests or explanation.
- Output that adds unnecessary complexity or breaks existing UX/help text.
