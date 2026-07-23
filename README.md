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
│       └── database_service.dart       # SQLite: orders + order_items tables
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
│       │   ├── cubit/                  # CartCubit: CRUD, customer, checkout
│       │   ├── widgets/
│       │   │   ├── cart_items_list.dart
│       │   │   ├── checkout_section.dart
│       │   │   └── customer_section.dart
│       │   └── cart_screen.dart        # BlocConsumer: cart + checkout flow
│       ├── customer_selection/
│       │   ├── cubit/                  # CustomerCubit: load + search + select
│       │   └── customer_selection_screen.dart
│       └── order_list/
│           ├── cubit/                  # OrderListCubit (stub)
│           └── order_list_screen.dart  # Scaffold with back-to-dashboard
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
| CartCubit        | `addToCart`, `increaseQuantity`, `decreaseQuantity`, `removeItem`, `setCustomer`, `checkout`, `resetCheckout` |
| PosCubit         | `loadProducts`, `loadCategories`, `selectCategory`           |
| CustomerCubit    | `loadCustomers`, `searchCustomers`, `selectCustomer`         |
| OrderListCubit   | Stub — no methods yet                                        |
| DashboardCubit   | `loadDashboardData` (empty body)                             |

## Progress

### Completed
- All data models: `Product`, `Rating`, `CartItem`, `Customer`, `Address`, `GeoLocation`, `Order`, `OrderItem`
- `ApiService` — `getAllProducts`, `getCategories`, `getProductsByCategory`, `getAllCustomers`
- `DatabaseService` — SQLite init with `orders` and `order_items` schema
- `GetIt` locator — global `getIt` instance with `Dio`, `ApiService`, `DatabaseService` singletons
- `main.dart` — locator init, `MultiBlocProvider` (no dead `child` params), `MaterialApp` + routing
- `DashboardScreen` — two nav cards (POS, Orders)
- `PosCubit` — product/category loading, category filtering with loading/error states
- `PosScreen` — category chips, product grid, cart icon with quantity badge
- `CategoryFilter` — horizontal `FilterChip` row ("All" + categories)
- `ProductGrid` — 2-column grid, `CachedNetworkImage`, per-item add/increment/decrement
- `CartCubit` — full cart CRUD + `checkout()` (creates Order + OrderItem) + `resetCheckout()`
- `CartState` — items, selectedCustomer, `totalQuantity`, `totalAmount`, `canCheckOut`, `isCheckingOut`, `checkoutSuccess`
- `CartScreen` — `BlocConsumer` with success snackbar + auto-navigate to `/orders` on checkout
- `CustomerSection` — extracted widget (no duplicate code)
- `CheckoutSection` — totals + checkout button with confirm dialog
- `CartItemsList` — product image, price, subtotal, quantity +/- , delete with snackbar
- `CustomerCubit` — load customers, search by name/email, select customer
- `CustomerSelectionScreen` — search `TextField` + filtered `ListView`, tap to select and pop back
- `AppRouter` — all 5 routes wired and active
- `Product` model — refactored to non-nullable `late` fields with `required` constructor

### In Progress
- `DashboardCubit.loadDashboardData()` — stub (empty body)
- `OrderListCubit` — scaffold created, no methods
- `OrderListScreen` — scaffold with back navigation, empty body

### Not Started
- Order list data loading (from SQLite)
- Tests
