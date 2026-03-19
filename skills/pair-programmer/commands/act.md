---
description: Act on a spoken instruction from the mic transcript
tools: Bash, Read, Write, Edit, Task
---

Find the user's most recent spoken instruction from the mic transcript and execute it.

## Events File

All recording events are in `/tmp/videodb_pp_events.jsonl` (one JSON per line). Each line has:

```json
{"ts": "2026-03-05T10:15:30.123Z", "unix_ts": 1709374530.12, "channel": "transcript", "data": {"text": "..."}}
```

## Flow

### 1. Pre-flight

Check that a recording session exists:

```bash
cat /tmp/videodb_pp_info.json
```

If file doesn't exist or is empty, tell the user no recording session is available.

### 2. Extract recent spoken instructions

Read the last 3 minutes of mic transcript:

```bash
grep '"channel":"transcript"' /tmp/videodb_pp_events.jsonl | tail -30
```

For more precise time filtering, filter lines from `/tmp/videodb_pp_events.jsonl` where `unix_ts` > `(current_epoch - 180)` and channel is `"transcript"`. Get current epoch with `$(date +%s)`.

### 3. Identify the actionable instruction

From the transcript, identify the most recent statement that is an **instruction or request** — something the user wants done. Look for:

- Direct commands: "fix the bug in...", "add a test for...", "refactor this to..."
- Requests: "can you update...", "I need you to...", "let's change..."
- Implicit tasks: "this function should handle errors", "we need validation here"

Ignore conversational speech, thinking out loud, or commentary that isn't a task.

If the user passed a query with the command (e.g. `/pair-programmer act "the thing I said about auth"`), use that as a hint to find the specific instruction — search the transcript for that topic instead of just taking the most recent one.

### 4. Gather screen context

Get the visual context around the time of the spoken instruction to understand what the user was looking at:

```bash
grep '"channel":"visual_index"' /tmp/videodb_pp_events.jsonl | tail -10
```

If the instruction referenced specific files, code, or UI elements, use the screen context to resolve what they meant.

### 5. Confirm and execute

1. **State what you understood** — tell the user: "You said: [instruction]. I'll now [action]."
2. **Execute the instruction** — use all available tools (Read, Write, Edit, Bash, Task) to carry out the task. This is a real action, not a search result.
3. If the instruction is ambiguous or could be interpreted multiple ways, ask the user to clarify before acting.

### 6. Edge cases

- If no actionable instruction is found in recent transcript, tell the user: "I didn't find a recent spoken instruction. Try saying what you'd like me to do, then run this command again."
- If multiple instructions are found, act on the most recent one unless the user specified a topic.
- If the instruction requires context you don't have (e.g. references a file you can't find), ask for clarification.
