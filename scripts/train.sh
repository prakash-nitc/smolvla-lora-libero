#!/usr/bin/env bash
# Wraps lerobot-train. All flags live in a config file (one flag per line, '#' comments allowed).
# Usage:  bash scripts/train.sh configs/train_lora_r64.args [extra flags...]
# Resume: bash scripts/train.sh configs/train_lora_r64.args --resume   (resumes from last checkpoint)
# Output: outputs/train/<config-name>/ (lerobot checkpoints) + train.log
set -euo pipefail
CFG="$1"; shift || true
NAME="$(basename "$CFG" .args)"
OUT="outputs/train/$NAME"
LOGDIR="outputs/logs"; mkdir -p "$LOGDIR"
export MUJOCO_GL="${MUJOCO_GL:-egl}"

mapfile -t FLAGS < <(grep -v '^\s*#' "$CFG" | sed '/^\s*$/d')

if [[ "${1:-}" == "--resume" ]]; then
  shift
  # lerobot resumes from the saved train config of the last checkpoint
  FLAGS=("--config_path=$OUT/checkpoints/last/pretrained_model/train_config.json" "--resume=true" "$@")
else
  FLAGS+=("--output_dir=$OUT" "--job_name=$NAME" "$@")
fi

LOG="$LOGDIR/train_${NAME}_$(date +%Y%m%d_%H%M%S).log"
{ echo "# $(date -Is) $(hostname) git=$(git rev-parse --short HEAD 2>/dev/null)"; printf '%s\n' lerobot-train "${FLAGS[@]}"; } | tee "$LOG"
start=$(date +%s)
lerobot-train "${FLAGS[@]}" 2>&1 | tee -a "$LOG"
echo "wall_seconds=$(( $(date +%s) - start ))" | tee -a "$LOG"
