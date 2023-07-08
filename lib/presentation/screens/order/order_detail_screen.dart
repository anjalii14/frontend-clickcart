import 'dart:developer';

import 'package:clickcart/core/ui.dart';
import 'package:clickcart/data/models/order/order_model.dart';
import 'package:clickcart/data/models/user/user_model.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:clickcart/logic/cubits/cart_cubit/cart_state.dart';
import 'package:clickcart/logic/cubits/order_cubit/order_cubit.dart';
import 'package:clickcart/logic/cubits/user_cubit/user_cubit.dart';
import 'package:clickcart/logic/cubits/user_cubit/user_state.dart';
import 'package:clickcart/logic/services/razorpay.dart';
import 'package:clickcart/presentation/screens/order/order_placed_screen.dart';
import 'package:clickcart/presentation/screens/order/providers/order_detail_provider.dart';
import 'package:clickcart/presentation/screens/user/edit_profile_screen.dart';
import 'package:clickcart/presentation/widgets/cart_list_view.dart';
import 'package:clickcart/presentation/widgets/gap_widget.dart';
import 'package:clickcart/presentation/widgets/link_button.dart';
import 'package:clickcart/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  static const routeName = "order_detail";

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("New Order", style: TextStyle(
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if(state is UserLoadingState) {
                  return const CircularProgressIndicator();
                }

                if(state is UserLoggedInState) {
                  UserModel user = state.userModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const GapWidget(),
                      Container(
                        padding: EdgeInsets.all(25),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              [Text(
                                "${user.fullName}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                                const SizedBox(height: 10),
                                Text(
                                  "Email: ${user.email}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "Address: ${user.address}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "State : ${user.state}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                LinkButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, EditProfileScreen.routeName);
                                    },
                                    text: "Edit Profile"
                                ),
                        ],

                        ),
                      ),


                    ],
                  );
                }

                if(state is UserErrorState) {
                  return Text(state.message);
                }

                return const SizedBox();
              },
            ),

            const GapWidget(size: 10),

            Text("Items", style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),),
            const GapWidget(),

            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if(state is CartLoadingState && state.items.isEmpty) {
                  return const CircularProgressIndicator();
                }

                if(state is CartErrorState && state.items.isEmpty) {
                  return Text(state.message);
                }

                return CartListView(
                  items: state.items,
                  shrinkWrap: true,
                  noScroll: true,
                );
              },
            ),

            const GapWidget(size: 10),

            Text("Payment", style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),),
            const GapWidget(),

            Consumer<OrderDetailProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      RadioListTile(
                        value: "pay-on-delivery",
                        groupValue: provider.paymentMethod,
                        contentPadding: EdgeInsets.zero,
                        onChanged: provider.changePaymentMethod,
                        title: const Text("Pay on Delivery"),
                      ),
                      RadioListTile(
                        value: "pay-now",
                        groupValue: provider.paymentMethod,
                        contentPadding: EdgeInsets.zero,
                        onChanged: provider.changePaymentMethod,
                        title: const Text("Pay Now"),
                      ),
                    ],
                  );
              }
            ),

            const GapWidget(),

            PrimaryButton(
              onPressed: () async {
                OrderModel? newOrder = await BlocProvider.of<OrderCubit>(context).createOrder(
                  items: BlocProvider.of<CartCubit>(context).state.items,
                  paymentMethod: Provider.of<OrderDetailProvider>(context, listen: false).paymentMethod.toString(),
                );

                if(newOrder == null) return;

                if(newOrder.status == "payment-pending") {
                  await RazorPayServices.checkoutOrder(
                    newOrder,
                    onSuccess: (response) async {
                      newOrder.status = "order-placed";

                      bool success = await BlocProvider.of<OrderCubit>(context).updateOrder(
                        newOrder,
                        paymentId: response.paymentId,
                        signature: response.signature
                      );

                      if(!success) {
                        log("Can't update the order!");
                        return;
                      }

                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                    },
                    onFailure: (response) {
                      log("Payment Failed!");
                    }
                  );
                }

                if(newOrder.status == "order-placed") {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                }
              },
              text: "Place Order"
            ),

          ],
        )
      ),
    );
  }
}