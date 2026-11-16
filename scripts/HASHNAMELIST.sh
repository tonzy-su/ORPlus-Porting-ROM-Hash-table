#!/system/bin/sh
#
# 遍历 Archives 下所有 nameList.txt，计算其 SHA-256，
# 并在同一目录生成 nameList.txt.sha256（sha256sum 标准校验格式，
# 可用 `sha256sum -c nameList.txt.sha256` 验证）。

BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

find "$BASE/Archives" -type f -name nameList.txt | sort | while IFS= read -r f; do
    hash=$(sha256sum "$f" 2>/dev/null | awk '{print $1}')
    [ -n "$hash" ] || continue

    printf '%s  %s\n' "$hash" "nameList.txt" > "${f%/*}/nameList.txt.sha256"
    printf '%s\n' "${f#"$BASE"/}"
done
