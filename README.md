# LoRA fine-tuning of SmolVLA on LIBERO-Spatial

This project uses SmolVLA (450M), a small vision-language-action (VLA) robot policy, on the LIBERO-Spatial simulated manipulation benchmark. It has three parts:

1. **Reproduction.** Reproduce the published SmolVLA LIBERO-Spatial success rate under the paper's evaluation protocol, and measure how success changes with action-chunk execution length (`n_action_steps`).
2. **LoRA vs full fine-tuning.** Fine-tune `lerobot/smolvla_base` with LoRA and compare it with the fully fine-tuned public checkpoint `HuggingFaceVLA/smolvla_libero` on task success vs. trainable parameters.
3. **Ablations.** Seeded ablations over LoRA rank and adapter placement.

Everything uses LeRobot's built-in `lerobot-train` / `lerobot-eval` with documented flags (lerobot 0.7.0).

## Status
All phases: **PENDING**. See [docs/PROGRESS.md](docs/PROGRESS.md).

## Results
_Results table will be filled from `results/all_runs.csv`._

## Reproduce
```bash
bash env/setup.sh                         # conda env + pinned lerobot
export MUJOCO_GL=egl
bash scripts/eval.sh configs/eval_public_nas1.args
```

## Docs
Start at [docs/00_START_HERE.md](docs/00_START_HERE.md). Decisions: [docs/DECISIONS.md](docs/DECISIONS.md). Results: [docs/RESULTS.md](docs/RESULTS.md).
