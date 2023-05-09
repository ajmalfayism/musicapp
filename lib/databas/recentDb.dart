
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Allsongs/Allsongs.dart';
import 'package:hive_flutter/adapters.dart';


import 'package:on_audio_query/on_audio_query.dart';

class GetRecentlyPlayed {
  static ValueNotifier<List<SongModel>> recentSongNotifier = ValueNotifier([]);
  static List recentlyplayed = [];



  //////tap that time  song  add in the recently played list //////////////////
  static Future<void> addRecentlyPlayed(Songid) async {
    final recentDB = await Hive.openBox('recentSongNotifier');
    await recentDB.add(Songid);
    getRecentlySongs();
    recentSongNotifier.notifyListeners();
  }


//////managing mostly played songs /////////////////////////////////////
  static Future<void> getRecentlySongs() async {
    final recentDB = await Hive.openBox('recentSongNotifier');
     recentlyplayed = await recentDB.values.toList();
    displayRecentlySongs();
    recentSongNotifier.notifyListeners();
  }

  static Future<void> displayRecentlySongs() async {
    final recentDB = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDB.values.toList();
    recentSongNotifier.value.clear();
    recentlyplayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < startSong.length; j++) {
        if (recentSongItems[i] == startSong[j].id) {
          recentSongNotifier.value.add(startSong[j]);
          recentlyplayed.add(startSong[j]);
        }
      }
    }
  }
}