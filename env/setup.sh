#!/usr/bin/env bash
# Environment setup. Updated with the exact steps that worked on the server (see docs/TROUBLESHOOTING.md).
# Usage:  bash env/setup.sh
set -euo pipefail

ENV_NAME=smolvla
LEROBOT_VERSION=0.7.0          # pinned (latest PyPI release on 2026-11-26); see docs/DECISIONS.md
PYTHON_VERSION=3.12            # lerobot 0.7.0 requires python >= 3.12

# 1) conda env
source "$(conda info --base)/etc/profile.d/conda.sh"
conda create -y -n "$ENV_NAME" python="$PYTHON_VERSION"
conda activate "$ENV_NAME"
conda install -y -c conda-forge ffmpeg   # video decoding for lerobot/libero (mp4 dataset)

# 2) lerobot with the three extras we need, pinned
pip install --upgrade pip
pip install "lerobot[smolvla,libero,peft]==${LEROBOT_VERSION}"

# 3) record versions
bash "$(dirname "$0")/record_versions.sh"
echo "Setup done. Remember: export MUJOCO_GL=egl"
