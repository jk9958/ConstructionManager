# ConstructionManagerApp — Improvement Plan

_Last updated: 2026-05-21_

A code-level analysis of the current SwiftUI + Core Data app, benchmarked against
leading construction management products (Procore, Buildertrend, Fieldwire,
Autodesk Build / PlanGrid, Raken, Contractor Foreman), with a prioritized
roadmap.

---

## 1. Current State Summary

**Stack:** SwiftUI, Core Data, MVVM (partial), single-target iOS app (~4,200 LOC).

**Implemented features**

| Area | Status | Notes |
|---|---|---|
| Projects | ✅ CRUD | Core Data backed |
| Tasks | ✅ CRUD | Status, priority, dependencies, duration fields |
| Expenses | ⚠️ Partial | `ExpenseViewModel` serves **mock data**, not persisted |
| Documents | ⚠️ Partial | Binary blob storage, no versioning/permissions wired |
| Teams / Users | ⚠️ Partial | No user-creation UI, no auth |
| Daily Log | ⚠️ Prototype | In-memory only, no entity, not persisted |
| Dashboard | ⚠️ Orphan | `ProjectDashboardView` exists but not in tab bar |
| Theming | ✅ Good | 3 themes, design tokens (`DS`), `ThemeManager` |
| Offline queue / Sync | ⚠️ Stub | `performRemoteOperation` always returns `true`; no backend |

**Tab bar:** Home, Projects, Team, Documents, Settings.

---

## 2. Gap Analysis vs. Leading Apps

Leading construction platforms converge on a feature set this app does **not** yet cover:

| Capability | Procore / Buildertrend / Fieldwire | This app |
|---|---|---|
| Authentication & roles (RBAC) | ✅ Core | ❌ None |
| Scheduling / Gantt / critical path | ✅ Core | ❌ Removed (`GanttChartView` deleted) |
| Daily field reports (weather, manpower, photos) | ✅ Core | ⚠️ In-memory prototype |
| Photo capture & annotation | ✅ Core | ❌ None |
| RFIs (Requests for Information) | ✅ Core | ❌ None |
| Submittals | ✅ Procore/Autodesk | ❌ None |
| Punch lists / issue tracking | ✅ Core | ❌ None |
| Drawings / plan markup | ✅ Core | ❌ None |
| Budget vs. actuals, cost codes, change orders | ✅ Core | ❌ Budget is a single number |
| Time tracking / timesheets / crew | ✅ Buildertrend | ❌ None |
| Safety / inspections / checklists | ✅ Core | ❌ None |
| Cloud sync & multi-device | ✅ Core | ❌ JSON file export only |
| Push notifications & reminders | ✅ Core | ❌ None |
| Reporting & analytics | ✅ Core | ⚠️ 3 dashboard counters |
| Client / stakeholder portal | ✅ Buildertrend | ❌ None |
| Search / filter / sort | ✅ Core | ❌ None |

---

## 3. Code Quality Issues (found in review)

### 3.1 Correctness bugs
- **`ExpenseViewModel` is disconnected** — `loadExpenses()` returns hardcoded mock
  `Expense` objects; `addExpense`/`removeExpense`/`updateExpense` carry
  `// Save to CoreData if needed` comments and never persist.
- **Duplicate "Expenses" header** in `ProjectDetailView.expensesSection` — the
  `Text("Expenses")` label is rendered twice.
- **`DailyLogView`** has no entity and no persistence — data is lost on relaunch.
- **Nested `NavigationStack`** — `TaskListView`, `DocumentListView`, `HomeView`
  each declare their own `NavigationStack` while also being pushed/embedded,
  risking broken navigation and double bars.
- **`SyncManager.importFromURL`** creates tasks with a throwaway `UUID()` as
  `projectId` when none exists, orphaning them; also re-imports duplicate data
  with no de-duplication.
- **`ProjectDashboardView`** is fully built but never reachable (not in `MainTabView`).

### 3.2 Architecture
- **`CoreDataManager` is a 778-line god object** — all CRUD, all entity↔model
  mapping, and offline-queue coupling in one singleton.
- **Repeated mapping logic** — entity→model conversion for Task (×3), Expense
  (×2), Project (×3) is copy-pasted. Extract `init(entity:)` / mappers.
- **All writes run on `viewContext`** (main thread). No background context;
  large imports/exports block the UI.
- **No single source of truth** — views hold local `@State var tasks/expenses`
  and re-fetch on `.onAppear`; the same task edited in two screens goes stale.
- **ViewModels used inconsistently** — some views talk to `CoreDataManager`
  directly (`ProjectDetailView`, `TaskListView`), bypassing the VM layer.

### 3.3 Data modeling
- **Stringly-typed fields** — `Project.status`, `Project.priority`,
  `Expense.status`, `Expense.category` are `String`/`String?`. `Task` already
  uses enums; apply the same everywhere.
- **`User.preferences` is `NSObject?`** and excluded from `Codable` — replace
  with the existing `Preferences` struct.
- **`Project` over-fetches** — `fetchProjects` eagerly loads documents (binary
  blobs), expenses, tasks, and team graph for every list row.
- **Dead schema** — `DocumentActivityEntity` and `DocumentPermissionEntity`
  exist in the model but have no UI or logic.
- **No model versioning / migration strategy** — schema changes will fail; a
  Core Data load error triggers `fatalError` in DEBUG.

### 3.4 Robustness & polish
- **`try!`** in `OfflineOperationQueue` init (documents directory) — crash risk.
- **Errors swallowed** — `print()` used throughout instead of `os.Logger`;
  failures rarely surface to the user.
- **No input validation** — empty names, negative budgets, and end-before-start
  dates are accepted by the Add/Edit forms.
- **Accessibility is inconsistent** — some labels/hints present, most missing.
- **Sparse tests** — only `CoreDataManager`, `ExpenseViewModel`, and
  `ProjectListViewModel` have tests; the `ExpenseViewModel` test exercises mock data.

---

## 4. Improvement Roadmap

### Phase 1 — Stabilize the foundation (1–2 weeks)
1. Wire `ExpenseViewModel` to Core Data; delete mock data; add
   `updateExpense`/`deleteExpense` persistence.
2. Fix the duplicate "Expenses" header in `ProjectDetailView`.
3. Remove nested `NavigationStack`s; adopt one stack per tab.
4. Convert `Project.status`/`priority` and `Expense.status`/`category` to enums.
5. Replace `try!` and `fatalError` with graceful handling; add `os.Logger`.
6. Add input validation to all Add/Edit forms (required fields, budget ≥ 0,
   end date ≥ start date).
7. Either surface `ProjectDashboardView` in the tab bar or remove it.

### Phase 2 — Architecture cleanup (1–2 weeks)
1. Split `CoreDataManager` into per-domain repositories
   (`ProjectRepository`, `TaskRepository`, …) behind protocols.
2. Add a background `NSManagedObjectContext` for writes; keep `viewContext`
   read-only for the UI.
3. Extract entity↔model mappers; remove duplicated conversion code.
4. Make `@FetchRequest` or a shared observable store the single source of
   truth; remove per-view `@State` data arrays.
5. Configure explicit Core Data model versioning + lightweight migration.
6. Expand unit tests (repositories, view models) and add UI smoke tests.

### Phase 3 — Close core feature gaps (3–5 weeks)
1. **Authentication & RBAC** — login, current-user context, role-gated actions;
   activate `DocumentPermissionEntity`.
2. **Daily Field Reports** — promote `DailyLog` to a Core Data entity with
   date, weather, manpower count, notes, and photos.
3. **Photo capture** — camera/library integration, thumbnails, geotagging;
   attach to tasks, daily logs, and documents.
4. **Scheduling** — restore a Gantt/timeline view using existing
   `Task.dependencies` + `durationInDays`; compute the critical path.
5. **Budget vs. actuals** — cost codes, expense rollups per project, a
   spent/remaining indicator, and change orders.
6. **Search, filter, and sort** across projects and tasks.
7. **Push notifications** — local reminders for task deadlines and overdue items.

### Phase 4 — Differentiating features (ongoing)
1. **Cloud sync** — adopt CloudKit (`NSPersistentCloudKitContainer`, the
   entitlements file already exists) or a real backend; make
   `OfflineOperationQueue` perform actual network calls.
2. **Punch lists / issue tracking** with photo evidence and assignment.
3. **RFIs & submittals** workflows.
4. **Drawings / plan markup** (PDF rendering + annotation).
5. **Safety inspections & checklists.**
6. **Time tracking / timesheets** for crews.
7. **Reporting & analytics** — exportable PDF reports, richer dashboard.
8. **Client portal / sharing** for stakeholders.

---

## 5. Quick Wins (do first)

- [x] Connect `ExpenseViewModel` to `CoreDataManager` (remove mock data). _Done 2026-05-21 — VM now reads/writes Core Data; `ExpenseListView` rebuilt on the VM._
- [x] Remove duplicate "Expenses" `Text` in `ProjectDetailView`. _Done 2026-05-21._
- [ ] Persist `DailyLogView` data (new `DailyLogEntity`).
- [x] Add `ProjectDashboardView` to `MainTabView`. _Done 2026-05-21 — added as the first "Dashboard" tab._
- [x] Replace `print()` with `os.Logger`. _Done 2026-05-21 — added `AppLogger.swift`; converted all 20 call sites in `CoreDataManager` and `OfflineOperationQueue`._
- [x] Add form validation to all Add/Edit forms. _Done 2026-05-21 — `isValid` checks (trimmed required fields, budget ≥ 0, amount > 0, end ≥ start) gate every Save button._
- [x] Replace `try!` in `OfflineOperationQueue` with safe error handling. _Done 2026-05-21 — falls back to the temporary directory._
- [ ] Convert `Project.status` / `priority` to enums.

> Status: 6 of 8 quick wins complete; project builds clean (`xcodebuild` BUILD SUCCEEDED, iOS 18.4).
> Remaining: `DailyLogEntity` persistence and the `Project` enum conversion both
> touch the Core Data model, so they are tracked under Phase 1 rather than as
> drop-in quick wins.

---

## 6. Suggested Priority Order

```
Phase 1 (Stabilize)  ──▶  Phase 2 (Architecture)  ──▶  Phase 3 (Core gaps)  ──▶  Phase 4 (Differentiators)
   bugs & validation       repositories & contexts      auth, photos, schedule    cloud sync, RFIs, markup
```

Stabilize and de-risk the foundation before adding features — Phases 1–2 make
Phases 3–4 dramatically cheaper to build and test.
