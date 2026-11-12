import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../product_api.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final int productId;
  AddToCart(this.productId);
  @override
  List<Object> get props => [productId];
}

class RemoveFromCart extends CartEvent {
  final int productId;
  RemoveFromCart(this.productId);
  @override
  List<Object> get props => [productId];
}

// States
abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final Map<String, dynamic> cart;
  CartLoaded(this.cart);
  int get totalItems =>
      cart['items'].fold(0, (sum, item) => sum + (item['quantity'] as int));
  @override
  List<Object> get props => [cart];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final ProductApiImpl api;
  CartBloc(this.api) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      final cart = await api.getCart();
      emit(CartLoaded(cart));
    });
    on<AddToCart>((event, emit) async {
      await api.addToCart(event.productId);
      add(LoadCart());
    });
    on<RemoveFromCart>((event, emit) async {
      await api.removeFromCart(event.productId);
      add(LoadCart());
    });
  }
}
