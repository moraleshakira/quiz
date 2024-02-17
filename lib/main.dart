import 'package:flutter/material.dart';
import 'demo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AcadNote());
}

class AcadNote extends StatefulWidget {
  const AcadNote({super.key});

  // This widget is the root of your application.

  @override
  _AcadNoteState createState() => _AcadNoteState();
}

class _AcadNoteState extends State<AcadNote> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //create a new class for this
      home: FormScreen(),
    );
  }
}