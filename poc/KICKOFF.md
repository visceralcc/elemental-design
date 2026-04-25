# Elemental Design — Web POC · New Thread Kickoff

## How This Works

The workflow has three players:

1. **You (Charlie)** — direct the design, give input, make decisions
2. **Claude (claude.ai)** — translate your intent into specific tasks, write handoff prompts, update docs
3. **Claude Code** — execute the code changes

You talk to Claude here on claude.ai. When we agree on what to build or change, Claude writes a specific task into the handoff prompt, and you paste it into Claude Code to execute. Claude Code reads the project files, makes the changes, and updates `BUILD_STATUS.md`.

---

## Starting a New Claude.ai Thread

Copy everything below the dashed line and paste it as your first message.

---

I'm iterating on the **Elemental Design Web POC** — a standalone HTML demo that proves how the Elemental Design component model works.

**Read these files using the filesystem tool:**

1. `/Users/charliedenison/dev/elemental-design/poc/CLAUDE.md` — what this POC is and the rules
2. `/Users/charliedenison/dev/elemental-design/poc/BUILD_STATUS.md` — current state and what's next
3. `/Users/charliedenison/dev/elemental-design/poc/DESIGN_INTENT.md` — what the demo should communicate

After reading, confirm the current state and ask what I want to work on.

When we decide on a task, write a handoff prompt I can paste into Claude Code. The handoff template is at `/Users/charliedenison/dev/elemental-design/handoff_claudecode/Handoff_WebPOC.md` — fill in the `[PASTE SPECIFIC TASK HERE]` section with the specific task.

**Important context:**
- I'm a designer, not a developer. Explain technical concepts in plain language.
- The demo is a single HTML file, zero dependencies, vanilla JS. No frameworks.
- All visual values must match the Elemental Design specs in `/Users/charliedenison/dev/elemental-design/specs/`.
- You have filesystem read/write access. Use it to read project files and write handoff prompts directly.
