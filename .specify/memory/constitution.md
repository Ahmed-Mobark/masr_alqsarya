<!--
Sync Impact Report
- Version change: 0.2.0 → 0.3.0
- Modified principles:
  - II. Clean Architecture (Feature-First) with a Stable Core → II. Clean Architecture + SOLID (Production-Grade)
  - V. State Management: Cubit-First (flutter_bloc) → V. State Management: Cubit-First (Production Discipline)
  - VI. Quality Gates: Analyzer Clean, Predictable Failures → IX. Quality Gates: Analyzer Clean, Predictable Failures
- Added sections: none (filled existing template sections)
- Removed sections: none
- Templates requiring updates:
  - .specify/templates/plan-template.md ✅ (no changes required)
  - .specify/templates/spec-template.md ✅ (no changes required)
  - .specify/templates/tasks-template.md ✅ (no changes required)
- Deferred TODOs:
  - TODO(RATIFICATION_DATE): original adoption date unknown
-->
# Masr Al-Qsariya Constitution
<!-- Mobile app engineering & UX constitution -->

## Core Principles

### I. UX-First, Arabic/RTL-Ready (Non‑negotiable)
- The UI MUST stay readable, tappable, and consistent across screen sizes (use `flutter_screenutil` and the shared `AppTextStyles`/`AppColors`).
- Interactive elements MUST meet mobile UX expectations (touch targets, spacing, feedback, loading/error/empty states).
- Any user-facing text MUST be localizable (ARB keys) and work in RTL; no layout that breaks in RTL.
- Flows MUST avoid dead ends: every screen has a clear next step and a safe back/exit path.

### II. Clean Architecture + SOLID (Production-Grade)
- The app MUST follow Clean Architecture boundaries: **presentation** → **domain** → **data** (dependencies point inward).
- SOLID principles MUST be applied strictly:
  - Single Responsibility: separate UI/state/use-cases/repos/data sources clearly.
  - Open/Closed + Dependency Inversion: depend on abstractions in domain; implementations live in data/core.
  - Interface Segregation: small focused interfaces; avoid “god” services.
- Domain MUST be framework-agnostic (no Flutter UI types; keep pure Dart where possible).
- Feature structure MUST be feature-based and layer-based within each feature (presentation/domain/data).
- `lib/core/` is the shared foundation: theme, navigation service, network helpers, storage, common widgets, and utilities.
- Features MUST not duplicate core primitives (colors, typography, navigation service, shared widgets).
- Core SHOULD provide shared patterns (base failures, network wrappers, pagination, validation).
- Public APIs in core MUST be backwards compatible (or changed with a clear migration plan).

### III. Navigation via `AppNavigator` (Single Source of Truth)
- Screens MUST navigate through `sl<AppNavigator>()` (`push`, `pushReplacement`, `pushAndRemoveUntil`).
- Direct `Navigator.of(context)` usage in feature screens is NOT allowed except for local `pop()` (or closing dialogs/bottom sheets).
- Routes MUST pass data via constructor parameters (preferred) rather than dynamic maps.
- Any “reset” transition (login/logout/role selection) MUST use `pushAndRemoveUntil` to prevent back-navigation into protected screens.

### IV. Consistent Styling: No Ad-hoc UI
- Colors MUST come from `AppColors` (or theme) and typography MUST come from `AppTextStyles`/`TextStyles`.
- New reusable UI pieces MUST become core widgets when used in 2+ places.
- Avoid one-off paddings/sizes scattered across features; prefer shared dimensions/utilities when patterns repeat.

### V. State Management: Cubit-First (Production Discipline)
- Use **Cubit** by default for feature state; use full Bloc only when event-driven complexity is justified.
- Prefer code generation only when it measurably improves correctness/maintainability (e.g., immutable states); avoid overengineering.
- UI widgets MUST remain dumb: business rules belong in domain/use-cases; state belongs in Cubits.
- Cubits MUST expose minimal, immutable state.
- Cubits MUST NOT perform navigation; they emit states that UI reacts to.
- State updates MUST be efficient:
  - avoid rebuild storms,
  - split widgets,
  - use `BlocSelector`/`context.select` style patterns where appropriate.

### VI. Performance-First UI (60fps)
- Minimize widget rebuilds (small widgets, selectors, avoid rebuilding entire screens for small changes).
- Use `const` constructors where possible.
- Avoid heavy computations on the UI thread; precompute, cache, or move to background.
- Use isolates when needed for CPU-heavy work (parsing, large transforms).

### VII. Memory & Lifecycle Safety
- Avoid memory leaks: dispose controllers, focus nodes, streams, and listeners.
- Do not retain unnecessary references to `BuildContext` or long-lived objects in widgets.
- Prefer scoped lifetimes: feature-level objects get disposed when feature is removed.

### VIII. Error Handling: Centralized, Typed, and User-Friendly
- Error handling MUST be centralized (shared failure/exceptions mapping in core/data layer).
- Domain use-cases MUST return a typed result:
  - Use `Either<Failure, T>` (dartz) or an equivalent `Result<T>` pattern consistently across the app.
- UI MUST show UX-appropriate errors (actionable, localized, non-technical).

### IX. Quality Gates: Analyzer Clean, Predictable Failures
- `flutter analyze` MUST be clean before merging.
- No “just to make it compile” hacks that leak into product code (dead code, unused imports, placeholder routes).
- Errors MUST be handled intentionally (network failures, empty states, validation) with UX-friendly messaging.

## Technical Constraints & Standards
- **Flutter/Dart**: Stable Flutter channel; Dart 3.9+.
- **State management**: Use Cubit-first via `flutter_bloc`; keep UI state local only for ephemeral UI concerns.
- **DI**: Use `get_it` via `sl` (`lib/core/injection/injection_container.dart`).
- **Localization**: Use ARB files under `assets/translation/` and generated localization; no hard-coded user-facing strings in final UI.
- **Performance**: 60fps target; avoid heavy rebuilds; use const constructors; move heavy work off UI thread.
- **SOLID**: New code MUST follow SOLID. If a shortcut is taken, it MUST be intentional, documented in the PR/spec, and localized (not spread).
- **DRY**: Avoid duplication; extract shared logic into domain/core utilities where it belongs.
- **Scalability**: Prefer composable, testable components (small widgets, small cubits, clear domain use-cases).
- **Testing**: Business logic MUST have unit tests (domain use-cases, mappers, validators).

## Development Workflow & Review
- Changes MUST be incremental and keep the app runnable.
- Prefer small, focused refactors over broad sweeping changes without safety checks.
- When adding new core APIs, update all call sites in the same change.
- UI changes MUST be checked in both light/dark themes and at least one small + one large screen size.

## Governance
This constitution supersedes local conventions and one-off decisions.

- Amendments MUST include:
  - clear intent (“why”),
  - migration notes if behavior changes,
  - and a version bump (semantic versioning below).
- Versioning policy:
  - **MAJOR**: breaking governance changes (principle removal/redefinition).
  - **MINOR**: new principle or materially expanded constraints.
  - **PATCH**: clarifications and non-semantic refinements.
- Reviews MUST check:
  - analyzer status,
  - navigation consistency (`AppNavigator`),
  - Clean Architecture boundaries (presentation/domain/data),
  - Cubit usage and state hygiene,
  - performance impact (rebuilds, scroll/jank, background work),
  - memory/lifecycle safety (dispose, listeners),
  - error handling consistency (Either/Result),
  - test coverage for new domain logic,
  - localization readiness,
  - and UI consistency with `AppColors`/`AppTextStyles`.

**Version**: 0.3.0 | **Ratified**: TODO(RATIFICATION_DATE): unknown | **Last Amended**: 2026-04-16
