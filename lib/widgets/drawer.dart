import 'package:flutter/material.dart';
import '../screens/orders.dart';
import '../screens/user_product.dart';

class AppDrawer extends StatelessWidget {
  Widget _listTile(
      BuildContext context, String title, IconData icon, String routeName) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              routeName,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Something here"),
            automaticallyImplyLeading: false,
          ),
          _listTile(
            context,
            "Shop",
            Icons.shop,
            '/',
          ),
          _listTile(
            context,
            "Orders",
            Icons.payment,
            Order.routeName,
          ),
          _listTile(
            context,
            "Manage Product",
            Icons.edit,
            UserProduct.routeName,
          ),
        ],
      ),
    );
  }
}
