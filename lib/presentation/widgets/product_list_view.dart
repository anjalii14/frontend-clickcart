import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickcart/data/models/product/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/ui.dart';
import '../../logic/services/formatter.dart';
import '../screens/product/product_details_screen.dart';
import 'gap_widget.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({
    super.key,
    required this.products
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {

        final product = products[index];

        return CupertinoButton(
          onPressed: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product);
          },
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin:  EdgeInsets.all(MediaQuery.of(context).size.width / 60),
            child: Row(

              children: [
                GapWidget(size : MediaQuery.of(context).size.width / 200.5,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.width / 3.5,
                    imageUrl: "${product.images?[0]}",
                    // fit: BoxFit.cover,
                  ),
                ),


                Flexible(
                  child: Container(

                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 8),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "${product.title}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${product.description}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                           // fontFamily: 'Times New Roman',

                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const GapWidget(),
                        Text(
                          Formatter.formatPrice(product.price!),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
                        ),

                      ],
                    ),

                  ),
                ),
              // GapWidget()

                GapWidget(size : MediaQuery.of(context).size.width / 100.5,),
              ],
              // GapWidget(size : MediaQuery.of(context).size.width / 100.5,),
            ),

          ),
        );

      },
    );
  }
}