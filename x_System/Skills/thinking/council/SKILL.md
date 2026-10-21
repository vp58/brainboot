---
name: council
description: Decision stress-tester. Convenes a standing panel of flawed-persona critics plus 2-3 problem-specific experts to pressure-test a decision, plan, or draft. Every persona must end on a concrete $1000 bet with a confidence percentage and the one thing that would change their mind.
user-invocable: true
argument-hint: "\"<decision, plan, or question to stress-test>\" [--fast]"
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebSearch, WebFetch, Agent
version: 1.0
last_updated: 2026-07-25
exportable: true
credit: "Persona-council + forced-bet structure adapted from Zapier's wade-skills War Council (github.com/zapier/wade-skills, MIT license, (c) Wade Foster / Zapier). Adapted to vault conventions; not a verbatim copy."
---

# Skill: Council

Convene a council of critics to stress-test a decision before the owner commits to it. The council is a **decision stress-tester**, not a cheerleader. Its whole value is that every voice is flawed, biased, and forced to take a concrete position: no "it depends," no hedging, no consensus mush. Each persona ends on a $1000 bet with a stated confidence and a single falsifier.

Trigger on: "convene the council", "run this by the council", "stress-test this decision", "war council", "red-team this plan", "poke holes in this", `/council "<question>"`.

This skill is generalizable: it works for a product bet, a hire, a pricing move, a strategy memo, a big email, an investment, or a personal decision. It reasons about whatever problem is handed to it. If the problem is thin or ambiguous, it asks ONE sharpening question first, then proceeds.

## Dependencies

- `Atlas/Reference/Writing as the owner.md` - voice, if the council is asked to critique a draft
- `x_System/Skills/deep-research` (optional) - if a persona's bet hinges on an external fact the council cannot resolve from memory

## Core Mechanic (the point of the whole skill)

The bet-with-confidence close is what kills "it depends." Every persona, standing or generated, MUST end their turn with exactly this block:

```
If I bet $1000: [what I would actually bet on, stated as a concrete claim]
Confidence: [X]%
What would change my mind: [one specific, observable thing]
```

A persona turn without a filled-in bet block is invalid and must be regenerated. "Confidence: it depends" is not allowed; force a number. The falsifier must be a real, checkable signal ("if churn on the new plan is under 3% after 60 days"), never a mood ("if the vibe shifts").

## Standing Panel (always seated)

Four permanent critics. Each carries a backstory that INCLUDES a real failure, because a critic who has been burned argues harder and more specifically. Keep them in character.

### 1. The Ruthless CFO
Backstory: ran finance at a company that grew top-line 3x while quietly lighting cash on fire, missed the runway wall by one quarter, and had to run the layoff. Now trusts no revenue number without its cost of capital. Obsessed with unit economics, burn, payback period, and the difference between a good story and a good margin.
Lens: "What does this cost, what does it actually return, and when? Show me the money, not the narrative."

### 2. The Contrarian Board Member
Backstory: sat on a board that cheered a "sure thing" acquisition into the ground because nobody in the room would say the emperor was naked. Vowed to always be the dissenting vote. Attacks groupthink, momentum, and any decision that feels pre-agreed.
Lens: "What is everyone in this room assuming is true that might not be? What is the strongest case AGAINST this?"

### 3. The Customer Obsessive
Backstory: shipped a beautifully-architected feature nobody asked for, watched it get zero adoption, and learned the hard way that the org's excitement is not the customer's. Now starts from the user's actual job-to-be-done and refuses to reason from internal enthusiasm.
Lens: "Which real customer wakes up wanting this? What do they do today instead, and why would they switch?"

### 4. The Wartime Operator
Backstory: took over a burning launch with a broken team and a hard deadline, and learned that speed and a decision beat a perfect plan that ships late. Impatient with analysis-paralysis and second-order theorizing. Wants the smallest reversible bet that gets real signal fastest.
Lens: "What is the fastest way to get real signal? What can we do THIS week that is cheap to undo if we are wrong?"

## Per-Problem Experts (generated each run)

After seating the standing panel, generate **2-3 experts specific to this decision.** Each gets a name/role, a one-line backstory that includes a relevant failure, and a lens. Pick experts whose expertise directly bears on the decision (e.g. a PLG growth lead for a pricing move, a security engineer for an architecture bet, a seasoned recruiter for a hire, a tax advisor for a personal finance decision). Do not reuse the four standing archetypes; the experts add domain depth the panel lacks.

## Workflow

1. **Frame the decision (mandatory first step).** Restate the decision in one crisp sentence: what is being decided, what the options are, and what "winning" looks like. If the input is too vague to frame (no clear options or success criteria), ask ONE sharpening question and stop until answered. Do not run a council on a fog.


3. **Seat the council.** State the four standing personas plus the 2-3 generated experts, each with their one-line backstory-with-failure.

4. **Run the turns.** Each persona argues in character: the strongest version of their critique of THIS decision, specific to the framing, then their mandatory $1000-bet close. No persona parrots another; if two would say the same thing, sharpen one into disagreement. Aim for real conflict between the CFO and the Wartime Operator, between the Customer Obsessive and whoever is arguing from internal excitement.

5. **Force-rank the objections.** Collect every distinct objection raised. Rank them by (a) how likely the risk is and (b) how much damage it does if real. Cut filler: keep the 3-5 objections that actually matter, drop the rest. Do not present ten equal-weight worries.

6. **Tally the bets.** Produce a bet table: persona, their bet, confidence %, falsifier. Compute the spread. Wide disagreement or low average confidence is itself a signal that the decision is not yet ready.

7. **Synthesize a verdict.** Lead with a single recommendation (proceed / proceed-with-changes / do not proceed / get-more-signal-first), the decisive reasons, the top unresolved risk, and the cheapest next test that would most reduce uncertainty. This is your judgment on top of the council, not a vote count. Name which falsifier to watch.

`--fast`: run the four standing personas only, skip generated experts, one tight paragraph each plus bet, then verdict. Use for a quick gut-check.

## Output Format

```
## Decision
[one-sentence framing + options + what winning looks like]

## Council
[persona: one-line backstory-with-failure] x (4 standing + 2-3 experts)

## Turns
### [Persona name]
[in-character critique specific to this decision]
If I bet $1000: [claim] | Confidence: [X]% | Change my mind: [falsifier]
... (one per persona)

## Objections, force-ranked
1. [highest likelihood x damage] ...
(3-5 only; filler cut)

## Bet table
| Persona | Bet | Confidence | Falsifier |
| ... |

## Verdict
[proceed / proceed-with-changes / do not proceed / get-more-signal]
[decisive reasons] [top unresolved risk] [cheapest next test] [falsifier to watch]
```

## Rules

- Every persona MUST close on the $1000-bet block with a real confidence number and a checkable falsifier. No exceptions, no "it depends."
- Personas are flawed on purpose. Do not sand off their biases into balanced takes; the bias is the stress-test.
- Force real conflict. If the council reaches easy consensus, you have written it wrong: regenerate the weakest, most agreeable turn as a genuine dissent.
- Ground every load-bearing number in a real source or label it an assumption. Never let a persona invent a metric, a customer quote, or a company fact.
- Cut filler in the objection ranking: 3-5 objections that matter beat 10 that do not.
- The verdict is your synthesis, not a majority vote. Say what you would actually do.
- No em dashes in any output.
- The council recommends; it never executes. It does not send, publish, or commit anything. Any outbound or write action still goes through its own approval path.

## Related

- `x_System/Skills/deep-research` - resolve an external fact a bet hinges on
- `x_System/Skills/vault-ace/weekly-review/SKILL.md` - the council can be pointed at a weekly-review decision backlog
- `Atlas/Reference/Writing as the owner.md` - voice guide when critiquing a draft

[[Work]]
