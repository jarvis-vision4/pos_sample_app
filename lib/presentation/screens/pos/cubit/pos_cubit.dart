import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/services/api_service.dart';
import '../../../../locator/locator.dart';
import 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final ApiService _apiService = getIt.get<ApiService>();

  PosCubit() : super(const PosState());

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoadingProducts: true, error: null));
    try {
      final products = await _apiService.getAllProducts();
      emit(
        state.copyWith(
          products: products,
          filteredProducts: products,
          isLoadingProducts: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingProducts: false, error: e.toString()));
    }
  }

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));
    try {
      final categories = await _apiService.getCategories();
      emit(state.copyWith(categories: categories, isLoadingCategories: false));
    } catch (e) {
      emit(state.copyWith(isLoadingCategories: false));
    }
  }

  void selectCategory(String? category) {
    if (category == null || category == state.selectedCategory) {
      emit(
        state.copyWith(filteredProducts: state.products, clearCategory: true),
      );
    } else {
      final filtered = state.products
          .where((p) => p.category?.toLowerCase() == category.toLowerCase())
          .toList();
      emit(
        state.copyWith(filteredProducts: filtered, selectedCategory: category),
      );
    }
  }


}
