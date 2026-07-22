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
│   │   ├── product.dart                # Product & Rating models (JSON)
│   │   ├── cart_item.dart              # CartItem (product + quantity + subtotal)
│   │   └── customer.dart               # Customer, Address & GeoLocation models
│   └── services/
│       ├── api_service.dart            # REST API: products, categories, customers
│       └── database_service.dart       # SQLite: orders + order_items tables
├── locator/
│   └── locator.dart                    # GetIt: registers Dio, ApiService, DatabaseService
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
│       │   ├── cubit/                  # CartCubit: CRUD, customer selection
│       │   ├── widgets/
│       │   │   └── cart_items_list.dart
│       │   └── cart_screen.dart        # Cart with customer, totals, checkout
│       └── customer_selection/
│           ├── cubit/                  # CustomerCubit: load + search
│           └── customer_selection_screen.dart  # Searchable customer list
└── routes/
    ├── app_router.dart                 # All routes active except /orders
    └── app_routes.dart
```

## Routes

| Route                | Screen                    | Status |
|----------------------|---------------------------|--------|
| `/`                  | DashboardScreen           | Active |
| `/pos`               | PosScreen                 | Active |
| `/cart`              | CartScreen                | Active |
| `/customer-selection`| CustomerSelectionScreen   | Active |
| `/orders`            | —                         | Stub   |

## Cubits

| Cubit            | File                         | Key Methods / State                                      |
|------------------|------------------------------|----------------------------------------------------------|
| PosCubit         | `pos/cubit/pos_cubit.dart`   | `loadProducts`, `loadCategories`, `selectCategory`       |
| CartCubit        | `cart/cubit/cart_cubit.dart` | `addToCart`, `increase/decreaseQuantity`, `removeItem`, `setCustomer` |
| CustomerCubit    | `customer_selection/cubit/`  | `loadCustomers`, `searchCustomers`, `selectCustomer`     |
| DashboardCubit   | `dashboard/cubit/`           | `loadDashboardData` (stub — empty body)                  |

## Progress

### Completed
- Project scaffolding and dependency setup
- `Product` / `Rating` / `CartItem` / `Customer` / `Address` / `GeoLocation` data models
- `ApiService` — `getAllProducts`, `getCategories`, `getProductsByCategory`, `getAllCustomers`
- `DatabaseService` — SQLite init with `orders` and `order_items` schema
- `GetIt` locator with `Dio`, `ApiService`, `DatabaseService` singletons
- `main.dart` — locator init, `MultiBlocProvider`, `MaterialApp` with routing
- `DashboardScreen` — two nav cards (POS, Orders)
- `PosCubit` — product/category loading and category filtering with loading/error states
- `PosScreen` — category chips, product grid, cart icon with quantity badge
- `CategoryFilter` — horizontal `FilterChip` row ("All" + categories)
- `ProductGrid` — 2-column grid, `CachedNetworkImage`, add/increment/decrement per item
- `CartCubit` — full cart CRUD: add, increase, decrease, remove, set customer
- `CartState` — items, selectedCustomer, computed `totalQuantity`, `totalAmount`, `canCheckOut`
- `CartScreen` — customer row (with avatar/"Change" or "No customer selected"/"Select Customer"), items list, total items + total amount footer
- `CartItemsList` — product image, price, subtotal, quantity +/- , delete with snackbar
- `CustomerCubit` — load customers, search by name/email, select customer
- `CustomerSelectionScreen` — search `TextField` + filtered `ListView`, tap to select and pop back
- `AppRouter` — dashboard, pos, cart, customerSelection all wired

### In Progress
- `DashboardCubit.loadDashboardData()` — exists but body is empty

### Not Started
- Order list screen
- Order checkout / submission flow
- Tests
