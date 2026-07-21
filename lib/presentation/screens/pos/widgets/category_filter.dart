import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_state.dart';

import '../cubit/pos_cubit.dart';

class CategoryFilter extends StatelessWidget {
  final PosState state;
  const CategoryFilter({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: FilterChip(
              checkmarkColor: Colors.white,
              label: const Text('All'),
              selected: state.selectedCategory == null,
              onSelected: (_) {
                context.read<PosCubit>().selectCategory(null);
              },
              selectedColor: const Color(0xFF0984E3),
              labelStyle: TextStyle(
                color: state.selectedCategory == null
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
          ...state.categories.map((category) {
            final isSelected = state.selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: FilterChip(
                checkmarkColor: Colors.white,
                label: Text(category[0].toUpperCase() + category.substring(1)),
                selected: isSelected,
                onSelected: (_) {
                  context.read<PosCubit>().selectCategory(category);
                },
                selectedColor: const Color(0xFF0984E3),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
