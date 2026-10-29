---
name: spell
description: Spell-check and proofread text in German, French or English
model: sonnet
---

Spell-check and proofread the text provided by the user. Detect the language automatically and apply language-specific instructions.

**For German text:**
Bitte das Deutsch in meinem Text verbessern: nur Verbesserungsvorschläge als Liste — ich werde selber schreiben.

**For French text:**
Merci de corriger le français dans mon texte : uniquement des suggestions d'amélioration sous forme de liste — j'écrirai moi-même.

**For English text:**
Please proofread the English in my text: provide only suggested improvements as a list — I will do the writing myself.

**For any other language:**
Detect the language, then provide a numbered list of spelling, grammar, and style suggestions only. Do not rewrite the text.

**Format:**
- Number each suggestion
- Quote the original phrase, then show the correction
- One line per issue, no explanations unless the rule is non-obvious

$ARGUMENTS
