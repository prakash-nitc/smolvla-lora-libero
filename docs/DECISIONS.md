# Decisions

Every non-trivial choice, why it was made, and what we gave up. Newest at the bottom.

---

### D1: Pin lerobot to the PyPI release 0.7.0 (not a git checkout)
- **Options considered:** A) `pip install "lerobot[...]==0.7.0"` from PyPI. B) clone the GitHub repo at a commit and `pip install -e`. C) unpinned latest.
- **Chosen:** A, with extras `smolvla,libero,peft`.
- **Why (plain English):** 0.7.0 was the newest PyPI release on 2026-11-26 (checked against `https://pypi.org/pypi/lerobot/json`) and it ships all three extras we need. A released version is easier to reproduce than a commit hash, and the installed source in `site-packages/lerobot/` is exactly what the docs cite.
- **How I'd say it in an interview:** "I pinned the released LeRobot 0.7.0 so anyone can rebuild the exact environment with one pip command."
- **Tradeoff / what we gave up:** No fixes that landed on `main` after the release; if we hit a bug we can't patch it (by design, no forks).

### D2: Reproduction target = SmolVLA (0.45B) LIBERO-Spatial 90% from the paper, Table 2
- **Options considered:** A) paper Table 2. B) model card of `HuggingFaceVLA/smolvla_libero`. C) LeRobot LIBERO docs.
- **Chosen:** A. The model card and the LeRobot LIBERO docs page report no SmolVLA LIBERO success numbers (checked 2026-11-26), so the paper is the only published target.
- **Why:** We need a published number with a known protocol. The paper (arXiv 2506.01844, Sec 4.1/4.3, Table 2) gives Spatial = 90 for the 0.45B model, evaluated with 10 trials per task.
- **How I'd say it in an interview:** "The only published LIBERO-Spatial number for SmolVLA-450M is 90% in the paper's Table 2, so that's what I reproduced against."
- **Tradeoff:** The public checkpoint may not be the exact model behind Table 2 (different data copy/training run), so a gap could come from the checkpoint, not the evaluation. We'll state this if we see a gap.

### D3: Evaluation protocol (used for every eval in the project)
- **Options considered:** A) paper protocol: 10 episodes/task, re-plan after every action (`n_action_steps=1`). B) LeRobot defaults. C) more episodes per task for tighter CIs.
- **Chosen:** A: `libero_spatial`, 10 tasks × 10 episodes = 100 episodes, `n_action_steps=1`, hard resets, fixed init states, `--eval.batch_size=10` (= episodes per task, as the LeRobot LIBERO docs advise for fair comparisons), fixed `--seed=1000`.
- **Why:** Paper Sec 4.3: "In simulation, we perform inference by sampling new observations and predicting a new action after each executed action" and Sec 4.1: "10 trials per task". The LeRobot LIBERO docs say "Use hard resets when reproducing benchmark results." Using one protocol everywhere means every comparison changes only the model.
- **How I'd say it in an interview:** "Every number uses the paper's protocol: 100 episodes on LIBERO-Spatial, hard resets, fixed init states and seed, re-planning after every action."
- **Tradeoff:** 100 episodes gives wide confidence intervals (a few points of difference won't be significant). The paper doesn't state its seed, so seed-level variation is a known source of mismatch.

### D4: Chunk-length sweep values = 1, 10, 30, 50
- **Options considered:** A) 1, 5, 10, 50. B) 1, 10, 30, 50 (the paper's Table 13 values).
- **Chosen:** B.
- **Why:** The paper's own "action execution steps" ablation (Table 13) uses exactly 1/10/30/50 and reports Spatial = 89/89/76/54. Using the same values lets us put our curve next to theirs. 50 is the full chunk (`chunk_size=50`, paper Sec 4.3).
- **How I'd say it in an interview:** "I swept the same execution lengths the paper ablates, so my curve is directly comparable to their Table 13."
- **Tradeoff:** No point between 10 and 30. Note the paper's Table 13 used a from-scratch ablation model with a frozen VLM (Sec 4.7), not the released checkpoint, so the shape matters more than exact numbers.
