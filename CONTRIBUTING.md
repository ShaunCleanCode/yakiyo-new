# Contributing to Yakiyo

Thank you for considering contributing to Yakiyo! To keep our codebase clean, maintainable, and collaborative, please follow these guidelines.

---

## 🚦 Git Commit & Branch Conventions

- **Commit Message Format**
  ```
  <type>: <short summary>
  
  - <detailed change 1>
  - <detailed change 2>
  ...
  ```
  **Types:** feat, fix, refactor, test, docs, chore, style

  **Example:**
  ```
  feat: Add intake log screen with calendar view

  - Implement calendar UI with month navigation
  - Add pill intake status indicators
  - Add detailed intake information dialog
  - Add widget tests for calendar and dialog
  ```

- **Branch Naming**
  - `feature/<feature-name>`
  - `fix/<bug-description>`
  - `hotfix/<urgent-fix>`
  - `chore/<misc-task>`

- **Pull Request**
  - PR title: `[Type] <Short Description>`
  - PR body: What/Why/How/Testing/Related Issues

---

## 🧑‍💻 Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.
- Use 2-space indentation.
- Use meaningful variable and function names.
- Add doc comments for public classes and methods.

---

## 🧪 Testing

- All new features and bug fixes must include relevant unit/widget tests.
- Run all tests before submitting a PR:
  ```bash
  flutter test
  ```

---

## 🚨 Error Handling

- Use try-catch for async operations.
- Show user-friendly error messages.
- Log errors for debugging.

---

## 🔄 Pull Request Process

1. Fork the repository and create your branch from `main`.
2. Write clear, descriptive commit messages.
3. Ensure your code passes all tests and lints.
4. Submit a pull request and fill out the PR template.
5. Wait for review and address any feedback.

---

## 📱 Application Documentation

### Main Features

- **Medication Schedule**: Users can add, edit, and delete pill schedules. Each schedule supports multiple time slots per day.
- **Intake Log**: Calendar view with color-coded intake status. Users can confirm intake and view statistics.
- **Device Status**: Real-time connection and battery status for IoT pillbox devices.
- **Event Log**: Tracks all significant events and errors for troubleshooting.
- **Authentication**: Secure sign-in and user profile management.

### Architecture

- **Clean Architecture**: Separation of presentation, domain, and data layers.
- **State Management**: Riverpod/Provider for predictable and testable state.
- **Testing**: Comprehensive widget and unit tests for all business logic.

---

## 🛠️ Development Environment

- **Flutter SDK**: latest stable
- **Xcode**: 16.0 (Build version 16A242d)
- **macOS**: 23.6.0 (M1 Max)
- **iOS Minimum Deployment Target**: 13.0
- **Firebase**: Auth enabled

## 🧰 Tech Stack

- **Flutter** (cross-platform UI)
- **Firebase** (authentication, backend)
- **Clean Architecture**
- **Riverpod/Provider** (state management)
- **IoT Device Integration**

---

## 🙏 Code of Conduct

Be respectful, collaborative, and constructive in all interactions.

---

Thank you for helping make Yakiyo better! 