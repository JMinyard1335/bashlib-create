#!/usr/bin/env bash

## SOURCE GUARD bashlib_create.bash -----------------------------------------------------
if [[ -v installer_lib_create_sourced ]]; then
    return 0
fi
installer_lib_create_sourced=1

bashlib_create_lib_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${bashlib_create_lib_dir}/create_prompt.bash"
source "${bashlib_create_lib_dir}/create_templates.bash"
## ---------------------------------------------------------------------------------------

create_lib_script() {
    local full_path="" file="" dir="" rc=""
    
    full_path="$(prompt_path)"
    file="$(basename "${full_path%.*}")"
    dir="$(dirname "${full_path}")"

    echo -e "Creating tool script at \e[36m$full_path\e[0m..."
    write_lib_file "$dir" "$file"
    rc="$?"
    
    return "$rc"
}

create_tool_script() {
    local full_path="" file="" dir="" rc=""
    
    full_path="$(prompt_path)"
    file="$(basename "${full_path%.*}")"
    dir="$(dirname "${full_path}")"

    echo -e "Creating tool script at \e[36m$full_path\e[0m..."
    write_tool_file "$dir" "$file"
    rc="$?"
    
    return "$rc"

}

create_readme() {
    local full_path="" file="" dir="" rc=""
    
    full_path="$(prompt_path)"
    file="$(basename "${full_path%.*}")"
    dir="$(dirname "${full_path}")"

    echo -e "Creating README file at \e[36m$full_path\e[0m..."
    write_readme "$dir" "$file" "path to your repo"
    rc="$?"
    
    return "$rc"
}

create_tool_toml() {
    local full_path="" file="" dir="" rc=""
    
    full_path="$(prompt_path)"
    file="$(basename "${full_path%.*}")"
    dir="$(dirname "${full_path}")"

    echo -e "Creating tool.toml file at \e[36m$full_path\e[0m..."
    write_tool_toml "$dir" "$file" "$file" "Author Name" "path to your repo" "A brief description of the project."
    rc="$?"
    
    return "$rc"
}

create_gitignore() {
    local full_path="" file="" dir="" rc=""
    
    full_path="$(prompt_path)"
    file="$(basename "${full_path%.*}")"
    dir="$(dirname "${full_path}")"

    echo -e "Creating .gitignore file at \e[36m$full_path\e[0m..."
    write_gitignore "$dir"
    rc="$?"
    
    return "$rc"
}


# create_mkdirs <project_dir>
# Creates a new project root and scaffold directories.
create_mkdirs() {
    if [[ "$#" -ne 1 ]]; then
        print_error "create_mkdirs: invalid argument count"
        return 1
    fi

    local project_dir="${1:-}"

    if [[ -z "$project_dir" ]]; then
        print_error "create_mkdirs: project directory cannot be empty"
        return 1
    fi

    if [[ -e "$project_dir" ]]; then
        print_error "create_mkdirs: project path already exists: $project_dir"
        return 1
    fi

    mkdir -p "$project_dir/lib/internal" "$project_dir/libexec" "$project_dir/man"
}

# create_touch_files <project_dir> <tool_name> <author> <repo> [description]
# Writes all scaffold files into an existing project directory.
create_touch_files() {
    if [[ "$#" -lt 4 || "$#" -gt 5 ]]; then
        print_error "create_touch_files: invalid argument count"
        return 1
    fi

    local project_dir="${1:-}"
    local tool_name="${2:-tool}"
    local author="${3:-unknown}"
    local repo="${4:-}"
    local description="${5:-A brief description of the project.}"
    local project_name=""

    if [[ ! -d "$project_dir" ]]; then
        print_error "create_touch_files: project directory does not exist: $project_dir"
        return 1
    fi

    project_name="$(basename -- "$project_dir")"

    write_tool_toml "$project_dir" "$project_name" "$tool_name" "$author" "$repo" "$description" || return 1
    write_lib_file "$project_dir/lib" "$tool_name" || return 1
    write_tool_file "$project_dir" "$tool_name" || return 1
    chmod +x "$project_dir/$tool_name" || return 1
    write_readme "$project_dir" "$project_name" "$repo" || return 1
    write_gitignore "$project_dir" || return 1

    return 0
}


# From the current directory create a new project
create_project() {
    local project_name="" tool_name="" author="" repo="" description="" project_dir=""

    project_name="$(prompt_project)"
    tool_name="$(prompt_tool)"
    author="$(prompt_author)"
    repo="$(prompt_repo)"
    description="$(prompt_description)"

    project_dir="$(pwd)/$project_name"
    echo -e "Creating project in \e[36m$project_dir\e[0m..."

    create_mkdirs "$project_dir" || return 1
    create_touch_files "$project_dir" "$tool_name" "$author" "$repo" "$description" || return 1

    return 0
}
