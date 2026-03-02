#!/bin/sh

load_env_file() {
  env_file="$1"
  [ -f "$env_file" ] || return 0

  while IFS= read -r line || [ -n "$line" ]; do
    trimmed=$(printf '%s' "$line" | sed 's/^[[:space:]]*//')

    case "$trimmed" in
      ''|'#'*) continue ;;
    esac

    case "$line" in
      *=*) ;;
      *)
        echo "Invalid .env line (missing '='): $line" >&2
        return 1
        ;;
    esac

    key=${line%%=*}
    value=${line#*=}

    key=$(printf '%s' "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    value=$(printf '%s' "$value" | sed 's/^[[:space:]]*//')

    case "$key" in
      ''|*[!A-Za-z0-9_]*)
        echo "Invalid .env key: $key" >&2
        return 1
        ;;
    esac

    case "$value" in
      \"*\") value=${value#\"}; value=${value%\"} ;;
      \'*\') value=${value#\'}; value=${value%\'} ;;
    esac

    export "$key=$value"
  done < "$env_file"
}
