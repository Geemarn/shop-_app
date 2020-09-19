import 'package:flutter/material.dart';
import 'package:shop_app/provider/carts.dart';
import '../widgets/drawer.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import './cart.dart';
import '../provider/products_provider.dart';

enum FilterOptions { Favourite, All }

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showFavourite = false;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartprint = Provider.of<CartsProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Cart'),
        actions: <Widget>[
          Consumer<CartsProvider>(
            builder: (context, cart, child) => Badge(
              child: child,
              title: cart.itemCount.toString(),
              txtColor: Colors.black,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Cart.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.Favourite) {
                  _showFavourite = true;
                } else {
                  _showFavourite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only favourites"),
                value: FilterOptions.Favourite,
              ),
              PopupMenuItem(
                child: Text("Show all"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : ProductGrid(_showFavourite),
    );
  }
}
