# Results

Status: **PENDING**. No experiments run yet. Every number we produce will cite its results file.

## Published target (source quotes)

**SmolVLA paper, arXiv 2506.01844, Table 2 (Section 4.5), LIBERO success rate (%):**

| Policy | Spatial | Object | Goal | Long | Avg |
|---|---|---|---|---|---|
| SmolVLA (0.45B) | 90 | 96 | 92 | 71 | 87.3 |

**Protocol, as stated in the paper:**
- Sec 4.1: evaluate "with 10 trials per task", binary success.
- Sec 4.3: action chunk of n = 50; "In simulation, we perform inference by sampling new observations and predicting a new action after each executed action" → `n_action_steps = 1`.
- Sec 4.3: LIBERO fine-tuning "for 100,000 steps with a batch size of 64", training only the action expert with the VLM frozen.
- Seed: **not stated** in the paper.

**Paper's chunk-execution ablation, Table 13 (Sec 4.7)**, LIBERO-Spatial column. Note that this comes from a from-scratch ablation model, not the released checkpoint:

| Action steps executed | 1 | 10 | 30 | 50 |
|---|---|---|---|---|
| Spatial success (%) | 89 | 89 | 76 | 54 |

**Model card `HuggingFaceVLA/smolvla_libero`:** reports no LIBERO success numbers and no training details (checked 2026-11-26).

## Phase 2: Reproduction: PENDING
## Phase 2: Chunk-length sweep: PENDING
## Phase 4: LoRA vs full fine-tuning: PENDING
## Phase 5: Ablations: PENDING
## Limitations: PENDING
