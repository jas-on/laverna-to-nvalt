#!/usr/bin/env bash

command_exists () {
    type "$1" &> /dev/null ;
}

display_help() {
    echo "Usage: $0 -i $1 -o $2" >&2
    echo
    echo "   -i, --input-directory      Where to find the laverna-formatted notes"
    echo "   -o, --output-directory     Where to output the nvALT-formatted notes"
    echo
    exit 1
}

if ! command_exists jq; then
    echo "Please ensure that these dependencies are installed:"
    echo
    echo "   - jq"
    echo
    exit 1
fi


while :
do
  case "$1" in
    -i | --input-directory)
      if [[ -z "$2" ]]; then
        shift 1
      fi

      input_dir="$2"
      shift 2
      ;;

    -o | --output-directory)
      if [[ -z "$2" ]]; then
        shift 1
      fi

      output_dir="$2"
      shift 2
      ;;

    -h | --help)
      display_help
      exit 0
      ;;

    -*)
      echo "Error: Unknown option: $1" >&2
      echo
      display_help
      exit 1
      ;;

    *)
      break
      ;;
  esac
done

if [[ -z $input_dir ]] || [[ -z $output_dir ]]; then
  echo "Please specify the required arguments"
  echo
  display_help
fi


# create output directory
mkdir -p "$output_dir"

# list all json files (assumes that the only json files in the directory are laverna note metadata files)
# for each json file:
  # pull out the `id` and `title` information
  # create a new file with `title` as name and `id`.md as body in output directory
for f in $input_dir/*.json; do
    id=$(jq -r '.id' < $f)
    title=$(jq -r '.title' < $f)

    output_file=$(echo $title | sed 's/\//\\\//g').txt
    cat "$input_dir/$id.md" > "$output_dir/$output_file"
done

