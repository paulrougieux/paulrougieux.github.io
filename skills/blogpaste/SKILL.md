---
name: blogpaste
description: Format a question-and-answer exchange from this conversation as a terminal-style transcript ready to paste into Paul's blog.
model: haiku
---

# blogpaste

Format a Paul-question / Claude-answer exchange from the current conversation as a
terminal-style transcript that Paul can paste straight into his blog. It mirrors how
the exchange looks in the terminal: Paul's input under a `❯` prompt, Claude's reply as
a `> ●` blockquote.


## What to format

- With no argument: use the **most recent** exchange — Paul's last substantive
  question and the answer that followed it.
- If an argument is given, use it to pick the exchange (a topic keyword, "the one
  about X", or e.g. "last 2" for the last two exchanges). Format each exchange with
  the same template, in order, separated by a blank line.
- This is a faithful transcript. Only reformat text that already exists in the
  conversation — do **not** add commentary, rewrite the answer, or change its meaning.

## Output template

Emit a fenced ` ```markdown ` block (so Paul copies the raw source), containing, for
each exchange:

```
Paul:

    ❯ <question, wrapped at 88 columns, every line indented 4 spaces;
    only the first line carries the ❯ prompt marker>

Claude:

  > ● <answer rendered as a blockquote: every line is 2 spaces then "> ";
  >   the first content line starts with the ● bullet>
```

## Formatting rules

- Wrap prose at 88 columns, counting the indent/prefix.
- **Paul's block**: header line `Paul:`, one blank line, then the question as a
  4-space-indented block. The first line begins with `❯ `; continuation lines are
  just indented 4 spaces (no `❯`).
- **Claude's block**: header line `Claude:`, one blank line, then the answer as a
  blockquote — each line is 2 spaces + `> `. The first content line starts with `● `.
  Separate paragraphs, list groups, and sections with a blank `>` or blank line.

## After producing it

Output only the transcript block, with no preamble or trailing remarks, so it is ready
to copy.
