import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart';
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class Order extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, i) => OrderItem(
          orderData.orders[i],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
