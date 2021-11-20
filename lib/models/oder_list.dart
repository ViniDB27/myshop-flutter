import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/oder.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  String _token;
  String _userId;
  List<Order> _items = [];
  final _url =
      'https://flutter-curso-a235c-default-rtdb.firebaseio.com/orders';

  List<Order> get items {
    return [..._items];
  }

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get ItemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(Uri.parse('$_url/${_userId}.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.insert(
        0,
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });
    this._items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('$_url/${_userId}.json?auth=$_token'),
      body: jsonEncode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values
            .map(
              (cartItem) => {
                "id": cartItem.id,
                "name": cartItem.name,
                "price": cartItem.price,
                "productId": cartItem.productId,
                "quantity": cartItem.quantity,
              },
            )
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: jsonDecode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
