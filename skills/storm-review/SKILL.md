---
name: storm-review
description: "Run the STORM (Stanford) multi-perspective analysis: 5 simulated expert perspectives, a contradiction map, a synthesis briefing, and a self-critique peer review. Invoke ONLY when the user explicitly types /storm-review (or asks for STORM/storm-review by name). Do not trigger on general requests to assess, review, or analyse a topic."
---

# /storm-review

Run the STORM (Stanford) parallel-experts method on a topic: simulate five expert
perspectives, map their contradictions, synthesise a briefing, then peer-review the
briefing to catch source bias and fact misassociation.

## Usage

```
/storm-review <topic or question>            # analyse the given issue
/storm-review literature/escobar2018_land_use.pdf   # analyse a paper (PDF read into context)
/storm-review <topic> --role "policy analyst"       # tailor the actionable insight to a role
```

## Parameters

- **TOPIC** (required) — everything the user passes after `/storm-review` is the issue
  to analyse. It replaces `[YOUR TOPIC]` in every prompt below. If no topic is given,
  ask the user for one before proceeding.
- **PDF / file context** (optional) — if an argument is a path to a `.pdf`, `.txt`, or
  `.md` file (e.g. something under `literature/`), **Read that file first** (the Read
  tool ingests PDFs directly) and treat its content as the primary source material the
  five perspectives must engage with. You may pass several files. When a PDF is given,
  the TOPIC is "the claims/argument made in this document" unless the user also gives an
  explicit question.
- **--role "<role>"** (optional) — the role for the Actionable Insight in Prompt 3.
  Replaces `[YOUR ROLE]`. Defaults to the user's role as a forest-bioeconomy researcher
  if unset.

## Procedure

Create a new subdirectory `ai_generated/storm/` (make `ai_generated/` if it does not
exist). Write the assembled result to a dated markdown file there, e.g.
`ai_generated/storm/<slug>-<YYYY-MM-DD>.md`, with the four sections below as top-level
(`#`) titles.

Orchestration:

- **Spawn parallel agents** for Prompt 1 (the five-perspective scan — one agent per
  perspective, or one agent producing all five) and for Prompt 4 (the peer review).
- **You, the coordinating agent, run** Prompt 2 (contradiction map) and Prompt 3
  (synthesis) yourself, since they depend on having all perspectives in hand.
- Assemble every contribution into the single markdown document.

If a PDF/file was provided, pass its key claims and any extracted quotes/numbers to the
spawned perspective agents so they argue from the actual source, not from memory.

### Prompt 1 — The Multi-Perspective Scan (parallel agents)

    I need to research [YOUR TOPIC].
    Simulate 5 different expert perspectives on this topic:
    1. THE PRACTITIONER: works with this daily.
    What do they know that academics miss?
    What practical realities are usually ignored?
    2. THE ACADEMIC: has studied this for years.
    What does the peer reviewed evidence actually say?
    Where does the evidence contradict popular belief?
    3. THE SKEPTIC: thinks the mainstream view is wrong.
    What is the strongest counterargument?
    What evidence do proponents conveniently ignore?
    4. THE ECONOMIST: follows the money.
    Who profits from the current narrative?
    What financial incentives shape the research?
    5. THE HISTORIAN: has seen similar patterns before.
    What historical parallels exist?
    What can we learn from how those played out?
    For each perspective give me:
    - Their core position in 2 sentences
    - The strongest evidence supporting their view
    - The one thing they would tell me that no other perspective would

### Prompt 2 — The Contradiction Map (coordinating agent)

    Based on the 5 perspectives above, map the contradictions:
    1. Where do two or more perspectives directly contradict
    each other? List each conflict with the specific claims
    that clash.
    2. Which perspective has the strongest evidence?
    Which has the weakest? Why?
    3. What is the one question that, if answered, would
    resolve the biggest contradiction?
    4. What does EVERY perspective agree on?
    (This is likely true. Even opponents confirm it.)
    5. What topic did NONE of the perspectives address?
    (This is the blind spot in the whole field.
    Often the most valuable finding.)

### Prompt 3 — The Synthesis (coordinating agent)

    Synthesize everything from the 5 perspectives and the
    contradiction map into a research briefing:
    1. THE ONE PARAGRAPH SUMMARY: explain this topic as if
    briefing a CEO who has 60 seconds and needs nuance,
    not just the headline.
    2. THE 5 KEY FINDINGS: most important things I now know,
    ranked by reliability. For each, note which perspectives
    support it and which challenge it.
    3. THE HIDDEN CONNECTION: one non obvious link between
    findings that only shows up when you look at all 5
    perspectives together.
    4. THE ACTIONABLE INSIGHT: based on all the evidence,
    what should someone in [YOUR ROLE] actually DO
    differently? Be specific.
    5. THE FRONTIER QUESTION: the one question that, if
    answered, would change everything about how we
    understand this topic.

### Prompt 4 — The Peer Review (parallel agent)

STORM has one known weakness that Stanford's own researchers flagged: the system does
not self-critique, so source bias and fact misassociation sneak in. This prompt fixes
that by making the model grade its own work.

    Now peer review your own research briefing:
    1. CONFIDENCE SCORES: rate each of the 5 key findings
    on a 1 to 10 scale for reliability. Explain each score.
    2. WEAKEST LINK: which claim are you least confident in?
    What specific info would you need to verify it?
    3. BIAS CHECK: which perspective might be overrepresented
    in your synthesis? Did one voice dominate?
    4. MISSING PERSPECTIVE: is there a 6th angle I should
    have included that would change the conclusions?
    5. OVERALL GRADE: if a Stanford professor reviewed this
    briefing, what grade would they give and why?
    What would they tell me to fix?
