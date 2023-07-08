import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickcart/core/ui.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_state.dart';
import 'package:clickcart/logic/services/calculations.dart';
import 'package:clickcart/logic/services/formatter.dart';
import 'package:clickcart/presentation/screens/order/order_detail_screen.dart';
import 'package:clickcart/presentation/widgets/cart_list_view.dart';
import 'package:clickcart/presentation/widgets/link_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = "cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Cart", style: TextStyle(
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
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {

            if(state is CartLoadingState && state.items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if(state is CartErrorState && state.items.isEmpty) {
              return Center(
                child: Text(state.message),
              );
            }

            if(state is CartLoadedState && state.items.isEmpty) {
              return const Center(
                child: Text("Cart items will show up here..")
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CartListView(items: state.items),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.items.length} items",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total: ${Formatter.formatPrice(Calculations.cartTotal(state.items))}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, OrderDetailScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Place Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

          }
        ),
      ),
    );
  }
}