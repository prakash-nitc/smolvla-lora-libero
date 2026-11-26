#!/usr/bin/env bash
# Phase 0: one-shot report of what this server can do.
# Usage:  bash scripts/check_server.sh 2>&1 | tee outputs/check_server.txt
# Safe to run: read-only, installs nothing, never asks for a password (sudo -n).

section() { echo; echo "===== $1 ====="; }

section "DATE / HOST"
date -Is; hostname; uname -a
cat /etc/os-release 2>/dev/null | grep -E '^(PRETTY_NAME|VERSION_ID)='

section "CPU / RAM"
nproc; free -h

section "GPU (nvidia-smi)"
if command -v nvidia-smi >/dev/null; then
  nvidia-smi
  nvidia-smi --query-gpu=index,name,memory.total,memory.used,utilization.gpu,driver_version --format=csv
  section "GPU processes (other users?)"
  nvidia-smi --query-compute-apps=pid,used_memory,process_name --format=csv
  for pid in $(nvidia-smi --query-compute-apps=pid --format=csv,noheader 2>/dev/null); do
    ps -o user=,pid=,etime=,cmd= -p "$pid" 2>/dev/null | cut -c1-150
  done
else
  echo "nvidia-smi NOT FOUND (are we on a login node without GPUs?)"
fi

section "CUDA toolkit"
command -v nvcc && nvcc --version | tail -n 2 || echo "nvcc not on PATH (fine: PyTorch wheels ship their own CUDA runtime)"
ls -d /usr/local/cuda* 2>/dev/null

section "EGL / OpenGL libs (needed for MUJOCO_GL=egl headless rendering)"
ldconfig -p 2>/dev/null | grep -E 'libEGL|libGL\.so|libOSMesa' | head || echo "ldconfig not readable"

section "DISK"
df -h "$HOME" /tmp 2>/dev/null
for d in /scratch /data /raid /ssd "/home/$USER"; do [ -d "$d" ] && df -h "$d" | tail -n 1; done
echo "HOME usage:"; du -sh "$HOME" 2>/dev/null
echo "HF cache: ${HF_HOME:-$HOME/.cache/huggingface}"

section "QUOTA"
quota -s 2>/dev/null || echo "no quota command / no quota"

section "SUDO (non-interactive check)"
if sudo -n true 2>/dev/null; then echo "sudo: YES (passwordless)"; else echo "sudo: NO (or needs password)"; fi

section "SLURM"
if command -v sbatch >/dev/null; then
  echo "SLURM: YES"; sinfo 2>/dev/null | head -n 20; squeue -u "$USER" 2>/dev/null
else
  echo "SLURM: NO"
fi

section "tmux / screen"
command -v tmux && tmux -V || echo "tmux: not found"
command -v screen || echo "screen: not found"

section "Python / conda"
command -v conda && conda --version || echo "conda: not found"
command -v mamba || true
command -v python3 && python3 --version
command -v uv || echo "uv: not found"
command -v ffmpeg && ffmpeg -version | head -n 1 || echo "ffmpeg: not found (torchcodec/pyav may need it)"
command -v git && git --version

section "INTERNET"
for url in https://huggingface.co https://pypi.org/simple/lerobot/ https://github.com https://download.pytorch.org/whl/; do
  code=$(curl -s -o /dev/null -m 10 -w '%{http_code}' "$url")
  echo "$url -> HTTP $code"
done
echo "proxy env: http_proxy=${http_proxy:-unset} https_proxy=${https_proxy:-unset}"

section "DONE"
