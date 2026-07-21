# POS Sample App

A Point-of-Sale (POS) mobile application built with **Flutter** and **Dart**, following a layered architecture with BLoC state management.

## Tech Stack

| Layer              | Library / Tool       |
|--------------------|----------------------|
| Framework          | Flutter 3.44+ / Dart |
| State Management   | flutter_bloc 9.x     |
| HTTP Client        | Dio 5.x              |
| Local Storage      | sqflite              |
| DI / Service Loc.  | get_it               |
| Linting            | flutter_lints        |

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── constants/
│   └── api_constants.dart              # API base URL & endpoint constants
├── data/
│   ├── models/
│   │   └── product.dart                # Product & Rating models (JSON serialization)
│   └── services/
│       ├── api_service.dart            # REST API service (Dio-based)
│       └── database_service.dart       # SQLite local database service
├── locator/
│   └── locator.dart                    # Dependency injection setup (GetIt)
├── presentation/
│   └── screens/                        # UI screens (pending implementation)
└── routes/
    ├── app_router.dart                 # Named route generation
    └── app_routes.dart                 # Route name constants
```

## Architecture

The project follows a **layered architecture**:

- **`constants/`** — App-wide constants (API endpoints, configuration)
- **`data/models/`** — Data models with `fromJson`/`toJson` serialization
- **`data/services/`** — Data access layer (remote API via Dio, local DB via sqflite)
- **`locator/`** — Dependency injection (GetIt service locator)
- **`presentation/screens/`** — UI screens using BLoC for state management
- **`routes/`** — Named route definitions and navigation logic

## Planned Screens

- **Dashboard** (`/`) — Overview and quick actions
- **POS Terminal** (`/pos`) — Point-of-sale transaction flow
- **Customer Selection** (`/customer-selection`) — Customer lookup / selection
- **Cart** (`/cart`) — Order review and checkout
- **Orders** (`/orders`) — Order history and management

## Current Progress

The project is in its **early scaffolding phase**:

- [x] Project setup & dependency declarations
- [x] Data models (Product, Rating) with JSON serialization
- [x] Dio HTTP client configured (FakeStore API)
- [x] GetIt service locator registered
- [x] Route constants and router scaffold
- [ ] BLoC classes (not yet implemented)
- [ ] API service methods
- [ ] Database service implementation
- [ ] Screen UIs (all pending)
- [ ] Route wiring in `main.dart`
- [ ] Tests

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## Build Targets

- **Android** — Kotlin 2.3, Gradle 9.0, Java 17
- **iOS** — Swift, Xcode project
