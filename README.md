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
├── main.dart                           # Entry point (GetIt, MultiBlocProvider, MaterialApp)
├── constants/
│   └── api_constants.dart              # FakeStore API base URL & endpoint helpers
├── data/
│   ├── models/
│   │   ├── product.dart                # Product & Rating (non-nullable, JSON)
│   │   ├── cart_item.dart              # CartItem (product + quantity + subtotal)
│   │   ├── customer.dart               # Customer, Address & GeoLocation (JSON)
│   │   └── order.dart                  # Order & OrderItem (SQLite maps)
│   └── services/
│       ├── api_service.dart            # REST API: products, categories, customers
│       └── database_service.dart       # SQLite: insert + query orders/order_items
├── locator/
│   └── locator.dart                    # Global GetIt: Dio, ApiService, DatabaseService
├── presentation/
│   └── screens/
│       ├── dashboard/
│       │   ├── cubit/                  # DashboardCubit (stub), DashboardState
│       │   └── dashboard_screen.dart   # Home screen nav cards
│       ├── pos/
│       │   ├── cubit/                  # PosCubit: products, categories, filtering
│       │   ├── widgets/
│       │   │   ├── category_filter.dart
│       │   │   └── product_grid.dart
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
| CartCubit        | `addToCart`, `increase/decreaseQuantity`, `removeItem`, `setCustomer`, `checkout` (async + SQLite insert), `resetCheckout` |
| OrderListCubit   | `loadOrders` — fetches orders + items from SQLite            |
| PosCubit         | `loadProducts`, `loadCategories`, `selectCategory`           |
| CustomerCubit    | `loadCustomers`, `filterCustomers` (preserves original list), `selectCustomer` |
| DashboardCubit   | `loadDashboardData` (stub)                                   |

## Data Flow

```
POS Screen ──addToCart──▶ CartCubit ──checkout──▶ DatabaseService (SQLite insert)
                                                        │
Cart Screen ──selectCustomer──▶ CustomerSelectionScreen   │
                                                        ▼
Dashboard ──navigate──▶ OrderListScreen ◀──loadOrders───┘
```

## Progress

### Completed
- All data models: `Product`, `Rating`, `CartItem`, `Customer`, `Address`, `GeoLocation`, `Order`, `OrderItem`
- `ApiService` — REST API: products, categories, customers
- `DatabaseService` — SQLite schema, `insertOrder(order + items)`, `getAllOrders()`
- `GetIt` locator — global `getIt` with `Dio`, `ApiService`, `DatabaseService`
- `main.dart` — `MyPosApp`, `MultiBlocProvider` with all 4 cubits
- `DashboardScreen` — two nav cards (POS, Orders)
- `PosScreen` — category chips, product grid, cart badge
- `CategoryFilter` — `FilterChip` row ("All" + categories)
- `ProductGrid` — 2-column grid, `CachedNetworkImage`, add/increment/decrement
- `CartCubit` — full CRUD + `checkout()` (creates Order, persists to SQLite, clears cart)
- `CartScreen` — `BlocConsumer`, customer section, items list, checkout with confirm dialog
- `CustomerCubit` — load from API, `filterCustomers` by name/email (preserves original list)
- `CustomerSelectionScreen` — search field + filtered list, tap to select
- `OrderListCubit` — `loadOrders()` with loading/error states
- `OrderListScreen` — order cards with #id, status badge, customer, date, totals
- `AppRouter` — all 5 routes active

### In Progress
- `DashboardCubit.loadDashboardData()` — stub (empty body)

### Not Started
- Tests
