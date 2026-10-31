# Write small skills

Use ASD-STE100-style English. Read the primary [ASD source](https://www.asd-ste100.org/).
This project applies selected writing rules. Its checks do not establish formal ASD-STE100 compliance.

Give each skill one bounded task. Keep its trigger and procedure in `SKILL.md`.
Move necessary detail into short bundled references. Use a router only to select another named skill.
Link to implementation contracts at their owner instead of copying them into a skill.

## Writing rules

- Use imperative instructions and active voice.
- Put one action in each sentence.
- Use simple words and consistent technical names.
- State the condition before its action.
- Preserve exact CLI commands, API names, paths, flags and identifiers.
- Check actual source or help before describing a tool.
- Report observed results and missing evidence clearly.
- Decide build reuse by the [input key](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/input-keys.md).
  Do not add checks that reread or rehash inputs that a git hash or input key already identifies.
- Require a causal regression test for a logic or behavior fix.
  A trivial fix needs no regression test: step order, typos, paths, and similar mechanical corrections.
  Such tests cost time and add no value.
- Refer to another skill by name, without a relative link into its folder.

Each skill must retain its own `agents/openai.yaml`, icon and supporting files.
Test the complete folder as a standalone installation. Retain the MIT license when redistributing it.

## Mechanical limits

| Content | Limit |
| --- | --- |
| Discovery description | 25 words |
| Main `SKILL.md` prose | 250 words |
| Each bundled reference | 500 words |
| Procedural sentence | 20 words |

Run `ruby scripts/check-package.rb` and `ruby scripts/test-check-package.rb`.
The checker inspects every bundled `.md` and `.markdown` file, including unlinked files.

Words are whitespace tokens containing a letter or digit. Inline code counts as one token.
Exclude frontmatter, fenced literal blocks, link destinations, reference definitions and Markdown separators.
Count headings, table labels and table cells toward document totals.
Headings have no sentence limit. Paragraphs, list items and table cells have sentence limits.
These limits also apply to fragments without final punctuation.
Split sentence units at `.`, `!` or `?` followed by whitespace or the text's end.
Join wrapped prose lines before counting sentences.
Fenced blocks must contain literal commands, source or output. Review their contents for disguised prose.

The link check supports inline links, reference definitions and HTML `href`/`src` attributes.
Resolve local destinations from their document, inside the owning skill folder.
Check Markdown fragments against heading slugs or explicit HTML anchors.
External URLs are not fetched.
Arbitrary Markdown extensions, natural-language grammar and the licensed ASD dictionary require manual review.
Review active voice, single actions, vocabulary and technical accuracy separately.

## Runtime and line width

Wrap source prose at approximately 100 columns. Line width is a readability target, not an enforced limit.
Optional native checks use `ruby scripts/check-package.rb --codex`.
Discovery and icon queries each have a 20-second timeout. Process cleanup can add up to ten seconds.
These checks use temporary Codex profiles and preserve saved user settings.

Remove completed assistant task instructions from referenced design documents.
A current contract describes behavior and checks, not a previous implementation assignment.
