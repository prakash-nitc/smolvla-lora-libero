#!/usr/bin/env bash
# Wraps lerobot-eval. All flags live in a config file (one flag per line, '#' comments allowed).
# Usage:  bash scripts/eval.sh configs/eval_public_nas1.args [extra flags to override...]
# Output: outputs/eval/<config-name>/ (lerobot eval_info.json, videos) + eval.log
set -euo pipefail
CFG="$1"; shift || true
NAME="$(basename "$CFG" .args)"
OUT="outputs/eval/$NAME"
mkdir -p "$OUT"
export MUJOCO_GL="${MUJOCO_GL:-egl}"

mapfile -t FLAGS < <(grep -v '^\s*#' "$CFG" | sed '/^\s*$/d')
FLAGS+=("--output_dir=$OUT" "$@")

{ echo "# $(date -Is) $(hostname) git=$(git rev-parse --short HEAD 2>/dev/null)"; printf '%s\n' lerobot-eval "${FLAGS[@]}"; } > "$OUT/command.txt"
start=$(date +%s)
lerobot-eval "${FLAGS[@]}" 2>&1 | tee "$OUT/eval.log"
echo "wall_seconds=$(( $(date +%s) - start ))" | tee -a "$OUT/command.txt"
