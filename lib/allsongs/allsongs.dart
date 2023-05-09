// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/controll/mostly_played.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/databas/recentDb.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/nowplaying/nowplaying.dart';
import 'package:flutter_application_1/playlist/playlistdialouge.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provide/song_model_provider.dart';
List<SongModel> startSong = [];
void main() {
  runApp(const MyApp());
}

class Allsongs extends StatefulWidget {
  const Allsongs({super.key});

  @override
  State<Allsongs> createState() => _AllsongsState();
}

class _AllsongsState extends State<Allsongs> {
  final _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("Error parsing song");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    dynamic permission = await _audioQuery.permissionsStatus();
    if (!permission) {
      await _audioQuery.permissionsRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 5, 92),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item==null) {
            return const Center(child: Text("No Song Found"));
          }
          startSong= item.data!;





        
          return ListTileWidget(songmodel: item.data!);
        },
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
   ListTileWidget({
    super.key,required this.songmodel,
  });

  List<SongModel> songmodel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount:songmodel.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(left: 3,right: 3,top: 10),



        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),
        color: const Color.fromARGB(255, 132, 63, 252),),
        child: ListTile(
          title: Text(
            songmodel[index].displayNameWOExt,
            style: const TextStyle(color: Colors.white),overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          subtitle: Text(
            "${songmodel[index].artist}",
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 132, 63, 252),
                        child: ValueListenableBuilder(
                            valueListenable: FavoriteDb.favoriteSongs,
                            builder: (context,
                                List<SongModel> favoriteSongs,
                                Widget? child) {
                              return Column(
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            if (FavoriteDb.isFavor(
                                                songmodel[index])) {
                                          
                                              FavoriteDb.delete(
                                                  songmodel[index].id);
                                              // ignore: unused_local_variable
                                              var remove =
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          duration: Duration(
                                                              seconds: 3),
                                                          backgroundColor:
                                                              Colors.red,
                                                          content:
                                                              Text('Removed')));
      
                                              FavoriteDb.favoriteSongs
                                                  .notifyListeners();
                                                      Navigator.of(context).pop();
                                            } else {
                                              FavoriteDb.add(songmodel[index]);
                                              var ADD = ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(const SnackBar(
                                                      duration:
                                                          Duration(seconds: 3),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 0, 255, 13),
                                                      content: Text('SAVED')));
      
                                              Navigator.of(context).pop();
                                            }
                                            FavoriteDb.favoriteSongs
                                                .notifyListeners();
                                          },
                                          icon: FavoriteDb.isFavor(
                                                  songmodel[index])
                                              ? const Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                ),
                                          label: const Text("Favourite",style: TextStyle(color: Colors.white),)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            playlistDialogue(
                                                context, songmodel[index]);
                                          },
                                          icon: const Icon(
                                            Icons.playlist_add,
                                            size: 30,
                                            color: Colors.white,
                                          )
                                          ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        "Add to playlist",
                                        
                                        style: TextStyle(color: Colors.white),
                                        
                                      ),
                                    ],
                                  )
                                ]
                              );
                            }),
                      );
                    });
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
          leading: QueryArtworkWidget(
            id: songmodel[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
          onTap: () {
               GetMostlyPlayedController.addMostlyPlayed(
                                      songmodel[index].id);
            GetAllSongController.audioPlayer.setAudioSource(
              GetAllSongController.createSongList(songmodel),
              initialIndex: index,
            );
            context.read<SongModelProvider>().setid(songmodel[index].id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
               

                    GetRecentlyPlayed.addRecentlyPlayed(
                                     songmodel[index].id);
                  
                  
                  
                  return NowPlaying(
                  songModel: songmodel,
                  count: songmodel.length,
                
               ); }
              ),
            );
          },
        ),
      ),

      separatorBuilder: (context, index) => SizedBox(height: 5,),
    );
  }
}
