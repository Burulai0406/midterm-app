import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../product_api.dart';

// Events
abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

// States
abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApiImpl api;

  ProductBloc(this.api) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await api.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
