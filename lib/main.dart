import 'package:contacts/contact_model.dart';
import 'package:contacts/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  await Hive.openBox<Contact>('contact-box');
  runApp(
    ListenableProvider(
      create: (context) {
        print('Rebuid RunApp');
        return HiveService();
      },
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    print('Rebuid myApp');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactsScreen(),
    );
  }
}
