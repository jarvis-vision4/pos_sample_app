import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/locator/locator.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/customer_selection/cubit/customer_cubit.dart';
import 'package:pos_sample_app/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:pos_sample_app/presentation/screens/order_list/cubit/order_list_cubit.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_cubit.dart';
import 'package:pos_sample_app/routes/app_router.dart';
import 'package:pos_sample_app/routes/app_routes.dart';
import 'package:pos_sample_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const MyPosApp());
}

class MyPosApp extends StatelessWidget {
  const MyPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardCubit()),
        BlocProvider(create: (_) => PosCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => CustomerCubit()),
        BlocProvider(create: (_) => OrderListCubit()),
      ],
      child: MaterialApp(
        title: 'POS Sample App',
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRouter.onGenerateRoute,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
