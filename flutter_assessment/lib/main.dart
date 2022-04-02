import 'package:flutter/material.dart';
import 'views/home_screen/home_screen.dart';
import 'package:flutter_assessment/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHandler().initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: const Color(0xFFEBF8F6),
        // ),
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
