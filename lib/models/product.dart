import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  final _url =
      'https://flutter-curso-a235c-default-rtdb.firebaseio.com/products';

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
    await http.patch(
      Uri.parse('$_url/${this.id}.json'),
      body: jsonEncode({"isFavorite": isFavorite}),
    );
  }
}
