---
name: feature-development
description: End-to-end feature scaffolding for iOS apps including UI creation from Figma or screenshots, business logic, API layer integration, navigation, data binding, error handling, reusable components, previews, and tests.
---

# Feature Development

This skill scaffolds complete iOS feature slices from design references and functional requirements.

## Core Capabilities

When invoked, this skill should be capable of:
- Creating UI layouts/screens from:
  - Figma references
	- Figma JSON exports (nodes, styles, component metadata)
  - screenshot references
  - textual UI requirements
- Building business logic and button actions.
- Creating and wiring API layer contracts and implementations.
- Creating ViewModels with dependency injection.
- Implementing clear data binding structures.
- Handling loading, error, empty, and success states.
- Creating reusable UI components for complex screens.
- Creating data-loading methods and typed models for binding.
- Generating SwiftUI preview coverage for key states and variants.
- Generating realistic mock data and mock API/repository implementations when API details are not provided.

## Figma JSON Support

This skill must support direct scaffolding from Figma JSON input.

Accepted Figma JSON inputs:
- file JSON export
- page/frame subtree JSON
- component set JSON
- design token/style JSON (colors, typography, spacing, radius, effects)

When Figma JSON is provided, the skill should:
- parse node hierarchy into reusable SwiftUI view structure
- map Figma auto-layout rules to SwiftUI layout primitives
- map text styles to typography tokens
- map color/fill/stroke/effect styles to semantic design tokens
- infer reusable components from repeated nodes and component instances
- preserve interaction hints (tap targets, disabled states, variant states)
- generate deterministic names for screens, sections, and components

Figma JSON mapping expectations:
- map layout direction, spacing, alignment, and constraints predictably
- avoid raw hardcoded values when a style token is available
- fall back safely when token mapping is missing and mark with TODO
- keep output compatible with enterprise design system rules
- do not generate networking/domain/data layers unless requested by mode/config

## Design System Rules (Enterprise-First)

All UI must follow the centralized enterprise design system in the internal reference folder.

Required:
- Use approved enterprise typography tokens.
- Use approved foundation tokens (colors, spacing, radius, elevation).
- Use approved enterprise controls and components.
- Use semantic tokens only, not hardcoded style values.

Avoid:
- Direct use of raw SwiftUI/UIKit controls when equivalent enterprise components exist.
- Custom ad-hoc visual styles outside approved tokens.

Exception:
- If a needed control does not exist in enterprise components, use native controls only as a fallback and clearly mark it with a TODO for design system replacement.

## Navigation Standards

Use:
- Coordinator pattern
- centralized navigation
- deeplink support

Avoid:
- navigation logic inside views

Implementation expectations:
- Views emit intents/callbacks only.
- Coordinators or navigation handlers own route decisions.
- Destination types should be strongly typed.

## State and Data Binding Standards

Use a structured UI state model per screen.

UiState variants:
- Loading
- Success(data)
- Error(message)
- Empty

Data binding expectations:
- Smart screen observes ViewModel state.
- Dumb content receives UiState and callbacks as inputs.
- Use explicit input models and action closures.
- Keep state transitions predictable and testable.

## Architecture Blueprint

For each feature, scaffold all layers together:

1. UiState
2. Smart Screen
3. Dumb Content
4. ViewModel
5. Use Case
6. Repository interface
7. Navigation destination
8. Analytics hooks
9. Tests

## Scaffolding Modes and Configuration

This skill supports two generation modes so simple component work does not require full feature scaffolding.

Mode 1: `full-feature` (default)
- Generates the full vertical slice across UI, ViewModel, domain, data, navigation, analytics, and tests.

Mode 2: `layout-only-component`
- Generates only a presentational subview and the minimum wiring required for:
	- data binding
	- ViewModel injection
	- action handling callbacks
- Skips API/repository/use-case/navigation/analytics/test scaffolding unless explicitly requested.

Required configuration keys:
- `mode`: `full-feature` or `layout-only-component`
- `featureName`: feature or module name
- `componentName`: required when `mode = layout-only-component`
- `designReference`: figma/screenshot/text requirements
- `include`: optional explicit include list for files to generate

Optional configuration keys:
- `createViewModelProtocol`: default `true` for `layout-only-component`
- `createPreview`: default `true`
- `createFixtures`: default `true`
- `actionStyle`: `closures` (default) or `enum-intents`
- `bindableStateType`: `struct` (default) or `enum`

Behavior rules for `layout-only-component`:
- Always keep the subview presentational and stateless where possible.
- Inject ViewModel via protocol abstraction or closure-driven adapter.
- Expose actions as typed callbacks (or typed intent enum if configured).
- Keep file output minimal and deterministic.
- Do not auto-generate repository/API layers unless `include` requests them.

### Layer Responsibilities

UiState:
- enum representing Loading, Success, Error, Empty

Smart Screen (`${FEATURE_NAME}Screen`):
- observes ViewModel state
- handles screen lifecycle triggers (initial load, retry)
- passes actions to ViewModel
- delegates layout to content component
- delegates navigation through coordinator callbacks

Dumb Content (`${FEATURE_NAME}Content`):
- pure presentational layer
- accepts UiState and callbacks
- renders all four states
- contains no navigation or business logic
- previewable in isolation

ViewModel (`${FEATURE_NAME}ViewModel`):
- depends on use case abstractions
- maps use case output to UiState
- exposes bindable state and intents
- handles button actions and side effects
- emits analytics for view/action/error events

Use Case (`Get${FEATURE_NAME}DataUseCase`):
- single responsibility operation
- returns typed Result<T>
- depends only on repository protocol

Repository (`${FEATURE_NAME}Repository`):
- domain-facing interface
- typed request/response methods
- typed error handling

API Layer:
- request/response DTOs
- endpoint/service definitions
- mapping to domain models
- robust error mapping

Navigation (`${FEATURE_NAME}Destination`):
- typed destination definitions
- deep link parsing support
- external navigation callbacks

## API and Data Loading Standards

Data loading methods should:
- be explicit and purpose-driven (for example: loadInitialData, refreshData, loadNextPage)
- avoid ambiguous generic names
- expose loading lifecycle state updates
- support retry flows

API integration should:
- keep transport concerns outside UI
- map DTOs to domain models before exposing to ViewModel
- convert transport/decoding/business failures into typed domain errors

## Mock Data Fallback (When API Info Is Missing)

If request/response JSON, endpoint docs, or Swagger/OpenAPI are unavailable, this skill must still scaffold a working feature by using mock-first contracts.

Required behavior:
- Infer a minimal typed domain model from UI fields and interaction requirements.
- Generate mock DTOs and domain fixtures with realistic values.
- Create a mock service and mock repository implementation.
- Ensure ViewModel, Screen, and Content are fully wired to mock data.
- Keep all preview and test paths functional without live networking.

Mock data standards:
- Provide deterministic seed data for stable previews and snapshot tests.
- Include at least three fixture variants:
	- happy path dataset
	- empty dataset
	- error scenario payload
- Include edge-case values for long text, missing optional values, and zero/large numeric values.

Contract transition rule:
- Structure mock contracts so they can be replaced with real API contracts later with minimal refactoring.
- Keep mapping boundaries explicit (DTO to domain) even in mock-first mode.

## Reusable View Creation for Complex Screens

Required approach:
- Break large layouts into reusable subcomponents.
- Keep reusable components stateless where possible.
- Provide dedicated input models for complex reusable components.
- Co-locate reusable components in a components folder per feature.

Examples of reusable units:
- headers
- list rows/cards
- section blocks
- info banners
- action bars/footers

## Preview Requirements

Each screen/content component should include previews for:
- loading state
- success state with representative data
- empty state
- error state
- dark mode
- variant states (small/large content, edge cases)

## Testing Requirements

Required:
- unit tests
- snapshot tests
- accessibility tests

Cover:
- dark mode
- variants
- loading/error states

Minimum test targets:
- ViewModel state transitions
- Use case success/error behavior
- Screen/content rendering across UiState variants
- Navigation callback wiring

## Scaffold a Complete Feature for: $FEATURE_NAME

Generate all of the following layers, following this project's feature-development conventions:

1. UiState
	- enum with Loading, Success(data), Error(message), Empty variants.

2. Smart Screen (`${FEATURE_NAME}Screen`)
	- observes ViewModel state
	- delegates layout to content component
	- handles navigation callbacks

3. Dumb Content (`${FEATURE_NAME}Content`)
	- presentational only
	- accepts UiState and callbacks
	- renders Loading, Error, Empty, Success
	- previewable

4. ViewModel (`${FEATURE_NAME}ViewModel`)
	- calls use case, not repository directly
	- maps results to UiState
	- fires analytics on screen view, action, and error

5. Use Case (`Get${FEATURE_NAME}DataUseCase`)
	- single responsibility
	- returns Result<T>
	- depends on repository interface only

6. Repository Interface (`${FEATURE_NAME}Repository`)
	- domain-layer protocol with typed error handling

7. Navigation (`${FEATURE_NAME}Destination`)
	- typed route/destination
	- accepts external navigation callbacks

8. API Layer
	- request and response DTOs
	- service/client contract
	- mapper to domain
	- mock DTO fixtures and mock service/repository fallback when API info is unavailable

9. Tests
	- ViewModel tests
	- use case tests
	- snapshot and accessibility coverage
	- mock-data driven tests for Loading, Success, Empty, and Error paths

## Feature Structure

Every feature is a vertical slice. Always scaffold all layers together:

```
feature/<name>/
├── ui/
│   ├── <Name>Screen.swift
│   ├── <Name>Content.swift
│   └── components/
├── viewmodel/
│   └── <Name>ViewModel.swift
├── navigation/
│   └── <Name>Navigation.swift
├── domain/usecases/
│   └── Get<Name>DataUseCase.swift
├── domain/repository/
│   └── <Name>Repository.swift
├── data/
│   ├── <Name>RepositoryImpl.swift
│   ├── dto/
│   └── service/
├── analytics/
│   └── <Name>Analytics.swift
└── tests/
	 ├── <Name>ViewModelTests.swift
	 ├── Get<Name>DataUseCaseTests.swift
	 └── <Name>SnapshotTests.swift
```

For `layout-only-component`, generate only the minimum files unless configured otherwise:

```
feature/<name>/ui/components/
├── <ComponentName>View.swift
├── <ComponentName>ViewModelProtocol.swift
├── <ComponentName>ViewData.swift
└── <ComponentName>Fixtures.swift
```

Notes:
- `ViewModelProtocol` defines bindable state exposure and actions for injection.
- `ViewData` is the explicit input model used by the dumb component.
- `Fixtures` provides deterministic preview/sample values.

## How to Use This Skill

Use this skill by providing:
- scaffolding mode (`full-feature` or `layout-only-component`)
- feature name
- design reference (Figma JSON, Figma link details, or screenshot description)
- required interactions (button actions and flows)
- API input (JSON request/response or endpoint contract)
- navigation expectations
- output scope (new files only or refactor existing files)

If using Figma JSON, also provide when possible:
- target frame or node IDs
- preferred naming convention for generated components
- token mapping hints (if design token names differ from enterprise tokens)
- variant/state rules to preserve (for example: default, pressed, disabled)

If API details are not available, provide:
- expected screen fields and sample values
- state behavior expectations (loading, empty, error, success)
- whether to generate mock-only mode for first iteration

Prompt template:

"Use feature-development skill.
Mode: <full-feature|layout-only-component>.
Create feature: <FEATURE_NAME>.
Design reference: <FIGMA_JSON_OR_LINK_OR_SCREENSHOT_DETAILS>.
Interactions: <BUTTON_ACTIONS_AND_FLOWS>.
API: <REQUEST_RESPONSE_OR_ENDPOINT_DETAILS>.
Use enterprise design system components only.
Add coordinator-based navigation, ViewModel injection, data binding, error handling, reusable components, previews, and tests."

Figma JSON template:

"Use feature-development skill.
Mode: <full-feature|layout-only-component>.
Create feature: <FEATURE_NAME>.
Design input type: figma-json.
Figma JSON: <PASTE_FIGMA_JSON>.
Target frame/node IDs: <OPTIONAL_NODE_IDS>.
Interactions: <BUTTON_ACTIONS_AND_FLOWS>.
Generate SwiftUI structure from JSON hierarchy and map styles to enterprise tokens.
Include data binding, ViewModel injection, and action handling.
Only generate layers requested by mode/config."

Layout-only template (simple dumb component):

"Use feature-development skill.
Mode: layout-only-component.
Create feature: <FEATURE_NAME>.
Create component: <COMPONENT_NAME>.
Design reference: <FIGMA_JSON_OR_SCREENSHOT_DETAILS>.
Interactions: <BUTTON_ACTIONS_AND_FLOWS>.
Generate only layout + data binding + ViewModel injection + action handling.
Do not generate API/repository/usecase/navigation/analytics/tests.
Use enterprise design system components only."

Mock-first template (no API contract yet):

"Use feature-development skill.
Create feature: <FEATURE_NAME>.
Design reference: <FIGMA_OR_SCREENSHOT_DETAILS>.
No API contract is available yet.
Generate typed mock data, mock service, mock repository, and fixture variants for success, empty, and error states.
Wire complete data binding and previews using mock data.
Use enterprise design system components only."

Expected output from this skill:
- generated file list by layer
- key architecture decisions
- mapping and data flow summary
- state handling and navigation summary
- testing and preview coverage summary
- mock data model and fixture summary (when API info is missing)

