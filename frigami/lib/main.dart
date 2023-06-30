import 'package:flutter/material.dart';
import 'package:frigami/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:frigami/utils/globals.dart';

import 'package:frigami/database/database.dart';
import 'package:frigami/repositories/databaseRepositories.dart';




Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  //This opens the database.

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build(); //assegno il nome del file del db
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);
  
  
  //Here, we run the app and we provide to the whole widget tree the instance 
  //of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { //Key method for building the Widget that must be implemented
    return 
    //MultiProvider(providers: [
      // ChangeNotifierProvider(create: context) => ...(), 
      //FutureProvider(
      //  initialData: null,
      //  create: (context) => _ProfileDataState()>,], // create specifies the Future object (pecifica la classe)
        
      //  child: 
        MaterialApp( 
          scaffoldMessengerKey: snackbarKey,

        theme: ThemeData(
          primarySwatch: Colors.green,
          ),
        home: LoginPage(),

      );
    //);
  }
}

