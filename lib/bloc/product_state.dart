part of 'product_bloc.dart';

abstract class ProductState {
  const ProductState({required this.list});
  final List<Product> list;
}

class StateInit extends ProductState {
  StateInit() : super(list: []);
}

class StateUpdated extends ProductState {
  const StateUpdated({required List<Product> list}) : super(list: list);
}
