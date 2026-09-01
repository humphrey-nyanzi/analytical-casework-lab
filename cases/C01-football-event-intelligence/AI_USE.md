# AI Use - C01 Football Event Intelligence

## Purpose

AI tools were used materially during this case. Their role was to support analytical reasoning, code development, debugging, validation design, interpretation, documentation and notebook organization.

AI assistance did not replace the requirement to define the football problem, inspect the data, choose operational definitions, validate outputs, interpret uncertainty or make the final decision. Material AI-generated code and analytical claims were checked against the underlying StatsBomb data and reconciled with independently inspected intermediate results before being retained.

---

## Material AI assistance

### 1. Analytical framing

AI was used to help decompose the core question into a decision chain:

**Opportunity → High regain → Post-regain attack → Dangerous attack**

It also helped identify the need to distinguish:

- raw regain counts from opportunity-adjusted regain frequency;
- the event that anchors a possession change from the defensive mechanism that caused it;
- high-regain frequency from what happens after the regain;
- descriptive differences from evidence of meaningful distinctiveness;
- uncertainty robustness from definition sensitivity.

The final operational choices were made during the analysis rather than copied from a prescribed solution.

---

### 2. Data inspection and regain reconstruction

AI assisted with Python code and debugging for:

- loading and combining the frozen StatsBomb JSON event files;
- inspecting the wide and sparse event schema;
- validating match coverage and event-ID uniqueness;
- reconstructing possession starts;
- checking possession-team consistency;
- identifying chronological team changes;
- inspecting restart, goalkeeper and event-actor edge cases;
- implementing the retained live-play regain definition;
- validating pitch orientation from shot locations;
- calculating final-third high regains.

Important edge cases were inspected using the actual event sequences before definitions were retained.

---

### 3. Exposure denominator

AI helped structure the reasoning and implementation for the high-regain opportunity denominator.

The final denominator counts one opponent possession in which the opponent demonstrates controlled possession in its own defensive third.

AI-assisted code was used to:

- identify conservative control evidence;
- assign each qualifying possession to the opposing team;
- check duplicate assignments;
- link high regains chronologically to the preceding possession;
- distinguish the exposure-adjusted high-regain numerator from the full high-regain population used for downstream attacking outcomes.

The resulting counts were reconciled before being used in the comparison.

---

### 4. Post-regain attacking outcomes

AI assisted with code for:

- reconstructing the full possession following each high regain;
- measuring time from regain to first shot;
- identifying completed pass and carry entries into the penalty area;
- correcting an early candidate box-entry rule so unsuccessful passes were excluded;
- comparing 10-, 15- and 20-second attacking windows;
- aggregating StatsBomb xG after high regains;
- comparing 0.10, 0.20 and 0.30 xG danger thresholds.

The retained definitions were:

- **Post-regain attack:** shot or successful penalty-area entry within 15 seconds.
- **Dangerous attack:** at least 0.10 total StatsBomb xG within 15 seconds.

These thresholds were retained with alternative definitions shown as sensitivity checks.

---

### 5. Peer comparison and uncertainty

AI supported code and explanation for:

- reconstructing the final WSL standings;
- comparing Chelsea with Manchester City WFC and Arsenal WFC;
- Wilson confidence intervals;
- approximate direct rate-difference intervals;
- whole-match bootstrap resampling;
- match-level reconciliation of regain, attack and dangerous-attack totals;
- interpreting definition sensitivity separately from statistical uncertainty.

AI also helped translate the statistical output into simpler football language when the technical comparisons became difficult to follow.

The final judgement that Chelsea were **not established as genuinely distinctive** was retained only after the descriptive results, uncertainty ranges, match-level resampling and definition sensitivity were considered together.

---

### 6. SQL and visualization

AI provided code scaffolding for a small SQLite relational layer containing:

- `opportunities`
- `high_regains`
- `post_regain_outcomes`

The SQL query aggregates those tables to reproduce the core Chelsea–Manchester City–Arsenal comparison.

AI also provided plotting code for the three decision-relevant figures:

1. opportunity-adjusted high-regain rate;
2. post-regain attack rate;
3. dangerous attacks per high regain.

The SQL results were compared directly with the previously validated Python results before being accepted.

---

### 7. Documentation and organization

AI assisted with:

- organizing the Colab notebook;
- adding explanatory markdown around final definitions and uncertainty;
- distinguishing exploratory work from retained methodology;
- drafting and refining the working analytical report;
- drafting the README;
- simplifying the analysis into coach-facing language;
- drafting the coaching recommendation.

AI-generated writing was checked against the validated analytical results before being added to the case materials.

---

## Independent checks performed

Material AI-generated code and claims were checked using the following evidence:

- all 132 required matches were present;
- the event layer contained 495,189 records;
- no duplicated event IDs were found;
- each match-possession had a consistent possession team;
- possession numbering did not move backwards within matches;
- retained regain anchors were performed by the newly controlling team;
- explicit restart, referee ball-drop and goalkeeper-control starts were excluded from the primary regain population;
- shot locations were used to confirm coordinate orientation;
- the retained regain population contained 9,721 league regains;
- the high-regain population contained 799 events;
- the opportunity population contained 13,970 qualifying possessions;
- no duplicate opportunity assignments were found;
- all 94 Chelsea high regains linked to a qualifying preceding opportunity;
- all 799 high-regain possessions were reconstructed for downstream analysis;
- all 286 shots in those high-regain possessions were attributed to the regain team;
- unsuccessful passes were removed from the successful penalty-area-entry definition;
- alternative 10-, 15- and 20-second attack windows were compared;
- alternative 0.10, 0.20 and 0.30 xG danger thresholds were compared;
- team-level attacking outcome totals were reconciled;
- match-level totals were reconciled with season-level totals;
- whole-match bootstrap conclusions were compared with first-pass binomial conclusions;
- SQL peer-comparison results matched the Python results.

---

## Final ownership and limitation

AI materially accelerated the implementation and explanation of this case. It also created a risk that parts of the analysis could move faster than independent understanding, particularly during the more technical sequence reconstruction and uncertainty work.

For that reason, the final case emphasizes transparent definitions, visible reconciliation checks, simple coach-facing interpretation and explicit documentation of AI use.

The final analytical position is:

**Chelsea FCW are not shown to be genuinely distinctive from Manchester City WFC and Arsenal WFC across the full high-regain decision chain.**

The evidence does not support a major change to Chelsea’s high-pressing approach from this analysis alone. Further investigation would be more useful if focused on decisions and actions immediately after high regains.
