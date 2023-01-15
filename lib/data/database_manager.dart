import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';
import 'product.dart';

class DatabaseManager {
  static final _db = DatabaseManager._internal();
  late final Future<Box> _box;

  factory DatabaseManager() {
    return _db;
  }

  DatabaseManager._internal() {
    _box = create();
  }

  Future<Box> create() async {
    WidgetsFlutterBinding.ensureInitialized();
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/objectbox/data.mdb');

    if (!await file.exists()) {
      file.createSync(recursive: true);
      var data = await rootBundle.load('assets/data.mdb');
      file.writeAsBytesSync(data.buffer.asUint8List());
    }

    final box = (await openStore()).box<Product>();
    return box;
  }

  Future<List<Product>> getAll() async {
    final List<Product> currentList = (await _box).getAll() as List<Product>;
    return currentList.reversed.toList();
  }

  Future<void> insert(Product item) async {
    (await _box).put(item);
  }

  Future<void> update(Product item) async {
    (await _box).put(item, mode: PutMode.update);
  }

  Future<void> remove(Product item) async {
    (await _box).remove(item.id);
  }

  Future<void> removeAll() async {
    (await _box).removeAll();
  }

  Future<bool> containsItem(Product item) async {
    return (await _box).contains(item.id);
  }

  Future<bool> containsID(int id) async {
    return (await _box).contains(id);
  }

  Future<List<Product>> dbQuery(Condition condition) async {
    return (await _box).query(condition).build().find() as List<Product>;
  }
}
