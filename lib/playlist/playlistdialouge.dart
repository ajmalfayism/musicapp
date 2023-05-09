import 'package:flutter/material.dart';
import 'package:flutter_application_1/databas/model_db.dart';
import 'package:flutter_application_1/playlist/playlist.dart';
import 'package:flutter_application_1/playlist/playlist_db.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:on_audio_query/on_audio_query.dart';

playlistDialogue(BuildContext context, SongModel songModel) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Color.fromARGB(255, 39, 10, 90),
          title: const Text(
            'Select a Playlist',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white
              
            ),
          ),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<MusicWorld>('playlistDb').listenable(),
                builder: (context, Box<MusicWorld> musicList, child) {
                  return Hive.box<MusicWorld>('playlistDb').isEmpty
                      ? const Center(
                          child: Text(
                          'No Playlist found',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ))
                      : ListView.builder(
                          itemCount: musicList.length,
                          itemBuilder: (context, index) {
                            final data = musicList.values.toList()[index];
                            return Card(
                              color: Color.fromARGB(255, 132, 63, 252),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(data.name,style: TextStyle(color: Colors.white),),
                                trailing: const Icon(Icons.playlist_add,
                                    color: Colors.white),
                                onTap: () {
                                  addSongToPlaylist(
                                      context, songModel, data, data.name);
                                },
                              ),
                            );
                          });
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                PlaylistDb.playlistNotifier.notifyListeners();

                /// Navigator.pop(context);
                newplaylist(context, formKey);
     
              },
              child: const Text('New Playlist',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      });
}

void addSongToPlaylist(
    BuildContext context, SongModel data, datas, String name) {
  if (!datas.isValueIn(data.id)) {
    datas.add(data.id);
    final songAddSnackBar = SnackBar(
      backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed, //idhonn check akknm
        content: Text(
          "Song Added To $name",
          textAlign: TextAlign.center,
          
        ));
    ScaffoldMessenger.of(context).showSnackBar(songAddSnackBar);
    Navigator.pop(context);
  } else {
    final songAlreadyExist = SnackBar(
      backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed, //idhonn check akknm
        content: Text(
          "Song Already exist In $name",
          textAlign: TextAlign.center,
        ));
    ScaffoldMessenger.of(context).showSnackBar(songAlreadyExist);
    Navigator.pop(context);
  }
}