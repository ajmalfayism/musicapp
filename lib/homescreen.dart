import 'package:flutter/material.dart';
import 'package:flutter_application_1/Section/search.dart';
import 'package:flutter_application_1/Settings_page/settings.dart';
import 'package:flutter_application_1/allsongs/allsongs.dart';
import 'package:flutter_application_1/allsongs/mini_playlist.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/databas/recentDb.dart';
import 'package:flutter_application_1/mostly_played/mostly_played.dart';
import 'package:flutter_application_1/playlist/playlist.dart';
import 'package:flutter_application_1/recently/recently_played.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Section/favourites.dart';


BoxDecoration bodyDecoration = const BoxDecoration(color: Colors.white);

const TextStyle title = TextStyle(
    color: Color.fromARGB(255, 253, 251, 251),
    fontWeight: FontWeight.bold,
    fontSize: 16);
const TextStyle artistStyle =
    TextStyle(color: Color.fromARGB(180, 252, 248, 248), fontSize: 14);


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: DefaultTabController(
        length: 5,
        child: Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: const [
                Tab(text: 'Tracks'),
                Tab(text: 'Recently Played'),
                Tab(text: 'Mosltly Played'),
                Tab(text: 'Favourites'),
                Tab(text: 'Playlist'),
              
              ],
              // indicatorColor: Colors.black,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(0.3),
              ),
              isScrollable: true,
            ),
            title: const Text(
              'A j Music',
              style: TextStyle(fontSize: 25,),
            ),
            // centerTitle: true,
            // leading: IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.menu),
            // ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  SearchScreen(
                          
                        ),
                      ));
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingsScreen())),
               icon: const Icon(Icons.settings,color: Colors.white,))
            ],
            elevation: 0,
          ),
          body:   Stack(
            children: [
        const      TabBarView(
                children: [
                  Allsongs(),
             RecentlyPlayed(),
                  MostlyPlayed(),
                  Favourites(),
                  PlaylistPage(),
                ],
              ),
          
           
             ValueListenableBuilder(
               valueListenable: GetRecentlyPlayed.recentSongNotifier,
               builder: (context, List<SongModel>value, Widget ?child ) {
            if (value.isEmpty
            &&
            GetAllSongController.audioPlayer.currentIndex!=null){
              return MiniPlayer();

            }else{
              return Container();
            }
               }
             )
            ],
         
          ),
        ),
      ),
    );
  }
}
