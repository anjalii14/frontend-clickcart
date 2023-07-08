import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickcart/core/ui.dart';
import 'package:clickcart/logic/cubits/order_cubit/order_cubit.dart';
import 'package:clickcart/logic/cubits/order_cubit/order_state.dart';
import 'package:clickcart/logic/services/calculations.dart';
import 'package:clickcart/logic/services/formatter.dart';
import 'package:clickcart/presentation/widgets/gap_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  static const routeName = "my_orders";

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "MyOrders",
          style: TextStyle(
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
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState && state.orders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is OrderErrorState && state.orders.isEmpty) {
              return Center(child: Text(state.message));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    const GapWidget(),
                    Divider(color: AppColors.textLight),
                    const GapWidget(),
                  ],
                );
              },
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Id: ${order.sId}",
                        style: TextStyles.body2.copyWith(color: AppColors.textLight),
                      ),
                      Text(
                        Formatter.formatDate(order.createdOn!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                          // decoration: TextDecoration.underline,
                          decorationColor: AppColors.accent,
                          decorationThickness: 2,
                        ),
                      ),


                      Text(
                        "Order Total: ${Formatter.formatPrice(Calculations.cartTotal(order.items!))}",
                        style: TextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust the font size as needed
                        ),
                      ),

                      //
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: order.items!.length,
                        itemBuilder: (context, index) {
                          final item = order.items![index];
                          final product = item.product!;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CachedNetworkImage(
                              imageUrl: product.images![0],
                            ),
                            title: Text("${product.title}"),
                            subtitle: Text("Qty: ${item.quantity}"),
                            trailing: Text(Formatter.formatPrice(product.price! * item.quantity!)),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text("Status: ${order.status}"),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
