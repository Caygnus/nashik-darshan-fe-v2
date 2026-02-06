# Reply to CodeRabbit – Addressed review feedback

Hi @coderabbitai — thanks for the review. Here’s what was changed based on your feedback and a pass over the touched files:

## Summary of changes

### 1. **Router / core**
- **`lib/core/router/app_router.dart`**  
  - Removed the unused `locationStream` getter on `GoRouterExtension` (it was polling every second and not used anywhere). This avoids dead code and unnecessary APIs.

### 2. **Navigation consistency**
- **Events flow**  
  Replaced `Navigator.of(context).maybePop()` with `context.pop()` from `go_router` in:
  - `lib/features/events/presentation/pages/events_page.dart`
  - `lib/features/events/presentation/pages/saved_events_page.dart` (and added `go_router` import)
  - `lib/features/events/presentation/pages/upcoming_events_page.dart`  
  Back navigation in the events tab now uses the same router as the rest of the app.

### 3. **Places mock data source**
- **`lib/features/places/data/datasources/places_mock_data_source.dart`**  
  - **`getPlaceById`** and **`getCategoryById`** no longer use `try/catch` with `firstWhere`.  
  - They now use a `where(...).toList()` + `isEmpty` check and return `null` when there’s no match, which:
    - Aligns with `avoid_catches_without_on_clauses` and `avoid_catching_errors` from `analysis_options.yaml`
    - Keeps the same public API and behavior.

### 4. **Itinerary – Customize action**
- **`lib/features/itinerary/presentation/pages/itinerary_page.dart`**  
  - The “Customize” action card now navigates to the Customize Trip flow via `context.pushNamed(AppRouteNames.customizeTrip)` instead of an empty `onTap`/TODO.

---

If any specific comment pointed to a different file or line, paste it here and we can align the reply or add a follow-up fix.
