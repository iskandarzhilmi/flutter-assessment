import 'package:flutter/material.dart';
import 'package:flutter_assessment/views/edit_screen/bloc/edit_contact_bloc.dart';
import 'package:flutter_assessment/views/home_screen/bloc/contact_refresh_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/home_screen/views/home_screen.dart';
import 'helpers/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactRefreshBloc(),
        ),
        BlocProvider(
          create: (context) => EditContactBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
        },
      ),
    );
  }
}
