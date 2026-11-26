#!/usr/bin/env bash
# Writes env/versions.txt: everything needed to reproduce the software environment.
# Usage (inside the activated env):  bash env/record_versions.sh
OUT="$(dirname "$0")/versions.txt"
{
  echo "# Recorded: $(date -Is) on $(hostname)"
  echo "## lerobot"
  python -c "import lerobot,os;print('lerobot', lerobot.__version__, os.path.dirname(lerobot.__file__))"
  echo "## torch / cuda"
  python -c "import torch;print('torch',torch.__version__,'cuda',torch.version.cuda,'cudnn',torch.backends.cudnn.version());print('gpu',torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'none')"
  echo "## nvidia driver"
  nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2>/dev/null
  echo "## python"
  python --version
  echo "## dataset revision(s) (filled by scripts/smoke_test.sh)"
  cat "$(dirname "$0")/dataset_revision.txt" 2>/dev/null || echo "not recorded yet"
  echo "## pip freeze"
  pip freeze
} > "$OUT"
echo "wrote $OUT"
