#!/system/bin/sh
#

SELF=$(basename "$0")
SHAOUT="shaList.txt"
NAMEOUT="nameList.txt"

: > "$SHAOUT"
: > "$NAMEOUT"

for f in *; do
    [ -e "$f" ] || continue
    [ -f "$f" ] || continue
    [ "$f" = "$SELF" ]    && continue
    [ "$f" = "$SHAOUT" ]  && continue
    [ "$f" = "$NAMEOUT" ] && continue

    hash=$(sha256sum "$f" 2>/dev/null | awk '{print $1}')
    [ -n "$hash" ] || continue

    size=$(wc -c < "$f" | awk '{print $1}')

    printf '%s\n' "$hash"          >> "$SHAOUT"
    printf '%s\t%s\n' "$f" "$size" >> "$NAMEOUT"
done