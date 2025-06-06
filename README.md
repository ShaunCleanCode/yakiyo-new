# Yakiyo - IoT-based Redosing Management App

Yakiyo is an innovative IoT-powered application designed to help users efficiently manage their medication schedules and prevent accidental redosing. With a focus on user safety and convenience, Yakiyo integrates device connectivity, real-time tracking, and a clean, modular architecture.

## ✨ Features

- **Clean Architecture** for scalable and maintainable codebase
- **Medication Schedule Management**: Add, edit, and track your pill schedules
- **User Authentication**: Secure sign-in and profile management
- **Device Status Monitoring**: Real-time IoT device connectivity and battery status
- **Event Logging**: Comprehensive event and error logs
- **Intake Tracking**: Visual calendar, statistics, and intake confirmation

## ��️ Project Structure (Detailed)

```
lib/
├── common/                # Shared widgets, icons, themes, and utility functions
│   ├── widgets/           # Reusable UI components (e.g., PillCard, PillIcon)
│   ├── themes/            # App-wide color and style definitions
│   └── utils.dart         # Utility/helper functions
│
├── core/                  # Core app logic, constants, and configuration
│   ├── constants/         # App-wide constants (colors, strings, etc.)
│   ├── exceptions/        # Custom exception classes
│   └── config.dart        # App configuration and environment setup
│
├── features/              # Feature-based modules (Clean Architecture)
│   ├── auth/              # User authentication (sign-in, sign-up, profile)
│   │   ├── data/          # Data sources, models, repositories for auth
│   │   ├── domain/        # Auth business logic, use cases, entities
│   │   └── presentation/  # Auth screens, viewmodels, providers
│   │
│   ├── device_status/     # IoT device connection & status
│   │   ├── data/          # Device status models, repositories
│   │   └── presentation/  # Device status UI, providers
│   │
│   ├── event_log/         # Event and error logging
│   │   ├── data/          # Event log models, repositories
│   │   └── presentation/  # Event log UI, providers
│   │
│   ├── home/              # Home screen/dashboard
│   │   ├── presentation/  # Home screen UI, navigation, providers
│   │
│   ├── intake_log/        # Pill intake tracking & statistics
│   │   ├── data/          # Intake log models, repositories
│   │   ├── domain/        # Intake log business logic, use cases
│   │   └── presentation/  # Intake log screens (calendar, stats), providers
│   │
│   ├── pill_schedule/     # Medication schedule management
│   │   ├── data/          # Pill schedule models, repositories
│   │   ├── domain/        # Schedule business logic, use cases
│   │   └── presentation/  # Schedule screens (add/edit), providers
│   │
│   └── settings/          # User settings (nickname, preferences)
│       ├── data/          # Settings models, repositories
│       └── presentation/  # Settings UI, providers
│
└── services/              # Service layer (API, Firebase, IoT, etc.)
    ├── api/               # REST API clients and endpoints
    ├── firebase/          # Firebase integration (auth, firestore, etc.)
    └── iot/               # IoT device communication logic
```

### Module Descriptions
- **common/**: Shared UI widgets (e.g., PillCard), icons, themes, and utility functions used throughout the app.
- **core/**: App-wide constants, configuration, and error handling.
- **features/**: Each major feature is a self-contained module following Clean Architecture (data/domain/presentation layers).
  - **auth/**: Handles user authentication, sign-in, sign-up, and profile management.
  - **device_status/**: Manages IoT device connection, battery, and sync status.
  - **event_log/**: Logs all significant events and errors for troubleshooting.
  - **home/**: Home dashboard, showing today's schedule, next pill, and summary.
  - **intake_log/**: Tracks pill intake, provides calendar/statistics, and AI-powered summaries.
  - **pill_schedule/**: Manages medication schedules, including add/edit/delete and time slots.
  - **settings/**: User preferences, nickname, and notification settings.
- **services/**: Integrations with external services (REST API, Firebase, IoT communication).

## 🔄 Main Application Flow

1. **User Authentication**: Users sign in or register. Auth state is managed and propagated throughout the app.
2. **Home Dashboard**: Shows today's medication schedule, next pill time, and device status. Pulls data from pill_schedule, intake_log, and device_status features.
3. **Medication Scheduling**: Users can add, edit, or delete pill schedules. Schedules are reflected in the home dashboard and intake log.
4. **Intake Logging**: Users confirm pill intake, which is logged and visualized in a calendar/statistics view. AI-powered summaries highlight missed or perfect adherence.
5. **Device Monitoring**: Real-time IoT device status (connection, battery, sync) is displayed and updated.
6. **Event Logging**: All significant actions and errors are logged for transparency and troubleshooting.
7. **Settings**: Users can update their nickname, notification preferences, and other settings.

## 🚀 Getting Started

1. **Clone the repository**
    ```bash
    git clone https://github.com/ShaunCleanCode/yakiyo-new.git
    ```

2. **Install dependencies**
    ```bash
    flutter pub get
    ```

3. **Run the app**
    ```bash
    flutter run
    ```

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

## 🛡️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

We welcome contributions! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.
