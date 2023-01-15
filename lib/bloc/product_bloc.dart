import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gsmarena2/data/repository.dart';

import '../data/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final repo = Repository();
  StreamSubscription? _streamSubscription;

  ProductBloc() : super(StateInit()) {
    on<EventStart>((event, emit) async {
      _streamSubscription ??= repo.filteredStream.listen((data) {
        add(EventUpdated(list: data));
      });
      emit(StateUpdated(list: await repo.list));
    });

    on<EventUpdateLatest>((event, emit) async {
      _streamSubscription ??= repo.filteredStream.listen((data) {
        add(EventUpdated(list: data));
      });
      await repo.updateLatestModels();
    });

    on<EventGetAll>((event, emit) async {
      _streamSubscription ??= repo.filteredStream.listen((data) {
        add(EventUpdated(list: data));
      });
      await repo.fetchAllModels();
    });

    on<EventClearAll>((event, emit) async {
      _streamSubscription ??= repo.filteredStream.listen((data) {
        add(EventUpdated(list: data));
      });
      await repo.clearAllModels();
    });

    on<EventRemoveSelected>((event, emit) async {
      _streamSubscription ??= repo.filteredStream.listen((data) {
        add(EventUpdated(list: data));
      });
      await repo.removeSelectedModels(event.list);
    });

    on<EventUpdated>((event, emit) {
      emit(StateUpdated(list: event.list));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
