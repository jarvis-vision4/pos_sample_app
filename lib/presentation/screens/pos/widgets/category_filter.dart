import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/theme/app_theme.dart';
import '../cubit/pos_cubit.dart';
import '../cubit/pos_state.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key, required this.state});

  final PosState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _FilterChip(
            label: 'All',
            isSelected: state.selectedCategory == null,
            onSelected: () => context.read<PosCubit>().selectCategory(null),
          ),
          ...state.categories.map((category) => _FilterChip(
            label: category.isEmpty ? category : '${category[0].toUpperCase()}${category.substring(1)}',
            isSelected: state.selectedCategory == category,
            onSelected: () => context.read<PosCubit>().selectCategory(category),
          )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: FilterChip(
        checkmarkColor: Colors.white,
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: AppTheme.accentColor,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
      ),
    );
  }
}
