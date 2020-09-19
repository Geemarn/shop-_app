import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;
  ProductGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProductsProvider>(context);
    final productsData = showFav ? data.favouriteItems : data.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: productsData[i],
        // create: (c) => productsData[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: productsData.length,
    );
  }
}
