import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:test_app/cubit/fetchcubit/fetch_data_cubit.dart';
import 'package:test_app/models/finance_model.dart';
import 'package:test_app/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(FinanceModelAdapter());
  await Hive.openBox<FinanceModel>("financeBox");
  await Hive.openBox("darkModeBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchDataCubit(),
      child: ValueListenableBuilder(
        valueListenable: Hive.box("darkModeBox").listenable(),
        builder: (context, box, child) {
          var darkMode = box.get('darkMode', defaultValue: false);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Finance',
            themeMode: darkMode ? ThemeMode.light : ThemeMode.dark,

            darkTheme: ThemeData.dark(),

            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
