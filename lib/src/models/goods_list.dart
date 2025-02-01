import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:inventario/src/models/good.dart';

class GoodsList extends ChangeNotifier {
  final List<Good> _goods = [];

  UnmodifiableListView<Good> get goods => UnmodifiableListView(_goods);

  int get goodsCuantity => _goods.length;

  void add(Good good) {
    _goods.add(good);

    notifyListeners();
  }
}