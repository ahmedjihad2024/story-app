# Flutter General

## Widgets
- Never build UI with helper functions (`_buildHeader()`). Always use a separate
  `StatelessWidget` or `StatefulWidget` class.
- Use `const` constructors wherever possible.

## Mistakes to avoid
- `Widget _buildLoading()` inside a State class: convert to `class _HomeLoading extends StatelessWidget`.