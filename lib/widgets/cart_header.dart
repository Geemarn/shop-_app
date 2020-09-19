import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts.dart';
import '../provider/order.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({
    Key key,
    @required this.carts,
  }) : super(key: key);

  final CartsProvider carts;

  void _snackBar(BuildContext context, String text, int time, String color) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        backgroundColor:
            color != 'errorColor' ? null : Theme.of(context).errorColor,
        duration: Duration(seconds: time),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(40),
                color: Colors.white30,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      ' \$${carts.totalAmt.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                if (carts.totalAmt != 0) {
                  Provider.of<OrderProvider>(
                    context,
                    listen: false,
                  ).addOrder(
                    carts.items.values.toList(),
                    carts.totalAmt,
                  );
                  carts.clearCart();
                  _snackBar(context, 'Order has been placed', 5, null);
                } else {
                  _snackBar(context, 'No cart item to order', 3, 'errorColor');
                }
              },
              child: Text(
                "PLACE ORDER",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                    )
                  ],
                ),
              ),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
