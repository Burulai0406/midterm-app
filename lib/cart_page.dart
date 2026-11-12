import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cart['items'].isEmpty)
              return const Center(child: Text('Cart is empty'));
            return ListView(
              children: state.cart['items'].map<Widget>((item) {
                return ListTile(
                  title: Text(item['product']['title']),
                  subtitle: Text(
                    'Qty: ${item['quantity']} | \$${item['total']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<CartBloc>().add(
                      RemoveFromCart(item['product']['id']),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
