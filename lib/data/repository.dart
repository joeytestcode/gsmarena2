import 'dart:async';

import 'package:gsmarena2/data/gsmarena.dart';

import 'database_manager.dart';
import 'product.dart';

class Repository {
  static final _repo = Repository._internal();
  late final Future<List<Product>> list;

  final StreamController _streamController = StreamController<List<Product>>();
  Stream get filteredStream => _streamController.stream;

  factory Repository() {
    return _repo;
  }

  Repository._internal() {
    list = DatabaseManager().getAll();
  }

  Future<void> updateLatestModels() async {
    // synchronize the db and list
    (await list).clear();
    (await list).addAll(await DatabaseManager().getAll());

    GSMarena.updateLatestModels(List.from(await list)).listen((item) async {
      await _addItem(item);
    });
  }

  Future<void> fetchAllModels() async {
    // synchronize the db and list
    (await list).clear();
    (await list).addAll(await DatabaseManager().getAll());

    GSMarena.getAll(await list).listen((item) async {
      await _addItem(item);
    });
  }

  Future<void> _addItem(Product item) async {
    if (!(await list).contains(item)) {
      (await list).insert(0, item);
      await DatabaseManager().insert(item);
      _streamController.add(await list);
    } else {
      int index = (await list).indexOf(item);
      (await list)[index] = item;
      await DatabaseManager().update(item);
    }
  }

  Future<void> clearAllModels() async {
    await DatabaseManager().removeAll();
    (await list).clear();
    _streamController.add(await list);
  }

  Future<void> removeSelectedModels(List<Product> selectedList) async {
    for (var element in selectedList) {
      await DatabaseManager().remove(element);
      (await list).remove(element);
      _streamController.add(await list);
    }
  }
}
