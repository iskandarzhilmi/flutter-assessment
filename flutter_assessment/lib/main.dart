import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/modules/home_screen/bloc/contact_listing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/home_screen/views/home_screen.dart';
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
          create: (context) => ContactListingBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
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
