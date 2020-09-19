import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../provider/products_provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  bool _showPreview = false;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  var _addProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _initialValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    if (_addProduct.id.isNotEmpty) {
      await productProvider.editProduct(_addProduct.id, _addProduct);
    } else {
      try {
        await productProvider.addProduct(_addProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "An error occured",
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            content: Text("Something went wrong..."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _addProduct = Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).findById(productId);

        _initialValues = {
          'title': _addProduct.title,
          'price': _addProduct.price.toString(),
          'description': _addProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _addProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              margin: const EdgeInsets.only(top: 10),
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 5,
                child: Form(
                  key: _form,
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        initialValue: _initialValues['title'],
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _addProduct = Product(
                            id: _addProduct.id,
                            isFavourite: _addProduct.isFavourite,
                            title: value,
                            price: _addProduct.price,
                            description: _addProduct.description,
                            imageUrl: _addProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        initialValue: _initialValues['price'],
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a number greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _addProduct = Product(
                            id: _addProduct.id,
                            isFavourite: _addProduct.isFavourite,
                            title: _addProduct.title,
                            price: double.parse(value),
                            description: _addProduct.description,
                            imageUrl: _addProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        initialValue: _initialValues['description'],
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter description';
                          }
                          if (value.length < 10) {
                            return 'description should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _addProduct = Product(
                            id: _addProduct.id,
                            isFavourite: _addProduct.isFavourite,
                            title: _addProduct.title,
                            price: _addProduct.price,
                            description: value,
                            imageUrl: _addProduct.imageUrl,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          if (_showPreview)
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   width: 1,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                  ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text(
                                      'No preview',
                                      textAlign: TextAlign.center,
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter image url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter a valid url';
                                }
                                // if (!value.endsWith('.png') &&
                                //     !value.endsWith('.jpg') &&
                                //     !value.endsWith('.jpeg')) {
                                //   return 'please enter png, jpg or jpeg format';
                                // }
                                return null;
                              },
                              onSaved: (value) {
                                _addProduct = Product(
                                  id: _addProduct.id,
                                  isFavourite: _addProduct.isFavourite,
                                  title: _addProduct.title,
                                  price: _addProduct.price,
                                  description: _addProduct.description,
                                  imageUrl: value,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          child: Text(
                            _showPreview ? "Hide preview" : "Preview",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: () {
                            if (_imageUrlController.text.isNotEmpty) {
                              setState(() {
                                _showPreview = !_showPreview;
                                ;
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
