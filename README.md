# Analytical Casework Lab

A public repository for reproducible, learner-authored analytical casework.

The Lab is a bounded applied-learning system. It develops analytical capability through progressively more demanding work rather than treating every case as an isolated portfolio exercise.

## Current state

- **C01 - Football Event Intelligence** is graded and closed. Its assessed submission is frozen at commit [`0e41ad0dbaeaad14666b41a438fb7e1b7ff90a34`](https://github.com/humphrey-nyanzi/analytical-casework-lab/commit/0e41ad0dbaeaad14666b41a438fb7e1b7ff90a34). Later governance or portfolio work must not overwrite that historical state.
- **LP-001 - Operational Definitions & Edge Cases** is the next ready micro-lab.
- **C02 - Cricket Match-State Strategy** remains unreleased. It may begin only after the required learning sequence is completed, reviewed, and explicitly released.

## How the Lab progresses

`Orientation -> Micro-lab -> Microcase -> Bridge Case when needed -> Assessment -> optional Portfolio Revision`

Practice develops and demonstrates individual capabilities. Formal assessments test whether those capabilities can be integrated and defended under a bounded brief. A later portfolio revision is separate from, and never changes, an assessed submission.

## Repository layout

```text
analytical-casework-lab/
├── README.md
├── practice/
│   └── LP-001-operational-definitions/
└── cases/
    └── C01-football-event-intelligence/
```

New practice, orientation, microcase, assessment, or shared-material paths are added only when that work has actually been selected or released. In particular, no C02 repository path exists before its formal release.

## What belongs here

This repository is the learner-safe reproducibility and history layer. It may contain:

- learner-authored notebooks, scripts, and SQL;
- provenance notes and reproduction instructions;
- safe analytical outputs and figures;
- AI-use disclosures and visible validation evidence; and
- assessed submission commits and later, clearly labelled revisions.

Notion owns project status, progression, mastery, and readiness. Google Drive owns governance, learner releases, feedback, and durable non-code records. Git history owns the reproducible code state.

Do not commit raw private data, evaluator-only material, hidden checks, expected answers, defence prompts, unreleased briefs, caches, or local checkpoints. Material AI assistance must be disclosed in the relevant artifact.

## Cases

- [C01 - Football Event Intelligence](cases/C01-football-event-intelligence/README.md) evaluates whether Chelsea FCW's high regains and post-regain attacking outcomes were genuinely distinctive relative to Manchester City WFC and Arsenal WFC in the 2023/24 FA Women's Super League.
