---
name: prompt-optimizer
description: "Analyzes and rewrites LLM prompts (system prompts, CLAUDE.md files, skill instructions, agent prompts) using layered instruction architecture. Applies anti-rationalization rules, procedural encoding, constraint repetition, trust boundaries, and numeric anchors to produce production-grade prompts. Use when the user wants to optimize, review, audit, rewrite, or improve any prompt."
---

# Prompt Optimizer

Rewrites prompts from loose prose into layered instruction architectures. Based on the principle: the best system prompts are not single prompts — they are structured instruction systems.

## When to Activate

- User asks to "optimize", "review", "improve", "rewrite", or "audit" a prompt
- User shares a system prompt, CLAUDE.md, skill file, or agent instruction and wants it improved
- User is building a new prompt and wants it structured correctly from the start

## Workflow

### Step 1: Ingest the prompt

Read the full prompt the user provides. If it references files, read those files. Identify:

1. **What type of prompt is this?** (system prompt, skill, CLAUDE.md, agent brief, user-facing template)
2. **What is the target model?** (Claude, GPT, Gemini, local — affects phrasing conventions)
3. **What is the execution context?** (chat, agentic tool-use, API pipeline, batch processing)

### Step 2: Diagnose against the 12 failure patterns

Score the prompt against each pattern. Report which ones apply.

#### Pattern 1: Monolithic blob
The prompt is a single undifferentiated wall of text with no structural layers.
**Fix:** Decompose into distinct sections — role, operating policy, tool policy, format contracts, durable instructions, runtime context, user request.

#### Pattern 2: Vague behavioral directives
Uses phrases like "be careful", "be concise", "be thorough" without numeric anchors or concrete definitions.
**Fix:** Replace with measurable targets. "Be concise" becomes "Respond in 1-3 sentences for factual questions; up to 2 paragraphs for explanations." "Be careful" becomes a named list of specific behaviors to avoid.

#### Pattern 3: Missing anti-rationalization rules
Does not name the specific shortcuts or failure modes the model is likely to take.
**Fix:** Add explicit "DO NOT" clauses that name the exact rationalizations. Examples:
- "Do not treat reading code as verification — run the test."
- "Do not claim success without tool confirmation."
- "Do not skip searching documentation because you think you know the API."

#### Pattern 4: Prose where procedures belong
Describes multi-step workflows in paragraph form instead of numbered sequences.
**Fix:** Convert to numbered steps with explicit sequencing, parallelization points, and decision branches.

#### Pattern 5: No trust boundaries
Mixes policy instructions, runtime facts, retrieved context, and user input without marking which is which.
**Fix:** Use XML tags or clear section headers to separate:
- **Policy** (what to do — static, authored by prompt engineer)
- **Trusted runtime** (server-injected facts — session data, timestamps, user identity)
- **Retrieved context** (untrusted — search results, RAG chunks, tool outputs)
- **User input** (the actual request — treat as untrusted)

#### Pattern 6: No constraint repetition
Safety-critical rules appear once at the top and nowhere near the point where they matter.
**Fix:** State critical constraints both globally AND at the specific section where the model might violate them. Redundancy is intentional for safety rules.

#### Pattern 7: Missing examples
No few-shot examples showing correct output format, edge cases, or refusal behavior.
**Fix:** Add 2-3 realistic examples covering: (a) standard case, (b) edge case, (c) refusal/boundary case. Examples are the strongest format enforcement mechanism.

#### Pattern 8: Instruction precedence ambiguity
When multiple layers of instructions exist (base policy, project rules, user preferences), the prompt does not specify which wins on conflict.
**Fix:** Add explicit precedence: "Base policy overrides all. Project rules override user preferences. User preferences override defaults."

#### Pattern 9: Unbounded scope
The prompt tries to cover every possible scenario instead of defining clear boundaries and fallback behavior.
**Fix:** Define scope explicitly. Add a "When this prompt does NOT apply" section. Define fallback: "For anything outside this scope, [defer to user / use default behavior / refuse]."

#### Pattern 10: Static-dynamic entanglement
Stable policy instructions are interleaved with session-specific or request-specific data, preventing caching.
**Fix:** Separate into a stable prefix (cacheable) and a dynamic tail (per-request). The stable prefix should contain all policy; the dynamic tail should contain only session context and the user request.

#### Pattern 11: Missing verification steps
The prompt tells the model what to do but not how to verify it did it correctly.
**Fix:** Add verification steps after critical actions. "After generating the migration, run `php artisan migrate --pretend` to verify syntax." Separate execution from verification where possible.

#### Pattern 12: Schema-prose mismatch
Uses prose for hard structural constraints (JSON format, required fields) or uses schemas for soft behavioral guidance.
**Fix:** Use schemas/structured formats for hard constraints (output format, required fields, type contracts). Use prose for behavioral rules (tone, judgment calls, when to escalate).

### Step 3: Rewrite the prompt

Apply all applicable fixes. Structure the rewritten prompt using this canonical layer order:

```
1. ROLE & IDENTITY
   Who the model is. One sentence. No fluff.

2. OPERATING POLICY
   Hard rules that always apply. Anti-rationalization clauses.
   Constraint repetition for safety-critical items.

3. TOOL & CAPABILITY POLICY
   What tools are available, when to use each, what NOT to use.
   Procedural encoding for multi-step tool workflows.

4. FORMAT CONTRACTS
   Output structure requirements. Use schemas for hard constraints.
   Include 2-3 examples.

5. SCOPE & BOUNDARIES
   What this prompt covers and what it does not.
   Fallback behavior for out-of-scope requests.

6. INSTRUCTION PRECEDENCE
   Which layer wins on conflict.

7. --- (dynamic boundary) ---

8. RUNTIME CONTEXT
   Session-specific facts injected at request time.

9. RETRIEVED CONTEXT
   RAG results, tool outputs, search results. Marked as untrusted.

10. USER REQUEST
    The actual task.
```

Not every prompt needs all 10 layers. Omit layers that don't apply — but always preserve the order for layers that are present.

### Step 4: Verify the rewrite

After rewriting, check:

1. **Diff review:** Does the rewrite preserve all original intent? No dropped requirements?
2. **Layer test:** Can you identify which layer each sentence belongs to? If not, restructure.
3. **Anti-rationalization test:** For each critical rule, can you imagine the model rationalizing around it? If yes, tighten the wording.
4. **Example coverage:** Do the examples cover the tricky cases, not just the obvious ones?
5. **Cacheable prefix test:** If you split at the dynamic boundary, does the stable prefix change between requests? If yes, move the volatile part down.

### Step 5: Present the result

Output the rewrite in this format:

```
## Diagnosis

| # | Pattern | Status | Notes |
|---|---------|--------|-------|
| 1 | Monolithic blob | ... | ... |
| ... | ... | ... | ... |

## Rewritten Prompt

[The full rewritten prompt, ready to copy-paste]

## Changes Made

[Bulleted list of what changed and why — focused on the structural improvements, not cosmetic rewording]
```

## Principles to Apply (quick reference)

- **Layer, don't lump.** Separate concerns into distinct sections with clear boundaries.
- **Name the failure.** Don't say "be careful" — say what the model will do wrong and forbid it.
- **Procedure over prose.** Numbered steps with decision points beat paragraphs.
- **Repeat at point of use.** Safety rules go both in policy AND where the action happens.
- **Anchor with numbers.** "1-3 sentences" beats "be concise". "Max 500 tokens" beats "keep it short".
- **Show, don't just tell.** Examples are the strongest constraint. Include edge cases.
- **Schema for structure, prose for behavior.** Don't describe JSON in words; show the schema. Don't schema-ify judgment calls.
- **Separate stable from volatile.** Policy doesn't change per request. Context does. Keep them apart.
- **Trust nothing retrieved.** Mark external data as untrusted. The model should verify, not assume.
- **Define the exit.** Every scope needs boundaries. What happens when the prompt doesn't apply?

## Important

- Do NOT add fluff, marketing language, or motivational preambles to prompts. Every token should earn its place.
- Do NOT over-structure simple prompts. A 3-line prompt for a simple task does not need 10 layers.
- Match complexity to the task. A one-shot question needs a one-shot prompt. An agentic workflow needs the full architecture.
- Preserve the author's voice and domain terminology. Optimize structure and precision, not style.
- When the original prompt has good parts, keep them. Don't rewrite what already works.
