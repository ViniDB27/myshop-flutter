import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem certeza'),
            content: Text('Quer remover ${cartItem.name}?'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop(false);
                },
                child: Text('Não'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Sim'),
              )
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removerItem(cartItem.productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('${cartItem.price.toStringAsFixed(2)}'),
                  ),
                ),
              ),
              title: Text(cartItem.name),
              subtitle: Text(
                  'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
              trailing: Text('${cartItem.quantity}x')),
        ),
      ),
    );
  }
}
