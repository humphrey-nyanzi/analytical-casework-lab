# C01 - Football Event Intelligence

## Overview

This case investigates whether Chelsea FCW were genuinely distinctive in their ability to regain possession high up the pitch and turn those regains into dangerous attacks during the 2023/24 FA Women’s Super League season.

The analysis separates the problem into a simple decision chain:

**Opportunity → High regain → Post-regain attack → Dangerous attack**

Chelsea are compared primarily with Manchester City WFC and Arsenal WFC, selected independently of the regain results because they formed the closest competitive tier in the final league standings.

The final conclusion is that Chelsea are **not established as genuinely distinctive** from those peers. Their high-regain frequency is broadly comparable, while apparent advantages in post-regain outcomes are too uncertain and sensitive to reasonable changes in definition to support a strong claim of superiority.

The coaching recommendation is therefore **not to make a major pressing change on the basis of this analysis alone**. Further investigation, if undertaken, should focus on what Chelsea do immediately after winning possession high up the pitch.

---

## Data provenance

Source:

- StatsBomb Open Data / Hudl Open Data
- Repository: `hudl/open-data`
- Frozen commit: `b0bc9f22dd77c206ddedc1d742893b3bbe64baec`

Assessment scope:

- Competition: FA Women’s Super League
- Season: 2023/24
- Competition ID: `37`
- Season ID: `281`
- Target team: Chelsea FCW
- Chelsea team ID: `971`
- Match universe: `data/matches/37/281.json`
- Event files: `data/events/<match_id>.json`
- StatsBomb 360 data: out of scope

The frozen JSON files are treated as the source of truth. Cached Parquet files and analytical checkpoints are development conveniences and can be rebuilt from the raw data.

The full season contains:

- 132 matches
- 12 teams
- 22 matches per team
- 495,189 event records

---

## Main operational definitions

### Regain

A regain is a change of controlled possession from one team to the other during live play, anchored at the first event of the new possession.

Explicit restarts, referee ball-drops and possession gains beginning with goalkeeper-control events are excluded.

### High regain

A high regain is a regain beginning in the attacking final third:

`x >= 80`

StatsBomb locations use an approximately 120 × 80 coordinate system, with increasing x representing movement toward the acting team’s attacking goal.

### High-regain opportunity

One opportunity is one opponent possession in which the opponent demonstrates controlled possession in its own defensive third.

The denominator is possession-based rather than event-based so that repeated actions within the same possession do not create multiple opportunities.

### Post-regain attack

A post-regain attack occurs when a high regain produces either:

- a shot; or
- a successful entry into the opposition penalty area

within 15 seconds.

A successful penalty-area entry is a completed pass or carry that begins outside and ends inside the penalty area.

### Dangerous attack

A dangerous attack is a high-regain sequence that generates at least:

`0.10 total StatsBomb xG`

within 15 seconds of the regain.

Alternative 0.20 and 0.30 xG thresholds are retained as sensitivity checks.

### Relevant peers

The primary comparison teams are:

- Manchester City WFC
- Arsenal WFC

All 12 league teams remain available for descriptive context.

---

## Key results

### High-regain frequency

After adjusting for qualifying opportunities:

| Team | Opportunities | Linked high regains | High-regain rate |
|---|---:|---:|---:|
| Manchester City WFC | 1,155 | 98 | 8.5% |
| Arsenal WFC | 1,185 | 99 | 8.4% |
| Chelsea FCW | 1,245 | 94 | 7.6% |

Chelsea do not regain possession high more frequently than their primary peers.

### Post-regain attacks

| Team | High regains | Post-regain attacks | Attack per high regain |
|---|---:|---:|---:|
| Chelsea FCW | 94 | 36 | 38.3% |
| Arsenal WFC | 105 | 39 | 37.1% |
| Manchester City WFC | 103 | 38 | 36.9% |

Chelsea are slightly higher descriptively, but the differences are small and uncertain.

### Dangerous attacks

| Team | High regains | Dangerous attacks | Dangerous per high regain |
|---|---:|---:|---:|
| Chelsea FCW | 94 | 11 | 11.7% |
| Arsenal WFC | 105 | 10 | 9.5% |
| Manchester City WFC | 103 | 9 | 8.7% |

This is the strongest descriptive Chelsea signal, but the sample is small and the apparent advantage is not sufficiently robust to establish genuine distinctiveness.

---

## Uncertainty and sensitivity

The analysis uses two complementary uncertainty checks:

1. first-pass binomial confidence intervals and direct rate-difference intervals;
2. whole-match bootstrap resampling to account for outcomes being clustered within matches.

The substantive conclusion is stable across these uncertainty approaches: the evidence does not establish a meaningful Chelsea advantage over Manchester City or Arsenal.

Definition sensitivity is tested separately.

Reasonable alternatives include:

- 10-, 15- and 20-second post-regain attack windows;
- 0.10, 0.20 and 0.30 xG danger thresholds.

Chelsea’s relative position changes under these alternatives. The apparent attacking advantage therefore depends partly on the operational definition and should not be treated as a robust competitive distinction.

---

## Relational SQL layer

A small SQLite database is created from the validated analytical tables.

The relational layer contains:

- `opportunities`
- `high_regains`
- `post_regain_outcomes`

The query in:

`sql/peer_comparison.sql`

joins and aggregates these tables to reproduce the core Chelsea–Manchester City–Arsenal comparison.

The SQL results are reconciled against the Python results before being used as part of the submission.

---

## Decision-relevant figures

The submission contains three primary figures:

1. **High-regain rate** - Chelsea do not win possession high more often than Manchester City or Arsenal after opportunity adjustment.
2. **Post-regain attack rate** - Chelsea convert high regains into attacks at a similar rate to their primary peers.
3. **Dangerous-attack rate** - Chelsea show the highest descriptive rate of the three teams, but the advantage is not sufficiently conclusive or robust.

The figures are saved in the `outputs/` directory.

---

## Reproducing the analysis

### Recommended environment

The notebook is designed primarily for Google Colab because the full StatsBomb event dataset can be demanding on modest local hardware.

Core Python packages include:

- Python
- pandas
- NumPy
- PyArrow
- matplotlib
- sqlite3 from the Python standard library

### Data layout

The notebook expects the frozen data underneath the project directory:

```text
data/
├── raw/
│   ├── matches/
│   │   └── 281.json
│   └── events/
│       ├── <match_id>.json
│       └── ...
├── cache/
└── checkpoints/
```

All 132 event files corresponding to the frozen match universe must be available.

### Running the notebook

1. Obtain the StatsBomb/Hudl Open Data repository at commit:

   `b0bc9f22dd77c206ddedc1d742893b3bbe64baec`

2. Place the frozen season match file and corresponding event JSON files in the directory structure above.

3. Open the case notebook.

   - Submitted repository filename: `analysis.ipynb`
   - Working Google Drive/Colab filename: `C01_Football_Event_Intelligence_Colab.ipynb`

4. Set `PROJECT_ROOT` if the project is stored in a different Google Drive location.

5. For a full reconstruction from raw JSON, set the relevant rebuild switches in the notebook and run from the beginning.

6. For later working sessions, the notebook can reload the validated Parquet cache and stage checkpoints.

7. Run the relational SQL section to create the SQLite database and reproduce the peer-comparison table.

8. Run the figure section to regenerate the three decision-relevant figures.

Checkpoints are shortcuts only. If an upstream analytical definition changes, the affected layer must be rebuilt rather than relying on an older checkpoint.

---

## Validation

The notebook includes visible checks for:

- complete 132-match coverage;
- 12 teams and 22 matches per team;
- unique event IDs;
- possession-team consistency;
- chronological possession ordering;
- event actor and new-possession-team agreement;
- exclusion of restart and goalkeeper-control regain starts;
- opportunity assignment uniqueness;
- chronological linkage between opportunities and high regains;
- reconciliation of Python and SQL team-level results;
- sensitivity to alternative time and xG thresholds;
- match-level robustness through whole-match bootstrap resampling.

---

## Limitations

This is observational event-data analysis.

It does not establish that Chelsea’s pressing system causes particular attacking outcomes, nor does it identify the tactical mechanism responsible for each regain.

Other relevant context-such as opponent tactical plans, player roles, pressing instructions, physical load, score state and video evidence-is not fully represented in the primary analysis.

The dangerous-attack comparison is also based on relatively small event counts, including only 11 Chelsea dangerous attacks under the primary definition.

The findings should therefore inform coaching discussion rather than be interpreted as causal proof.

---

## Final decision

Chelsea FCW are **not shown to be genuinely distinctive** from Manchester City WFC and Arsenal WFC across the full high-regain decision chain.

The evidence does not justify a major change to Chelsea’s high-pressing approach.

The most useful follow-up question is not simply whether Chelsea should press more, but whether the decisions and actions immediately after a high regain can be improved or better understood.

---

## AI use

Material AI assistance was used during the case for analytical scaffolding, debugging, code development, validation design, notebook organization and drafting support.

The specific assistance and the independent checks applied to AI-generated code and claims are documented separately in:

`AI_USE.md`
