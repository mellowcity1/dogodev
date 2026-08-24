# WI-NNN — <short name>

Status: open
Stages: analyst → <the stages this item actually needs> → operator

## Ask (verbatim)

<what was actually requested, in the requester's words>

## Analyst — requirements

<why this matters (tie to the request and the project's goals/backlog), what is IN and
OUT of scope, and numbered acceptance criteria a builder can check off. Name the stages
this item needs and why any are skipped.>

## Designer — experience

<screens/output affected, layout and copy in markdown, states (empty, error, loading),
consistent with the project's existing look. Skip this section when the item has no
user-facing surface — say so.>

## Builder — implementation

<what changed and where (files), how it satisfies each acceptance criterion by number,
test evidence (the tail of the project's test run), and anything the dba or operator
must know.>

## DBA — data

<schema/seed/migration changes, integrity impact, backup/restore considerations, and the
verification run. "No data surface touched" is a valid full entry when true.>

## Operator — release & support

<version/changelog, deploy notes, what support should know, and the smoke check
performed. Ends with `Status: shipped`.>

## Open questions

<anything any stage needed and could not find — each line names who must answer it. An
item never advances past an unanswered blocking question.>
