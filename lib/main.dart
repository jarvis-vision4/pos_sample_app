import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/locator/locator.dart';
import 'package:pos_sample_app/presentation/screens/cart/cart_screen.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_cubit.dart';
import 'package:pos_sample_app/presentation/screens/pos/pos_screen.dart';
import 'package:pos_sample_app/routes/app_router.dart';
import 'package:pos_sample_app/routes/app_routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => PosCubit(),
            child: PosScreen(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
          child: CartScreen(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRouter.onGenerateRoute,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

