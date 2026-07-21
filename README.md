# POS Sample App

A Point-of-Sale (POS) mobile application built with **Flutter** and **Dart**, following a layered architecture with BLoC/Cubit state management.

## Tech Stack

| Layer              | Library / Tool       |
|--------------------|----------------------|
| Framework          | Flutter 3.44+ / Dart |
| State Management   | flutter_bloc 9.x     |
| HTTP Client        | Dio 5.x              |
| Local Storage      | sqflite              |
| DI / Service Loc.  | get_it               |
| Linting            | flutter_lints        |

## Architecture

```
lib/
├── main.dart                           # App entry point (GetIt init, routing, MultiBlocProvider)
├── constants/
│   └── api_constants.dart              # FakeStore API base URL & endpoint constants
├── data/
│   ├── models/
│   │   ├── product.dart                # Product & Rating models (JSON serialization)
│   │   └── cart_item.dart              # CartItem model (product + quantity)
│   └── services/
│       ├── api_service.dart            # REST API service (Dio-based)
│       └── database_service.dart       # SQLite DB (orders + order_items tables)
├── locator/
│   └── locator.dart                    # GetIt: registers Dio, ApiService, DatabaseService
├── presentation/
│   └── screens/
│       ├── dashboard/
│       │   ├── cubit/
│       │   │   ├── dashboard_cubit.dart
│       │   │   └── dashboard_state.dart
│       │   └── dashboard_screen.dart   # Home screen with POS & Orders nav cards
│       ├── pos/
│       │   ├── cubit/
│       │   │   ├── pos_cubit.dart
│       │   │   └── pos_state.dart
│       │   ├── widgets/
│       │   │   └── category_filter.dart
│       │   └── pos_screen.dart         # Category chips + product grid
│       └── cart/
│           └── cart_screen.dart
└── routes/
    ├── app_router.dart                 # Named route generation
    └── app_routes.dart                 # Route name constants
```

## Routes

| Route              | Screen              | Status      |
|--------------------|---------------------|-------------|
| `/`                | DashboardScreen     | Active      |
| `/pos`             | PosScreen           | Active      |
| `/customer-selection` | —               | Commented   |
| `/cart`            | CartScreen          | Commented   |
| `/orders`          | —                   | Commented   |

## Progress

### Completed
- Project scaffolding and dependency setup
- `Product` / `Rating` / `CartItem` data models with JSON serialization
- `ApiService` — `getAllProducts()` and `getCategories()` implemented
- `DatabaseService` — SQLite init with `orders` and `order_items` table schema
- `GetIt` locator with `Dio`, `ApiService`, `DatabaseService` singletons
- `main.dart` wired with locator init, `MultiBlocProvider`, and `MaterialApp` routing
- `DashboardScreen` — two navigation cards (POS, Orders)
- `PosScreen` — category chips + product grid with loading state
- `PosCubit` — `loadProducts()` and `loadCategories()` with error handling
- Route constants and router scaffold (dashboard + POS active)

### Partial / In Progress
- `DashboardCubit` — `loadDashboardData()` exists but body is empty
- `PosState` — `selectedCategory` and `cart` fields defined but not yet wired to cubit methods
- `CartScreen` — scaffold exists but no UI content

### Not Started
- `CategoryFilter` widget (currently a `Placeholder`)
- Category filtering (`filterByCategory`)
- Cart operations (`addToCart`, `removeFromCart`)
- Customer selection screen
- Order list screen
- Tests

## Getting Started

```bash
flutter pub get
flutter run
flutter test
```

## Build Targets

- **Android** — Kotlin 2.3, Gradle 9.0, Java 17
- **iOS** — Swift, Xcode project
