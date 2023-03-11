import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/product_bloc.dart';
import 'ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp(
        title: 'GSMarena',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(title: 'GSMarena'),
      ),
    );
  }
}