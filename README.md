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
│   │   ├── product.dart                # Product & Rating (JSON)
│   │   ├── cart_item.dart              # CartItem (product + quantity + subtotal)
│   │   ├── customer.dart               # Customer, Address & GeoLocation (JSON)
│   │   └── order.dart                  # Order & OrderItem (SQLite maps)
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
│       │   ├── cubit/                  # CartCubit: CRUD, customer, checkout
│       │   ├── widgets/
│       │   │   ├── cart_items_list.dart
│       │   │   └── checkout_section.dart
│       │   └── cart_screen.dart        # Customer row, items, checkout
│       ├── customer_selection/
│       │   ├── cubit/                  # CustomerCubit: load + search
│       │   └── customer_selection_screen.dart
│       └── order_list/
│           ├── cubit/                  # OrderListCubit (stub)
│           └── order_list_screen.dart  # Scaffold stub
└── routes/
    ├── app_router.dart                 # Active: /, /pos, /cart, /customer-selection
    └── app_routes.dart
```

## Routes

| Route                | Screen                    | Status |
|----------------------|---------------------------|--------|
| `/`                  | DashboardScreen           | Active |
| `/pos`               | PosScreen                 | Active |
| `/cart`              | CartScreen                | Active |
| `/customer-selection`| CustomerSelectionScreen   | Active |
| `/orders`            | OrderListScreen           | Stub   |

## Cubits

| Cubit            | Methods / State                                              |
|------------------|--------------------------------------------------------------|
| PosCubit         | `loadProducts`, `loadCategories`, `selectCategory`           |
| CartCubit        | `addToCart`, `increaseQuantity`, `decreaseQuantity`, `removeItem`, `setCustomer` |
| CustomerCubit    | `loadCustomers`, `searchCustomers`, `selectCustomer`         |
| OrderListCubit   | Stub — no methods yet                                        |
| DashboardCubit   | `loadDashboardData` (empty body)                             |

## Progress

### Completed
- Project scaffolding and dependency setup
- All data models: `Product`, `Rating`, `CartItem`, `Customer`, `Address`, `GeoLocation`, `Order`, `OrderItem`
- `ApiService` — `getAllProducts`, `getCategories`, `getProductsByCategory`, `getAllCustomers`
- `DatabaseService` — SQLite init with `orders` and `order_items` schema
- `GetIt` locator with `Dio`, `ApiService`, `DatabaseService` singletons
- `main.dart` — locator init, `MultiBlocProvider` (PosCubit, CartCubit, CustomerCubit), routing
- `DashboardScreen` — two nav cards (POS, Orders)
- `PosCubit` — product/category loading, category filtering with loading/error states
- `PosScreen` — category chips, product grid, cart icon with quantity badge
- `CategoryFilter` — horizontal `FilterChip` row ("All" + categories)
- `ProductGrid` — 2-column grid, `CachedNetworkImage`, per-item add/increment/decrement
- `CartCubit` — full cart CRUD: add, increase, decrease, remove, set customer
- `CartState` — items, selectedCustomer, `totalQuantity`, `totalAmount`, `canCheckOut`, `isCheckingOut`
- `CartScreen` — customer row (avatar/"Change" or "Select Customer"), items list
- `CartItemsList` — product image, price, subtotal, quantity +/- , delete with snackbar
- `CheckoutSection` — total items, total amount, checkout button (disabled when `!canCheckOut`), confirm dialog
- `CustomerCubit` — load customers, search by name/email, select customer
- `CustomerSelectionScreen` — search `TextField` + filtered `ListView`, tap to select and pop back
- `AppRouter` — all routes wired except `/orders`

### In Progress
- `DashboardCubit.loadDashboardData()` — stub (empty body)
- `OrderListCubit` — scaffold created, no methods
- `OrderListScreen` — scaffold created, empty body

### Not Started
- Order checkout / submission flow (save to DB)
- Order list data loading
- Tests
