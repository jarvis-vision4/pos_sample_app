from __future__ import annotations

import math
import textwrap
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFont


OUT_DIR = Path(__file__).resolve().parent


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Supplemental/Helvetica Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Helvetica.ttf",
        "/Library/Fonts/Arial Bold.ttf" if bold else "/Library/Fonts/Arial.ttf",
    ]
    for candidate in candidates:
        try:
            return ImageFont.truetype(candidate, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


TITLE = font(48, True)
SUBTITLE = font(24)
GROUP = font(28, True)
BOX_TITLE = font(23, True)
BOX_TEXT = font(19)
SMALL = font(16)
TINY = font(14)

INK = "#172033"
MUTED = "#526070"
CANVAS = "#f7f9fc"
WHITE = "#ffffff"
BLUE = "#dceeff"
BLUE_DARK = "#2f6fed"
GREEN = "#def7e8"
GREEN_DARK = "#159456"
ORANGE = "#fff0d3"
ORANGE_DARK = "#d88911"
PURPLE = "#eee7ff"
PURPLE_DARK = "#7c55d9"
RED = "#ffe3e1"
RED_DARK = "#c94b42"
GRAY = "#edf1f6"
GRAY_DARK = "#7a8491"


@dataclass
class Box:
    x: int
    y: int
    w: int
    h: int
    title: str
    lines: list[str]
    fill: str = WHITE
    stroke: str = BLUE_DARK
    title_color: str = INK

    @property
    def center(self) -> tuple[int, int]:
        return (self.x + self.w // 2, self.y + self.h // 2)

    @property
    def top(self) -> tuple[int, int]:
        return (self.x + self.w // 2, self.y)

    @property
    def bottom(self) -> tuple[int, int]:
        return (self.x + self.w // 2, self.y + self.h)

    @property
    def left(self) -> tuple[int, int]:
        return (self.x, self.y + self.h // 2)

    @property
    def right(self) -> tuple[int, int]:
        return (self.x + self.w, self.y + self.h // 2)


def new_canvas(width: int, height: int, title: str, subtitle: str) -> tuple[Image.Image, ImageDraw.ImageDraw]:
    image = Image.new("RGB", (width, height), CANVAS)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((30, 30, width - 30, height - 30), radius=28, fill="#fbfcff", outline="#d9e0eb", width=2)
    draw.text((70, 58), title, fill=INK, font=TITLE)
    draw.text((72, 118), subtitle, fill=MUTED, font=SUBTITLE)
    return image, draw


def draw_group(draw: ImageDraw.ImageDraw, xy: tuple[int, int, int, int], label: str, color: str) -> None:
    x1, y1, x2, y2 = xy
    draw.rounded_rectangle(xy, radius=22, fill=color, outline="#cfd8e5", width=2)
    draw.text((x1 + 26, y1 + 18), label, fill=INK, font=GROUP)


def wrapped_lines(text: str, max_chars: int) -> list[str]:
    out: list[str] = []
    for raw in text.splitlines():
        if not raw:
            out.append("")
            continue
        out.extend(textwrap.wrap(raw, width=max_chars, break_long_words=False))
    return out


def draw_box(draw: ImageDraw.ImageDraw, box: Box, max_chars: int = 34) -> None:
    shadow = (box.x + 5, box.y + 6, box.x + box.w + 5, box.y + box.h + 6)
    draw.rounded_rectangle(shadow, radius=14, fill="#d9e2ee")
    draw.rounded_rectangle((box.x, box.y, box.x + box.w, box.y + box.h), radius=14, fill=box.fill, outline=box.stroke, width=3)
    draw.text((box.x + 20, box.y + 16), box.title, fill=box.title_color, font=BOX_TITLE)
    draw.line((box.x + 18, box.y + 50, box.x + box.w - 18, box.y + 50), fill=box.stroke, width=2)
    y = box.y + 64
    for line in box.lines:
        for wrapped in wrapped_lines(line, max_chars):
            draw.text((box.x + 20, y), wrapped, fill=INK if not wrapped.startswith("-") else MUTED, font=BOX_TEXT)
            y += 25


def draw_table(draw: ImageDraw.ImageDraw, box: Box, fields: list[tuple[str, str]], max_chars: int = 32) -> None:
    draw_box(draw, Box(box.x, box.y, box.w, box.h, box.title, [], box.fill, box.stroke), max_chars=max_chars)
    y = box.y + 64
    for idx, (prefix, text) in enumerate(fields):
        fill = "#fff7e7" if prefix == "PK" else "#edf9f1" if prefix == "FK" else "#f8fafc"
        outline = ORANGE_DARK if prefix == "PK" else GREEN_DARK if prefix == "FK" else "#cad4e2"
        draw.rounded_rectangle((box.x + 18, y, box.x + 64, y + 25), radius=6, fill=fill, outline=outline, width=1)
        draw.text((box.x + 29, y + 3), prefix, fill=outline, font=SMALL)
        draw.text((box.x + 78, y + 2), text, fill=INK, font=BOX_TEXT)
        y += 31
        if idx in {0, 6}:
            draw.line((box.x + 18, y - 4, box.x + box.w - 18, y - 4), fill="#d9e0eb", width=1)


def arrow(draw: ImageDraw.ImageDraw, start: tuple[int, int], end: tuple[int, int], color: str = "#44546a", width: int = 3, label: str | None = None) -> None:
    draw.line((start, end), fill=color, width=width)
    angle = math.atan2(end[1] - start[1], end[0] - start[0])
    head = 14
    left = (end[0] - head * math.cos(angle - math.pi / 6), end[1] - head * math.sin(angle - math.pi / 6))
    right = (end[0] - head * math.cos(angle + math.pi / 6), end[1] - head * math.sin(angle + math.pi / 6))
    draw.polygon([end, left, right], fill=color)
    if label:
        lx = (start[0] + end[0]) // 2
        ly = (start[1] + end[1]) // 2
        bbox = draw.textbbox((0, 0), label, font=SMALL)
        pad = 7
        draw.rounded_rectangle((lx - (bbox[2] - bbox[0]) // 2 - pad, ly - 16, lx + (bbox[2] - bbox[0]) // 2 + pad, ly + 10), radius=7, fill="#fbfcff", outline="#ccd6e3")
        draw.text((lx - (bbox[2] - bbox[0]) // 2, ly - 13), label, fill=color, font=SMALL)


def elbow_arrow(draw: ImageDraw.ImageDraw, points: Iterable[tuple[int, int]], color: str = "#44546a", label: str | None = None) -> None:
    pts = list(points)
    for first, second in zip(pts, pts[1:-1]):
        draw.line((first, second), fill=color, width=3)
    arrow(draw, pts[-2], pts[-1], color=color, width=3, label=label)


def save(image: Image.Image, filename: str) -> None:
    path = OUT_DIR / filename
    image.save(path, "PNG", optimize=True)
    print(f"generated {path}")


def architecture_diagram() -> None:
    image, draw = new_canvas(
        2800,
        1900,
        "Project Architecture Diagram",
        "POS Sample App mobile architecture - Flutter, Cubit state, FakeStore API, and local SQLite storage",
    )

    draw_group(draw, (85, 190, 2715, 430), "Client and Application Shell", "#eef5ff")
    draw_group(draw, (85, 490, 2715, 795), "Presentation Layer", "#eefbf3")
    draw_group(draw, (85, 855, 2715, 1125), "State Management Layer", "#fff8ea")
    draw_group(draw, (85, 1185, 2715, 1475), "Data and Service Layer", "#f4efff")
    draw_group(draw, (85, 1515, 2715, 1810), "External and Device Storage", "#fff0ef")

    user = Box(165, 260, 350, 115, "Mobile User", ["Runs Android or iOS app", "Uses POS, cart, orders"], BLUE, BLUE_DARK)
    app = Box(655, 245, 520, 145, "Flutter App Shell", ["main.dart initializes Flutter", "MyPosApp + MaterialApp", "AppTheme.lightTheme"], WHITE, BLUE_DARK)
    router = Box(1320, 245, 485, 145, "Routing", ["AppRouter.onGenerateRoute", "AppRoutes: /, /pos, /cart", "/customer-selection, /orders"], WHITE, BLUE_DARK)
    di = Box(1950, 245, 540, 145, "Dependency Injection", ["GetIt service locator", "Registers Dio, ApiService", "Registers DatabaseService"], WHITE, BLUE_DARK)

    screens = [
        Box(150, 575, 420, 145, "DashboardScreen", ["Sales summary", "POS and Orders navigation"], GREEN, GREEN_DARK),
        Box(650, 575, 420, 145, "PosScreen", ["Category filter", "Product grid, cart badge"], GREEN, GREEN_DARK),
        Box(1150, 575, 420, 145, "CartScreen", ["Cart items, customer", "Checkout and clear cart"], GREEN, GREEN_DARK),
        Box(1650, 575, 420, 145, "CustomerSelection", ["Search users", "Select customer"], GREEN, GREEN_DARK),
        Box(2150, 575, 420, 145, "OrderListScreen", ["Saved orders list", "Order cards"], GREEN, GREEN_DARK),
    ]

    cubits = [
        Box(150, 930, 420, 130, "DashboardCubit", ["loadDashboardData", "DashboardState"], ORANGE, ORANGE_DARK),
        Box(650, 930, 420, 130, "PosCubit", ["loadProducts/categories", "selectCategory"], ORANGE, ORANGE_DARK),
        Box(1150, 930, 420, 130, "CartCubit", ["add/remove/update cart", "setCustomer, checkout"], ORANGE, ORANGE_DARK),
        Box(1650, 930, 420, 130, "CustomerCubit", ["loadCustomers", "filterCustomers"], ORANGE, ORANGE_DARK),
        Box(2150, 930, 420, 130, "OrderListCubit", ["loadOrders", "OrderListState"], ORANGE, ORANGE_DARK),
    ]

    api = Box(465, 1260, 500, 155, "ApiService", ["Dio REST calls", "Products, categories, users"], PURPLE, PURPLE_DARK)
    db = Box(1190, 1260, 500, 155, "DatabaseService", ["sqflite database", "Insert/read orders", "Dashboard aggregates"], PURPLE, PURPLE_DARK)
    models = Box(1915, 1260, 500, 155, "Models and Utilities", ["Product, Customer, CartItem", "Order, OrderItem, PriceFormat"], PURPLE, PURPLE_DARK)

    fake = Box(465, 1595, 500, 135, "FakeStore API", ["External REST data source", "/products, /users"], RED, RED_DARK)
    sqlite = Box(1190, 1595, 500, 135, "Local SQLite DB", ["orders table", "order_items table"], RED, RED_DARK)
    device = Box(1915, 1595, 500, 135, "Device Runtime", ["Android / iOS", "Local app sandbox"], RED, RED_DARK)

    for box in [user, app, router, di, *screens, *cubits, api, db, models, fake, sqlite, device]:
        draw_box(draw, box)

    arrow(draw, user.right, app.left, BLUE_DARK, label="opens")
    arrow(draw, app.right, router.left, BLUE_DARK, label="routes")
    arrow(draw, router.right, di.left, BLUE_DARK, label="uses")
    for screen, cubit in zip(screens, cubits):
        arrow(draw, screen.bottom, cubit.top, GREEN_DARK, label="BlocBuilder")
    arrow(draw, cubits[1].bottom, api.top, ORANGE_DARK, label="fetch")
    arrow(draw, cubits[3].bottom, api.top, ORANGE_DARK, label="fetch")
    arrow(draw, cubits[2].bottom, db.top, ORANGE_DARK, label="checkout")
    arrow(draw, cubits[0].bottom, db.top, ORANGE_DARK, label="summary")
    arrow(draw, cubits[4].bottom, db.top, ORANGE_DARK, label="orders")
    arrow(draw, api.bottom, fake.top, PURPLE_DARK, label="HTTP")
    arrow(draw, db.bottom, sqlite.top, PURPLE_DARK, label="CRUD")
    arrow(draw, models.bottom, device.top, PURPLE_DARK, label="Dart objects")
    draw.text((1968, 402), "Services are resolved by Cubits through GetIt", fill=MUTED, font=SMALL)

    save(image, "architecture_diagram.png")


def er_diagram() -> None:
    image, draw = new_canvas(
        2500,
        1650,
        "Entity Relationship Design",
        "Database schema and external entities used by the POS checkout flow",
    )

    draw.text((100, 190), "Persisted SQLite entities", fill=INK, font=GROUP)
    orders = Box(165, 260, 760, 410, "orders", [], BLUE, BLUE_DARK)
    order_items = Box(1560, 260, 760, 455, "order_items", [], GREEN, GREEN_DARK)
    draw_table(draw, orders, [
        ("PK", "id INTEGER AUTOINCREMENT"),
        ("", "order_number INTEGER NOT NULL"),
        ("", "customer_id INTEGER NOT NULL"),
        ("", "customer_name TEXT NOT NULL"),
        ("", "order_date TEXT NOT NULL"),
        ("", "total_quantity INTEGER NOT NULL"),
        ("", "total_amount REAL NOT NULL"),
    ])
    draw_table(draw, order_items, [
        ("PK", "id INTEGER AUTOINCREMENT"),
        ("FK", "order_id INTEGER -> orders.id"),
        ("", "product_id INTEGER NOT NULL"),
        ("", "product_name TEXT NOT NULL"),
        ("", "product_image TEXT NOT NULL"),
        ("", "unit_price REAL NOT NULL"),
        ("", "quantity INTEGER NOT NULL"),
        ("", "subtotal REAL NOT NULL"),
    ])

    arrow(draw, orders.right, order_items.left, BLUE_DARK, label="1 order has many order_items")
    draw.text((1035, 425), "1", fill=BLUE_DARK, font=BOX_TITLE)
    draw.text((1455, 425), "N", fill=GREEN_DARK, font=BOX_TITLE)

    draw.text((100, 805), "API-backed entities used before checkout", fill=INK, font=GROUP)
    customer = Box(165, 880, 660, 315, "Customer (FakeStore /users)", [
        "+ id: int",
        "+ email: String",
        "+ username: String",
        "+ name: String",
        "+ phone: String",
        "+ address: Address?",
    ], PURPLE, PURPLE_DARK)
    product = Box(1015, 880, 660, 355, "Product (FakeStore /products)", [
        "+ id: int",
        "+ title: String",
        "+ price: num",
        "+ description: String",
        "+ category: String",
        "+ image: String",
        "+ rating: Rating?",
    ], ORANGE, ORANGE_DARK)
    cart = Box(1865, 880, 460, 230, "CartItem (in memory)", [
        "+ product: Product",
        "+ quantity: int",
        "+ subtotal: num",
    ], GRAY, GRAY_DARK)

    for box in [customer, product, cart]:
        draw_box(draw, box)

    arrow(draw, product.right, cart.left, ORANGE_DARK, label="selected product")
    elbow_arrow(draw, [customer.top, (customer.center[0], 790), (orders.center[0], 790), orders.bottom], PURPLE_DARK, label="customer snapshot")
    elbow_arrow(draw, [cart.top, (cart.center[0], 790), (order_items.center[0], 790), order_items.bottom], ORANGE_DARK, label="cart lines persisted")

    note = Box(420, 1325, 1660, 150, "Design Note", [
        "Products and customers are read from the FakeStore API.",
        "During checkout, customer and product display data are copied into SQLite order records so past sales remain readable offline.",
    ], WHITE, GRAY_DARK)
    draw_box(draw, note, max_chars=100)

    save(image, "er_diagram.png")


def class_box(draw: ImageDraw.ImageDraw, box: Box, attrs: list[str], methods: list[str], max_chars: int = 32) -> None:
    draw.rounded_rectangle((box.x + 5, box.y + 6, box.x + box.w + 5, box.y + box.h + 6), radius=12, fill="#d9e2ee")
    draw.rounded_rectangle((box.x, box.y, box.x + box.w, box.y + box.h), radius=12, fill=box.fill, outline=box.stroke, width=3)
    draw.text((box.x + 16, box.y + 12), box.title, fill=INK, font=BOX_TITLE)
    y = box.y + 45
    draw.line((box.x + 14, y, box.x + box.w - 14, y), fill=box.stroke, width=2)
    y += 10
    for attr in attrs:
        for wrapped in wrapped_lines(attr, max_chars):
            draw.text((box.x + 16, y), wrapped, fill=INK, font=SMALL)
            y += 21
    y += 4
    draw.line((box.x + 14, y, box.x + box.w - 14, y), fill="#cfd8e5", width=1)
    y += 10
    for method in methods:
        for wrapped in wrapped_lines(method, max_chars):
            draw.text((box.x + 16, y), wrapped, fill=MUTED, font=SMALL)
            y += 21


def class_diagram() -> None:
    image, draw = new_canvas(
        3300,
        2300,
        "Class Diagram",
        "Core Dart classes, state classes, service dependencies, and model relationships",
    )

    draw_group(draw, (80, 185, 3220, 455), "Application Shell", "#eef5ff")
    my_app = Box(140, 260, 430, 140, "MyPosApp", [], BLUE, BLUE_DARK)
    router = Box(720, 260, 430, 140, "AppRouter", [], BLUE, BLUE_DARK)
    routes = Box(1300, 260, 430, 140, "AppRoutes", [], BLUE, BLUE_DARK)
    locator = Box(1880, 260, 500, 140, "GetIt Locator", [], BLUE, BLUE_DARK)
    theme = Box(2530, 260, 430, 140, "AppTheme", [], BLUE, BLUE_DARK)
    for box, attrs, methods in [
        (my_app, ["+ build(context): Widget"], ["creates MultiBlocProvider", "creates MaterialApp"]),
        (router, [], ["+ onGenerateRoute(settings): Route"]),
        (routes, ["+ dashboard", "+ pos", "+ cart", "+ customerSelection", "+ orders"], []),
        (locator, ["+ getIt: GetIt"], ["+ setUpLocator(): Future<void>"]),
        (theme, ["+ lightTheme: ThemeData"], []),
    ]:
        class_box(draw, box, attrs, methods)

    draw_group(draw, (80, 520, 3220, 1000), "Cubits and State", "#fff8ea")
    cubit_boxes = [
        (Box(140, 605, 430, 315, "DashboardCubit", [], ORANGE, ORANGE_DARK), ["- _databaseService"], ["+ loadDashboardData()"]),
        (Box(720, 605, 430, 315, "PosCubit", [], ORANGE, ORANGE_DARK), ["- _apiService"], ["+ loadProducts()", "+ loadCategories()", "+ selectCategory(category)"]),
        (Box(1300, 605, 430, 315, "CartCubit", [], ORANGE, ORANGE_DARK), ["- _databaseService"], ["+ addToCart(product)", "+ removeFromCart(productId)", "+ increase/decreaseQuantity()", "+ setCustomer(customer)", "+ checkout()"]),
        (Box(1880, 605, 430, 315, "CustomerCubit", [], ORANGE, ORANGE_DARK), ["- _apiService"], ["+ loadCustomers()", "+ filterCustomers(query)"]),
        (Box(2460, 605, 430, 315, "OrderListCubit", [], ORANGE, ORANGE_DARK), ["- _databaseService"], ["+ loadOrders()"]),
    ]
    state_boxes = [
        (Box(140, 1060, 430, 230, "DashboardState", [], WHITE, ORANGE_DARK), ["+ totalSales", "+ totalCount", "+ isLoading", "+ error"], ["+ copyWith()"]),
        (Box(720, 1060, 430, 270, "PosState", [], WHITE, ORANGE_DARK), ["+ products", "+ filteredProducts", "+ categories", "+ selectedCategory", "+ isLoading", "+ error"], ["+ copyWith()"]),
        (Box(1300, 1060, 430, 270, "CartState", [], WHITE, ORANGE_DARK), ["+ items", "+ selectedCustomer", "+ isCheckingOut", "+ checkoutSuccess"], ["+ totalQuantity", "+ totalAmount", "+ canCheckOut", "+ copyWith()"]),
        (Box(1880, 1060, 430, 250, "CustomerState", [], WHITE, ORANGE_DARK), ["+ customers", "+ filteredCustomers", "+ isLoading", "+ error", "+ searchQuery"], ["+ copyWith()"]),
        (Box(2460, 1060, 430, 230, "OrderListState", [], WHITE, ORANGE_DARK), ["+ isLoading", "+ error", "+ orders"], ["+ copyWith()"]),
    ]
    for box, attrs, methods in [*cubit_boxes, *state_boxes]:
        class_box(draw, box, attrs, methods)

    for (cubit, _, _), (state, _, _) in zip(cubit_boxes, state_boxes):
        arrow(draw, cubit.bottom, state.top, ORANGE_DARK, label="emits")

    draw_group(draw, (80, 1390, 1550, 2125), "Data Models", "#eefbf3")
    model_specs = [
        (Box(140, 1470, 385, 315, "Product", [], GREEN, GREEN_DARK), ["+ id", "+ title", "+ price", "+ description", "+ category", "+ image", "+ rating"], ["+ fromJson()", "+ toJson()", "+ copyWith()"]),
        (Box(590, 1470, 330, 175, "Rating", [], WHITE, GREEN_DARK), ["+ rate", "+ count"], ["+ fromJson()", "+ toJson()"]),
        (Box(985, 1470, 385, 190, "CartItem", [], GREEN, GREEN_DARK), ["+ product", "+ quantity", "+ subtotal"], ["+ copyWith()"]),
        (Box(140, 1810, 385, 270, "Customer", [], PURPLE, PURPLE_DARK), ["+ id", "+ email", "+ username", "+ name", "+ phone", "+ address"], ["+ fromJson()", "+ toJson()"]),
        (Box(590, 1810, 330, 210, "Address", [], WHITE, PURPLE_DARK), ["+ city", "+ street", "+ number", "+ zipcode", "+ geolocation"], ["+ fromJson()"]),
        (Box(985, 1810, 330, 155, "GeoLocation", [], WHITE, PURPLE_DARK), ["+ lat", "+ long"], ["+ fromJson()"]),
    ]
    for box, attrs, methods in model_specs:
        class_box(draw, box, attrs, methods)
    arrow(draw, model_specs[0][0].right, model_specs[1][0].left, GREEN_DARK, label="has")
    arrow(draw, model_specs[2][0].left, model_specs[0][0].right, GREEN_DARK, label="contains")
    arrow(draw, model_specs[3][0].right, model_specs[4][0].left, PURPLE_DARK, label="has")
    arrow(draw, model_specs[4][0].right, model_specs[5][0].left, PURPLE_DARK, label="has")

    draw_group(draw, (1650, 1390, 3220, 2125), "Persistence Models and Services", "#f4efff")
    order = Box(1710, 1470, 430, 335, "Order", [], PURPLE, PURPLE_DARK)
    order_item = Box(2220, 1470, 430, 335, "OrderItem", [], PURPLE, PURPLE_DARK)
    api = Box(1710, 1830, 430, 230, "ApiService", [], RED, RED_DARK)
    db = Box(2220, 1830, 500, 250, "DatabaseService", [], RED, RED_DARK)
    dio = Box(2810, 1830, 330, 160, "Dio", [], WHITE, RED_DARK)
    for box, attrs, methods in [
        (order, ["+ id", "+ orderNumber", "+ customerId", "+ customerName", "+ orderDate", "+ totalQuantity", "+ totalAmount", "+ items"], ["+ toMap()", "+ fromMap()", "+ copyWith()"]),
        (order_item, ["+ id", "+ orderId", "+ productId", "+ productName", "+ productImage", "+ unitPrice", "+ quantity", "+ subtotal"], ["+ toMap()", "+ fromMap()", "+ copyWith()"]),
        (api, ["- _dio"], ["+ getAllProducts()", "+ getCategories()", "+ getProductsByCategory()", "+ getAllCustomers()"]),
        (db, ["- _database", "+ tableOrders", "+ tableOrderItems"], ["+ insertOrder(order)", "+ getAllOrders()", "+ getTotalSales()", "+ getOrderCount()"]),
        (dio, ["HTTP client"], ["GET FakeStore API"]),
    ]:
        class_box(draw, box, attrs, methods)
    arrow(draw, order.right, order_item.left, PURPLE_DARK, label="1..*")
    draw.text((976, 1358), "State contents: PosState holds Product lists; CartState holds CartItem and Customer; OrderListState holds Order records.", fill=MUTED, font=SMALL)
    draw.text((1888, 2148), "Dependencies: PosCubit and CustomerCubit use ApiService. DashboardCubit, CartCubit, and OrderListCubit use DatabaseService. GetIt registers Dio, ApiService, and DatabaseService.", fill=MUTED, font=SMALL)

    save(image, "class_diagram.png")


if __name__ == "__main__":
    architecture_diagram()
    er_diagram()
    class_diagram()
