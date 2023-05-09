import 'package:flutter/material.dart';
import 'package:flutter_application_1/ALLCOLORS/All_Colors.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/nowplaying/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../databas/Favoritedb.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:const Color.fromARGB(255, 39, 10, 90) ,
      child: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder: (context, favoritedata, child) {
            return favoritedata.isEmpty
                ? const Center (child: Text("IS EMPTY ",style: TextStyle(color: Colors.white),))
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: All_colors,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 3,left: 3,top: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),
                               color: const Color.fromARGB(255, 132, 63, 252)
                               ),
                            
                            child: ListTile(
                              onTap: (){
                                List<SongModel> songlist = [...favoritedata];
                                    GetAllSongController.audioPlayer.setAudioSource(
                                        GetAllSongController.createSongList(
                                          songlist),
                                        initialIndex: index);
                                  
                              
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NowPlaying(songModel:songlist)));
                              },
                                 
                                title:  Text(
                                  favoritedata[index].displayNameWOExt,
                                  style: const TextStyle(color: Colors.white),
                                  overflow:TextOverflow.fade,
                                  maxLines: 1 ,
                                ),
                                subtitle: Text(
                                  "${favoritedata[index].artist}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    FavoriteDb.favoriteSongs.notifyListeners();
                                     FavoriteDb.delete(favoritedata[index].id);
                                  },
                                  icon: Icon(Icons.favorite),
                                  color: Colors.red,  
                                ),
                                leading: QueryArtworkWidget(
                                  id:favoritedata[index].id,
                                 type: ArtworkType.AUDIO, ),
                                ),
                                
                          );
                        
                        },
                        separatorBuilder:  (context, index) => const SizedBox(height: 5),
                        itemCount: favoritedata.length),
                  );
          }),
    );
  }
}
