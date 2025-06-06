# Yakiyo - IoT-based Redosing Management App

Yakiyo is an innovative IoT-powered application designed to help users efficiently manage their medication schedules and prevent accidental redosing. With a focus on user safety and convenience, Yakiyo integrates device connectivity, real-time tracking, and a clean, modular architecture.

## ✨ Features

- **Clean Architecture** for scalable and maintainable codebase
- **Medication Schedule Management**: Add, edit, and track your pill schedules
- **User Authentication**: Secure sign-in and profile management
- **Device Status Monitoring**: Real-time IoT device connectivity and battery status
- **Event Logging**: Comprehensive event and error logs
- **Intake Tracking**: Visual calendar, statistics, and intake confirmation

## 🗂️ Project Structure

```
lib/
├── common/          # Shared widgets and utilities
├── core/            # Core functionality and constants
├── features/        # Feature-based modules
│   ├── auth/        # Authentication
│   ├── device_status/
│   ├── event_log/
│   ├── home/
│   ├── intake_log/
│   ├── pill_schedule/
│   └── settings/
└── services/        # Service layer implementations
```

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
