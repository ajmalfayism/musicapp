
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/databas/recentDb.dart';
import 'package:flutter_application_1/nowplaying/nowplaying.dart';
import 'package:flutter_application_1/playlist/playlistdialouge.dart';


import 'package:on_audio_query/on_audio_query.dart';

// ignore: camel_case_types, use_key_in_widget_constructors
class recently_Libary extends StatefulWidget {
  @override
  State<recently_Libary> createState() => _recently_LibaryState();
}

class _recently_LibaryState extends State<recently_Libary> {
  List<SongModel> recent = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future initialize() async {
    await GetRecentlyPlayed.getRecentlySongs();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaquery = MediaQuery.of(context).size;
    return FutureBuilder(
        future: GetRecentlyPlayed.getRecentlySongs(),
        builder: (context, item) {
          return ValueListenableBuilder(
              valueListenable: GetRecentlyPlayed.recentSongNotifier,
              builder: (context, value, child) {
                if (value.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 130, left: 30),
                    child: Column(
                      children: [
                        Container(
                        
                        ),
                        const Text(
                          "Your Recent Is Empty",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(147, 255, 255, 255)),
                        ),
                      ],
                    ),
                  );
                } else {
                  final temp = value.toList();
                  recent = temp.toSet().toList();

                  return FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                          sortType: null,
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL,
                          ignoreCase: true),
                      builder: (context, item) {
                        if (item.data == null) {
                          const CircularProgressIndicator();
                        } else if (item.data!.isEmpty) {
                          return const Center(
                            child: Text('No songs in your internal'),
                          );
                        }
                        return Container(
                          height: _mediaquery.height * 0.88,
                          width: _mediaquery.width,
                          // decoration: const BoxDecoration(
                          //     image: DecorationImage(
                          //         image: AssetImage(""),
                          //         fit: BoxFit.cover)),
                          child: ListView.separated(
                              itemBuilder: ((context, index) {
                                return Container(
                                  child: ListTile(
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                        GetAllSongController.createSongList(
                                            recent),
                                        initialIndex: index,
                                      );
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                 return NowPlaying(
                                            songModel: recent,
                                            count: recent.length,
                                          );
                                 }));
                                    },
                                    leading: Text(
                                      "${index + 1}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                         showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.black,
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
                                                item.data![index])) {
                                          
                                              FavoriteDb.delete(
                                                  item.data![index].id);
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
                                              FavoriteDb.add(item.data![index]);
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
                                                  item.data![index])
                                              ? const Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                ),
                                          label: const Text("Favourite")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            playlistDialogue(
                                                context, item.data![index]);
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
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      recent[index].displayNameWOExt,
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text("${recent[index].artist}",
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                );
                              }),
                              separatorBuilder: ((context, index) {
                                return const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                );
                              }),
                              itemCount: recent.length),
                        );
                      });
                }
              });
        });
  }
}