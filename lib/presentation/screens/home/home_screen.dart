import 'package:clickcart/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_state.dart';
import 'package:clickcart/logic/cubits/user_cubit/user_cubit.dart';
import 'package:clickcart/logic/cubits/user_cubit/user_state.dart';
import 'package:clickcart/presentation/screens/cart/cart_screen.dart';
import 'package:clickcart/presentation/screens/home/category_screen.dart';
import 'package:clickcart/presentation/screens/home/profile_screen.dart';
import 'package:clickcart/presentation/screens/home/user_feed_screen.dart';
import 'package:clickcart/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clickcart/core/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int currentIndex = 0;
  List<Widget> screens = const [
    UserFeedScreen(),
    CategoryScreen(),
    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if(state is UserLoggedOutState) {
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
            elevation: 0,
            title: Text("ClickCart", style: TextStyle(
            color: Colors.white,
            fontFamily: 'YourDesiredFont',
            fontSize: 24,
            shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                  ],
                ),
            ),
          shape: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            backgroundColor: AppColors.accent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return Badge(
                    label: Text("${state.items.length}"),
                    isLabelVisible: (state is CartLoadingState) ? false : true,
                    child: const Icon(
                      CupertinoIcons.cart_fill,
                      color: Colors.white,
                    ),

                  );
                }
              )
            ),
          ],
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
    
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.storefront,),
              label: "Categories"
            ),
    
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
            ),


            // BottomNavigationBarItem(
            //     icon: Icon(Icons.person),
            //     label: "Profile"
            // ),
          ],
        ),
      ),
    );
  }
}