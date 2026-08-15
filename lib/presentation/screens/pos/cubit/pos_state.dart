import '../../../../data/models/product.dart';

class PosState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final String? selectedCategory;
  final bool isLoadingProducts;
  final bool isLoadingCategories;
  final String? error;

  const PosState({
    this.products = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory,
    this.isLoadingProducts = false,
    this.isLoadingCategories = false,
    this.error,
  });

  bool get isLoading => isLoadingProducts || isLoadingCategories;

  PosState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    bool clearCategory = false,
    bool? isLoadingProducts,
    bool? isLoadingCategories,
    String? error,
    bool clearError = false,
  }) {
    return PosState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
