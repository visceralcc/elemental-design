# Elemental Design — Agent Specification

**The persistent AI collaborator — input modes, behavior, authorship, and API integration**

Version 0.2 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Agent panel behavior, three input modes, proactivity model, authorship distinction, API integration, future AI provider selection. |
| 0.2 | Apr 2026 | Renamed product to Elemental Design throughout. |

---

## 1. Overview

The Agent is Elemental Design's persistent AI collaborator. It lives in the left panel for the entire session and participates in the work — answering questions, creating and modifying objects, suggesting next steps, and interpreting canvas gestures. It is never a modal, never a wizard, never something you have to open and close.

**Design principle: The Agent is a collaborator, not a command interface.** It does not require precise syntax or specific keywords. It understands intent expressed as natural language, voice, or freehand gesture. It always shows its work — every action it takes is visible in the Elements panel and on the canvas — and it always distinguishes what it has authored from what the user has authored. The user is always in control.

### Scope boundary — what this spec does NOT cover
- How parameters are displayed or edited directly by the user → `router→ Spec_ProgressiveDisclosure.md`
- Canvas interaction model for user-initiated gestures → `router→ Spec_Canvas.md`
- How Agent-created objects are documented → `router→ Spec_ComponentDocs.md`

---

## 2. The Agent Panel

The Agent panel occupies the left column persistently. It has three zones:

```
┌─────────────────────────┐
│ ✦ Agent          [mode] │  ← header: Agent label + current mode indicator
│─────────────────────────│
│                         │
│  [conversation area]    │  ← scrollable message history
│                         │
│  Agent messages         │
│  User messages          │
│  Suggestions            │
│                         │
│─────────────────────────│
│ [input bar]         [🎙] │  ← text input + voice button
└─────────────────────────┘
```

### Header
Shows the Agent label with the `✦` marker and a mode indicator when the Agent is actively doing something (Thinking, Drawing, Listening).

### Conversation area
A scrollable message history. Three message types appear here:

| Message type | Visual treatment |
|-------------|-----------------|
| User message | Right-aligned, plain background |
| Agent response | Left-aligned, subtle tinted background, `✦` before text |
| Agent suggestion | Left-aligned, dashed border, dismiss `×` button, Accept button |

### Input bar
A persistent text field at the bottom of the panel. Placeholder text reads: `let's talk...`
A microphone button to the right activates voice input.

---

## 3. Input Modes

The Agent accepts three input modes. They can be combined in a single interaction — a user can sketch a shape on the canvas and then describe it in the input bar.

### 3.1 Text
The primary input mode. The user types in the input bar. No special syntax required. Examples of valid input:

- "Make a card component with an image at the top and a title below"
- "The button needs a pressed state that darkens the background"
- "I'm a chef and I need to show off my recipes online"
- "Make this bigger"
- "Undo that"

The Agent interprets context from the current selection, the current view, and the conversation history. "Make this bigger" refers to the selected object. "That" refers to the last Agent action.

### 3.2 Voice
Activating voice input (microphone button or keyboard shortcut) opens a listening state. The input bar shows a live waveform. Speech is transcribed in real time and shown in the input bar as text. The user can review and edit before sending, or let a pause trigger submission automatically.

Voice input is transcribed locally using Apple's Speech framework where available, falling back to the Anthropic API for transcription when not.

### 3.3 Canvas Gesture
The user can draw directly on the canvas to communicate intent to the Agent. Canvas gesture input is activated by a dedicated mode in the canvas toolbar (not the mode bar — this is a canvas-layer affordance).

When active:
- The cursor becomes a freehand drawing tool
- The user sketches a rough shape, layout, or annotation on the canvas
- On lift (mouse up / finger up), the gesture is captured as an image
- The image is sent to the Agent alongside any text in the input bar
- The Agent interprets the sketch and responds — creating objects, adjusting layout, or asking a clarifying question

Canvas gestures are ephemeral — the sketch disappears once the Agent has processed it. It is not stored as a canvas object.

**What the Agent can interpret from a gesture:**
- Rough shape and size intent ("a rectangle about this big")
- Rough layout ("these three things stacked vertically")
- Annotations on existing objects ("make this part bigger")
- Flow arrows between screens ("this button goes to this screen")

**What the Agent does not interpret from gestures alone:**
- Specific colors, exact dimensions, or font choices — these require text or voice
- Precise alignment — the Agent will make a reasonable call and flag it for review

router→ Spec_Canvas.md — canvas gesture mode, activation, drawing tools

---

## 4. What the Agent Can Do

The Agent has full read and write access to the Elemental Design object model. It can:

| Action | Example |
|--------|---------|
| Create objects | "Add a navigation bar at the top" |
| Name objects | Names components meaningfully based on context |
| Set parameters | "Make the padding tighter" |
| Create states | "Add a loading state to this button" |
| Nest objects | "Put the title and subtitle inside a container" |
| Declare relationships | "This button triggers the settings screen" |
| Switch active state | "Show me the error state" |
| Rename objects | "Call this the Hero Card" |
| Delete objects | "Remove the divider" |
| Suggest next steps | Unprompted, based on what the user is building |

The Agent does not have access to:
- The file system outside the current project
- The user's clipboard
- External URLs or assets (in v1)

---

## 5. Proactivity Model

The Agent is proactive — it observes what the user is doing and offers suggestions without being asked. Suggestions are always dismissible and never blocking.

### When the Agent suggests
- After creating a first object: suggests adding content or a sibling component
- After setting a color: suggests applying it consistently across similar objects
- After creating a Widget with no Interaction: suggests adding a tap action
- After creating multiple screens: suggests declaring navigation relationships
- When a Component has no name: suggests a meaningful name based on its contents
- When the user has been idle for a moment on an incomplete object

### How suggestions appear
Suggestions appear as a distinct message type in the conversation area — dashed border, two actions: **Accept** and **×** dismiss.

```
✦  This button doesn't have a tap action yet.
   Want me to add one?
   [Accept]  [×]
```

- Accepting executes the action immediately and adds it to the conversation history
- Dismissing removes the suggestion and does not resurface the same suggestion for this session
- Suggestions do not stack — only one suggestion is shown at a time
- If the user starts typing or acts on the canvas, any pending suggestion is quietly dismissed

### Suggestion frequency
The Agent does not suggest continuously. After a suggestion is dismissed, it waits for a meaningful new context before suggesting again. It does not repeat dismissed suggestions within a session.

---

## 6. Authorship Distinction

Every value in Elemental Design is authored by either the user or the Agent. This distinction is always visible.

### The ✦ marker
`✦` marks Agent-authored content throughout the interface:

| Location | Usage |
|----------|-------|
| Agent panel header | Identifies the Agent itself |
| Agent messages in conversation | Before every Agent response |
| Elements panel | `✦` before a parameter name when its value was set by the Agent |
| Component docs | `✦` inline before Agent-authored parameter values |

### Rules
- The `✦` marker persists until the user manually changes the value
- Once a user edits an Agent-authored value, the `✦` is removed — it is now user-authored
- The Agent never removes `✦` markers from user-authored values
- `✦` is not shown on objects the Agent created if the user has subsequently edited all of their parameters — authorship is per-parameter, not per-object

router→ Spec_ComponentDocs.md — how ✦ appears in generated .md files

---

## 7. Session Context

The Agent maintains context for the current session. It knows:

- The full object model of the current project (all screens, components, states, relationships)
- The conversation history for this session
- The currently selected object
- The currently active screen and state
- Any canvas gestures from this session

Context is not persisted between sessions in v1. Each new session starts fresh. The Agent re-reads the project's object model on open.

---

## 8. API Integration

### Provider
The Anthropic API (Claude) powers the Agent in v1. Future versions will allow users to bring their own API key or select a different provider.

### Model
`claude-sonnet-4-5` (or the most capable model available at ship time). The model is not user-configurable in v1.

### System prompt
The Agent is initialized with a system prompt that includes:
- A description of Elemental Design and its object model
- The current project's full object model serialized as structured text
- The authorship rules and `✦` convention
- Instructions to respond concisely and to always show its actions in the Elements panel

The system prompt is regenerated at session start and when the project's object model changes significantly (new screen added, etc.).

### What is sent to the API
Each API call includes:
- The system prompt (with current project state)
- The full conversation history for this session
- The user's message (text, transcribed voice, or sketch image + text)
- The currently selected object's full parameter state

### Canvas gesture images
Sketch captures are sent as base64-encoded images in the user message content array, following Anthropic's vision input format. The text prompt accompanying the image instructs the model to interpret it as a layout or shape sketch.

### API key handling
The user's Anthropic API key is stored in the system Keychain. It is never written to disk in plaintext, never included in project files, and never logged.

---

## 9. Future — AI Provider Selection (Not in V1)

In a future version, users will be able to configure which AI provider powers the Agent:
- Anthropic (Claude) — default
- OpenAI (GPT)
- Google (Gemini)
- Local / on-device (Apple Intelligence)
- Custom API endpoint

The Agent's behavior spec (this document) defines the contract. Provider selection changes the model behind the contract, not the contract itself. This is an explicit architectural decision — the Agent interface must not be coupled to the Anthropic API specifically.

---

## 10. What This Spec Does Not Cover

- Canvas interaction and gesture drawing mode → `router→ Spec_Canvas.md`
- How Agent-created objects appear in the Elements panel → `router→ Spec_ProgressiveDisclosure.md`
- Component doc generation from Agent-authored objects → `router→ Spec_ComponentDocs.md`
- The mode bar and how Agent mode relates to other modes → `router→ Spec_ModeBar.md`
