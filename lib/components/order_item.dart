import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/oder.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemHeight = (widget.order.products.length * 25.0) + 10;
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 250,
      ),
      height: _expanded ? itemHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('DD/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: _expanded ? itemHeight : 0,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: ListView(
                children: widget.order.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${product.quantity} x R\$${product.price}',
                          style: TextStyle(fontSize: 18, color: Colors.grey))
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
