# Project Memory System

You have no memory between sessions. The folder `docs/skills/` and the file
`docs/PROJECT_MAP.md` are your memory. Follow these rules in EVERY session.

## 1. Before you start any task
1. Read `docs/skills/INDEX.md`, then `docs/PROJECT_MAP.md`.
2. Open every skill file related to the task and read it fully.
3. Use the map to find where things live. Do not scan the whole project.
4. Before creating a new file, check the map: a similar file may already exist.
5. Do not guess how this project does something. Check the skills first.
6. If no skill covers it, say so, then look at the existing code before writing new code.

## 2. While you work
- Follow the patterns and rules written in the skills.
- If the code and a skill disagree, tell me. Do not silently pick one.

## 3. After you finish (or when you learn something)
Save a skill when any of these happens:
- I correct you or tell you "don't do it like that".
- You fix a bug that took more than one attempt.
- I tell you "remember this".

### Skills are by TOPIC, never by FEATURE
Allowed topics (only these files, unless I approve a new one):
- `flutter-general.md`: widgets, state, naming, UI rules
- `supabase.md`: queries, RPC, RLS, migrations, parsing rows
- `riverpod.md`: providers, controllers, state classes
- `dart-style.md`: language rules, extensions, null safety
- `workflow.md`: how I like you to work (output format, how to answer)

FORBIDDEN file names: anything named after a screen or feature
(`home-feature.md`, `cart-screen.md`, `login-fix.md`).
If you learned something while working on the Home screen, ask:
"What is the GENERAL rule?" and save only that rule in the topic file.

How to save:
1. Pick the topic file. If none fits, ask me before creating one.
2. Add the rule as ONE line under the right section. Do not duplicate: if a similar rule exists, edit it.
3. Add a short example only if the rule is not obvious.
4. Tell me in one line what you saved and where.

## 4. Topic file template
Each topic file in `docs/skills/` looks like this:

# <Topic name>

## Rules
- One short rule per line.

## Mistakes to avoid
- What went wrong before, and the fix.

Keep each file under 80 lines. Split by sub-topic only if I approve.

## 5. Project Map
`docs/PROJECT_MAP.md` is the map of the whole app. It is the ONLY structure file.
Do NOT create `architecture.md` or any other structure file.

Update `PROJECT_MAP.md` in the SAME task when you:
- add, delete, rename, or move a file or folder
- add a new shared widget, model, provider, or service
- change what a file is responsible for

Rules:
- One line per file: `name.dart: what it does` (max 10 words).
- Keep the tree order the same as the real folders.
- Do not list generated files (`*.g.dart`, `*.freezed.dart`).
- If a file in the map no longer exists, remove its line.
- Never finish a task that changed the structure without updating the map.

## 6. Quality rules
- One rule = one line. Short and direct.
- Never save feature-specific details (screen names, one-time bug fixes).
- Never save guesses. Only what is confirmed by working code or by me.
- Never delete a rule unless I ask.
- Never store secrets (keys, tokens, passwords).