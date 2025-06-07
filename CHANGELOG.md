# CHANGELOG

All notable changes to this project will be documented in this file.

---

## [1.0.0] - 2025-06-07
### Shaun's Clean Architecture Refactor & Test Strategy

#### Major Changes
- **Applied Clean Architecture**
  - Refactored the Home feature into Data, Domain, and Presentation layers
  - Structured by responsibility: Repository, UseCase, Entity, Model, Provider, ViewModel, Widget, etc.
  - Moved all business logic to ViewModel/UseCase, achieving full separation from UI

- **Added Use Case Unit Tests**
  - Core business logic (today's schedule, intake status, next intake time, etc.) is now tested at the use case level
  - Enables fast and reliable validation, independent of UI/Flutter environment
  - Removed all widget/rendering tests, keeping only pure use case tests

- **Unified Provider/Repository/Model Management**
  - Standardized import paths for models like SlotWithScheduleId (relative → package path)
  - Clarified dependencies and applied DI between Provider, UseCase, and Repository

- **UI Code Refactoring**
  - Home screen card time labels (morning, lunch, dinner) are always sorted in chronological order
  - Removed redundant code and separated widgets for clarity

#### Others
- Managed open source standard files such as .gitignore and README.md
- Merged into main branch and established version control workflow

---

> **Shaun Comment:**
> 
> "This refactoring is a strategic structural improvement to maximize maintainability and scalability. All core logic is validated at the use case level, and UI is completely separated from business logic. We will continue to document clear version histories and maintain open-source level quality."

--- 