import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  void _isFavListener(bool isFav) {
    isFavourite = isFav;
    notifyListeners();
  }

  Future<void> toggleFavourite() async {
    final initialStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-firebase-20fa6.firebaseio.com/product/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavourite': isFavourite},
        ),
      );
      if (response.statusCode >= 400) {
        _isFavListener(initialStatus);
      }
    } catch (error) {
      _isFavListener(initialStatus);
    }
  }
}
