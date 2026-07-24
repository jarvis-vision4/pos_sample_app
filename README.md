# POS Sample App

A Point-of-Sale (POS) mobile application built with **Flutter** and **Dart**, following a layered architecture with Cubit state management.

## Tech Stack

| Layer              | Library / Tool            |
|--------------------|---------------------------|
| Framework          | Flutter 3.44+ / Dart      |
| State Management   | flutter_bloc 9.x (Cubits) |
| HTTP Client        | Dio 5.x                   |
| Local Storage      | sqflite                   |
| Image Caching      | cached_network_image      |
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
│       │   │   ├── product_card.dart    # Extracted product card widget
│       │   │   └── cart_badge.dart
│       │   └── pos_screen.dart         # POS terminal with cart badge
│       ├── cart/
│       │   ├── cubit/                  # CartCubit: CRUD, checkout, SQLite persist
│       │   ├── widgets/
│       │   │   ├── cart_items_list.dart
│       │   │   ├── checkout_section.dart
│       │   │   └── customer_section.dart
│       │   └── cart_screen.dart        # BlocConsumer: cart + checkout flow
│       ├── customer_selection/
│       │   ├── cubit/                  # CustomerCubit: load + filter + select
│       │   └── customer_selection_screen.dart
│       └── order_list/
│           ├── cubit/                  # OrderListCubit: loadOrders
│           ├── widgets/
│           │   └── order_card.dart     # Extracted order card widget
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
| DashboardCubit   | `loadDashboardData` — fetches total sales + order count from SQLite |
| CartCubit        | `addToCart`, `increase/decreaseQuantity`, `removeItem`, `setCustomer`, `checkout` (async + SQLite insert), `resetCheckout` |
| OrderListCubit   | `loadOrders` — fetches orders + items from SQLite            |
| PosCubit         | `loadProducts`, `loadCategories`, `selectCategory`           |
| CustomerCubit    | `loadCustomers`, `filterCustomers`, `selectCustomer`         |

## Data Flow

```
Dashboard ──loadDashboardData──▶ DatabaseService.getTotalSales() + getOrderCount()

POS Screen ──addToCart──▶ CartCubit ──checkout──▶ DatabaseService.insertOrder()
                                                        │
Cart Screen ──selectCustomer──▶ CustomerSelectionScreen   │
                                                        ▼
Dashboard ──navigate──▶ OrderListScreen ◀──loadOrders───┘
```

## Progress

### Completed
- All data models: `Product` (non-nullable), `Rating`, `CartItem`, `Customer`, `Address`, `GeoLocation`, `Order`, `OrderItem`
- `ApiService` — REST API: products, categories, customers
- `DatabaseService` — schema, `insertOrder`, `getAllOrders`, `getTotalSales`, `getOrderCount`
- `GetIt` locator — global `getIt` with `Dio`, `ApiService`, `DatabaseService`
- `AppTheme` — color constants, `lightTheme` with styled AppBar, Card, Button, Input
- `main.dart` — `MyPosApp`, `MultiBlocProvider` (all 5 cubits), `AppTheme.lightTheme`
- `DashboardCubit` — `loadDashboardData()` with total sales + order count from SQLite
- `DashboardScreen` — Total Sales / Total Orders summary cards + POS / Order List nav
- `PosCubit` — product/category loading, category filtering with loading/error states
- `PosScreen` — category chips, product grid, cart icon with badge
- `CategoryFilter` — horizontal `FilterChip` row
- `ProductGrid` — 2-column grid with `ProductCard`
- `ProductCard` — extracted widget, `CachedNetworkImage`, add/increment/decrement
- `CartCubit` — full CRUD + `checkout()` + SQLite persist + `resetCheckout()`
- `CartScreen` — `BlocConsumer`, success snackbar, auto-navigate to `/orders`
- `CustomerCubit` — load from API, `filterCustomers` (preserves original list)
- `CustomerSelectionScreen` — search field + filtered list, tap to select
- `OrderListCubit` — `loadOrders()` with loading/error states
- `OrderListScreen` — `OrderCard` list from SQLite
- `OrderCard` — extracted widget with #id, status badge, customer, date, totals
- `AppRouter` — all 5 routes active

### In Progress / Not Started
- Tests
