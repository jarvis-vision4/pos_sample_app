# POS Sample App — Project Documentation

## 1. Overview

**POS Sample App** is a cross-platform (Android / iOS / Web / Desktop) Point-of-Sale
demonstration built with **Flutter** and **Dart**. It demonstrates a clean, layered
architecture using the **BLoC / Cubit** state-management pattern, a local **SQLite**
database for persisted orders, and a remote **REST API** (FakeStore API) for products
and customers.

Key capabilities:
- Browse products by category, search products, and add them to a cart.
- Choose a customer, review the cart, and **checkout** (persist the order locally).
- View a dashboard with **total sales** and **total orders**.
- Review the list of placed orders.

---

## 2. Technology Stack

| Category | Package | Purpose |
|---|---|---|
| UI Framework | Flutter 3.x / Dart ^3.12.2 | Cross-platform app |
| State Management | `flutter_bloc` ^9.1.1 | Cubits + States |
| HTTP Client | `dio` ^5.10.0 | REST calls to FakeStore API |
| Local DB | `sqflite` ^2.4.3 | SQLite persistence |
| Image Cache | `cached_network_image` ^3.4.1 | Product image loading |
| DI | `get_it` ^9.2.1 | Service locator |
| Utils | `intl` ^0.20.2, `path`, `path_provider` | Formatting, paths |
| Lints | `flutter_lints` ^6.0.0 | Static analysis |

---

## 3. Architecture

The app follows a **layered / clean architecture**. Dependencies flow downward; the UI
never talks directly to services, only through Cubits.

```
┌───────────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER (UI)                                       │
│   DashboardScreen · PosScreen · CartScreen ·                 │
│   CustomerSelectionScreen · OrderListScreen (+ widgets)       │
└───────────────────────────┬───────────────────────────────────┘
                            │ BlocBuilder / BlocSelector
┌───────────────────────────▼───────────────────────────────────┐
│ STATE MANAGEMENT (BLoC / Cubit)                                │
│   PosCubit · CartCubit · DashboardCubit ·                      │
│   CustomerCubit · OrderListCubit  (+ *State classes)          │
└───────────────────────────┬───────────────────────────────────┘
                            │ uses (via GetIt)
┌───────────────────────────▼───────────────────────────────────┐
│ DATA MODELS                                                    │
│   Product · CartItem · Customer · Address · Order · OrderItem  │
└───────────────────────────┬───────────────────────────────────┘
                            │
┌───────────────────────────▼───────────────────────────────────┐
│ DATA SOURCES & INFRASTRUCTURE                                 │
│   ApiService (Dio) ──▶ FakeStore REST API                     │
│   DatabaseService (sqflite) ──▶ SQLite (pos_sample_app_db)     │
│   locator.dart (GetIt) registers Dio / ApiService / Database   │
└───────────────────────────────────────────────────────────────┘
```

A diagram is available at `docs/diagrams/architecture_diagram.png`.

---

## 4. Project Structure

```
lib/
├── main.dart                      # App entry, MultiBlocProvider, GetIt setup
├── locator/
│   └── locator.dart               # Dependency injection (GetIt)
├── routes/
│   ├── app_routes.dart            # Route name constants
│   └── app_router.dart            # onGenerateRoute switch
├── theme/
│   └── app_theme.dart             # AppTheme (colors, light theme)
├── utils/
│   └── price_format.dart          # Currency formatting helper
├── constants/
│   └── api_constants.dart         # Base URL & endpoints
├── data/
│   ├── models/                    # Product, Rating, CartItem, Customer,
│   │                              #   Address, GeoLocation, Order, OrderItem
│   └── services/
│       ├── api_service.dart       # REST client
│       └── database_service.dart  # SQLite client
└── presentation/
    └── screens/
        ├── dashboard/             # DashboardCubit/State + DashboardScreen
        ├── pos/                   # PosCubit/State + PosScreen + widgets
        │                          #   (CategoryFilter, ProductGrid,
        │                          #    ProductCard, CartBadge)
        ├── cart/                  # CartCubit/State + CartScreen + widgets
        │                          #   (CartItemsList, CartCard,
        │                          #    CustomerSection, CheckoutSection)
        ├── customer_selection/    # CustomerCubit/State + Screen
        └── order_list/            # OrderListCubit/State + Screen + OrderCard
```

---

## 5. Data Models

| Model | Key Fields | Notes |
|---|---|---|
| `Product` | `id, title, price, description, category, image, rating` | Immutable (`const` ctor), `Rating?` |
| `Rating` | `rate, count` | Nested in `Product` |
| `CartItem` | `product: Product, quantity` | `subtotal` getter = `price * quantity` |
| `Customer` | `id, email, username, name, phone, address?` | From REST API |
| `Address` | `city, street, number, zipcode, geolocation?` | Nested in `Customer` |
| `GeoLocation` | `lat, long` | Nested in `Address` |
| `Order` | `id?, orderNumber, customerId, customerName, orderDate, totalQuantity, totalAmount, items` | Persisted in SQLite |
| `OrderItem` | `id?, orderId?, productId, productName, productImage, unitPrice, quantity, subtotal` | Child of `Order` |

---

## 6. State Management (Cubits)

Each feature owns a **Cubit** (business logic) and an immutable **State** class.

| Cubit | Responsibility | Emits State |
|---|---|---|
| `PosCubit` | Load products/categories, filter by category, search | `PosState` |
| `CartCubit` | Add/remove/update cart items, select customer, checkout | `CartState` |
| `DashboardCubit` | Load total sales + total orders (parallel) | `DashboardState` |
| `CustomerCubit` | Load & filter customers | `CustomerState` |
| `OrderListCubit` | Load persisted orders | `OrderListState` |

States expose `copyWith(...)`, convenience getters (`isLoading`, `totalQuantity`,
`totalAmount`, `canCheckOut`), and an `error` field for failure handling.

---

## 7. Services

### ApiService (`Dio`)
- `getAllProducts()` → `GET /products`
- `getCategories()` → `GET /products/categories`
- `getProductsByCategory(cat)` → `GET /products/category/$cat`
- `getAllCustomers()` → `GET /users`

### DatabaseService (`sqflite`)
- `insertOrder(Order)` → inserts into `orders` + child `order_items`
- `getAllOrders()` → reconstructs `Order` with `items`
- `getTotalSales()` → `SUM(total_amount)`
- `getOrderCount()` → `COUNT(*)`

Tables:

```sql
orders (
  id INTEGER PK AUTOINCREMENT,
  order_number INTEGER,
  customer_id INTEGER,
  customer_name TEXT,
  order_date TEXT,
  total_quantity INTEGER,
  total_amount REAL
)

order_items (
  id INTEGER PK AUTOINCREMENT,
  order_id INTEGER FK → orders.id ON DELETE CASCADE,
  product_id INTEGER,
  product_name TEXT,
  product_image TEXT,
  unit_price REAL,
  quantity INTEGER,
  subtotal REAL
)
```

ER diagram: `docs/diagrams/er_diagram.png`.
Class diagram: `docs/diagrams/class_diagram.png` (also `class_diagram.puml`).

---

## 8. Screens & Features

| Route | Screen | Highlights |
|---|---|---|
| `/` | DashboardScreen | Total Sales / Total Orders cards, navigation to features |
| `/pos` | PosScreen | Category filter, product grid, cart badge, add-to-cart |
| `/cart` | CartScreen | Cart items, customer selection, checkout |
| `/customer-selection` | CustomerSelectionScreen | Search & pick a customer |
| `/orders` | OrderListScreen | List of placed orders |

### Theming
`AppTheme.lightTheme` provides a consistent Material 3 look. Centralized colors
(`accentColor`, `successColor`, `errorColor`, etc.) are reused across widgets to
avoid hardcoded hex values.

---

## 9. Dependency Injection

`lib/locator/locator.dart` registers singletons with **GetIt**:

```dart
getIt.registerSingleton<Dio>(Dio(BaseOptions(baseUrl: ApiConstants.baseUrl, ...)));
getIt.registerSingleton<DatabaseService>(DatabaseService());
getIt.registerSingleton<ApiService>(ApiService());
```

Cubits/Widgets resolve dependencies via `getIt.get<T>()`.

---

## 10. Build & Run

```bash
# Prerequisites: Flutter SDK (>= 3.x), Dart (>= 3.12.2)

flutter pub get
flutter run                 # run on connected device / emulator
flutter run -d chrome      # run on web

# Build release artifacts
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release

# Static analysis & tests
flutter analyze
flutter test
```

---

## 11. Code Quality Notes

The codebase was refactored for clean code and quality:
- Removed `print`/debug statements and redundant code.
- Enforced a single theme source (`AppTheme`) instead of repeated hex colors.
- Fixed unnecessary widget rebuilds (`ProductGrid` uses `BlocSelector` instead of
  `context.watch<CartCubit>()`).
- Removed dead code (e.g., unused `PosState.cart` parameter, duplicate cart methods).
- Made models immutable and type-safe (`fromJson`/`toJson`/`copyWith`).
- Added null-safety to aggregation queries in `DatabaseService`.

---

## 12. Diagrams (for Project Report)

| Diagram | File |
|---|---|
| Architecture (layered) | `docs/diagrams/architecture_diagram.png` |
| Entity Relationship | `docs/diagrams/er_diagram.png` |
| Class Diagram (PlantUML) | `docs/diagrams/class_diagram.png` / `class_diagram.puml` |
