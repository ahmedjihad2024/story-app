# Git

## Commit message format
- Use Conventional Commits: `type(scope): description`
- Write in English, imperative mood ("add", not "added" or "adds").
- Subject max 72 characters, lowercase, no period at the end.
- `scope` is optional: the area of the app (`home`, `cart`, `auth`, `supabase`, `core`).
- Add a body only when the "why" is not obvious. Leave a blank line after the subject.

## Types
- `feat`: new feature or behavior
- `fix`: bug fix
- `refactor`: code change with no behavior change
- `style`: formatting only (no logic change)
- `perf`: performance improvement
- `docs`: documentation only (skills, PROJECT_MAP, README)
- `test`: add or change tests
- `chore`: dependencies, config, build, migrations housekeeping

## Examples
- `feat(home): add popular products section`
- `fix(supabase): parse empty offers list in get_home_data`
- `refactor(home): convert build helper functions to widgets`
- `chore(db): add pg_trgm index on products name`
- `docs: update PROJECT_MAP after adding network logger`

## Before committing
- Run `git status` and `git diff --staged`. Write the message from the ACTUAL diff, not from memory.
- One logical change per commit. If the diff mixes two things, split it into two commits.
- Never commit secrets (`.env`, API keys, tokens, service-role keys).
- Never use vague messages: `update`, `fix`, `changes`, `wip`, `final`.

## Rules for you (the agent)
- Never run `git push`, `git push --force`, `git reset --hard`, or delete branches unless I ask.
- Never amend or rewrite commits that were already pushed.
- If I ask for a commit message only, give me the message and do not run the commit.

## Branch names
- `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>` (lowercase, hyphens).

## Mistakes to avoid
- Message says "fix bug" without saying which bug: name the thing that was fixed.
- One giant commit with UI, database, and refactor together: split it.