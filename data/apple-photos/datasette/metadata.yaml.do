DATE="$(date -R)" envsubst '$DATE' < "$1.in" > "$3"
