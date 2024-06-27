import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();


  await Supabase.initialize(
    url: "https://jdhsuxetjdzwdznipbvm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkaHN1eGV0amR6d2R6bmlwYnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg2OTE1NjMsImV4cCI6MjAzNDI2NzU2M30.kFeVsszukI3fEJw5Fk1olQ_VGW51EXG59Ml01u8WjDU",
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

