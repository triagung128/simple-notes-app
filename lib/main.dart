import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db_provider.dart';
import 'note_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DbProvider(),
      child: MaterialApp(
        title: 'Simple Note App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const NoteListPage(),
      ),
    );
  }
}
