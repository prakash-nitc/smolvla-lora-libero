# Progress log

Status key: **DONE** · **PARTIAL** · **PENDING**

| Phase | Status |
|---|---|
| 0 Server check | PENDING (script written, needs server access) |
| 1 Setup + smoke test | PENDING |
| 2 Reproduction + chunk sweep | PENDING (protocol + configs drafted) |
| 3 Timing + budget | PENDING |
| 4 Main LoRA run | PENDING |
| 5 Ablations | PENDING |
| 6 Wrap-up | PENDING |

---

### 2026-11-26
- Repo scaffolded: `.gitignore`, `env/setup.sh` (lerobot 0.7.0 pinned, D1), `scripts/check_server.sh`, `scripts/eval.sh`, `scripts/train.sh`, Phase 2 eval configs in `configs/`.
- Found the reproduction target: paper Table 2, SmolVLA-0.45B LIBERO-Spatial = 90, protocol 10 trials/task, re-plan every action (D2, D3). Public model card has no LIBERO numbers.
- Chunk sweep set to 1/10/30/50 to match the paper's Table 13 (D4).
- **Next:** run `scripts/check_server.sh` on the GPU server (needs SSH access from Prakash).
