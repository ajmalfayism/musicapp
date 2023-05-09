import 'package:flutter/material.dart';
import 'package:flutter_application_1/homescreen.dart';
import 'package:flutter_application_1/playlist/playlist_add_song.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controll/get_all_song_controll.dart';
import '../databas/model_db.dart';
import '../nowplaying/nowplaying.dart';
import '../provide/song_model_provider.dart';


class SinglePlaylist extends StatelessWidget {
  const SinglePlaylist({
    super.key,
    required this.playlist,
    required this.findex,
    this.String,
  });
  final MusicWorld playlist;
  final int findex;
  final String;

  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist;
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicWorld>('playlistDb').listenable(),
      builder: (BuildContext context, Box<MusicWorld> music, Widget? child) {
        songPlaylist = listPlaylist(music.values.toList()[findex].songId);
        return Scaffold(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor:const Color.fromARGB(255, 37, 5, 92),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
//pop button
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
// Add song
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistAddSong(
                            playlist: playlist,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
//Title
                  title: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  expandedTitleScale: 2.9,
                  background: Image.asset(
                    String,
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 37, 5, 92),
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width * 2.5 / 4,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    songPlaylist.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistAddSong(
                                            playlist: playlist,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.add_box,
                                      size: 50,
                                      color: Colors.white,
                                    )),
                                const Center(
                                    child: Text(
                                  'Add Songs To Your playlist',
                                  style: TextStyle(fontSize: 20,color:Colors.white),
                                  
                                )),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                   left: 3,right: 3,top: 10 ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    
                                    color: Color.fromARGB(255, 132, 63, 252),
                                    // image: const DecorationImage(
                                    //   fit: BoxFit.cover,
                                    //   image: AssetImage(
                                    //       ''),
                                    // ),
                                    
                                  ),
                                  
                                  child: ListTile(
                                    leading: QueryArtworkWidget(
                                      id: songPlaylist[index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkWidth: 50,
                                      artworkHeight: 50,
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(6),
                                      nullArtworkWidget: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color:
                                               Colors.white
                                                  .withOpacity(0.3),
                                        ),
                                        height: 50,
                                        width: 50,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                        songPlaylist[index].displayNameWOExt,
                                        maxLines: 1,
                                        style: title),
                                    subtitle: Text(
                                      songPlaylist[index].artist.toString(),
                                      maxLines: 1,
                                      style: artistStyle,
                                    ),
                                    trailing: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color:
                                               Colors.white
                                                  .withOpacity(1.0),
                                        ),
                                        onPressed: () {
                                          songDeleteFromPlaylist(
                                              songPlaylist[index], context);
                                        },
                                      ),
                                    ),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(songPlaylist),
                                              initialIndex: index);
                                      // GetRecentSongController.addRecentlyPlayed(
                                      //     songPlaylist[index].id);
                                      context
                                          .read<SongModelProvider>()
                                          .setid(songPlaylist[index].id);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NowPlaying(
                                            songModel: songPlaylist,
                                            count: songPlaylist.length,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            itemCount: songPlaylist.length,
                          )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void songDeleteFromPlaylist(SongModel data,context) {
    playlist.deleteData(data.id);
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 208, 11, 11),
      content: const Center(
        child: Text(
          'Song removed from Playlist',
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
