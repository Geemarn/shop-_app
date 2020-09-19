import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/carts.dart';
import './screens/product_overview.dart';
import './screens/product_details.dart';
import './provider/products_provider.dart';
import './provider/order.dart';
import './screens/cart.dart';
import './screens/orders.dart' as OrderScreen;
import './screens/user_product.dart';
import './screens/product_edit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.limeAccent,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverview(),
        routes: {
          ProductDetails.routeName: (_) => ProductDetails(),
          Cart.routeName: (_) => Cart(),
          OrderScreen.Order.routeName: (_) => OrderScreen.Order(),
          UserProduct.routeName: (_) => UserProduct(),
          EditProduct.routeName: (_) => EditProduct(),
        },
      ),
    );
  }
}
