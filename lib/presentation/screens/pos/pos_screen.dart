import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_cubit.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_state.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosCubit>().loadCategories();
      context.read<PosCubit>().loadProducts();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POS Screen"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: BlocBuilder<PosCubit,PosState>(builder: (context, state) {
        if (state.isLoadingCategories && state.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }
       return Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(category),
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {

                    final product = state.products[index];
                    print(state.products);
                    return Card(
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.image ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.title ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        );
      })
    );
  }
}
