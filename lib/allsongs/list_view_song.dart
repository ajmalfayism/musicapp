import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/controll/mostly_played.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/databas/recentDb.dart';
import 'package:flutter_application_1/nowplaying/nowplaying.dart';
import 'package:flutter_application_1/playlist/playlistdialouge.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../homescreen.dart';



class ListViewScreen extends StatelessWidget {
  ListViewScreen(
      {super.key,
      required this.songModel,
      this.recentLength,
      this.isRecent = false,
      this.isMostly = false});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;
  final bool isMostly;

  List<SongModel> allSongs = [];
  @override
  Widget build(BuildContext context) {
    return
     ListView.builder(
      itemBuilder: (context, index) {
        allSongs.addAll(songModel);
        return Padding(
          padding:  EdgeInsets.only(left: 3,right: 3,top:10 ),
          child: Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color.fromARGB(255, 132, 63, 252),
              // image: const DecorationImage(
              //   fit: BoxFit.cover,
              //   image: AssetImage(''),
              // ),
            //   boxShadow: const [
            //     BoxShadow(
            //         // color: Colors.white.withOpacity(1),
            //         spreadRadius: 1,
            //         blurRadius: 8),
            //   ],
             ),
            child: ListTile(
              leading: QueryArtworkWidget(
                id: songModel[index].id,
                type: ArtworkType.AUDIO,
                artworkWidth: 50,
                artworkHeight: 50,
                keepOldArtwork: true,
               
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        const Color.fromARGB(255, 240, 121, 0).withOpacity(0.3),
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.music_note,
                    color:
                        const Color.fromARGB(255, 240, 121, 0).withOpacity(0.6),
                  ),
                ),
              ),
              title: Text(
                songModel[index].displayNameWOExt,
                style: title,
                maxLines: 1,
              ),
              subtitle: Text(
                songModel[index].artist.toString(),
                style: artistStyle,
                maxLines: 1,
              ),
              trailing: Wrap(
                children: [
                 
                  IconButton(
                    onPressed: () {
                           showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        color:const Color.fromARGB(255, 132, 63, 252),
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
                                                songModel[index])) {
                                          
                                              FavoriteDb.delete(
                                                songModel[index].id);
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
                                              FavoriteDb.add(songModel[index]);
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
                                                  songModel[index])
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
                                                context, songModel[index]);
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
                    icon: const Icon(Icons.more_vert),
                    color: Colors.white,
                  ),
                ],
              ),
              onTap: () {
                GetAllSongController.audioPlayer.setAudioSource(
                  GetAllSongController.createSongList(songModel),
                  initialIndex: index,
                );
                   GetMostlyPlayedController.addMostlyPlayed(
                                songModel [index].id);
                              
                                     GetMostlyPlayedController.addMostlyPlayed(
                                      songModel[index].id);
                                    GetRecentlyPlayed.addRecentlyPlayed(
                                    songModel[index].id);
                                  GetAllSongController.audioPlayer
                                      .setAudioSource(
                                    GetAllSongController.createSongList(
                                      songModel),
                                    initialIndex: index,
                                  );
           
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      songModel: songModel,
                      // audioPlayer: _audioPlayer,
                      count: songModel.length,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      itemCount: isRecent || isRecent ? recentLength : songModel.length,
    );
  }
}