import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/playlist/playlistdialouge.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';

class PlayingControls extends StatefulWidget {
  const PlayingControls({
    super.key,
    required this.count,
    required this.favSongModel,
    required this.lastSong,
    required this.firstSong,
  });

  final int count;
  final bool firstSong;
  final bool lastSong;
  final SongModel favSongModel;

  @override
  State<PlayingControls> createState() => _PlayingControlsState();
}

class _PlayingControlsState extends State<PlayingControls> {
  bool isPlaying = true;
  bool isShuffling = false;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          IconButton(onPressed: (){
                if (FavoriteDb.isFavor(widget.favSongModel)){
                    FavoriteDb.delete(widget.favSongModel.id);
                      var remove= ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              
                              duration: Duration(seconds: 3),
                              
                                backgroundColor: Color.fromARGB(255, 255, 13, 0), content: Text('REMOVED')));
                           
                               

                    
                  }else{
                    FavoriteDb.add(widget.favSongModel);
                      var ADD= ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              
                              duration: Duration(seconds: 3),
                              
                                backgroundColor: Color.fromARGB(255, 0, 255, 13), content: Text('SAVED')));
                           
                              


                  }
                  FavoriteDb.favoriteSongs.notifyListeners();
               

          },
       icon:FavoriteDb.isFavor(widget.favSongModel)? Icon(Icons.favorite,color: Color.fromARGB(255, 255, 1, 1),
        ):Icon(Icons.favorite,color: Color.fromARGB(255, 255, 255, 255),
        )),
              
          
            IconButton(
                onPressed: () {
                   playlistDialogue(context, widget.favSongModel);
              
                },
                icon: const Icon(
                  Icons.playlist_add,
                  size: 30,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                isShuffling == false
                    ? GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(true)
                    : GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(false);
              },
              icon: StreamBuilder<bool>(
                stream:
                    GetAllSongController.audioPlayer.shuffleModeEnabledStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    isShuffling = snapshot.data;
                  }
                  if (isShuffling) {
                    return const Icon(
                      Icons.shuffle,
                      size: 30,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(
                      Icons.shuffle,
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                GetAllSongController.audioPlayer.loopMode == LoopMode.one
                    ? GetAllSongController.audioPlayer.setLoopMode(LoopMode.all)
                    : GetAllSongController.audioPlayer
                        .setLoopMode(LoopMode.one);
              },
              icon: StreamBuilder<LoopMode>(
                stream: GetAllSongController.audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  final loopMode = snapshot.data;
                  if (LoopMode.one == loopMode) {
                    return const Icon(
                      Icons.repeat,
                      size: 30,
                      color: Color.fromARGB(255, 11, 11, 11),
                    );
                  } else {
                    return const Icon(
                      Icons.repeat,
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
// skip previous
            widget.firstSong
                ?const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white30,
                          size: 40,
                        ),)
                  
                : IconButton(
                  onPressed: () {
                    if (GetAllSongController.audioPlayer.hasPrevious) {
                      GetAllSongController.audioPlayer.seekToPrevious();
                    }
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Color.fromARGB(255, 250, 249, 249),
                    size: 40,
                  ),
                ),
// play pause
            IconButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      if (GetAllSongController.audioPlayer.playing) {
                        GetAllSongController.audioPlayer.pause();
                      } else {
                        GetAllSongController.audioPlayer.play();
                      }
                      isPlaying = !isPlaying;
                    });
                  }
                },
                icon: isPlaying
                    ? const Icon(
                        Icons.pause,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 40,
                      )
                    : const Icon(
                        Icons.play_arrow,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 40,
                      )),
// skip next
            widget.lastSong
                ? IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    
                  
                :  IconButton(
                        onPressed: () {
                          if (GetAllSongController.audioPlayer.hasNext) {
                            GetAllSongController.audioPlayer.seekToNext();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    
                  
          ],
        )
      ],
    );
  }
}