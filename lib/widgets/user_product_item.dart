import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_edit.dart';
import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    final _theme = Theme.of(context);

    final productProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await productProvider.deleteProduct(id);
                  _scaffold.hideCurrentSnackBar();
                  _scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Prouct delete successful',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } catch (error) {
                  _scaffold.hideCurrentSnackBar();
                  _scaffold.showSnackBar(
                    SnackBar(
                      backgroundColor: _theme.errorColor,
                      content: Text(
                        'An error occured: ${error.toString()}',
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
