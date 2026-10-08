# MC-C02-01: Simple Cricket Match-State Microcase

Learning-practice microcase. Synthetic data. Not an assessment.

**Question:** in completed T20 chases, at the end of over 10 of the second innings, how did chase success differ by the gap between required and current run rate?

## 1. Definitions
- **Row grain:** `deliveries` has one row per delivery event, including wides and no-balls. `innings` has one row per innings. `matches` has one row per match.
- **Keys:** `delivery_id` (deliveries), `match_id` + `innings_no` (innings), `match_id` (matches). Joining deliveries to innings on `match_id` alone doubles the rows.
- **Legal ball:** `extra_type` is null or `legbye`. Wides and no-balls are not legal balls.
- **Runs:** `runs_off_bat` + `extras`. **Wickets:** sum of `wicket`.
- **Checkpoint:** the first 10 overs of innings 2, using `over_no <= 10`. A chase is included only if it reached 60 legal balls without being all out.
- **Formulas:** CRR = runs / 10. RRR = (target − runs) / ((120 − legal balls) / 6). Gap = RRR − CRR. Buckets: gap ≤ 0, 0 < gap ≤ 2, gap > 2.

## 2. Data issues log
| Issue | How found | Action |
|---|---|---|
| Three duplicate delivery rows: D000201, D000901, D001301 | Duplicate check on `delivery_id` | Kept one copy of each, in a copy of the data. Raw files untouched |
| M017 has no result or winner | Missing `winner`, `result_type` = no_result | Excluded (not completed) |
| M031 innings 2 ended in 6 overs (target reached) | Inspected innings shorter than 10 overs | Excluded (no state at checkpoint) |

Expected chases: 40 matches − 1 (not completed) − 1 (chase ended before checkpoint) = 38.

## 3. Plan
- **Unit of analysis:** one row per chase (`match_id`) at the checkpoint.
- **Columns:** `match_id`, `total_runs`, `total_wickets`, `total_legal_balls`, `target`, `CRR`, `RRR`, `gap`, `gap_bucket`, `outcome`.
- **Win rate:** chases won in a bucket / chases in that bucket.
- **Validation:** row count equals 38; no nulls in `gap`, `gap_bucket`, `outcome`; bucket counts sum to 38; pandas and SQL agree field by field; `outcome` agrees with `matches.winner`.

## 4. Result
| Bucket | Chases | Wins | Win rate |
|---|---|---|---|
| gap ≤ 0 | 14 | 12 | 85.7% |
| 0 < gap ≤ 2 | 11 | 5 | 45.5% |
| gap > 2 | 13 | 0 | 0% |

Mean wickets lost at over 10: 2.29, 2.45 and 3.62 respectively.
Rows versus legal balls: 36 of 38 chases contain non-legal rows in the first 10 overs (125 extra rows, 92 wides and 33 no-balls). Counting rows instead of legal balls would move 5 of 38 chases into a different bucket.

## 5. Conclusion
**Cricket reading.** At the end of over 10, the gap between required and current run rate separated outcomes. Chasing sides more than 2 runs an over behind the required pace won 0 of 13. Sides level with or ahead of the pace won 12 of 14. Sides 0–2 runs an over behind won 5 of 11, the least predictable group. The largest-gap sides had also lost more wickets on average (3.6 against about 2.4).

**Data reading.** This is synthetic data at a single checkpoint, so it shows a pattern, not a rule. Each bucket has only 11–14 chases, so one result would move a percentage sharply; 0 of 13 does not mean a win is impossible. Two matches fell outside scope: M017 (no result) and M031 (target reached before over 10). Counting delivery rows instead of legal balls would have moved 5 of 38 chases into a different bucket.

## 6. Limitations
Initially, I struggled to understand and visualise that a chase was merely a match state at a set checkpoint of after 10 overs in the second innings. The framing of the question as a 'rule of thumb' to give a coach also caught me a offguard because I had failed to grasp that the analysis needed us to capture match state at he checkpoint, and then group these states into buckets and then compare the win rates in each. Most of the intuition to solve the problem came during the all chases implementation plan in step 7 but even then somethings seemed fuzzy for example creation of the outcome column came to me  later during the implemetation part, and the hardest bit was validation of the outputs, where I couldn't easily think of ways to validate the outputs and finally the other challenge came with final interpretation. I could see the figures and the columns, but tying it back to the original question was challenging on my own.

## 7. AI-use note
Most of the work was unaided with the exception of certain code syntax and improvements only after personally trying out the method myself. The general pipeline, definitions that came from the brief, and cricket interpretations and  initial implementations were all unaided.
In the exploratory section, i didnt wirte the code to show the sorrounding rows... this was fully AI because again i knew what i wanted but i didn't know how ot implement it in code.

The first SQL implementation of M002 was done by me 80% by slowly building the query till the desired output, with exception of `SUM(CASE WHEN (extra_type IS NULL OR extra_type = 'legbye') THEN 1 ELSE 0 END) AS total_legal_balls` whose final version was proposed by AI. This became evn more serious during the full chase table replication in SQL,i started the query but ended at about 40%, when CTEs came into play and AI came in for the rest of the query after cleaning my rugged starts. The part in the query I had no idea of doing was deduplication of the delivery IDs within the same query.

Analytical Validation and robustness audits were also fully written by AI. Somehow I had a fuzzy idea of what to check for(and this was very shallow) but had no idea of how to implement it in code. I didn't see the relevance in audidting buckets if all raw rows were counted as legal balls.

Summary and interpretaion wording were also a bit fuzzy but with the help of AI, maanaged to get it sorted. FInally, AI helped me reorganise the notebook sections, add comments and a final brief strategic takeaway

The final conclusion wording was drafted by AI from my own sentences. The reconciliation, rows-versus-events diagnostic, duplicate proof, outcome cross-check and assertions were written by AI.

## 8. Reproducing
Notebook: `MC_C02_01_Cricket_Match_State_Microcase.ipynb`. Commit: `50bafd6`.