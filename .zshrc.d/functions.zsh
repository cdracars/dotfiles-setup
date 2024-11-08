# findread function for searching and displaying files with exclusions
findread() {
    # Load default exclusions from the .findreadconfig file, if it exists
    if [[ -f "$HOME/.findreadconfig" ]]; then
        source "$HOME/.findreadconfig"
    fi

    # Detect the shell to use the appropriate array-splitting method
    local shell_is_zsh=false
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_is_zsh=true
    fi

    # Split the space-separated strings into arrays for directories and files
    local exclude_dirs=()
    local exclude_files=()

    if $shell_is_zsh; then
        # In zsh, use ${=VAR} to split by whitespace
        exclude_dirs=(${=FINDREAD_EXCLUDE_DIRS})
        exclude_files=(${=FINDREAD_EXCLUDE_FILES})
    else
        # In bash, use IFS and read to split by whitespace
        IFS=' ' read -r -a exclude_dirs <<< "$FINDREAD_EXCLUDE_DIRS"
        IFS=' ' read -r -a exclude_files <<< "$FINDREAD_EXCLUDE_FILES"
    fi

    local debug=false  # Debug mode flag

    # Display help information
    if [[ "$1" == "--help" ]]; then
        echo "findread - A function to search and display file contents with exclusion options"
        echo
        echo "This function uses a configuration file (.findreadconfig) to manage default"
        echo "exclusions for directories and file patterns. You can create a .findreadconfig"
        echo "file in the project root directory with the following format:"
        echo
        echo "  FINDREAD_EXCLUDE_DIRS=\"./files ./node_modules ./.next ./.git ./dist ./.yarn\""
        echo "  FINDREAD_EXCLUDE_FILES=\"*.lock *.json *.md *.log *.svg *.ico\""
        echo
        echo "If the .findreadconfig file is not present, the function will use internal defaults."
        echo
        echo "Options:"
        echo "  --exclude-dir <directory>   Exclude additional directories from the search."
        echo "  --exclude-file <pattern>    Exclude additional file types from the search."
        echo "  --debug                     Show the built command without executing it."
        echo "  --help                      Show this help message and exit."
        echo
        echo "Examples:"
        echo "  findread                    Run with default exclusions from config file or internal defaults."
        echo "  findread --exclude-dir './public'   Exclude './public' directory in addition to defaults."
        echo "  findread --exclude-file '*.txt'     Exclude '.txt' files in addition to defaults."
        echo "  findread --debug             Show the command without executing it."
        return 0
    fi

    # Parse command line arguments for additional exclusions and debug mode
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --exclude-dir)
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    exclude_dirs+=("$2")
                    shift 2
                else
                    echo "Error: --exclude-dir requires a directory argument."
                    return 1
                fi
                ;;
            --exclude-file)
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    exclude_files+=("$2")
                    shift 2
                else
                    echo "Error: --exclude-file requires a pattern argument."
                    return 1
                fi
                ;;
            --debug)
                debug=true
                shift
                ;;
            *)
                echo "Unknown option: $1. Use --help for usage information."
                return 1
                ;;
        esac
    done

    # Build the find command dynamically
    local find_command="find ."

    # Add directory exclusions with -prune
    for dir in "${exclude_dirs[@]}"; do
        find_command+=" -path '$dir' -prune -o"
    done

    # Continue file search after pruning directories
    find_command+=" -type f"

    # Add file exclusions using ! -name for each pattern
    for file in "${exclude_files[@]}"; do
        find_command+=" ! -name '$file'"
    done

    find_command+=" -exec sh -c 'echo \"{}\"; cat \"{}\"; echo' \\;"

    # Output the command if debug mode is enabled
    if [[ "$debug" == true ]]; then
        echo "Built find command:"
        echo "$find_command"
        return 0
    fi

    # Execute the built find command
    eval "$find_command"
}
