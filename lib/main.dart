import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_nosql/home_screen.dart';
import 'package:hive_nosql/models/notes_model.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}




// Permissions:
//  <uses-permission
//         android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
//     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
//     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

// flutter packages pub run build_runner build
