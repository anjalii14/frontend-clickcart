import 'package:clickcart/logic/cubits/category_product_cubit/category_product_cubit.dart';
import 'package:clickcart/logic/cubits/category_product_cubit/category_product_state.dart';
import 'package:clickcart/presentation/widgets/product_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clickcart/core/ui.dart';
class CategoryProductScreen extends StatefulWidget {
  const CategoryProductScreen({super.key});

  static const routeName = "category_product";

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CategoryProductCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("${cubit.category.title}", style: TextStyle(
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
        child: BlocBuilder<CategoryProductCubit, CategoryProductState>(
          builder: (context, state) {

            if(state is CategoryProductLoadingState && state.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator()
              );
            }

            if(state is CategoryProductErrorState && state.products.isEmpty) {
              return Center(
                child: Text(state.message),
              );
            }

            if(state is CategoryProductLoadedState && state.products.isEmpty) {
              return const Center(
                child: Text("No products found!"),
              );
            }

            return ProductListView(products: state.products);

          },
        ),
      ),
    );
  }
}