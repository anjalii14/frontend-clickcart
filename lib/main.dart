import 'dart:developer';

import 'package:clickcart/core/routes.dart';
import 'package:clickcart/core/ui.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:clickcart/logic/cubits/category_cubit/category_cubit.dart';
import 'package:clickcart/logic/cubits/order_cubit/order_cubit.dart';
import 'package:clickcart/logic/cubits/product_cubit/product_cubit.dart';
import 'package:clickcart/logic/cubits/user_cubit/user_cubit.dart';
import 'package:clickcart/presentation/screens/auth/login_screen.dart';
import 'package:clickcart/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => ProductCubit()),

        BlocProvider(create: (context) => CartCubit(
          BlocProvider.of<UserCubit>(context)
        )),

        BlocProvider(create: (context) => OrderCubit(
          BlocProvider.of<UserCubit>(context),
          BlocProvider.of<CartCubit>(context),
        )),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.defaultTheme,
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: SplashScreen.routeName
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log("Created: $bloc");
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Change in $bloc: $change");
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("Change in $bloc: $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    log("Closed: $bloc");
    super.onClose(bloc);
  }
}