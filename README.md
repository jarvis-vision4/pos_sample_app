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
├── main.dart                           # Entry point (GetIt init, MultiBlocProvider, MaterialApp)
├── constants/
│   └── api_constants.dart              # FakeStore API base URL & endpoint helpers
├── data/
│   ├── models/
│   │   ├── product.dart                # Product & Rating models (JSON serialization)
│   │   ├── cart_item.dart              # CartItem model (product + quantity + subtotal)
│   │   └── customer.dart               # Customer, Address & GeoLocation models
│   └── services/
│       ├── api_service.dart            # REST API: getAllProducts, getCategories
│       └── database_service.dart       # SQLite: orders + order_items tables
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
│       │   │   ├── pos_cubit.dart      # loadProducts, loadCategories, selectCategory
│       │   │   └── pos_state.dart
│       │   ├── widgets/
│       │   │   ├── category_filter.dart  # Horizontal FilterChip row
│       │   │   └── product_grid.dart     # 2-column grid with add-to-cart per item
│       │   └── pos_screen.dart         # POS terminal with cart badge
│       └── cart/
│           ├── cubit/
│           │   ├── cart_cubit.dart     # addToCart, increase/decreaseQuantity, removeItem
│           │   └── cart_state.dart     # items list + totalQuantity getter
│           ├── widgets/
│           │   └── cart_items_list.dart  # ListView with image, qty controls, delete
│           └── cart_screen.dart
└── routes/
    ├── app_router.dart                 # Active: dashboard, pos, cart
    └── app_routes.dart                 # Route name constants
```

## Routes

| Route              | Screen              | Status |
|--------------------|---------------------|--------|
| `/`                | DashboardScreen     | Active |
| `/pos`             | PosScreen           | Active |
| `/cart`            | CartScreen          | Active |
| `/customer-selection` | —               | Stub   |
| `/orders`          | —                   | Stub   |

## Progress

### Completed
- Project scaffolding and dependency setup
- `Product` / `Rating` / `CartItem` / `Customer` / `Address` / `GeoLocation` data models
- `ApiService` — `getAllProducts()` and `getCategories()` with error handling
- `DatabaseService` — SQLite init with `orders` and `order_items` schema
- `GetIt` locator with `Dio`, `ApiService`, `DatabaseService` singletons
- `main.dart` wired with locator init, `MultiBlocProvider`, `MaterialApp` + routing
- `DashboardScreen` — two navigation cards (POS, Orders)
- `PosCubit` — `loadProducts()`, `loadCategories()`, `selectCategory()` with error handling
- `PosScreen` — category chips, product grid, cart icon with badge
- `CategoryFilter` widget — horizontal `FilterChip` row with "All" + categories
- `ProductGrid` widget — 2-column grid, `CachedNetworkImage`, per-item add/increment/decrement
- `CartCubit` — `addToCart()`, `increaseQuantity()`, `decreaseQuantity()`, `removeItem()`
- `CartScreen` — displays `CartItemsList` with image, subtotal, quantity +/- , delete
- `CartItemsList` widget — `ListView` with product image, price, quantity controls

### In Progress
- `DashboardCubit` — `loadDashboardData()` method exists but body is empty

### Not Started
- Customer selection screen
- Order list screen
- Order checkout / submission flow
- Tests
