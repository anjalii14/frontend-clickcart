import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickcart/data/models/cart/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../logic/cubits/cart_cubit/cart_cubit.dart';
import '../../logic/services/formatter.dart';
import 'link_button.dart';

class CartListView extends StatelessWidget {
  final List<CartItemModel> items;
  final bool shrinkWrap;
  final bool noScroll;

  const CartListView({super.key, required this.items, this.shrinkWrap = false, this.noScroll = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: (noScroll) ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {

        final item = items[index];
        return Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),

            boxShadow: [ BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
            ),],
            ),
            margin: EdgeInsets.all(10),
            child: ListTile(
            leading: CachedNetworkImage(
            width: 50,
            imageUrl: item.product!.images![0],
            ),
            title: Text(
            "${item.product?.title}",
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            ),
            ),
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            "${Formatter.formatPrice(item.product!.price!)} x ${item.quantity} = ${Formatter.formatPrice(item.product!.price! * item.quantity!)}",
            style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            ),
            ),
            SizedBox(height: 8),
            LinkButton(
            onPressed: () {
            BlocProvider.of<CartCubit>(context).removeFromCart(item.product!);
            },
            text: "Delete",
            color: Colors.red,
            ),
            ],
            ),
            trailing: InputQty(
            maxVal: 99,
            initVal: item.quantity!!,
            minVal: 1,
            showMessageLimit: false,
            onQtyChanged: (value) {
            if (value == item.quantity) return;
            BlocProvider.of<CartCubit>(context).addToCart(item.product!, value as int);
            },
            ),
            ),
            );
            },
            );
            }
            }