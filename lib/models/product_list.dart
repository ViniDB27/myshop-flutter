import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/errors/http_errors.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  String _token;
  String _userId;
  List<Product> _items = [];
  final _url =
      'https://flutter-curso-a235c-default-rtdb.firebaseio.com/products';

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get ItemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse(_url + '.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        'https://flutter-curso-a235c-default-rtdb.firebaseio.com/userFavorite/${_userId}.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite));
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_url + '.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": product.name,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    print(jsonDecode(response.body));
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_url/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      final response =
          await http.delete(Uri.parse("$_url/${product.id}.json?auth=$_token"));
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        throw HttpErrors(
          message: 'Erro ao excluir o item ${product.name}',
          statusCode: response.statusCode,
        );
      }

      notifyListeners();
    }
  }
}
