import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sample/HomePage.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('b1');
  await Hive.openBox('b2');
  runApp(const MaterialApp(
    home: Home(),
  ));
}

 
