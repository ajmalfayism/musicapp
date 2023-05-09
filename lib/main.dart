

import 'package:flutter/material.dart';
import 'package:flutter_application_1/databas/model_db.dart';
import 'package:flutter_application_1/provide/song_model_provider.dart';
import 'package:flutter_application_1/splashscreen/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(MusicWorldAdapter().typeId)) {
    Hive.registerAdapter(MusicWorldAdapter());
  }
 await Hive.initFlutter();
 await Hive.openBox<int>('FavoriteDB');
 await Hive.openBox<MusicWorld>('playlistDb');
  runApp(
    ChangeNotifierProvider(create: (context) => SongModelProvider(),child: const MyApp(),),
  );
}

class MyApp extends StatelessWidget  {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       /// useMaterial3: true,
            fontFamily: GoogleFonts.inder().fontFamily,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 39, 10, 90)
        )
      ),
      
     home: SplashScreen(),
    );
  }
}


