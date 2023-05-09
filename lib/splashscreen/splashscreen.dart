import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/allsongs/allsongs.dart';
import 'package:flutter_application_1/homescreen.dart';



class SplashScreen extends StatefulWidget {
  dynamic  colorsize = [
     Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,

  ];
 SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(
      Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
    );
  }
    @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 5, 92),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 300,),



            // Container(
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),border: Border.all(width: 2,color: Colors.white)),
            //   height: 100,
            //   width: 100,
            //   child: Image.asset("assets/images/output.png"),

            // ),
            Center(
              child: Text(" Music",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 29,color: Colors.white),),
            ),
          ],
        )
        ),
    );
  }
}
