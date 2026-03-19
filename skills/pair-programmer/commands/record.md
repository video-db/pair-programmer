---
description: Start screen/audio recording
tools: Bash, Read
---

Start the VideoDB Pair Programmer recorder.

## Flow

### 1. Check if already running

1. Read the PID file at `/tmp/videodb_pp_pid`
2. If the file exists, check if the process with that PID is still running
3. If running → Tell the user the recorder is already active. They can stop it from the tray icon (🔴 PP in menu bar)
4. If not running → Continue to step 2

### 2. Verify VideoDB connection

Run the verification script from the skill directory, passing the user's project root via `--cwd`:

```bash
node verify-connection.js --cwd=<PROJECT_ROOT>
```

> `<PROJECT_ROOT>` is the absolute path to the user's project directory. This is NOT the skill directory — resolve it before running the command.

- If successful (exit code 0) → Continue to step 3
- If `VIDEO_DB_API_KEY not set` (exit code 1) → Tell user to either `export VIDEO_DB_API_KEY=your_key` or add it to a `.env` file in their project root
- If connection error (exit code 2) → Check if the API key is valid

### 3. Start the recorder

Run the Electron app as a background process from the skill directory:

```bash
nohup npx electron recorder-app.js --cwd=<PROJECT_ROOT> > /tmp/videodb_pp_logs 2>&1 &
```

> `<PROJECT_ROOT>` is the absolute path to the user's project directory. This is NOT the skill directory — resolve it before running the command.

### 4. Confirm

Tell the user:
- The recorder is starting
- A picker UI will appear to select screen/audio sources
- After selection, recording will start automatically
- Events are logged to `/tmp/videodb_pp_events.jsonl`
- Stop recording from the tray icon (🔴 PP → Stop Recording) or the overlay widget
