# WI-NNN — <short name>

Status: open
Stages: analyst → <the stages this item actually needs> → tester → operator

## Ask (verbatim)

<what was actually requested, in the requester's words>

## Analyst — requirements

<why this matters (tie to the request and the project's goals/backlog), what is IN and
OUT of scope, and numbered acceptance criteria a tester can check by running the
software. Name the stages this item needs and why any are skipped.>

## Designer — experience

<screens/output affected, layout and copy in markdown, states (empty, error, loading),
consistent with the project's existing look. Skip this section when the item has no
user-facing surface — say so.>

## DBA — data

<schema/seed/migration changes (made before the builder starts), upgrade behavior on
existing data, integrity and backup impact, the verification run, and the numbered data
checks the tester must run. "No data surface touched" is a valid full entry when true.>

## Builder — implementation

<what changed and where (files), how it satisfies each acceptance criterion by number,
test evidence (the tail of the project's test run), and anything the tester or operator
must know.>

## Tester — verification

<the whole suite re-run, each acceptance criterion PASS/FAIL by number with what was
actually seen, the edges and the dba's data checks. PASS ends with "Try it yourself"
steps for the person. FAIL names each finding's owner and sets the Status line to
`rework — <owner>, round N`.>

<!-- Rework rounds ("Builder — round 2", "Tester — round 2", ...) go here, directly above
the Operator section, in the order they happen. Earlier rounds are never edited. -->

## Operator — release & support

<version/changelog, deploy notes, what support should know, and the smoke check
performed where it now runs. Ends with `Status: shipped`.>

## Open questions

<anything any stage needed and could not find — each line names who must answer it. An
item never advances past an unanswered blocking question.>
