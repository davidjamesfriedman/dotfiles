#!/usr/bin/env zsh
# Network and API Functions
# Functions for working with APIs and network requests

# Lazy load guard
[[ -n "${_NETWORK_API_LOADED}" ]] && return
_NETWORK_API_LOADED=1

# Add request to ATAC collection
add_req() {
    if [[ $# -lt 3 ]]; then
        echo "Usage: add_req <collection_name> <request_name> \"<curl_command>\""
        echo "Example: add_req my_api \"get_users\" \"curl -X GET https://api.example.com/users -H 'Authorization: Bearer token'\""
        return 1
    fi

    local collection_name="$1"
    local request_name="$2"
    local curl_command="$3"

    # Check if collection exists
    local collections=$(atac collection list 2>/dev/null)
    if ! echo "$collections" | grep -q "^$collection_name$"; then
        echo "Error: Collection '$collection_name' does not exist."
        echo "Available collections:"
        atac collection list 2>/dev/null || echo "  (no collections found)"
        echo "Create a collection first with: atac collection new <collection_name>"
        return 1
    fi

    # Create a temporary file for the curl command
    local temp_file=$(mktemp /tmp/curl_cmd.XXXXXX)
    echo "$curl_command" > "$temp_file"

    # Import the curl command using atac's built-in import functionality
    if atac import curl "$temp_file" "$collection_name" "$request_name"; then
        echo "✅ Successfully added request '$request_name' to collection '$collection_name'"
    else
        echo "❌ Failed to add request '$request_name' to collection '$collection_name'"
        rm -f "$temp_file"
        return 1
    fi

    # Clean up temporary file
    rm -f "$temp_file"
}

# Curl wrapper that automatically pipes JSON/NDJSON output to jqp
# Note: This overrides the default curl command - consider if you want this behavior
curl_with_jqp() {
    # Check if jqp is available
    if ! command -v jqp >/dev/null 2>&1; then
        # If jqp is not available, just run regular curl
        command curl "$@"
        return $?
    fi

    # Create temporary files for output and headers
    local temp_output=$(mktemp /tmp/curl_output.XXXXXX)
    local temp_headers=$(mktemp /tmp/curl_headers.XXXXXX)
    
    # Run curl and capture output and headers
    local curl_exit_code
    command curl -D "$temp_headers" -o "$temp_output" "$@"
    curl_exit_code=$?
    
    # If curl failed, show the output and return
    if [[ $curl_exit_code -ne 0 ]]; then
        cat "$temp_output"
        rm -f "$temp_output" "$temp_headers"
        return $curl_exit_code
    fi
    
    # If output is empty, just show headers if any
    if [[ ! -s "$temp_output" ]]; then
        cat "$temp_headers"
        rm -f "$temp_output" "$temp_headers"
        return $curl_exit_code
    fi
    
    # Check Content-Type header for JSON
    local content_type=$(grep -i "^content-type:" "$temp_headers" | tail -1 | cut -d: -f2- | tr -d ' \r\n' | tr '[:upper:]' '[:lower:]')
    local is_json_content_type=false
    
    if [[ "$content_type" == *"application/json"* ]] || [[ "$content_type" == *"application/ndjson"* ]] || [[ "$content_type" == *"text/json"* ]]; then
        is_json_content_type=true
    fi
    
    # Try to detect JSON by content (check first few characters)
    local first_chars=$(head -c 10 "$temp_output" | tr -d '[:space:]')
    local looks_like_json=false
    
    # Check if it starts with JSON-like characters or is NDJSON
    if [[ "$first_chars" =~ ^[\{\[] ]] || [[ -n "$(head -1 "$temp_output" | jq . 2>/dev/null)" ]]; then
        looks_like_json=true
    fi
    
    # Check if the entire content is valid JSON
    local is_valid_json=false
    if jq . "$temp_output" >/dev/null 2>&1; then
        is_valid_json=true
    fi
    
    # Check if it's NDJSON (newline-delimited JSON)
    local is_ndjson=false
    if [[ "$is_valid_json" == false ]] && [[ "$looks_like_json" == true ]]; then
        # Try to validate as NDJSON (each line should be valid JSON)
        local ndjson_valid=true
        while IFS= read -r line; do
            if [[ -n "$line" ]] && ! echo "$line" | jq . >/dev/null 2>&1; then
                ndjson_valid=false
                break
            fi
        done < "$temp_output"
        if [[ "$ndjson_valid" == true ]]; then
            is_ndjson=true
        fi
    fi
    
    # Show headers if requested (when -I, -head, or -D options are used)
    local show_headers=false
    for arg in "$@"; do
        if [[ "$arg" == "-I" ]] || [[ "$arg" == "--head" ]] || [[ "$arg" == "-D" ]] || [[ "$arg" == "--dump-header" ]]; then
            show_headers=true
            break
        fi
    done
    
    if [[ "$show_headers" == true ]]; then
        cat "$temp_headers"
    fi
    
    # If it's JSON or NDJSON, pipe to jqp; otherwise show normally
    if [[ "$is_valid_json" == true ]] || [[ "$is_ndjson" == true ]] || [[ "$is_json_content_type" == true && "$looks_like_json" == true ]]; then
        echo "🔍 JSON detected - opening in jqp (press 'q' to quit)"
        sleep 1
        cat "$temp_output" | jqp
    else
        cat "$temp_output"
    fi
    
    # Clean up temporary files
    rm -f "$temp_output" "$temp_headers"
    return $curl_exit_code
}

# Optional: Create an alias instead of overriding curl
alias curlj='curl_with_jqp'