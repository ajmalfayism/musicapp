import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/databas/model_db.dart';
import 'package:flutter_application_1/homescreen.dart';
import 'package:flutter_application_1/playlist/playlist_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistAddSong extends StatefulWidget {
  const PlaylistAddSong({super.key, required this.playlist});
  final MusicWorld playlist;
  @override
  State<PlaylistAddSong> createState() => _PlaylistAddSongState();
}

class _PlaylistAddSongState extends State<PlaylistAddSong> {
  bool isPlaying = true;
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor:  Color.fromARGB(255, 39, 10, 90),
      appBar: AppBar(
        title: const Text("Add songs"),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
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
          if (item.data!.isEmpty) {
            return const Center(
              child: Text('No songs availble'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {

              return Padding(
                padding:
                    EdgeInsets.only(left: 3,right: 3, top: 10,bottom: 3),
                child: Container(
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(40),
                    color: Color.fromARGB(255, 132, 63, 252),
                    // image: const DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage(''),
                    // ),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Color.fromARGB(255, 39, 10, 90).withOpacity(1),
                    //       spreadRadius: 1,
                    //       blurRadius: 8),
                    // ],
                  ),
                  // color: const Color.fromARGB(255, 248, 247, 247),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 50,
                      artworkHeight: 50,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(6),
                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.music_note,
                          color:  Colors.white
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    title: Text(item.data![index].displayNameWOExt,
                        maxLines: 1, style: title),
                    subtitle: Text(
                      item.data![index].artist.toString(),
                      maxLines: 1,
                      style: artistStyle,
                    ),
                    trailing: SizedBox(
                      height: 60,
                      width: 60,
                      child: Container(
                        child: !widget.playlist.isValueIn(item.data![index].id)
                            ? IconButton(
                                onPressed: () {
                                  GetAllSongController.songscopy = item.data!;
                                  setState(
                                    () {

                                      PlaylistDb.playlistNotifier.addListener(() { });


                                      
                                      
                                      songAddToPlaylist(
                                       item.data![index],
                                       );
                                      PlaylistDb.playlistNotifier
                                          .notifyListeners();
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color:  Colors.white
                                      .withOpacity(0.5),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      songDeleteFromPlaylist(item.data![index]);
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }

  void songAddToPlaylist(SongModel data) {
    widget.playlist.add(data.id);
    final addedToPlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 24, 199, 36),
      content: const Text(
        'Song added to playlist',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(addedToPlaylist);
  }

  void songDeleteFromPlaylist(SongModel data) {
    widget.playlist.deleteData(data.id);
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 188, 18, 18),
      content: const Text(
        'Song removed from Playlist',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }
}