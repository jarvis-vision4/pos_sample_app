# POS Sample App
## Getting Started

### Prerequisites
- Flutter SDK 3.44+ (stable channel)
- Dart SDK ^3.12.2
- Android Studio / Xcode (for emulator)

### Setup

```bash
# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Run in release mode
flutter run --release

# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS (macOS only)
flutter build ios --release

# Run tests
flutter test
```

The app uses the [FakeStore API](https://fakestoreapi.com) as its data source — no backend setup required.

A Point-of-Sale (POS) mobile application built with **Flutter** and **Dart**, following a layered architecture with Cubit state management.

## Tech Stack

| Layer              | Library / Tool            |
|--------------------|---------------------------|
| Framework          | Flutter 3.44+ / Dart      |
| State Management   | flutter_bloc 9.x (Cubits) |
| HTTP Client        | Dio 5.x                   |
| Local Storage      | sqflite                   |
| Image Caching      | cached_network_image      |
| Number Formatting  | intl                      |
| DI / Service Loc.  | get_it                    |
| Linting            | flutter_lints             |

## Architecture

```
lib/
├── main.dart                           # Entry point (GetIt, MultiBlocProvider, AppTheme)
├── constants/
│   └── api_constants.dart              # FakeStore API base URL & endpoint helpers
├── theme/
│   └── app_theme.dart                  # AppTheme: colors, lightTheme config
├── utils/
│   └── price_format.dart               # PriceFormat: number formatting utility
├── data/
│   ├── models/
│   │   ├── product.dart                # Product & Rating (non-nullable, JSON)
│   │   ├── cart_item.dart              # CartItem (product + quantity + subtotal)
│   │   ├── customer.dart               # Customer, Address & GeoLocation (JSON)
│   │   └── order.dart                  # Order & OrderItem (SQLite maps)
│   └── services/
│       ├── api_service.dart            # REST API: products, categories, customers
│       └── database_service.dart       # SQLite: CRUD + aggregation queries
├── locator/
│   └── locator.dart                    # Global GetIt: Dio, ApiService, DatabaseService
├── presentation/
│   └── screens/
│       ├── dashboard/
│       │   ├── cubit/                  # DashboardCubit: totalSales, totalCount
│       │   └── dashboard_screen.dart   # Summary cards + nav cards
│       ├── pos/
│       │   ├── cubit/                  # PosCubit: products, categories, filtering
│       │   ├── widgets/
│       │   │   ├── category_filter.dart
│       │   │   ├── product_grid.dart
│       │   │   ├── product_card.dart
│       │   │   └── cart_badge.dart
│       │   └── pos_screen.dart         # POS terminal with cart badge
│       ├── cart/
│       │   ├── cubit/                  # CartCubit: CRUD, clearCart, checkout
│       │   ├── widgets/
│       │   │   ├── cart_card.dart
│       │   │   ├── cart_items_list.dart
│       │   │   ├── checkout_section.dart
│       │   │   └── customer_section.dart
│       │   └── cart_screen.dart        # BlocConsumer: cart + clear + checkout
│       ├── customer_selection/
│       │   ├── cubit/                  # CustomerCubit: load + filter + select
│       │   └── customer_selection_screen.dart
│       └── order_list/
│           ├── cubit/                  # OrderListCubit: loadOrders
│           ├── widgets/
│           │   └── order_card.dart
│           └── order_list_screen.dart  # Order cards list from SQLite
└── routes/
    ├── app_router.dart                 # All 5 routes active
    └── app_routes.dart
```

## Routes

| Route                | Screen                    | Status |
|----------------------|---------------------------|--------|
| `/`                  | DashboardScreen           | Active |
| `/pos`               | PosScreen                 | Active |
| `/cart`              | CartScreen                | Active |
| `/customer-selection`| CustomerSelectionScreen   | Active |
| `/orders`            | OrderListScreen           | Active |

## Cubits

| Cubit            | Methods / State                                              |
|------------------|--------------------------------------------------------------|
| DashboardCubit   | `loadDashboardData` — total sales + order count from SQLite  |
| CartCubit        | `addToCart`, `increase/decreaseQuantity`, `removeItem`, `setCustomer`, `clearCart`, `checkout` (async + SQLite insert), `resetCheckout` |
| OrderListCubit   | `loadOrders` — orders + items from SQLite                    |
| PosCubit         | `loadProducts`, `loadCategories`, `selectCategory`           |
| CustomerCubit    | `loadCustomers`, `filterCustomers`, `selectCustomer`         |

## Data Flow

```
Dashboard ──loadDashboardData──▶ DB.getTotalSales() + getOrderCount()

POS ──addToCart──▶ CartCubit ──checkout──▶ DB.insertOrder() ──▶ OrderListScreen
                         ▲                      │
                   clearCart()            resetCheckout()
```

## Progress

### Completed
- All data models: `Product` (non-nullable), `Rating`, `CartItem`, `Customer`, `Address`, `GeoLocation`, `Order`, `OrderItem`
- `ApiService` — REST API: products, categories, customers
- `DatabaseService` — schema, `insertOrder`, `getAllOrders`, `getTotalSales`, `getOrderCount`
- `GetIt` locator — global `getIt` with `Dio`, `ApiService`, `DatabaseService`
- `AppTheme` — color constants, `lightTheme` with styled AppBar, Card, Button, Input
- `PriceFormat` — `NumberFormat('#,##0')` utility for price display
- `main.dart` — `MyPosApp`, `MultiBlocProvider` (all 5 cubits), `AppTheme.lightTheme`
- `DashboardCubit` — total sales + order count from SQLite
- `DashboardScreen` — Total Sales / Total Orders summary + POS / Orders nav
- `PosCubit` — products, categories, filtering with loading/error states
- `PosScreen` — category chips, product grid, cart badge
- `CategoryFilter` — horizontal `FilterChip` row
- `ProductGrid` — 2-column grid with `ProductCard`
- `ProductCard` — extracted widget, `CachedNetworkImage`, add/increment/decrement
- `CartCubit` — full CRUD + `clearCart()` + `checkout()` (SQLite persist)
- `CartCard` — extracted widget: image, title, price, qty +/- , delete
- `CartItemsList` — empty state with icon + hint text
- `CartScreen` — "Clear Cart" button with confirm dialog, `BlocConsumer` with success snackbar, auto-navigate to `/orders`
- `CheckoutSection` — totals + checkout with `PriceFormat`
- `CustomerSection` — extracted widget with avatar/change logic
- `CustomerCubit` — load from API, `filterCustomers` (preserves original list)
- `CustomerSelectionScreen` — search field + filtered list, tap to select
- `OrderListCubit` — `loadOrders()` with loading/error states
- `OrderCard` — extracted widget: #id, status badge, customer, date, totals
- `OrderListScreen` — order cards from SQLite
- `AppRouter` — all 5 routes active

### Not Started
- Tests

