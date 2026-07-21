import '../../../../data/models/cart_item.dart';
import '../../../../data/models/product.dart';

class PosState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final String? selectedCategory;
  final List<CartItem> cart;
  final bool isLoadingProducts;
  final bool isLoadingCategories;
  final String? error;

  const PosState({
    this.products = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory,
    this.cart = const [],
    this.isLoadingProducts = false,
    this.isLoadingCategories = false,
    this.error,
  });
  PosState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    bool clearCategory = false,
    List<CartItem>? cart,
    bool? isLoadingProducts,
    bool? isLoadingCategories,
    String? error,
  }) {
    return PosState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      cart: cart ?? this.cart,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      error: error ?? this.error,
    );
  }
}