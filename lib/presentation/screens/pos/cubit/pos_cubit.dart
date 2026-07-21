import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/data/services/api_service.dart';

import 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final ApiService _apiService = GetIt.I.get<ApiService>();

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
      emit(state.copyWith(
        categories: categories,
        isLoadingCategories: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingCategories: false));
    }
  }
}
